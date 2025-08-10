import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/utils/widget_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../core/theme/index.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/order_history_provider.dart';
import '../../../auth/presentation/providers/demo_auth_provider.dart';

// 웹 환경에서만 dart:html import
import 'dart:html' as html if (dart.library.io) 'dart:io';
import 'dart:js' as js;

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
    final isDemoMode = ref.watch(isDemoModeProvider);
    
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
        // AppBar 버튼들 제거 - 하단 PDF 다운로드 버튼으로 통합
      ),
      body: statementState.when(
        data: (url) {
          if (url == null) {
            return _buildNoStatementView();
          }
          
          // 데모 모드에서는 더미 PDF 생성
          if (isDemoMode && _localPath == null) {
            _generateDemoPdf();
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
                      Icons.description_rounded,
                      size: 40,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  '데모 거래명세서 생성 중...'.text
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
              // 플랫폼별 뷰어
              Expanded(
                child: _buildPlatformSpecificViewer(),
              ),
              
              // 컨트롤 바 (HTML 뷰어에서는 간단한 버전)
              if (_isReady && !kIsWeb)
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
  
  /// 플랫폼별 뷰어 빌드
  Widget _buildPlatformSpecificViewer() {
    if (kIsWeb) {
      // 웹 환경: HTML 뷰어 사용
      return _buildHtmlViewer();
    } else {
      // 모바일 환경: PDF 뷰어 사용
      return _buildPdfViewer();
    }
  }

  /// HTML 뷰어 (웹 환경용)
  Widget _buildHtmlViewer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        children: [
          // 헤더
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Icon(Icons.description, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '거래명세서 미리보기'.text.bold.make(),
                      '주문번호: ${widget.orderNumber}'.text.size(12).gray600.make(),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GFButton(
                      onPressed: () {
                        try {
                          // 새 탭에서 HTML 열기
                          html.window.open(_localPath!, '_blank');
                        } catch (e) {
                          GFToast.showToast(
                            '새 탭에서 열기에 실패했습니다',
                            context,
                            toastPosition: GFToastPosition.BOTTOM,
                            backgroundColor: AppTheme.errorColor,
                            textStyle: const TextStyle(color: Colors.white, fontSize: 14),
                          );
                        }
                      },
                      text: '새 탭에서 보기',
                      size: 32,
                      color: AppTheme.primaryColor,
                      textStyle: const TextStyle(fontSize: 11),
                    ),
                    const SizedBox(width: 8),
                    GFButton(
                      onPressed: () => _downloadPdf(),
                      text: 'PDF 다운로드',
                      size: 32,
                      color: Colors.green[600]!,
                      textStyle: const TextStyle(fontSize: 11, color: Colors.white),
                      icon: const Icon(Icons.picture_as_pdf, size: 16, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 미리보기 영역
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  '거래명세서가 생성되었습니다.'.text.bold.size(16).make(),
                  const SizedBox(height: 8),
                  '• 주문번호: ${widget.orderNumber}'.text.make(),
                  '• 생성일: ${DateTime.now().toString().substring(0, 19)}'.text.make(),
                  '• 상태: 완료'.text.make(),
                  '• 파일형식: PDF (A4 크기)'.text.make(),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '📄 새 탭에서 보기: 브라우저에서 전체 화면으로 확인'.text
                        .gray600
                        .size(13)
                        .make(),
                      const SizedBox(height: 4),
                      '📥 PDF 다운로드: 실제 PDF 파일로 저장 (인쇄 가능)'.text
                        .gray600
                        .size(13)
                        .make(),
                      const SizedBox(height: 4),
                      '💡 PDF 파일을 다운로드한 후 이메일이나 메신저로 공유할 수 있습니다.'.text
                        .gray600
                        .size(13)
                        .make(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// PDF 뷰어 (모바일 환경용)
  Widget _buildPdfViewer() {
    return PDFView(
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
            .color(Colors.red[700]!)
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
      padding: const EdgeInsets.all(16),
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
                    .size(16)
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
            
            const SizedBox(height: 12),
            
            // 페이지 네비게이션 버튼들
            Row(
              children: [
                // 이전 페이지 버튼
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: GFButton(
                      onPressed: _currentPage > 0
                        ? () {
                            _pdfController?.setPage(_currentPage - 1);
                          }
                        : null,
                      text: '이전',
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _currentPage > 0 ? Colors.white : Colors.grey[600],
                      ),
                      fullWidthButton: true,
                      color: _currentPage > 0 ? AppTheme.primaryColor : Colors.grey[300]!,
                      disabledColor: Colors.grey[300]!,
                      shape: GFButtonShape.pills,
                      icon: Icon(
                        Icons.chevron_left,
                        color: _currentPage > 0 ? Colors.white : Colors.grey[600],
                        size: 18,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // 다음 페이지 버튼
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: GFButton(
                      onPressed: _currentPage < _totalPages - 1
                        ? () {
                            _pdfController?.setPage(_currentPage + 1);
                          }
                        : null,
                      text: '다음',
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _currentPage < _totalPages - 1 ? Colors.white : Colors.grey[600],
                      ),
                      fullWidthButton: true,
                      color: _currentPage < _totalPages - 1 ? AppTheme.primaryColor : Colors.grey[300]!,
                      disabledColor: Colors.grey[300]!,
                      shape: GFButtonShape.pills,
                      icon: Icon(
                        Icons.chevron_right,
                        color: _currentPage < _totalPages - 1 ? Colors.white : Colors.grey[600],
                        size: 18,
                      ),
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
      if (kIsWeb) {
        // 웹 환경: URL을 직접 사용
        setState(() {
          _localPath = url;
        });
      } else {
        // 모바일 환경: 파일 다운로드
        final dio = Dio();
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/${widget.orderNumber}_statement.pdf');
        
        await dio.download(url, file.path);
        
        setState(() {
          _localPath = file.path;
        });
      }
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

  Future<void> _generateDemoPdf() async {
    try {
      // 1초 지연으로 실제 생성 느낌 연출
      await Future.delayed(const Duration(seconds: 1));
      
      // 웹 환경과 모바일 환경 구분
      if (kIsWeb) {
        // 웹 환경: Blob URL 사용
        await _generateWebPdf();
      } else {
        // 모바일 환경: 기존 path_provider 방식 사용
        await _generateMobilePdf();
      }
    } catch (e) {
      if (mounted) {
        GFToast.showToast(
          '데모 PDF 생성에 실패했습니다: ${e.toString()}',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: AppTheme.errorColor,
          textStyle: const TextStyle(color: Colors.white, fontSize: 16),
        );
      }
    }
  }

  /// 웹 환경용 PDF 생성 (HTML 기반 대안)
  Future<void> _generateWebPdf() async {
    try {
      // jsPDF 사용을 시도하되, 실패하면 HTML 기반 대안 사용
      final jsPdf = js.context['jsPDF'];
      
      if (jsPdf != null) {
        // jsPDF가 사용 가능한 경우 기존 로직 사용
        await _generateWebPdfWithJsPdf();
      } else {
        // jsPDF가 없는 경우 HTML 기반 대안 사용
        await _generateWebPdfAlternative();
      }
    } catch (e) {
      print('jsPDF 사용 실패, 대안 방법 사용: $e');
      await _generateWebPdfAlternative();
    }
  }

  /// jsPDF를 사용한 웹 PDF 생성
  Future<void> _generateWebPdfWithJsPdf() async {
    final jsPdf = js.context['jsPDF'];
    
    // PDF 문서 생성 (A4 크기, 세로 방향)
    final pdf = js.JsObject(jsPdf, ['p', 'mm', 'a4']);
    
    // 한글 폰트 설정 (기본 폰트 사용)
    pdf.callMethod('setFont', ['helvetica']);
    pdf.callMethod('setFontSize', [12]);
    
    // 제목
    pdf.callMethod('setFontSize', [20]);
    pdf.callMethod('text', ['거래명세서', 105, 30, {'textAlign': 'center'}]);
    
    // 기본 정보
    pdf.callMethod('setFontSize', [12]);
    pdf.callMethod('text', ['주문번호: ${widget.orderNumber}', 20, 50]);
    pdf.callMethod('text', ['생성일: ${DateTime.now().toString().substring(0, 19)}', 20, 60]);
    
    // 주문 정보 테이블
    final tableData = [
      ['주문번호', widget.orderNumber],
      ['주문일시', DateTime.now().toString().substring(0, 19)],
      ['상태', '완료'],
      ['배송방법', '직접배송'],
    ];
    
    var yPosition = 80;
    for (final row in tableData) {
      pdf.callMethod('text', [row[0], 20, yPosition]);
      pdf.callMethod('text', [row[1], 80, yPosition]);
      yPosition += 10;
    }
    
    // 제품 테이블 헤더
    yPosition += 10;
    pdf.callMethod('setFontSize', [14]);
    pdf.callMethod('text', ['제품명', 20, yPosition]);
    pdf.callMethod('text', ['수량', 80, yPosition]);
    pdf.callMethod('text', ['단가', 120, yPosition]);
    pdf.callMethod('text', ['금액', 160, yPosition]);
    
    // 제품 정보
    yPosition += 10;
    pdf.callMethod('setFontSize', [12]);
    pdf.callMethod('text', ['자바라 (20L)', 20, yPosition]);
    pdf.callMethod('text', ['10개', 80, yPosition]);
    pdf.callMethod('text', ['15,000원', 120, yPosition]);
    pdf.callMethod('text', ['150,000원', 160, yPosition]);
    
    yPosition += 10;
    pdf.callMethod('text', ['반환 탱크', 20, yPosition]);
    pdf.callMethod('text', ['5개', 80, yPosition]);
    pdf.callMethod('text', ['5,000원', 120, yPosition]);
    pdf.callMethod('text', ['25,000원', 160, yPosition]);
    
    // 총 금액
    yPosition += 20;
    pdf.callMethod('setFontSize', [16]);
    pdf.callMethod('text', ['총 금액: 175,000원', 120, yPosition]);
    
    // 푸터
    yPosition += 30;
    pdf.callMethod('setFontSize', [10]);
    pdf.callMethod('text', ['이 문서는 데모용으로 생성되었습니다.', 20, yPosition]);
    pdf.callMethod('text', ['실제 거래명세서는 주문 완료 후 발급됩니다.', 20, yPosition + 5]);
    
    // PDF를 Blob으로 변환
    final pdfBlob = pdf.callMethod('output', ['blob']);
    final url = html.Url.createObjectUrlFromBlob(pdfBlob);
    
    setState(() {
      _localPath = url;
    });
  }

  /// HTML 기반 대안 PDF 생성 (jsPDF 없이)
  Future<void> _generateWebPdfAlternative() async {
    // PDF 콘텐츠 DOM 요소 생성
    await _createPdfContentElement();
    
    // 미리보기용 HTML blob 생성
    final htmlContent = '''
<div style="width: 210mm; margin: 0 auto; font-family: 'Noto Sans KR', Arial, sans-serif; line-height: 1.6; color: #333; background: white; padding: 20mm;">
    <div class="header" style="text-align: center; border-bottom: 3px solid #2196F3; padding-bottom: 20px; margin-bottom: 30px;">
        <h1 style="font-size: 28px; margin: 0; color: #2196F3;">거래명세서</h1>
        <p style="margin: 5px 0; color: #666;">Transaction Statement</p>
        <p style="margin: 5px 0; color: #666;">주문번호: ${widget.orderNumber}</p>
        <p style="margin: 5px 0; color: #666;">생성일: ${DateTime.now().toString().substring(0, 19)}</p>
    </div>

    <table style="width: 100%; border-collapse: collapse; margin: 20px 0; border: 1px solid #ddd;">
        <tr>
            <th style="padding: 12px; text-align: left; border: 1px solid #ddd; background-color: #f5f5f5; font-weight: bold; width: 30%;">주문번호</th>
            <td style="padding: 12px; text-align: left; border: 1px solid #ddd;">${widget.orderNumber}</td>
        </tr>
        <tr>
            <th style="padding: 12px; text-align: left; border: 1px solid #ddd; background-color: #f5f5f5; font-weight: bold;">주문일시</th>
            <td style="padding: 12px; text-align: left; border: 1px solid #ddd;">${DateTime.now().toString().substring(0, 19)}</td>
        </tr>
        <tr>
            <th style="padding: 12px; text-align: left; border: 1px solid #ddd; background-color: #f5f5f5; font-weight: bold;">처리상태</th>
            <td style="padding: 12px; text-align: left; border: 1px solid #ddd;">완료</td>
        </tr>
        <tr>
            <th style="padding: 12px; text-align: left; border: 1px solid #ddd; background-color: #f5f5f5; font-weight: bold;">배송방법</th>
            <td style="padding: 12px; text-align: left; border: 1px solid #ddd;">직접배송</td>
        </tr>
        <tr>
            <th style="padding: 12px; text-align: left; border: 1px solid #ddd; background-color: #f5f5f5; font-weight: bold;">고객구분</th>
            <td style="padding: 12px; text-align: left; border: 1px solid #ddd;">데모계정</td>
        </tr>
    </table>

    <h3 style="margin: 30px 0 20px 0; color: #333;">주문 상세 내역</h3>
    <table style="width: 100%; border-collapse: collapse; margin: 20px 0; border: 1px solid #ddd;">
        <thead>
            <tr>
                <th style="padding: 12px; text-align: center; border: 1px solid #ddd; background-color: #2196F3; color: white; font-weight: bold;">제품명</th>
                <th style="padding: 12px; text-align: center; border: 1px solid #ddd; background-color: #2196F3; color: white; font-weight: bold;">수량</th>
                <th style="padding: 12px; text-align: center; border: 1px solid #ddd; background-color: #2196F3; color: white; font-weight: bold;">단가</th>
                <th style="padding: 12px; text-align: center; border: 1px solid #ddd; background-color: #2196F3; color: white; font-weight: bold;">금액</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td style="padding: 12px; text-align: left; border: 1px solid #ddd;">자바라 (20L)</td>
                <td style="padding: 12px; text-align: center; border: 1px solid #ddd;">10개</td>
                <td style="padding: 12px; text-align: center; border: 1px solid #ddd;">15,000원</td>
                <td style="padding: 12px; text-align: center; border: 1px solid #ddd;">150,000원</td>
            </tr>
            <tr>
                <td style="padding: 12px; text-align: left; border: 1px solid #ddd;">반환 탱크</td>
                <td style="padding: 12px; text-align: center; border: 1px solid #ddd;">5개</td>
                <td style="padding: 12px; text-align: center; border: 1px solid #ddd;">5,000원</td>
                <td style="padding: 12px; text-align: center; border: 1px solid #ddd;">25,000원</td>
            </tr>
        </tbody>
    </table>

    <div style="text-align: right; font-size: 20px; font-weight: bold; color: #2196F3; margin: 20px 0; padding: 15px; background-color: #f0f8ff; border: 1px solid #2196F3; border-radius: 5px;">
        총 결제금액: 175,000원
    </div>

    <div style="text-align: center; margin-top: 40px; padding-top: 20px; border-top: 1px solid #ddd; color: #666; font-size: 12px;">
        <p><strong>이 문서는 데모용으로 생성되었습니다.</strong></p>
        <p>실제 거래명세서는 주문 완료 후 정식으로 발급됩니다.</p>
        <p>문의사항이 있으시면 고객센터로 연락해주세요.</p>
        <p>DEF 요소수 출고주문관리 시스템 | Demo Mode</p>
    </div>
</div>
    ''';
    
    // 미리보기용 HTML blob 생성
    final htmlBlob = html.Blob(['''
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>거래명세서 - ${widget.orderNumber}</title>
</head>
<body>
    $htmlContent
</body>
</html>
    '''], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(htmlBlob);
    
    setState(() {
      _localPath = url;
    });
  }

  /// 모바일 환경용 PDF 생성
  Future<void> _generateMobilePdf() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/demo_statement_${widget.orderNumber}.pdf');

    // pdf 라이브러리를 사용하여 실제 PDF 생성
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 헤더
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      '거래명세서',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text('주문번호: ${widget.orderNumber}'),
                    pw.Text('생성일: ${DateTime.now().toString().substring(0, 19)}'),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 30),
              
              // 주문 정보
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('주문 정보', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      children: [
                        pw.Text('주문번호:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(width: 10),
                        pw.Text(widget.orderNumber),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      children: [
                        pw.Text('주문일시:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(width: 10),
                        pw.Text(DateTime.now().toString().substring(0, 19)),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      children: [
                        pw.Text('상태:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(width: 10),
                        pw.Text('완료'),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      children: [
                        pw.Text('배송방법:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(width: 10),
                        pw.Text('직접배송'),
                      ],
                    ),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 20),
              
              // 제품 테이블
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  // 헤더
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('제품명', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('수량', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('단가', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('금액', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  // 제품 1
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('자바라 (20L)'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('10개'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('15,000원'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('150,000원'),
                      ),
                    ],
                  ),
                  // 제품 2
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('반환 탱크'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('5개'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('5,000원'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('25,000원'),
                      ),
                    ],
                  ),
                ],
              ),
              
              pw.SizedBox(height: 20),
              
              // 총 금액
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  '총 금액: 175,000원',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              
              pw.SizedBox(height: 40),
              
              // 푸터
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      '이 문서는 데모용으로 생성되었습니다.',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.Text(
                      '실제 거래명세서는 주문 완료 후 발급됩니다.',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // PDF 파일 저장
    final bytes = await pdf.save();
    await file.writeAsBytes(bytes);

    setState(() {
      _localPath = file.path;
    });
  }
  
  Future<void> _downloadPdf() async {
    if (_localPath == null) return;

    try {
      if (kIsWeb) {
        // 웹 환경: 브라우저 다운로드
        await _downloadWebPdf();
      } else {
        // 모바일 환경: 기존 방식
        await _downloadMobilePdf();
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

  /// 웹 환경용 PDF 다운로드
  Future<void> _downloadWebPdf() async {
    try {
      // html2pdf 라이브러리 사용 시도
      final html2pdf = js.context['html2pdf'];
      
      if (html2pdf != null) {
        // html2pdf.js로 HTML을 PDF로 변환하여 다운로드
        await _downloadWithHtml2Pdf();
      } else {
        // html2pdf 라이브러리가 없는 경우 기존 방식 사용
        await _fallbackDownload();
      }
      
      if (mounted) {
        GFToast.showToast(
          '거래명세서 PDF가 다운로드되었습니다',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: AppTheme.successColor,
          textStyle: const TextStyle(color: Colors.white, fontSize: 16),
        );
      }
    } catch (e) {
      if (mounted) {
        GFToast.showToast(
          'PDF 다운로드 중 오류가 발생했습니다: ${e.toString()}',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: AppTheme.errorColor,
          textStyle: const TextStyle(color: Colors.white, fontSize: 16),
        );
      }
    }
  }

  /// html2pdf.js를 사용한 PDF 다운로드
  Future<void> _downloadWithHtml2Pdf() async {
    try {
      // PDF 콘텐츠가 없으면 다시 생성
      var element = html.document.getElementById('pdf-content');
      if (element == null) {
        print('PDF 콘텐츠가 없어서 다시 생성합니다.');
        await _createPdfContentElement();
        element = html.document.getElementById('pdf-content');
        
        if (element == null) {
          throw Exception('PDF 콘텐츠를 생성할 수 없습니다');
        }
      }

      print('PDF 콘텐츠 요소 찾음: ${element.innerText?.substring(0, 50)}...');

      // html2pdf 옵션 설정 (A4 크기에 맞게 최적화)
      final options = js.JsObject.jsify({
        'margin': [10, 10, 10, 10],
        'filename': '거래명세서_${widget.orderNumber}.pdf',
        'image': {
          'type': 'jpeg',
          'quality': 0.98
        },
        'html2canvas': {
          'scale': 2,
          'useCORS': true,
          'letterRendering': true,
          'allowTaint': false,
          'height': null,
          'width': null,
          'scrollX': 0,
          'scrollY': 0
        },
        'jsPDF': {
          'unit': 'mm',
          'format': 'a4',
          'orientation': 'portrait'
        }
      });

      print('html2pdf 변환 시작...');

      // Promise 기반 JavaScript 실행을 위한 더 안정적인 방법
      final completer = js.context['Promise'];
      
      // html2pdf 변환 실행
      final convertPromise = js.context.callMethod('eval', ['''
        (function() {
          const element = document.getElementById('pdf-content');
          if (!element) {
            return Promise.reject(new Error('PDF 콘텐츠를 찾을 수 없습니다'));
          }
          
          console.log('html2pdf 변환 시작, 요소 내용:', element.innerHTML.substring(0, 100));
          
          const options = ${js.context['JSON'].callMethod('stringify', [options])};
          
          return html2pdf()
            .set(options)
            .from(element)
            .save()
            .then(() => {
              console.log('html2pdf 변환 완료');
              return 'success';
            })
            .catch((error) => {
              console.error('html2pdf 변환 오류:', error);
              throw error;
            });
        })()
      ''']);

      // Promise 완료까지 기다리기
      await Future.delayed(const Duration(seconds: 5));
      
      print('PDF 다운로드 완료');

    } catch (e) {
      print('html2pdf 실행 중 오류: $e');
      // 오류 발생 시 fallback 다운로드 시도
      await _fallbackDownload();
    }
  }

  /// PDF 콘텐츠 DOM 요소 생성
  Future<void> _createPdfContentElement() async {
    // 기존 요소가 있으면 제거
    final existingElement = html.document.getElementById('pdf-content');
    existingElement?.remove();

    // HTML 콘텐츠 생성
    final htmlContent = '''
<div id="pdf-content" style="width: 210mm; margin: 0 auto; font-family: 'Noto Sans KR', Arial, sans-serif; line-height: 1.6; color: #333; background: white; padding: 20mm; position: relative; z-index: 1000;">
    <div class="header" style="text-align: center; border-bottom: 3px solid #2196F3; padding-bottom: 20px; margin-bottom: 30px;">
        <h1 style="font-size: 28px; margin: 0; color: #2196F3;">거래명세서</h1>
        <p style="margin: 5px 0; color: #666;">Transaction Statement</p>
        <p style="margin: 5px 0; color: #666;">주문번호: ${widget.orderNumber}</p>
        <p style="margin: 5px 0; color: #666;">생성일: ${DateTime.now().toString().substring(0, 19)}</p>
    </div>

    <table style="width: 100%; border-collapse: collapse; margin: 20px 0; border: 1px solid #ddd;">
        <tr>
            <th style="padding: 12px; text-align: left; border: 1px solid #ddd; background-color: #f5f5f5; font-weight: bold; width: 30%;">주문번호</th>
            <td style="padding: 12px; text-align: left; border: 1px solid #ddd;">${widget.orderNumber}</td>
        </tr>
        <tr>
            <th style="padding: 12px; text-align: left; border: 1px solid #ddd; background-color: #f5f5f5; font-weight: bold;">주문일시</th>
            <td style="padding: 12px; text-align: left; border: 1px solid #ddd;">${DateTime.now().toString().substring(0, 19)}</td>
        </tr>
        <tr>
            <th style="padding: 12px; text-align: left; border: 1px solid #ddd; background-color: #f5f5f5; font-weight: bold;">처리상태</th>
            <td style="padding: 12px; text-align: left; border: 1px solid #ddd;">완료</td>
        </tr>
        <tr>
            <th style="padding: 12px; text-align: left; border: 1px solid #ddd; background-color: #f5f5f5; font-weight: bold;">배송방법</th>
            <td style="padding: 12px; text-align: left; border: 1px solid #ddd;">직접배송</td>
        </tr>
        <tr>
            <th style="padding: 12px; text-align: left; border: 1px solid #ddd; background-color: #f5f5f5; font-weight: bold;">고객구분</th>
            <td style="padding: 12px; text-align: left; border: 1px solid #ddd;">데모계정</td>
        </tr>
    </table>

    <h3 style="margin: 30px 0 20px 0; color: #333;">주문 상세 내역</h3>
    <table style="width: 100%; border-collapse: collapse; margin: 20px 0; border: 1px solid #ddd;">
        <thead>
            <tr>
                <th style="padding: 12px; text-align: center; border: 1px solid #ddd; background-color: #2196F3; color: white; font-weight: bold;">제품명</th>
                <th style="padding: 12px; text-align: center; border: 1px solid #ddd; background-color: #2196F3; color: white; font-weight: bold;">수량</th>
                <th style="padding: 12px; text-align: center; border: 1px solid #ddd; background-color: #2196F3; color: white; font-weight: bold;">단가</th>
                <th style="padding: 12px; text-align: center; border: 1px solid #ddd; background-color: #2196F3; color: white; font-weight: bold;">금액</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td style="padding: 12px; text-align: left; border: 1px solid #ddd;">자바라 (20L)</td>
                <td style="padding: 12px; text-align: center; border: 1px solid #ddd;">10개</td>
                <td style="padding: 12px; text-align: center; border: 1px solid #ddd;">15,000원</td>
                <td style="padding: 12px; text-align: center; border: 1px solid #ddd;">150,000원</td>
            </tr>
            <tr>
                <td style="padding: 12px; text-align: left; border: 1px solid #ddd;">반환 탱크</td>
                <td style="padding: 12px; text-align: center; border: 1px solid #ddd;">5개</td>
                <td style="padding: 12px; text-align: center; border: 1px solid #ddd;">5,000원</td>
                <td style="padding: 12px; text-align: center; border: 1px solid #ddd;">25,000원</td>
            </tr>
        </tbody>
    </table>

    <div style="text-align: right; font-size: 20px; font-weight: bold; color: #2196F3; margin: 20px 0; padding: 15px; background-color: #f0f8ff; border: 1px solid #2196F3; border-radius: 5px;">
        총 결제금액: 175,000원
    </div>

    <div style="text-align: center; margin-top: 40px; padding-top: 20px; border-top: 1px solid #ddd; color: #666; font-size: 12px;">
        <p><strong>이 문서는 데모용으로 생성되었습니다.</strong></p>
        <p>실제 거래명세서는 주문 완료 후 정식으로 발급됩니다.</p>
        <p>문의사항이 있으시면 고객센터로 연락해주세요.</p>
        <p>DEF 요소수 출고주문관리 시스템 | Demo Mode</p>
    </div>
</div>
    ''';
    
    // HTML 콘텐츠를 DOM에 추가 (body 끝에 추가하고 숨김 처리)
    final div = html.DivElement()
      ..setInnerHtml(htmlContent, treeSanitizer: html.NodeTreeSanitizer.trusted)
      ..style.position = 'absolute'
      ..style.left = '-9999px'
      ..style.top = '-9999px'
      ..style.zIndex = '-1';
    
    html.document.body?.append(div);
    
    print('PDF 콘텐츠 DOM 요소 생성 완료');
  }

  /// Fallback 다운로드 (HTML 파일)
  Future<void> _fallbackDownload() async {
    final anchor = html.AnchorElement(href: _localPath!)
      ..setAttribute('download', '거래명세서_${widget.orderNumber}.html')
      ..click();
  }

  /// 모바일 환경용 PDF 다운로드
  Future<void> _downloadMobilePdf() async {
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
  }
  
  Future<void> _sharePdf() async {
    if (_localPath == null) return;

    try {
      if (kIsWeb) {
        // 웹 환경: URL 공유
        await _shareWebPdf();
      } else {
        // 모바일 환경: 기존 방식
        await _shareMobilePdf();
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

  /// 웹 환경용 PDF 공유
  Future<void> _shareWebPdf() async {
    try {
      // 웹에서는 다운로드 링크와 함께 공유 정보 생성
      final shareText = '''
거래명세서 공유
주문번호: ${widget.orderNumber}
생성일: ${DateTime.now().toString().substring(0, 19)}

PDF 다운로드는 위의 다운로드 버튼을 클릭하세요.
거래명세서 미리보기: ${_localPath!}
      ''';
      
      // 공유 텍스트를 클립보드에 복사
      await html.window.navigator.clipboard?.writeText(shareText);
      
      if (mounted) {
        GFToast.showToast(
          '거래명세서 공유 정보가 클립보드에 복사되었습니다',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: AppTheme.successColor,
          textStyle: const TextStyle(color: Colors.white, fontSize: 16),
        );
      }
    } catch (e) {
      // Web Share API 사용 시도
      try {
        if (js.context.hasProperty('navigator') && 
            js.context['navigator'].hasProperty('share')) {
          final shareData = js.JsObject.jsify({
            'title': '거래명세서 - ${widget.orderNumber}',
            'text': '거래명세서가 생성되었습니다.',
            'url': _localPath!,
          });
          await js.context['navigator'].callMethod('share', [shareData]);
        } else {
          throw Exception('Web Share API 지원하지 않음');
        }
      } catch (shareError) {
        if (mounted) {
          GFToast.showToast(
            '공유 기능을 사용할 수 없습니다',
            context,
            toastPosition: GFToastPosition.BOTTOM,
            backgroundColor: AppTheme.errorColor,
            textStyle: const TextStyle(color: Colors.white, fontSize: 16),
          );
        }
      }
    }
  }

  /// 모바일 환경용 PDF 공유
  Future<void> _shareMobilePdf() async {
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
  }
}