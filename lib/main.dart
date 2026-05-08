import 'package:flutter/material.dart';

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

// WIDGET KHUSUS TV: Agar tombol terlihat sangat tajam saat dipilih remote
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
      onFocusChange: (focus) => setState(() => _isFocused = focus),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: _isFocused ? Colors.blueAccent : Colors.transparent,
              width: 3,
            ),
            boxShadow: _isFocused ? [
              BoxShadow(color: Colors.blueAccent.withOpacity(0.5), blurRadius: 15, spreadRadius: 2)
            ] : [],
          ),
          transform: _isFocused ? (Matrix4.identity()..scale(1.05)) : Matrix4.identity(),
          child: widget.child,
        ),
      ),
    );
  }
}

// NAVIGASI UTAMA
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const Center(child: Text("Halaman Unduhan")),
    const AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: const Color(0xFF111827),
        selectedItemColor: Colors.blueAccent,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "HOME"),
          BottomNavigationBarItem(icon: Icon(Icons.download_rounded), label: "UNDUHAN"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "AKUN"),
        ],
      ),
    );
  }
}

// HALAMAN HOME (TAMPILAN DI TV)
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text("Livego")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            TVButton(
              onTap: () {},
              child: Container(
                height: 200, width: double.infinity, margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(15)),
                child: const Center(child: Text("BANNER PROMO DRACIN")),
              ),
            ),
            const Padding(padding: EdgeInsets.all(20), child: Text("Daftar API Dracin akan muncul di sini...")),
          ],
        ),
      ),
    );
  }
}

// HALAMAN AKUN (DENGAN TOMBOL BERFUNGSI & KURSOR TAJAM)
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 30),
            _buildSection("KOLEKSI CEPAT", [
              _tvMenuItem(context, Icons.history, "Riwayat", "Lihat tontonan terakhir"),
              _tvMenuItem(context, Icons.favorite_border, "Favorit", "Drama yang Anda simpan"),
              _tvMenuItem(context, Icons.settings, "Pengaturan", "Atur Player & DRM"),
            ]),
            const SizedBox(height: 20),
            _buildSection("DUKUNGAN", [
              _tvMenuItem(context, Icons.system_update, "Pembaruan", "Cek versi terbaru"),
              _tvMenuItem(context, Icons.help_outline, "Bantuan", "Panduan aplikasi"),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(20)),
      child: const Row(
        children: [
          CircleAvatar(radius: 30, backgroundColor: Colors.blueAccent, child: Icon(Icons.person, size: 40)),
          SizedBox(width: 20),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("User Penggemar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Akun Gratis", style: TextStyle(color: Colors.grey)),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(20)),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _tvMenuItem(BuildContext context, IconData icon, String title, String sub) {
    return TVButton(
      onTap: () {
        // Logika berpindah halaman saat diklik
        if (title == "Pengaturan") {
          Navigator.push(context, MaterialPageRoute(builder: (c) => const SimplePage(title: "Pengaturan")));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (c) => SimplePage(title: title)));
        }
      },
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(title, style: const TextStyle(fontSize: 14)),
        subtitle: Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right, size: 18),
      ),
    );
  }
}

// HALAMAN PLACEHOLDER UNTUK TOMBOL YG BELUM ADA ISINYA
class SimplePage extends StatelessWidget {
  final String title;
  const SimplePage({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("Halaman $title Segera Hadir")),
    );
  }
}
