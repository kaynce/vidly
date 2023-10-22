import 'package:flutter/material.dart';
import 'package:vidly/views/home_view.dart';
import 'package:vidly/views/login_view.dart';
import 'package:vidly/views/rented_movies_view.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String? title;

  CustomAppBar({required this.title});
  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 3.0,
            spreadRadius: 1.0,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
      ),
      child: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 6,
            ),
            Text(
              title.toString(),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                size: 30,
                color: Color(0xFF35C2B1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF0E2D52),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: //Image.asset('assets/img/iRely.png'),
                  Center(
                child: Text(
                  'Vidly',
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.dashboard,
                color: Colors.white,
              ),
              title: Text(
                'Movies',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomeView()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.movie, color: Colors.white),
              title: const Text(
                'Rented Movies',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RentedMoviesView()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginView(),
                  ),
                );
              },
            ),
            // Add more items as needed
          ],
        ),
      ),
    );
  }
}
