import 'package:depi_graduation_project/fikraty.dart';
import 'package:depi_graduation_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: 'https://tqoyfzbnysoxqqjywbkc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRxb3lmemJueXNveHFxanl3YmtjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkzMzAyODEsImV4cCI6MjA3NDkwNjI4MX0.xtEnp2TGYmy4HyXhkMZWNdy1uV8BZCbWVoHCMJ0t68k',
  );
  runApp(const Fikraty());
}