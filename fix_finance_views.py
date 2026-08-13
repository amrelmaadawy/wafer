import os
import re

receipt_path = 'lib/features/owner/finance/presentation/views/create_owner_receipt_view.dart'
payment_path = 'lib/features/owner/finance/presentation/views/create_owner_payment_view.dart'

def fix_view(file_path, is_receipt=True):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Add import if missing
    if "import '../../../../../core/localization/locale_keys.dart';" not in content:
        content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:easy_localization/easy_localization.dart';\nimport '../../../../../core/localization/locale_keys.dart';")

    # Shared replacements
    replacements = [
        (r"'Ø¬Ø§Ø±ÙŠ Ø§Ù„Ø­Ù Ù Ø¸\.\.\.'", "LocaleKeys.financeSaving.tr()"),
        (r"'ØªÙ… Ø­Ù Ù Ø¸ Ø§Ù„Ø³Ù†Ø¯ Ø§Ù„Ù…Ø§Ù„ÙŠ Ø¨Ù†Ø¬Ø§Ø­'", "LocaleKeys.financeReceiptSaved.tr()"),
        (r"'Ø¥Ù†Ø´Ø§Ø¡ Ø³Ù†Ø¯ Ù…Ø§Ù„ÙŠ'", "LocaleKeys.financeCreateReceipt.tr()"),
        (r"'Ø±Ù‚Ù… Ø§Ù„Ù…Ø§Ù„Ùƒ \(Owner ID\)'", "LocaleKeys.financeOwnerId.tr()"),
        (r"'Ù…Ø·Ù„ÙˆØ¨'", "LocaleKeys.financeRequired.tr()"),
        (r"'Ø§Ù„Ù…Ø¨Ù„Øº'", "LocaleKeys.financeAmount.tr()"),
        (r"'Ø§Ù„Ù…Ø¨Ù„Øº \(Amount\)'", "LocaleKeys.financeAmount.tr()"),
        (r"'ØªØ§Ø±ÙŠØ® Ø§Ù„Ø³Ù†Ø¯'", "LocaleKeys.financeDate.tr()"),
        (r"'Ø·Ø±ÙŠÙ‚Ø© Ø§Ù„Ø¯Ù Ù Ø¹'", "LocaleKeys.financePaymentMethod.tr()"),
        (r"'Ø§Ø®ØªØ± Ø·Ø±ÙŠÙ‚Ø© Ø§Ù„Ø¯Ù Ù Ø¹'", "LocaleKeys.financeSelectPaymentMethod.tr()"),
        (r"'Ø§Ù„Ø­Ø³Ø§Ø¨ Ø§Ù„Ù…Ø¯ÙŠÙ† \(Debit Account\)'", "LocaleKeys.financeDebitAccount.tr()"),
        (r"'Ø§Ø®ØªØ± Ø§Ù„Ø­Ø³Ø§Ø¨ Ø§Ù„Ù…Ø¯ÙŠÙ†'", "LocaleKeys.financeSelectDebit.tr()"),
        (r"'Ø§Ù„Ø­Ø³Ø§Ø¨ Ø§Ù„Ø¯Ø§Ø¦Ù† \(Credit Account\)'", "LocaleKeys.financeCreditAccount.tr()"),
        (r"'Ø§Ø®ØªØ± Ø§Ù„Ø­Ø³Ø§Ø¨ Ø§Ù„Ø¯Ø§Ø¦Ù†'", "LocaleKeys.financeSelectCredit.tr()"),
        (r"'Ø§Ù„Ø¹Ù‚Ø§Ø± - Ø§Ø®ØªÙŠØ§Ø±ÙŠ'", "LocaleKeys.financePropertyOptional.tr()"),
        (r"'Ø§Ù„Ø¹Ù‚Ø§Ø± \(Property\) - Ø§Ø®ØªÙŠØ§Ø±ÙŠ'", "LocaleKeys.financePropertyOptional.tr()"),
        (r"'Ø§Ø®ØªØ± Ø§Ù„Ø¹Ù‚Ø§Ø±'", "LocaleKeys.financeSelectProperty.tr()"),
        (r"'Ø§Ù„Ø¹Ù‚Ø¯ - Ø§Ø®ØªÙŠØ§Ø±ÙŠ'", "LocaleKeys.financeContractOptional.tr()"),
        (r"'Ø§Ù„Ø¹Ù‚Ø¯ \(Contract\) - Ø§Ø®ØªÙŠØ§Ø±ÙŠ'", "LocaleKeys.financeContractOptional.tr()"),
        (r"'Ø§Ø®ØªØ± Ø§Ù„Ø¹Ù‚Ø¯'", "LocaleKeys.financeSelectContract.tr()"),
        (r"'Ù…Ù„Ø§Ø­Ø¸Ø§Øª'", "LocaleKeys.financeNotes.tr()"),
        (r"'Ø¥Ù†Ø´Ø§Ø¡ Ø§Ù„Ø³Ù†Ø¯'", "LocaleKeys.financeCreateAction.tr()"),
    ]

    if not is_receipt:
        replacements.append((r"LocaleKeys.owner_finance_saving.tr\(\)", "LocaleKeys.financeSaving.tr()"))
        replacements.append((r"LocaleKeys.owner_finance_save_success.tr\(\)", "LocaleKeys.financePaymentSaved.tr()"))
        replacements.append((r"Text\(LocaleKeys.owner_finance_create_payment.tr\(\)\)", "Text(LocaleKeys.financeCreatePayment.tr())"))
        replacements.append((r"LocaleKeys.owner_finance_payee_id.tr\(\)", "LocaleKeys.financePayeeId.tr()"))

    for old, new in replacements:
        content = re.sub(old, new, content)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

fix_view(receipt_path, is_receipt=True)
fix_view(payment_path, is_receipt=False)
print("Fixed views")
