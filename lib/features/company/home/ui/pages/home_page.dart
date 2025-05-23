import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/home/ui/pages/chat_page.dart';
import 'package:rociny/features/company/home/ui/pages/collaboration_page.dart';
import 'package:rociny/features/company/home/ui/pages/profile_page.dart';
import 'package:rociny/features/company/home/ui/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

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
                  SearchPage(),
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
          buildNavigationIcon(0, ["assets/svg/house.svg", "assets/svg/house_full.svg"], "home".translate()),
          buildNavigationIcon(1, ["assets/svg/chat.svg", "assets/svg/chat_full.svg"], "messages".translate()),
          buildNavigationIcon(2, ["assets/svg/box.svg", "assets/svg/box_full.svg"], "collaboration".translate()),
          buildNavigationIcon(3, ["assets/svg/people.svg", "assets/svg/people_full.svg"], "profile".translate()),
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
              width: 20,
              height: 20,
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
