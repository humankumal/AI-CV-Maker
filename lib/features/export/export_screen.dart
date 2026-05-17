import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../models/country_config.dart';
import '../../models/cv_document.dart';
import '../../models/template_config.dart';
import '../../services/country_catalog.dart';
import '../../services/pdf_export_service.dart';
import '../../shared/widgets/empty_state.dart';
import '../../state/cv_editor_notifier.dart';
import '../../state/cv_list_notifier.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key, required this.cvId});
  final String cvId;

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  final PdfExportService _exporter = PdfExportService();

  @override
  Widget build(BuildContext context) {
    final CvDocument? doc =
        context.watch<CvEditorNotifier>().document?.id == widget.cvId
            ? context.watch<CvEditorNotifier>().document
            : context.watch<CvListNotifier>().find(widget.cvId);
    if (doc == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Export')),
        body: const EmptyState(
          icon: Icons.picture_as_pdf_outlined,
          title: 'CV not found',
          message: 'This CV no longer exists.',
        ),
      );
    }
    final CountryConfig country = CountryCatalog.countryFor(doc.countryCode);
    final TemplateConfig template =
        CountryCatalog.templateFor(doc.templateId);
    final String fileBase = doc.name.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
    return Scaffold(
      appBar: AppBar(title: const Text('Export PDF')),
      body: PdfPreview(
        build: (PdfPageFormat format) async {
          final pw.Document pdf = await _exporter.build(
            doc: doc,
            template: template,
            country: country,
          );
          return pdf.save();
        },
        canChangePageFormat: false,
        canDebug: false,
        pdfFileName: '$fileBase.pdf',
        allowPrinting: true,
        allowSharing: true,
        useActions: true,
      ),
    );
  }
}
