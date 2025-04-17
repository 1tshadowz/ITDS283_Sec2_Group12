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
    'https://i.imgur.com/95w0GAh.png',
    'https://i.imgur.com/X6PWoQ9.png',
    'https://i.imgur.com/SBi3ZZg.png',
  ];

  // รายการลิงก์ที่ต้องการให้เปิดเมื่อคลิกที่แต่ละแบนเนอร์
  final List<String> bannerLinks = [
    'https://www.google.com/search?sca_esv=735ec2de70d5467b&rlz=1C1GCEU_enTH1126TH1126&sxsrf=AHTn8zqyZQiH4G2zyFHMZztqutzqcXfqHg:1744916924911&q=%E0%B9%81%E0%B8%81%E0%B9%89%E0%B8%A7%E0%B8%99%E0%B9%89%E0%B8%B3%E0%B8%A3%E0%B8%B1%E0%B8%81%E0%B8%A9%E0%B9%8C%E0%B9%82%E0%B8%A5%E0%B8%81&tbm=shop&source=lnms&fbs=ABzOT_CvTum9bfMS_keiIOkwIHYPL2NLy9MqS8Azaqg6O_R6uNVUIAWq8JLvWaEk3Zdd2l6KCGhJyyacOPtOG3FcnmfFNSpIpI9jyrtF-Ijhe0gRvF4FurmYBKdDHSNQGNXTowug0850eRlaLTx9ujegvEAOYE4xZb8iXt3JWiAgJESCKwqPJSVYp8-gXPWLK4DNQgqnI7Ovh3k6KRzjRs_qCOuQRpGRacd2SOLXvZDoc25MPBfhYIej0zCj1cuAmoNDDwhFUkMUTnhbuq74NISJABwMqo9R61JbprQm9dQTQ93e6wpcg00&ved=1t:200715&ictx=111&biw=1920&bih=963&dpr=1', // ลิงก์สำหรับแบนเนอร์ที่ 1
    'https://chillpainai.com/scoop/15580/10-%E0%B8%84%E0%B8%B2%E0%B9%80%E0%B8%9F%E0%B9%88%E0%B8%A2%E0%B9%88%E0%B8%B2%E0%B8%99%E0%B8%9E%E0%B8%B8%E0%B8%97%E0%B8%98%E0%B8%A1%E0%B8%93%E0%B8%91%E0%B8%A5-%E0%B8%9A%E0%B8%A3%E0%B8%A3%E0%B8%A2%E0%B8%B2%E0%B8%81%E0%B8%B2%E0%B8%A8%E0%B8%8A%E0%B8%B4%E0%B8%A5-%E0%B8%99%E0%B9%88%E0%B8%B2%E0%B9%84%E0%B8%9B%E0%B9%80%E0%B8%8A%E0%B9%87%E0%B8%84%E0%B8%AD%E0%B8%B4%E0%B8%99', // ลิงก์สำหรับแบนเนอร์ที่ 2
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
        // ใช้ SafeArea เพื่อหลีกเลี่ยงปัญหาจากพื้นที่ที่ทับซ้อน
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // เพิ่มการแสดงผลเหมือนใน AppBar โดยใช้ Row
                Row(
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
                      _buildIconBox(Icons.local_drink, "Glass", Colors.orange),
                      _buildIconBox(Icons.local_cafe, "Cafe", Colors.brown),
                      _buildIconBox(Icons.shopping_bag, "Bag", Colors.blue),
                      _buildIconBox(Icons.shower, "Shower", Colors.cyan),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                // แถวของภาพสินค้า
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildProductImage("Image 1"),
                      const SizedBox(width: 16),
                      _buildProductImage("Image 2"),
                      const SizedBox(width: 16),
                      _buildProductImage("Image 3"),
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
  Widget _buildIconBox(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("$label clicked")));
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
  Widget _buildProductImage(String label) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("$label clicked")));
      },
      child: Container(
        color: Colors.grey[300],
        width: 150,
        height: 150,
        child: Center(child: Text(label)),
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
