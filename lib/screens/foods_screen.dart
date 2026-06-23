import 'package:flutter/material.dart';
import '../core/services/supabase_service.dart';
import '../widgets/animated_list_item.dart';
import '../widgets/story_sheet.dart';

class FoodsScreen extends StatefulWidget {
  const FoodsScreen({super.key});

  @override
  State<FoodsScreen> createState() => _FoodsScreenState();
}

class _FoodsScreenState extends State<FoodsScreen> {
  final _service = SupabaseService();
  List<Map<String, dynamic>>? _foods;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final foods = await _service.getFoods();
      setState(() { _foods = foods; _error = null; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _enrich(Map<String, dynamic> food) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final story = await _service.enrichContent(
        type: 'cuisine',
        name: food['name'] ?? 'Unknown',
        baseDescription: food['description'] ?? '',
      );
      if (!mounted) return;
      Navigator.pop(context);
      showStorySheet(context, story);
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('AI enrichment failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Traditional Cuisine')),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.cloud_off, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('Something went wrong', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(_error!, style: TextStyle(color: Colors.grey.shade600), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.tonal(onPressed: _load, child: const Text('Try Again')),
          ]),
        ),
      );
    }
    if (_foods == null || _foods!.isEmpty) return const Center(child: Text('No foods found'));

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: _foods!.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final food = _foods![index];
          return AnimatedListItem(
            index: index,
            child: _ContentCard(
              index: index + 1,
              name: food['name'] ?? '',
              description: food['description'] ?? '',
              onEnrich: () => _enrich(food),
            ),
          );
        },
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  final int index;
  final String name;
  final String description;
  final VoidCallback onEnrich;

  const _ContentCard({
    required this.index,
    required this.name,
    required this.description,
    required this.onEnrich,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.deepOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.restaurant, color: Colors.deepOrange.shade600, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: onEnrich,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                minimumSize: Size.zero,
                backgroundColor: Colors.deepOrange.withValues(alpha: 0.1),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.auto_awesome, size: 15, color: Colors.deepOrange.shade700),
                const SizedBox(width: 6),
                Text('Enrich', style: TextStyle(fontSize: 13, color: Colors.deepOrange.shade700)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
