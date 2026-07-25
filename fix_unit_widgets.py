import os
import re

files = [
    'lib/features/owner/properties/presentation/widgets/details/unit_header_section.dart',
    'lib/features/owner/properties/presentation/widgets/details/unit_prices_section.dart',
    'lib/features/owner/properties/presentation/widgets/details/unit_specs_grid.dart',
    'lib/features/owner/properties/presentation/widgets/details/unit_meters_section.dart',
    'lib/features/owner/properties/presentation/widgets/details/unit_dimensions_card.dart',
    'lib/features/owner/properties/presentation/widgets/details/unit_amenities_section.dart',
]

for filepath in files:
    if not os.path.exists(filepath):
        print(f'SKIP (not found): {filepath}')
        continue
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original = content
    
    # Fix import path: core/utils/color_utils.dart -> core/theme/color_utils.dart
    content = content.replace(
        '../../../../../../core/utils/color_utils.dart',
        '../../../../../../core/theme/color_utils.dart'
    )
    
    # Fix AppFonts.X.copyWith(...) -> TextStyle(fontFamily: AppFonts.fontFamilyPrimary, fontWeight: AppFonts.X).copyWith(...)
    content = re.sub(
        r'AppFonts\.(bold|semiBold|medium|regular|light)\.copyWith\(',
        lambda m: f'TextStyle(fontFamily: AppFonts.fontFamilyPrimary, fontWeight: AppFonts.{m.group(1)}).copyWith(',
        content
    )
    
    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f'Fixed: {filepath}')
    else:
        print(f'No changes: {filepath}')

print('Done!')
