import 'package:flutter/material.dart';
import 'ui/home.dart';
import 'ui/account.dart';
void main() => runApp(const LivegoApp());
class LivegoApp extends StatelessWidget {
  const LivegoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF0D1117), primaryColor: const Color(0xFF8B5CF6)), home: const MainNavigation());
  }
}
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}
class _MainNavigationState extends State<MainNavigation> {
  int _idx = 0;
  final _p = [const HomePage(), const Center(child: Text("Unduhan")), const AccountPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _idx, children: _p),
      bottomNavigationBar: BottomNavigationBar(currentIndex: _idx, onTap: (i) => setState(() => _idx = i), backgroundColor: const Color(0xFF161B22), selectedItemColor: Colors.blueAccent, type: BottomNavigationBarType.fixed, items: const [BottomNavigationBarItem(icon: Icon(Icons.home), label: "HOME"), BottomNavigationBarItem(icon: Icon(Icons.download), label: "UNDUHAN"), BottomNavigationBarItem(icon: Icon(Icons.person), label: "AKUN")]),
    );
  }
}
