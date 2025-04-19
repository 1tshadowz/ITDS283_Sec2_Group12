import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'track.dart';
import 'activity.dart';
import 'dashboard.dart';
import 'achievement.dart';
import 'setting.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int selectedIndex = 4;
  PageController _pageController = PageController(initialPage: 0);
  Timer? _timer;

  // รายการภาพแบนเนอร์ (URL จากอินเทอร์เน็ต)
  final List<String> bannerImages = [
    'https://scontent.fkdt1-1.fna.fbcdn.net/v/t39.30808-6/336042403_887436202564810_1331039537008241797_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=28-vB5WbaWIQ7kNvwH6XSnZ&_nc_oc=AdnYGjXNmwpSa39srvI5FaOFX2-fetQ7BesGbuGuAQ24JLxNgrXGHHL74I2cakXyGOZHWhvd4DREr9lZPATu22fA&_nc_zt=23&_nc_ht=scontent.fkdt1-1.fna&_nc_gid=Pffe7EfNvByWDkg_bvMNUQ&oh=00_AfGUjGnJjCF2fkY4HZKCR5DqAJ1YAJgOsYDllr5-O4w9oQ&oe=68084E88',
    'https://vulcanpost.com/wp-content/uploads/2024/05/anywheel-singapore-1024x533.jpg',
    'https://i.imgur.com/SBi3ZZg.png',
  ];

  // รายการลิงก์ที่ต้องการให้เปิดเมื่อคลิกที่แต่ละแบนเนอร์
  final List<String> bannerLinks = [
    'https://g.co/kgs/qJTNcHs', // ลิงก์สำหรับแบนเนอร์ที่ 1
    'https://www.anywheel.co.th/', // ลิงก์สำหรับแบนเนอร์ที่ 2
    'https://www.pwa.co.th/contents/service', // ลิงก์สำหรับแบนเนอร์ที่ 3
  ];

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    // ใช้ Timer เพื่อ auto scroll ทุก 5 วินาที
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.toInt() + 1;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // ฟังก์ชันเปิด URL
  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Couldn't open the link: $url")));
    }
  }

  // ฟังก์ชันค้นหาผ่านอินเทอร์เน็ต (ค้นหาผ่าน Google)
  Future<void> performSearch() async {
    final String searchUrl = "https://www.google.com/search?q=$searchQuery";
    await openUrl(searchUrl);
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
        MaterialPageRoute(
          builder: (_) => const AchievementPage(title: "Achievements"),
        ),
      );
    } else if (index == 4) {
      // Already on ProductPage
    }
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
                // แก้ไขปุ่ม Setting และ Profile ให้อยู่ใน Row
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SettingPage(),
                            ),
                          );
                        },
                      ),
                      const Icon(
                        Icons.account_circle_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
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
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Search Products & Services",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // ปุ่มค้นหา (Custom Internet Search)
                if (searchQuery.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: performSearch,
                      child: Text("ค้นหา: $searchQuery"),
                    ),
                  ),
                const SizedBox(height: 50),
                // Banner ที่เลื่อนสลับไปมาแบบ infinite loop
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: null,
                    itemBuilder: (context, index) {
                      int displayIndex = index % bannerImages.length;
                      String bannerUrl = bannerImages[displayIndex];
                      String bannerLink = bannerLinks[displayIndex];

                      return Center(
                        child: GestureDetector(
                          onTap: () async {
                            await openUrl(bannerLink);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              bannerUrl,
                              width: MediaQuery.of(context).size.width * 0.8,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 50),
                // กล่องไอคอน
                Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildIconBox(
                        Icons.local_drink,
                        "Glass",
                        Colors.orange,
                        'https://www.google.com/search?q=Eco-friendly+glass',
                      ),
                      _buildIconBox(
                        Icons.local_cafe,
                        "Cafe",
                        Colors.brown,
                        'https://www.google.com/search?q=Eco-friendly+cafe',
                      ),
                      _buildIconBox(
                        Icons.shopping_bag,
                        "Bag",
                        Colors.blue,
                        'https://www.google.com/search?q=Eco-friendly+bag',
                      ),
                      _buildIconBox(
                        Icons.shower,
                        "Shower",
                        Colors.cyan,
                        'https://www.google.com/search?q=Eco-friendly+shower',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                // แถวของภาพสินค้า
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildProductImage(
                        "Image 1",
                        'https://i.imgur.com/95w0GAh.png', // ลิงก์ของภาพ
                        'https://www.google.com/search?q=Eco-friendly+glass', // ลิงก์ที่จะเปิดเมื่อคลิก
                      ),
                      const SizedBox(width: 16),
                      _buildProductImage(
                        "Image 2",
                        'https://i.imgur.com/SrFt44F.png', // ลิงก์ของภาพ
                        'https://www.google.com/search?q=Eco-friendly+bottle', // ลิงก์ที่จะเปิดเมื่อคลิก
                      ),
                      const SizedBox(width: 16),
                      _buildProductImage(
                        "Image 3",
                        'https://i.imgur.com/QFrSI3E.png', // ลิงก์ของภาพ
                        'https://www.google.com/search?q=Eco-friendly+lunchbox', // ลิงก์ที่จะเปิดเมื่อคลิก
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
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

  // ฟังก์ชันสร้างกล่องไอคอนที่สามารถคลิกได้
  Widget _buildIconBox(IconData icon, String label, Color color, String url) {
    return InkWell(
      onTap: () async {
        await openUrl(url); // เปิดลิงก์เมื่อคลิกที่ไอคอน
      },
      child: Container(
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
        child: Column(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันสร้าง widget สำหรับผลิตภัณฑ์ (สินค้าคลิกได้)
  Widget _buildProductImage(String label, String imageUrl, String linkUrl) {
    return InkWell(
      onTap: () async {
        await openUrl(linkUrl); // เมื่อคลิกที่ภาพ จะเปิดลิงก์ที่กำหนด
      },
      child: Container(
        color: Colors.grey[300],
        width: 150,
        height: 150,
        child: Center(
          child: Image.network(
            // ใช้ Image.network เพื่อแสดงภาพจาก URL
            imageUrl, // ลิงก์ของภาพที่ต้องการแสดง
            width: double.infinity,  // ใช้ความกว้างของ Container เต็ม
            height: double.infinity,  // ใช้ความสูงของ Container เต็ม
            fit: BoxFit.cover, // ทำให้ภาพเต็มพื้นที่โดยไม่ตัดภาพ
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
        children:
            icons.asMap().entries.map((entry) {
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
