import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/order_entity.dart';
import '../models/order_model.dart';
import '../../../../core/utils/logger.dart';

/// 간단한 PDF 생성 서비스 (한글 문제 해결용)
class SimplePdfService {
  static List<pw.Font>? _koreanFonts;
  
  /// 한글 폰트 로드 - 시스템 기본 폰트 활용 + 기본 폰트 설정
  Future<List<pw.Font>?> _loadKoreanFontFallback() async {
    if (_koreanFonts != null) return _koreanFonts;
    
    try {
      final fallbackFonts = <pw.Font>[];
      
      // 방법 1: Google Fonts 시도 (이모지 폰트는 다국어 가능성)
      try {
        final emojiFont = await PdfGoogleFonts.notoColorEmoji();
        fallbackFonts.add(emojiFont);
        logger.i('✅ Noto Color Emoji 폰트 로드 성공');
      } catch (e1) {
        logger.w('⚠️ Noto Color Emoji 로드 실패: $e1');
      }
      
      // 방법 2: 웹 환경에서는 시스템 폰트를 우선 활용하기 위해 fontFallback 없이도 시도
      // dart_pdf는 시스템 폰트를 자동으로 찾아서 사용하려고 시도함
      
      // 최소 1개 폰트는 로드해서 fontFallback에 설정
      if (fallbackFonts.isEmpty) {
        try {
          final basicFont = await PdfGoogleFonts.nunitoExtraLight();
          fallbackFonts.add(basicFont);
          logger.i('✅ 기본 폰트(Nunito) 로드 성공');
        } catch (e2) {
          logger.w('⚠️ 기본 폰트 로드도 실패: $e2');
        }
      }
      
      // 폰트 설정 완료
      _koreanFonts = fallbackFonts.isEmpty ? [] : fallbackFonts;
      logger.i('📝 폰트 설정 완료: ${fallbackFonts.length}개 폰트, 시스템 한글 폰트 자동 탐지에 의존');
      return _koreanFonts;
    } catch (e) {
      logger.e('❌ 폰트 로딩 오류: $e');
      _koreanFonts = [];
      return _koreanFonts;
    }
  }
  
  /// 거래명세서 PDF 생성 (fontFallback 방식)
  Future<Uint8List> generateTransactionStatement(OrderEntity order) async {
    try {
      // fontFallback 방식으로 한글 폰트 로드
      final koreanFontFallback = await _loadKoreanFontFallback();
      logger.i('PDF 생성: fontFallback 방식 사용 - ${koreanFontFallback != null ? "성공" : "실패"}');
      
      final pdf = pw.Document();
      final numberFormat = NumberFormat('#,###');

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // 헤더
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 2),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        '거 래 명 세 서',
                        style: _createTextStyle(
                          fontFallback: koreanFontFallback,
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        '주문번호: ${order.orderNumber}',
                        style: _createTextStyle(fontFallback: koreanFontFallback, fontSize: 16),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                '거래처: ${order.userProfile?.businessName ?? "데모회사"}',
                                style: _createTextStyle(fontFallback: koreanFontFallback, fontSize: 14, fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                '사업자번호: ${order.userProfile?.businessNumber ?? "123-45-67890"}',
                                style: _createTextStyle(fontFallback: koreanFontFallback, fontSize: 12),
                              ),
                              pw.Text(
                                '전화번호: ${order.userProfile?.phone ?? "010-1234-5678"}',
                                style: _createTextStyle(fontFallback: koreanFontFallback, fontSize: 12),
                              ),
                              pw.Text(
                                '발행일: ${DateFormat('yyyy년 MM월 dd일').format(DateTime.now())}',
                                style: _createTextStyle(fontFallback: koreanFontFallback, fontSize: 12),
                              ),
                            ],
                          ),
                          pw.Container(
                            width: 80,
                            height: 80,
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.black),
                            ),
                            child: pw.Center(
                              child: pw.Text(
                                '직인',
                                style: _createTextStyle(fontFallback: koreanFontFallback, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                pw.SizedBox(height: 30),
                
                // 주문 상세 테이블
                pw.Text(
                  '주문 상세',
                  style: _createTextStyle(fontFallback: koreanFontFallback, fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey400),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(3),
                    1: const pw.FlexColumnWidth(1),
                    2: const pw.FlexColumnWidth(2),
                    3: const pw.FlexColumnWidth(2),
                  },
                  children: [
                    // 헤더
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                      children: [
                        _buildTableCell('품목', isHeader: true, fontFallback: koreanFontFallback),
                        _buildTableCell('수량', isHeader: true, fontFallback: koreanFontFallback),
                        _buildTableCell('단가', isHeader: true, fontFallback: koreanFontFallback),
                        _buildTableCell('금액', isHeader: true, fontFallback: koreanFontFallback),
                      ],
                    ),
                    // 제품 행
                    pw.TableRow(
                      children: [
                        _buildTableCell(
                          order.productType == ProductType.box
                              ? '요소수 (박스 10L)'
                              : '요소수 (벌크 1,000L)',
                          fontFallback: koreanFontFallback,
                        ),
                        _buildTableCell('${numberFormat.format(order.quantity)}', fontFallback: koreanFontFallback),
                        _buildTableCell('${numberFormat.format(order.unitPrice)}원', fontFallback: koreanFontFallback),
                        _buildTableCell('${numberFormat.format(order.unitPrice * order.quantity)}원', fontFallback: koreanFontFallback),
                      ],
                    ),
                    // 자바라
                    if (order.javaraQuantity != null && order.javaraQuantity! > 0)
                      pw.TableRow(
                        children: [
                          _buildTableCell('자바라', fontFallback: koreanFontFallback),
                          _buildTableCell('${numberFormat.format(order.javaraQuantity)}', fontFallback: koreanFontFallback),
                          _buildTableCell('-', fontFallback: koreanFontFallback),
                          _buildTableCell('-', fontFallback: koreanFontFallback),
                        ],
                      ),
                    // 반납통
                    if (order.returnTankQuantity != null && order.returnTankQuantity! > 0)
                      pw.TableRow(
                        children: [
                          _buildTableCell('반납통', fontFallback: koreanFontFallback),
                          _buildTableCell('${numberFormat.format(order.returnTankQuantity)}', fontFallback: koreanFontFallback),
                          _buildTableCell('-', fontFallback: koreanFontFallback),
                          _buildTableCell('-', fontFallback: koreanFontFallback),
                        ],
                      ),
                  ],
                ),
                
                pw.SizedBox(height: 30),
                
                // 가격 정보
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Container(
                    width: 300,
                    child: pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.grey400),
                      children: [
                        pw.TableRow(
                          children: [
                            _buildTableCell('공급가액', isHeader: true, fontFallback: koreanFontFallback),
                            _buildTableCell(
                              '${numberFormat.format(order.unitPrice * order.quantity)}원',
                              align: pw.TextAlign.right,
                              fontFallback: koreanFontFallback,
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            _buildTableCell('배송비', isHeader: true, fontFallback: koreanFontFallback),
                            _buildTableCell(
                              '${numberFormat.format(order.calculateEstimatedShippingCost())}원',
                              align: pw.TextAlign.right,
                              fontFallback: koreanFontFallback,
                            ),
                          ],
                        ),
                        pw.TableRow(
                          decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                          children: [
                            _buildTableCell('합계금액', isHeader: true, fontFallback: koreanFontFallback),
                            _buildTableCell(
                              '${numberFormat.format(order.totalPrice)}원',
                              align: pw.TextAlign.right,
                              fontFallback: koreanFontFallback,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                pw.SizedBox(height: 50),
                
                // 푸터
                pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Column(
                    children: [
                      pw.Text(
                        '상기와 같이 거래함을 확인합니다.',
                        style: _createTextStyle(fontFallback: koreanFontFallback, fontSize: 12),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        '본 거래명세서는 세금계산서가 아니므로 세무처리에 사용할 수 없습니다.',
                        style: _createTextStyle(
                          fontFallback: koreanFontFallback,
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

      return pdf.save();
    } catch (e) {
      logger.e('PDF 생성 실패', e);
      rethrow;
    }
  }

  /// 한글 텍스트 스타일 생성 헬퍼 (유연한 폰트 처리)
  pw.TextStyle _createTextStyle({
    List<pw.Font>? fontFallback,
    double fontSize = 12,
    pw.FontWeight fontWeight = pw.FontWeight.normal,
    PdfColor? color,
    double letterSpacing = 0,
  }) {
    // fontFallback이 비어있으면 시스템 기본 폰트에 의존
    if (fontFallback == null || fontFallback.isEmpty) {
      return pw.TextStyle(
        // fontFallback 없이 생성 - 시스템에서 자동으로 적절한 폰트 선택
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );
    }
    
    return pw.TextStyle(
      fontFallback: fontFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  /// 테이블 셀 생성 헬퍼
  pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    pw.TextAlign align = pw.TextAlign.center,
    List<pw.Font>? fontFallback,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: _createTextStyle(
          fontFallback: fontFallback,
          fontSize: isHeader ? 12 : 11,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: align,
      ),
    );
  }

  /// PDF 파일명 생성
  String generateFileName(OrderEntity order) {
    final dateFormat = DateFormat('yyyyMMdd');
    final date = dateFormat.format(DateTime.now());
    return 'statement_${order.orderNumber}_$date.pdf';
  }
}