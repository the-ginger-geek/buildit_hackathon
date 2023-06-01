import 'package:app/view_model/view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Build iT',
      home: Consumer<AppViewModel>(
        // Consumer listens to changes in AppViewModel
        builder: (context, viewModel, _) {
          if (viewModel.isBusy) {
            // Show progress bar if isLoading is true
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (viewModel.result != null) {
            // If result is not null, show a dialog
            Future.microtask(() {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Result'),
                    content: Text(viewModel.result ?? ''),
                    actions: [
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          viewModel.result = null;
                        },
                      ),
                    ],
                  );
                },
              ); // reset result after showing
            });
          }

          return Scaffold(
            appBar: _buildAppBar(),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _inputField(context),
                    TextFormField(
                      onChanged: (value) => context
                          .read<AppViewModel>()
                          .updateAuthTokenSentry(value),
                      validator: context.read<AppViewModel>().validateNotEmpty,
                      decoration: const InputDecoration(
                        hintText: 'Auth Token Sentry',
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) => context
                          .read<AppViewModel>()
                          .updateOrganisationSlug(value),
                      validator: context.read<AppViewModel>().validateNotEmpty,
                      decoration: const InputDecoration(
                        hintText: 'Organisation Slug',
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) =>
                          context.read<AppViewModel>().updateProjectSlug(value),
                      validator: context.read<AppViewModel>().validateNotEmpty,
                      decoration: const InputDecoration(
                        hintText: 'Project Slug',
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    _buildActionButtonRow(
                        context,
                        'Select File',
                        context.watch<AppViewModel>().selectFile,
                        context.watch<AppViewModel>().selectedFilePath),
                    const SizedBox(height: 15),
                    _buildActionButtonRow(
                        context,
                        'Upload CSV',
                        context.watch<AppViewModel>().uploadCsvFile,
                        context.watch<AppViewModel>().uploadedCsvFilePath),
                    const SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildActionButton(
                        context,
                        'Run',
                        () {
                          Provider.of<AppViewModel>(context, listen: false)
                              .run(_formKey);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Rest of your methods...
}

// return MaterialApp(
//   title: 'Build iT',
//   home: Scaffold(
//     appBar: _buildAppBar(),
//     body: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Form(
//         key: _formKey,
//         child: context.read<AppViewModel>().isBusy
//             ? const CircularProgressIndicator()
//             : Column(
//                 children: [
//                   _inputField(context),
//                   TextFormField(
//                     onChanged: (value) => context
//                         .read<AppViewModel>()
//                         .updateAuthTokenSentry(value),
//                     validator:
//                         context.read<AppViewModel>().validateNotEmpty,
//                     decoration: const InputDecoration(
//                       hintText: 'Auth Token Sentry',
//                     ),
//                   ),
//                   TextFormField(
//                     onChanged: (value) => context
//                         .read<AppViewModel>()
//                         .updateOrganisationSlug(value),
//                     validator:
//                         context.read<AppViewModel>().validateNotEmpty,
//                     decoration: const InputDecoration(
//                       hintText: 'Organisation Slug',
//                     ),
//                   ),
//                   TextFormField(
//                     onChanged: (value) => context
//                         .read<AppViewModel>()
//                         .updateProjectSlug(value),
//                     validator:
//                         context.read<AppViewModel>().validateNotEmpty,
//                     decoration: const InputDecoration(
//                       hintText: 'Project Slug',
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   _buildActionButtonRow(
//                       context,
//                       'Select File',
//                       context.watch<AppViewModel>().selectFile,
//                       context.watch<AppViewModel>().selectedFilePath),
//                   const SizedBox(height: 15),
//                   _buildActionButtonRow(
//                       context,
//                       'Upload CSV',
//                       context.watch<AppViewModel>().uploadCsvFile,
//                       context.watch<AppViewModel>().uploadedCsvFilePath),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: _buildActionButton(
//                       context,
//                       'Run',
//                       () {
//                         Provider.of<AppViewModel>(context, listen: false)
//                             .run(_formKey);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     ),
//   ),
// );

TextFormField _inputField(BuildContext context) {
  return TextFormField(
    onChanged: (value) => context.read<AppViewModel>().updateApiKey(value),
    validator: context.read<AppViewModel>().validateNotEmpty,
    decoration: const InputDecoration(
      hintText: 'API Key',
    ),
  );
}

AppBar _buildAppBar() {
  return AppBar(
    backgroundColor: Colors.orange[900],
    title: const Text('Build iT'),
  );
}

Widget _buildActionButtonRow(BuildContext context, String buttonText,
    Function() onPressed, String? filePath) {
  return Row(
    children: [
      _buildActionButton(context, buttonText, onPressed),
      const SizedBox(width: 20),
      Expanded(
        child: Text(
          filePath ?? '',
        ),
      ),
    ],
  );
}

Widget _buildActionButton(
    BuildContext context, String buttonText, Function() onPressed) {
  return SizedBox(
    width: 200,
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.orange[900],
        ),
      ),
      onPressed: onPressed,
      child: Text(buttonText),
    ),
  );
}
