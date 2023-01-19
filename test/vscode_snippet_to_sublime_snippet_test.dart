import 'dart:io';

import 'package:test/test.dart';
import 'package:vscode_snippet_to_sublime_snippet/vscode_snippet_to_sublime_snippet.dart';

void main() {
  const String prefix = "debugP";
  const String body = '''debugPrint(\${1:statement});''';
  const String description =
      "Prints a message to the console, which you can access using the flutter tool's `logs` command (flutter logs).";

  Snippet snippet = Snippet(prefix, body, description);

  test('snippet', () {
    expect(snippet.getBody(), body);
  });

  final String outputTemplate = '''<snippet>
  <content><![CDATA[
$body
]]></content>
  <!-- Optional: Set a tabTrigger to define how to trigger the snippet -->
  <tabTrigger>$prefix</tabTrigger>
  <!-- Optional: Set a scope to limit where the snippet will trigger -->
  <scope>source.dart</scope>
  <description>$description</description>
</snippet>
''';

  test('replaceTemplateVars', () {
    final String output = replaceTemplateVars(snippet, 'source.dart');

    expect(output, outputTemplate);
  });

  // create a temporary folder to save the files to
  test('createSnippetFile', () async {
    Directory tmp = await Directory.systemTemp.createTemp('file_test_create');

    expect(await tmp.exists(), true);

    String tmpPath = "${tmp.path}/snippets";

    final outPath = await createSnippetFile('test', outputTemplate, tmpPath);

    expect(outPath, '$tmpPath/test.sublime-snippet');

    expect(await File(outPath).exists(), true);

    await tmp.delete(recursive: true);
  });
}
