import 'package:flutter/material.dart';
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
import '../widgets/logo_widget.dart';
import '../widgets/mini_player_bar.dart';

const Color kPoint = Color(0xFF4A4A4A); // 포인트 강조 텍스트
const Color kText = Color(0xFF333333); // 기본 텍스트
const Color kIcon = Color(0xFFA0A0A0); // 아이콘/버튼
const Color kInactive = Color(0xFFD0D0D0); // 비활성
const Color kBg = Color(0xFFF5F5F5); // 배경

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
    // 카테고리별 더미 데이터 4권씩
    _books = [
      // 🔥 요즘 사람들 이거 듣더라
      Book(
        sellingBookId: 1,
        title: '불편한 편의점',
        coverUrl: 'cover1.webp',
        authorName: '김호연',
        identificationNumber: '9788954679403',
      ),
      Book(
        sellingBookId: 2,
        title: '달러구트 꿈 백화점',
        coverUrl: 'cover4.jpeg',
        authorName: '이미예',
        identificationNumber: '9788954679404',
      ),
      Book(
        sellingBookId: 3,
        title: '파친코',
        coverUrl: 'cover3.jpg',
        authorName: '이선 몰릭',
        identificationNumber: '9788934972465',
      ),
      Book(
        sellingBookId: 4,
        title: '아몬드',
        coverUrl: 'cover2.jpg',
        authorName: '손원평',
        identificationNumber: '9788936434267',
      ),
      Book(
        sellingBookId: 5,
        title: '용의자 X의 헌신',
        coverUrl: 'test.webp',
        authorName: '히가시노 게이고',
        identificationNumber: '9788990982704',
      ),
      // 📚 노벨문학상이 사랑한 한국어
      Book(
        sellingBookId: 6,
        title: '채식주의자',
        coverUrl: 'cover9.jpeg',
        authorName: '한강',
        identificationNumber: '9788936434268',
      ),
      Book(
        sellingBookId: 7,
        title: '소년이 온다',
        coverUrl: 'cover10.jpeg',
        authorName: '한강',
        identificationNumber: '9788936437559',
      ),
      Book(
        sellingBookId: 8,
        title: '흰',
        coverUrl: 'cover11.jpeg',
        authorName: '한강',
        identificationNumber: '9788936434269',
      ),
      Book(
        sellingBookId: 9,
        title: '작별하지 않는다',
        coverUrl: 'cover12.jpeg',
        authorName: '한강',
        identificationNumber: '9788936434260',
      ),
      // 👶 아이와 함께 듣는 오디오북
      Book(
        sellingBookId: 10,
        title: '강아지똥',
        coverUrl: 'cover5.jpg',
        authorName: '권정생',
        identificationNumber: '9788949112850',
      ),
      Book(
        sellingBookId: 11,
        title: '마당을 나온 암탉',
        coverUrl: 'cover6.jpeg',
        authorName: '황선미',
        identificationNumber: '9788952784360',
      ),
      Book(
        sellingBookId: 12,
        title: '아기돼지 삼형제',
        coverUrl: 'cover7.jpg',
        authorName: '이지수',
        identificationNumber: '9788972591234',
      ),
      Book(
        sellingBookId: 13,
        title: '백설공주',
        coverUrl: 'cover8.jpg',
        authorName: '그림형제',
        identificationNumber: '9788972591241',
      ),
    ];
    _isLoading = false;
    // _fetchBooks(); // 더미 데이터 사용 시 주석 처리
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

  Widget _buildSectionTitle(
    String emoji,
    String title, {
    VoidCallback? onMore,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: kPoint,
              letterSpacing: -1,
            ),
          ),
          const Spacer(),
          if (onMore != null)
            GestureDetector(
              onTap: onMore,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '더보기',
                    style: TextStyle(
                      color: kPoint,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.chevron_right, color: kPoint, size: 18),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHomeBody() {
    // 카테고리별 4권씩 분리
    final trendyBooks = _books.take(5).toList();
    final nobelBooks = _books.skip(5).take(4).toList();
    final kidsBooks = _books.skip(9).take(4).toList();

    return Container(
      color: kBg,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            // 상단 타이틀
            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 8.0),
              child: SizedBox(
                height: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(alignment: Alignment.centerLeft, child: LogoWidget()),
                    Center(
                      child: Text(
                        '글을 말하다',
                        style: const TextStyle(
                          fontFamily: 'AppTitle',
                          fontSize: 32,
                          color: kPoint,
                          letterSpacing: -1.2,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.search, color: kPoint, size: 28),
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 오늘의 명언 (강조된 색감, 화자 추가)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 4.0,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF3E0), // 연한 오렌지
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.format_quote, color: kPoint, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '“내가 세계를 알게 된 것은 책에 의해서였다.”',
                            style: TextStyle(
                              fontSize: 15,
                              color: kText,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '- 사르트르 -',
                          style: TextStyle(
                            color: Color(0xFF4A4A4A),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // 🔥 요즘 사람들 이거 듣더라
            _buildSectionTitle(
              '🔥',
              '요즘, 이 책 모르면 좀 섭섭해요',
              onMore: () {
                print('요즘 사람들 더보기');
              },
            ),
            Container(
              color: const Color(0xFFF7F7F7),
              child: BookListWidget(
                books: trendyBooks,
                onBookTap: (book) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookDetailScreen(book: book),
                    ),
                  );
                },
              ),
            ),
            // 📚 노벨문학상이 사랑한 한국어
            _buildSectionTitle(
              '🏆',
              '노벨이 사랑한 한강의 문장들',
              onMore: () {
                print('노벨문학상 더보기');
              },
            ),
            Container(
              color: const Color(0xFFF3F3F3),
              child: BookListWidget(
                books: nobelBooks,
                onBookTap: (book) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookDetailScreen(book: book),
                    ),
                  );
                },
              ),
            ),
            // 👶 아이와 함께 듣는 오디오북
            _buildSectionTitle(
              '👶',
              '아이와 함께 듣는 오디오북',
              onMore: () {
                print('아이와 함께 더보기');
              },
            ),
            Container(
              color: kBg,
              child: BookListWidget(
                books: kidsBooks,
                onBookTap: (book) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookDetailScreen(book: book),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
      body: Stack(
        children: [
          bodies[_selectedIndex],
          // 하단에 미니 플레이어바 (네비게이션 위)
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: 5, // 네비게이션 바 위에 띄우기
          // child: MiniPlayerBar(),
          // ),
        ],
      ),
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
