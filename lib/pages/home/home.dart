import 'package:dyg/pages/home/personalization/personalization.dart';
import 'package:dyg/pages/home/recommendations/recommendations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {required this.accessToken, required this.refreshToken, super.key});
  final String accessToken;
  final String refreshToken;

  @override
  State<HomePage> createState() =>
      _HomePageState(accessToken: accessToken, refreshToken: refreshToken);
}

class _HomePageState extends State<HomePage> {
  _HomePageState({required String accessToken, required String refreshToken}) {
    screens = [
      PersonalizationPage(accessToken: accessToken, refreshToken: refreshToken),
      RecommendationsPage(accessToken: accessToken, refreshToken: refreshToken),
      const Center(child: Text('3rd Screen')),
    ];
  }

  late List<Widget> screens;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: _buildBNB(),
      ),
    );
  }

  BottomNavigationBar _buildBNB() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      selectedItemColor: Colors.black,
      onTap: changeScreen,
      currentIndex: _currentIndex,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 0.0,
      items: const [
        BottomNavigationBarItem(
          backgroundColor: Color(0xFFc2f0f2),
          icon: FaIcon(
            FontAwesomeIcons.house,
            color: Color.fromARGB(255, 84, 80, 80),
          ),
          activeIcon: FaIcon(
            FontAwesomeIcons.house,
            size: 25,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.compactDisc,
            color: Color.fromARGB(255, 84, 80, 80),
          ),
          activeIcon: FaIcon(
            FontAwesomeIcons.compactDisc,
            size: 25,
          ),
          label: 'Recommendations',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.userGroup,
            color: Color.fromARGB(255, 84, 80, 80),
          ),
          activeIcon: FaIcon(
            FontAwesomeIcons.userGroup,
            size: 25,
          ),
          label: 'Friend Activity',
        ),
      ],
    );
  }

  void changeScreen(int value) {
    setState(() => _currentIndex = value);
  }
}
