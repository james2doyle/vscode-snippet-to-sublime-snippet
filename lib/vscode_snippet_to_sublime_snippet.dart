import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:slugify_string/slugify_string.dart';

/// The template that is used to make sublime snippets
const String template = '''<snippet>
  <content><![CDATA[
__content__
]]></content>
  <!-- Optional: Set a tabTrigger to define how to trigger the snippet -->
  <tabTrigger>__tabtrigger__</tabTrigger>
  <!-- Optional: Set a scope to limit where the snippet will trigger -->
  <scope>__scope__</scope>
  <description>__description__</description>
</snippet>
''';

/// The snippet represented as a class
class Snippet {
  final String prefix;
  final dynamic body;
  final String description;

  Snippet(this.prefix, this.body, this.description);

  /// return the body as a formatted string
  String getBody() {
    return body is List ? body.join("\n") : body;
  }
}

/// Take the snippet and replace the values in the template
String replaceTemplateVars(Snippet snippet, String source) {
  return template
      .replaceFirst("__content__", snippet.getBody())
      .replaceFirst("__tabtrigger__", snippet.prefix)
      .replaceFirst("__scope__", source)
      .replaceFirst("__description__", snippet.description);
}

/// Takes the JSON data and maps it to Snippet classes
Map<String, Snippet> parseJsonToSnippet(String snippetContent) {
  const JsonDecoder decoder = JsonDecoder();
  final Map<String, dynamic> mappedSnippets = decoder.convert(snippetContent);

  final Map<String, Snippet> snippets = mappedSnippets.map((key, value) =>
      MapEntry(
          key, Snippet(value['prefix'], value['body'], value['description'])));

  return snippets;
}

/// Take the template string and write it to the output file returning the path of that new file
Future<String> createSnippetFile(String filename, String content,
    [String targetFolder = '']) async {
  String slug = Slugify(filename);
  var path = targetFolder.isEmpty
      ? p.join(p.current, 'snippets/$slug.sublime-snippet')
      : '$targetFolder/$slug.sublime-snippet';

  var file = await File(path).create(recursive: true);

  await file.writeAsString(content);

  return path;
}
