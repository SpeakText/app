import 'package:flutter/material.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/book_list_widget.dart';
import '../models/book.dart';

/// 검색 결과 화면
class SearchScreen extends StatefulWidget {
  final List<Book> results;
  final String query;
  final void Function(String, List<Book>) onSearch;
  final List<Book> allBooks;
  final bool showNoResultGuide;
  final void Function(Book) onBookTap;

  const SearchScreen({
    super.key,
    required this.results,
    required this.query,
    required this.onSearch,
    required this.allBooks,
    required this.onBookTap,
    this.showNoResultGuide = false,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _controller;
  late List<Book> _results;
  late String _query;

  @override
  void initState() {
    super.initState();
    _query = widget.query;
    _controller = TextEditingController(text: _query);
    _results = widget.results;
  }

  void _onSearch(String query) {
    final q = query.trim().toLowerCase();
    final filtered =
        widget.allBooks.where((book) {
          return book.title.toLowerCase().contains(q) ||
              book.authorName.toLowerCase().contains(q);
        }).toList();
    setState(() {
      _query = query;
      _results = filtered;
      _controller.text = query;
    });
    widget.onSearch(query, filtered);
  }

  @override
  void didUpdateWidget(covariant SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _query) {
      _query = widget.query;
      _controller.text = _query;
      _results = widget.results;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 12.0,
            ),
            child: SearchBarWidget(
              controller: _controller,
              onSubmitted: _onSearch,
              onChanged: (v) {}, // 실시간 검색 미사용
            ),
          ),
          if (widget.showNoResultGuide)
            const Expanded(
              child: Center(
                child: Text(
                  '검색어를 입력해 책을 찾아보세요.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            )
          else if (_results.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  '검색 결과가 없습니다.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: BookListWidget(
                  books: _results,
                  onBookTap: widget.onBookTap,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
