import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user_profile.dart';
import '../../../state/cv_editor_notifier.dart';
import '../widgets/form_helpers.dart';

class BasicsSection extends StatelessWidget {
  const BasicsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final CvEditorNotifier ed = context.watch<CvEditorNotifier>();
    final UserProfile p = ed.document!.profile;
    void update(UserProfile next) => ed.setProfile(next);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionTitle('Contact details'),
        LabeledTextField(
          label: 'Full name',
          value: p.fullName,
          onChanged: (String v) => update(p.copyWith(fullName: v)),
          hint: 'e.g. Alex Morgan',
        ),
        LabeledTextField(
          label: 'Headline',
          value: p.headline,
          onChanged: (String v) => update(p.copyWith(headline: v)),
          hint: 'e.g. Senior Product Designer',
          helper: 'One short line under your name. Optional.',
        ),
        LabeledTextField(
          label: 'Email',
          value: p.email,
          onChanged: (String v) => update(p.copyWith(email: v)),
          keyboardType: TextInputType.emailAddress,
        ),
        LabeledTextField(
          label: 'Phone',
          value: p.phone,
          onChanged: (String v) => update(p.copyWith(phone: v)),
          keyboardType: TextInputType.phone,
        ),
        LabeledTextField(
          label: 'Location',
          value: p.location,
          onChanged: (String v) => update(p.copyWith(location: v)),
          hint: 'City, Country',
        ),
        LabeledTextField(
          label: 'LinkedIn (optional)',
          value: p.linkedIn,
          onChanged: (String v) => update(p.copyWith(linkedIn: v)),
        ),
        LabeledTextField(
          label: 'Website / Portfolio (optional)',
          value: p.website,
          onChanged: (String v) => update(p.copyWith(website: v)),
        ),
      ],
    );
  }
}
