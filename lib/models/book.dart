/// 책 정보를 나타내는 모델 클래스입니다.
class Book {
  final int sellingBookId;
  final String title;
  final String coverUrl;
  final String authorName;
  final String identificationNumber;
  final String description;

  Book({
    required this.sellingBookId,
    required this.title,
    required this.coverUrl,
    required this.authorName,
    required this.identificationNumber,
    required this.description,
  });

  /// JSON에서 Book 객체를 생성하는 팩토리 생성자입니다.
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      sellingBookId: json['sellingBookId'] as int,
      title: json['title'] as String,
      coverUrl: json['coverUrl'] as String, // 실제 API 응답의 coverUrl 사용
      authorName: json['authorName'] as String,
      identificationNumber: json['identificationNumber'] as String? ?? '',
      description:
          json['description'] as String? ?? '', // 실제 API 응답의 description 사용
    );
  }
}
