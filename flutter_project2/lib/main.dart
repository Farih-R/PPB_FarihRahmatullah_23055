import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BottomNavExample(),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
    );
  }
}

class BottomNavExample extends StatefulWidget {
  const BottomNavExample({super.key});

  @override
  State<BottomNavExample> createState() => _BottomNavExampleState();
}

class _BottomNavExampleState extends State<BottomNavExample> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    HomeChatPage(), 
    const Center(child: Text("Search Page")),
    const Center(child: Text("Profile Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aplikasi"),
      ),

      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class HomeChatPage extends StatelessWidget {
  HomeChatPage({super.key});

  final List<Map<String, dynamic>> chats = [
    {
      "name": "Okta",
      "message": "Lagi Apa?",
      "time": "11:20",
      "avatar": "images/my.jpeg", // offline
    },
    {
      "name": "Budi",
      "message": "Udah makan belum?",
      "time": "10:21",
      "avatar": "https://picsum.photos/200", // online
    },
    {
      "name": "Rusdi Bengkel",
      "message": "Login bang, -1 Roam",
      "time": "10:22",
      "avatar": "images/pp.jpg", // offline
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];

        return ListTile(
          leading: _avatar(chat["avatar"]),
          title: Text(chat["name"],
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(chat["message"]),
          trailing: Text(chat["time"]),
        );
      },
    );
  }

  // Deteksi gambar online / offline
  Widget _avatar(String path) {
    if (path.startsWith("http")) {
      return CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(path),
      );
    } else {
      return CircleAvatar(
        radius: 28,
        backgroundImage: AssetImage(path),
      );
    }
  }
}
