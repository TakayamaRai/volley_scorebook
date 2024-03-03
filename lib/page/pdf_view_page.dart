import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:volley_scorebook/utils/Grobal.dart';

class PdfViewerPage extends StatelessWidget {
  final String path;
  const PdfViewerPage({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return PDFViewerScaffold(
      appBar:AppBar(
        centerTitle: true,
        title: Text((languageJa) ? '試合結果' : 'Match result'),
      ),
      path: path,
    );
  }
}