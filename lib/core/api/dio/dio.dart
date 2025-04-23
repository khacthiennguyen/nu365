
import 'package:dio/dio.dart';
import 'package:nu365/core/api/dio/constants/content_type.dart';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: const String.fromEnvironment("BASE_URL"),
    contentType: ContentType.applicationJson,
    responseType: ResponseType.json,
  ),
);

