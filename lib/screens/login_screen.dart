import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../services/auth_service.dart';
import '../constants.dart';
import '../utils/ui_utils.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLogin;
  const LoginScreen({super.key, this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  String _loginId = '';
  String _loginPassword = '';
  String _signupId = '';
  String _signupPassword = '';
  String _signupName = '';
  String _signupEmail = '';
  bool _isLogin = true;
  bool _loading = false;
  String? _error;

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _error = null;
    });
  }

  Future<void> _submitLogin() async {
    if (!_loginFormKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _authService.signin(id: _loginId, password: _loginPassword);
      widget.onLogin?.call();
      final cookies = await _authService.cookieJar.loadForRequest(
        Uri.parse(baseUrl),
      );
      print('저장된 쿠키: $cookies');
    } on DioException catch (e) {
      String msg = '로그인에 실패했습니다. 아이디와 비밀번호를 확인하세요.';
      if (e.response != null &&
          e.response?.data is Map &&
          e.response?.data['message'] != null) {
        msg = e.response?.data['message'];
      }
      setState(() {
        _error = msg;
      });
    } catch (e) {
      setState(() {
        _error = '알 수 없는 오류가 발생했습니다.';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _submitSignup() async {
    if (!_signupFormKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _authService.signup(
        id: _signupId,
        password: _signupPassword,
        name: _signupName,
        email: _signupEmail,
      );
      setState(() {
        _isLogin = true;
      });
      showAppSnackBar(context, '회원가입 성공! 로그인 해주세요.');
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? '로그인' : '회원가입')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_error != null) ...[
                Text(_error!, style: const TextStyle(color: Color(0xFFD32F2F))),
                const SizedBox(height: 12),
              ],
              if (_isLogin)
                Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: '아이디'),
                        onChanged: (v) => _loginId = v,
                        validator:
                            (v) => v == null || v.isEmpty ? '아이디를 입력하세요' : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: '비밀번호'),
                        obscureText: true,
                        onChanged: (v) => _loginPassword = v,
                        validator:
                            (v) =>
                                v == null || v.isEmpty ? '비밀번호를 입력하세요' : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loading ? null : _submitLogin,
                        child:
                            _loading
                                ? const CircularProgressIndicator()
                                : const Text('로그인'),
                      ),
                      TextButton(
                        onPressed: _loading ? null : _toggleMode,
                        child: const Text('회원가입'),
                      ),
                    ],
                  ),
                )
              else
                Form(
                  key: _signupFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: '아이디'),
                        onChanged: (v) => _signupId = v,
                        validator:
                            (v) => v == null || v.isEmpty ? '아이디를 입력하세요' : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: '비밀번호'),
                        obscureText: true,
                        onChanged: (v) => _signupPassword = v,
                        validator:
                            (v) =>
                                v == null || v.isEmpty ? '비밀번호를 입력하세요' : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: '이름'),
                        onChanged: (v) => _signupName = v,
                        validator:
                            (v) => v == null || v.isEmpty ? '이름을 입력하세요' : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: '이메일'),
                        onChanged: (v) => _signupEmail = v,
                        validator:
                            (v) => v == null || v.isEmpty ? '이메일을 입력하세요' : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loading ? null : _submitSignup,
                        child:
                            _loading
                                ? const CircularProgressIndicator()
                                : const Text('회원가입'),
                      ),
                      TextButton(
                        onPressed: _loading ? null : _toggleMode,
                        child: const Text('로그인'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
