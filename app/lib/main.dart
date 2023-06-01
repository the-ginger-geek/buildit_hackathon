import 'package:app/view_model/view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Build iT',
      home: Scaffold(
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildActionButtonRow(
                  context,
                  'Select File',
                  context.watch<AppViewModel>().selectFile,
                  context.watch<AppViewModel>().selectedFilePath),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildActionButton(
                    context, 'Run', context.watch<AppViewModel>().run),
              ),
            ],
          ),
        ),
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
