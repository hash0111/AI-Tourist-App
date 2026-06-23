import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import '../core/services/supabase_service.dart';
import '../widgets/story_sheet.dart';

class PlaceDetailScreen extends StatefulWidget {
  final String name;
  final String description;
  final String imagePath;
  final double rating;
  final String location;
  final String category;

  const PlaceDetailScreen({
    super.key,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.rating,
    required this.location,
    this.category = 'place',
  });

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  final _service = SupabaseService();
  Map<String, dynamic>? _story;
  bool _loadingStory = false;
  bool _showFullDesc = false;

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
                  _buildHeader(theme),
                  const SizedBox(height: 16),
                  _buildDescription(theme),
                  const SizedBox(height: 20),
                  _buildActionButtons(theme),
                  const SizedBox(height: 20),
                  if (_story != null) _buildStory(theme),
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
      expandedHeight: 260,
      pinned: true,
      backgroundColor: AppColors.deepIndigo,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Image.asset(widget.imagePath, height: 260, width: double.infinity, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.deepIndigo.withValues(alpha: 0.4),
                    AppColors.deepIndigo.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20, right: 20, bottom: 20,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.saffron,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.star, size: 16, color: Colors.white),
                      const SizedBox(width: 4),
                      Text('${widget.rating}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                    ]),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(widget.category, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.name, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: AppColors.saffron),
            const SizedBox(width: 6),
            Text(widget.location, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.description,
          style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary, height: 1.6),
          maxLines: _showFullDesc ? null : 4,
          overflow: _showFullDesc ? null : TextOverflow.ellipsis,
        ),
        if (widget.description.length > 150)
          GestureDetector(
            onTap: () => setState(() => _showFullDesc = !_showFullDesc),
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _showFullDesc ? 'Show less' : 'Read more',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.saffron),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _loadingStory ? null : _enrichStory,
            icon: _loadingStory
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.auto_stories),
            label: Text(_loadingStory ? 'Discovering Mythology...' : 'Discover Mythology & Legends'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.saffron,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _openInMap(),
            icon: const Icon(Icons.map_outlined),
            label: const Text('View on Map'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              side: const BorderSide(color: AppColors.divider),
              foregroundColor: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStory(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.saffronLight, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.auto_stories, color: AppColors.saffron, size: 20),
            ),
            const SizedBox(width: 10),
            Text('Mythology & Legends', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 14),
        if (_story!['legend'] != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.indigoLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.deepIndigo.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_story!['title'] ?? 'The Legend', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.deepIndigo)),
                const SizedBox(height: 8),
                Text(_story!['legend'], style: const TextStyle(fontSize: 14, height: 1.6, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
        if (_story!['interestingFacts'] != null) ...[
          const SizedBox(height: 14),
          _factChips(List<String>.from(_story!['interestingFacts'])),
        ],
        const SizedBox(height: 14),
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
      ],
    );
  }

  Widget _factChips(List<String> facts) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: facts.map((f) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.goldLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.turmericGold.withValues(alpha: 0.3)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.lightbulb, size: 14, color: AppColors.turmericGold),
          const SizedBox(width: 6),
          Text(f, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
        ]),
      )).toList(),
    );
  }

  Future<void> _enrichStory() async {
    setState(() => _loadingStory = true);
    try {
      final story = await _service.enrichContent(
        type: 'mythology',
        name: widget.name,
        baseDescription: widget.description,
      );
      if (!mounted) return;
      setState(() {
        _story = story;
        _loadingStory = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingStory = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load story: $e')),
      );
    }
  }

  Future<void> _openInMap() async {
    final query = Uri.encodeComponent('${widget.name}, ${widget.location}, Jharkhand, India');
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open maps. Please install Google Maps.')),
      );
    }
  }
}
