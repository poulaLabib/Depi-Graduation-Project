// store image and return image url

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorage {
  // function uploads images

  static Future<String?> uploadImage(File imageFile, String uid) async {
    final supabase = Supabase.instance.client;
    final path = '$uid-profile.jpg';

    try {
      // Upload and overwrite if exists
      final res = await supabase.storage
          .from('photos')
          .upload(
            path,
            imageFile,
            fileOptions: const FileOptions(upsert: true),
          );
      print('upload result: $res');

      // Get public URL
      final url = supabase.storage.from('photos').getPublicUrl(path);

      // Add cache-busting timestamp
      return '$url?t=${DateTime.now().millisecondsSinceEpoch}';
    } catch (e, st) {
      print('upload exception: $e\n$st');
      return null;
    }
  }
}
