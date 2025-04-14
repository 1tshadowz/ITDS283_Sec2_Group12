import 'package:flutter/material.dart';
import 'track.dart';
import 'activity.dart';
import 'dashboard.dart';
import 'achievement.dart';
import 'products.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int selectedIndex = 4;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), _autoScroll);
  }

  void _autoScroll() {
    if (_pageController.hasClients) {
      _pageController.nextPage(
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
      Future.delayed(Duration(seconds: 3), _autoScroll);
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
          children: const [
            Icon(Icons.settings, color: Colors.white, size: 28),
            Icon(Icons.account_circle_outlined, color: Colors.white, size: 30),
          ],
        ),
      ),
      body: Column(
        children: [
          // Banner that auto slides
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              itemCount: 3, // Number of images
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey[300], // Placeholder for images
                  child: Center(
                    child: Text(
                      'Banner $index', // Placeholder text
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ),
                );
                // Uncomment and update when images are available
                // return Image.asset(
                //   'assets/images/banner$index.jpg',
                //   fit: BoxFit.cover,
                // );
              },
            ),
          ),
          const SizedBox(height: 50),
          
          // Add the icon boxes between the banner and images
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Icon(Icons.battery_full, color: Colors.orange, size: 40),
                      const Text("Battery", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.coffee, color: Colors.brown, size: 40),
                      const Text("Coffee", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.shopping_bag, color: Colors.blue, size: 40),
                      const Text("Bag", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.shower, color: Colors.cyan, size: 40),
                      const Text("Shower", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),

          // Row of images that can be swiped horizontally
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  color: Colors.grey[300], // Placeholder for image
                  width: 150,
                  height: 150,
                  child: Center(child: Text('Image 1')), // Placeholder text
                ),
                const SizedBox(width: 16),
                Container(
                  color: Colors.grey[300], // Placeholder for image
                  width: 150,
                  height: 150,
                  child: Center(child: Text('Image 2')), // Placeholder text
                ),
                const SizedBox(width: 16),
                Container(
                  color: Colors.grey[300], // Placeholder for image
                  width: 150,
                  height: 150,
                  child: Center(child: Text('Image 3')), // Placeholder text
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: _CustomBottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
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
