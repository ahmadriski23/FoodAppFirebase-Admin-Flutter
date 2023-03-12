import 'package:flutter/material.dart';
import 'package:kami_saiyo_admin_panel/controllers/MenuControllers.dart';
import 'package:kami_saiyo_admin_panel/responsive.dart';
import 'package:kami_saiyo_admin_panel/services/utils.dart';
import 'package:kami_saiyo_admin_panel/widgets/header.dart';
import 'package:kami_saiyo_admin_panel/widgets/orders_list.dart';
import 'package:kami_saiyo_admin_panel/widgets/side_menu.dart';
import 'package:provider/provider.dart';

class AllOrdersScreen extends StatefulWidget {
  static const routeName = '/AllOrdersScreen';
  const AllOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      key: context.read<CustomMenuController>().getOrdersScaffoldKey,
      drawer: const SideMenu(),
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
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Header(
                        showTextField: false,
                        fct: () {
                          context
                              .read<CustomMenuController>()
                              .controlAllOrder();
                        },
                        title: 'Semua Pesanan',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: OrdersList(
                          isInDashboard: false,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
