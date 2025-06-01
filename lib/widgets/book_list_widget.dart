import 'package:flutter/material.dart';
import '../models/book.dart';

/// 가로로 스크롤되는 책 리스트 위젯입니다.
class BookListWidget extends StatelessWidget {
  final List<Book> books;
  final void Function(Book) onBookTap;
  const BookListWidget({
    super.key,
    required this.books,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: books.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final book = books[index];
          return GestureDetector(
            onTap: () => onBookTap(book),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/${book.coverUrl.split('/').last}',
                    width: 110,
                    height: 170,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          width: 110,
                          height: 170,
                          color: Color(0xFFD0D0D0),
                          child: const Icon(Icons.broken_image, size: 40),
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 110,
                  child: Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 110,
                  child: Text(
                    book.authorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF4A4A4A),
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
