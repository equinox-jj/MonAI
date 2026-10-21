import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:monai/core/base/base_remote_data_source.dart';
import 'package:monai/features/profile/data/datasources/endpoint/profile_endpoint.dart';
import 'package:monai/features/profile/data/model/delete_account_request.dart';
import 'package:monai/features/profile/data/model/update_profile_request.dart';
import 'package:monai/features/shared/data/model/me_response.dart';

abstract class ProfileRemoteDataSource {
  Future<MeResponse> updateProfile(UpdateProfileRequest request);

  Future<MeResponse> uploadAvatar(
    Uint8List bytes, {
    required String filename,
    void Function(double progress)? onProgress,
  });

  Future<void> removeAvatar();

  Future<void> deleteAccount(DeleteAccountRequest request);
}

class ProfileRemoteDataSourceImpl extends ProfileRemoteDataSource
    with BaseRemoteDataSource {
  ProfileRemoteDataSourceImpl({required this._dio});

  final Dio _dio;

  @override
  Future<MeResponse> updateProfile(UpdateProfileRequest request) =>
      safeApiCall(() async {
        final response = await _dio.patch<Map<String, dynamic>>(
          ProfileEndpoint.me,
          data: request.toJson(),
        );
        return MeResponse.fromJson(response.data ?? const {});
      });

  @override
  Future<MeResponse> uploadAvatar(
    Uint8List bytes, {
    required String filename,
    void Function(double progress)? onProgress,
  }) => safeApiCall(() async {
    final response = await _dio.put<Map<String, dynamic>>(
      ProfileEndpoint.avatar,
      data: FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: filename),
      }),
      onSendProgress: onProgress == null
          ? null
          : (sent, total) {
              if (total > 0) onProgress(sent / total);
            },
    );
    return MeResponse.fromJson(response.data ?? const {});
  });

  @override
  Future<void> removeAvatar() => safeApiCall(() async {
    await _dio.delete<void>(ProfileEndpoint.avatar);
  });

  @override
  Future<void> deleteAccount(DeleteAccountRequest request) =>
      safeApiCall(() async {
        await _dio.delete<void>(ProfileEndpoint.me, data: request.toJson());
      });
}
