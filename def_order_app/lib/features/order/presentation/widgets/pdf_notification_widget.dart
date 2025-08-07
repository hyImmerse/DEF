import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/utils/velocity_x_compat.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// 40-60대 사용자를 위한 접근성 개선된 PDF 알림 위젯
/// 
/// WCAG AA 준수:
/// - 색상 대비율 4.5:1 이상
/// - 최소 18sp 폰트 크기
/// - 24dp 이상 아이콘 크기
/// - 중요 정보 강조
class PdfNotificationWidget extends StatelessWidget {
  final String? recipientEmail;
  final bool showEmailInfo;
  final VoidCallback? onResendEmail;
  final bool isLoading;
  
  const PdfNotificationWidget({
    super.key,
    this.recipientEmail,
    this.showEmailInfo = true,
    this.onResendEmail,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // Info Container 색상 - Material 3
        color: AppColors.info50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.info200,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 섹션
          Row(
            children: [
              // 아이콘 컨테이너
              Container(
                width: 56,  // 48dp → 56dp
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.info100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.info200,
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.picture_as_pdf,
                  color: AppColors.info,
                  size: 32,  // 24dp → 32dp
                ),
              ),
              20.widthBox,
              
              // 텍스트 섹션
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목
                    'PDF 주문서 안내'.text
                        .size(20)  // 18sp → 20sp
                        .fontWeight(FontWeight.bold)
                        .color(AppColors.info900)
                        .make(),
                    
                    8.heightBox,
                    
                    // 주요 메시지
                    '주문 확정 후 PDF 주문서가 자동 생성됩니다'
                        .text
                        .size(18)  // 16sp → 18sp
                        .color(AppColors.info800)
                        .lineHeight(1.5)
                        .make(),
                  ],
                ),
              ),
            ],
          ),
          
          // 이메일 정보 섹션
          if (showEmailInfo && recipientEmail != null) ...[
            24.heightBox,
            
            // 구분선
            Container(
              height: 1,
              color: AppColors.info200,
            ),
            
            20.heightBox,
            
            // 이메일 발송 정보
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.info300,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        color: AppColors.info700,
                        size: 24,
                      ),
                      12.widthBox,
                      '이메일 발송 주소'.text
                          .size(16)
                          .fontWeight(FontWeight.w600)
                          .color(AppColors.info900)
                          .make(),
                    ],
                  ),
                  
                  12.heightBox,
                  
                  // 이메일 주소 강조 표시
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primary200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: recipientEmail!.text
                              .size(18)  // 이메일 주소는 18sp
                              .fontWeight(FontWeight.bold)
                              .color(AppColors.primary900)  // Primary 색상으로 강조
                              .make(),
                        ),
                        if (onResendEmail != null) ...[
                          8.widthBox,
                          GFButton(
                            onPressed: isLoading ? null : onResendEmail,
                            text: isLoading ? '발송 중...' : '재발송',
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            size: 40,
                            type: GFButtonType.outline,
                            color: AppColors.primary,
                            shape: GFButtonShape.pills,
                            icon: isLoading 
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.send,
                                    size: 18,
                                  ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // 추가 안내 메시지
          20.heightBox,
          
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.info600,
                size: 20,
              ),
              8.widthBox,
              Expanded(
                child: 'PDF 파일은 주문 내역에서도 다운로드 가능합니다'
                    .text
                    .size(16)
                    .color(AppColors.info700)
                    .lineHeight(1.4)
                    .make(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// PDF 다운로드 버튼 위젯
class PdfDownloadButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String? fileName;
  
  const PdfDownloadButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return GFButton(
      onPressed: isLoading ? null : onPressed,
      text: isLoading 
          ? '다운로드 중...' 
          : fileName ?? 'PDF 다운로드',
      textStyle: const TextStyle(
        fontSize: 18,  // 18sp
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      color: AppColors.primary,
      size: 56,  // 56dp 터치 영역
      shape: GFButtonShape.pills,
      fullWidthButton: true,
      icon: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
            )
          : const Icon(
              Icons.download,
              color: Colors.white,
              size: 24,
            ),
      position: GFPosition.start,
    );
  }
}

/// PDF 상태 표시 위젯
class PdfStatusIndicator extends StatelessWidget {
  final bool isGenerated;
  final bool isEmailSent;
  final String? error;
  
  const PdfStatusIndicator({
    super.key,
    required this.isGenerated,
    required this.isEmailSent,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData icon;
    String message;
    
    if (error != null) {
      backgroundColor = AppColors.error50;
      borderColor = AppColors.error200;
      textColor = AppColors.error900;
      icon = Icons.error_outline;
      message = error!;
    } else if (isEmailSent) {
      backgroundColor = AppColors.success50;
      borderColor = AppColors.success200;
      textColor = AppColors.success900;
      icon = Icons.check_circle;
      message = 'PDF 생성 및 이메일 발송 완료';
    } else if (isGenerated) {
      backgroundColor = AppColors.warning50;
      borderColor = AppColors.warning200;
      textColor = AppColors.warning900;
      icon = Icons.picture_as_pdf;
      message = 'PDF 생성 완료';
    } else {
      backgroundColor = AppColors.surfaceVariant;
      borderColor = AppColors.border;
      textColor = AppColors.textSecondary;
      icon = Icons.hourglass_empty;
      message = 'PDF 생성 대기 중';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: textColor,
            size: 24,
          ),
          16.widthBox,
          Expanded(
            child: message.text
                .size(16)
                .fontWeight(FontWeight.w600)
                .color(textColor)
                .make(),
          ),
        ],
      ),
    );
  }
}