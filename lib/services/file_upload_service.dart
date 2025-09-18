// lib/services/file_upload_service.dart - UPDATED FOR YOUR API
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class FileUploadResult {
  final bool success;
  final String? imageUrl;
  final String? error;

  FileUploadResult({required this.success, this.imageUrl, this.error});
}

class FileUploadService {
  // ✅ Updated to use your API structure
  static String get uploadEndpoint => '${ApiConfig.baseUrl}/api/v1/upload/image/';

  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Upload single image file (mobile)
  static Future<FileUploadResult> uploadImage(File imageFile) async {
    try {
      print('📤 [FileUpload] Uploading image: ${imageFile.path}');
      
      final token = await _getAuthToken();
      if (token == null) {
        return FileUploadResult(success: false, error: 'Authentication required');
      }
      
      final dio = Dio();
      final fileName = imageFile.path.split('/').last;
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: DioMediaType.parse(mimeType),
        ),
      });

      final response = await dio.post(
        uploadEndpoint,
        data: formData,
        options: Options(
          headers: ApiConfig.authHeaders(token),
        ),
      );

      print('📥 [FileUpload] Upload response: ${response.statusCode}');
      print('📄 [FileUpload] Upload response body: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse your API response format
        final responseData = response.data;
        String? imageUrl;
        
        if (responseData is Map<String, dynamic>) {
          if (responseData['success'] == true) {
            imageUrl = responseData['data']?['image_url'] ?? 
                       responseData['data']?['url'] ?? 
                       responseData['image_url'];
          } else {
            imageUrl = responseData['image_url'] ?? 
                       responseData['url'] ?? 
                       responseData['data']?['image_url'];
          }
        }
        
        if (imageUrl != null) {
          print('✅ [FileUpload] Image uploaded successfully: $imageUrl');
          return FileUploadResult(success: true, imageUrl: imageUrl);
        } else {
          print('⚠️ [FileUpload] Upload succeeded but no URL in response');
          return FileUploadResult(success: false, error: 'No image URL in response');
        }
      } else {
        print('❌ [FileUpload] Upload failed: ${response.statusCode}');
        return FileUploadResult(success: false, error: 'Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [FileUpload] Exception: $e');
      return FileUploadResult(success: false, error: 'Upload error: $e');
    }
  }

  // Upload image from web (Uint8List)
  static Future<FileUploadResult> uploadWebImage(Uint8List imageBytes, String fileName) async {
    try {
      print('📤 [FileUpload] Uploading web image: $fileName');
      
      final token = await _getAuthToken();
      if (token == null) {
        return FileUploadResult(success: false, error: 'Authentication required');
      }
      
      final dio = Dio();
      final mimeType = lookupMimeType(fileName) ?? 'image/jpeg';
      
      FormData formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          imageBytes,
          filename: fileName,
          contentType: DioMediaType.parse(mimeType),
        ),
      });

      final response = await dio.post(
        uploadEndpoint,
        data: formData,
        options: Options(
          headers: ApiConfig.authHeaders(token),
        ),
      );

      print('📥 [FileUpload] Web upload response: ${response.statusCode}');
      print('📄 [FileUpload] Web upload response body: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        String? imageUrl;
        
        if (responseData is Map<String, dynamic>) {
          if (responseData['success'] == true) {
            imageUrl = responseData['data']?['image_url'] ?? 
                       responseData['data']?['url'] ?? 
                       responseData['image_url'];
          } else {
            imageUrl = responseData['image_url'] ?? 
                       responseData['url'] ?? 
                       responseData['data']?['image_url'];
          }
        }
        
        if (imageUrl != null) {
          print('✅ [FileUpload] Web image uploaded successfully: $imageUrl');
          return FileUploadResult(success: true, imageUrl: imageUrl);
        } else {
          return FileUploadResult(success: false, error: 'No image URL in response');
        }
      } else {
        print('❌ [FileUpload] Web upload failed: ${response.statusCode}');
        return FileUploadResult(success: false, error: 'Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [FileUpload] Web upload exception: $e');
      return FileUploadResult(success: false, error: 'Upload error: $e');
    }
  }
}
