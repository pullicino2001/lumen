import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The .env file holds the Atlas Cloud API key. It is gitignored, so a fresh
  // checkout may not have one — load it optionally so the app still starts and
  // the simulation feature reports a clear "key not set" error instead.
  await dotenv.load(fileName: '.env', isOptional: true);
  runApp(
    const ProviderScope(
      child: LumenApp(),
    ),
  );
}
