import 'package:flutter/material.dart';
import 'package:kami_saiyo_admin_panel/controllers/MenuControllers.dart';
import 'package:kami_saiyo_admin_panel/responsive.dart';
import 'package:kami_saiyo_admin_panel/screens/dashboard_screen.dart';
import 'package:kami_saiyo_admin_panel/widgets/side_menu.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  static const routeName = '/DashboardScreen';
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<CustomMenuController>().getScaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // We want this side menu only for large screen
          if (Responsive.isDesktop(context))
            Expanded(
              // default flex = 1
              // and it takes 1/6 part of the screen
              child: SideMenu(),
            ),
          Expanded(
            // It takes 5/6 part of the screen
            flex: 5,
            child: DashboardScreen(),
          ),
        ],
      )),
    );
  }
}
