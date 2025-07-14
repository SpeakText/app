import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import 'settings_screen.dart';
import 'book_detail_screen.dart';
import '../services/book_download_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final BookService _bookService = BookService();
  final BookDownloadService _downloadService = BookDownloadService();
  List<Book> _books = [];
  bool _isLoading = true;
  String? _error;
  final Map<int, bool> _downloadedMap = {};
  int? _selectedBookIndex;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  /// 책 목록을 로드합니다
  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final books = await _bookService.fetchBooks();
      setState(() {
        _books = books;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  /// 설정 화면으로 이동
  Future<void> _navigateToSettings() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SettingsScreen()));

    // 설정 화면에서 돌아올 때 상태 업데이트
    setState(() {});
  }

  /// 책 선택 시 호출되는 함수
  void _onBookSelected(Book book) {
    // 책 상세 화면으로 이동
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => BookDetailScreen(book: book)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          '글을 말하다',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
            shadows: [
              Shadow(
                color: Colors.black54,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        actions: [
          Semantics(
            label: '설정',
            hint: '설정 화면으로 이동합니다',
            button: true,
            child: IconButton(
              onPressed: _navigateToSettings,
              icon: const Icon(Icons.settings, color: Colors.white, size: 32),
              tooltip: '설정',
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black, // 배경 검정색
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    if (_error != null) {
      return Center(
        child: Text(
          '문제가 발생했습니다: $_error',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    if (_books.isEmpty) {
      return const Center(
        child: Text('책이 없습니다', style: TextStyle(color: Colors.white)),
      );
    }
    return Semantics(
      label: '오디오북 리스트입니다.',
      child: ListView.builder(
        itemCount: _books.length,
        itemBuilder: (context, index) {
          final book = _books[index];
          return Card(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              leading: const Icon(Icons.book, color: Colors.white, size: 36),
              title: Text(
                book.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              subtitle: Text(
                '저자: ${book.authorName}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 24,
              ),
              onTap: () => _onBookSelected(book),
              selected: _selectedBookIndex == index,
              selectedTileColor: Colors.white10,
            ),
          );
        },
      ),
    );
  }
}
