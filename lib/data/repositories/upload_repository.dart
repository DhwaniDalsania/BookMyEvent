import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/network/api_client.dart';
import '../../constants/api_constants.dart';

class UploadRepository {
  final Dio _dio = apiClient;

  Future<String> uploadImage(XFile file) async {
    final fileName = file.name;
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    final response = await _dio.post(
      '/uploads/image',
      data: formData,
    );

    final relativeUrl = response.data['imageUrl'] as String;
    return ApiConstants.getFullImageUrl(relativeUrl);
  }
}
