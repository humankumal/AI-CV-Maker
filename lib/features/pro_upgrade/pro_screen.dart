import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/pro_notifier.dart';

class ProUpgradeScreen extends StatelessWidget {
  const ProUpgradeScreen({super.key});

  static const List<_Feature> _features = [
    _Feature('Unlimited file history', true),
    _Feature('Bookmarks across files', true),
    _Feature('PDF search & page thumbnails', true),
    _Feature('EPUB e-book reader', true),
    _Feature('Office docs (DOCX, XLSX, PPTX)', true),
    _Feature('Text font customization', true),
    _Feature('Open any 5 files (recent history)', false),
    _Feature('PDF, image & text viewer', false),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Go Pro')),
      body: Consumer<ProNotifier>(
        builder: (context, pro, _) {
          if (pro.isPro) {
            return _ProActiveView();
          }
          return _UpgradeView(pro: pro);
        },
      ),
    );
  }
}

class _UpgradeView extends StatelessWidget {
  const _UpgradeView({required this.pro});
  final ProNotifier pro;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Header
          Text(
            'All In One\nDocument Reader',
            style: theme.textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.w700, height: 1.2),
          ),
          const SizedBox(height: 8),
          Text(
            'One-time purchase. No subscription. No recurring charges.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          // Feature comparison table
          _FeatureTable(),
          const SizedBox(height: 28),
          // Price badge
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.onSurface, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$0.99',
                    style: theme.textTheme.displaySmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'One-time · Lifetime access',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Buy button
          if (pro.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                pro.error!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: pro.loading ? null : () => pro.purchase(),
              child: pro.loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Unlock Pro — \$0.99'),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: pro.loading ? null : () => pro.restore(),
              child: const Text('Restore previous purchase'),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Payment processed by Apple App Store or Google Play.\n'
              'No account required.',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(4),
        1: FixedColumnWidth(52),
        2: FixedColumnWidth(52),
      },
      children: [
        // Header row
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.colorScheme.outline, width: 0.5),
            ),
          ),
          children: [
            const TableCell(child: SizedBox()),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Free',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Pro',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
        // Feature rows
        _featureRow(context, 'Open any file type', true, true),
        _featureRow(context, 'PDF viewer', true, true),
        _featureRow(context, 'Image viewer', true, true),
        _featureRow(context, 'Text & Markdown viewer', true, true),
        _featureRow(context, 'Recent files history', false, true),
        _featureRow(context, 'Unlimited recent files', false, true),
        _featureRow(context, 'EPUB e-book reader', false, true),
        _featureRow(context, 'Office doc viewer (DOCX/XLSX)', false, true),
        _featureRow(context, 'PDF search', false, true),
        _featureRow(context, 'Text font customization', false, true),
        _featureRow(context, 'Bookmarks', false, true),
      ],
    );
  }

  TableRow _featureRow(
      BuildContext ctx, String label, bool free, bool pro) {
    final theme = Theme.of(ctx);
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom:
              BorderSide(color: theme.colorScheme.outline.withOpacity(0.5), width: 0.3),
        ),
      ),
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Text(label, style: theme.textTheme.bodySmall),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: _check(ctx, free),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: _check(ctx, pro),
        ),
      ],
    );
  }

  Widget _check(BuildContext ctx, bool enabled) {
    return Icon(
      enabled ? Icons.check : Icons.remove,
      size: 16,
      color: enabled
          ? Theme.of(ctx).colorScheme.onSurface
          : Theme.of(ctx).colorScheme.outline,
    );
  }
}

class _ProActiveView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified_outlined, size: 80),
            const SizedBox(height: 20),
            Text(
              'Pro Plan Active',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'You have lifetime access to all Pro features.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Feature {
  const _Feature(this.label, this.isPro);
  final String label;
  final bool isPro;
}
