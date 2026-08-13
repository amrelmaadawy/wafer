import json
import os

ar_path = 'assets/translations/ar.json'
en_path = 'assets/translations/en.json'

new_ar = {
    "propertiesFilterTitle": "تصفية العقارات",
    "propertiesResetFilter": "إعادة تعيين",
    "propertiesStatusTitle": "حالة العقار",
    "propertiesStatusPublished": "منشور",
    "propertiesStatusDraft": "مسودة",
    "propertiesTypeTitle": "نوع العقار",
    "propertiesTypeBuilding": "عمارة",
    "propertiesTypeVilla": "فيلا",
    "propertiesTypeLand": "أرض",
    "propertiesUsageTitle": "نوع الاستخدام",
    "propertiesUsageResidential": "سكني",
    "propertiesUsageCommercial": "تجاري",
    "propertiesSortTitle": "الترتيب حسب",
    "propertiesSortName": "الاسم",
    "propertiesSortArea": "المساحة",
    "propertiesSortOccupancy": "نسبة الإشغال",
    "propertiesSortUnits": "عدد الوحدات",
    "propertiesSortOrderTitle": "ترتيب تصاعدي/تنازلي",
    "propertiesSortAscending": "تصاعدي",
    "propertiesSortDescending": "تنازلي"
}

new_en = {
    "propertiesFilterTitle": "Filter Properties",
    "propertiesResetFilter": "Reset",
    "propertiesStatusTitle": "Property Status",
    "propertiesStatusPublished": "Published",
    "propertiesStatusDraft": "Draft",
    "propertiesTypeTitle": "Property Type",
    "propertiesTypeBuilding": "Building",
    "propertiesTypeVilla": "Villa",
    "propertiesTypeLand": "Land",
    "propertiesUsageTitle": "Usage Type",
    "propertiesUsageResidential": "Residential",
    "propertiesUsageCommercial": "Commercial",
    "propertiesSortTitle": "Sort By",
    "propertiesSortName": "Name",
    "propertiesSortArea": "Area",
    "propertiesSortOccupancy": "Occupancy",
    "propertiesSortUnits": "Units Count",
    "propertiesSortOrderTitle": "Sort Order",
    "propertiesSortAscending": "Ascending",
    "propertiesSortDescending": "Descending"
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
