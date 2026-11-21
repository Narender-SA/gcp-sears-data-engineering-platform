
from pathlib import Path
import pandas as pd
import random

# Find the project root folder
project_root = Path(__file__).resolve().parents[2]

# Read the existing customer CSV
customer_file = project_root / "data" / "historical" / "customers.csv"
customers_df = pd.read_csv(customer_file)

# Prepare sample order data
orders = []

order_statuses = ["DELIVERED", "SHIPPED", "PROCESSING", "CANCELLED"]

for i in range(1, 11):

    # Select one customer from the customer dataset
    customer = customers_df.sample(1).iloc[0]

    order = {
        "order_id": f"ORD{1000 + i}",
        "customer_id": customer["customer_id"],
        "order_timestamp": f"2026-11-{random.randint(1, 20):02d} 10:30:00",
        "order_status": random.choice(order_statuses),
        "shipping_city": customer["city"],
        "shipping_state": customer["state"],
        "region": customer["region"],
        "currency": "INR",
        "created_at": "2026-11-21 09:00:00",
        "updated_at": "2026-11-21 09:00:00",
        "is_deleted": False
    }

    orders.append(order)

# Convert list into DataFrame
orders_df = pd.DataFrame(orders)

# Create output folder
output_folder = project_root / "data" / "historical"
output_folder.mkdir(parents=True, exist_ok=True)

# Save orders CSV
output_file = output_folder / "orders.csv"
orders_df.to_csv(output_file, index=False)

print("Orders CSV generated successfully!")
print("Total orders:", len(orders_df))
print("File location:", output_file)
