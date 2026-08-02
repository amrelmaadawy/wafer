keys = [
    'legal_case_updated_success', 'discard_changes', 'discard_changes_message',
    'discard', 'edit_case', 'add_case', 'case_basics', 'edit_legal_case',
    'select_stage', 'no_data_available', 'parties', 'links', 'select_property',
    'select_unit', 'select_contract', 'additional_notes', 'enter_notes',
    'property_and_contract', 'currency', 'all'
]

with open('lib/core/localization/locale_keys.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Remove the trailing '}'
if content.strip().endswith('}'):
    content = content[:content.rfind('}')]

# Append the keys
for key in keys:
    content += f"  static const {key} = '{key}';\n"

content += '}\n'

with open('lib/core/localization/locale_keys.dart', 'w', encoding='utf-8') as f:
    f.write(content)
