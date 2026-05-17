import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.title,
    this.action,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final String? title;
  final Widget? action;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (title != null)
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(title!, style: text.titleMedium),
                  ),
                  if (action != null) action!,
                ],
              ),
            if (title != null) const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
