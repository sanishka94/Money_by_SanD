// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
// pages
import 'pages/tabs_page.dart';
import 'pages/intro_page.dart';
// screens
import './screens/home_screen.dart';
import './screens/budgets_screen.dart';
import './screens/accounts_screen.dart';
import './screens/analytics_screen.dart';
import './screens/edit_account_screen.dart';
// providers
import './providers/transactions.dart';
import './providers/accounts.dart';
import './providers/categories.dart';
import './providers/settings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Color primaryColor = Colors.purple;
  // Color primaryColor = Colors.red[700];
  Color secondaryColor = Colors.green[800];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Transactions(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Accounts(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Categories(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Settings(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Money by SanD',
        theme: ThemeData(
            primaryColor: primaryColor,
            colorScheme: ColorScheme(
              background: Colors.white,
              onBackground: Colors.black,
              brightness: Brightness.light,
              primary: primaryColor,
              onPrimary: Colors.white,
              secondary: secondaryColor,
              onSecondary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
              primaryVariant: primaryColor,
              secondaryVariant: secondaryColor,
              onError: Colors.white,
              error: Colors.red,
            )),
        home: IntroPage(),
        routes: {
          IntroPage.routeName: (ctx) => IntroPage(),
          TabsPage.ruteName: (ctx) => TabsPage(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          BudgetsScreen.routeName: (ctx) => BudgetsScreen(),
          AccountsScreen.routeName: (ctx) => AccountsScreen(),
          AnalyticsScreen.routeName: (ctx) => AnalyticsScreen(),
          EditAccountScreen.routeName: (ctx) => EditAccountScreen(),
          // DisplayTransactionsPage.routeName: (ctx) => DisplayTransactionsPage(),
        },
      ),
    );
  }
}
