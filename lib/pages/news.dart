import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // เพิ่มไลบรารี url_launcher เพื่อทำการเปิดเว็บ
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

  // ฟังก์ชันเปิด URL เมื่อกดปุ่ม
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _onItemTapped(int index) {
    if (index == selectedIndex) return;

    setState(() {
      selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TrackWaterPage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ActivityPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AchievementPage(title: "Achievements")),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _pageControllerTop = PageController(); // กำหนดค่าให้ _pageControllerTop
    _pageControllerBottom = PageController(); // กำหนดค่าให้ _pageControllerBottom

    // ใช้ Timer เพื่อ auto scroll ทุก 3 วินาที
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageControllerTop.hasClients) {
        int nextPage = _pageControllerTop.page!.toInt() + 1;
        _pageControllerTop.animateToPage(
          nextPage % 3,  // แสดงแค่ 3 แบนเนอร์
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }

      if (_pageControllerBottom.hasClients) {
        int nextPage = _pageControllerBottom.page!.toInt() + 1;
        _pageControllerBottom.animateToPage(
          nextPage % 3,  // แสดงแค่ 3 แบนเนอร์
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
    body: SafeArea(  // ใช้ SafeArea เพื่อให้เนื้อหาภายในไม่ทับกับพื้นที่ส่วนบนและล่าง
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ข้อมูลที่เคยอยู่ใน AppBar ตอนนี้อยู่ที่นี่
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingPage(),
                        ),
                      );
                    },
                  ),
                  const Icon(Icons.account_circle_outlined, color: Colors.white, size: 30),
                ],
              ),
              const SizedBox(height: 20),
              // เพิ่ม 2 ปุ่มที่สามารถกดได้ (Events และ Workshop)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildClickableButton("Events", "https://example.com/events"),
                    _buildClickableButton("Workshop", "https://example.com/workshop"),
                  ],
                ),
              ),
              // Banner ที่เลื่อนได้ (แบนเนอร์บน)
              SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: _pageControllerTop,
                  itemCount: 3, // จำนวนแบนเนอร์
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // ลิงก์ที่จะแสดงเมื่อคลิก
                        String url = "https://example.com/banner$index";
                        // แสดง SnackBar และเปิดลิงก์
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Going to $url"),
                            duration: const Duration(seconds: 1), // แสดง SnackBar 1 วินาที
                          ),
                        );
                        _launchURL(url); // เปิดลิงก์เมื่อคลิกแบนเนอร์
                      },
                      child: Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Text('Banner $index', style: TextStyle(fontSize: 24, color: Colors.black)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 50),
              // Banner ที่สอง (แบนเนอร์ล่าง)
              SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: _pageControllerBottom,
                  itemCount: 3, // จำนวนแบนเนอร์
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // ลิงก์ที่จะแสดงเมื่อคลิก
                        String url = "https://example.com/banner$index";
                        // แสดง SnackBar และเปิดลิงก์
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Going to $url"),
                            duration: const Duration(seconds: 1), // แสดง SnackBar 1 วินาที
                          ),
                        );
                        _launchURL(url); // เปิดลิงก์เมื่อคลิกแบนเนอร์
                      },
                      child: Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Text('Banner $index', style: TextStyle(fontSize: 24, color: Colors.black)),
                        ),
                      ),
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


  // ฟังก์ชันสร้างปุ่มที่สามารถกดได้
  Widget _buildClickableButton(String label, String url) {
    return GestureDetector(
      onTap: () {
        // แสดง SnackBar เพื่อบอกลิงก์
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Going to $url"),
            duration: const Duration(seconds: 1), // แสดง SnackBar เป็นเวลา 1 วินาที
          ),
        );
        _launchURL(url); // เปิด URL
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 30, // ขนาดพอดีกับหน้าจอ
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const _CustomBottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

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
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: icons.asMap().entries.map((entry) {
          int idx = entry.key;
          IconData icon = entry.value;
          return IconButton(
            icon: Icon(
              icon,
              size: 28,
              color: selectedIndex == idx ? Colors.black : Colors.grey,
            ),
            onPressed: () => onItemTapped(idx),
          );
        }).toList(),
      ),
    );
  }
}
