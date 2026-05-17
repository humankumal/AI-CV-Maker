import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/country_config.dart';
import '../../services/country_catalog.dart';
import '../../state/settings_notifier.dart';

class CountrySelectionScreen extends StatelessWidget {
  const CountrySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;
    final ColorScheme cs = Theme.of(context).colorScheme;
    final List<CountryConfig> countries = CountryCatalog.countries;
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a country')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        itemCount: countries.length + 1,
        separatorBuilder: (BuildContext _, int __) =>
            const SizedBox(height: 10),
        itemBuilder: (BuildContext context, int i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'Pick the country your CV is for. We tailor the layout, spelling, and section order.',
                style: t.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            );
          }
          final CountryConfig c = countries[i - 1];
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                context
                    .read<SettingsNotifier>()
                    .setDefaultCountry(c.code);
                context.push('/template?country=${c.code}');
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Text(c.flag, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${c.name} · ${c.docKind}',
                              style: t.titleMedium),
                          const SizedBox(height: 2),
                          Text(c.tagline,
                              style: t.bodySmall
                                  ?.copyWith(color: cs.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: cs.outline),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
