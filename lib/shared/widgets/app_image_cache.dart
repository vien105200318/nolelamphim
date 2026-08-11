import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Singleton CacheManager dùng chung cho mọi `CachedNetworkImage`.
///
/// Lý do tồn tại: trên iOS, `cached_network_image` mặc định bị "kẹt mãi ở
/// placeholder" (poster không hiện) — gốc rễ nằm ở flutter_cache_manager:
///  1. HttpFileService dùng http client nội bộ (package http) dễ treo khi
///     ảnh qua Cloudflare/CDN (github issue #766).
///  2. Repo metadata mặc định là sqflite trên iOS.
///
/// Fix: dùng chung 1 CacheManager với
///   - `repo: JsonCacheInfoRepository` (metadata JSON, không dùng sqlite)
///   - `fileService: DioFileService` — tải ảnh bằng Dio, cùng stack gọi API
///     đã hoạt động tốt trên thiết bị.
class AppImageCache {
  AppImageCache._();

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.bytes,
    ),
  );

  static final CacheManager _cache = CacheManager(
    Config(
      'appImageCache',
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 1000,
      repo: JsonCacheInfoRepository(databaseName: 'appImageCache'),
      fileService: DioFileService(_dio),
    ),
  );

  static CacheManager get instance => _cache;
}

/// Tải file ảnh bằng Dio thay cho http client mặc định của flutter_cache_manager.
class DioFileService extends FileService {
  final Dio _dio;

  DioFileService(this._dio);

  @override
  Future<FileServiceResponse> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    final response = await _dio.get<List<int>>(
      url,
      options: Options(
        headers: headers,
        responseType: ResponseType.bytes,
        // Cho phép 304 (Not Modified — dùng chung cơ chế eTag) đi qua.
        validateStatus: (status) => status != null && status < 400,
      ),
    );
    return _DioFileServiceResponse(response);
  }
}

class _DioFileServiceResponse implements FileServiceResponse {
  final Response<List<int>> _response;
  final DateTime _receivedTime = DateTime.now();

  _DioFileServiceResponse(this._response);

  @override
  Stream<List<int>> get content => Stream.value(_response.data ?? const []);

  @override
  int? get contentLength => _response.data?.length;

  @override
  int get statusCode => _response.statusCode ?? 0;

  @override
  DateTime get validTill {
    var ageDuration = const Duration(days: 7);
    final cacheControl = _response.headers.value('cache-control');
    if (cacheControl != null) {
      for (final setting in cacheControl.split(',')) {
        final s = setting.trim().toLowerCase();
        if (s == 'no-cache') {
          ageDuration = Duration.zero;
        } else if (s.startsWith('max-age=')) {
          final seconds = int.tryParse(s.split('=')[1]);
          if (seconds != null && seconds > 0) {
            ageDuration = Duration(seconds: seconds);
          }
        }
      }
    }
    return _receivedTime.add(ageDuration);
  }

  @override
  String? get eTag => _response.headers.value('etag');

  @override
  String get fileExtension {
    final contentType = _response.headers.value('content-type');
    final mime = contentType?.split(';').first.trim() ?? 'image/jpeg';
    return switch (mime) {
      'image/png' => '.png',
      'image/webp' => '.webp',
      'image/gif' => '.gif',
      _ => '.jpg',
    };
  }
}
