import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zqsjrgocsycacmcpsvxm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpxc2pyZ29jc3ljYWNtY3BzdnhtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1ODUxMTEsImV4cCI6MjA5NzE2MTExMX0.6yJFN10XJK3pT1kjoAzOjBqbF6Qaki_IlkAOarJu9Rg',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TestScreen(),
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final supabase = Supabase.instance.client;
  String output = 'Fetching...';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

Future<void> fetchData() async {
  final service = SupabaseService();

  final places = await service.getPlaces();
  print('PLACES: $places');

  final foods = await service.getFoods();
  print('FOODS: $foods');

  final clothes = await service.getClothes();
  print('CLOTHES: $clothes');

  final words = await service.getWords();
  print('WORDS: $words');

  final plan = await service.getAIPlan(
    query: 'family trip to Jharkhand',
    budget: 10000,
  );
  print('AI PLAN: $plan');

  setState(() {
    output = 'All checks passed. See terminal for data.';
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(output),
        ),
      ),
    );
  }
}