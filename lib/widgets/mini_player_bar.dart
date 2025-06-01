// import 'package:flutter/material.dart';

// class MiniPlayerBar extends StatelessWidget {
//   const MiniPlayerBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF5F5F5),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFFA0A0A0).withOpacity(0.15),
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // 책 표지
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.asset(
//                   'assets/cover1.webp',
//                   width: 36,
//                   height: 48,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               // 제목/저자/시간
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       '불편한 편의점',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                         color: Color(0xFF212121),
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 2),
//                     Text(
//                       '김호연',
//                       style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 2),
//                     Text(
//                       '04:12 / 23:45',
//                       style: TextStyle(fontSize: 11, color: Color(0xFF757575)),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//               // Play 버튼
//               Container(
//                 width: 36,
//                 height: 36,
//                 margin: const EdgeInsets.only(right: 8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFA0A0A0),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xFFA0A0A0).withOpacity(0.18),
//                       blurRadius: 8,
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   Icons.play_arrow,
//                   color: const Color(0xFF4A4A4A),
//                   size: 22,
//                 ),
//               ),
//             ],
//           ),
//           // 진행바 (더미)
//           Container(
//             height: 4,
//             margin: const EdgeInsets.only(top: 8),
//             decoration: BoxDecoration(
//               color: const Color(0xFFD0D0D0),
//               borderRadius: BorderRadius.circular(2),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 60, // 진행 정도 (더미)
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFA0A0A0),
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 Expanded(child: SizedBox()),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
