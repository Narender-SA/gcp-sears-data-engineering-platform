
from pathlib import Path
import pandas as pd

products = [
    {
        "product_id": "PROD1001",
        "product_name": "Samsung Smart TV",
        "category": "Electronics",
        "brand": "Samsung",
        "list_price": 45000.00,
        "updated_at": "2026-11-21 09:00:00",
        "is_active": True
    },
    {
        "product_id": "PROD1002",
        "product_name": "Men Cotton Shirt",
        "category": "Apparel",
        "brand": "Levis",
        "list_price": 1999.00,
        "updated_at": "2026-11-21 09:00:00",
        "is_active": True
    },
    {
        "product_id": "PROD1003",
        "product_name": "Washing Machine",
        "category": "Home Appliances",
        "brand": "LG",
        "list_price": 28000.00,
        "updated_at": "2026-11-21 09:00:00",
        "is_active": True
    },
    {
        "product_id": "PROD1004",
        "product_name": "Running Shoes",
        "category": "Footwear",
        "brand": "Nike",
        "list_price": 5500.00,
        "updated_at": "2026-11-21 09:00:00",
        "is_active": True
    },
    {
        "product_id": "PROD1005",
        "product_name": "Kitchen Mixer",
        "category": "Home Appliances",
        "brand": "Philips",
        "list_price": 3500.00,
        "updated_at": "2026-11-21 09:00:00",
        "is_active": True
    }
]

df = pd.DataFrame(products)

project_root = Path(__file__).resolve().parents[2]

output_folder = project_root / "data" / "historical"
output_folder.mkdir(parents=True, exist_ok=True)

output_file = output_folder / "products.csv"

df.to_csv(output_file, index=False)

print("Product CSV generated successfully!")
print("Total products:", len(df))
print("File location:", output_file)
