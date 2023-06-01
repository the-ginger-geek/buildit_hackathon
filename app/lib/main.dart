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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Build iT',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[900],
          title: const Text('Build iT'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.orange[900],
                        ),
                      ),
                      onPressed: () =>
                          context.read<AppViewModel>().selectFile(),
                      child: const Text('Select File'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Consumer<AppViewModel>(
                    builder: (context, viewModel, child) {
                      return Expanded(
                        child: Text(
                          viewModel.selectedFilePath ?? '',
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.orange[900],
                        ),
                      ),
                      onPressed: () =>
                          context.read<AppViewModel>().uploadCsvFile(),
                      child: const Text('Upload CSV'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Consumer<AppViewModel>(
                    builder: (context, viewModel, child) => Expanded(
                      child: Text(
                        viewModel.uploadedCsvFilePath ?? '',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.orange[900],
                      ),
                    ),
                    onPressed: () => context.read<AppViewModel>().run(),
                    child: const Text('Run'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
