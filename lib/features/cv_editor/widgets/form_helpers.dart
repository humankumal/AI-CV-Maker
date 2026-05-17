import 'package:flutter/material.dart';

import '../../ai/ai_rewrite_sheet.dart';
import '../../../models/country_config.dart';
import '../../../services/ai_service.dart';

class LabeledTextField extends StatefulWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.hint,
    this.helper,
    this.errorText,
    this.multiline = false,
    this.aiKind,
    this.country,
    this.keyboardType,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final String? hint;
  final String? helper;
  final String? errorText;
  final bool multiline;
  final AiFieldKind? aiKind;
  final CountryConfig? country;
  final TextInputType? keyboardType;

  @override
  State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  late final TextEditingController _ctrl =
      TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(covariant LabeledTextField old) {
    super.didUpdateWidget(old);
    if (widget.value != _ctrl.text) {
      _ctrl.text = widget.value;
      _ctrl.selection =
          TextSelection.collapsed(offset: _ctrl.text.length);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: _ctrl,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType ??
            (widget.multiline ? TextInputType.multiline : TextInputType.text),
        minLines: widget.multiline ? 3 : 1,
        maxLines: widget.multiline ? 8 : 1,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          helperText: widget.helper,
          errorText: widget.errorText,
          suffixIcon: (widget.aiKind != null && widget.country != null)
              ? IconButton(
                  tooltip: 'Improve with AI',
                  icon: const Icon(Icons.auto_awesome_outlined),
                  onPressed: () async {
                    final String? rewritten = await showModalBottomSheet<String>(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      backgroundColor:
                          Theme.of(context).colorScheme.surface,
                      builder: (BuildContext _) => AiRewriteSheet(
                        original: _ctrl.text,
                        kind: widget.aiKind!,
                        country: widget.country!,
                      ),
                    );
                    if (rewritten != null) {
                      _ctrl.text = rewritten;
                      widget.onChanged(rewritten);
                    }
                  },
                )
              : null,
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
