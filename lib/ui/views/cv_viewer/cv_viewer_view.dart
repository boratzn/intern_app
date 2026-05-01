import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';

import 'cv_viewer_viewmodel.dart';

class CvViewerView extends StackedView<CvViewerViewModel> {
  final String pdfPath;

  const CvViewerView({super.key, required this.pdfPath});

  @override
  Widget builder(
    BuildContext context,
    CvViewerViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CV Görüntüleyici',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: pdfPath.startsWith('http')
          ? SfPdfViewer.network(pdfPath)
          : SfPdfViewer.file(File(pdfPath)),
    );
  }

  @override
  CvViewerViewModel viewModelBuilder(BuildContext context) =>
      CvViewerViewModel(pdfPath);
}
