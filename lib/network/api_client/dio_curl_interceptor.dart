//ignore_for_file: public_member_api_docs
import 'dart:convert';

import 'package:dio/dio.dart';

class DioCUrlInterceptor extends Interceptor {
  final Function(String curl)? onCUrlRequest;
  final Function(String curl, Response response)? onCurlResponse;
  final Function(String curl, DioException error)? onCurlError;
  DioCUrlInterceptor({
    this.onCUrlRequest,
    this.onCurlResponse,
    this.onCurlError,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    onCUrlRequest?.call(_cURLRepresentation(options));
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    onCurlResponse?.call(
        _cURLRepresentation(response.requestOptions), response);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    onCurlError?.call(_cURLRepresentation(err.requestOptions), err);
    super.onError(err, handler);
  }

  String _cURLRepresentation(RequestOptions options) {
    final List<String> components = ['curl -i'];
    if (options.method.toUpperCase() != 'GET') {
      components.add('-X ${options.method}');
    }

    options.headers.forEach((k, v) {
      if (k != 'Cookie') {
        components.add('-H "$k: $v"');
      }
    });

    if (options.data != null) {
      String componentType = '-d';
      // FormData can't be JSON-serialized, so keep only their fields attributes
      if (options.data is FormData) {
        componentType = '-f';
        options.data = Map.fromEntries((options.data as FormData).fields)
          ..addAll(
            Map.fromEntries(
              (options.data as FormData).files.map(
                    (e) => MapEntry(
                      e.key,
                      e.value.filename ?? '',
                    ),
                  ),
            ),
          );
      }

      final data = json.encode(options.data).replaceAll('"', '\\"');
      components.add('$componentType "$data"');
    }

    components.add('"${options.uri.toString()}"');

    return components.join(' \\\n\t');
  }
}
