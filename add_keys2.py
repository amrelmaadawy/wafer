import json

ar_path = 'assets/translations/ar.json'
en_path = 'assets/translations/en.json'

new_ar = {
    "propertyDetailsLocation": "الموقع والعنوان",
    "propertyDetailsCity": "المدينة",
    "propertyDetailsCityHint": "أدخل اسم المدينة",
    "propertyDetailsDistrict": "الحي",
    "propertyDetailsDistrictHint": "أدخل اسم الحي",
    "propertyDetailsRegion": "المنطقة",
    "propertyDetailsRegionHint": "أدخل اسم المنطقة",
    "propertyDetailsBuildingNumber": "رقم المبنى",
    "propertyDetailsBuildingNumberHint": "رقم المبنى",
    "propertyDetailsStreet": "الشارع",
    "propertyDetailsStreetHint": "أدخل اسم الشارع",
    "propertyDetailsDescriptionHint": "اكتب وصفاً مفصلاً للعقار...",
    "propertyDetailsSpecsTitle": "المواصفات والأبعاد",
    "propertyDetailsUsageHint": "اختر نوع الاستخدام",
    "propertyDetailsLength": "الطول (م)",
    "propertyDetailsWidth": "العرض (م)",
    "propertyDetailsAmenitiesTitle": "المميزات والإضافات",
    "propertiesUsageIndustrial": "صناعي",
    "propertiesUsageMixed": "مختلط",
    "amenityElevator": "مصعد",
    "amenityParking": "موقف سيارات",
    "amenitySecurity": "حراسة 24/7",
    "amenityPool": "مسبح",
    "amenityGym": "صالة رياضية",
    "amenityGenerator": "مولد كهرباء",
    "amenityCentralAc": "تكييف مركزي",
    "amenityInternet": "ألياف بصرية (إنترنت)"
}

new_en = {
    "propertyDetailsLocation": "Location & Address",
    "propertyDetailsCity": "City",
    "propertyDetailsCityHint": "Enter city name",
    "propertyDetailsDistrict": "District",
    "propertyDetailsDistrictHint": "Enter district name",
    "propertyDetailsRegion": "Region",
    "propertyDetailsRegionHint": "Enter region name",
    "propertyDetailsBuildingNumber": "Building No.",
    "propertyDetailsBuildingNumberHint": "Building Number",
    "propertyDetailsStreet": "Street",
    "propertyDetailsStreetHint": "Enter street name",
    "propertyDetailsDescriptionHint": "Enter a detailed description...",
    "propertyDetailsSpecsTitle": "Specifications & Dimensions",
    "propertyDetailsUsageHint": "Select usage type",
    "propertyDetailsLength": "Length (m)",
    "propertyDetailsWidth": "Width (m)",
    "propertyDetailsAmenitiesTitle": "Amenities & Features",
    "propertiesUsageIndustrial": "Industrial",
    "propertiesUsageMixed": "Mixed",
    "amenityElevator": "Elevator",
    "amenityParking": "Parking",
    "amenitySecurity": "24/7 Security",
    "amenityPool": "Pool",
    "amenityGym": "Gym",
    "amenityGenerator": "Generator",
    "amenityCentralAc": "Central AC",
    "amenityInternet": "Fiber Internet"
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
