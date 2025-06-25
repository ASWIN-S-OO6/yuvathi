import 'dart:io';
import 'package:path/path.dart' as path;

void main() async {
  final projectDir = Directory.current;
  await processDirectory(projectDir);
  print('Reversion complete!');
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
  bool modified = false;

  // Regex to match TranslatedText widgets (basic cases)
  final translatedTextRegex = RegExp(
      r'''TranslatedText\s*\(\s*['"]([^'"]+)['"]\s*(,\s*style:\s*TextStyle\([^\)]*\))?\s*\)''',
      multiLine: true);

  String newContent = content;
  translatedTextRegex.allMatches(content).forEach((match) {
    final fullMatch = match.group(0)!;
    final textContent = match.group(1)!;
    final stylePart = match.group(2) ?? '';

    // Replace TranslatedText with Text
    final replacement = 'Text(\'$textContent\'$stylePart)';
    newContent = newContent.replaceFirst(fullMatch, replacement);
    modified = true;
  });

  if (modified) {
    await file.writeAsString(newContent);
    print('Reverted: ${file.path}');
  }
}