/// 책 정보를 나타내는 모델 클래스입니다.
class Book {
  final int sellingBookId;
  final String title;
  final String coverUrl;
  final String authorName;
  final String identificationNumber;

  Book({
    required this.sellingBookId,
    required this.title,
    required this.coverUrl,
    required this.authorName,
    required this.identificationNumber,
  });

  /// JSON에서 Book 객체를 생성하는 팩토리 생성자입니다.
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      sellingBookId: json['sellingBookId'] as int,
      title: json['title'] as String,
      coverUrl: json['coverUrl'] as String,
      authorName: json['authorName'] as String,
      identificationNumber:
          json['identificationNumber'] as String? ?? '9788949301990',
    );
  }
}
