import 'package:app/api/ask_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';

class AppViewModel extends ChangeNotifier {
  String? _selectedFilePath;
  String? _uploadedCsvFilePath;

  String? get selectedFilePath => _selectedFilePath;
  String? get uploadedCsvFilePath => _uploadedCsvFilePath;

  Future<void> selectFile() async {
    String? path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      _selectedFilePath = path;
      notifyListeners();
    }
  }

  void run() async {
    var apiKey = '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';
    var directory = _selectedFilePath ?? '';
    var sentryAuthToken =
        '7cee24623fb54366a02ec551d480ed32852178a7e39f43a490384cb72571eb65';
    var orgSlug = 'build-it-xb';
    var projectSlug = 'flutter';

    final result = await AskAI.askAI(
      openAIApiKey: apiKey,
      projectDirectory: directory,
      sentryAuthToken: sentryAuthToken,
      sentryOrgSlug: orgSlug,
      sentryProjectSlug: projectSlug,
    );

    Logger().d(result);
  }
}
