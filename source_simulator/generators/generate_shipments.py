
from pathlib import Path
import pandas as pd
import random

# Step 1: Find project root
project_root = Path(__file__).resolve().parents[2]

# Step 2: Read existing orders
orders_file = project_root / "data" / "historical" / "orders.csv"
orders_df = pd.read_csv(orders_file)

# Step 3: Prepare shipment options
carriers = ["BlueDart", "Delhivery", "DTDC", "Ecom Express"]

shipments = []
shipment_counter = 1000

# Step 4: Generate shipments
for _, order in orders_df.iterrows():

    # Cancelled orders do not get shipments
    if order["order_status"] == "CANCELLED":
        continue

    shipment_counter += 1

    delivery_status = random.choice(
        ["SHIPPED", "IN_TRANSIT", "DELIVERED"]
    )

    shipped_at = "2026-11-18 10:00:00"

    if delivery_status == "DELIVERED":
        delivered_at = "2026-11-20 15:30:00"
    else:
        delivered_at = None

    shipment = {
        "shipment_id": f"SHIP{shipment_counter}",
        "order_id": order["order_id"],
        "carrier": random.choice(carriers),
        "shipped_at": shipped_at,
        "delivered_at": delivered_at,
        "delivery_status": delivery_status,
        "updated_at": "2026-11-21 09:00:00"
    }

    shipments.append(shipment)

# Step 5: Convert to DataFrame
shipments_df = pd.DataFrame(shipments)

# Step 6: Save shipments CSV
output_folder = project_root / "data" / "historical"
output_folder.mkdir(parents=True, exist_ok=True)

output_file = output_folder / "shipments.csv"
shipments_df.to_csv(output_file, index=False)

print("Shipments CSV generated successfully!")
print("Total shipments:", len(shipments_df))
print("File location:", output_file)

