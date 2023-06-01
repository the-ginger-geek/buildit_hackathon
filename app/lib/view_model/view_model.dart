import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';

import '../api/ask_ai.dart';

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
    String? path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      _selectedFilePath = path;
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

  // Future run(GlobalKey<FormState> formKey) async {
  //   if (!formKey.currentState!.validate()) {
  //     return;
  //   }

  //   setIsBusy(true);

  //   await Future.delayed(
  //     const Duration(seconds: 5),
  //   );
  //   _result = 'hello world';

  //   setIsBusy(false);
  // }

  Future<void> run(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setIsBusy(true);

    var apiKey = _apiKey ?? '';
    // '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';
    var directory = _selectedFilePath ?? '';
    var sentryAuthToken = _authTokenSentry ?? '';
    // '7cee24623fb54366a02ec551d480ed32852178a7e39f43a490384cb72571eb65';
    var orgSlug = _organisationSlug ?? '';
    // 'build-it-xb';
    var projectSlug = _projectSlug ?? '';
    // 'flutter';
    _result = await AskAI.askAI(
      openAIApiKey: apiKey,
      projectDirectory: directory,
      sentryAuthToken: sentryAuthToken,
      sentryOrgSlug: orgSlug,
      sentryProjectSlug: projectSlug,
    );
    Logger().d(result);

    setIsBusy(false);
  }
}
