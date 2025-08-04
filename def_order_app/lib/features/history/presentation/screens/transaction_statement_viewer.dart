import 'package:flutter/material.dart';
import '../../../../core/utils/widget_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../../../core/theme/index.dart';
import '../../../../core/theme/app_theme.dart';
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          children: [
            '거래명세서'.text.size(22).bold.make(),
            '주문번호: ${widget.orderNumber}'.text
              .size(14)
              .gray600
              .make(),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // 다운로드 버튼 - 40-60대를 위한 큰 터치 영역
          if (_localPath != null)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: GFButton(
                onPressed: _downloadPdf,
                text: '',
                icon: const Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                size: 44,
                color: AppTheme.primaryColor,
                shape: GFButtonShape.circle,
                type: GFButtonType.solid,
              ),
            ),
          // 공유 버튼 - 40-60대를 위한 큰 터치 영역
          if (_localPath != null)
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: GFButton(
                onPressed: _sharePdf,
                text: '',
                icon: const Icon(
                  Icons.share_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                size: 44,
                color: Colors.blue[600]!,
                shape: GFButtonShape.circle,
                type: GFButtonType.solid,
              ),
            ),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.download_rounded,
                      size: 40,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  'PDF를 다운로드하는 중...'.text
                    .size(18)
                    .bold
                    .gray700
                    .makeCentered(),
                  const SizedBox(height: 12),
                  '잠시만 기다려주세요'.text
                    .size(16)
                    .gray500
                    .makeCentered(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    ),
                  ),
                ],
              ),
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
                      backgroundColor: AppTheme.errorColor,
                      textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                    );
                  },
                  onPageError: (page, error) {
                    GFToast.showToast(
                      '페이지를 불러올 수 없습니다',
                      context,
                      toastPosition: GFToastPosition.BOTTOM,
                      backgroundColor: AppTheme.errorColor,
                      textStyle: const TextStyle(color: Colors.white, fontSize: 16),
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
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 32),
          '거래명세서가 없습니다'.text
            .size(24)
            .bold
            .gray700
            .make(),
          const SizedBox(height: 12),
          '이 주문에 대한 거래명세서를\n생성하시겠습니까?'.text
            .size(16)
            .gray600
            .align(TextAlign.center)
            .make(),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: GFButton(
              onPressed: () {
                ref.read(transactionStatementProvider(widget.orderId).notifier)
                    .requestStatement();
              },
              text: '거래명세서 생성 요청',
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              size: 56,
              fullWidthButton: true,
              color: AppTheme.primaryColor,
              shape: GFButtonShape.pills,
              icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.red[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red[400],
            ),
          ),
          const SizedBox(height: 32),
          '오류가 발생했습니다'.text
            .size(24)
            .bold
            .color(Colors.red[700])
            .make(),
          const SizedBox(height: 12),
          error.text
            .size(16)
            .gray600
            .align(TextAlign.center)
            .make(),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: GFButton(
              onPressed: () {
                ref.invalidate(transactionStatementProvider(widget.orderId));
              },
              text: '다시 시도',
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              size: 56,
              fullWidthButton: true,
              color: Colors.red[600]!,
              shape: GFButtonShape.pills,
              icon: const Icon(Icons.refresh, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildControlBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 페이지 정보 및 진행률
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  '${_currentPage + 1} / $_totalPages 페이지'.text
                    .size(18)
                    .bold
                    .makeCentered(),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentPage + 1) / _totalPages,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    minHeight: 6,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 페이지 네비게이션 버튼들
            Row(
              children: [
                // 이전 페이지 버튼
                Expanded(
                  child: GFButton(
                    onPressed: _currentPage > 0
                      ? () {
                          _pdfController?.setPage(_currentPage - 1);
                        }
                      : null,
                    text: '이전 페이지',
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _currentPage > 0 ? Colors.white : Colors.grey[600],
                    ),
                    size: 50,
                    fullWidthButton: true,
                    color: _currentPage > 0 ? AppTheme.primaryColor : Colors.grey[300]!,
                    disabledColor: Colors.grey[300]!,
                    shape: GFButtonShape.pills,
                    icon: Icon(
                      Icons.chevron_left,
                      color: _currentPage > 0 ? Colors.white : Colors.grey[600],
                      size: 20,
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // 다음 페이지 버튼
                Expanded(
                  child: GFButton(
                    onPressed: _currentPage < _totalPages - 1
                      ? () {
                          _pdfController?.setPage(_currentPage + 1);
                        }
                      : null,
                    text: '다음 페이지',
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _currentPage < _totalPages - 1 ? Colors.white : Colors.grey[600],
                    ),
                    size: 50,
                    fullWidthButton: true,
                    color: _currentPage < _totalPages - 1 ? AppTheme.primaryColor : Colors.grey[300]!,
                    disabledColor: Colors.grey[300]!,
                    shape: GFButtonShape.pills,
                    icon: Icon(
                      Icons.chevron_right,
                      color: _currentPage < _totalPages - 1 ? Colors.white : Colors.grey[600],
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
    if (_localPath == null) return;

    try {
      // 저장소 권한 확인 및 요청
      final permission = await Permission.storage.request();
      if (!permission.isGranted) {
        GFToast.showToast(
          '저장소 권한이 필요합니다',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: AppTheme.errorColor,
          textStyle: const TextStyle(color: Colors.white, fontSize: 16),
        );
        return;
      }

      // 다운로드 폴더에 파일 저장
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      if (downloadsDir != null && downloadsDir.existsSync()) {
        final fileName = '거래명세서_${widget.orderNumber}_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final newFile = File('${downloadsDir.path}/$fileName');
        
        // 파일 복사
        await File(_localPath!).copy(newFile.path);

        if (mounted) {
          GFToast.showToast(
            'PDF가 다운로드되었습니다\n경로: ${newFile.path}',
            context,
            toastPosition: GFToastPosition.BOTTOM,
            backgroundColor: AppTheme.successColor,
            textStyle: const TextStyle(color: Colors.white, fontSize: 16),
            toastDuration: 4,
          );
        }
      } else {
        throw Exception('다운로드 폴더를 찾을 수 없습니다');
      }
    } catch (e) {
      if (mounted) {
        GFToast.showToast(
          'PDF 다운로드에 실패했습니다: ${e.toString()}',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: AppTheme.errorColor,
          textStyle: const TextStyle(color: Colors.white, fontSize: 16),
        );
      }
    }
  }
  
  Future<void> _sharePdf() async {
    if (_localPath == null) return;

    try {
      final file = File(_localPath!);
      if (await file.exists()) {
        await Share.shareXFiles(
          [XFile(_localPath!)],
          text: '거래명세서 (주문번호: ${widget.orderNumber})',
          subject: '거래명세서 - ${widget.orderNumber}',
        );
      } else {
        throw Exception('공유할 파일을 찾을 수 없습니다');
      }
    } catch (e) {
      if (mounted) {
        GFToast.showToast(
          'PDF 공유에 실패했습니다: ${e.toString()}',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: AppTheme.errorColor,
          textStyle: const TextStyle(color: Colors.white, fontSize: 16),
        );
      }
    }
  }
}