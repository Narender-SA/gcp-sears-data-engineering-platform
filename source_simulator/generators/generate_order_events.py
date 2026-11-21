
from pathlib import Path
import pandas as pd
from datetime import datetime, timedelta

# Step 1: Find project root
project_root = Path(__file__).resolve().parents[2]

# Step 2: Read existing orders
orders_file = project_root / "data" / "historical" / "orders.csv"
orders_df = pd.read_csv(orders_file)

# Step 3: Define possible status transitions
status_sequences = {
    "DELIVERED": [
        "CREATED",
        "CONFIRMED",
        "SHIPPED",
        "DELIVERED"
    ],
    "SHIPPED": [
        "CREATED",
        "CONFIRMED",
        "SHIPPED"
    ],
    "PROCESSING": [
        "CREATED",
        "CONFIRMED",
        "PROCESSING"
    ],
    "CANCELLED": [
        "CREATED",
        "CANCELLED"
    ]
}

# Step 4: Prepare event records
events = []
event_counter = 1000

base_timestamp = datetime(2026, 11, 1, 10, 0, 0)

# Step 5: Generate status events for every order
for _, order in orders_df.iterrows():

    final_status = order["order_status"]

    # Get the sequence matching the current order status
    statuses = status_sequences[final_status]

    previous_status = None

    for position, current_status in enumerate(statuses):

        event_counter += 1

        event_time = base_timestamp + timedelta(
            days=position
        )

        event = {
            "event_id": f"EVT{event_counter}",
            "order_id": order["order_id"],
            "old_status": previous_status,
            "new_status": current_status,
            "event_timestamp": event_time,
            "source_updated_at": event_time
        }

        events.append(event)

        previous_status = current_status

# Step 6: Convert events into DataFrame
events_df = pd.DataFrame(events)

# Step 7: Save order events CSV
output_folder = project_root / "data" / "historical"
output_folder.mkdir(parents=True, exist_ok=True)

output_file = output_folder / "order_events.csv"

events_df.to_csv(output_file, index=False)

print("Order events CSV generated successfully!")
print("Total events:", len(events_df))
print("File location:", output_file)
