import 'package:flutter/material.dart';
import 'package:kami_saiyo_admin_panel/consts/constant.dart';
import 'package:kami_saiyo_admin_panel/controllers/MenuControllers.dart';
import 'package:kami_saiyo_admin_panel/inner_screens/add_prod.dart';
import 'package:kami_saiyo_admin_panel/inner_screens/all_products.dart';
import 'package:kami_saiyo_admin_panel/responsive.dart';
import 'package:kami_saiyo_admin_panel/services/utils.dart';
import 'package:kami_saiyo_admin_panel/widgets/grid_products.dart';
import 'package:kami_saiyo_admin_panel/widgets/header.dart';
import 'package:kami_saiyo_admin_panel/widgets/orders_list.dart';
import 'package:kami_saiyo_admin_panel/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/buttons_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    Color color = Utils(context).color;
    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              title: 'Dashboard',
              fct: () {
                context.read<CustomMenuController>().controlDashboardMenu();
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextWidget(text: 'Produk Terbaru', color: color),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ButtonsWidget(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, AllProductsScreen.routeName);
                      },
                      text: 'Lihat Semua',
                      icon: Icons.store,
                      backgroundColor: Colors.yellow),
                  const Spacer(),
                  ButtonsWidget(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, UploadProductForm.routeName);
                      },
                      text: 'Tambah Produk',
                      icon: Icons.add,
                      backgroundColor: Colors.yellow),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // flex: 5,
                  child: Column(
                    children: [
                      Responsive(
                        mobile: ProductGridWidget(
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                        ),
                        desktop: ProductGridWidget(
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                        ),
                      ),
                      OrdersList(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
