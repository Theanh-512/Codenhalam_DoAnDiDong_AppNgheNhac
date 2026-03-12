import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../search/search_screen.dart';
import '../favorites/favorite_songs_screen.dart';
import '../upload/artist_upload_song_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/mini_player.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const LibraryScreen(),
    const CreateScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _selectedIndex, children: _screens),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [MiniPlayer()],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.black),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black.withOpacity(0.9),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontSize: 10),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Tìm kiếm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music_outlined),
              label: 'Thư viện',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: 'Tạo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Cá nhân',
            ),
          ],
        ),
      ),
    );
  }
}
