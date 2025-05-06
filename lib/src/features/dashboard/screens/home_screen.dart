import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homestay_host/src/features/dashboard/screens/widgets/my_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.grey.shade200,
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Container(
                padding: EdgeInsets.all(16),
                child: SvgPicture.asset(
                  "assets/icons/menu.svg",
                  colorFilter: ColorFilter.mode(
                    Colors.grey.shade700,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            );
          },
        ),
        centerTitle: true,
        actions: [
          InkWell(
            splashFactory: InkRipple.splashFactory,
            onTap: () {
              // Navigator.pushNamed(context, '/search');
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Container(
                padding: EdgeInsets.all(5.5),
                width: 32,
                height: 32,
                child: SvgPicture.asset(
                  "assets/icons/search.svg",
                  colorFilter: ColorFilter.mode(
                    Colors.grey.shade700,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: MyDrawer(),
    );
  }
}