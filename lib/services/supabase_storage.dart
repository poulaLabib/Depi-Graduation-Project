import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorage {
  static Future<String?> uploadImage(
    File imageFile,
    String uid, {
    required String type, // 'profile' or 'id'
  }) async {
    final supabase = Supabase.instance.client;
    const bucket = 'photos';
    final path = '$uid/$type.jpg'; // each user has profile.jpg and id.jpg

    try {
      // upload or replace
      await supabase.storage.from(bucket).upload(
        path,
        imageFile,
        fileOptions: const FileOptions(upsert: true), // replaces if exists
      );

      // get public URL (timestamp ensures latest version is fetched)
      final url = supabase.storage.from(bucket).getPublicUrl(path);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return '$url?t=$timestamp';
    } catch (e, st) {
      print('Upload exception: $e\n$st');
      print('Upload exception: $e\n$st');
      return null;
    }
  }
}
