VSCode Snippet to Sublime Text 3 Snippet converter
==================================================

A small CLI tool to convert VSCode Snippet files into Sublime Text 3 snippets.

<small><i>This was made as a way to learn [Dart](https://dart.dev/)</i></small>

### Downloading binaries

The executables are attached to the Action results in the artifacts list after every push.

### Building

Note: The compiler can create machine code **only for the operating system on which you’re compiling**. To create executables for macOS, Windows, and Linux, you need to run the compiler three times. Or download the executables that are attached to the Action results in the artifacts list after every push.

```sh
dart compile exe bin/vscode_snippet_to_sublime_snippet.dart -o converter
```

### Running

```sh
./converter snippet_file_from_vscode.json source.dart
```

### Development

```sh
dart pub get
dart run bin/vscode_snippet_to_sublime_snippet.dart snippet_file_from_vscode.json source.dart
```

### Testing

```sh
dart test
```

### Preparing for build

```sh
dart format bin/vscode_snippet_to_sublime_snippet.dart
dart format lib/vscode_snippet_to_sublime_snippet.dart
dart analyze
dart fix --apply
dart test
```
