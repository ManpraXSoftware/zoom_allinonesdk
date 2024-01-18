import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';
import 'package:zoom_allinonesdk/constants/zoom_constants.dart';

class ZoomProvider {
  final Dio dio = Dio();

  ZoomProvider() {
    dio.interceptors.add(HttpFormatter(
        includeRequest: false,
        includeRequestHeaders: false,
        includeRequestQueryParams: true,
        includeResponse: false,
        includeResponseHeaders: false,
        includeResponseBody: true));
  }

  Future<Response> getAccessToken(
      {required String clientId,
      required String clientSecret,
      required String accountId}) async {
    final encoded = base64Url.encode(utf8.encode("$clientId:$clientSecret"));

    final url = ZoomConstants.authTokenUrl + accountId;

    final options = Options(
      headers: {
        "Authorization": "Basic $encoded",
      },
    );

    final data = {'client_id': clientId};

    try {
      final response = await dio.post(url, options: options, data: data);
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Something went wrong... ${e.message}');
      } else {
        throw Exception('Failed to log in: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<Response> getZAKToken(
      {required String clientId,
      required String clientSecret,
      required String accessToken}) async {
    const url = ZoomConstants.zakTokenUrl;

    final options = Options(
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    try {
      final response = await dio.get(url, options: options);

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Something went wrong... ${e.message}');
      } else {
        throw Exception('Failed to log in: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
