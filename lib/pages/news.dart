import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'track.dart';
import 'activity.dart';
import 'dashboard.dart';
import 'achievement.dart';
import 'products.dart';
import 'setting.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int selectedIndex = 5;
  late PageController _pageControllerTop;
  late PageController _pageControllerBottom;
  Timer? _timer;

  final List<Map<String, String>> topBanners = [
    {
      'imageUrl': 'https://op.mahidol.ac.th/sa/wp-content/uploads/2025/03/2025_CUMU-48-1200x480.jpg',
      'linkUrl': 'https://op.mahidol.ac.th/sa/2025/22623/',
    },
    {
      'imageUrl': 'https://inno.co.th/wp-content/uploads/2023/06/Eco-friendly-event-1.jpg',
      'linkUrl': 'https://inno.co.th/eco-friendly-event/',
    },
    {
      'imageUrl': 'https://www.sarakadeelite.com/wp-content/uploads/2023/07/Worksop-open-web.jpg',
      'linkUrl': 'https://www.sarakadeelite.com/better-living/5-green-workshop/',
    },
  ];

  final List<Map<String, String>> bottomBanners = [
    {
      'imageUrl': 'https://www.krungsricard.com/KrungsriCreditCard/media/html/1450x665_Desktop1_20.jpg',
      'linkUrl': 'https://www.krungsricard.com/th/article/%E0%B8%81%E0%B8%B4%E0%B8%88%E0%B8%81%E0%B8%A3%E0%B8%A3%E0%B8%A1%E0%B8%A3%E0%B8%B1%E0%B8%81%E0%B8%A9%E0%B9%8C%E0%B9%82%E0%B8%A5%E0%B8%81',
    },
    {
      'imageUrl': 'https://www.onep.go.th/wp-content/uploads/2025/04/onep-eit-2025.jpg',
      'linkUrl': 'https://www.onep.go.th/category/%E0%B8%82%E0%B9%88%E0%B8%B2%E0%B8%A7%E0%B8%AA%E0%B8%B4%E0%B9%88%E0%B8%87%E0%B9%81%E0%B8%A7%E0%B8%94%E0%B8%A5%E0%B9%89%E0%B8%AD%E0%B8%A1/',
    },
    {
      'imageUrl': 'https://static.thairath.co.th/media/B6FtNKtgSqRqbnNsbKCjqDeIgu0jARfywfyYZAI2UCBJphH7Sv2qQJNtWBbZyGJBpGjCp.webp',
      'linkUrl': 'https://www.thairath.co.th/news/local/2784030',
    },
  ];

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _onItemTapped(int index) {
    if (index == selectedIndex) return;
    setState(() => selectedIndex = index);

    final pages = [
      const TrackWaterPage(),
      const ActivityPage(),
      const DashboardPage(),
      const AchievementPage(title: "Achievements"),
      const ProductPage()
    ];

    if (index >= 0 && index <= 4) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => pages[index]));
    }
  }

  @override
  void initState() {
    super.initState();
    _pageControllerTop = PageController();
    _pageControllerBottom = PageController();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageControllerTop.hasClients) {
        int nextPage = _pageControllerTop.page!.toInt() + 1;
        _pageControllerTop.animateToPage(
          nextPage % topBanners.length,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }

      if (_pageControllerBottom.hasClients) {
        int nextPage = _pageControllerBottom.page!.toInt() + 1;
        _pageControllerBottom.animateToPage(
          nextPage % bottomBanners.length,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ECAC4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white, size: 28),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingPage())),
                    ),
                    const Icon(Icons.account_circle_outlined, color: Colors.white, size: 30),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildClickableButton("Events", "https://www.google.com/search?q=Eco-Saving+Events"),
                      _buildClickableButton("Workshop", "https://www.google.com/search?q=Eco-Saving+Workshop"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    controller: _pageControllerTop,
                    itemCount: topBanners.length,
                    itemBuilder: (context, index) {
                      final banner = topBanners[index];
                      return GestureDetector(
                        onTap: () {
                          final url = banner['linkUrl']!;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Going to $url"), duration: const Duration(seconds: 1)),
                          );
                          _launchURL(url);
                        },
                        child: Image.network(banner['imageUrl']!, fit: BoxFit.cover),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    controller: _pageControllerBottom,
                    itemCount: bottomBanners.length,
                    itemBuilder: (context, index) {
                      final banner = bottomBanners[index];
                      return GestureDetector(
                        onTap: () {
                          final url = banner['linkUrl']!;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Going to $url"), duration: const Duration(seconds: 1)),
                          );
                          _launchURL(url);
                        },
                        child: Image.network(banner['imageUrl']!, fit: BoxFit.cover),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _CustomBottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildClickableButton(String label, String url) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Going to $url"), duration: const Duration(seconds: 1)),
        );
        _launchURL(url);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 30,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black12.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Center(
          child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const _CustomBottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    List<IconData> icons = [
      Icons.pie_chart,
      Icons.calendar_today,
      Icons.home,
      Icons.emoji_events_outlined,
      Icons.water_drop_outlined,
    ];

    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xFFE9DCC7),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: icons.asMap().entries.map((entry) {
          int idx = entry.key;
          IconData icon = entry.value;
          return IconButton(
            icon: Icon(icon, size: 28, color: selectedIndex == idx ? Colors.black : Colors.grey),
            onPressed: () => onItemTapped(idx),
          );
        }).toList(),
      ),
    );
  }
}