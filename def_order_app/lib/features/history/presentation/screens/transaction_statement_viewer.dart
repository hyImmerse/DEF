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
import '../../../../core/services/web_pdf_service.dart';
import '../../../order/data/models/order_model.dart';
import '../../../order/domain/entities/order_entity.dart';
// UserProfile is imported through OrderEntity

// 웹 환경에서만 dart:html import
import 'dart:html' as html if (dart.library.io) 'dart:io';

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
  
  // 새로운 웹 PDF 서비스
  late final WebPdfService _webPdfService;
  bool _isGeneratingPdf = false;

  @override
  void initState() {
    super.initState();
    // WebPdfService 초기화
    if (kIsWeb) {
      _webPdfService = WebPdfService();
    }
  }
  
  @override
  void dispose() {
    // Blob URL 정리
    if (_localPath != null && kIsWeb) {
      WebPdfService.cleanupUrl(_localPath!);
    }
    super.dispose();
  }
  
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
      ),
      body: statementState.when(
        data: (url) {
          if (url == null) {
            return _buildNoStatementView();
          }
          
          // 데모 모드에서는 Flutter 네이티브 PDF 생성
          if (isDemoMode && _localPath == null) {
            _generateNativeDemoPdf();
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
                  'PDF 생성 중...'.text
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
                  'PDF를 준비하는 중...'.text
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
              
              // 컨트롤 바 (모바일 환경에서만 표시)
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
      // 웹 환경: 간소화된 뷰어
      return _buildWebViewer();
    } else {
      // 모바일 환경: PDF 뷰어 사용
      return _buildPdfViewer();
    }
  }

  /// 웹 뷰어 (간소화된 버전)
  Widget _buildWebViewer() {
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
                    if (_localPath != null)
                      GFButton(
                        onPressed: () {
                          try {
                            // 새 탭에서 PDF 열기
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
                      onPressed: _isGeneratingPdf ? null : () => _downloadNativePdf(),
                      text: _isGeneratingPdf ? 'PDF 생성 중...' : 'PDF 다운로드',
                      size: 32,
                      color: Colors.green[600]!,
                      textStyle: const TextStyle(fontSize: 11, color: Colors.white),
                      icon: _isGeneratingPdf 
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.picture_as_pdf, size: 16, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 간소화된 미리보기 영역
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

  /// Flutter 네이티브 PDF 생성 (데모용)
  Future<void> _generateNativeDemoPdf() async {
    if (_isGeneratingPdf) return;
    
    try {
      setState(() {
        _isGeneratingPdf = true;
      });
      
      // 1초 지연으로 실제 생성 느낌 연출
      await Future.delayed(const Duration(seconds: 1));
      
      // 데모용 주문 엔터티 생성
      final demoOrder = _createDemoOrderEntity();
      
      // 웹 환경과 모바일 환경 구분
      if (kIsWeb) {
        // 웹 환경: 새로운 WebPdfService 사용
        final previewUrl = await _webPdfService.generatePreviewUrl(demoOrder);
        setState(() {
          _localPath = previewUrl;
          _isGeneratingPdf = false;
        });
      } else {
        // 모바일 환경: 기존 방식 유지
        await _generateMobilePdf();
      }
    } catch (e) {
      setState(() {
        _isGeneratingPdf = false;
      });
      
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
  
  /// 데모용 주문 엔터티 생성
  OrderEntity _createDemoOrderEntity() {
    return OrderEntity(
      id: widget.orderId,
      orderNumber: widget.orderNumber,
      userId: 'demo-user',
      productType: ProductType.box,
      quantity: 10,
      unitPrice: 15000.0,
      totalPrice: 175000.0,
      deliveryDate: DateTime.now().add(const Duration(days: 1)),
      deliveryMethod: DeliveryMethod.delivery,
      status: OrderStatus.completed,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      javaraQuantity: 5,
      returnTankQuantity: 2,
      userProfile: const UserProfile(
        id: 'demo-user-id',
        businessName: '데모회사',
        businessNumber: '123-45-67890',
        representativeName: '홍길동',
        phone: '010-1234-5678',
        email: 'demo@example.com',
        grade: '대리점',
        status: 'active',
      ),
      deliveryAddress: const DeliveryAddress(
        id: 'demo-address-id',
        name: '데모 배송지',
        address: '경기도 김포시 고촌읍 아라육로 16',
        postalCode: '10000',
        phone: '010-1234-5678',
      ),
    );
  }

  /// Flutter 네이티브 PDF 다운로드
  Future<void> _downloadNativePdf() async {
    if (_isGeneratingPdf) return;
    
    try {
      setState(() {
        _isGeneratingPdf = true;
      });
      
      if (kIsWeb) {
        // 웹 환경: 새로운 WebPdfService 사용
        final demoOrder = _createDemoOrderEntity();
        await _webPdfService.generateAndDownloadPdf(
          order: demoOrder,
          autoDownload: true,
        );
        
        if (mounted) {
          GFToast.showToast(
            'PDF 다운로드가 시작되었습니다',
            context,
            toastPosition: GFToastPosition.BOTTOM,
            backgroundColor: AppTheme.successColor,
            textStyle: const TextStyle(color: Colors.white, fontSize: 16),
          );
        }
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
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingPdf = false;
        });
      }
    }
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
      _isGeneratingPdf = false;
    });
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
}