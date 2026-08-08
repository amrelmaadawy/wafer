import json

def add_key_to_json(filepath, key, value):
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
    data[key] = value
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

def main():
    add_key_to_json('assets/translations/ar.json', 'feature_coming_soon', 'هذه الخاصية سوف يتم إضافتها قريباً')
    add_key_to_json('assets/translations/en.json', 'feature_coming_soon', 'This feature will be added soon')
    print("Coming soon keys added.")

if __name__ == '__main__':
    main()
