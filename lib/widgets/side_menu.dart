import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:kami_saiyo_admin_panel/authentication/login_screen.dart';
import 'package:kami_saiyo_admin_panel/inner_screens/all_orders.dart';
import 'package:kami_saiyo_admin_panel/inner_screens/all_products.dart';
import 'package:kami_saiyo_admin_panel/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';
import '../screens/main_screen.dart';
import '../services/utils.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final themeState = Provider.of<DarkThemeProvider>(context);

    final color = Utils(context).color;
    return Drawer(
      backgroundColor:
          themeState.getDarkTheme ? const Color(0xFF00001a) : Colors.yellow,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset(
              themeState.getDarkTheme
                  ? "assets/images/logo_ks_contrass.png"
                  : "assets/images/logo_ks.png",
            ),
          ),
          DrawerListTile(
            title: "Main",
            press: () {
              Navigator.pushReplacementNamed(context, MainScreen.routeName);
            },
            icon: Icons.home_filled,
          ),
          DrawerListTile(
            title: "Semua Produk",
            press: () {
              Navigator.pushReplacementNamed(
                  context, AllProductsScreen.routeName);
            },
            icon: Icons.store,
          ),
          DrawerListTile(
            title: "Semua Pesanan",
            press: () {
              Navigator.pushReplacementNamed(
                  context, AllOrdersScreen.routeName);
            },
            icon: IconlyBold.bag_2,
          ),
          SwitchListTile(
              title: const Text('Tema'),
              secondary: Icon(themeState.getDarkTheme
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined),
              value: theme,
              onChanged: (value) {
                setState(() {
                  themeState.setDarkTheme = value;
                });
              }),
          DrawerListTile(
              title: "Logout",
              press: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const LoginScreen()));
              },
              icon: Icons.logout)
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.press,
    required this.icon,
  }) : super(key: key);

  final String title;
  final VoidCallback press;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;

    return ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: Icon(
          icon,
          size: 18,
        ),
        title: TextWidget(
          text: title,
          color: color,
        ));
  }
}
