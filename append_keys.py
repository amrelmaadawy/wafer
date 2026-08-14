with open('lib/core/localization/locale_keys.dart', 'r', encoding='utf-8') as f:
    lines = f.readlines()

last_brace_idx = -1
for i in range(len(lines)-1, -1, -1):
    if '}' in lines[i]:
        last_brace_idx = i
        break

if last_brace_idx != -1:
    lines.insert(last_brace_idx, "  static const properties_amenity_smart_lock = 'properties_amenity_smart_lock';\n")
    lines.insert(last_brace_idx+1, "  static const properties_amenity_central_ac = 'properties_amenity_central_ac';\n")

with open('lib/core/localization/locale_keys.dart', 'w', encoding='utf-8') as f:
    f.writelines(lines)
