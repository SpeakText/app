import 'dart:io';
import 'package:flutter/material.dart';
import '../models/book.dart';
import 'audio_player_screen.dart';
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
    return Container(
      margin: const EdgeInsets.only(top: 32, bottom: 24),
      alignment: Alignment.topCenter,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            assetPath,
            width: 220,
            height: 320,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  width: 220,
                  height: 320,
                  color: Color(0xFFD0D0D0),
                  child: const Icon(Icons.broken_image, size: 48),
                ),
          ),
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
    final buttonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(54),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      elevation: 2,
    );
    if (!_downloaded && !_downloading) {
      return Row(
        children: [
          Expanded(
            flex: 7,
            child: ElevatedButton.icon(
              onPressed: _downloadAudio,
              icon: const Icon(Icons.download),
              label: const Text('오디오북 다운로드'),
              style: buttonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(Color(0xFF4A4A4A)),
                foregroundColor: WidgetStateProperty.all(Color(0xFFF5F5F5)),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: ElevatedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.delete),
              label: const Text('삭제'),
              style: buttonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(Color(0xFFD0D0D0)),
                foregroundColor: WidgetStateProperty.all(Color(0xFFF5F5F5)),
              ),
            ),
          ),
        ],
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
        children: [
          Expanded(
            flex: 7,
            child: ElevatedButton.icon(
              onPressed: _goToPlayer,
              icon: const Icon(Icons.play_arrow),
              label: const Text('오디오북 재생'),
              style: buttonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(Color(0xFF4A4A4A)),
                foregroundColor: WidgetStateProperty.all(Color(0xFFF5F5F5)),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: ElevatedButton.icon(
              onPressed: _deleteAudioBook,
              icon: const Icon(Icons.delete),
              label: const Text('삭제'),
              style: buttonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(Color(0xFFD32F2F)),
                foregroundColor: WidgetStateProperty.all(Color(0xFFF5F5F5)),
              ),
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildDescription() {
    // 실제로는 Book 모델에 description 필드가 있으면 그걸 사용하세요.
    // 여기서는 예시로 고정 텍스트 사용
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '책 소개',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(width: 18),
              Row(
                children: const [
                  Icon(Icons.star, color: Color(0xFFFFD600), size: 22),
                  Icon(Icons.star, color: Color(0xFFFFD600), size: 22),
                  Icon(Icons.star, color: Color(0xFFFFD600), size: 22),
                  Icon(Icons.star, color: Color(0xFFFFD600), size: 22),
                  Icon(Icons.star_half, color: Color(0xFFFFD600), size: 22),
                  SizedBox(width: 8),
                  Text('4.5/5.0', style: TextStyle(fontSize: 15)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '완벽한 알리바이를 만든 천재 수학자 이시가미 데츠야와 그 알리바이를 파헤치는 천재 물리학자이자 "탐정 갈릴레오"란 별명을 가진 유카와 마나부의 대결을 풀어내고 있다. 사랑과 ‘헌신’이라는 고전적이며 낭만적인 테제를 따르고 있는게 특징이다.',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF333333),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '오디오북 상세페이지',
          style: TextStyle(
            color: Color(0xFF4A4A4A),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFF5F5F5),
        iconTheme: const IconThemeData(color: Color(0xFFA0A0A0)),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCover(),
              _buildTitleAuthor(),
              _buildDescription(),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
