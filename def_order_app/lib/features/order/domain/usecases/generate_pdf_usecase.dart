import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';
import '../../data/services/pdf_service.dart';
import '../../data/services/storage_service.dart';
import '../../../../core/utils/logger.dart';

/// PDF 생성 파라미터
class GeneratePdfParams {
  final Order order;
  final bool uploadToStorage;
  
  const GeneratePdfParams({
    required this.order,
    this.uploadToStorage = true,
  });
}

/// PDF 생성 결과
class PdfGenerationResult {
  final Uint8List pdfData;
  final String? storageUrl;
  final String fileName;
  
  const PdfGenerationResult({
    required this.pdfData,
    this.storageUrl,
    required this.fileName,
  });
}

/// 거래명세서 PDF 생성 UseCase
class GeneratePdfUseCase implements UseCase<PdfGenerationResult, GeneratePdfParams> {
  final OrderRepository repository;
  final PdfService pdfService;
  final StorageService storageService;
  
  GeneratePdfUseCase({
    required this.repository,
    PdfService? pdfService,
    StorageService? storageService,
  })  : pdfService = pdfService ?? PdfService(),
        storageService = storageService ?? StorageService();

  @override
  Future<Either<Failure, PdfGenerationResult>> call(GeneratePdfParams params) async {
    try {
      logger.i('PDF 생성 시작: 주문번호 ${params.order.orderNumber}');
      
      // 1. PDF 생성
      final pdfData = await pdfService.generateTransactionStatement(params.order);
      final fileName = pdfService.generateFileName(params.order);
      
      logger.i('PDF 생성 완료: ${pdfData.length} bytes');
      
      // 2. Storage 업로드 (옵션)
      String? storageUrl;
      if (params.uploadToStorage) {
        try {
          storageUrl = await storageService.uploadPdf(
            pdfData: pdfData,
            fileName: fileName,
            userId: params.order.userId,
          );
          logger.i('Storage 업로드 완료: $storageUrl');
        } catch (e) {
          logger.e('Storage 업로드 실패 (PDF는 생성됨)', error: e);
          // Storage 업로드 실패해도 PDF는 반환
        }
      }
      
      return Right(PdfGenerationResult(
        pdfData: pdfData,
        storageUrl: storageUrl,
        fileName: fileName,
      ));
    } catch (e) {
      logger.e('PDF 생성 실패', error: e);
      return Left(ServerFailure('PDF 생성에 실패했습니다: ${e.toString()}'));
    }
  }
}