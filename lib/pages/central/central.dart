import 'home/home.dart';
import 'recommendations/recommendations.dart';
import 'tasteCompate/taste_compare.dart';
import '../../providers/top_tracks_done.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class CentralPage extends StatefulWidget {
  const CentralPage(
      {required this.accessToken, required this.refreshToken, super.key});
  final String accessToken;
  final String refreshToken;

  @override
  State<CentralPage> createState() =>
      _CentralPageState(accessToken: accessToken, refreshToken: refreshToken);
}

class _CentralPageState extends State<CentralPage> {
  _CentralPageState({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;
  late List<Widget> screens;
  int _currentIndex = 0;
  final AudioPlayer player = AudioPlayer();

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (_) => TopTracksDone(),
        child: Scaffold(
          // To prevent distortion of images when user taps on textfield.
          resizeToAvoidBottomInset: false,
          body: IndexedStack(
            index: _currentIndex,
            children: [
              HomePage(
                accessToken: accessToken,
                refreshToken: refreshToken,
                player: player,
              ),
              RecommendationsPage(
                accessToken: accessToken,
                refreshToken: refreshToken,
                player: player,
              ),
              TasteCompare(
                accessToken: accessToken,
                refreshToken: refreshToken,
              ),
            ],
          ),
          bottomNavigationBar: _buildBNB(),
        ),
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
