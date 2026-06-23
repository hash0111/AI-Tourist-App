import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/page_transition.dart';
import 'place_detail_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  int _selectedFilter = 0;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final _filters = ['All', 'Nature', 'Temples', 'Wildlife', 'Heritage', 'Adventure'];

  final _allDestinations = [
    _PlaceData('Hundru Falls', 'Ranchi', 4.8, 'One of the highest waterfalls in Jharkhand, plunging 98 meters. A stunning cascade surrounded by lush forests.', 'assets/images/waterfall.png', 'Nature'),
    _PlaceData('Baba Baidyanath Temple', 'Deoghar', 4.9, 'One of the 12 sacred Jyotirlingas of Lord Shiva. Millions of pilgrims visit this ancient temple annually.', 'assets/images/temple_baba.png', 'Temples'),
    _PlaceData('Betla National Park', 'Palamau', 4.6, 'A rich wildlife reserve housing tigers, elephants, deer, and over 200 bird species. Historic Palamau Fort within.', 'assets/images/dest_betla.png', 'Wildlife'),
    _PlaceData('Jonha Falls', 'Ranchi', 4.5, 'Also known as Gautamdhara, this 43-meter horse-shoe shaped waterfall is surrounded by dense greenery.', 'assets/images/waterfall.png', 'Nature'),
    _PlaceData('Chhinnamasta Temple', 'Rajrappa', 4.7, 'The only temple in India dedicated to Goddess Chhinnamasta, set at the confluence of Damodar and Bhairavi rivers.', 'assets/images/temple_chhinnamasta.png', 'Temples'),
    _PlaceData('Netarhat', 'Latehar', 4.5, 'The "Queen of Chotanagpur" — a serene hill station with breathtaking sunrises, sunsets, and pine forests.', 'assets/images/dest_netarhat.png', 'Adventure'),
    _PlaceData('Dalma Hills', 'Jamshedpur', 4.4, 'A wildlife sanctuary and hill range with elephants, deer, and scenic trekking trails overlooking Jamshedpur.', 'assets/images/wildlife.png', 'Wildlife'),
    _PlaceData('Itkhori Temple', 'Chatra', 4.3, 'Ancient Buddhist-Hindu site with rare 6th-century idols. Believed to be where Sita stayed during her exile.', 'assets/images/temple_itkhori.png', 'Heritage'),
    _PlaceData('Samvet Sikhar', 'Parasnath', 4.8, 'Highest peak in Jharkhand. Sacred Jain site where 20 of 24 Tirthankaras attained nirvana.', 'assets/images/samvet_sikhar.png', 'Heritage'),
    _PlaceData('Dassam Falls', 'Ranchi', 4.6, 'A 44-meter waterfall where the Kanchi River plunges over a horseshoe-shaped cliff into a deep gorge.', 'assets/images/waterfall.png', 'Nature'),
    _PlaceData('Palamau Fort', 'Betla', 4.3, 'A historic 16th-century fort within Betla National Park with Chero dynasty architecture and scenic views.', 'assets/images/dest_betla.png', 'Heritage'),
    _PlaceData('Seraikela', 'Seraikela', 4.4, 'Famous for the UNESCO-recognized Chhau dance, royal palaces, and rich cultural heritage.', 'assets/images/festival.png', 'Heritage'),
    _PlaceData('Rajrappa Falls', 'Ramgarh', 4.5, 'A scenic waterfall on the Damodar River, home to the Chhinnamasta Temple at its base.', 'assets/images/waterfall.png', 'Nature'),
    _PlaceData('Hazaribagh Lake', 'Hazaribagh', 4.2, 'A serene lake surrounded by forests in Hazaribagh National Park, ideal for boating and birdwatching.', 'assets/images/dest_hazaribagh.png', 'Nature'),
    _PlaceData('Rock Garden', 'Ranchi', 4.3, 'A unique garden built from industrial waste and rocks, featuring sculptures, waterfalls, and a peaceful atmosphere.', 'assets/images/dest_ranchi.png', 'Adventure'),
  ];

  final _gems = [
    _PlaceData('Itkhori', 'Chatra', 4.3, 'Ancient Buddhist & Hindu temple complex with rare 6th-century idols and carvings.', 'assets/images/hidden_gems.png', 'Heritage'),
    _PlaceData('Samvet Sikhar', 'Parasnath', 4.8, 'Highest peak in Jharkhand. 20 Jain Tirthankaras attained salvation here.', 'assets/images/hidden_gems.png', 'Heritage'),
    _PlaceData('Seraikela', 'Seraikela', 4.4, 'Home to the UNESCO-recognized Chhau dance tradition and royal palaces.', 'assets/images/hidden_gems.png', 'Heritage'),
  ];

  final _itineraries = [
    ('2 Days', 'Ranchi Waterfalls Tour', 'Hundru → Jonha → Dassam → Rock Garden', '₹4,500', AppColors.mutedJade),
    ('3 Days', 'Spiritual Deoghar', 'Baidyanath → Nandan Pahar → Satsang', '₹6,000', AppColors.saffron),
    ('4 Days', 'Betla Safari Adventure', 'Wildlife safari → Palamau Fort → Netarhat', '₹8,500', AppColors.deepIndigo),
  ];

  List<_PlaceData> get _filteredDestinations {
    var list = _allDestinations.where((d) {
      if (_selectedFilter == 0) return true;
      return d.category == _filters[_selectedFilter];
    }).toList();

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((d) =>
        d.name.toLowerCase().contains(q) ||
        d.location.toLowerCase().contains(q) ||
        d.description.toLowerCase().contains(q)
      ).toList();
    }

    return list;
  }

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
          _buildSearchHeader(),
          if (_searchQuery.isNotEmpty || _selectedFilter != 0)
            ..._buildFilteredSlivers()
          else
            ..._buildFullSlivers(),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  SliverAppBar _buildSearchHeader() {
    return SliverAppBar(
      expandedHeight: 130,
      collapsedHeight: 90,
      pinned: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 50, 20, 0),
            child: Column(
              children: [
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _searchQuery.isNotEmpty ? AppColors.saffron : AppColors.divider),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search places, experiences...',
                      hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18, color: AppColors.textSecondary),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFilteredSlivers() {
    final results = _filteredDestinations;
    return [
      SliverToBoxAdapter(child: _buildFilterChips()),
      if (_selectedFilter != 0 && _searchQuery.isEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Text('${_filters[_selectedFilter]} places in Jharkhand',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ),
        ),
      if (results.isEmpty)
        SliverFillRemaining(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text('No results found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                const Text('Try a different search or filter', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              ],
            ),
          ),
        )
      else
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final d = results[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: _SearchResultCard(data: d, onTap: () => _openPlaceDetail(d)),
              );
            },
            childCount: results.length,
          ),
        ),
    ];
  }

  List<Widget> _buildFullSlivers() {
    final interests = [
      ('Waterfalls', Icons.waterfall_chart, AppColors.mutedJade, _allDestinations.where((d) => d.category == 'Nature').length),
      ('Wildlife', Icons.pets, AppColors.deepIndigo, _allDestinations.where((d) => d.category == 'Wildlife').length),
      ('Temples', Icons.temple_hindu, AppColors.saffron, _allDestinations.where((d) => d.category == 'Temples').length),
      ('Heritage', Icons.account_balance, AppColors.turmericGold, _allDestinations.where((d) => d.category == 'Heritage').length),
    ];

    return [
      SliverToBoxAdapter(child: _buildFilterChips()),
      const SliverPadding(padding: EdgeInsets.only(top: 20)),

      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Explore by Interest'),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _InterestTile(icon: interests[0].$2, label: interests[0].$1, color: interests[0].$3, count: '${interests[0].$4}', onTap: () => _selectCategory(interests[0].$1))),
                  const SizedBox(width: 10),
                  Expanded(child: _InterestTile(icon: interests[1].$2, label: interests[1].$1, color: interests[1].$3, count: '${interests[1].$4}', onTap: () => _selectCategory(interests[1].$1))),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _InterestTile(icon: interests[2].$2, label: interests[2].$1, color: interests[2].$3, count: '${interests[2].$4}', onTap: () => _selectCategory(interests[2].$1))),
                  const SizedBox(width: 10),
                  Expanded(child: _InterestTile(icon: interests[3].$2, label: interests[3].$1, color: interests[3].$3, count: '${interests[3].$4}', onTap: () => _selectCategory(interests[3].$1))),
                ],
              ),
            ],
          ),
        ),
      ),
      const SliverPadding(padding: EdgeInsets.only(top: 20)),

      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Trending Destinations', action: 'View all'),
              const SizedBox(height: 14),
              SizedBox(
                height: 215,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _allDestinations.take(5).length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (_, i) {
                    final d = _allDestinations[i];
                    return DestinationCard(
                      imagePath: d.imagePath, name: d.name, location: d.location, rating: d.rating,
                      subtitle: d.description.length > 40 ? '${d.description.substring(0, 40)}...' : d.description,
                      onTap: () => _openPlaceDetail(d),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      const SliverPadding(padding: EdgeInsets.only(top: 20)),

      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Hidden Gems', action: 'Explore'),
              const SizedBox(height: 14),
              ..._gems.map((g) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _openPlaceDetail(g),
                  child: Row(
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(g.imagePath, width: 56, height: 56, fit: BoxFit.cover)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(g.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
                            const SizedBox(height: 2),
                            Text(g.description, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 2),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
      const SliverPadding(padding: EdgeInsets.only(top: 20)),

      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Nearby Attractions'),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: _openMap,
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset('assets/images/map_placeholder.png', height: 160, width: double.infinity, fit: BoxFit.cover),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter, end: Alignment.topCenter,
                            colors: [AppColors.deepIndigo.withValues(alpha: 0.7), Colors.transparent],
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 16, bottom: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Explore Nearby', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                            SizedBox(height: 4),
                            Text('Discover attractions around Jharkhand', style: TextStyle(fontSize: 12, color: Colors.white70)),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 16, bottom: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(color: AppColors.saffron, borderRadius: BorderRadius.circular(12)),
                          child: const Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.map, size: 16, color: Colors.white),
                            SizedBox(width: 6),
                            Text('Open Maps', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 13)),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SliverPadding(padding: EdgeInsets.only(top: 20)),

      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Recommended Itineraries', action: 'View all'),
              const SizedBox(height: 14),
              ..._itineraries.map((i) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(context, SlideFadeTransition(page: PlaceDetailScreen(
                      name: i.$2, description: i.$3, imagePath: 'assets/images/dest_ranchi.png',
                      rating: 4.5, location: 'Jharkhand', category: 'Itinerary',
                    )));
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: i.$5.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                        child: Text(i.$1, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: i.$5)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(i.$2, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
                            const SizedBox(height: 2),
                            Text(i.$3, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      Text(i.$4, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.mutedJade)),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) => CategoryChip(
          icon: Icons.explore,
          label: _filters[i],
          color: AppColors.saffron,
          isSelected: _selectedFilter == i,
          onTap: () => setState(() => _selectedFilter = i),
        ),
      ),
    );
  }

  void _selectCategory(String category) {
    final index = _filters.indexWhere((f) => f.toLowerCase() == category.toLowerCase());
    if (index >= 0) {
      setState(() => _selectedFilter = index);
    }
  }

  void _openPlaceDetail(_PlaceData d) {
    Navigator.push(context, SlideFadeTransition(page: PlaceDetailScreen(
      name: d.name, description: d.description, imagePath: d.imagePath,
      rating: d.rating, location: d.location, category: d.category,
    )));
  }

  Future<void> _openMap() async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=Jharkhand+India+tourist+places');
    final canLaunch = await canLaunchUrl(uri);
    if (canLaunch) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open maps. Please install Google Maps.')),
      );
    }
  }
}

class _PlaceData {
  final String name, location, description, imagePath, category;
  final double rating;
  const _PlaceData(this.name, this.location, this.rating, this.description, this.imagePath, this.category);
}

class _InterestTile extends StatelessWidget {
  final IconData icon;
  final String label, count;
  final Color color;
  final VoidCallback onTap;

  const _InterestTile({required this.icon, required this.label, required this.color, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis),
                  Text('$count places', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final _PlaceData data;
  final VoidCallback onTap;

  const _SearchResultCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(data.imagePath, width: 64, height: 64, fit: BoxFit.cover)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Row(children: [
                      const Icon(Icons.location_on, size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Flexible(child: Text(data.location, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, size: 13, color: AppColors.turmericGold),
                      const SizedBox(width: 2),
                      Text('${data.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.turmericGold)),
                    ]),
                    const SizedBox(height: 2),
                    Text(data.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
