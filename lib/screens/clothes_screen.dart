import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ClothesScreen extends StatelessWidget {
  const ClothesScreen({super.key});

  static const _items = [
    _Clothing(
      name: 'Panchi Parhan',
      subtitle: 'Traditional tribal saree',
      description: 'Panchi Parhan is the traditional attire of tribal women in Jharkhand. '
          'It consists of two pieces — a sarong-like lower wrap (parhan) and an upper cloth (panchi). '
          'Unlike the mainstream saree, it is worn without a blouse and is often woven with distinct '
          'tribal motifs that represent nature, fertility, and community identity. The fabric is '
          'typically hand-spun cotton, ideal for the humid climate of the region.',
      image: 'assets/images/clothes.jpg',
      origin:
          'The Panchi Parhan has been worn by tribal communities like the Santhal, Munda, and '
          'Oraon for centuries. Its origins trace back to ancient times when tribal women wove their '
          'own clothing using locally grown cotton. Each tribe has its distinct weaving style, '
          'with patterns and colours passed down through generations of women.',
      materials: ['Hand-spun cotton', 'Natural dyes (indigo, madder, turmeric)', 'Tussar silk (for festive variants)'],
      craftsmanship:
          'Panchi Parhan is woven on traditional handlooms. The weaving process is entirely manual — '
          'cotton is first cleaned, spun into yarn, dyed with natural colours, and then woven. '
          'Tribal motifs like the "Sohrai" (harvest) patterns are etched into the weave using '
          'supplementary warp techniques. A single piece can take 3-7 days to complete.',
      occasions: ['Daily wear in rural areas', 'Tribal festivals (Sohrai, Karma)', 'Weddings and ceremonies', 'Harvest celebrations'],
      significance:
          'The Panchi Parhan is more than clothing — it is a symbol of tribal identity and self-reliance. '
          'Each motif tells a story of the community\'s connection to nature, its myths, and its way of life. '
          'The art of weaving is traditionally passed from mother to daughter.',
    ),
    _Clothing(
      name: 'Tussar Silk',
      subtitle: 'The golden fabric of Jharkhand',
      description: 'Tussar silk, also known as "Kosa silk", is a prized textile produced in the forest '
          'regions of Jharkhand, particularly around Dumka and Godda. Its distinctive golden-brown hue '
          'comes from the natural cocoon of the Antheraea mylitta moth. Tussar silk is known for its '
          'rich texture, durability, and the unique natural sheen that sets it apart from mulberry silk.',
      image: 'assets/images/clothes.jpg',
      origin:
          'Tussar silk cultivation (sericulture) has been practised in Jharkhand\'s forest belts '
          'for over 2,000 years. The tribal communities traditionally reared silkworms in the wild '
          'on trees like Arjun, Asan, and Sal. The fabric was once traded along ancient routes and '
          'was prized in royal courts across India. Today, Jharkhand is one of India\'s largest '
          'producers of Tussar silk.',
      materials: ['Tussar silk yarn', 'Natural dyes (lac, indigo, turmeric)', 'Zari (silver/gold thread for festive wear)'],
      craftsmanship:
          'Tussar silk production involves rearing silkworms in forested areas, collecting cocoons, '
          'and spinning the silk fibres. The weaving is done on pit looms using a technique that '
          'preserves the natural irregularities of the yarn — giving Tussar its characteristic '
          'texture. The fabric is often hand-painted or block-printed with tribal motifs.',
      occasions: ['Festivals and weddings', 'Formal ceremonies', 'Cultural events', 'Traditional dance performances'],
      significance:
          'Tussar silk represents the rich textile heritage of Jharkhand. It is a significant source '
          'of livelihood for thousands of tribal families, especially women. The sustainable, '
          'forest-based sericulture model is a unique example of harmony between nature and livelihood.',
    ),
    _Clothing(
      name: 'Dhoti & Kurta',
      subtitle: 'Men\'s traditional attire',
      description: 'The Dhoti and Kurta is the traditional attire for men in Jharkhand, worn across '
          'both tribal and non-tribal communities. The dhoti is a rectangular piece of cloth wrapped '
          'around the waist and tied at the waistline, while the kurta is a loose-fitting tunic. '
          'In rural areas, men often pair the dhoti with a simple cotton kurta or vest.',
      image: 'assets/images/clothes.jpg',
      origin:
          'Dhoti-wearing has been documented in the Indian subcontinent since ancient times, depicted '
          'in sculptures and texts thousands of years old. In Jharkhand, the style was adapted to '
          'the specific needs of farming and forest life — shorter wraps for easier movement, '
          'and cotton fabric for the warm climate.',
      materials: ['Cotton (khadi)', 'Handloom fabric', 'Silk-blend for festive wear'],
      craftsmanship:
          'Traditional dhotis are woven on handlooms, typically 4-5 metres long. The fabric has '
          'a distinct border weave. Khadi dhotis are especially valued for their breathability '
          'and durability. The kurta is often hand-stitched with simple embroidery on the collar or cuffs.',
      occasions: ['Daily wear in villages', 'Temple visits', 'Festivals (Sohrai, Karma)', 'Weddings and social gatherings'],
      significance:
          'The Dhoti and Kurta symbolise simplicity and cultural rootedness. It is the preferred '
          'attire for religious ceremonies and traditional events. Mahatma Gandhi\'s promotion of '
          'khadi also popularised hand-spun cotton dhotis across the region.',
    ),
    _Clothing(
      name: 'Pagon (Turban)',
      subtitle: 'Traditional headwear',
      description: 'The Pagon is a traditional turban worn by men in Jharkhand, particularly during '
          'ceremonies, weddings, and festivals. Made from fine cotton or silk fabric, it is carefully '
          'wrapped layer by layer to form a distinctive structured shape. The colour and style vary '
          'by community and occasion — saffron for ceremonies, white for mourning, and red for weddings.',
      image: 'assets/images/clothes.jpg',
      origin:
          'Turban-wearing in Jharkhand has roots in the warrior traditions of the region. Historically, '
          'turbans were worn by tribal chiefs and kings (rajas) as symbols of authority. Over time, '
          'the practice spread across communities. The distinct folding style of the Jharkhandi pagon '
          'differs from turbans in neighbouring states.',
      materials: ['Fine cotton (summer)', 'Silk or brocade (festive)', 'Muslin (ceremonial)'],
      craftsmanship:
          'Tying a pagon is a skilled art passed down through generations. The fabric (typically 5-9 '
          'metres long) is folded, pleated, and wrapped in precise layers. A well-tied pagon can '
          'take 30-45 minutes. Families often have their signature tying style, with distinct '
          'pleats and folds.',
      occasions: ['Weddings (groom and guests)', 'Religious ceremonies', 'Harvest festivals', 'Panchayat (village council) gatherings'],
      significance:
          'The Pagon represents honour, dignity, and community identity. In tribal panchayats, '
          'the chief\'s pagon symbolises his authority. Gifting a pagon is considered a mark of '
          'respect. The art of tying is a cherished cultural practice.',
    ),
    _Clothing(
      name: 'Tribal Jewellery',
      subtitle: 'Handcrafted adornments',
      description: 'Jharkhand\'s tribal jewellery is a stunning display of traditional metalwork and beadwork. '
          'Women adorn themselves with heavy silver necklaces (hansi), brass anklets (payal), iron '
          'bangles (kada), and bead necklaces (chandrahar). Each piece is handcrafted by tribal '
          'artisans using techniques passed down over centuries.',
      image: 'assets/images/clothes.jpg',
      origin:
          'Tribal jewellery-making in Jharkhand dates back centuries, with techniques influenced '
          'by the region\'s rich mineral deposits (particularly iron and copper). The Santhal, Munda, '
          'and Ho tribes each have distinctive jewellery styles. Silver is preferred for its '
          'spiritual significance — believed to ward off negative energy.',
      materials: ['Silver', 'Brass and bronze', 'Iron', 'Glass beads', 'Cowrie shells', 'Plant seeds and lac'],
      craftsmanship:
          'Each piece is handmade using traditional tools. Silver wires are drawn, hammered, and '
          'shaped without soldering. Beads are individually threaded in geometric patterns. '
          'The "Jhumar" (earring) involves intricate filigree work. A single necklace can take '
          'several days to complete.',
      occasions: ['Weddings and engagements', 'Festivals (Sohrai, Karma)', 'Dance performances', 'Daily wear by tribal women'],
      significance:
          'Tribal jewellery is deeply symbolic — certain designs indicate marital status, community '
          'affiliation, and social standing. It is also considered a form of savings, as silver '
          'jewellery is passed down as heirloom wealth from mother to daughter.',
    ),
    _Clothing(
      name: 'Gamcha',
      subtitle: 'The versatile checked cloth',
      description: 'The Gamcha is a lightweight, checked cotton cloth that is a staple of Jharkhandi life. '
          'Used as a towel, scarf, headgear, shoulder cloth, or even a makeshift bag, its red-and-white '
          'checked pattern is instantly recognisable. No rural household is without a gamcha — it is '
          'as essential as rice or salt in daily life.',
      image: 'assets/images/clothes.jpg',
      origin:
          'The Gamcha has been woven in the Gangetic plains and eastern India for centuries. '
          'In Jharkhand, it became particularly popular among farmers and labourers for its '
          'absorbency, durability, and low cost. The distinctive check pattern is created by '
          'interweaving coloured and undyed cotton threads.',
      materials: ['Cotton (coarse weave)', 'Hand-spun yarn', 'Natural red dye (from madder root)'],
      craftsmanship:
          'Gamchas are woven on simple frame looms. The checked pattern is achieved by arranging '
          'coloured and white yarns in a grid before weaving. Traditional gamchas use natural '
          'dyes — the red colour comes from madder (manjistha) root. A skilled weaver produces '
          '4-6 gamchas per day.',
      occasions: ['Daily utility in rural areas', 'Farming and labour', 'Temple visits (as shoulder cloth)', 'Gift exchanges during festivals'],
      significance:
          'The humble Gamcha is a cultural equaliser — worn by rich and poor alike. It symbolises '
          'the hardworking spirit of Jharkhand\'s people. In recent years, it has become a fashion '
          'statement, with designers incorporating the gamcha pattern into modern clothing.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBg,
      body: CustomScrollView(
        slivers: [
          _ClothesHeader(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            sliver: SliverList.separated(
              itemCount: _items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _ClothesCard(item: _items[i], index: i),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClothesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.forestGreen,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/clothes.jpg', fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.forestGreen.withValues(alpha: 0.3),
                    AppColors.forestGreen.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 80, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Traditional Attire',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5)),
                  SizedBox(height: 6),
                  Text('Discover Jharkhand\'s textile heritage\nfrom handlooms to ceremonial wear',
                      style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClothesCard extends StatelessWidget {
  final _Clothing item;
  final int index;

  const _ClothesCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => _ClothesDetailScreen(item: item)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  Image.asset(item.image, height: 180, width: double.infinity, fit: BoxFit.cover),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.3)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16, bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.forestGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('${item.materials.length} materials',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.3)),
                  const SizedBox(height: 4),
                  Text(item.subtitle, style: const TextStyle(fontSize: 13, color: AppColors.forestGreen, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.forestGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
                        child: const Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.history, size: 14, color: AppColors.forestGreen),
                          SizedBox(width: 6),
                          Text('View History', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.forestGreen)),
                        ]),
                      ),
                      const Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary.withValues(alpha: 0.4)),
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

class _ClothesDetailScreen extends StatelessWidget {
  final _Clothing item;

  const _ClothesDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.forestGreen,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Image.asset(item.image, height: 240, width: double.infinity, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(item.subtitle, style: const TextStyle(fontSize: 14, color: AppColors.forestGreen, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  Text(item.description, style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.6)),
                  const SizedBox(height: 28),
                  _sectionHeader('Origin & History', Icons.history, AppColors.forestGreen),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
                    ),
                    child: Text(item.origin,
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.7)),
                  ),
                  const SizedBox(height: 28),
                  _sectionHeader('Materials', Icons.shopping_bag, AppColors.forestGreen),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: item.materials.map((m) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.forestGreen.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.forestGreen.withValues(alpha: 0.12)),
                      ),
                      child: Text(m, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                    )).toList(),
                  ),
                  const SizedBox(height: 28),
                  _sectionHeader('Craftsmanship', Icons.handyman, AppColors.forestGreen),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
                    ),
                    child: Text(item.craftsmanship,
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.7)),
                  ),
                  const SizedBox(height: 28),
                  _sectionHeader('Occasions Worn', Icons.event, AppColors.forestGreen),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: item.occasions.map((o) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.mutedJade.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.mutedJade.withValues(alpha: 0.12)),
                      ),
                      child: Text(o, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                    )).toList(),
                  ),
                  const SizedBox(height: 28),
                  _sectionHeader('Cultural Significance', Icons.auto_stories, AppColors.forestGreen),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.forestGreen.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.forestGreen.withValues(alpha: 0.08)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.auto_awesome, size: 18, color: AppColors.forestGreen),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(item.significance,
                              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ],
    );
  }
}

class _Clothing {
  final String name;
  final String subtitle;
  final String description;
  final String image;
  final String origin;
  final List<String> materials;
  final String craftsmanship;
  final List<String> occasions;
  final String significance;

  const _Clothing({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.origin,
    required this.materials,
    required this.craftsmanship,
    required this.occasions,
    required this.significance,
  });
}
