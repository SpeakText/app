import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../constants.dart';

/// 책 정보를 API에서 가져오는 서비스 클래스입니다.
class BookService {
  static final BookService _instance = BookService._internal();
  factory BookService({Dio? dio}) {
    if (dio != null) _instance._dio = dio;
    return _instance;
  }
  BookService._internal();
  Dio _dio = Dio();

  Dio get dio => _dio;

  /// /api/selling-book 엔드포인트에서 책 리스트를 받아옵니다.
  Future<List<Book>> fetchBooks() async {
    try {
      final url = '$baseUrl/api/selling-book';
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (kDebugMode) {
          debugPrint('서버에서 받아온 책 목록: $data');
        }
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('책 목록을 불러오지 못했습니다');
      }
    } catch (e) {
      throw Exception('네트워크 오류: $e');
    }
  }
}
