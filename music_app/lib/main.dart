import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/song_provider.dart';
import 'providers/library_provider.dart';
import 'providers/audio_provider.dart';
import 'providers/playlist_provider.dart';
import 'screens/main/main_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/login/register_screen.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase (Cần file google-services.json hoặc cấu hình DefaultFirebaseOptions)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization error: $e');
    print(
      'Hãy đảm bảo bạn đã cấu hình Firebase cho dự án (google-services.json cho Android).',
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SongProvider()),
        ChangeNotifierProvider(create: (_) => LibraryProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => PlaylistProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
        fontFamily: 'Inter', // Assuming standard clean fonts
      ),
      initialRoute: '/main',
      routes: {
        '/main': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
