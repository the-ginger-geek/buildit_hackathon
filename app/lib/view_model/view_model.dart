import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';

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

  void run() {
    // Implement your 'run' logic here.
  }
}
