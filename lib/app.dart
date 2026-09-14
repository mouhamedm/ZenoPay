import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/otp_verification_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/pin_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class ZenoPayApp extends StatelessWidget {
  const ZenoPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp(
        scrollBehavior: AppScrollBehavior(),
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        title: 'Zeno Pay',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        initialRoute: '/',
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case '/':
        page = const SplashScreen();
      case '/signup':
        page = const SignupScreen();
      case '/otp':
        page = const OtpVerificationScreen();
      case '/login':
        page = const LoginScreen();
      case '/pin':
        page = const PinScreen();
      case '/dashboard':
        page = const DashboardScreen();
      default:
        page = const SplashScreen();
    }

    // -- Smooth fade+slide transition between screens --
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fade = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeIn),
        );
        final slide = Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}
