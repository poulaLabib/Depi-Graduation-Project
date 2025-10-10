// store image and return image url

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

// function uploads images 
Future<String?> uploadImage(File imageFile, String path) async {
  final supabase = Supabase.instance.client;

  await supabase.storage.from('photos').upload(path, imageFile);

  return supabase.storage.from('photos').getPublicUrl(path);
}