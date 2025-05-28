import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

/// 오디오북 재생 화면
class AudioPlayerScreen extends StatefulWidget {
  final String filePath;
  final String title;
  final String author;
  const AudioPlayerScreen({
    super.key,
    required this.filePath,
    required this.title,
    required this.author,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _player;
  late StreamSubscription<Duration> _positionSub;
  late StreamSubscription<PlayerState> _stateSub;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _playing = false;
  bool _ready = false;

  // 페이지/문장 관련 상태
  List<String> _sentences = [];
  List<int> _voiceLengthInfo = [];
  int _currentPage = 0;
  final int _sentencesPerPage = 3;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    _player = AudioPlayer();
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    await _player.setFilePath(widget.filePath);
    _duration = _player.duration ?? Duration.zero;
    _ready = true;
    _positionSub = _player.positionStream.listen(_onPositionChanged);
    _stateSub = _player.playerStateStream.listen(_onPlayerStateChanged);
    await _loadBookData();
    setState(() {});
  }

  void _onPositionChanged(Duration pos) {
    setState(() {
      _position = pos;
    });
  }

  void _onPlayerStateChanged(PlayerState state) {
    setState(() {
      _playing = state.playing;
    });
  }

  Future<void> _loadBookData() async {
    final dir = await getApplicationDocumentsDirectory();
    final id = widget.filePath.split('/').last.split('_').first;
    final sentencesFile = File('${dir.path}/${id}_sentences.json');
    final voiceFile = File('${dir.path}/${id}_voice_length.json');
    if (await sentencesFile.exists()) {
      final sentences = await sentencesFile.readAsString();
      _sentences = List<String>.from(jsonDecode(sentences));
    }
    if (await voiceFile.exists()) {
      final voiceInfo = await voiceFile.readAsString();
      _voiceLengthInfo = List<int>.from(jsonDecode(voiceInfo));
      if (_voiceLengthInfo.isNotEmpty && _duration.inMilliseconds > 0) {
        if (_voiceLengthInfo.last < _duration.inMilliseconds) {
          _voiceLengthInfo.add(_duration.inMilliseconds);
        }
      }
    }
  }

  int get _pageStartIdx => _currentPage * _sentencesPerPage;
  int get _pageEndIdx =>
      ((_currentPage + 1) * _sentencesPerPage).clamp(0, _sentences.length);
  int get _totalPages => (_sentences.length / _sentencesPerPage).ceil();

  List<String> get _currentPageSentences =>
      _sentences.isEmpty ? [] : _sentences.sublist(_pageStartIdx, _pageEndIdx);

  Future<void> _playCurrentPageAudio() async {
    if (_voiceLengthInfo.length <= _pageStartIdx + 1) return;
    final startMs = _voiceLengthInfo[_pageStartIdx];
    await _player.seek(Duration(milliseconds: startMs));
    _player.play();
    _positionSub.cancel();
    _positionSub = _player.positionStream.listen((pos) {
      final currentMs = pos.inMilliseconds;
      final startMs = _voiceLengthInfo[_pageStartIdx];
      final endIdx =
          _pageEndIdx < _voiceLengthInfo.length
              ? _pageEndIdx
              : _voiceLengthInfo.length - 1;
      final endMs = _voiceLengthInfo[endIdx];
      print('[AUDIO LOG] current position: \\$currentMs ms');
      if (currentMs >= endMs - 100) {
        // 페이지가 넘어갈 때 상세 로그 출력
        print(
          '[PAGE TURN] page: \\${_currentPage + 1}/$_totalPages, '
          'sentenceIdx: \\$_pageStartIdx~\\${_pageEndIdx - 1}, '
          'startMs: \\$startMs, endMs: \\$endMs, currentMs: \\$currentMs',
        );
        if (_pageEndIdx < _sentences.length) {
          setState(() {
            _currentPage++;
          });
          _playCurrentPageAudio();
        } else {
          _player.pause();
        }
      }
    });
  }

  void _goToPrevPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _playCurrentPageAudio();
    }
  }

  void _goToNextPage() {
    if (_pageEndIdx < _sentences.length) {
      setState(() {
        _currentPage++;
      });
      _playCurrentPageAudio();
    }
  }

  @override
  void dispose() {
    _positionSub.cancel();
    _stateSub.cancel();
    _player.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void _seek(double value) {
    final newPos = Duration(
      milliseconds: (value * _duration.inMilliseconds).toInt(),
    );
    _player.seek(newPos);
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: Column(
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            widget.author,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSentences() {
    if (_sentences.isEmpty) {
      return const Center(child: Text('책 내용이 없습니다.'));
    }
    return Center(
      child: Text(
        _currentPageSentences.join(' '),
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          height: 1.6,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildPageControls() {
    if (_sentences.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: _goToPrevPage, child: const Text('이전')),
          const SizedBox(width: 24),
          Text('페이지 ${_currentPage + 1} / $_totalPages'),
          const SizedBox(width: 24),
          ElevatedButton(onPressed: _goToNextPage, child: const Text('다음')),
        ],
      ),
    );
  }

  Widget _buildPlayButton() {
    return IconButton(
      iconSize: 64,
      icon: Icon(
        _playing ? Icons.pause_circle_filled : Icons.play_circle_filled,
        color: Colors.deepPurple,
      ),
      onPressed: () {
        if (!_playing) {
          _playCurrentPageAudio();
        } else {
          _player.pause();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('오디오북 재생')),
      body:
          _ready
              ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    Expanded(child: _buildSentences()),
                    _buildPageControls(),
                    _buildPlayButton(),
                  ],
                ),
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
