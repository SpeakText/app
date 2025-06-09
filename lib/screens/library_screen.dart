import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'audio_player_screen.dart';

/// 라이브러리 화면: 다운로드된 오디오북 리스트 (책 정보 기반)
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<Map<String, dynamic>> _books = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() => _loading = true);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/library.json');
    print('library.json path: ${file.path}');
    if (await file.exists()) {
      print('library.json exists');
      final content = await file.readAsString();
      print(
        'library.json content: \\${content.substring(0, content.length > 200 ? 200 : content.length)}',
      );
      final List<dynamic> data = jsonDecode(content);
      print('jsonDecode success, data length: \\${data.length}');
      setState(() {
        _books = data.cast<Map<String, dynamic>>();
        _loading = false;
      });
    } else {
      print('library.json does not exist');
      setState(() {
        _books = [];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 라이브러리')),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _books.isEmpty
              ? const Center(child: Text('다운로드된 오디오북이 없습니다.'))
              : ListView.separated(
                itemCount: _books.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final book = _books[index];
                  return Semantics(
                    label: '책 제목: ${book['title']}, 저자: ${book['author']}',
                    button: true,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            (() {
                              final fileName =
                                  book['coverUrl'].toString().split('/').last;
                              final assetPath = 'assets/$fileName';
                              return Image.asset(
                                assetPath,
                                width: 48,
                                height: 64,
                                fit: BoxFit.cover,
                                semanticLabel: '책 표지: \\${book['title']}',
                                errorBuilder:
                                    (context, error, stackTrace) => Semantics(
                                      label: '표지 이미지 없음',
                                      child: Container(
                                        width: 48,
                                        height: 64,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.broken_image,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                              );
                            })(),
                      ),
                      title: Text(
                        book['title'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        book['author'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Semantics(
                        button: true,
                        label: '오디오북 재생',
                        child: IconButton(
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.deepPurple,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => AudioPlayerScreen(
                                      filePath: book['audioPath'],
                                      title: book['title'] ?? '',
                                      author: book['author'] ?? '',
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
