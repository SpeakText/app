import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/book.dart';
import 'audio_player_screen.dart';
import '../constants.dart';
import '../services/auth_service.dart';
import '../utils/ui_utils.dart';
import '../services/book_download_service.dart';

/// 책 상세 페이지: 표지, 제목, 작가, 다운로드 및 오프라인 재생 지원
class BookDetailScreen extends StatefulWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  double _progress = 0.0;
  bool _downloading = false;
  bool _downloaded = false;
  String? _localFilePath;
  final AuthService _authService = AuthService();
  final BookDownloadService _downloadService = BookDownloadService();

  @override
  void initState() {
    super.initState();
    _checkDownloaded();
  }

  Future<void> _checkDownloaded() async {
    final downloaded = await _downloadService.isBookDownloaded(widget.book);
    if (downloaded) {
      final path = await _downloadService.getAudioFilePath(widget.book);
      setState(() {
        _downloaded = true;
        _localFilePath = path;
        _progress = 1.0;
      });
    }
  }

  Future<void> _deleteAudioBook() async {
    await _downloadService.deleteAudioBook(widget.book);
    setState(() {
      _downloaded = false;
      _localFilePath = null;
      _progress = 0.0;
    });
    showAppSnackBar(context, '오디오북이 삭제되었습니다.');
  }

  Future<void> _downloadAudio() async {
    setState(() {
      _downloading = true;
      _progress = 0.0;
    });
    try {
      final savePath = await _downloadService.downloadAudio(widget.book);
      if (savePath != null) {
        await _downloadService.downloadBookContentAndVoiceInfo(widget.book);
        await _downloadService.saveBookToLibrary(
          book: widget.book,
          audioPath: savePath,
        );
        setState(() {
          _downloaded = true;
          _localFilePath = savePath;
          _progress = 1.0;
        });
      } else {
        throw Exception('voicePath가 응답에 없습니다');
      }
    } catch (e) {
      showAppSnackBar(context, '다운로드 실패: $e');
    } finally {
      setState(() {
        _downloading = false;
      });
    }
  }

  void _goToPlayer() {
    if (_localFilePath != null && File(_localFilePath!).existsSync()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => AudioPlayerScreen(
                filePath: _localFilePath!,
                title: widget.book.title,
                author: widget.book.authorName,
              ),
        ),
      );
    }
  }

  Widget _buildCover() {
    final fileName = widget.book.coverUrl.split('/').last;
    final assetPath = 'assets/$fileName';
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        assetPath,
        width: 180,
        height: 260,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) => Container(
              width: 180,
              height: 260,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, size: 40),
            ),
      ),
    );
  }

  Widget _buildTitleAuthor() {
    return Column(
      children: [
        Text(
          widget.book.title,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          widget.book.authorName,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (!_downloaded && !_downloading) {
      return ElevatedButton.icon(
        onPressed: _downloadAudio,
        icon: const Icon(Icons.download),
        label: const Text('오디오북 다운로드'),
      );
    } else if (_downloading) {
      return Column(
        children: [
          const Text('다운로드 중...'),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: _progress),
          const SizedBox(height: 8),
          Text('${(_progress * 100).toStringAsFixed(0)}%'),
        ],
      );
    } else if (_downloaded) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: _goToPlayer,
            icon: const Icon(Icons.play_arrow),
            label: const Text('오디오북 재생'),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: _deleteAudioBook,
            icon: const Icon(Icons.delete),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            label: const Text('삭제'),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('책 상세')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCover(),
              const SizedBox(height: 24),
              _buildTitleAuthor(),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
