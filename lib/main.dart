import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refreshing_co/res/app_router.dart';
import 'package:refreshing_co/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
  }) : super(key: key);

  final AppRouter _appRoutes = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Refreshing.co',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _appRoutes.onGenerateRoute,
      //theme: theme,
      //darkTheme: darkTheme,
      home: const SplashScreen(),
    );
  }
}
