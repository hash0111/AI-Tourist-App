import 'package:flutter/material.dart';

void showStorySheet(BuildContext context, Map<String, dynamic> story) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _StorySheet(story: story),
  );
}

class _StorySheet extends StatelessWidget {
  final Map<String, dynamic> story;
  const _StorySheet({required this.story});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 4),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                children: [
                  Text(story['title'] ?? '', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  if (story['subtitle'] != null) ...[
                    const SizedBox(height: 6),
                    Text(story['subtitle'], style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
                  ],
                  ..._buildSections(context),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildSections(BuildContext context) {
    final theme = Theme.of(context);
    final sections = <Widget>[];

    void addSection(String label, dynamic value) {
      if (value == null) return;

      if (value is String) {
        sections.add(const SizedBox(height: 20));
        sections.add(_SectionHeader(label: label));
        sections.add(const SizedBox(height: 8));
        sections.add(Text(value, style: theme.textTheme.bodyLarge?.copyWith(height: 1.6)));
      } else if (value is List) {
        sections.add(const SizedBox(height: 20));
        sections.add(_SectionHeader(label: label));
        sections.add(const SizedBox(height: 8));
        for (final item in value) {
          sections.add(Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(fontSize: 16, color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                Expanded(child: Text('$item', style: const TextStyle(height: 1.4))),
              ],
            ),
          ));
        }
      }
    }

    final orderedKeys = [
      ('summary', 'Summary'),
      ('legend', 'The Legend'),
      ('originStory', 'Origin Story'),
      ('originHistory', 'Origin & History'),
      ('preparationMethod', 'Preparation'),
      ('culturalSignificance', 'Cultural Significance'),
      ('keyCharacters', 'Key Characters'),
      ('relatedPlaces', 'Related Places'),
      ('ingredients', 'Key Ingredients'),
      ('materials', 'Materials'),
      ('craftsmanship', 'Craftsmanship'),
      ('whenEaten', 'When It\'s Eaten'),
      ('occasionsWorn', 'Occasions Worn'),
      ('interestingFacts', 'Interesting Facts'),
      ('nutritionalValue', 'Nutritional Value'),
      ('modernRelevance', 'Modern Relevance'),
      ('moralOrTeaching', 'Moral & Teaching'),
    ];

    for (final (key, label) in orderedKeys) {
      addSection(label, story[key]);
    }

    return sections;
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 18, decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(2),
        )),
        const SizedBox(width: 10),
        Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
