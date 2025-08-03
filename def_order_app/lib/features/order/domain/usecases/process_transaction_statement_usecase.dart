import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';
import 'generate_pdf_usecase.dart';
import 'send_email_usecase.dart';
import '../../../../core/utils/logger.dart';
import '../../data/models/order_model.dart';

/// 거래명세서 처리 파라미터
class ProcessTransactionStatementParams {
  final String orderId;
  final String? recipientEmail;
  final bool sendEmail;
  
  const ProcessTransactionStatementParams({
    required this.orderId,
    this.recipientEmail,
    this.sendEmail = true,
  });
}

/// 거래명세서 처리 결과
class TransactionStatementResult {
  final OrderEntity order;
  final String pdfUrl;
  final String fileName;
  final bool emailSent;
  
  const TransactionStatementResult({
    required this.order,
    required this.pdfUrl,
    required this.fileName,
    required this.emailSent,
  });
}

/// 거래명세서 생성 및 발송 통합 UseCase
/// 
/// 이 UseCase는 다음 작업을 수행합니다:
/// 1. 주문 정보 조회
/// 2. PDF 생성
/// 3. Storage 업로드
/// 4. 이메일 발송 (선택적)
/// 5. 주문 상태 업데이트
class ProcessTransactionStatementUseCase 
    implements UseCase<TransactionStatementResult, ProcessTransactionStatementParams> {
  final OrderRepository repository;
  final GeneratePdfUseCase generatePdfUseCase;
  final SendEmailUseCase sendEmailUseCase;
  
  ProcessTransactionStatementUseCase({
    required this.repository,
    required this.generatePdfUseCase,
    required this.sendEmailUseCase,
  });

  @override
  Future<Either<Failure, TransactionStatementResult>> call(
    ProcessTransactionStatementParams params,
  ) async {
    try {
      logger.i('거래명세서 처리 시작: 주문 ID ${params.orderId}');
      
      // 1. 주문 정보 조회
      final orderResult = await repository.getOrderById(params.orderId);
      
      return await orderResult.fold(
        (failure) {
          logger.e('주문 조회 실패: $failure');
          return Left(failure);
        },
        (order) async {
          // 2. 주문 상태 확인
          if (order.status != OrderStatus.confirmed && 
              order.status != OrderStatus.shipped &&
              order.status != OrderStatus.completed) {
            return Left(BusinessRuleFailure(message: '확정된 주문만 거래명세서를 발행할 수 있습니다'));
          }
          
          // 3. PDF 생성 및 Storage 업로드
          final pdfResult = await generatePdfUseCase(
            GeneratePdfParams(
              order: order,
              uploadToStorage: true,
            ),
          );
          
          return await pdfResult.fold(
            (failure) {
              logger.e('PDF 생성 실패: $failure');
              return Left(failure);
            },
            (pdfGenerationResult) async {
              if (pdfGenerationResult.storageUrl == null) {
                return Left(ServerFailure(message: 'PDF Storage 업로드에 실패했습니다'));
              }
              
              bool emailSent = false;
              
              // 4. 이메일 발송 (선택적)
              if (params.sendEmail) {
                final email = params.recipientEmail ?? 
                    order.userProfile?.email;
                    
                if (email != null) {
                  final emailResult = await sendEmailUseCase(
                    SendEmailParams(
                      order: order,
                      recipientEmail: email,
                      emailType: EmailType.transactionStatement,
                      pdfUrl: pdfGenerationResult.storageUrl,
                    ),
                  );
                  
                  emailResult.fold(
                    (failure) {
                      logger.e('이메일 발송 실패 (거래명세서는 생성됨): $failure');
                    },
                    (_) {
                      emailSent = true;
                      logger.i('이메일 발송 성공');
                    },
                  );
                } else {
                  logger.w('이메일 주소가 없어 발송하지 않음');
                }
              }
              
              // 5. 거래명세서 발행 기록 업데이트 (선택적)
              // TODO: 필요시 orders 테이블에 statement_generated_at 필드 추가
              
              logger.i('거래명세서 처리 완료');
              
              return Right(TransactionStatementResult(
                order: order,
                pdfUrl: pdfGenerationResult.storageUrl!,
                fileName: pdfGenerationResult.fileName,
                emailSent: emailSent,
              ));
            },
          );
        },
      );
    } catch (e) {
      logger.e('거래명세서 처리 중 오류', e);
      return Left(ServerFailure(message: '거래명세서 처리 중 오류가 발생했습니다'));
    }
  }
}