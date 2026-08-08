import json
import re
from pathlib import Path

def camel_to_words(name):
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1 \2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1 \2', s1).lower().split()

def get_nested_paths(d, current_path=""):
    paths = []
    for k, v in d.items():
        new_path = f"{current_path}.{k}" if current_path else k
        if isinstance(v, dict):
            paths.extend(get_nested_paths(v, new_path))
        else:
            paths.append(new_path)
    return paths

def main():
    with open('assets/translations/en.json', 'r', encoding='utf-8') as f:
        data = json.load(f)

    # Separate nested keys and flat keys
    nested_data = {}
    flat_keys = []
    
    for k, v in data.items():
        if isinstance(v, dict):
            nested_data[k] = v
        else:
            flat_keys.append(k)
            
    nested_paths = get_nested_paths(nested_data)
    
    # Create snake_case dart variable names from nested paths
    # e.g., "dashboard.welcome" -> "dashboard_welcome"
    snake_case_keys = [p.replace('.', '_') for p in nested_paths]
    
    mapping = {}
    for flat in flat_keys:
        # e.g. "propertiesStatsUnitsAndDeeds"
        flat_words = set(camel_to_words(flat))
        
        best_match = None
        best_score = -1
        
        for snake in snake_case_keys:
            snake_words = set(snake.split('_'))
            # Calculate Jaccard similarity or intersection
            intersection = len(flat_words.intersection(snake_words))
            union = len(flat_words.union(snake_words))
            score = intersection / union if union > 0 else 0
            
            # Additional heuristic: if flat key completely contains snake_case or vice versa
            if snake.replace('_', '').lower() == flat.lower():
                score = 100
                
            if score > best_score:
                best_score = score
                best_match = snake
                
        mapping[flat] = best_match

    # Now write a Dart script to do the replacement
    dart_script = """import 'dart:io';

void main() {
  final libDir = Directory('lib');
  final mapping = <String, String>{
"""
    for flat, snake in mapping.items():
        dart_script += f"    '{flat}': '{snake}',\n"
        
    dart_script += """  };
  
  int filesModified = 0;
  
  void processDir(Directory dir) {
    for (var entity in dir.listSync(recursive: false)) {
      if (entity is Directory) {
        processDir(entity);
      } else if (entity is File && entity.path.endsWith('.dart')) {
        String content = entity.readAsStringSync();
        bool changed = false;
        
        mapping.forEach((flat, snake) {
          final target = 'LocaleKeys.$flat';
          final replacement = 'LocaleKeys.$snake';
          if (content.contains(target)) {
            // Check word boundary to avoid partial replacements (e.g., flat1 replaced inside flat10)
            final regex = RegExp('LocaleKeys\\\\.$flat\\\\b');
            if (regex.hasMatch(content)) {
                content = content.replaceAll(regex, replacement);
                changed = true;
            }
          }
        });
        
        if (changed) {
          entity.writeAsStringSync(content);
          filesModified++;
        }
      }
    }
  }
  
  processDir(libDir);
  print('Replaced keys in $filesModified files.');
}
"""

    with open('scratch/replace_keys.dart', 'w', encoding='utf-8') as f:
        f.write(dart_script)
        
    print("Generated scratch/replace_keys.dart")

if __name__ == '__main__':
    main()
