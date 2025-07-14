import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_download_service.dart';
import 'audio_player_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final BookDownloadService _downloadService = BookDownloadService();
  bool _isDownloaded = false;
  bool _isDownloading = false;
  bool _isCheckingDownload = true;
  bool _showDownloadComplete = false;

  @override
  void initState() {
    super.initState();
    _checkDownloadStatus();
  }

  Future<void> _checkDownloadStatus() async {
    try {
      final isDownloaded = await _downloadService.isBookDownloaded(widget.book);
      setState(() {
        _isDownloaded = isDownloaded;
        _isCheckingDownload = false;
        _showDownloadComplete = false;
      });
    } catch (e) {
      setState(() {
        _isCheckingDownload = false;
      });
    }
  }

  Future<void> _downloadBook() async {
    setState(() {
      _isDownloading = true;
      _showDownloadComplete = false;
    });
    try {
      final audioPath = await _downloadService.downloadAudio(widget.book);
      if (audioPath != null) {
        await _downloadService.downloadBookContentAndVoiceInfo(widget.book);
        await _downloadService.saveBookToLibrary(
          book: widget.book,
          audioPath: audioPath,
        );
        setState(() {
          _isDownloaded = true;
          _isDownloading = false;
          _showDownloadComplete = true;
        });
      } else {
        throw Exception('다운로드 실패');
      }
    } catch (e) {
      setState(() {
        _isDownloading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('다운로드 중 문제가 발생했습니다. 나중에 다시 시도해주세요.')),
        );
      }
    }
  }

  void _playBook() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AudioPlayerScreen(book: widget.book),
      ),
    );
  }

  Future<void> _deleteBook() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
            title: const Text('오디오북 삭제', style: TextStyle(color: Colors.white)),
            content: const Text(
              '이 오디오북의 오디오 파일을 삭제하시겠습니까?',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            actions: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white, width: 2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  '취소',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white, width: 2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  '삭제',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      setState(() {
        _isCheckingDownload = true;
        _showDownloadComplete = false;
      });
      await _downloadService.deleteAudioBook(widget.book);
      setState(() {
        _isDownloaded = false;
        _isCheckingDownload = false;
        _showDownloadComplete = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('오디오북이 삭제되었습니다.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: Semantics(
          label: '뒤로 가기 버튼',
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          '책 상세정보',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.white, width: 3),
            ),
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 책 표지
                  Center(
                    child: Container(
                      width: 140,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[900],
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child:
                          widget.book.coverUrl.isNotEmpty
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/${widget.book.coverUrl}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.book,
                                      size: 80,
                                      color: Colors.white,
                                    );
                                  },
                                ),
                              )
                              : Icon(Icons.book, size: 80, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 제목
                  Text(
                    widget.book.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // 저자
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '저자: ${widget.book.authorName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // 설명
                  Text(
                    '책 소개',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.book.description.isNotEmpty
                        ? widget.book.description
                        : '이 책에 대한 자세한 설명은 준비 중입니다.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // 버튼
                  if (_isCheckingDownload)
                    const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  if (!_isCheckingDownload && !_isDownloaded)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
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
                        onPressed: _isDownloading ? null : _downloadBook,
                        icon:
                            _isDownloading
                                ? const SizedBox.shrink()
                                : const Icon(Icons.download_outlined),
                        label:
                            _isDownloading
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black,
                                    ),
                                  ),
                                )
                                : const Text('오디오북 다운로드'),
                      ),
                    ),
                  if (!_isCheckingDownload && _isDownloaded)
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
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
                            onPressed: _playBook,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('오디오북 재생'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
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
                            onPressed: _deleteBook,
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('오디오북 삭제'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
