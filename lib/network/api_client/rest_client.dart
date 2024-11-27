import 'dart:developer';
import 'dart:io';

import 'package:demo/network/model/demo.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import 'dio_curl_interceptor.dart';

part 'rest_client.g.dart';

final interceptor = DioCUrlInterceptor(
  onCurlError: (curl, error) {
    log('🌍 RestClient curl:\n=====BEGIN====\n\t$curl\n====END====\n');
    log('⛔️ RestClient error:\n====BEGIN====\n\t$error\n${error.response}\n====END====\n');
  },
  onCurlResponse: (curl, response) {
    log('🌍 RestClient curl:\n=====BEGIN====\n\t$curl\n====END====\n');
    log('✅ RestClient response:\n====BEGIN====\n\t$response\n====END====\n');
  },
);

final baseDio = Dio()..interceptors.add(interceptor);

@RestApi(baseUrl: 'https://pub.dev')
abstract class AuthRestClient {
  factory AuthRestClient._(Dio dio, {String? baseUrl}) = _AuthRestClient;

  static AuthRestClient getDefaultInstance() {
    return AuthRestClient._(
      baseDio,
    );
  }

  @POST("/login")
  Future<HttpResponse<LoginResponse>> login({
    @Body() required LoginRequest request,
  });

  @POST("/register")
  Future<HttpResponse> register({
    @Body() required LoginRequest request,
  });

  @GET("/get/list")
  Future<HttpResponse> lisData();

  @POST("/send-photo")
  @MultiPart()
  Future<HttpResponse> sendPhoto(@Part() File file);
}
