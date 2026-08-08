import json

def add_key_to_json(filepath, key, value):
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
    data[key] = value
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

def main():
    add_key_to_json('assets/translations/ar.json', 'splashTagline', 'إدارة الأملاك الذكية')
    add_key_to_json('assets/translations/en.json', 'splashTagline', 'Smart Property Management')
    print("Tagline keys added.")

if __name__ == '__main__':
    main()
