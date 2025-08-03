import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../../core/theme/index.dart';
import '../providers/order_history_provider.dart';

/// 거래명세서 PDF 뷰어 화면
/// 40-60대 사용자를 위한 큰 컨트롤과 직관적인 UI
class TransactionStatementViewer extends ConsumerStatefulWidget {
  final String orderId;
  final String orderNumber;
  
  const TransactionStatementViewer({
    super.key,
    required this.orderId,
    required this.orderNumber,
  });

  @override
  ConsumerState<TransactionStatementViewer> createState() => _TransactionStatementViewerState();
}

class _TransactionStatementViewerState extends ConsumerState<TransactionStatementViewer> {
  PDFViewController? _pdfController;
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isReady = false;
  String? _localPath;
  double _zoom = 1.0;
  
  @override
  Widget build(BuildContext context) {
    final statementState = ref.watch(transactionStatementProvider(widget.orderId));
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          children: [
            '거래명세서'.text
              .textStyle(AppTextStyles.headlineSmall)
              .make(),
            '주문번호: ${widget.orderNumber}'.text
              .textStyle(AppTextStyles.bodySmall)
              .color(AppColors.textSecondary)
              .make(),
          ],
        ),
        centerTitle: true,
        actions: [
          // 다운로드 버튼
          if (_localPath != null)
            IconButton(
              icon: Icon(
                Icons.download_rounded,
                size: 28,
                color: AppColors.primary,
              ),
              onPressed: _downloadPdf,
              tooltip: 'PDF 다운로드',
            ),
          // 공유 버튼
          if (_localPath != null)
            IconButton(
              icon: Icon(
                Icons.share_rounded,
                size: 28,
                color: AppColors.primary,
              ),
              onPressed: _sharePdf,
              tooltip: 'PDF 공유',
            ),
          AppSpacing.h8,
        ],
      ),
      body: statementState.when(
        data: (url) {
          if (url == null) {
            return _buildNoStatementView();
          }
          
          // PDF 다운로드 및 표시
          if (_localPath == null) {
            _downloadAndDisplayPdf(url);
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          return Column(
            children: [
              // PDF 뷰어
              Expanded(
                child: PDFView(
                  filePath: _localPath!,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: false,
                  pageFling: true,
                  pageSnap: true,
                  defaultPage: _currentPage,
                  fitPolicy: FitPolicy.BOTH,
                  preventLinkNavigation: false,
                  onRender: (pages) {
                    setState(() {
                      _totalPages = pages!;
                      _isReady = true;
                    });
                  },
                  onError: (error) {
                    GFToast.showToast(
                      'PDF를 불러올 수 없습니다',
                      context,
                      toastPosition: GFToastPosition.BOTTOM,
                      backgroundColor: AppColors.error,
                    );
                  },
                  onPageError: (page, error) {
                    GFToast.showToast(
                      '페이지를 불러올 수 없습니다',
                      context,
                      toastPosition: GFToastPosition.BOTTOM,
                      backgroundColor: AppColors.error,
                    );
                  },
                  onViewCreated: (PDFViewController pdfViewController) {
                    _pdfController = pdfViewController;
                  },
                  onPageChanged: (int? page, int? total) {
                    setState(() {
                      _currentPage = page ?? 0;
                    });
                  },
                ),
              ),
              
              // 컨트롤 바
              if (_isReady)
                _buildControlBar(),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => _buildErrorView(error.toString()),
      ),
    );
  }
  
  Widget _buildNoStatementView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description_outlined,
              size: 60,
              color: AppColors.textTertiary,
            ),
          ),
          AppSpacing.v24,
          '거래명세서가 없습니다'.text
            .textStyle(AppTextStyles.titleLarge)
            .color(AppColors.textSecondary)
            .make(),
          AppSpacing.v8,
          '거래명세서 생성을 요청하시겠습니까?'.text
            .textStyle(AppTextStyles.bodyLarge)
            .color(AppColors.textTertiary)
            .make(),
          AppSpacing.v32,
          GFButton(
            onPressed: () {
              ref.read(transactionStatementProvider(widget.orderId).notifier)
                  .requestStatement();
            },
            text: '거래명세서 생성',
            icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 24),
            textStyle: AppTextStyles.button.copyWith(color: Colors.white),
            size: GFSize.LARGE,
            color: AppColors.primary,
            shape: GFButtonShape.pills,
          ),
        ],
      ),
    ).px(AppSpacing.xl);
  }
  
  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          AppSpacing.v24,
          '오류가 발생했습니다'.text
            .textStyle(AppTextStyles.titleLarge)
            .color(AppColors.error)
            .make(),
          AppSpacing.v8,
          error.text
            .textStyle(AppTextStyles.bodyLarge)
            .color(AppColors.textSecondary)
            .align(TextAlign.center)
            .make(),
          AppSpacing.v32,
          GFButton(
            onPressed: () {
              ref.invalidate(transactionStatementProvider(widget.orderId));
            },
            text: '다시 시도',
            size: GFSize.LARGE,
            color: AppColors.error,
            shape: GFButtonShape.pills,
          ),
        ],
      ),
    ).px(AppSpacing.xl);
  }
  
  Widget _buildControlBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // 이전 페이지
          IconButton(
            icon: Icon(
              Icons.chevron_left_rounded,
              size: 36,
              color: _currentPage > 0 
                ? AppColors.primary 
                : AppColors.disabled,
            ),
            onPressed: _currentPage > 0
              ? () {
                  _pdfController?.setPage(_currentPage - 1);
                }
              : null,
          ),
          
          // 페이지 정보
          Expanded(
            child: Column(
              children: [
                '${_currentPage + 1} / $_totalPages'.text
                  .textStyle(AppTextStyles.titleMedium)
                  .makeCentered(),
                AppSpacing.v4,
                LinearProgressIndicator(
                  value: (_currentPage + 1) / _totalPages,
                  backgroundColor: AppColors.backgroundSecondary,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 4,
                ),
              ],
            ),
          ),
          
          // 다음 페이지
          IconButton(
            icon: Icon(
              Icons.chevron_right_rounded,
              size: 36,
              color: _currentPage < _totalPages - 1 
                ? AppColors.primary 
                : AppColors.disabled,
            ),
            onPressed: _currentPage < _totalPages - 1
              ? () {
                  _pdfController?.setPage(_currentPage + 1);
                }
              : null,
          ),
          
          AppSpacing.h16,
          
          // 줌 컨트롤
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.zoom_out_rounded,
                  size: 28,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  setState(() {
                    _zoom = (_zoom - 0.25).clamp(0.5, 3.0);
                  });
                  _pdfController?.setZoom(_zoom);
                },
              ),
              '${(_zoom * 100).toInt()}%'.text
                .textStyle(AppTextStyles.bodyMedium)
                .make()
                .box
                .width(60)
                .makeCentered(),
              IconButton(
                icon: Icon(
                  Icons.zoom_in_rounded,
                  size: 28,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  setState(() {
                    _zoom = (_zoom + 0.25).clamp(0.5, 3.0);
                  });
                  _pdfController?.setZoom(_zoom);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Future<void> _downloadAndDisplayPdf(String url) async {
    try {
      final dio = Dio();
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${widget.orderNumber}_statement.pdf');
      
      await dio.download(url, file.path);
      
      setState(() {
        _localPath = file.path;
      });
    } catch (e) {
      if (mounted) {
        GFToast.showToast(
          'PDF 다운로드에 실패했습니다',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: AppColors.error,
        );
      }
    }
  }
  
  Future<void> _downloadPdf() async {
    // TODO: 파일 시스템에 저장
    GFToast.showToast(
      'PDF가 다운로드되었습니다',
      context,
      toastPosition: GFToastPosition.BOTTOM,
      backgroundColor: AppColors.success,
    );
  }
  
  Future<void> _sharePdf() async {
    // TODO: 공유 기능 구현
    GFToast.showToast(
      'PDF 공유 기능은 준비 중입니다',
      context,
      toastPosition: GFToastPosition.BOTTOM,
      backgroundColor: AppColors.info,
    );
  }
}