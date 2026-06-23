import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/page_transition.dart';
import '../widgets/story_sheet.dart';
import '../core/services/tts_service.dart';
import 'place_detail_screen.dart';
import 'ai_planner_screen.dart';
import 'language_screen.dart';
import 'discover_screen.dart';
import 'food_screen.dart';
import 'clothes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _HeroSection(searchController: _searchController),
          SliverToBoxAdapter(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        _CulturalDiscoverySection(),
        const SizedBox(height: 32),
        _SectionHeader(title: 'Featured Destinations', actionLabel: 'Explore all', onAction: () =>
            Navigator.push(context, SlideFadeTransition(page: const DiscoverScreen()))),
        const SizedBox(height: 16),
        const _FeaturedDestinations(),
        const SizedBox(height: 32),
        _SectionHeader(title: 'Story of the Day', actionLabel: 'More stories', onAction: () =>
            Navigator.push(context, SlideFadeTransition(page: const DiscoverScreen())),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: AppColors.saffronOrange.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
              child: const Text('Mythology', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.saffronOrange, letterSpacing: 0.5)),
            )),
        const SizedBox(height: 16),
        const _StoryOfTheDay(),
        const SizedBox(height: 28),
        const _QuickExploreCategories(),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  final TextEditingController searchController;
  const _HeroSection({required this.searchController});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverToBoxAdapter(
      child: SizedBox(
        height: size.height * 0.62,
        child: Stack(
          children: [
            Image.asset('assets/images/hero_bg.png', width: size.width, height: size.height * 0.62, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [
                    AppColors.deepIndigo.withValues(alpha: 0.25),
                    AppColors.deepIndigo.withValues(alpha: 0.5),
                    AppColors.deepIndigo.withValues(alpha: 0.85),
                    AppColors.deepIndigo,
                  ],
                ),
              ),
            ),
            Positioned(top: -60, right: -60, child: Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.03)))),
            Positioned(bottom: 100, left: -80, child: Container(width: 250, height: 250, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.saffronOrange.withValues(alpha: 0.04)))),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 12, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.explore, size: 16, color: AppColors.goldAccent),
                            const SizedBox(width: 6),
                            const Text('Tourism Jharkhand', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
                          ]),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const Spacer(),
                    const Text('Explore the\nSoul of Jharkhand', style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white, height: 1.1, letterSpacing: -0.5)),
                    const SizedBox(height: 12),
                    Text('Discover Mythology, Food, Clothing, Language and\nCultural Heritage through AI-powered exploration.',
                        style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8), height: 1.5)),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => Navigator.push(context, SlideFadeTransition(page: const AIPlannerScreen())),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          boxShadow: [BoxShadow(color: AppColors.deepIndigo.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: AppColors.saffronOrange, borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                            ),
                            const Expanded(child: Text('Plan your trip to Jharkhand...', style: TextStyle(color: Colors.white60, fontSize: 14))),
                            Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(Icons.auto_awesome, color: Colors.white70, size: 18),
                                SizedBox(width: 4),
                                Text('AI', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;
  final Widget? trailing;

  const _SectionHeader({required this.title, required this.actionLabel, required this.onAction, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (trailing != null) ...[
            trailing!,
            const SizedBox(width: 10),
          ],
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.3)),
          const Spacer(),
          GestureDetector(
            onTap: onAction,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(color: AppColors.saffronOrange.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(actionLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.saffronOrange)),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 13, color: AppColors.saffronOrange),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _CulturalDiscoverySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(width: 3, height: 18, decoration: BoxDecoration(color: AppColors.saffronOrange, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 10),
              const Text('Cultural Discovery', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.3)),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(child: _FeatureCard(
                icon: Icons.auto_stories,
                label: 'Mythology',
                subtitle: 'Stories, Legends & Sacred Heritage',
                gradient: [AppColors.deepIndigo, const Color(0xFF3D2B7F)],
                iconBg: Colors.white.withValues(alpha: 0.18),
                onTap: () => Navigator.push(context, SlideFadeTransition(page: const DiscoverScreen())),
              )),
              const SizedBox(width: 14),
              Expanded(child: _FeatureCard(
                icon: Icons.restaurant,
                label: 'Food',
                subtitle: 'Traditional Cuisine & Recipes',
                gradient: [AppColors.saffronOrange, const Color(0xFFFFB300)],
                iconBg: Colors.white.withValues(alpha: 0.25),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodScreen())),
              )),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(child: _FeatureCard(
                icon: Icons.checkroom,
                label: 'Clothing',
                subtitle: 'Traditional Attire, Textiles & Handicrafts',
                gradient: [AppColors.forestGreen, const Color(0xFF43A047)],
                iconBg: Colors.white.withValues(alpha: 0.2),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClothesScreen())),
              )),
              const SizedBox(width: 14),
              Expanded(child: _FeatureCard(
                icon: Icons.translate,
                label: 'Language',
                subtitle: 'Local Languages, Expressions & Translation',
                gradient: [const Color(0xFF5C2D91), const Color(0xFF8E5CC7)],
                iconBg: Colors.white.withValues(alpha: 0.2),
                onTap: () => Navigator.push(context, SlideFadeTransition(page: const LanguageScreen())),
              )),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final List<Color> gradient;
  final Color iconBg;
  final VoidCallback onTap;

  const _FeatureCard({required this.icon, required this.label, required this.subtitle, required this.gradient, required this.iconBg, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 168,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradient),
          boxShadow: [
            BoxShadow(color: gradient.first.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8)),
          ],
        ),
        child: Stack(
          children: [
            Positioned(bottom: -20, right: -20, child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.06)))),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(14)),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const Spacer(),
                  Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.3)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8), height: 1.3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedDestinations extends StatelessWidget {
  const _FeaturedDestinations();

  final _destinations = const [
    _DestCardData('Baidyanath Dham', 'Deoghar', 'Temples', 4.8, 'One of the 12 Jyotirlingas. Sacred Shiva temple drawing millions of pilgrims annually.', 'assets/images/dest_deoghar.png'),
    _DestCardData('Parasnath Hills', 'Giridih', 'Spiritual', 4.6, 'Highest peak in Jharkhand. Sacred Jain pilgrimage site with 20 temples.', 'assets/images/dest_netarhat.png'),
    _DestCardData('Hundru Falls', 'Ranchi', 'Waterfalls', 4.7, 'One of the highest waterfalls in Jharkhand, plunging 98 meters.', 'assets/images/dest_ranchi.png'),
    _DestCardData('Rajrappa Temple', 'Ramgarh', 'Temples', 4.5, 'Ancient Chhinnamasta Temple at the confluence of Bhairavi and Damodar rivers.', 'assets/images/dest_betla.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: _destinations.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (_, i) {
          final d = _destinations[i];
          return _DestinationCard(
            imagePath: d.image,
            name: d.name,
            location: d.location,
            category: d.category,
            rating: d.rating,
            onTap: () => Navigator.push(context, SlideFadeTransition(page: PlaceDetailScreen(
              name: d.name, description: d.desc, imagePath: d.image,
              rating: d.rating, location: d.location, category: d.category,
            ))),
          );
        },
      ),
    );
  }
}

class _DestCardData {
  final String name, location, category, desc, image;
  final double rating;
  const _DestCardData(this.name, this.location, this.category, this.rating, this.desc, this.image);
}

class _DestinationCard extends StatelessWidget {
  final String imagePath, name, location, category;
  final double rating;
  final VoidCallback onTap;

  const _DestinationCard({required this.imagePath, required this.name, required this.location, required this.category, required this.rating, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Stack(
                children: [
                  Image.asset(imagePath, height: 160, width: 220, fit: BoxFit.cover),
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.4)],
                      ),
                    ),
                  ),
                  Positioned(left: 12, top: 12, child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.saffronOrange, borderRadius: BorderRadius.circular(8)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.auto_awesome, size: 10, color: Colors.white),
                      const SizedBox(width: 4),
                      const Text('AI Rec.', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                    ]),
                  )),
                  Positioned(right: 12, top: 12, child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(8)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.star, size: 11, color: AppColors.goldAccent),
                      const SizedBox(width: 3),
                      Text('$rating', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                    ]),
                  )),
                  Positioned(left: 12, bottom: 12, child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                    child: Text(category, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.location_on, size: 13, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(location, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const Spacer(),
                    Icon(Icons.directions_car, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 3),
                    Text('${(math.Random().nextInt(4) + 1) * 50} km', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryOfTheDay extends StatefulWidget {
  const _StoryOfTheDay();

  @override
  State<_StoryOfTheDay> createState() => _StoryOfTheDayState();
}

class _StoryOfTheDayState extends State<_StoryOfTheDay> {
  final _tts = TtsService();
  final _myId = Object();

  static final _storyData = <String, dynamic>{
    'title': 'The Legend of Baidyanath Dham',
    'subtitle': 'How Lord Shiva manifested as a Jyotirlinga in Deoghar',
    'summary':
        'Baidyanath Dham, also known as Vaidyanath Jyotirlinga, is one of the twelve sacred Jyotirlingas in India, '
        'located in Deoghar, Jharkhand. The temple holds immense religious significance and is believed to be where '
        'Lord Shiva manifested as a cosmic pillar of light.',
    'legend':
        'According to Hindu mythology, the demon king Ravana prayed to Lord Shiva at Mount Kailash. '
        'When Shiva appeared, Ravana requested that the Lord accompany him to Sri Lanka. '
        'Shiva agreed but warned that if the lingam was placed on the ground before reaching Lanka, '
        'it would remain there forever. On the way, Ravana needed to relieve himself and asked a '
        'cowherd named Baiju to hold the lingam. Unable to bear its weight, Baiju placed it down, '
        'and the lingam became firmly rooted at Deoghar.',
    'keyCharacters': [
      'Lord Shiva – The supreme deity who manifested as the Jyotirlinga',
      'Ravana – The demon king who brought the lingam from Kailash',
      'Baiju – The cowherd who held and placed the lingam',
    ],
    'relatedPlaces': ['Deoghar, Jharkhand', 'Mount Kailash', 'Sri Lanka'],
    'interestingFacts': [
      'Baidyanath Dham is one of the 12 Jyotirlingas and also one of the 51 Shakti Peethas',
      'The temple is also known as "Kamana Linga" where devotees pray for their wishes',
      'Millions of pilgrims visit during Shravan month, carrying holy water from the Ganges',
    ],
    'moralOrTeaching':
        'The story teaches that divine blessings follow sincere devotion, but also that '
        'those who serve the divine selflessly (like Baiju) are blessed.',
  };

  @override
  void initState() {
    super.initState();
    _tts.addListener(() {
      if (mounted) setState(() {});
    });
  }

  bool get _playing => _tts.isSpeaking && _tts.activeSpeakerId == _myId;

  @override
  void dispose() {
    _tts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 440,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 10))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Image.asset('assets/images/dest_deoghar.png', width: double.infinity, height: double.infinity, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.deepIndigo.withValues(alpha: 0.7)],
                      ),
                    ),
                  ),
                  Positioned(left: 20, right: 20, bottom: 20, child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.saffronOrange, borderRadius: BorderRadius.circular(8)),
                        child: const Text('Mythology', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5)),
                      ),
                      const SizedBox(height: 12),
                      const Text('The Legend of Baidyanath Dham', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.3)),
                      const SizedBox(height: 6),
                      Text('How Lord Shiva manifested as a Jyotirlinga in the sacred land of Deoghar, blessing devotees for eternity.',
                          style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8), height: 1.4)),
                    ],
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => showStorySheet(context, _storyData),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.deepIndigo,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.auto_stories, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text('Read Story', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (_playing) {
                          _tts.stop();
                        } else {
                          _tts.speak(
                            'The Legend of Baidyanath Dham. According to Hindu mythology, '
                            'the demon king Ravana prayed to Lord Shiva at Mount Kailash. '
                            'When Shiva appeared, Ravana requested that the Lord accompany him to Sri Lanka. '
                            'Shiva agreed but warned that if the lingam was placed on the ground before reaching Lanka, '
                            'it would remain there forever. On the way, Ravana needed to relieve himself and asked a '
                            'cowherd named Baiju to hold the lingam. Unable to bear its weight, Baiju placed it down, '
                            'and the lingam became firmly rooted at Deoghar, now known as Baidyanath Dham.',
                            speakerId: _myId,
                          );
                        }
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: _playing ? AppColors.deepIndigo : AppColors.saffronOrange,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(_playing ? Icons.stop : Icons.headphones, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(_playing ? 'Stop' : 'Listen Audio', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickExploreCategories extends StatelessWidget {
  const _QuickExploreCategories();

  final _categories = const [
    ('Temples', Icons.temple_hindu, AppColors.saffronOrange),
    ('Waterfalls', Icons.waterfall_chart, AppColors.mutedJade),
    ('Tribal Culture', Icons.people, AppColors.deepIndigo),
    ('Festivals', Icons.celebration, AppColors.saffronOrange),
    ('Food', Icons.restaurant, AppColors.forestGreen),
    ('Handicrafts', Icons.handyman, AppColors.turmericGold),
    ('Wildlife', Icons.pets, AppColors.forestGreen),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(width: 3, height: 18, decoration: BoxDecoration(color: AppColors.saffronOrange, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 10),
              const Text('Explore by Category', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.3)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final c = _categories[i];
              return _CategoryChip(icon: c.$2, label: c.$1, color: c.$3, onTap: () {
                Navigator.push(context, SlideFadeTransition(page: const DiscoverScreen()));
              });
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CategoryChip({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
        ]),
      ),
    );
  }
}
