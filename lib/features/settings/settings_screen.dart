import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants.dart';
import '../../state/settings_notifier.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsNotifier s = context.watch<SettingsNotifier>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: <Widget>[
          _Section(
            title: 'Appearance',
            child: Column(
              children: <Widget>[
                RadioListTile<ThemeMode>(
                  groupValue: s.themeMode,
                  value: ThemeMode.system,
                  title: const Text('System default'),
                  onChanged: (ThemeMode? m) =>
                      s.setThemeMode(m ?? ThemeMode.system),
                ),
                RadioListTile<ThemeMode>(
                  groupValue: s.themeMode,
                  value: ThemeMode.light,
                  title: const Text('Light'),
                  onChanged: (ThemeMode? m) =>
                      s.setThemeMode(m ?? ThemeMode.light),
                ),
                RadioListTile<ThemeMode>(
                  groupValue: s.themeMode,
                  value: ThemeMode.dark,
                  title: const Text('Dark'),
                  onChanged: (ThemeMode? m) =>
                      s.setThemeMode(m ?? ThemeMode.dark),
                ),
              ],
            ),
          ),
          _Section(
            title: 'AI',
            child: ListTile(
              leading: const Icon(Icons.key_outlined),
              title: const Text('Google Gemini API key'),
              subtitle: Text(
                s.hasGeminiKey
                    ? 'Configured · ${s.geminiKeyMasked}'
                    : 'Not set — AI features will be unavailable.',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _editApiKeyDialog(context, s),
            ),
          ),
          _Section(
            title: 'About',
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text(AppConstants.appName),
                  subtitle: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (BuildContext ctx,
                        AsyncSnapshot<PackageInfo> snap) {
                      final PackageInfo? p = snap.data;
                      return Text(p == null
                          ? 'Version 1.0.0'
                          : 'Version ${p.version}+${p.buildNumber}');
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy policy'),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () => _openUrl(
                      'https://github.com/humankumal/ai-cv-maker/blob/main/PRIVACY.md'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _editApiKeyDialog(
      BuildContext context, SettingsNotifier s) async {
    final TextEditingController c = TextEditingController();
    bool obscure = true;
    final String? next = await showDialog<String>(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (BuildContext ctx, void Function(void Function()) setS) {
            return AlertDialog(
              title: const Text('Gemini API key'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Get a free key at https://aistudio.google.com/apikey.\n'
                    'Your key is stored only on this device.',
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: c,
                    obscureText: obscure,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'API key',
                      suffixIcon: IconButton(
                        icon: Icon(obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () => setS(() => obscure = !obscure),
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(ctx, '__remove__'),
                  child: const Text('Remove'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, c.text.trim()),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
    if (next == null) return;
    if (next == '__remove__') {
      await s.setGeminiKey(null);
    } else if (next.isNotEmpty) {
      await s.setGeminiKey(next);
    }
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
            child: Text(title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
          ),
          Card(child: child),
        ],
      ),
    );
  }
}
