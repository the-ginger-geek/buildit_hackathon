import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:dart_openai/dart_openai.dart';

class AskAI {
  static Future<String> askAI({
    required String openAIApiKey,
    required String projectDirectory,
    required String sentryAuthToken,
    required String sentryOrgSlug,
    required String sentryProjectSlug,
  }) async {
    final questionBuilder = OpenAIQuestionBuilder(
      directory: projectDirectory,
      orgSlug: sentryOrgSlug,
      projectSlug: sentryProjectSlug,
      authToken: sentryAuthToken,
    );

    final questionsList = await questionBuilder.buildQuestions();
    final openAIAsker = OpenAIClient(openAIApiKey);
    return await openAIAsker.ask(questionsList);
  }
}

class OpenAIQuestionBuilder {
  final Logger logger = Logger();
  final String directory;
  final String orgSlug;
  final String projectSlug;
  final String authToken;

  OpenAIQuestionBuilder({
    required this.directory,
    required this.orgSlug,
    required this.projectSlug,
    required this.authToken,
  });

  Future<List<OpenAIChatCompletionChoiceMessageModel>> buildQuestions() async {
    final prompts = [
      const OpenAIChatCompletionChoiceMessageModel(
          content:
              "You are a fault finding bot that interrogates issues from provided logs and you formulate fixs for the faults.",
          role: OpenAIChatMessageRole.system)
    ];
    final questions = ["Scan through the following code\n\n"];

    final files = Directory(directory)
        .listSync(recursive: true)
        .where((entity) => path.extension(entity.path) == ".dart");

    for (var file in files) {
      questions.add(await File(file.path).readAsString());
    }

    questions.add("\n\nScan through the following logs\n\n");
    final events = await getSentryEvents();
    final eventsStrings = [];
    if (events != null) {
      eventsStrings.add(events);
    }
    questions.add(eventsStrings.join(' '));

    questions.add(
        "\n\nLooking at the above, show me in the code where the issue might be coming from and show a code snippet with arrows (<<) pointing to the line of code that has the problem.");
    prompts.add(OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.user, content: questions.join(' ')));
    return prompts;
  }

  Future<String?> getSentryEvents() async {
    var url = "https://sentry.io/api/0/projects/$orgSlug/$projectSlug/events/";
    var headers = {'Authorization': 'Bearer $authToken'};

    try {
      logger.d('Connecting to sentry: $url');
      var response = await http.get(Uri.parse(url), headers: headers);
      return response.body;
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  String writeEventsToString(List<dynamic> events) {
    var output = StringBuffer();
    var fieldnames = ['eventID', 'dateCreated', 'message', 'tags'];
    output.writeln(fieldnames.join(','));

    for (var event in events) {
      var tags = Map.fromEntries((event['tags'] as List<dynamic>)
          .map((tag) => MapEntry(tag['key'], tag['value'])));
      output.writeln([
        event['eventID'],
        event['dateCreated'],
        event['message'],
        tags.toString(),
      ].join(','));
    }
    return output.toString();
  }
}

class OpenAIClient {
  final String apiKey;

  OpenAIClient(this.apiKey) {
    OpenAI.apiKey = apiKey;
  }

  Future<String> ask(List<OpenAIChatCompletionChoiceMessageModel> prompt,
      {int maxTokens = 60}) async {
    OpenAIChatCompletionModel completion = await OpenAI.instance.chat.create(
      messages: prompt,
      model: 'gpt-3.5-turbo',
    );

    return completion.choices.first.message.content;
  }
}
