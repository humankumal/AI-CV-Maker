import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../shared/widgets/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;
    final ColorScheme cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  tooltip: 'Settings',
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => context.push('/settings'),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(Icons.description_outlined,
                    size: 32, color: cs.onPrimaryContainer),
              ),
              const SizedBox(height: 28),
              Text(AppConstants.appName,
                  style: t.displaySmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(AppConstants.tagline,
                  style: t.bodyLarge?.copyWith(color: cs.onSurfaceVariant)),
              const Spacer(),
              PrimaryButton(
                label: 'Create new CV',
                icon: Icons.add,
                expanded: true,
                onPressed: () => context.push('/country'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => context.push('/saved'),
                icon: const Icon(Icons.folder_outlined),
                label: const Text('My saved CVs'),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
