import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';

class AppViewModel extends ChangeNotifier {
  String? _selectedFilePath;
  String? _uploadedCsvFilePath;
  String? _apiKey;
  String? _authTokenSentry;
  String? _organisationSlug;
  String? _projectSlug;
  String? _result;

  bool _isLoading = false;

  String? get selectedFilePath => _selectedFilePath;
  String? get uploadedCsvFilePath => _uploadedCsvFilePath;
  bool get isBusy => _isLoading;
  String? get result => _result;

  set result(String? value) {
    _result = value;
    notifyListeners();
  }

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

  void updateApiKey(String value) {
    _apiKey = value;
    notifyListeners();
  }

  void updateAuthTokenSentry(String value) {
    _authTokenSentry = value;
    notifyListeners();
  }

  void updateOrganisationSlug(String value) {
    _organisationSlug = value;
    notifyListeners();
  }

  void updateProjectSlug(String value) {
    _projectSlug = value;
    notifyListeners();
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can not be empty';
    }
    return null;
  }

  void setIsBusy(bool isBusy) {
    _isLoading = isBusy;
    notifyListeners();
  }

  Future run(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setIsBusy(true);

    await Future.delayed(
      const Duration(seconds: 5),
    );
    _result = 'hello world';

    setIsBusy(false);
  }
}
