import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AppViewModel extends ChangeNotifier {
  String? _selectedFilePath;
  String? _uploadedCsvFilePath;

  String? get selectedFilePath => _selectedFilePath;
  String? get uploadedCsvFilePath => _uploadedCsvFilePath;

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      _selectedFilePath = result.files.single.path;
      notifyListeners();
    }
  }

  Future<void> uploadCsvFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
    if (result != null) {
      _uploadedCsvFilePath = result.files.single.path;
      notifyListeners();
    }
  }

  void run() async {
    var apiKey = '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';
    var directory = _selectedFilePath ?? '';
    var sentryAuthToken = '7cee24623fb54366a02ec551d480ed32852178a7e39f43a490384cb72571eb65';
    var orgSlug = 'build-it-xb';
    var projectSlug = 'flutter';

    var process = await Process.run('python', [
      'mypythonscript.py',
      '--api_key',
      apiKey,
      '--directory',
      directory,
      '--sentry_auth_token',
      sentryAuthToken,
      '--org_slug',
      orgSlug,
      '--project_slug',
      projectSlug,
    ]);

    print('Process exited with ${process.exitCode}');
    print('stdout: ${process.stdout}');
    print('stderr: ${process.stderr}');
  }
}
