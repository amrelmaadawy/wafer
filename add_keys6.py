import json

ar_path = 'assets/translations/ar.json'
en_path = 'assets/translations/en.json'

new_ar = {
    "financeCreateReceipt": "إنشاء سند قبض",
    "financeCreatePayment": "إنشاء سند صرف",
    "financeSaving": "جارٍ الحفظ...",
    "financeReceiptSaved": "تم حفظ سند القبض بنجاح",
    "financePaymentSaved": "تم حفظ سند الصرف بنجاح",
    "financeOwnerId": "رقم المالك (Owner ID)",
    "financePayeeId": "رقم المستفيد (Payee ID)",
    "financeRequired": "مطلوب",
    "financeAmount": "المبلغ",
    "financeDate": "تاريخ السند",
    "financePaymentMethod": "طريقة الدفع",
    "financeSelectPaymentMethod": "اختر طريقة الدفع",
    "financeDebitAccount": "الحساب المدين (Debit Account)",
    "financeSelectDebit": "اختر الحساب المدين",
    "financeCreditAccount": "الحساب الدائن (Credit Account)",
    "financeSelectCredit": "اختر الحساب الدائن",
    "financePropertyOptional": "العقار - اختياري",
    "financeSelectProperty": "اختر العقار",
    "financeContractOptional": "العقد - اختياري",
    "financeSelectContract": "اختر العقد",
    "financeNotes": "ملاحظات",
    "financeCreateAction": "إنشاء السند"
}

new_en = {
    "financeCreateReceipt": "Create Receipt",
    "financeCreatePayment": "Create Payment",
    "financeSaving": "Saving...",
    "financeReceiptSaved": "Receipt saved successfully",
    "financePaymentSaved": "Payment saved successfully",
    "financeOwnerId": "Owner ID",
    "financePayeeId": "Payee ID",
    "financeRequired": "Required",
    "financeAmount": "Amount",
    "financeDate": "Date",
    "financePaymentMethod": "Payment Method",
    "financeSelectPaymentMethod": "Select Payment Method",
    "financeDebitAccount": "Debit Account",
    "financeSelectDebit": "Select Debit Account",
    "financeCreditAccount": "Credit Account",
    "financeSelectCredit": "Select Credit Account",
    "financePropertyOptional": "Property (Optional)",
    "financeSelectProperty": "Select Property",
    "financeContractOptional": "Contract (Optional)",
    "financeSelectContract": "Select Contract",
    "financeNotes": "Notes",
    "financeCreateAction": "Create"
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
