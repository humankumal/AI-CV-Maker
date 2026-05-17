import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Two-column compact month/year date range field with an optional
/// "I currently work/study here" toggle.
class DateRangeField extends StatelessWidget {
  const DateRangeField({
    super.key,
    required this.start,
    required this.end,
    required this.current,
    required this.onStartChanged,
    required this.onEndChanged,
    required this.onCurrentChanged,
    this.currentLabel = 'I currently work here',
    this.showCurrentToggle = true,
  });

  final String start;
  final String end;
  final bool current;
  final ValueChanged<String> onStartChanged;
  final ValueChanged<String> onEndChanged;
  final ValueChanged<bool> onCurrentChanged;
  final String currentLabel;
  final bool showCurrentToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(children: <Widget>[
          Expanded(
            child: _MonthYearField(
              label: 'Start',
              value: start,
              onChanged: onStartChanged,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _MonthYearField(
              label: 'End',
              value: current ? '' : end,
              enabled: !current,
              hint: current ? 'Present' : null,
              onChanged: onEndChanged,
            ),
          ),
        ]),
        if (showCurrentToggle)
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: current,
            onChanged: onCurrentChanged,
            title: Text(currentLabel),
          ),
      ],
    );
  }
}

class _MonthYearField extends StatelessWidget {
  const _MonthYearField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.hint,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => _pick(context) : null,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint ?? 'MMM YYYY',
          enabled: enabled,
          suffixIcon: const Icon(Icons.calendar_month_outlined, size: 18),
        ),
        child: Text(
          value.isEmpty ? (hint ?? ' ') : value,
          style: TextStyle(
            color: value.isEmpty
                ? Theme.of(context).hintColor
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initial = _parse(value) ?? now;
    final DateTime first = DateTime(1970);
    final DateTime last = DateTime(now.year + 5);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Select $label date',
      fieldHintText: 'MM/YYYY',
    );
    if (picked == null) return;
    onChanged(DateFormat('MMM yyyy').format(picked));
  }

  DateTime? _parse(String v) {
    if (v.trim().isEmpty) return null;
    try {
      return DateFormat('MMM yyyy').parseStrict(v.trim());
    } catch (_) {/* fall through */}
    try {
      return DateFormat('yyyy').parseStrict(v.trim());
    } catch (_) {/* fall through */}
    return null;
  }
}
