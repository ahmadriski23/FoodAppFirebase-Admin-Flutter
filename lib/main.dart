import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kami_saiyo_admin_panel/authentication/login_screen.dart';
import 'package:kami_saiyo_admin_panel/consts/theme_data.dart';
import 'package:kami_saiyo_admin_panel/controllers/MenuControllers.dart';
import 'package:kami_saiyo_admin_panel/inner_screens/add_prod.dart';
import 'package:kami_saiyo_admin_panel/inner_screens/all_orders.dart';
import 'package:kami_saiyo_admin_panel/inner_screens/all_products.dart';
import 'package:kami_saiyo_admin_panel/inner_screens/edit_prod.dart';
import 'package:kami_saiyo_admin_panel/providers/dark_theme_provider.dart';
import 'package:kami_saiyo_admin_panel/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBqoiVtJPsWq--Y3FiWpNgoLq5mY8PwB44",
          authDomain: "online-app---riski.firebaseapp.com",
          projectId: "online-app---riski",
          storageBucket: "online-app---riski.appspot.com",
          messagingSenderId: "1033258361711",
          appId: "1:1033258361711:web:74722b3fe1c510cad43e9a",
          measurementId: "G-C7GX767Y9M"));
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Center(
                    child: Text('App is being initialized'),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Center(
                    child: Text('An error has been occured ${snapshot.error}'),
                  ),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => CustomMenuController(),
              ),
              ChangeNotifierProvider(
                create: (_) {
                  return themeChangeProvider;
                },
              ),
            ],
            child: Consumer<DarkThemeProvider>(
              builder: (context, themeProvider, child) {
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Kami Saiyo Admin',
                    theme:
                        Styles.themeData(themeProvider.getDarkTheme, context),
                    home: const LoginScreen(),
                    routes: {
                      '/DashboardScreen': (context) => const MainScreen(),
                      UploadProductForm.routeName: (context) =>
                          const UploadProductForm(),
                      AllProductsScreen.routeName: (context) =>
                          const AllProductsScreen(),
                      AllOrdersScreen.routeName: (context) =>
                          const AllOrdersScreen(),
                    });
              },
            ),
          );
        });
  }
}
