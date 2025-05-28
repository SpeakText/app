import 'package:flutter/material.dart';

/// 재사용 가능한 검색바 위젯입니다.
class SearchBarWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: const InputDecoration(
          icon: Icon(Icons.search),
          hintText: '오디오북 검색',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
