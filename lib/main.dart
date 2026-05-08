import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'ui/home.dart';
import 'ui/account.dart';

void main() => runApp(const LivegoApp());
class LivegoApp extends StatelessWidget {
  const LivegoApp({super.key});
  @override Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF0D1117), primaryColor: const Color(0xFF8B5CF6)), home: const MainNavigation());
  }
}
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override State<MainNavigation> createState() => _MainNavigationState();
}
class _MainNavigationState extends State<MainNavigation> {
  int _idx = 0;
  final _p = [const HomePage(), const Center(child: Text("Unduhan")), const AccountPage()];
  Future<void> _exit() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) { cacheDir.deleteSync(recursive: true); }
    SystemNavigator.pop();
  }
  @override Widget build(BuildContext context) {
    return PopScope(canPop: false, onPopInvokedWithResult: (did, res) { if(!did) _showExit(context); }, child: Scaffold(body: IndexedStack(index: _idx, children: _p), bottomNavigationBar: BottomNavigationBar(currentIndex: _idx, onTap: (i) => setState(() => _idx = i), backgroundColor: const Color(0xFF161B22), selectedItemColor: Colors.blueAccent, type: BottomNavigationBarType.fixed, items: const [BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "HOME"), BottomNavigationBarItem(icon: Icon(Icons.download), label: "UNDUHAN"), BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "AKUN")])));
  }
  void _showExit(BuildContext ctx) {
    showDialog(context: ctx, builder: (c) => AlertDialog(backgroundColor: const Color(0xFF161B22), title: const Text("Keluar Aplikasi"), content: const Text("Yakin ingin keluar dan bersihkan cache?"), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text("Batal")), ElevatedButton(onPressed: _exit, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text("Keluar"))]));
  }
}
