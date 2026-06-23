import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/page_transition.dart';
import '../core/services/tts_service.dart';
import 'place_detail_screen.dart';

class MythologyScreen extends StatefulWidget {
  const MythologyScreen({super.key});

  @override
  State<MythologyScreen> createState() => _MythologyScreenState();
}

class _MythologyScreenState extends State<MythologyScreen> {
  final _legendKey = GlobalKey();
  final _audioKey = GlobalKey();
  final _tts = TtsService();
  String _selectedFilter = 'All';

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
    }
  }

  @override
  void initState() {
    super.initState();
    _tts.onError = (msg) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    };
  }

  @override
  void dispose() {
    _tts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _MythHeroBanner(
            onExploreStories: () => _scrollTo(_legendKey),
            onAudio: () => _scrollTo(_audioKey),
          ),
          SliverToBoxAdapter(child: _buildFilterChips()),
          if (_selectedFilter == 'All' || _selectedFilter == 'Sacred' || _selectedFilter == 'Temples')
            SliverToBoxAdapter(child: _buildSacredPlaces()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: _SectionHeader(title: 'Legendary Stories', action: 'View all', onAction: () => _scrollTo(_legendKey)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: _LegendStories(key: _legendKey, tts: _tts, filter: _selectedFilter),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: _SectionHeader(title: 'Audio Stories', action: 'Listen now', onAction: () => _scrollTo(_audioKey)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
              child: _AudioStories(key: _audioKey, tts: _tts, filter: _selectedFilter),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _mythFilters.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, i) => _FilterChip(
            label: _mythFilters[i],
            icon: _mythIcons[i],
            isSelected: _selectedFilter == _mythFilters[i],
            onTap: () => setState(() => _selectedFilter = _mythFilters[i]),
          ),
        ),
      ),
    );
  }

  Widget _buildSacredPlaces() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Sacred Places'),
          const SizedBox(height: 14),
          _SacredPlaces(onTap: (name, desc, image) {
            Navigator.push(context, SlideFadeTransition(page: PlaceDetailScreen(
              name: name, description: desc, imagePath: image,
              rating: 4.7, location: 'Jharkhand', category: 'Temple',
            )));
          }),
        ],
      ),
    );
  }
}

const _mythFilters = ['All', 'Temples', 'Folklore', 'Tribal', 'Sacred'];
const _mythIcons = [Icons.explore, Icons.temple_hindu, Icons.auto_stories, Icons.people, Icons.spa];

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final selected = isSelected;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.saffron : AppColors.deepIndigo.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.saffron : AppColors.deepIndigo.withValues(alpha: 0.12)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: selected ? Colors.white : AppColors.deepIndigo),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.deepIndigo)),
        ]),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const _SectionHeader({required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Container(width: 3, height: 18, decoration: BoxDecoration(color: AppColors.saffron, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ]),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Row(children: [
              Text(action!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.saffron)),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.saffron),
            ]),
          ),
      ],
    );
  }
}

class _MythHeroBanner extends StatelessWidget {
  final VoidCallback onExploreStories;
  final VoidCallback onAudio;

  const _MythHeroBanner({required this.onExploreStories, required this.onAudio});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: false,
      floating: false,
      backgroundColor: AppColors.deepIndigo,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Image.asset('assets/images/mythology_hero.png', height: 280, width: double.infinity, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [
                    AppColors.deepIndigo.withValues(alpha: 0.2),
                    AppColors.deepIndigo.withValues(alpha: 0.85),
                    AppColors.deepIndigo,
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20, right: 20, bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Mythology & Legends', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 6),
                  Text('Discover ancient stories, folklore and spiritual heritage of Jharkhand',
                      style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.85))),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onExploreStories,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(color: AppColors.saffron, borderRadius: BorderRadius.circular(12)),
                          child: const Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.auto_stories, size: 16, color: Colors.white),
                            SizedBox(width: 6),
                            Text('Explore Stories', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 13)),
                          ]),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: onAudio,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                          child: const Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.volume_up, size: 16, color: Colors.white),
                            SizedBox(width: 6),
                            Text('Audio', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 13)),
                          ]),
                        ),
                      ),
                    ],
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

class _SacredPlaces extends StatelessWidget {
  final void Function(String name, String desc, String image) onTap;

  const _SacredPlaces({required this.onTap});

  final _places = const [
    _PlaceData('assets/images/temple_baba.png', 'Baba Baidyanath Temple',
        'One of the 12 sacred Jyotirlingas. Legend says Ravana worshipped Shiva here on his way to Kashi.'),
    _PlaceData('assets/images/temple_chhinnamasta.png', 'Chhinnamasta Temple',
        'The only temple dedicated to Goddess Chhinnamasta in India, at Rajrappa waterfall.'),
    _PlaceData('assets/images/temple_itkhori.png', 'Itkhori Temple',
        'Ancient Buddhist-Hindu site with 6th-century idols. Believed to be where Sita stayed during exile.'),
    _PlaceData('assets/images/samvet_sikhar.png', 'Samvet Sikhar (Parasnath)',
        'Highest peak in Jharkhand. 20 of 24 Jain Tirthankaras attained salvation here.'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: _places.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final p = _places[i];
          return GestureDetector(
            onTap: () => onTap(p.name, p.desc, p.image),
            child: Container(
              width: 240,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(p.image, height: 130, width: 240, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
                        const SizedBox(height: 6),
                        Text(p.desc, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PlaceData {
  final String image, name, desc;
  const _PlaceData(this.image, this.name, this.desc);
}

class _LegendStories extends StatelessWidget {
  final TtsService tts;
  final String filter;
  const _LegendStories({super.key, required this.tts, required this.filter});

  final _stories = const [
    _StoryData('assets/images/waterfall.png', 'The Legend of Hundru Falls',
        'Local legend says Hundru Falls was named after a beautiful princess who jumped off the cliff to avoid a forced marriage. The cascading waters are said to carry her spirit, and on full moon nights, her silhouette can be seen behind the waterfall.',
        'Folklore'),
    _StoryData('assets/images/temple_baba.png', 'Shiva\'s Journey to Deoghar',
        'Ravana received a Shiva Linga from Lord Shiva with a condition - it must not touch the ground before reaching Lanka. When Ravana stopped to rest near Deoghar, Lord Vishnu disguised as a cowherd made him set it down, and the linga became permanently rooted.',
        'Temples'),
    _StoryData('assets/images/wildlife.png', 'The Tribal Creation Myth',
        'The Sariya tribes believe the first humans were created by the Sun God Singbonga from the clay of the Chotanagpur plateau. He breathed life into two clay figures who became the ancestors of all Jharkhand\'s indigenous communities.',
        'Tribal'),
    _StoryData('assets/images/temple_chhinnamasta.png', 'Goddess Chhinnamasta at Rajrappa',
        'The legend tells of Goddess Chhinnamasta, who beheaded herself to satisfy the hunger of her two attendants. The river Damodar turned red with her blood, and the site where her head fell became the Rajrappa temple, a powerful Shakti Peetha.',
        'Temples'),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = filter == 'All' ? _stories : _stories.where((s) => s.tag == filter).toList();
    return Column(
      children: filtered.map((s) => _ExpandableMythCard(data: s, tts: tts)).toList(),
    );
  }
}

class _StoryData {
  final String imagePath, title, content, tag;
  const _StoryData(this.imagePath, this.title, this.content, this.tag);
}

class _ExpandableMythCard extends StatefulWidget {
  final _StoryData data;
  final TtsService tts;
  const _ExpandableMythCard({required this.data, required this.tts});

  @override
  State<_ExpandableMythCard> createState() => _ExpandableMythCardState();
}

class _ExpandableMythCardState extends State<_ExpandableMythCard> with SingleTickerProviderStateMixin {
  final _tagColors = <String, Color>{
    'Temples': const Color(0xFFFF6B00),
    'Folklore': const Color(0xFF2E7D32),
    'Tribal': const Color(0xFF1A1035),
  };
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  final _myId = Object();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 350), vsync: this);
    _heightFactor = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
    widget.tts.addListener(_onTtsChanged);
  }

  @override
  void dispose() {
    widget.tts.removeListener(_onTtsChanged);
    _controller.dispose();
    super.dispose();
  }

  bool _snackbarShown = false;

  void _onTtsChanged() {
    if (!mounted) return;
    setState(() {});
    if (widget.tts.isSpeaking && widget.tts.activeSpeakerId == _myId) {
      if (!_snackbarShown) {
        _snackbarShown = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.play_circle, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text('Speaking: ${widget.data.title}', overflow: TextOverflow.ellipsis)),
            ]),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 80),
            action: SnackBarAction(
              label: 'Stop',
              textColor: Colors.white,
              onPressed: () => widget.tts.stop(),
            ),
          ),
        );
      }
    } else {
      _snackbarShown = false;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  bool get _speaking => widget.tts.isSpeaking && widget.tts.activeSpeakerId == _myId;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() => _expanded = !_expanded);
              _expanded ? _controller.forward() : _controller.reverse();
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(d.imagePath, width: 52, height: 52, fit: BoxFit.cover)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: (_tagColors[d.tag] ?? AppColors.saffron).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(d.tag, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _tagColors[d.tag] ?? AppColors.saffron)),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.expand_more, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _heightFactor,
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(d.content, style: const TextStyle(fontSize: 14, height: 1.6, color: AppColors.textSecondary)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _ActionChip(
                        icon: _speaking ? Icons.stop : Icons.volume_up,
                        label: _speaking ? 'Stop' : 'Listen',
                        color: AppColors.saffron,
                        bgColor: AppColors.saffronLight,
                        onTap: () {
                          if (_speaking) {
                            widget.tts.stop();
                          } else {
                            widget.tts.speak(d.content, speakerId: _myId);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color, bgColor;
  final VoidCallback onTap;

  const _ActionChip({required this.icon, required this.label, required this.color, required this.bgColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ]),
      ),
    );
  }
}

const _audioScripts = {
  'The Creation of Chotanagpur':
      'According to tribal folklore, the Chotanagpur plateau was created by the Sun God Singbonga. He descended from the heavens and shaped the hills and valleys with his hands. The forests were his gift, and the rivers were his tears of joy. The first humans were molded from the sacred red clay of this very land.',
  "Sita's Exile in Itkhori":
      'Legend says that Goddess Sita, during her exile with Lord Ram, found refuge in the dense forests of Itkhori. She bathed in the sacred pond and prayed at the ancient temple. The footprints carved in stone are believed to be hers, and the locals still offer flowers there every morning.',
  'Legend of the Lost Kingdom':
      'The Nagvanshi dynasty ruled Jharkhand for over a thousand years. Their capital at Chutiya was once a magnificent city with golden temples and bustling markets. It is said that the kingdom sank into the earth overnight when the king betrayed a sacred promise, and on quiet nights, you can still hear the bells of the lost temples.',
  'The Spirit of the Waterfalls':
      'Every waterfall in Jharkhand is believed to be home to a spirit. The most famous is the spirit of Hundru, a princess who became one with the falls. Local tribes say that if you listen carefully to the roar of Dassam Falls, you can hear the drums of the forest gods celebrating the monsoon.',
};

class _AudioStories extends StatelessWidget {
  final TtsService tts;
  final String filter;
  const _AudioStories({super.key, required this.tts, required this.filter});

  final _audios = const [
    _AudioData('The Creation of Chotanagpur', '15 min', 'Tribal folklore', 'Tribal'),
    _AudioData("Sita's Exile in Itkhori", '12 min', 'Ramayana connection', 'Temples'),
    _AudioData('Legend of the Lost Kingdom', '18 min', 'Nagvanshi dynasty', 'Folklore'),
    _AudioData('The Spirit of the Waterfalls', '10 min', 'Local legends', 'Folklore'),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = filter == 'All' ? _audios : _audios.where((a) => a.tag == filter).toList();
    return Column(
      children: filtered.map((a) => _AudioCard(data: a, tts: tts)).toList(),
    );
  }
}

class _AudioData {
  final String title, duration, category, tag;
  const _AudioData(this.title, this.duration, this.category, this.tag);
}

class _AudioCard extends StatefulWidget {
  final _AudioData data;
  final TtsService tts;
  const _AudioCard({required this.data, required this.tts});

  @override
  State<_AudioCard> createState() => _AudioCardState();
}

class _AudioCardState extends State<_AudioCard> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final _myId = Object();
  bool _snackbarShown = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    widget.tts.addListener(_onTtsStateChanged);
  }

  @override
  void dispose() {
    widget.tts.removeListener(_onTtsStateChanged);
    _pulseController.dispose();
    super.dispose();
  }

  bool get _playing => widget.tts.isSpeaking && widget.tts.activeSpeakerId == _myId;

  void _onTtsStateChanged() {
    if (!mounted) return;
    setState(() {});
    if (widget.tts.isSpeaking && widget.tts.activeSpeakerId == _myId) {
      _pulseController.repeat();
      if (!_snackbarShown) {
        _snackbarShown = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.play_circle, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text('Playing: ${widget.data.title}', overflow: TextOverflow.ellipsis)),
            ]),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            action: SnackBarAction(
              label: 'Stop',
              textColor: Colors.white,
              onPressed: () => widget.tts.stop(),
            ),
          ),
        );
      }
    } else {
      _snackbarShown = false;
      _pulseController.stop();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.data;
    final script = _audioScripts[a.title] ?? a.title;
    final audioPlaying = _playing;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: audioPlaying ? AppColors.indigoLight : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: audioPlaying ? AppColors.deepIndigo.withValues(alpha: 0.3) : AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: audioPlaying ? AppColors.saffron : AppColors.indigoLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: audioPlaying
                ? AnimatedBuilder(
                    animation: _pulseController,
                    builder: (_, child) => const Icon(Icons.equalizer, color: Colors.white, size: 22),
                  )
                : const Icon(Icons.headphones, color: AppColors.deepIndigo, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text('${a.duration} * ${a.category}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (audioPlaying) {
                widget.tts.stop();
              } else {
                widget.tts.speak(script, speakerId: _myId);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: audioPlaying ? AppColors.deepIndigo : AppColors.saffron,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(audioPlaying ? Icons.stop : Icons.play_arrow, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
