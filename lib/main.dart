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
        primaryColor: const Color(0xFF8B5CF6),
      ),
      home: const MainNavigation(),
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
  final List<Widget> _pages = [
    const Center(child: Text("Halaman Home")),
    const Center(child: Text("Halaman Unduhan")),
    const AccountPage(), // Halaman Akun yang sudah dirombak
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
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "HOME"),
          BottomNavigationBarItem(icon: Icon(Icons.download_rounded), label: "UNDUHAN"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "AKUN"),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            // HEADER PROFIL (Background & Logo bisa diganti di Assets)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xFF161B22),
                image: const DecorationImage(
                  image: AssetImage('assets/bg_profile.png'), // GANTI DISINI
                  fit: BoxFit.cover,
                  opacity: 0.3,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.blueAccent.withOpacity(0.2),
                    child: const Icon(Icons.person, size: 40, color: Colors.blueAccent),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("User Penggemar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const Text("Masuk cepat ke riwayat, favorit, dan update.", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _socialButton("Telegram", Colors.blue),
                            const SizedBox(width: 10),
                            _socialButton("WhatsApp", Colors.green),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),
            const Text("KOLEKSI CEPAT", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            // CARD KOLEKSI
            _buildMenuCard([
              _menuItem(Icons.history, "Riwayat", "Lanjutkan tontonan terakhir"),
              _menuItem(Icons.favorite_border, "Favorit", "Daftar judul yang Anda simpan"),
              _menuItem(Icons.settings_outlined, "Pengaturan", "Atur tampilan, player, dan DRM"),
            ]),

            const SizedBox(height: 25),
            const Text("APLIKASI & DUKUNGAN", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // CARD DUKUNGAN
            _buildMenuCard([
              _menuItem(Icons.system_update_alt, "Periksa Pembaruan", "Cek versi terbaru Livego"),
              _menuItem(Icons.share, "Dukung Livego", "Bantu maintenance lewat donasi"),
              _menuItem(Icons.feedback_outlined, "Kirim Feedback", "Laporkan bug atau masalah sumber"),
              _menuItem(Icons.help_outline, "Bantuan", "Panduan fitur utama aplikasi"),
            ]),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _socialButton(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(border: Border.all(color: Colors.white24), borderRadius: BorderRadius.circular(15)),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }

  Widget _buildMenuCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(20)),
      child: Column(children: items),
    );
  }

  Widget _menuItem(IconData icon, String title, String sub) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white70, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
      onTap: () {},
    );
  }
}
