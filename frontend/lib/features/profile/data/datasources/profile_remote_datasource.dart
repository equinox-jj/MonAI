import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:monai/core/data/base_remote_data_source.dart';
import 'package:monai/features/profile/data/datasources/endpoint/profile_endpoint.dart';
import 'package:monai/features/profile/data/model/delete_account_request.dart';
import 'package:monai/features/profile/data/model/update_profile_request.dart';
import 'package:monai/features/shared/data/model/me_response.dart';

abstract class ProfileRemoteDataSource {
  /// `PATCH /me`.
  Future<MeResponse> updateProfile(UpdateProfileRequest request);

  /// `PUT /me/avatar`, multipart `file`. [onProgress] gets the share sent,
  /// 0 to 1.
  Future<MeResponse> uploadAvatar(
    Uint8List bytes, {
    required String filename,
    void Function(double progress)? onProgress,
  });

  /// `DELETE /me/avatar`.
  Future<void> removeAvatar();

  /// `DELETE /me`.
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
