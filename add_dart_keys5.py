import os

dart_path = 'lib/core/localization/locale_keys.dart'

new_keys = [
    "unitsVideosTitle",
    "unitsVideosSubtitle",
    "unitsFilesTitle",
    "unitsFilesSubtitle"
]

with open(dart_path, 'r', encoding='utf-8') as f:
    content = f.read()

insertion = ""
for key in new_keys:
    if f"static const {key} = '{key}';" not in content:
        insertion += f"  static const {key} = '{key}';\n"

if insertion:
    content = content.replace("}", insertion + "\n}")
    with open(dart_path, 'w', encoding='utf-8') as f:
        f.write(content)
    print("Updated locale_keys.dart")
else:
    print("Keys already exist")
