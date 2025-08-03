import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';

/// Supabase Storage 서비스
class StorageService {
  final SupabaseClient _supabase;
  static const String _bucketName = 'transaction-statements';
  
  StorageService({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client;

  /// PDF 파일 업로드
  Future<String> uploadPdf({
    required Uint8List pdfData,
    required String fileName,
    required String userId,
  }) async {
    try {
      final path = '$userId/$fileName';
      
      // Storage에 파일 업로드
      final response = await _supabase.storage
          .from(_bucketName)
          .uploadBinary(
            path,
            pdfData,
            fileOptions: const FileOptions(
              contentType: 'application/pdf',
              upsert: true,
            ),
          );

      logger.i('PDF 업로드 성공: $path');
      
      // 공개 URL 생성
      final publicUrl = _supabase.storage
          .from(_bucketName)
          .getPublicUrl(path);
      
      return publicUrl;
    } on StorageException catch (e) {
      logger.e('PDF 업로드 실패', e);
      throw ServerException(message: 'PDF 업로드에 실패했습니다: ${e.message}');
    } catch (e) {
      logger.e('예상치 못한 오류', e);
      throw ServerException(message: 'PDF 업로드 중 오류가 발생했습니다');
    }
  }

  /// PDF 파일 다운로드
  Future<Uint8List> downloadPdf({
    required String fileName,
    required String userId,
  }) async {
    try {
      final path = '$userId/$fileName';
      
      final response = await _supabase.storage
          .from(_bucketName)
          .download(path);
      
      logger.i('PDF 다운로드 성공: $path');
      return response;
    } on StorageException catch (e) {
      logger.e('PDF 다운로드 실패', e);
      throw ServerException(message: 'PDF 다운로드에 실패했습니다: ${e.message}');
    } catch (e) {
      logger.e('예상치 못한 오류', e);
      throw ServerException(message: 'PDF 다운로드 중 오류가 발생했습니다');
    }
  }

  /// PDF 파일 삭제
  Future<void> deletePdf({
    required String fileName,
    required String userId,
  }) async {
    try {
      final path = '$userId/$fileName';
      
      await _supabase.storage
          .from(_bucketName)
          .remove([path]);
      
      logger.i('PDF 삭제 성공: $path');
    } on StorageException catch (e) {
      logger.e('PDF 삭제 실패', e);
      throw ServerException(message: 'PDF 삭제에 실패했습니다: ${e.message}');
    } catch (e) {
      logger.e('예상치 못한 오류', e);
      throw ServerException(message: 'PDF 삭제 중 오류가 발생했습니다');
    }
  }

  /// PDF 파일 목록 조회
  Future<List<FileObject>> listPdfs({required String userId}) async {
    try {
      final response = await _supabase.storage
          .from(_bucketName)
          .list(path: userId);
      
      logger.i('PDF 목록 조회 성공: ${response.length}개');
      return response;
    } on StorageException catch (e) {
      logger.e('PDF 목록 조회 실패', e);
      throw ServerException(message: 'PDF 목록 조회에 실패했습니다: ${e.message}');
    } catch (e) {
      logger.e('예상치 못한 오류', e);
      throw ServerException(message: 'PDF 목록 조회 중 오류가 발생했습니다');
    }
  }

  /// 서명된 URL 생성 (임시 다운로드 링크)
  Future<String> createSignedUrl({
    required String fileName,
    required String userId,
    int expiresIn = 3600, // 1시간
  }) async {
    try {
      final path = '$userId/$fileName';
      
      final signedUrl = await _supabase.storage
          .from(_bucketName)
          .createSignedUrl(path, expiresIn);
      
      logger.i('서명된 URL 생성 성공: $path');
      return signedUrl;
    } on StorageException catch (e) {
      logger.e('서명된 URL 생성 실패', e);
      throw ServerException(message: '다운로드 링크 생성에 실패했습니다: ${e.message}');
    } catch (e) {
      logger.e('예상치 못한 오류', e);
      throw ServerException(message: '다운로드 링크 생성 중 오류가 발생했습니다');
    }
  }
}