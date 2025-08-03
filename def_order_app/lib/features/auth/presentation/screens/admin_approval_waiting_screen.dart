import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/theme/index.dart';
import '../providers/auth_provider.dart';

/// 관리자 승인 대기 화면
/// 회원가입 후 관리자 승인을 기다리는 사용자에게 표시되는 화면
class AdminApprovalWaitingScreen extends ConsumerStatefulWidget {
  const AdminApprovalWaitingScreen({super.key});

  @override
  ConsumerState<AdminApprovalWaitingScreen> createState() => _AdminApprovalWaitingScreenState();
}

class _AdminApprovalWaitingScreenState extends ConsumerState<AdminApprovalWaitingScreen> {
  @override
  void initState() {
    super.initState();
    // 5초마다 승인 상태 확인
    _checkApprovalStatus();
  }

  Future<void> _checkApprovalStatus() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) break;
      
      try {
        await ref.read(authProvider.notifier).checkApprovalStatus();
        final user = ref.read(authProvider).user;
        
        if (user?.userMetadata?['status'] == 'approved') {
          if (mounted) {
            // 승인 완료 시 홈 화면으로 이동
            Navigator.of(context).pushReplacementNamed('/home');
          }
          break;
        }
      } catch (e) {
        // 에러 무시 - 백그라운드 체크이므로
      }
    }
  }

  Future<void> _handleLogout() async {
    await ref.read(authProvider.notifier).signOut();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final businessName = user?.userMetadata?['business_name'] ?? '';
    final businessNumber = user?.userMetadata?['business_number'] ?? '';
    final createdAt = user?.createdAt ?? '';
    
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: _handleLogout,
            child: '로그아웃'.text
              .size(16)
              .color(AppColors.primary)
              .make(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.allXL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSpacing.v40,
            
            // 대기 아이콘
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.hourglass_bottom_rounded,
                size: 64,
                color: AppColors.warning,
              ),
            ).centered(),
            
            AppSpacing.v32,
            
            // 상태 메시지
            '관리자 승인 대기 중'.text
              .textStyle(AppTextStyles.headlineMedium)
              .color(AppColors.textPrimary)
              .makeCentered(),
            
            AppSpacing.v16,
            
            '회원가입이 완료되었습니다.\n관리자 승인 후 서비스를 이용하실 수 있습니다.'.text
              .textStyle(AppTextStyles.bodyLarge)
              .color(AppColors.textSecondary)
              .align(TextAlign.center)
              .makeCentered(),
            
            AppSpacing.v40,
            
            // 가입 정보 카드
            Container(
              padding: AppSpacing.allLG,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  '가입 정보'.text
                    .textStyle(AppTextStyles.titleMedium)
                    .make(),
                  
                  AppSpacing.v16,
                  
                  _buildInfoRow('사업자명', businessName),
                  AppSpacing.v12,
                  _buildInfoRow('사업자번호', businessNumber),
                  AppSpacing.v12,
                  _buildInfoRow('가입일시', _formatDate(createdAt)),
                  AppSpacing.v12,
                  _buildInfoRow('상태', '승인 대기', isStatus: true),
                ],
              ),
            ),
            
            AppSpacing.v32,
            
            // 안내 메시지
            Container(
              padding: AppSpacing.allMD,
              decoration: BoxDecoration(
                color: AppColors.infoLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: AppColors.info,
                  ),
                  AppSpacing.h8,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        '승인 절차 안내'.text
                          .textStyle(AppTextStyles.titleSmall)
                          .color(AppColors.info)
                          .make(),
                        AppSpacing.v4,
                        '• 평일 기준 1~2일 내 처리됩니다'.text
                          .textStyle(AppTextStyles.bodySmall)
                          .color(AppColors.info)
                          .make(),
                        '• 승인 완료 시 이메일로 안내드립니다'.text
                          .textStyle(AppTextStyles.bodySmall)
                          .color(AppColors.info)
                          .make(),
                        '• 문의사항은 고객센터로 연락주세요'.text
                          .textStyle(AppTextStyles.bodySmall)
                          .color(AppColors.info)
                          .make(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            AppSpacing.v32,
            
            // 고객센터 연락처
            Container(
              padding: AppSpacing.allLG,
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.support_agent,
                    size: 48,
                    color: AppColors.primary,
                  ),
                  AppSpacing.v16,
                  '고객센터'.text
                    .textStyle(AppTextStyles.titleMedium)
                    .make(),
                  AppSpacing.v8,
                  '평일 09:00 ~ 18:00'.text
                    .textStyle(AppTextStyles.bodyMedium)
                    .color(AppColors.textSecondary)
                    .make(),
                  AppSpacing.v16,
                  GFButton(
                    onPressed: () {
                      // TODO: 전화 걸기 기능
                    },
                    text: '1588-1234',
                    icon: const Icon(Icons.phone, color: Colors.white, size: 20),
                    textStyle: AppTextStyles.button.copyWith(color: Colors.white),
                    size: GFSize.LARGE,
                    fullWidthButton: true,
                    color: AppColors.primary,
                    shape: GFButtonShape.pills,
                  ),
                ],
              ),
            ),
            
            AppSpacing.v40,
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: label.text
            .textStyle(AppTextStyles.bodyMedium)
            .color(AppColors.textSecondary)
            .make(),
        ),
        Expanded(
          child: isStatus
            ? Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                ),
                child: value.text
                  .textStyle(AppTextStyles.labelMedium)
                  .color(AppColors.warning)
                  .makeCentered(),
              )
            : value.text
                .textStyle(AppTextStyles.bodyMedium)
                .color(AppColors.textPrimary)
                .make(),
        ),
      ],
    );
  }
  
  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateString);
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}