import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import '../models/book.dart';
import '../constants.dart';
import 'auth_service.dart';

class BookDownloadService {
  final AuthService _authService = AuthService();

  Future<String> getAudioFilePath(Book book) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/${book.identificationNumber}_merged.mp3';
  }

  Future<bool> isBookDownloaded(Book book) async {
    final savePath = await getAudioFilePath(book);
    return File(savePath).exists();
  }

  Future<void> saveBookToLibrary({
    required Book book,
    required String audioPath,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/library.json');
    List<dynamic> books = [];
    if (await file.exists()) {
      books = jsonDecode(await file.readAsString());
    }
    books.removeWhere((b) => b['id'] == book.sellingBookId);
    books.add({
      'id': book.sellingBookId,
      'title': book.title,
      'author': book.authorName,
      'coverUrl': book.coverUrl,
      'audioPath': audioPath,
    });
    await file.writeAsString(jsonEncode(books));
  }

  Future<void> deleteAudioBook(Book book) async {
    final dir = await getApplicationDocumentsDirectory();
    final id = book.identificationNumber;
    final fileName = '${id}_merged.mp3';
    final savePath = '${dir.path}/$fileName';
    final file = File(savePath);
    if (await file.exists()) {
      await file.delete();
    }
    final sentencesFile = File('${dir.path}/${id}_sentences.json');
    if (await sentencesFile.exists()) {
      await sentencesFile.delete();
    }
    final voiceFile = File('${dir.path}/${id}_voice_length.json');
    if (await voiceFile.exists()) {
      await voiceFile.delete();
    }
    final libFile = File('${dir.path}/library.json');
    if (await libFile.exists()) {
      List<dynamic> books = jsonDecode(await libFile.readAsString());
      books.removeWhere((b) => b['id'] == book.sellingBookId);
      await libFile.writeAsString(jsonEncode(books));
    }
  }

  Future<void> downloadBookContentAndVoiceInfo(Book book) async {
    final dio = _authService.dio;
    final id = book.identificationNumber;
    List<String> allSentences = [];
    int totalIndex = 1;
    int readingIndex = 1;
    bool first = true;
    do {
      final response = await dio.get('$baseUrl/api/script/$id/$readingIndex');
      final data = response.data;
      if (first) {
        totalIndex = data['totalIndex'] as int;
        first = false;
      }
      final contents = data['contents'] as List;
      allSentences.addAll(contents.map((e) => e['utterance'] as String));
      readingIndex += 100;
    } while (readingIndex <= totalIndex);
    final voiceRes = await dio.get('$baseUrl/api/voice/$id/voice-length-info');
    final List<int> voiceLengthInfo =
        (voiceRes.data['voiceLengthInfo'] as String)
            .replaceAll('[', '')
            .replaceAll(']', '')
            .split(',')
            .map((e) => int.parse(e.trim()))
            .toList();
    final dir = await getApplicationDocumentsDirectory();
    final sentencesFile = File('${dir.path}/${id}_sentences.json');
    final voiceFile = File('${dir.path}/${id}_voice_length.json');
    await sentencesFile.writeAsString(jsonEncode(allSentences));
    await voiceFile.writeAsString(jsonEncode(voiceLengthInfo));
  }

  Future<String?> downloadAudio(Book book) async {
    final dio = _authService.dio;
    final response = await dio.post(
      '$baseUrl/api/voice/download',
      data: {'identificationNumber': book.identificationNumber},
    );
    if (response.statusCode == 200 && response.data['voicePath'] != null) {
      final fileName = '${book.identificationNumber}_merged.mp3';
      final assetPath = 'assets/$fileName';
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/$fileName';
      final byteData = await rootBundle.load(assetPath);
      final file = File(savePath);
      await file.writeAsBytes(byteData.buffer.asUint8List());
      return savePath;
    } else {
      return null;
    }
  }
}
