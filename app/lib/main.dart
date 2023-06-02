import 'package:app/view_model/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

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
      title: 'Build iT - Bug Finder 5000',
      home: Consumer<AppViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: _buildAppBar(),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: (viewModel.isBusy)
                  ? _buildProgress()
                  : _buildForm(context, viewModel),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, AppViewModel viewModel) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _inputField(context),
            TextFormField(
              initialValue:
                  '7cee24623fb54366a02ec551d480ed32852178a7e39f43a490384cb72571eb65',
              onChanged: (value) =>
                  context.read<AppViewModel>().updateAuthTokenSentry(value),
              validator: context.read<AppViewModel>().validateNotEmpty,
              decoration: const InputDecoration(
                hintText: 'Sentry Auth Token',
              ),
            ),
            TextFormField(
              initialValue: 'build-it-xb',
              onChanged: (value) =>
                  context.read<AppViewModel>().updateOrganisationSlug(value),
              validator: context.read<AppViewModel>().validateNotEmpty,
              decoration: const InputDecoration(
                hintText: 'Org Slug',
              ),
            ),
            TextFormField(
              initialValue: 'flutter',
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
                'Select Project Directory',
                context.watch<AppViewModel>().selectFile,
                context.watch<AppViewModel>().selectedFilePath),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: _buildActionButton(
                context,
                'Find Bugs',
                () {
                  Provider.of<AppViewModel>(context, listen: false).run(_formKey);
                },
              ),
            ),
            if (viewModel.result != null) ...[
              const SizedBox(height: 32),
              MarkdownBody(
                data: viewModel.result ?? '',
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: viewModel.resetResult,
                child: const Text('Close'),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Center _buildProgress() {
    return Center(
      child: Container(
        width: 85.0,
        height: 85.0,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: const RiveAnimation.asset('assets/search_icon.riv'),
      ),
    );
  }

  TextFormField _inputField(BuildContext context) {
    return TextFormField(
      initialValue: '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',
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
}
