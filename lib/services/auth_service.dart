import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import '../constants.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    _dio.interceptors.add(CookieManager(_cookieJar));
  }
  String? _sessionId;
  final Dio _dio = Dio();
  final CookieJar _cookieJar = CookieJar();

  String? get sessionId => _sessionId;
  bool get isLoggedIn => _sessionId != null;
  Dio get dio => _dio;
  CookieJar get cookieJar => _cookieJar;

  /// 회원가입
  Future<int> signup({
    required String id,
    required String password,
    required String name,
    required String email,
  }) async {
    final url = '$baseUrl/api/member/signup';
    final response = await _dio.post(
      url,
      data: {'id': id, 'password': password, 'name': name, 'email': email},
      options: Options(contentType: Headers.jsonContentType),
    );
    if (response.statusCode == 200) {
      return response.data['memberId'] as int;
    } else {
      throw Exception('회원가입 실패');
    }
  }

  /// 로그인
  Future<void> signin({required String id, required String password}) async {
    final url = '$baseUrl/api/member/signin';
    final response = await _dio.post(
      url,
      data: {'id': id, 'password': password},
      options: Options(contentType: Headers.jsonContentType),
    );
    if (response.statusCode == 200) {
      _sessionId = response.data['sessionId'] as String;
    } else {
      throw Exception('로그인 실패');
    }
  }

  /// 로그아웃
  Future<void> signout() async {
    final url = '$baseUrl/api/member/signout';
    await _dio.get(url);
    _sessionId = null;
    await _cookieJar.deleteAll();
  }
}
