import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/influencer/home/ui/pages/chat_page.dart';
import 'package:rociny/features/influencer/home/ui/pages/collaboration_page.dart';
import 'package:rociny/features/influencer/home/ui/pages/dashboard_page.dart';
import 'package:rociny/features/influencer/home/ui/pages/profile_page.dart';

/// TODO faire nav sur entreprise et influencer
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// TODO se souvenir du state des 4 pages
class _HomePageState extends State<HomePage> {
  PageController pageController = PageController();
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Column(
          children: [
            /// Pages
            Expanded(
              child: PageView(
                controller: pageController,
                children: const [
                  DashboardPage(),
                  ChatPage(),
                  CollaborationPage(),
                  ProfilePage(),
                ],
              ),
            ),

            /// Navigation
            buildNavigatonIcons(),
          ],
        ),
      ),
    );
  }

  Widget buildNavigatonIcons() {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /// TODO translates
          buildNavigationIcon(0, ["assets/svg/house.svg", "assets/svg/house_full.svg"], "Accueil"),
          buildNavigationIcon(1, ["assets/svg/chat.svg", "assets/svg/chat_full.svg"], "Messages"),
          buildNavigationIcon(2, ["assets/svg/box.svg", "assets/svg/box_full.svg"], "Collaboration"),
          buildNavigationIcon(3, ["assets/svg/people.svg", "assets/svg/people_full.svg"], "Profil"),
        ],
      ),
    );
  }

  Widget buildNavigationIcon(int index, List<String> svgPaths, String label) {
    bool isSelected = index == selectedPage;

    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (!isSelected) {
          setState(() {
            selectedPage = index;
          });
          pageController.jumpToPage(index);
        }
      },
      child: SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              isSelected ? svgPaths[1] : svgPaths[0],
              width: 25,
              height: 25,
              colorFilter: ColorFilter.mode(isSelected ? kPrimary500 : kGrey300, BlendMode.srcIn),
            ),
            const SizedBox(
              height: kPadding5,
            ),
            Text(
              label,
              style: kCaption.copyWith(
                color: isSelected ? kPrimary500 : kGrey300,
              ),
            )
          ],
        ),
      ),
    );
  }
}
