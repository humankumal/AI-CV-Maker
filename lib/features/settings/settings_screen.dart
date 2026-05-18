import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants.dart';
import '../../state/pro_notifier.dart';
import '../../state/settings_notifier.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const _SettingsBody(),
    );
  }
}

class _SettingsBody extends StatefulWidget {
  const _SettingsBody();

  @override
  State<_SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<_SettingsBody> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _version = info.version);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsNotifier>();
    final pro = context.watch<ProNotifier>();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _Section(title: 'Appearance'),
        _ThemeTile(
          current: settings.themeMode,
          onChange: settings.setThemeMode,
        ),
        const Divider(height: 1),
        _Section(title: 'Pro Plan'),
        if (pro.isPro)
          const ListTile(
            leading: Icon(Icons.verified_outlined),
            title: Text('Pro Plan Active'),
            subtitle: Text('Lifetime access — no subscription'),
          )
        else
          ListTile(
            leading: const Icon(Icons.workspace_premium_outlined),
            title: const Text('Upgrade to Pro'),
            subtitle: const Text('\$0.99 one-time · Unlock all features'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/pro'),
          ),
        ListTile(
          leading: const Icon(Icons.restore),
          title: const Text('Restore Purchase'),
          onTap: () async {
            await pro.restore();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Checking for previous purchases...')),
              );
            }
          },
        ),
        const Divider(height: 1),
        _Section(title: 'About'),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(AppConstants.appName),
          subtitle: Text(_version.isEmpty ? 'Loading...' : 'v$_version'),
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.open_in_new, size: 16),
          onTap: () => launchUrl(
            Uri.parse('https://example.com/privacy'),
            mode: LaunchMode.externalApplication,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.library_books_outlined),
          title: const Text('Open Source Licenses'),
          onTap: () => showLicensePage(
            context: context,
            applicationName: AppConstants.appName,
            applicationVersion: _version,
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({required this.current, required this.onChange});
  final ThemeMode current;
  final ValueChanged<ThemeMode> onChange;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        current == ThemeMode.dark
            ? Icons.dark_mode_outlined
            : Icons.light_mode_outlined,
      ),
      title: const Text('Theme'),
      trailing: DropdownButton<ThemeMode>(
        value: current,
        underline: const SizedBox.shrink(),
        onChanged: (v) {
          if (v != null) onChange(v);
        },
        items: const [
          DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
          DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
          DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
        ],
      ),
    );
  }
}
