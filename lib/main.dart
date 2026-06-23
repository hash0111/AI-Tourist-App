import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants/colors.dart';
import 'screens/bottom_nav_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zqsjrgocsycacmcpsvxm.supabase.co',
    publishableKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpxc2pyZ29jc3ljYWNtY3BzdnhtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1ODUxMTEsImV4cCI6MjA5NzE2MTExMX0.6yJFN10XJK3pT1kjoAzOjBqbF6Qaki_IlkAOarJu9Rg',
  );

  await Supabase.instance.client.auth.signInAnonymously();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jharkhand Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.deepIndigo,
          primary: AppColors.deepIndigo,
          secondary: AppColors.saffron,
          tertiary: AppColors.turmericGold,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.surfaceBg,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.deepIndigo,
        ),
        navigationBarTheme: NavigationBarThemeData(
          elevation: 0,
          backgroundColor: Colors.white,
          indicatorColor: AppColors.saffron.withValues(alpha: 0.15),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (_) => const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return const IconThemeData(color: AppColors.saffron, size: 24);
            return const IconThemeData(color: AppColors.textSecondary, size: 24);
          }),
        ),
        dividerTheme: DividerThemeData(color: AppColors.divider, thickness: 1, space: 0),
      ),
      home: const BottomNavShell(),
    );
  }
}
