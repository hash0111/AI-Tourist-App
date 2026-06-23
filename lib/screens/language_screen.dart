import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../core/services/supabase_service.dart';
import '../core/services/tts_service.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int _activeTab = 0;
  final _tts = TtsService();
  final _supabase = SupabaseService();

  int _selectedCategory = -1;
  final Set<String> _learnedPhrases = {};

  final _allPhrases = [
    _PhraseData('𑂔𑂷 𑂯𑂰𑂩𑂵', 'Jo Haare', 'Welcome / Hello', 'Greetings'),
    _PhraseData('𑂮𑂵𑂫𑂰 𑂮𑂵𑂫𑂰', 'Sewa Sewa', 'How are you?', 'Greetings'),
    _PhraseData('𑂥𑂰𑂚𑂱𑂩𑂵', 'Baade re', 'Thank you', 'Greetings'),
    _PhraseData('𑂔𑂰𑂯𑂵𑂩 𑂍𑂰𑂪𑂰𑂢𑂰', 'Jaher Kalana', 'Good morning', 'Greetings'),
    _PhraseData('𑂯𑂰𑂢𑂹𑂯𑂲', 'Hanhi', 'Yes', 'Greetings'),
    _PhraseData('𑂃𑂒𑂹𑂓𑂰', 'Achchha', 'Okay / Good', 'Greetings'),
    _PhraseData('𑂔𑂵𑂫𑂰 𑂍𑂵 𑂮𑂧𑂨', 'Jewa ke samay', 'Meal time', 'Food & Dining'),
    _PhraseData('𑂥𑂰𑂔𑂩 𑂦𑂰𑂗', 'Bajar bhat', 'Market rice', 'Food & Dining'),
    _PhraseData('𑂣𑂰𑂢𑂱 𑂠𑂱𑂨𑂷', 'Paani diyo', 'Give water', 'Food & Dining'),
    _PhraseData('𑂔𑂰𑂉𑂠𑂰', 'Jaeda', 'Where?', 'Directions'),
    _PhraseData('𑂒𑂰𑂪𑂷', 'Chalo', 'Let\'s go', 'Directions'),
    _PhraseData('𑂍𑂵𑂞𑂵𑂍 𑂠𑂳𑂩𑂱', 'Ketek duri', 'How far?', 'Directions'),
    _PhraseData('𑂍𑂵𑂞𑂵𑂍 𑂣𑂶𑂮𑂰', 'Ketek paisa', 'How much?', 'Shopping'),
    _PhraseData('𑂥𑂵𑂮𑂲 𑂣𑂶𑂮𑂰', 'Besi paisa', 'Too expensive', 'Shopping'),
    _PhraseData('𑂮𑂮𑂹𑂞𑂵 𑂠𑂵𑂫𑂷', 'Saste devo', 'Give discount', 'Shopping'),
  ];

  List<_PhraseData> get _filteredPhrases {
    if (_selectedCategory == -1) return _allPhrases;
    return _allPhrases.where((p) => p.category == _categories[_selectedCategory].$1).toList();
  }

  final _categories = [
    ('Greetings', Icons.waving_hand, AppColors.mutedJade),
    ('Food & Dining', Icons.restaurant, AppColors.saffron),
    ('Directions', Icons.directions, AppColors.turmericGold),
    ('Shopping', Icons.shopping_bag, AppColors.deepIndigo),
  ];

  final _sourceController = TextEditingController();
  String _translatedText = '';
  String _transliteration = '';
  bool _translating = false;
  String _sourceLang = 'English';
  String _targetLang = 'Santhali';

  int _practiceScore = 0;
  int _practiceIndex = 0;
  final _practicePhrases = [
    _PracticeQ('𑂔𑂷 𑂯𑂰𑂩𑂵', ['Goodbye', 'Welcome / Hello', 'Thank you'], 1, fallback: 'Jo Haare'),
    _PracticeQ('𑂥𑂰𑂚𑂱𑂩𑂵', ['Thank you', 'Good morning', 'How are you?'], 0, fallback: 'Baade re'),
    _PracticeQ('𑂮𑂵𑂫𑂰 𑂮𑂵𑂫𑂰', ['Welcome', 'How are you?', 'Goodbye'], 1, fallback: 'Sewa Sewa'),
    _PracticeQ('𑂔𑂰𑂯𑂵𑂩 𑂍𑂰𑂪𑂰𑂢𑂰', ['Good night', 'Good morning', 'Good evening'], 1, fallback: 'Jaher Kalana'),
    _PracticeQ('𑂯𑂰𑂢𑂹𑂯𑂲', ['No', 'Maybe', 'Yes'], 2, fallback: 'Hanhi'),
    _PracticeQ('𑂃𑂒𑂹𑂓𑂰', ['Bad', 'Okay / Good', 'Hello'], 1, fallback: 'Achchha'),
    _PracticeQ('𑂔𑂵𑂫𑂰 𑂍𑂵 𑂮𑂧𑂨', ['Bed time', 'Meal time', 'Work time'], 1, fallback: 'Jewa ke samay'),
    _PracticeQ('𑂒𑂰𑂪𑂷', ['Stop', 'Come here', 'Let\'s go'], 2, fallback: 'Chalo'),
    _PracticeQ('𑂍𑂵𑂞𑂵𑂍 𑂣𑂶𑂮𑂰', ['How much?', 'How far?', 'How many?'], 0, fallback: 'Ketek paisa'),
    _PracticeQ('𑂥𑂵𑂮𑂲 𑂣𑂶𑂮𑂰', ['Very cheap', 'Too expensive', 'Just right'], 1, fallback: 'Besi paisa'),
  ];

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
    _sourceController.dispose();
    _tts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _LanguageHeader(),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _buildProgress(),
          )),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: _buildTabBar(),
          )),
          if (_activeTab == 0) ..._buildPhrasesSlivers(),
          if (_activeTab == 1) ..._buildTranslatorSlivers(),
          if (_activeTab == 2) ..._buildPracticeSlivers(),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    final count = _allPhrases.length;
    final learned = _learnedPhrases.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Your Progress', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
              Text('$learned/$count learned', style: const TextStyle(fontSize: 12, color: AppColors.saffron, fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: count > 0 ? learned / count : 0,
                backgroundColor: AppColors.surfaceBg,
                color: AppColors.mutedJade,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _Stat(label: 'Languages', value: '5'),
              _Stat(label: 'Phrases', value: '$count'),
              _Stat(label: 'Learned', value: '$learned'),
              _Stat(label: 'Practice', value: '$_practiceScore/${_practicePhrases.length}'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: AppColors.surfaceBg, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.divider)),
        child: Row(
          children: [
            _tabBtn(label: 'Phrases', icon: Icons.chat, index: 0),
            _tabBtn(label: 'Translator', icon: Icons.g_translate, index: 1),
            _tabBtn(label: 'Practice', icon: Icons.mic, index: 2),
          ],
        ),
      ),
    );
  }

  Widget _tabBtn({required String label, required IconData icon, required int index}) {
    final selected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            boxShadow: selected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2))] : [],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 18, color: selected ? AppColors.saffron : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? AppColors.saffron : AppColors.textSecondary)),
          ]),
        ),
      ),
    );
  }

  List<Widget> _buildPhrasesSlivers() {
    return [
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _sectionHdr('Categories'),
      )),
      const SliverToBoxAdapter(child: SizedBox(height: 14)),
      SliverToBoxAdapter(child: SizedBox(
        height: 90,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (_, i) {
            final c = _categories[i];
            final selected = _selectedCategory == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = selected ? -1 : i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 100,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: selected ? c.$3.withValues(alpha: 0.12) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: selected ? c.$3.withValues(alpha: 0.4) : AppColors.divider),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(c.$2, color: selected ? c.$3 : AppColors.textSecondary, size: 22),
                  const SizedBox(height: 6),
                  Text(c.$1, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: selected ? c.$3 : AppColors.textPrimary)),
                ]),
              ),
            );
          },
        ),
      )),
      const SliverToBoxAdapter(child: SizedBox(height: 16)),
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _sectionHdr(_selectedCategory == -1 ? 'All Phrases' : '${_categories[_selectedCategory].$1} Phrases'),
      )),
      const SliverToBoxAdapter(child: SizedBox(height: 12)),
      if (_filteredPhrases.isEmpty)
        const SliverToBoxAdapter(child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Center(child: Text('No phrases in this category yet', style: TextStyle(color: AppColors.textSecondary))),
        ))
      else
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final p = _filteredPhrases[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _PhraseCard(
                    phrase: p,
                    tts: _tts,
                    learned: _learnedPhrases.contains(p.regional),
                    onPlay: () => setState(() => _learnedPhrases.add(p.regional)),
                  ),
                );
              },
              childCount: _filteredPhrases.length,
            ),
          ),
        ),
    ];
  }

  List<Widget> _buildTranslatorSlivers() {
    final langs = ['English', 'Hindi', 'Santhali', 'Kurukh', 'Mundari', 'Khortha', 'Nagpuri'];

    return [
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _langDropdown(langs, _sourceLang, (v) => setState(() => _sourceLang = v)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() {
                          final tmp = _sourceLang;
                          _sourceLang = _targetLang;
                          _targetLang = tmp;
                        }),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppColors.surfaceBg, borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.swap_horiz, color: AppColors.saffron, size: 22),
                        ),
                      ),
                      const Spacer(),
                      _langDropdown(langs, _targetLang, (v) => setState(() => _targetLang = v)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _sourceController,
                    decoration: InputDecoration(
                      hintText: 'Enter text to translate...',
                      filled: true, fillColor: AppColors.surfaceBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    maxLines: 3,
                  ),
                  if (_translatedText.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: AppColors.jadeLight, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_translatedText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.deepIndigo)),
                          if (_transliteration.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(_transliteration, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                          ],
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppColors.surfaceBg, borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.mic, color: AppColors.saffron, size: 20),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            final text = _translatedText.isNotEmpty ? _translatedText : _sourceController.text;
                            _tts.speak(text, fallback: _transliteration);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: AppColors.surfaceBg, borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.volume_up, color: AppColors.textSecondary, size: 20),
                          ),
                        ),
                      ]),
                      GestureDetector(
                        onTap: () {
                          if (!_translating) _translate();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(color: AppColors.saffron, borderRadius: BorderRadius.circular(12)),
                          child: _translating
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Row(mainAxisSize: MainAxisSize.min, children: [
                                  Icon(Icons.g_translate, color: Colors.white, size: 18),
                                  SizedBox(width: 6),
                                  Text('Translate', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14)),
                                ]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.jadeLight, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.mutedJade.withValues(alpha: 0.2))),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.language, color: AppColors.mutedJade, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Available Languages', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text('Santhali, Kurukh, Mundari, Khortha, Nagpuri, Ho, Kharia', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
                  ]),
                ),
              ]),
            ),
          ],
        ),
      )),
    ];
  }

  Widget _langDropdown(List<String> langs, String current, ValueChanged<String> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppColors.surfaceBg, borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: current,
          items: langs.map((l) => DropdownMenuItem(value: l, child: Text(l, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)))).toList(),
          onChanged: (v) { if (v != null) onChanged(v); },
          isDense: true,
        ),
      ),
    );
  }

  Future<void> _translate() async {
    final text = _sourceController.text.trim();
    if (text.isEmpty) return;

    setState(() => _translating = true);
    try {
      final result = await _supabase.translate(
        text: text,
        sourceLanguage: _sourceLang,
        targetLanguage: _targetLang,
      );
      if (!mounted) return;
      setState(() {
        _translatedText = result['translatedText'] ?? '';
        _transliteration = result['transliteration'] ?? '';
        _translating = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _translatedText = 'Translation failed. Using local lookup.';
        _transliteration = '';
        _translating = false;
      });
    }
  }

  List<Widget> _buildPracticeSlivers() {
    if (_practiceIndex >= _practicePhrases.length) {
      return [
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.jadeLight, borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.celebration, color: AppColors.mutedJade, size: 48),
              ),
              const SizedBox(height: 16),
              const Text('Practice Complete!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Text('You scored $_practiceScore/${_practicePhrases.length} correct', style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              _buildScoreBar(),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                FilledButton.icon(
                  onPressed: () => setState(() { _practiceIndex = 0; _practiceScore = 0; }),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Start Over'),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.saffron),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _activeTab = 0),
                  icon: const Icon(Icons.chat),
                  label: const Text('Review Phrases'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.deepIndigo),
                ),
              ]),
            ]),
          ),
        )),
      ];
    }

    final q = _practicePhrases[_practiceIndex];
    return [
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.deepIndigo, const Color(0xFF2D1B69)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                      child: Text('Question ${_practiceIndex + 1}/${_practicePhrases.length}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    GestureDetector(
                      onTap: () => _tts.speak(q.fallback),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.volume_up, color: Colors.white, size: 20),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  Text(q.question, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text('What does this mean?', style: TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...q.options.asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    final correct = entry.key == q.correctIndex;
                    if (correct) _practiceScore++;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(children: [
                          Icon(correct ? Icons.check_circle : Icons.cancel, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(correct ? 'Correct!' : 'The answer was: ${q.options[q.correctIndex]}'),
                        ]),
                        backgroundColor: correct ? AppColors.mutedJade : Colors.red.shade700,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                    Future.delayed(const Duration(milliseconds: 600), () {
                      if (mounted) setState(() => _practiceIndex++);
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(color: AppColors.divider),
                    foregroundColor: AppColors.textPrimary,
                  ),
                  child: Text(entry.value, style: const TextStyle(fontSize: 15)),
                ),
              ),
            )),
          ],
        ),
      )),
    ];
  }

  Widget _buildScoreBar() {
    final score = _practiceScore;
    final total = _practicePhrases.length;
    final pct = total > 0 ? score / total : 0.0;
    String emoji;
    String msg;
    if (pct >= 0.9) { emoji = '🌟'; msg = 'Outstanding!'; }
    else if (pct >= 0.7) { emoji = '👏'; msg = 'Great job!'; }
    else if (pct >= 0.5) { emoji = '💪'; msg = 'Keep practicing!'; }
    else { emoji = '📖'; msg = 'Review the phrases!'; }

    return Column(children: [
      Text('$emoji $msg', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      const SizedBox(height: 8),
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(
          value: pct,
          backgroundColor: AppColors.surfaceBg,
          color: pct >= 0.7 ? AppColors.mutedJade : pct >= 0.5 ? AppColors.turmericGold : AppColors.saffron,
          minHeight: 10,
        ),
      ),
      const SizedBox(height: 4),
      Text('$score/$total correct', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
    ]);
  }

  Widget _sectionHdr(String title) {
    return Row(children: [
      Container(width: 3, height: 16, decoration: BoxDecoration(color: AppColors.saffron, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 8),
      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
    ]);
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.deepIndigo)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
    ]);
  }
}

class _PhraseData {
  final String regional, transliteration, english, category;
  const _PhraseData(this.regional, this.transliteration, this.english, this.category);
}

class _PhraseCard extends StatelessWidget {
  final _PhraseData phrase;
  final TtsService tts;
  final bool learned;
  final VoidCallback onPlay;

  const _PhraseCard({
    required this.phrase,
    required this.tts,
    required this.learned,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: learned ? AppColors.mutedJade.withValues(alpha: 0.3) : AppColors.divider),
      ),
      child: Row(
        children: [
          if (learned)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: AppColors.jadeLight, shape: BoxShape.circle),
                child: const Icon(Icons.check_circle, color: AppColors.mutedJade, size: 18),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(phrase.regional, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepIndigo)),
                const SizedBox(height: 2),
                Text(phrase.transliteration, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                const SizedBox(height: 2),
                Text(phrase.english, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              onPlay();
              tts.speak(phrase.transliteration);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.saffronLight, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.volume_up, color: AppColors.saffron, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class _PracticeQ {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String fallback;

  const _PracticeQ(this.question, this.options, this.correctIndex, {this.fallback = ''});
}

class _LanguageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: false,
      floating: false,
      backgroundColor: AppColors.deepIndigo,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(gradient: AppColors.gradientHero),
          child: Stack(
            children: [
              Positioned(top: -30, right: -30, child: Container(width: 180, height: 180, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.04)))),
              Positioned(bottom: -40, left: -20, child: Container(width: 140, height: 140, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.03)))),
              Positioned(left: 20, right: 20, bottom: 20, child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Language Learning', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 6),
                  Text('Master Jharkhand\'s rich linguistic heritage', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.85))),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
