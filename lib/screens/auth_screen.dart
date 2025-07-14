import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'main_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoginMode = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      if (_isLoginMode) {
        await _authService.signin(
          id: _idController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await _authService.signup(
          id: _idController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
        );
        await _authService.signin(
          id: _idController.text.trim(),
          password: _passwordController.text,
        );
      }
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            _isLoginMode
                ? '로그인에 실패했습니다. 아이디와 비밀번호를 확인해주세요.'
                : '회원가입에 실패했습니다. 입력 정보를 확인해주세요.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          _isLoginMode ? '로그인' : '회원가입',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Colors.white, width: 2),
                ),
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_errorMessage != null) ...[
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                        ],
                        TextFormField(
                          controller: _idController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            labelText: '아이디',
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.black,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),
                          ),
                          validator:
                              (v) =>
                                  v == null || v.trim().isEmpty
                                      ? '아이디를 입력해주세요'
                                      : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            labelText: '비밀번호',
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.black,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? '비밀번호를 입력해주세요'
                                      : null,
                        ),
                        if (!_isLoginMode) ...[
                          const SizedBox(height: 20),
                          Semantics(
                            label: '이름 입력',
                            textField: true,
                            child: TextFormField(
                              controller: _nameController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              decoration: InputDecoration(
                                labelText: '이름',
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.black,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 16,
                                ),
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.trim().isEmpty
                                          ? '이름을 입력해주세요'
                                          : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Semantics(
                            label: '이메일 입력',
                            textField: true,
                            child: TextFormField(
                              controller: _emailController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              decoration: InputDecoration(
                                labelText: '이메일',
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.black,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 16,
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return '이메일을 입력해주세요';
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v))
                                  return '유효한 이메일 주소를 입력해주세요';
                                return null;
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              elevation: 4,
                            ),
                            onPressed: _isLoading ? null : _handleSubmit,
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.black,
                                            ),
                                      ),
                                    )
                                    : Text(_isLoginMode ? '로그인' : '회원가입'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : () {
                                    setState(() {
                                      _isLoginMode = !_isLoginMode;
                                      _errorMessage = null;
                                    });
                                  },
                          child: Text(
                            _isLoginMode ? '회원가입' : '로그인',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
