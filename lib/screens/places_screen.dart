import 'package:flutter/material.dart';
import '../core/services/supabase_service.dart';
import '../widgets/animated_list_item.dart';
import '../widgets/story_sheet.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final _service = SupabaseService();
  List<Map<String, dynamic>>? _places;
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
      final places = await _service.getPlaces();
      setState(() { _places = places; _error = null; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _enrich(Map<String, dynamic> place) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final story = await _service.enrichContent(
        type: 'mythology',
        name: place['name'] ?? 'Unknown',
        baseDescription: place['description'] ?? '',
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
      appBar: AppBar(title: const Text('Mythology & Legends')),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text('Something went wrong', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: Colors.grey.shade600), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.tonal(onPressed: _load, child: const Text('Try Again')),
            ],
          ),
        ),
      );
    }
    if (_places == null || _places!.isEmpty) {
      return const Center(child: Text('No places found'));
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: _places!.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final place = _places![index];
          return AnimatedListItem(
            index: index,
            child: _ContentCard(
              index: index + 1,
              name: place['name'] ?? '',
              description: place['description'] ?? '',
              onEnrich: () => _enrich(place),
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
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text('$index', style: TextStyle(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
              ),
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
              ),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.auto_awesome, size: 15),
                SizedBox(width: 6),
                Text('Enrich', style: TextStyle(fontSize: 13)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
