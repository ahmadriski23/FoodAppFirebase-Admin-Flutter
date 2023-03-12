import 'package:flutter/material.dart';
import 'package:kami_saiyo_admin_panel/consts/constant.dart';
import 'package:kami_saiyo_admin_panel/responsive.dart';
import 'package:kami_saiyo_admin_panel/services/utils.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.title,
    required this.fct,
    this.showTextField = true,
  });
  final String title;
  final Function fct;
  final bool showTextField;

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            onPressed: () {
              fct();
            },
            icon: Icon(Icons.menu),
          ),
        if (Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        if (Responsive.isDesktop(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        !showTextField
            ? Container()
            : Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    fillColor: Theme.of(context).cardColor,
                    filled: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(defaultPadding * 0.75),
                        margin: EdgeInsets.symmetric(
                            horizontal: defaultPadding / 2),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              )
      ],
    );
  }
}
