import 'package:flutter/material.dart';
import '../core/services/supabase_service.dart';
import '../widgets/animated_list_item.dart';

class AIPlannerScreen extends StatefulWidget {
  const AIPlannerScreen({super.key});

  @override
  State<AIPlannerScreen> createState() => _AIPlannerScreenState();
}

class _AIPlannerScreenState extends State<AIPlannerScreen> {
  final _service = SupabaseService();
  final _queryController = TextEditingController();
  final _budgetController = TextEditingController();
  Map<String, dynamic>? _plan;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _queryController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final query = _queryController.text.trim();
    final budget = double.tryParse(_budgetController.text.trim());

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tell me about your trip!')),
      );
      return;
    }
    if (budget == null || budget <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid budget in INR')),
      );
      return;
    }

    setState(() { _loading = true; _error = null; _plan = null; });

    try {
      final plan = await _service.getAIPlan(query: query, budget: budget);
      setState(() { _plan = plan; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Trip Planner')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputCard(theme),
            if (_error != null) ...[
              const SizedBox(height: 16),
              _buildErrorCard(theme),
            ],
            if (_plan != null) ...[
              const SizedBox(height: 20),
              _buildPlan(theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.travel_explore, color: appTeal, size: 24),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Plan Your Trip', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Text('Let AI craft the perfect itinerary', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _queryController,
              decoration: const InputDecoration(
                labelText: 'Trip description',
                hintText: 'e.g. family trip to Ranchi & waterfalls for 3 days',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _budgetController,
              decoration: const InputDecoration(
                labelText: 'Budget',
                hintText: 'e.g. 15000',
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _loading ? null : _generate,
                icon: _loading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.auto_awesome),
                label: Text(_loading ? 'Generating...' : 'Generate Plan'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(_error!, style: TextStyle(color: Colors.red.shade800, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildPlan(ThemeData theme) {
    final plan = _plan!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.check_circle, color: appTeal, size: 22),
            ),
            const SizedBox(width: 12),
            Text('Your Trip Plan', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        _PlanSummaryCard(plan: plan, theme: theme),
        if (plan['itinerary'] != null) ...[
          const SizedBox(height: 20),
          _SectionHeader(title: 'Itinerary'),
          const SizedBox(height: 10),
          ...List<Map<String, dynamic>>.from(plan['itinerary']).asMap().entries.map(
            (entry) => AnimatedListItem(
              index: entry.key,
              child: _DayCard(day: entry.value, theme: theme),
            ),
          ),
        ],
        if (plan['budgetBreakdown'] != null) ...[
          const SizedBox(height: 20),
          _SectionHeader(title: 'Budget Breakdown'),
          const SizedBox(height: 10),
          _BudgetCard(plan: plan, theme: theme),
        ],
        if (plan['tips'] != null) ...[
          const SizedBox(height: 20),
          _SectionHeader(title: 'Tips'),
          const SizedBox(height: 10),
          _TipsCard(tips: List<String>.from(plan['tips']), theme: theme),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

const Color appTeal = Color(0xFF1B6B5E);

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 18, decoration: BoxDecoration(
          color: appTeal,
          borderRadius: BorderRadius.circular(2),
        )),
        const SizedBox(width: 10),
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _PlanSummaryCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final ThemeData theme;
  const _PlanSummaryCard({required this.plan, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow(Icons.location_on, 'Destination', '${plan['destination']}', theme),
            const SizedBox(height: 12),
            _infoRow(Icons.schedule, 'Duration', '${plan['duration']}', theme),
            if (plan['bestTimeToVisit'] != null) ...[
              const SizedBox(height: 12),
              _infoRow(Icons.wb_sunny, 'Best Time', '${plan['bestTimeToVisit']}', theme),
            ],
            if (plan['summary'] != null) ...[
              const Divider(height: 24),
              Text(plan['summary'], style: theme.textTheme.bodyMedium?.copyWith(height: 1.6, color: Colors.grey.shade700)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 18, color: appTeal),
        const SizedBox(width: 10),
        SizedBox(width: 80, child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13))),
        Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
      ],
    );
  }
}

class _DayCard extends StatelessWidget {
  final Map<String, dynamic> day;
  final ThemeData theme;
  const _DayCard({required this.day, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: appTeal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text('${day['day']}', style: TextStyle(fontWeight: FontWeight.w700, color: appTeal)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(day['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
              ],
            ),
            if (day['description'] != null) ...[
              const SizedBox(height: 10),
              Text(day['description'], style: const TextStyle(height: 1.5, fontSize: 14)),
            ],
            if (day['activities'] != null) ...[
              const SizedBox(height: 10),
              ...List<String>.from(day['activities']).map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.play_arrow, size: 16, color: appTeal),
                  const SizedBox(width: 6),
                  Expanded(child: Text(a, style: const TextStyle(fontSize: 14, height: 1.3))),
                ]),
              )),
            ],
            if (day['meals'] != null || day['accommodation'] != null || day['estimatedCost'] != null) ...[
              const Divider(height: 20),
              Row(
                children: [
                  if (day['meals'] != null)
                    _chip(Icons.restaurant, '${List<String>.from(day['meals']).length} meals'),
                  if (day['accommodation'] != null) ...[
                    const SizedBox(width: 8),
                    _chip(Icons.bed, 'Stay included'),
                  ],
                  const Spacer(),
                  if (day['estimatedCost'] != null)
                    Text('₹${day['estimatedCost']}', style: TextStyle(fontWeight: FontWeight.w700, color: appTeal)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ]),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final ThemeData theme;
  const _BudgetCard({required this.plan, required this.theme});

  @override
  Widget build(BuildContext context) {
    final breakdown = plan['budgetBreakdown'] as Map<String, dynamic>;
    final items = [
      ('Transport', breakdown['transport']),
      ('Accommodation', breakdown['accommodation']),
      ('Food', breakdown['food']),
      ('Activities', breakdown['activities']),
      ('Miscellaneous', breakdown['miscellaneous']),
    ];
    final total = (plan['totalEstimatedCost'] as num?)?.toDouble() ?? 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ...items.map((item) => _budgetRow(item.$1, item.$2 as num?, total)),
            const Divider(height: 24),
            _budgetRow('Total', total, total, bold: true),
          ],
        ),
      ),
    );
  }

  Widget _budgetRow(String label, num? value, double total, {bool bold = false}) {
    final val = (value ?? 0).toDouble();
    final fraction = total > 0 ? val / total : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w500, fontSize: 14)),
              Text('₹ ${val.toStringAsFixed(0)}', style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w500, fontSize: 14)),
            ],
          ),
          if (!bold) ...[
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction,
                backgroundColor: Colors.grey.shade200,
                color: appTeal,
                minHeight: 4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  final List<String> tips;
  final ThemeData theme;
  const _TipsCard({required this.tips, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('💡', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Expanded(child: Text(tip, style: const TextStyle(height: 1.4, fontSize: 14))),
            ]),
          )).toList(),
        ),
      ),
    );
  }
}
