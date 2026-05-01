import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

class AiJobGeneratorViewModel extends BaseViewModel {
  final TextEditingController promptController = TextEditingController();

  String? generatedTitle;
  String? generatedDescription;
  List<String> generatedSkills = [];

  void generateJob() async {
    if (promptController.text.isEmpty) return;

    setBusy(true);
    // Simulate AI request to Node.js/Python backend
    await Future.delayed(const Duration(seconds: 3));

    generatedTitle = "Kıdemli Flutter Geliştirici";
    generatedDescription =
        "Yenilikçi projelerimizde görev alacak, state management (Riverpod/Stacked) konularına hakim, modern UI/UX prensiplerine uygun, temiz kod yazabilen takım arkadaşı arıyoruz.\n\nSorumluluklar:\n- Flutter ile cross-platform uygulama geliştirme\n- API entegrasyonları\n- Kod incelemelerine katılma";
    generatedSkills = ["Flutter", "Dart", "Firebase", "REST API", "Git"];

    setBusy(false);
  }
}
