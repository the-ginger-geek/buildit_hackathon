import 'package:app/view_model/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
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
  final appTitle = 'Build iT - Bug Finder 5000';

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: Consumer<AppViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: _buildAppBar(context),
            body: AnimatedCrossFade(
              firstChild: _buildProgress(),
              secondChild: _buildForm(context, viewModel),
              crossFadeState: viewModel.isBusy
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 500),
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
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 500),
          firstChild: _buildInputState(context),
          secondChild: _buildOutputState(context, viewModel),
          crossFadeState: viewModel.result == null
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
        ),
      ),
    );
  }

  Widget _buildInputState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 16.0,
      ),
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
            context.watch<AppViewModel>().selectedFilePath,
          ),
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
        ],
      ),
    );
  }

  Widget _buildOutputState(BuildContext context, AppViewModel viewModel) {
    const textColor = Colors.black;
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 16.0,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              MarkdownBody(
                data: viewModel.result ?? '',
                selectable: true,
                extensionSet: md.ExtensionSet(
                  md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                  [
                    md.EmojiSyntax(),
                    ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                  ],
                ),
                styleSheet:
                    MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  a: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: textColor),
                  p: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: textColor),
                  listBullet: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: textColor),
                  code: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontFamily: "monospace",
                        backgroundColor: Colors.black,

                      ),
                  codeblockPadding: const EdgeInsets.all(25.0),
                  codeblockDecoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  h1: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: textColor),
                  h2: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: textColor),
                  h3: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: textColor),
                  h4: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: textColor),
                  h5: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: textColor),
                  h6: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: textColor),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: viewModel.resetResult,
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center _buildProgress() {
    return Center(
      child: Container(
        width: 285.0,
        height: 285.0,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: const RiveAnimation.asset('assets/chicken.riv',
            fit: BoxFit.contain),
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.grey.shade50,
      title: Text(appTitle,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.blueGrey)),
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
      child: MaterialButton(
        color: Colors.tealAccent,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 3.0,
        onPressed: onPressed,
        child: Text(buttonText),
      ),
    );
  }
}
