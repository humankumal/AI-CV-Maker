import 'package:flutter/material.dart';

import '../../models/country_config.dart';
import '../../models/cv_document.dart';
import '../../models/education_entry.dart';
import '../../models/skill_item.dart';
import '../../models/template_config.dart';
import '../../models/user_profile.dart';
import '../../models/work_experience.dart';
import '../../services/country_catalog.dart';
import '../preview/cv_renderer.dart';

/// Small selectable card showing a tiny preview of the template.
class TemplateCard extends StatelessWidget {
  const TemplateCard({
    super.key,
    required this.template,
    required this.selected,
    required this.onTap,
  });

  final TemplateConfig template;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final CountryConfig country =
        CountryCatalog.countryFor(template.countryCode);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          width: selected ? 2 : 0.6,
          color: selected ? cs.primary : cs.outlineVariant,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.72,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15)),
                child: ColoredBox(
                  color: cs.surfaceContainerLow,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 380,
                      height: 540,
                      child: CvRenderer(
                        document: _sample(template, country),
                        template: template,
                        country: country,
                        scale: 0.75,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(template.name,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    template.archetype.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  CvDocument _sample(TemplateConfig t, CountryConfig c) {
    return CvDocument(
      countryCode: c.code,
      templateId: t.id,
      name: 'Sample',
      profile: const UserProfile(
        fullName: 'Alex Morgan',
        headline: 'Senior Product Designer',
        email: 'alex.morgan@example.com',
        phone: '+44 7700 900123',
        location: 'London, UK',
        summary:
            'Product designer with 8 years of experience leading user-centred design '
            'for SaaS products. Comfortable across research, prototyping, and shipping.',
      ),
      experience: <WorkExperience>[
        WorkExperience(
          jobTitle: 'Senior Product Designer',
          company: 'Northwind',
          location: 'Remote',
          startDate: 'Jan 2022',
          endDate: '',
          current: true,
          bullets: <String>[
            'Led the redesign of the onboarding flow, improving activation by 24%.',
            'Mentored four junior designers and ran weekly critique sessions.',
          ],
        ),
        WorkExperience(
          jobTitle: 'Product Designer',
          company: 'Bramble',
          location: 'London',
          startDate: 'Sep 2018',
          endDate: 'Dec 2021',
          bullets: <String>[
            'Shipped the v3 dashboard used by 40k weekly active users.',
            'Established the first design system for the product suite.',
          ],
        ),
      ],
      education: <EducationEntry>[
        EducationEntry(
          degree: 'BA in Graphic Communication',
          institution: 'University of Reading',
          startDate: '2014',
          endDate: '2017',
          gradeOrGpa: 'First Class',
        ),
      ],
      skills: <SkillItem>[
        SkillItem(name: 'Figma'),
        SkillItem(name: 'Design Systems'),
        SkillItem(name: 'Prototyping'),
        SkillItem(name: 'User Research'),
        SkillItem(name: 'Accessibility'),
      ],
    );
  }
}
