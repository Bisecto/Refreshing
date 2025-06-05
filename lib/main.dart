import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshing_co/res/app_router.dart';
import 'package:refreshing_co/view/app_screens/landing_page.dart';
import 'package:refreshing_co/view/auth/sign_in_screen.dart';
import 'package:refreshing_co/view/splash_screen.dart';

import 'bloc/auth_bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Android
      statusBarBrightness: Brightness.light, // iOS
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final AppRouter _appRoutes = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(CheckAuthStatus()),
      child: MaterialApp(
        title: 'Refreshing.co',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: _appRoutes.onGenerateRoute,
        //theme: theme,
        //darkTheme: darkTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const SplashScreen();
        } else if (state is AuthAuthenticated ||
            state is AuthSignInSuccess ||
            state is AuthOTPVerificationSuccess) {
          return  LandingPage(selectedIndex: 0);
        } else {
          return const SignInScreen();
        }
      },
    );
  }
}