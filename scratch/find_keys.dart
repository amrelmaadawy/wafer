import 'dart:io';

void main() {
  final libDir = Directory('lib');
  final regex = RegExp(r'LocaleKeys\.([a-z][a-zA-Z0-9]*)');
  
  final Set<String> camelCaseKeysUsed = {};
  
  void processDir(Directory dir) {
    for (var entity in dir.listSync(recursive: false)) {
      if (entity is Directory) {
        processDir(entity);
      } else if (entity is File && entity.path.endsWith('.dart')) {
        final content = entity.readAsStringSync();
        final matches = regex.allMatches(content);
        for (var match in matches) {
          final key = match.group(1)!;
          // Filter out actual snake_case keys just in case the regex caught them without underscores
          // Wait, the regex `[a-z][a-zA-Z0-9]*` doesn't match underscores, so it ONLY catches camelCase keys!
          // But wait, what about single-word keys like `auth`? They don't have uppercase.
          if (key.contains(RegExp(r'[A-Z]'))) {
            camelCaseKeysUsed.add(key);
          }
        }
      }
    }
  }
  
  processDir(libDir);
  
  print('Found ${camelCaseKeysUsed.length} camelCase keys used in the codebase:');
  for (var key in camelCaseKeysUsed.toList()..sort()) {
    print(key);
  }
}
