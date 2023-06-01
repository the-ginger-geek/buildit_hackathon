import 'package:app/view_model/view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppViewModel(),
      child: MaterialApp(
        title: 'Build iT',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Build iT'),
          ),
          body: Column(
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => context.read<AppViewModel>().selectFile(),
                    child: const Text('Select File'),
                  ),
                  const Spacer(),
                  Consumer<AppViewModel>(
                    builder: (_, viewModel, __) =>
                        Text(viewModel.selectedFilePath ?? ''),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        context.read<AppViewModel>().uploadCsvFile(),
                    child: const Text('Upload CSV'),
                  ),
                  const Spacer(),
                  Consumer<AppViewModel>(
                    builder: (_, viewModel, __) =>
                        Text(viewModel.uploadedCsvFilePath ?? ''),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => context.read<AppViewModel>().run(),
                child: const Text('Run'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
