import json

ar_path = 'assets/translations/ar.json'
en_path = 'assets/translations/en.json'

new_ar = {
    "commonAll": "الكل",
    "commonApply": "تطبيق"
}

new_en = {
    "commonAll": "All",
    "commonApply": "Apply"
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
