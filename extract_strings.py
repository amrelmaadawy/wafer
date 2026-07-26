import os, re, json

matches = set()
pattern = re.compile(r'([\'"])(.*?[\\u0600-\\u06FF]+.*?)\1')

dirs = [
    'lib/features/owner/properties/presentation',
    'lib/features/owner/deeds/presentation'
]

for d in dirs:
    for root, _, files in os.walk(d):
        for file in files:
            if file.endswith('.dart'):
                path = os.path.join(root, file)
                with open(path, 'r', encoding='utf-8') as f:
                    for line in f:
                        for match in pattern.findall(line):
                            matches.add(match[1])

with open('arabic_strings_dump.json', 'w', encoding='utf-8') as out:
    json.dump(list(matches), out, ensure_ascii=False, indent=2)
