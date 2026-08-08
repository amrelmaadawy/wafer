import json
import re

def to_camel_case(snake_str):
    # snake_str can be "dashboard.welcome" or "dashboard.total_count"
    # We want to convert it to "dashboardWelcome" and "dashboardTotalCount"
    # First, split by '.' and '_'
    parts = re.split(r'[_.]', snake_str)
    if not parts:
        return snake_str
    
    # Capitalize the first letter of each component except the first one
    # with the 'title' method and join them together.
    return parts[0].lower() + ''.join(x.title() for x in parts[1:])

def get_nested_paths_with_values(d, current_path=""):
    paths = {}
    for k, v in d.items():
        new_path = f"{current_path}.{k}" if current_path else k
        if isinstance(v, dict):
            paths.update(get_nested_paths_with_values(v, new_path))
        else:
            paths[new_path] = v
    return paths

def fix_json_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    nested_data = {}
    flat_data = {}
    
    for k, v in data.items():
        if isinstance(v, dict):
            nested_data[k] = v
        else:
            flat_data[k] = v
            
    # Flatten the nested data
    nested_paths = get_nested_paths_with_values(nested_data)
    
    # Create a mapping from camelCase -> Arabic/English value
    camel_to_value = {}
    for path, value in nested_paths.items():
        camel_key = to_camel_case(path)
        camel_to_value[camel_key] = value
        
    # Update flat_data with the correct values
    updated_count = 0
    missing = []
    
    for k, v in flat_data.items():
        if k in camel_to_value:
            flat_data[k] = camel_to_value[k]
            updated_count += 1
        else:
            # Maybe the key in camelCase was derived differently?
            missing.append(k)
            
    # Reconstruct the JSON: nested data first, then updated flat data
    final_data = {}
    final_data.update(nested_data)
    final_data.update(flat_data)
    
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(final_data, f, ensure_ascii=False, indent=2)
        
    print(f"Updated {updated_count} flat keys in {filepath}.")
    if missing:
        print(f"Could not find nested translations for {len(missing)} flat keys in {filepath}:")
        for m in missing[:10]:
            print(f"  - {m}")
        if len(missing) > 10:
            print("  ...")

def main():
    fix_json_file('assets/translations/ar.json')
    fix_json_file('assets/translations/en.json')

if __name__ == '__main__':
    main()
