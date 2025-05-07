import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homestay_host/src/features/dashboard/screens/widgets/main_carousel.dart';
import 'package:homestay_host/src/features/dashboard/screens/widgets/my_drawer.dart';
import 'package:homestay_host/src/features/dashboard/screens/widgets/my_listing.dart';
import 'package:homestay_host/src/themes/extensions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            MainCarousel(),
            // Your listings
            ListingView(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-listing');
        },
        child: Icon(
          Icons.add,
          color: context.theme.colorScheme.primary,
        ),
      ),
    );
  }
}
