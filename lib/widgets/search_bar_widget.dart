import 'package:flutter/material.dart';

/// 재사용 가능한 검색바 위젯입니다.
class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  const SearchBarWidget({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.controller,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _opacityAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '오디오북 검색 입력창',
      textField: true,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(40.0),
          border: Border.all(color: Color(0xFFD0D0D0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFA0A0A0).withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            icon: const Icon(Icons.search, color: Color(0xFFA0A0A0)),
            hintText: '오디오북 검색',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
            hintStyle: const TextStyle(color: Color(0xFFD0D0D0), fontSize: 15),
            labelText: '오디오북 검색',
          ),
        ),
      ),
    );
  }
}

/// placeholder에 애니메이션 효과가 있는 검색바
class AnimatedPlaceholderSearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  const AnimatedPlaceholderSearchBar({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.controller,
  });

  @override
  State<AnimatedPlaceholderSearchBar> createState() =>
      _AnimatedPlaceholderSearchBarState();
}

class _AnimatedPlaceholderSearchBarState
    extends State<AnimatedPlaceholderSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _opacityAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '오디오북 검색 입력창',
      textField: true,
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          icon: const Icon(Icons.search, color: Color(0xFFA0A0A0)),
          hintText: null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          hintStyle: const TextStyle(color: Color(0xFFD0D0D0)),
          // Animated placeholder
          prefixIcon: null,
          suffixIcon: null,
          label: AnimatedBuilder(
            animation: _opacityAnim,
            builder:
                (context, child) =>
                    Opacity(opacity: _opacityAnim.value, child: child),
            child: const Text(
              '오디오북 검색',
              style: TextStyle(color: Color(0xFFD0D0D0), fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
