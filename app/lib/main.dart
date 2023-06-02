import 'package:app/view_model/view_model.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
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
  final appTitle = 'Welcome to bug Finder 5000';

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: FlexThemeData.light(
        scheme: FlexScheme.mandyRed,
        blendLevel: 2,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 6,
          blendOnColors: false,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        swapLegacyOnMaterial3: true,
      ),
      home: Consumer<AppViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: AnimatedCrossFade(
              firstChild: _buildProgress(context),
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
      child: Center(
        child: SizedBox(
          width: 800,
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              SizedBox(
                width: 800,
                child: Text(
                  'Step 1: Input your project details',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
              const SizedBox(height: 16.0),
              _inputField(context),
              const SizedBox(height: 8.0),
              TextFormField(
                onChanged: (value) =>
                    context.read<AppViewModel>().updateAuthTokenSentry(value),
                validator: context.read<AppViewModel>().validateNotEmpty,
                decoration: const InputDecoration(
                  hintText: 'Sentry Auth Token',
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                onChanged: (value) =>
                    context.read<AppViewModel>().updateOrganisationSlug(value),
                validator: context.read<AppViewModel>().validateNotEmpty,
                decoration: const InputDecoration(
                  hintText: 'Sentry Organisation Slug',
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                onChanged: (value) =>
                    context.read<AppViewModel>().updateProjectSlug(value),
                validator: context.read<AppViewModel>().validateNotEmpty,
                decoration: const InputDecoration(
                  hintText: 'Sentry Project Slug',
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
              const SizedBox(height: 16),
              Text(
                'Step 3: Be amazed!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Here are some suggested fixes to your application errors',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: viewModel.resetResult,
                        child: const Text('Search again'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.black,),
              const SizedBox(height: 16),
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
                        height: 1.5,
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
            ],
          ),
        ),
      ),
    );
  }

  Center _buildProgress(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 285.0,
        height: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Step 2: Have some coffee...',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8.0),
            Container(
              width: 285.0,
              height: 200,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: const RiveAnimation.asset(
                'assets/cup_loader.riv',
                fit: BoxFit.fitWidth,
                antialiasing: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _inputField(BuildContext context) {
    return TextFormField(
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
      title: Text(appTitle),
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
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(buttonText),
    );
  }
}
