import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'package:vscode_snippet_to_sublime_snippet/vscode_snippet_to_sublime_snippet.dart';

const String helpInfo = '''
A CLI tool to convert VSCode Snippet files into Sublime Text 3 snippets.

Usage: converter snippets.json source.dart

-h, --help                                 Print this usage information.
''';

void main(List<String> arguments) async {
  var parser = ArgParser();

  parser.addFlag('help', abbr: 'h', defaultsTo: false);

  var results = parser.parse(arguments);

  if (arguments.isEmpty ||
      results.rest.isEmpty ||
      results['help'] != null ||
      results['help']) {
    print(helpInfo);

    return;
  }

  if (arguments[0].isEmpty) {
    throw Exception(
        'The first argument needs to be the snippets file you are converting.');
  }

  if (arguments[1].isEmpty) {
    throw Exception(
        'The second argument needs to be the scope to use for these snippets.');
  }

  late String path = p.normalize(arguments[0]);

  late File myFile = File(path);
  String snippetContent = await myFile.readAsString();

  if (snippetContent.isEmpty) {
    throw Exception('The snippets file is empty.');
  }

  Map<String, Snippet> snippets = parseJsonToSnippet(snippetContent);

  if (snippets.isEmpty) {
    throw Exception('The snippets file is empty.');
  }

  late String source = arguments[1];

  snippets.forEach((key, snippet) async {
    final newBody = replaceTemplateVars(snippet, source);

    final outpath = await createSnippetFile(key, newBody);

    print('Wrote out snippet file for: $outpath');
  });
}
