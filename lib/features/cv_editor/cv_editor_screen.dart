import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/cv_document.dart';
import '../../models/template_config.dart';
import '../../services/country_catalog.dart';
import '../../services/cv_completeness.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/primary_button.dart';
import '../../state/cv_editor_notifier.dart';
import '../../state/cv_list_notifier.dart';
import 'sections/basics_section.dart';
import 'sections/certifications_section.dart';
import 'sections/education_section.dart';
import 'sections/experience_section.dart';
import 'sections/languages_section.dart';
import 'sections/projects_section.dart';
import 'sections/references_section.dart';
import 'sections/skills_section.dart';
import 'sections/summary_section.dart';

class CvEditorScreen extends StatefulWidget {
  const CvEditorScreen({super.key, required this.cvId});
  final String cvId;

  @override
  State<CvEditorScreen> createState() => _CvEditorScreenState();
}

class _CvEditorScreenState extends State<CvEditorScreen> {
  int _step = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureOpen());
  }

  void _ensureOpen() {
    final CvEditorNotifier editor = context.read<CvEditorNotifier>();
    if (editor.document?.id == widget.cvId) return;
    final CvDocument? doc =
        context.read<CvListNotifier>().find(widget.cvId);
    if (doc != null) editor.open(doc);
  }

  static const List<_Step> _steps = <_Step>[
    _Step('Basics', null, BasicsSection()),
    _Step('Summary', CvSectionKind.summary, SummarySection()),
    _Step('Experience', CvSectionKind.experience, ExperienceSection()),
    _Step('Education', CvSectionKind.education, EducationSection()),
    _Step('Skills', CvSectionKind.skills, SkillsSection()),
    _Step('Projects', CvSectionKind.projects, ProjectsSection()),
    _Step('Certifications', CvSectionKind.certifications,
        CertificationsSection()),
    _Step('Languages', CvSectionKind.languages, LanguagesSection()),
    _Step('References', CvSectionKind.references, ReferencesSection()),
  ];

  @override
  Widget build(BuildContext context) {
    final CvEditorNotifier ed = context.watch<CvEditorNotifier>();
    final CvDocument? doc = ed.document;
    if (doc == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('CV Editor')),
        body: const EmptyState(
          icon: Icons.description_outlined,
          title: 'CV not found',
          message: 'This CV no longer exists.',
        ),
      );
    }
    final String countryName =
        CountryCatalog.countryFor(doc.countryCode).name;
    return Scaffold(
      appBar: AppBar(
        title: Text('${_steps[_step].title}  ·  $countryName'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Preview',
            icon: const Icon(Icons.visibility_outlined),
            onPressed: () => context.push('/preview/${doc.id}'),
          ),
          IconButton(
            tooltip: 'Rename',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _renameDialog(context, doc.name),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _Stepper(
            steps: _steps,
            current: _step,
            doc: doc,
            onTap: (int i) => setState(() => _step = i),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[_steps[_step].child],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Row(
            children: <Widget>[
              OutlinedButton(
                onPressed: _step == 0
                    ? null
                    : () => setState(() => _step -= 1),
                child: const Text('Back'),
              ),
              const Spacer(),
              if (_step < _steps.length - 1)
                PrimaryButton(
                  label: 'Next',
                  icon: Icons.arrow_forward,
                  onPressed: () => setState(() => _step += 1),
                )
              else
                PrimaryButton(
                  label: 'Preview',
                  icon: Icons.visibility_outlined,
                  onPressed: () async {
                    await ed.saveNow();
                    if (!context.mounted) return;
                    context.push('/preview/${doc.id}');
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _renameDialog(BuildContext context, String current) async {
    final TextEditingController c = TextEditingController(text: current);
    final String? next = await showDialog<String>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Rename CV'),
        content: TextField(
          controller: c,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, c.text.trim()),
              child: const Text('Save')),
        ],
      ),
    );
    if (next != null && next.isNotEmpty && context.mounted) {
      context.read<CvEditorNotifier>().setName(next);
    }
  }
}

class _Step {
  const _Step(this.title, this.kind, this.child);
  final String title;

  /// Null for the Basics step (basics has its own completeness rule).
  final CvSectionKind? kind;
  final Widget child;
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.steps,
    required this.current,
    required this.doc,
    required this.onTap,
  });
  final List<_Step> steps;
  final int current;
  final CvDocument doc;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        itemCount: steps.length,
        separatorBuilder: (BuildContext _, int __) =>
            const SizedBox(width: 6),
        itemBuilder: (BuildContext context, int i) {
          final bool selected = i == current;
          final _Step s = steps[i];
          final double score = s.kind == null
              ? CvCompleteness.basicsScore(doc)
              : CvCompleteness.scoreFor(s.kind!, doc);
          return ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _Dot(score: score, selected: selected),
                const SizedBox(width: 6),
                Text('${i + 1}. ${s.title}'),
              ],
            ),
            selected: selected,
            onSelected: (_) => onTap(i),
            selectedColor: cs.primary,
            labelStyle: TextStyle(
                color: selected ? cs.onPrimary : cs.onSurface,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500),
          );
        },
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.score, required this.selected});
  final double score;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final Color color = score >= 1
        ? (selected ? cs.onPrimary : Colors.green.shade600)
        : score > 0
            ? (selected ? cs.onPrimary.withOpacity(0.6) : cs.tertiary)
            : (selected ? cs.onPrimary.withOpacity(0.4) : cs.outlineVariant);
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
