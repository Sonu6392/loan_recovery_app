import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/app_colour.dart';
import 'home/allcustomers/allcustomers_screen.dart';
import 'home/dashboard/dashboard_screen.dart';
import 'home/mycase/mycase_screen.dart';
import 'home/setting/setting_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    DashboardScreen(),
    MycaseScreen(),
    AllcustomersScreen(),
    SettingScreen(),
  ];

  final List<String> iconImages = [
    'assets/icons/dashboard.svg',
    'assets/icons/history.svg',
    'assets/icons/Customers.svg',
    'assets/icons/setting.svg',
  ];

  final List<String> labels = [
    "Dashboard",
    "Case History",
    "All Customers",
    "Setting",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: Container(
        padding:  EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(iconImages.length, (index) {
            bool isSelected = selectedIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      iconImages[index],
                      width: 24,
                      height: 24,
                      color: isSelected ? AppColors.primary : Colors.grey,
                    ),
                     SizedBox(height: 4),
                    Text(
                      labels[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? AppColors.primary : Colors.grey,
                      ),
                    ),

                    SizedBox(height: 4),
                    AnimatedContainer(
                      duration:  Duration(milliseconds: 200),
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}