import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/home.dart';
import 'ui/account.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineFlow',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        primaryColor: const Color(0xFF8B5CF6),
      ),
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    const HomePage(),
    const AccountPage(),
  ];
  
  Future<void> _clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cache berhasil dibersihkan"))
      );
    }
  }
  
  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Keluar Aplikasi", style: TextStyle(color: Colors.white)),
        content: const Text("Apakah Anda ingin keluar?", style: TextStyle(color: Colors.grey)),
        backgroundColor: const Color(0xFF1A1A1A),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
            child: const Text("Ya", style: TextStyle(color: Color(0xFF8B5CF6))),
          ),
        ],
      ),
    ) ?? false;
  }
  
  void _showExitDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Keluar Aplikasi", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Pilihan:", style: TextStyle(color: Colors.white)),
            SizedBox(height: 10),
            Text("• Keluar saja", style: TextStyle(color: Colors.grey)),
            Text("• Keluar + Bersihkan Cache", style: TextStyle(color: Colors.grey)),
          ],
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _onWillPop();
            },
            child: const Text("Keluar Saja", style: TextStyle(color: Color(0xFF8B5CF6))),
          ),
          TextButton(
            onPressed: () async {
              await _clearCache();
              Navigator.of(context).pop();
              _onWillPop();
            },
            child: const Text("Keluar + Hapus Cache", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: const Color(0xFF0A0A0A),
          selectedItemColor: const Color(0xFF8B5CF6),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
            BottomNavigationBarItem(icon: Icon(Icons.download), label: 'UNDUHAN'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'AKUN'),
          ],
        ),
      ),
    );
  }
}
