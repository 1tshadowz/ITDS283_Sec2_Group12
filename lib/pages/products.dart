import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'track.dart';
import 'activity.dart';
import 'dashboard.dart';
import 'achievement.dart';
import 'setting.dart';
import 'test.dart'; // เพิ่มการ import ไฟล์ test.dart ที่มี TestPage

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
    'https://www.baankrongnam.com/uploads/products/5/510/5ef163e5cf18d6b562d236a1a25a7b77.jpg',
    'https://fastly.picsum.photos/id/9/5000/3269.jpg?hmac=cZKbaLeduq7rNB8X-bigYO8bvPIWtT-mh8GRXtU3vPc',
    'https://fastly.picsum.photos/id/11/2500/1667.jpg?hmac=xxjFJtAPgshYkysU_aqx2sZir-kIOjNR9vx0te7GycQ',
  ];

  // รายการลิงก์ที่ต้องการให้เปิดเมื่อคลิกที่แต่ละแบนเนอร์
  final List<String> bannerLinks = [
    'https://www.baankrongnam.com/product/ro-rain-1', // ลิงก์สำหรับแบนเนอร์ที่ 1
    'https://www.google.com', // ลิงก์สำหรับแบนเนอร์ที่ 2
    'https://www.example3.com', // ลิงก์สำหรับแบนเนอร์ที่ 3
  ];

  // Dummy data สำหรับ search (Product & Service ที่เกี่ยวกับการลดการใช้น้ำ)
  final List<String> allProducts = [
    "Water Saving Kit",
    "Efficient Shower Head",
    "Low Flow Faucet",
    "Rainwater Harvesting System",
    "Water Filter",
    "Eco-friendly Toilet",
    "Solar Water Heater",
  ];
  String searchQuery = "";

  List<String> get filteredProducts {
    if (searchQuery.isEmpty) {
      return [];
    }
    return allProducts
        .where((product) =>
            product.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't open the link: $url")),
      );
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
            builder: (_) => const AchievementPage(title: "Achievements")),
      );
    } else if (index == 4) {
      // Already on ProductPage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ECAC4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8ECAC4),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon:
                  const Icon(Icons.settings, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingPage()),
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
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              // เพิ่มปุ่มใหม่เพื่อไปยัง test.dart (TestPage)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TestLinkPage()),
                    );
                  },
                  child: const Text("Go to Test Page"),
                ),
              ),
              const SizedBox(height: 20),
            ],
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$label clicked")),
        );
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$label clicked")),
        );
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
