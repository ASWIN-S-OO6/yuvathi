import 'dart:io';
import 'package:path/path.dart' as path;

void main() async {
  final projectDir = Directory.current;
  await processDirectory(projectDir);
  print('Replacement complete!');
}

Future<void> processDirectory(Directory dir) async {
  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      await processFile(entity);
    }
  }
}

Future<void> processFile(File file) async {
  final content = await file.readAsString();
  final lines = content.split('\n');
  final modifiedLines = <String>[];
  bool modified = false;

  // Simple regex to match Text widgets (basic cases)
  final textWidgetRegex = RegExp(
      r'''Text\s*\(\s*['"]([^'"]+)['"]\s*(,\s*style:\s*TextStyle\([^\)]*\))?\s*\)''',
      multiLine: true);

  String newContent = content;
  textWidgetRegex.allMatches(content).forEach((match) {
    final fullMatch = match.group(0)!;
    final textContent = match.group(1)!;
    final stylePart = match.group(2) ?? '';

    // Replace Text with TranslatedText
    final replacement = 'TranslatedText(\'$textContent\'$stylePart)';
    newContent = newContent.replaceFirst(fullMatch, replacement);
    modified = true;
  });

  if (modified) {
    await file.writeAsString(newContent);
    print('Modified: ${file.path}');
  }
}