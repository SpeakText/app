import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../models/book.dart';

class AudioPlayerScreen extends StatefulWidget {
  final Book book;

  const AudioPlayerScreen({super.key, required this.book});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isLoading = true;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// 오디오 플레이어 초기화
  Future<void> _initializeAudioPlayer() async {
    try {
      _audioPlayer = AudioPlayer();

      // 오디오 세션 초기화
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());

      // 오디오 파일 로드
      final audioPath =
          'assets/audio/${widget.book.identificationNumber}_merged.mp3';

      if (kDebugMode) {
        debugPrint('Loading audio file: $audioPath');
      }

      await _audioPlayer.setAsset(audioPath);

      // 리스너 설정
      _audioPlayer.durationStream.listen((duration) {
        if (mounted) {
          setState(() {
            _duration = duration ?? Duration.zero;
          });
        }
      });

      _audioPlayer.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            _position = position;
          });
        }
      });

      _audioPlayer.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
            _isLoading =
                state.processingState == ProcessingState.loading ||
                state.processingState == ProcessingState.buffering;
          });
        }
      });

      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('오디오 초기화 에러: $e');
      }

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("오디오 파일을 불러올 수 없습니다."),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// 재생/일시정지 토글
  Future<void> _togglePlayPause() async {
    if (!_isInitialized) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        // 2초 지연 후 재생
        await Future.delayed(const Duration(seconds: 2));
        await _audioPlayer.play();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('재생/정지 에러: $e');
      }
    }
  }

  /// 뒤로 30초 이동
  Future<void> _seekBackward() async {
    if (!_isInitialized) return;

    final newPosition = _position - const Duration(seconds: 60);
    final targetPosition =
        newPosition < Duration.zero ? Duration.zero : newPosition;

    await _audioPlayer.seek(targetPosition);
  }

  /// 앞으로 30초 이동
  Future<void> _seekForward() async {
    if (!_isInitialized) return;

    final newPosition = _position + const Duration(seconds: 60);
    final targetPosition = newPosition > _duration ? _duration : newPosition;

    await _audioPlayer.seek(targetPosition);
  }

  /// 재생 속도 변경
  Future<void> _changePlaybackSpeed() async {
    if (!_isInitialized) return;

    double newSpeed;
    switch (_playbackSpeed) {
      case 0.5:
        newSpeed = 0.75;
        break;
      case 0.75:
        newSpeed = 1.0;
        break;
      case 1.0:
        newSpeed = 1.25;
        break;
      case 1.25:
        newSpeed = 1.5;
        break;
      case 1.5:
        newSpeed = 2.0;
        break;
      case 2.0:
        newSpeed = 0.5;
        break;
      default:
        newSpeed = 1.0;
    }

    await _audioPlayer.setSpeed(newSpeed);
    setState(() {
      _playbackSpeed = newSpeed;
    });
  }

  /// 시간을 포맷팅
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: _buildPlayerScreen(),
    );
  }

  /// 플레이어 화면
  Widget _buildPlayerScreen() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. 재생/일시정지 버튼
              _buildPlayPauseButton(),
              const SizedBox(height: 24),
              // 2. 30초 이동/속도 조절 버튼
              _buildControlButtons(excludePlayPause: true),
              const SizedBox(height: 24),
              // 3. 진행률 영역
              Column(
                children: [
                  _buildProgressDisplay(),
                  const SizedBox(height: 16),
                  _buildProgressSlider(),
                ],
              ),
              const SizedBox(height: 24),
              // 4. 책 정보 (가장 마지막)
              _buildBookInfo(),
            ],
          ),
        ),
      ),
    );
  }

  /// 책 정보 표시 위젯
  Widget _buildBookInfo() {
    return Semantics(
      label: "현재 재생중인 책: ${widget.book.title}",
      child: Column(
        children: [
          ExcludeSemantics(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child:
                    widget.book.coverUrl.isNotEmpty
                        ? Image.asset(
                          'assets/${widget.book.coverUrl}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.book,
                                size: 80,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        )
                        : Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.book,
                            size: 80,
                            color: Colors.grey[600],
                          ),
                        ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          ExcludeSemantics(
            child: Text(
              widget.book.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// 진행률 표시 위젯
  Widget _buildProgressDisplay() {
    return Semantics(
      label:
          "재생 진행률: 현재 위치 ${_formatDuration(_position)}, 총 길이 ${_formatDuration(_duration)}",
      child: ExcludeSemantics(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDuration(_position),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              _formatDuration(_duration),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  /// 진행률 슬라이더 위젯
  Widget _buildProgressSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: "오디오 탐색 슬라이더",
          value:
              "${(_position.inSeconds / (_duration.inSeconds == 0 ? 1 : _duration.inSeconds) * 100).toStringAsFixed(0)} 퍼센트, 현재 위치 ${_formatDuration(_position)}",
          hint: "좌우로 쓸어 값을 조절할 수 있습니다.",
          slider: true,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 8,
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 14,
                elevation: 4,
              ),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
            ),
            child: Slider(
              value: _position.inSeconds.toDouble(),
              min: 0,
              max:
                  _duration.inSeconds.toDouble() > 0
                      ? _duration.inSeconds.toDouble()
                      : 1,
              onChanged: (value) async {
                await _audioPlayer.seek(Duration(seconds: value.toInt()));
              },
              semanticFormatterCallback: (double value) {
                return _formatDuration(Duration(seconds: value.round()));
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_position),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                _formatDuration(_duration),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 컨트롤 버튼 위젯
  Widget _buildControlButtons({bool excludePlayPause = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1번째 줄: 되감기, (재생/일시정지), 빨리감기
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: _buildTextButton(
                onPressed: _seekBackward,
                label: '60초 뒤로',
              ),
            ),
            const SizedBox(width: 12),
            if (!excludePlayPause)
              Expanded(flex: 4, child: _buildPlayPauseButton()),
            if (!excludePlayPause) const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: _buildTextButton(
                onPressed: _seekForward,
                label: '60초 앞으로',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // 2번째 줄: 재생속도
        SizedBox(
          width: 240,
          child: _buildTextButton(
            onPressed: _changePlaybackSpeed,
            label: '재생 속도 (${_playbackSpeed}x)',
          ),
        ),
      ],
    );
  }

  /// 재생/일시정지 버튼
  Widget _buildPlayPauseButton() {
    return Semantics(
      label: _isPlaying ? "일시정지" : "재생",
      button: true,
      child: ElevatedButton(
        onPressed: _togglePlayPause,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.white, width: 3),
          ),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        child: Text(
          _isPlaying ? '일시정지' : '재생',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  /// 텍스트 기반 컨트롤 버튼
  Widget _buildTextButton({
    required VoidCallback onPressed,
    required String label,
    String? hint,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.white, width: 3),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
