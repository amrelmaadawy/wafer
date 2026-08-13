import json

ar_path = 'assets/translations/ar.json'
en_path = 'assets/translations/en.json'

new_ar = {
    "unitsVideosTitle": "الفيديوهات",
    "unitsVideosSubtitle": "أضف فيديوهات توضيحية للوحدة",
    "unitsFilesTitle": "الملفات والمرفقات",
    "unitsFilesSubtitle": "أضف أي ملفات أو مستندات (PDF, Word, etc)"
}

new_en = {
    "unitsVideosTitle": "Videos",
    "unitsVideosSubtitle": "Add illustrative videos for the unit",
    "unitsFilesTitle": "Files and Attachments",
    "unitsFilesSubtitle": "Add any files or documents (PDF, Word, etc)"
}

def update_json(path, new_keys):
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    for k, v in new_keys.items():
        if k not in data:
            data[k] = v
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

update_json(ar_path, new_ar)
update_json(en_path, new_en)
print("Updated JSON files")
