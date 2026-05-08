import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const LivegoApp());

class LivegoApp extends StatelessWidget {
  const LivegoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF090C11),
        primaryColor: Colors.blueAccent,
      ),
      home: const MainNavigation(),
    );
  }
}

// Komponen Kursor TV yang Tajam
class TVButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const TVButton({super.key, required this.child, required this.onTap});
  @override
  State<TVButton> createState() => _TVButtonState();
}

class _TVButtonState extends State<TVButton> {
  bool _isFocused = false;
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (f) => setState(() => _isFocused = f),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _isFocused ? Colors.blueAccent : Colors.transparent, width: 3),
            boxShadow: _isFocused ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.5), blurRadius: 15)] : [],
          ),
          transform: _isFocused ? (Matrix4.identity()..scale(1.05)) : Matrix4.identity(),
          child: widget.child,
        ),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _pages = [const HomePage(), const Center(child: Text("Unduhan")), const AccountPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "HOME"),
          BottomNavigationBarItem(icon: Icon(Icons.download), label: "UNDUHAN"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "AKUN"),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activeSource = "Melolo";
  List dramas = [];
  bool isLoading = true;

  final List<String> sources = ["Melolo", "DramaBox", "DotDrama", "Netshort", "Stardusttv", "Reelife", "DramaBite", "Velolo"];

  @override
  void initState() {
    super.initState();
    fetchDramas();
  }

  // FUNGSI AMBIL DATA DARI SERVER
  Future<void> fetchDramas() async {
    setState(() => isLoading = true);
    try {
      // GANTI IP INI dengan IP Lokal HP Anda jika di TV, atau localhost jika di HP
      final response = await http.get(Uri.parse("http://127.0.0.1:3000/api/dramas?source=$activeSource"));
      if (response.statusCode == 200) {
        setState(() {
          dramas = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LIVEGO", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))),
      body: Column(
        children: [
          // 8 API SELECTOR
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sources.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TVButton(
                  onTap: () {
                    setState(() => activeSource = sources[i]);
                    fetchDramas();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: activeSource == sources[i] ? Colors.blueAccent : Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(sources[i]),
                  ),
                ),
              ),
            ),
          ),
          // GRID DRAMA
          Expanded(
            child: isLoading 
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.7, crossAxisSpacing: 10, mainAxisSpacing: 10),
                  itemCount: dramas.length,
                  itemBuilder: (context, i) => TVButton(
                    onTap: () {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(dramas[i]['image'], fit: BoxFit.cover),
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Akun")),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          _menuItem(Icons.history, "Riwayat"),
          _menuItem(Icons.favorite, "Favorit"),
          _menuItem(Icons.update, "Pembaruan"),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return TVButton(
      onTap: () {},
      child: ListTile(leading: Icon(icon), title: Text(title), trailing: const Icon(Icons.chevron_right)),
    );
  }
}
