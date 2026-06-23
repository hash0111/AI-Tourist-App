import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../core/services/supabase_service.dart';
import '../widgets/story_sheet.dart';

class ClothesDetailScreen extends StatefulWidget {
  final String name;
  final String description;
  final String imagePath;

  const ClothesDetailScreen({
    super.key,
    required this.name,
    required this.description,
    this.imagePath = 'assets/images/clothes.jpg',
  });

  @override
  State<ClothesDetailScreen> createState() => _ClothesDetailScreenState();
}

class _ClothesDetailScreenState extends State<ClothesDetailScreen> {
  final _service = SupabaseService();
  Map<String, dynamic>? _story;
  bool _loadingStory = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHero(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text(widget.description, style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary, height: 1.6)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _loadingStory ? null : _enrichStory,
                      icon: _loadingStory
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.auto_stories),
                      label: Text(_loadingStory ? 'Discovering...' : 'Discover the Story Behind This Attire'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.saffron,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  if (_story != null) ...[
                    const SizedBox(height: 20),
                    _buildStory(theme),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: AppColors.deepIndigo,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Image.asset(widget.imagePath, height: 240, width: double.infinity, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.deepIndigo.withValues(alpha: 0.7)],
                ),
              ),
            ),
            Positioned(
              left: 20, right: 20, bottom: 20,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.saffron, borderRadius: BorderRadius.circular(8)),
                    child: const Text('Traditional Attire', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStory(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_story!['originHistory'] != null) ...[
          _section('Origin & History', _story!['originHistory']),
          const SizedBox(height: 14),
        ],
        if (_story!['materials'] != null) ...[
          _listSection('Materials', List<String>.from(_story!['materials'])),
          const SizedBox(height: 14),
        ],
        if (_story!['craftsmanship'] != null) ...[
          _section('Craftsmanship', _story!['craftsmanship']),
          const SizedBox(height: 14),
        ],
        if (_story!['culturalSignificance'] != null) ...[
          _section('Cultural Significance', _story!['culturalSignificance']),
          const SizedBox(height: 14),
        ],
        if (_story!['occasionsWorn'] != null) ...[
          _listSection('Occasions Worn', List<String>.from(_story!['occasionsWorn'])),
          const SizedBox(height: 14),
        ],
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => showStorySheet(context, _story!),
            icon: const Icon(Icons.fullscreen),
            label: const Text('Read Full Story'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              side: const BorderSide(color: AppColors.saffron),
              foregroundColor: AppColors.saffron,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _section(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(width: 3, height: 16, decoration: BoxDecoration(color: AppColors.saffron, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary)),
        ]),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 14, height: 1.6, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _listSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(width: 3, height: 16, decoration: BoxDecoration(color: AppColors.saffron, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary)),
        ]),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8,
          children: items.map((item) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.saffronLight, borderRadius: BorderRadius.circular(10)),
            child: Text(item, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
          )).toList(),
        ),
      ],
    );
  }

  Future<void> _enrichStory() async {
    setState(() => _loadingStory = true);
    try {
      final story = await _service.enrichContent(
        type: 'clothes',
        name: widget.name,
        baseDescription: widget.description,
      );
      if (!mounted) return;
      setState(() { _story = story; _loadingStory = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingStory = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    }
  }
}
