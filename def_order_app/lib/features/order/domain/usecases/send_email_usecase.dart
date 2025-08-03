import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';
import '../../data/services/email_service.dart';
import '../../../../core/utils/logger.dart';

/// 이메일 발송 타입
enum EmailType {
  transactionStatement, // 거래명세서
  orderConfirmation,    // 주문 확정
}

/// 이메일 발송 파라미터
class SendEmailParams {
  final Order order;
  final String recipientEmail;
  final EmailType emailType;
  final String? pdfUrl; // 거래명세서용
  
  const SendEmailParams({
    required this.order,
    required this.recipientEmail,
    required this.emailType,
    this.pdfUrl,
  });
}

/// 이메일 발송 UseCase
class SendEmailUseCase implements UseCase<void, SendEmailParams> {
  final OrderRepository repository;
  final EmailService emailService;
  
  SendEmailUseCase({
    required this.repository,
    EmailService? emailService,
  }) : emailService = emailService ?? EmailService();

  @override
  Future<Either<Failure, void>> call(SendEmailParams params) async {
    try {
      logger.i('이메일 발송 시작: ${params.emailType} to ${params.recipientEmail}');
      
      // 이메일 유효성 검사
      if (!_isValidEmail(params.recipientEmail)) {
        return Left(ValidationFailure('유효하지 않은 이메일 주소입니다'));
      }
      
      // 이메일 타입에 따른 발송
      switch (params.emailType) {
        case EmailType.transactionStatement:
          if (params.pdfUrl == null) {
            return Left(ValidationFailure('거래명세서 PDF URL이 필요합니다'));
          }
          await emailService.sendTransactionStatement(
            order: params.order,
            pdfUrl: params.pdfUrl!,
            recipientEmail: params.recipientEmail,
          );
          break;
          
        case EmailType.orderConfirmation:
          await emailService.sendOrderConfirmationEmail(
            order: params.order,
            recipientEmail: params.recipientEmail,
          );
          break;
      }
      
      logger.i('이메일 발송 완료');
      return const Right(null);
    } catch (e) {
      logger.e('이메일 발송 실패', error: e);
      return Left(ServerFailure('이메일 발송에 실패했습니다: ${e.toString()}'));
    }
  }
  
  /// 이메일 유효성 검사
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}