
from pathlib import Path
import pandas as pd
import random

# Step 1: Find project root
project_root = Path(__file__).resolve().parents[2]

# Step 2: Read existing orders and products
orders_file = project_root / "data" / "historical" / "orders.csv"
products_file = project_root / "data" / "historical" / "products.csv"

orders_df = pd.read_csv(orders_file)
products_df = pd.read_csv(products_file)

# Step 3: Prepare order item records
order_items = []

item_counter = 1000

# Step 4: Generate 1 to 3 product lines for every order
for _, order in orders_df.iterrows():

    number_of_items = random.randint(1, 3)

    # Select products without repeating a product in the same order
    selected_products = products_df.sample(
        n=min(number_of_items, len(products_df))
    )

    for _, product in selected_products.iterrows():

        item_counter += 1

        quantity = random.randint(1, 3)
        unit_price = float(product["list_price"])
        discount = random.choice([0, 5, 10, 15])

        order_item = {
            "order_item_id": f"ITEM{item_counter}",
            "order_id": order["order_id"],
            "product_id": product["product_id"],
            "quantity": quantity,
            "unit_price_at_purchase": unit_price,
            "discount_percent": discount,
            "updated_at": "2026-11-21 09:00:00"
        }

        order_items.append(order_item)

# Step 5: Convert records into DataFrame
order_items_df = pd.DataFrame(order_items)

# Step 6: Save the generated CSV
output_folder = project_root / "data" / "historical"
output_folder.mkdir(parents=True, exist_ok=True)

output_file = output_folder / "order_items.csv"

order_items_df.to_csv(output_file, index=False)

print("Order items CSV generated successfully!")
print("Total order items:", len(order_items_df))
print("File location:", output_file)
