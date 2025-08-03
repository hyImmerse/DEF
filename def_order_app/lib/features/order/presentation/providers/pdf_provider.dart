import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/generate_pdf_usecase.dart';
import '../../domain/usecases/send_email_usecase.dart';
import '../../domain/usecases/process_transaction_statement_usecase.dart';
import '../../domain/providers/order_domain_provider.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';

part 'pdf_provider.g.dart';

/// PDF 생성 상태
class PdfGenerationState {
  final bool isLoading;
  final Uint8List? pdfData;
  final String? pdfUrl;
  final String? fileName;
  final String? error;
  final bool emailSent;
  
  const PdfGenerationState({
    this.isLoading = false,
    this.pdfData,
    this.pdfUrl,
    this.fileName,
    this.error,
    this.emailSent = false,
  });
  
  PdfGenerationState copyWith({
    bool? isLoading,
    Uint8List? pdfData,
    String? pdfUrl,
    String? fileName,
    String? error,
    bool? emailSent,
  }) {
    return PdfGenerationState(
      isLoading: isLoading ?? this.isLoading,
      pdfData: pdfData ?? this.pdfData,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      fileName: fileName ?? this.fileName,
      error: error ?? this.error,
      emailSent: emailSent ?? this.emailSent,
    );
  }
}

/// PDF 생성 Provider
@riverpod
class PdfGenerationNotifier extends _$PdfGenerationNotifier {
  late final GeneratePdfUseCase _generatePdfUseCase;
  late final SendEmailUseCase _sendEmailUseCase;
  late final ProcessTransactionStatementUseCase _processTransactionStatementUseCase;
  
  @override
  PdfGenerationState build() {
    _generatePdfUseCase = ref.read(generatePdfUseCaseProvider);
    _sendEmailUseCase = ref.read(sendEmailUseCaseProvider);
    _processTransactionStatementUseCase = ref.read(processTransactionStatementUseCaseProvider);
    
    return const PdfGenerationState();
  }
  
  /// PDF 생성 (로컬)
  Future<void> generatePdf(Order order) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _generatePdfUseCase(
        GeneratePdfParams(
          order: order,
          uploadToStorage: false,
        ),
      );
      
      result.fold(
        (failure) {
          logger.e('PDF 생성 실패: $failure');
          state = state.copyWith(
            isLoading: false,
            error: _mapFailureToMessage(failure),
          );
        },
        (pdfResult) {
          logger.i('PDF 생성 성공: ${pdfResult.fileName}');
          state = state.copyWith(
            isLoading: false,
            pdfData: pdfResult.pdfData,
            fileName: pdfResult.fileName,
          );
        },
      );
    } catch (e) {
      logger.e('PDF 생성 중 오류', e);
      state = state.copyWith(
        isLoading: false,
        error: '예상치 못한 오류가 발생했습니다',
      );
    }
  }
  
  /// 거래명세서 처리 (PDF 생성 + Storage 업로드 + 이메일 발송)
  Future<void> processTransactionStatement({
    required String orderId,
    String? recipientEmail,
    bool sendEmail = true,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _processTransactionStatementUseCase(
        ProcessTransactionStatementParams(
          orderId: orderId,
          recipientEmail: recipientEmail,
          sendEmail: sendEmail,
        ),
      );
      
      result.fold(
        (failure) {
          logger.e('거래명세서 처리 실패: $failure');
          state = state.copyWith(
            isLoading: false,
            error: _mapFailureToMessage(failure),
          );
        },
        (statementResult) {
          logger.i('거래명세서 처리 성공');
          state = state.copyWith(
            isLoading: false,
            pdfUrl: statementResult.pdfUrl,
            fileName: statementResult.fileName,
            emailSent: statementResult.emailSent,
          );
        },
      );
    } catch (e) {
      logger.e('거래명세서 처리 중 오류', e);
      state = state.copyWith(
        isLoading: false,
        error: '예상치 못한 오류가 발생했습니다',
      );
    }
  }
  
  /// 이메일 재발송
  Future<void> resendEmail({
    required Order order,
    required String recipientEmail,
  }) async {
    if (state.pdfUrl == null) {
      state = state.copyWith(error: 'PDF URL이 없습니다');
      return;
    }
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _sendEmailUseCase(
        SendEmailParams(
          order: order,
          recipientEmail: recipientEmail,
          emailType: EmailType.transactionStatement,
          pdfUrl: state.pdfUrl,
        ),
      );
      
      result.fold(
        (failure) {
          logger.e('이메일 재발송 실패: $failure');
          state = state.copyWith(
            isLoading: false,
            error: _mapFailureToMessage(failure),
          );
        },
        (_) {
          logger.i('이메일 재발송 성공');
          state = state.copyWith(
            isLoading: false,
            emailSent: true,
          );
        },
      );
    } catch (e) {
      logger.e('이메일 재발송 중 오류', e);
      state = state.copyWith(
        isLoading: false,
        error: '예상치 못한 오류가 발생했습니다',
      );
    }
  }
  
  /// 상태 초기화
  void reset() {
    state = const PdfGenerationState();
  }
  
  /// Failure를 사용자 메시지로 변환
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message ?? '서버 오류가 발생했습니다';
    } else if (failure is ValidationFailure) {
      return failure.message ?? '입력값이 올바르지 않습니다';
    } else if (failure is BusinessFailure) {
      return failure.message ?? '처리할 수 없습니다';
    } else {
      return '오류가 발생했습니다';
    }
  }
}