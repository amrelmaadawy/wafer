import re
import glob

def fix_const_text():
    files = [
        'lib/features/owner/finance/presentation/views/create_owner_receipt_view.dart',
        'lib/features/owner/finance/presentation/views/create_owner_payment_view.dart'
    ]
    for path in files:
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Remove const before Text that has .tr()
        content = re.sub(r'const\s+Text\(([^)]*\.tr\(\)[^)]*)\)', r'Text(\1)', content)
        
        # Also remove const if the TextStyle is const now
        content = re.sub(r'const\s+Text\(LocaleKeys', r'Text(LocaleKeys', content)
        
        # Fix: Text(LocaleKeys.financeDebitAccount.tr(), style: const TextStyle(fontWeight: FontWeight.bold)) 
        # where it might have had const before Text.
        
        # Any remaining const Text with LocaleKeys
        content = content.replace("const Text(LocaleKeys", "Text(LocaleKeys")
        
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
            
fix_const_text()
print("Fixed const Text errors")
