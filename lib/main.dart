import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshing_co/repository/auth_service.dart';
import 'package:refreshing_co/repository/cafe_repository.dart';
import 'package:refreshing_co/repository/cart_service.dart';
import 'package:refreshing_co/repository/notification_service.dart';
import 'package:refreshing_co/repository/product_service.dart';
import 'package:refreshing_co/res/app_router.dart';
import 'package:refreshing_co/view/app_screens/landing_page.dart';
import 'package:refreshing_co/view/auth/sign_in_screen.dart';
import 'package:refreshing_co/view/splash_screen.dart';

import 'bloc/auth_bloc/auth_bloc.dart';
import 'bloc/cafe_bloc/cafe_bloc.dart';
import 'bloc/cart_bloc/cart_bloc.dart';
import 'bloc/notification_bloc/notification_bloc.dart';
import 'bloc/product_bloc/product_bloc.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authService: AuthRepository())..add(CheckAuthStatus()),

        ),
        BlocProvider(
          create: (context) => CafeBloc(cafeService: CafeService()),
        ),
        BlocProvider(
          create: (context) => CartBloc(cartService: CartService()),
        ),
        BlocProvider(
          create: (context) => ProductBloc(
            productService: ProductService(authService: AuthRepository()),
            authService: AuthRepository(),
            cartBloc: context.read<CartBloc>(),
            useAutoTokens: true, // Enable auto tokens
          ),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) => NotificationBloc(
            notificationService: NotificationService(

            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Refreshing.co',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: _appRoutes.onGenerateRoute,

        home: const AuthWrapper(),
      ),
    );
  }
}
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Handle specific state transitions with user feedback
        if (state is TokenRefreshed) {
          // Optional: Show subtle notification that token was refreshed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session refreshed'),
              duration: Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        if (state is AuthError) {
          // Show error messages for auth failures
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () {
                  // Retry auth check
                  context.read<AuthBloc>().add(CheckAuthStatus());
                },
              ),
            ),
          );
        }

        if (state is AuthSignInSuccess) {
          // Show welcome message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome back, ${state.user.email}!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        if (state is AuthSignedOut) {
          // Show logout confirmation
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully signed out'),
              backgroundColor: Colors.blue,
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return _buildScreenForState(context, state);
      },
    );
  }

  Widget _buildScreenForState(BuildContext context, AuthState state) {
    switch (state.runtimeType) {
      case AuthInitial:
      case AuthLoading:
        return const SplashScreen();

      case TokenRefreshing:
        return const SplashScreen();

      case AuthAuthenticated:
      case AuthSignInSuccess:
      case AuthOTPVerificationSuccess:
        return LandingPage(selectedIndex: 0);

      case AuthSignUpSuccess:

        return const SignInScreen();

      case TokenRefreshed:
        return LandingPage(selectedIndex: 0);

      case AuthSignedOut:
        return const SignInScreen();

      case AuthError:
        return SignInScreen();

      default:
        return const SignInScreen();
    }
  }
}