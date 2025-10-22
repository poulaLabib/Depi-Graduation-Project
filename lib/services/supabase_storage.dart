import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SupabaseStorage {
  static Future<String?> uploadImage(
    File imageFile,
    String uid, {
    String? oldUrl,
  }) async {
    final supabase = Supabase.instance.client;
    const bucket = 'photos';
    final uuid = const Uuid().v4();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = '$uid-$uuid-$timestamp.jpg';

    try {
      if (oldUrl != null && oldUrl.isNotEmpty) {
        try {
          final oldFileName = oldUrl.split('/').last.split('?').first;
          await supabase.storage.from(bucket).remove([oldFileName]);
        } catch (e) {
          print('Failed to delete old image: $e');
        }
      }

      await supabase.storage
          .from(bucket)
          .upload(
            path,
            imageFile,
            fileOptions: const FileOptions(upsert: false),
          );

      final url = supabase.storage.from(bucket).getPublicUrl(path);
      return '$url?t=$timestamp';
    } catch (e, st) {
      print('Upload exception: $e\n$st');
      return null;
    }
  }
}
