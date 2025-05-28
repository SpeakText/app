import 'package:flutter/material.dart';
import '../widgets/logo_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/book_list_widget.dart';
import '../widgets/bottom_nav_bar_widget.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'library_screen.dart';
import 'search_screen.dart';
import 'book_detail_screen.dart';

/// 메인 화면: 로고, 검색바, 책 리스트, 하단 네비게이션 바를 포함합니다.
class MainScreen extends StatefulWidget {
  final BookService bookService;
  final AuthService authService;
  MainScreen({super.key, BookService? bookService, AuthService? authService})
    : bookService = bookService ?? BookService(),
      authService = authService ?? AuthService();

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // 하단 네비게이션 현재 인덱스
  List<Book> _books = []; // 책 리스트
  bool _isLoading = true; // 로딩 상태

  // 마지막 검색 결과와 쿼리 저장
  String? _lastSearchQuery;
  List<Book>? _lastSearchResults;

  late final BookService _bookService;
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _bookService = widget.bookService;
    _authService = widget.authService;
    _fetchBooks();
  }

  /// 책 리스트를 API에서 불러옵니다.
  Future<void> _fetchBooks() async {
    setState(() => _isLoading = true);
    final books = await _bookService.fetchBooks();
    setState(() {
      _books = books;
      _isLoading = false;
    });
  }

  /// 검색어가 변경될 때 호출됩니다.
  void _onSearchChanged(String query) {
    // 실시간 필터링 제거: 아무 동작도 하지 않음
  }

  /// 검색창에서 엔터(Submit) 시 검색 결과 페이지로 이동
  void _onSearchSubmitted(String query) {
    final filteredBooks =
        _books.where((book) {
          final q = query.toLowerCase();
          return book.title.toLowerCase().contains(q) ||
              book.authorName.toLowerCase().contains(q);
        }).toList();
    setState(() {
      _lastSearchQuery = query;
      _lastSearchResults = filteredBooks;
      _selectedIndex = 1; // 검색 탭으로 이동
    });
  }

  /// 로그인/로그아웃 등 인증 상태 변경 시 호출
  void _onAuthChanged() {
    setState(() {});
  }

  Widget _buildHomeBody() {
    // 실시간 필터링 제거: 항상 전체 책 리스트를 보여줌
    final filteredBooks = _books;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단: 로고 + 검색바
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                const LogoWidget(),
                Expanded(
                  child: SearchBarWidget(
                    onChanged: _onSearchChanged,
                    onSubmitted: _onSearchSubmitted,
                  ),
                ),
              ],
            ),
          ),
          // 책 리스트 영역
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              '인기 오디오북',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : BookListWidget(
                books: filteredBooks,
                onBookTap: (book) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookDetailScreen(book: book),
                    ),
                  );
                },
              ),
        ],
      ),
    );
  }

  Widget _buildProfileBody() {
    if (_authService.isLoggedIn) {
      return ProfileScreen(onLogout: _onAuthChanged);
    } else {
      return LoginScreen(onLogin: _onAuthChanged);
    }
  }

  Widget _buildSearchBody() {
    return SearchScreen(
      results: _lastSearchResults ?? [],
      query: _lastSearchQuery ?? '',
      onSearch: (query, filteredBooks) {
        setState(() {
          _lastSearchQuery = query;
          _lastSearchResults = filteredBooks;
        });
      },
      allBooks: _books,
      showNoResultGuide: _lastSearchQuery == null || _lastSearchResults == null,
      onBookTap: (book) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bodies = [
      _buildHomeBody(),
      _buildSearchBody(),
      const LibraryScreen(),
      _buildProfileBody(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: bodies[_selectedIndex],
      bottomNavigationBar: BottomNavBarWidget(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
