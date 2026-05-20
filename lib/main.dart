import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/app_state_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
      ],
      child: MaterialApp(
        title: 'SentrySafe Eyewear',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF080C14),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF9E00), // High-Vis Safety Amber
            primary: const Color(0xFFFF9E00),
            secondary: const Color(0xFFFFB703),
            surface: const Color(0xFF0F172A),
            background: const Color(0xFF080C14),
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.outfitTextTheme(
            ThemeData.dark().textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        home: Consumer<AppStateProvider>(
          builder: (context, state, child) {
            return state.isLoggedIn ? const HomeScreen() : const LoginScreen();
          },
        ),
      ),
    );
  }
}
