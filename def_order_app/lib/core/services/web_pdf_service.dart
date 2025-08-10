import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../../features/order/domain/entities/order_entity.dart';
import '../../features/order/data/services/pdf_service.dart';
import '../../features/order/data/services/pdf_service_simple.dart';
import '../utils/logger.dart';

// 웹 환경에서만 dart:html import
import 'dart:html' as html;
import 'dart:convert';

/// Flutter 네이티브 PDF 생성을 위한 웹 전용 서비스
/// html2canvas를 사용하지 않고 dart_pdf 패키지로 직접 PDF를 생성하고 다운로드
class WebPdfService {
  final SimplePdfService _pdfService;
  
  WebPdfService({SimplePdfService? pdfService}) : _pdfService = pdfService ?? SimplePdfService();

  /// 웹 환경에서 PDF 생성 및 다운로드
  Future<String> generateAndDownloadPdf({
    required OrderEntity order,
    bool autoDownload = true,
  }) async {
    if (!kIsWeb) {
      throw UnsupportedError('WebPdfService는 웹 환경에서만 사용할 수 있습니다');
    }

    try {
      logger.i('웹 환경 PDF 생성 시작: ${order.orderNumber}');
      
      // 1. dart_pdf 패키지로 PDF 바이트 생성
      final pdfBytes = await _pdfService.generateTransactionStatement(order);
      final fileName = _pdfService.generateFileName(order);
      
      logger.i('PDF 바이트 생성 완료: ${pdfBytes.length} bytes');
      
      // 2. 웹 환경용 다운로드 처리
      final downloadUrl = await _createWebDownloadUrl(
        pdfBytes: pdfBytes,
        fileName: fileName,
      );
      
      // 3. 자동 다운로드 실행 (옵션)
      if (autoDownload) {
        await _triggerWebDownload(downloadUrl, fileName);
      }
      
      logger.i('웹 PDF 다운로드 완료: $fileName');
      return downloadUrl;
      
    } catch (e) {
      logger.e('웹 PDF 생성/다운로드 실패', e);
      rethrow;
    }
  }

  /// PDF 미리보기용 Blob URL 생성
  Future<String> generatePreviewUrl(OrderEntity order) async {
    if (!kIsWeb) {
      throw UnsupportedError('WebPdfService는 웹 환경에서만 사용할 수 있습니다');
    }

    try {
      logger.i('웹 환경 PDF 미리보기 생성: ${order.orderNumber}');
      
      // dart_pdf로 PDF 바이트 생성
      final pdfBytes = await _pdfService.generateTransactionStatement(order);
      
      // Blob URL 생성 (다운로드 트리거 없이)
      final downloadUrl = await _createWebDownloadUrl(
        pdfBytes: pdfBytes,
        fileName: _pdfService.generateFileName(order),
        createBlobUrl: true,
      );
      
      logger.i('웹 PDF 미리보기 URL 생성 완료');
      return downloadUrl;
      
    } catch (e) {
      logger.e('웹 PDF 미리보기 생성 실패', e);
      rethrow;
    }
  }

  /// 웹 환경용 다운로드 URL 생성
  Future<String> _createWebDownloadUrl({
    required Uint8List pdfBytes,
    required String fileName,
    bool createBlobUrl = false,
  }) async {
    try {
      if (createBlobUrl) {
        // Blob URL 생성 (브라우저에서 열기용)
        final blob = html.Blob([pdfBytes], 'application/pdf');
        final url = html.Url.createObjectUrl(blob);
        return url;
      } else {
        // Data URL 생성 (다운로드용)
        final base64String = base64Encode(pdfBytes);
        final dataUrl = 'data:application/pdf;base64,$base64String';
        return dataUrl;
      }
    } catch (e) {
      logger.e('웹 다운로드 URL 생성 실패', e);
      rethrow;
    }
  }

  /// 웹 브라우저에서 PDF 다운로드 트리거
  Future<void> _triggerWebDownload(String downloadUrl, String fileName) async {
    try {
      // HTMLAnchorElement를 사용한 다운로드 트리거
      final anchor = html.AnchorElement()
        ..href = downloadUrl
        ..download = fileName
        ..style.display = 'none';
      
      // 문서에 추가하고 클릭 후 제거
      html.document.body?.children.add(anchor);
      anchor.click();
      
      // 약간의 지연 후 요소 제거
      Future.delayed(const Duration(milliseconds: 100), () {
        anchor.remove();
      });
      
      logger.i('웹 다운로드 트리거 완료: $fileName');
      
    } catch (e) {
      logger.e('웹 다운로드 트리거 실패', e);
      rethrow;
    }
  }

  /// 기존 Blob URL 정리
  static void cleanupUrl(String url) {
    if (kIsWeb && url.startsWith('blob:')) {
      try {
        html.Url.revokeObjectUrl(url);
      } catch (e) {
        logger.w('Blob URL 정리 실패: $e');
      }
    }
  }

  /// 웹 환경 확인
  static bool get isSupported => kIsWeb;

  /// 브라우저 PDF 지원 확인
  static bool get isPdfViewerSupported {
    if (!kIsWeb) return false;
    
    try {
      // PDF MIME type 지원 확인
      final navigator = html.window.navigator;
      final mimeTypes = navigator.mimeTypes;
      
      // PDF 플러그인 확인
      for (int i = 0; i < mimeTypes!.length; i++) {
        final mimeType = mimeTypes[i];
        if (mimeType!.type == 'application/pdf') {
          return true;
        }
      }
      
      // 기본적으로 모던 브라우저는 PDF 지원
      return true;
    } catch (e) {
      logger.w('PDF 뷰어 지원 확인 실패: $e');
      return true; // 확인 실패 시 지원한다고 가정
    }
  }
}