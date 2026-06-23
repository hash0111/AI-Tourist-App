import 'package:flutter/material.dart';
import '../constants/colors.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  static const _foods = [
    _Food(
      name: 'Dhuska',
      subtitle: 'Deep-fried rice & lentil cakes',
      description: 'A popular breakfast and snack item in Jharkhand, Dhuska is made from a batter of '
          'rinsed rice and chana dal (Bengal gram), deep-fried to golden perfection. Light, crispy on the '
          'outside and soft within, it is typically served with ghughni (spiced chickpea curry) or '
          'potato curry and green chutney.',
      image: 'assets/images/food_dishka.png',
      ingredients: ['Rice', 'Chana dal (Bengal gram)', 'Turmeric', 'Salt', 'Green chillies', 'Ginger', 'Oil for deep-frying'],
      preparation:
          '1. Soak rice and chana dal separately for 4-5 hours.\n'
          '2. Drain and grind together to a smooth paste.\n'
          '3. Add finely chopped green chillies, grated ginger, turmeric, and salt.\n'
          '4. Whisk the batter well until slightly fluffy.\n'
          '5. Heat oil in a kadhai.\n'
          '6. Drop spoonfuls of batter into hot oil and fry until golden brown.\n'
          '7. Serve hot with ghughni or aloo curry.',
      significance: 'Dhuska is a staple breakfast in tribal households of Jharkhand and is often '
          'prepared during festivals. It represents the simple yet rich culinary heritage of the state, '
          'using locally grown rice and lentils.',
    ),
    _Food(
      name: 'Litti Chokha',
      subtitle: 'Baked wheat balls with sattu filling',
      description: 'Litti is a baked whole wheat dough ball stuffed with spiced sattu (roasted gram flour), '
          'traditionally cooked over cow dung cakes or charcoal. Chokha is a smoky mash of roasted '
          'eggplant, tomato, and potato. Together, they create an iconic Bihari-Jharkhandi meal.',
      image: 'assets/images/food_litti.png',
      ingredients: [
        'Whole wheat flour', 'Sattu (roasted gram flour)', 'Mustard oil', 'Ajwain (carom seeds)',
        'Lemon juice', 'Green chillies', 'Ginger', 'Garlic', 'Onion', 'Eggplant', 'Potato', 'Tomato',
        'Pickling spices (kalonji, saunf, methi)',
      ],
      preparation:
          '1. Knead whole wheat flour with salt, ajwain, and mustard oil into a stiff dough.\n'
          '2. Mix sattu with chopped onions, green chillies, ginger, garlic, lemon juice, and mustard oil for the filling.\n'
          '3. Stuff the dough balls with the sattu mixture.\n'
          '4. Bake over charcoal or in a pre-heated oven at 200°C for 15-20 mins.\n'
          '5. For chokha: roast eggplant, tomato, and potato until skins char.\n'
          '6. Peel and mash with onions, chillies, garlic, mustard oil, and salt.\n'
          '7. Serve littis hot, brushed with ghee, alongside chokha.',
      significance: 'Litti Chokha is more than food — it is a cultural emblem of the region. Traditionally '
          'eaten by farmers during harvest season, it is now celebrated at festivals and gatherings, '
          'representing the earthy, robust flavours of Jharkhand.',
    ),
    _Food(
      name: 'Rugra',
      subtitle: 'Wild mushroom delicacy',
      description: 'Rugra is a seasonal wild mushroom found in Jharkhand forests during the monsoon. '
          'Tribal communities forage for these earthy mushrooms and cook them in a simple, flavourful '
          'preparation with minimal spices to let the natural taste shine.',
      image: 'assets/images/food_rugra.png',
      ingredients: ['Rugra (wild mushrooms)', 'Mustard oil', 'Onion', 'Tomato', 'Garlic', 'Green chillies', 'Turmeric', 'Cumin seeds', 'Salt'],
      preparation:
          '1. Clean rugra thoroughly by rinsing in water multiple times.\n'
          '2. Slice mushrooms into bite-sized pieces.\n'
          '3. Heat mustard oil, add cumin seeds and let them crackle.\n'
          '4. Sauté chopped onions, garlic, and green chillies until golden.\n'
          '5. Add tomatoes, turmeric, and salt; cook until oil separates.\n'
          '6. Add rugra and cook on medium heat for 15-20 mins, stirring occasionally.\n'
          '7. Serve hot with steamed rice or roti.',
      significance: 'Rugra is a monsoon treasure for tribal communities. Foraging for mushrooms is a '
          'centuries-old tradition, and the dish represents the deep connection between Jharkhand\'s '
          'forests and its people\'s cuisine.',
    ),
    _Food(
      name: 'Chhilka Roti',
      subtitle: 'Rice flour crepes',
      description: 'Chhilka Roti is a thin, soft crepe made from rice flour batter. A breakfast staple '
          'in Sadan households, it is typically eaten with ghughni, chutney, or potato curry. Its '
          'delicate texture and subtle flavour make it a versatile base for both sweet and savoury accompaniments.',
      image: 'assets/images/food.png',
      ingredients: ['Rice flour', 'Water', 'Salt', 'Oil for cooking'],
      preparation:
          '1. Mix rice flour with water and salt to form a thin, smooth batter (similar to dosa batter).\n'
          '2. Let the batter rest for 30 minutes.\n'
          '3. Heat a tawa or non-stick pan.\n'
          '4. Pour a ladleful of batter and spread in a circular motion.\n'
          '5. Drizzle a little oil around the edges.\n'
          '6. Cook on medium heat until golden spots appear, then flip.\n'
          '7. Serve hot with ghughni, chokha, or chutney.',
      significance: 'Chhilka Roti is a daily breakfast in rural Jharkhand. Made from rice, the region\'s '
          'primary grain, it exemplifies how local ingredients shape everyday meals. It is also prepared '
          'during festivals and family gatherings.',
    ),
    _Food(
      name: 'Thekua',
      subtitle: 'Sweet wheat flour cookies',
      description: 'Thekua is a traditional deep-fried sweet snack made from whole wheat flour, jaggery, '
          'and ghee. Crunchy on the outside and slightly chewy within, it is especially prepared during '
          'Chhath Puja and other festivals. Its long shelf life made it popular among travellers.',
      image: 'assets/images/food_thekua.png',
      ingredients: ['Whole wheat flour', 'Jaggery (gur)', 'Ghee', 'Fennel seeds (saunf)', 'Cardamom powder', 'Coconut (optional)', 'Oil for frying'],
      preparation:
          '1. Melt jaggery with a little water to form a syrup.\n'
          '2. Mix wheat flour, fennel seeds, cardamom powder, and grated coconut.\n'
          '3. Add warm ghee and the jaggery syrup; knead into a firm dough.\n'
          '4. Rest the dough for 15 minutes.\n'
          '5. Shape into small discs with a thumb impression in the centre.\n'
          '6. Deep-fry on low heat until golden brown.\n'
          '7. Cool completely before storing in an airtight container.',
      significance: 'Thekua is synonymous with Chhath Puja, the most important festival of the region. '
          'It is offered as prasad and distributed among devotees. The use of jaggery and wheat reflects '
          'the agricultural bounty of Jharkhand.',
    ),
    _Food(
      name: 'Pitha',
      subtitle: 'Traditional rice cakes',
      description: 'Pitha are steamed or fried rice cakes stuffed with sweet or savoury fillings. '
          'Varieties include Arsa Pitha (deep-fried, sweet), Dudh Pitha (steamed in milk), and '
          'Chunga Pitha (baked in bamboo tubes). A festive essential in every Jharkhandi household.',
      image: 'assets/images/food.png',
      ingredients: ['Rice flour', 'Jaggery or sugar', 'Coconut (grated)', 'Sesame seeds', 'Cardamom', 'Salt', 'Banana leaves (for steaming)'],
      preparation:
          '1. Prepare dough with rice flour and warm water.\n'
          '2. For sweet filling: mix grated coconut, jaggery, cardamom, and sesame seeds.\n'
          '3. Flatten a portion of dough, place filling in centre, seal into a crescent shape.\n'
          '4. Steam on a greased banana leaf for 15-20 minutes (for steamed pitha).\n'
          '5. Alternatively, deep-fry until golden (for Arsa Pitha).\n'
          '6. Serve warm with tea or as a festive dessert.',
      significance: 'Pitha-making is a communal activity during festivals in Jharkhand. Different '
          'tribes have their own variations — Chunga Pitha (baked in bamboo) is uniquely Santhali. '
          'Each pitha tells a story of the land and its people.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBg,
      body: CustomScrollView(
        slivers: [
          _FoodHeader(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            sliver: SliverList.separated(
              itemCount: _foods.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _FoodCard(food: _foods[i], index: i),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.saffronOrange,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/hero_bg.png', fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.saffronOrange.withValues(alpha: 0.3),
                    AppColors.saffronOrange.withValues(alpha: 0.85),
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
                  Text('Traditional Cuisine',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5)),
                  SizedBox(height: 6),
                  Text('Discover authentic flavours of Jharkhand\nfrom tribal kitchens to festive feasts',
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

class _FoodCard extends StatelessWidget {
  final _Food food;
  final int index;

  const _FoodCard({required this.food, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => _FoodDetailScreen(food: food)),
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
                  Image.asset(food.image, height: 180, width: double.infinity, fit: BoxFit.cover),
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
                        color: AppColors.saffronOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('${food.ingredients.length} ingredients',
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
                  Text(food.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.3)),
                  const SizedBox(height: 4),
                  Text(food.subtitle, style: const TextStyle(fontSize: 13, color: AppColors.saffronOrange, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(food.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.saffronOrange.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
                        child: const Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.menu_book, size: 14, color: AppColors.saffronOrange),
                          SizedBox(width: 6),
                          Text('View Recipe', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.saffronOrange)),
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

class _FoodDetailScreen extends StatelessWidget {
  final _Food food;

  const _FoodDetailScreen({required this.food});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.saffronOrange,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Image.asset(food.image, height: 240, width: double.infinity, fit: BoxFit.cover),
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
                  Text(food.name, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(food.subtitle, style: const TextStyle(fontSize: 14, color: AppColors.saffronOrange, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  Text(food.description, style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.6)),
                  const SizedBox(height: 28),
                  _sectionHeader('Ingredients', Icons.shopping_bag),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: food.ingredients.map((ing) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.saffronOrange.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.saffronOrange.withValues(alpha: 0.12)),
                      ),
                      child: Text(ing, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                    )).toList(),
                  ),
                  const SizedBox(height: 28),
                  _sectionHeader('Preparation Method', Icons.restaurant_menu),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
                    ),
                    child: Text(food.preparation, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.7)),
                  ),
                  const SizedBox(height: 28),
                  _sectionHeader('Cultural Significance', Icons.auto_stories),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.deepIndigo.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.deepIndigo.withValues(alpha: 0.08)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.auto_awesome, size: 18, color: AppColors.saffronOrange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(food.significance,
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

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.saffronOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: AppColors.saffronOrange),
        ),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ],
    );
  }
}

class _Food {
  final String name;
  final String subtitle;
  final String description;
  final String image;
  final List<String> ingredients;
  final String preparation;
  final String significance;

  const _Food({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.ingredients,
    required this.preparation,
    required this.significance,
  });
}
