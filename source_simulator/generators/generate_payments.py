
from pathlib import Path
import pandas as pd
import random

# Step 1: Find project root
project_root = Path(__file__).resolve().parents[2]

# Step 2: Read existing orders
orders_file = project_root / "data" / "historical" / "orders.csv"
orders_df = pd.read_csv(orders_file)

# Step 3: Prepare payment options
payment_methods = ["UPI", "CARD", "NET_BANKING", "WALLET"]

payments = []
payment_counter = 1000

# Step 4: Generate payment attempts for each order
for _, order in orders_df.iterrows():

    # Every order gets at least one payment attempt
    number_of_attempts = random.randint(1, 2)

    for attempt in range(1, number_of_attempts + 1):

        payment_counter += 1

        # First attempt can fail or succeed
        # A retry succeeds in this simplified simulation
        if attempt == 1:
            status = random.choice(["SUCCESS", "FAILED"])
        else:
            status = "SUCCESS"

        payment = {
            "payment_id": f"PAY{payment_counter}",
            "order_id": order["order_id"],
            "attempt_number": attempt,
            "payment_method": random.choice(payment_methods),
            "payment_amount": round(random.uniform(500, 50000), 2),
            "payment_status": status,
            "transaction_timestamp": "2026-11-21 10:30:00",
            "updated_at": "2026-11-21 10:30:00"
        }

        payments.append(payment)

# Step 5: Convert to DataFrame
payments_df = pd.DataFrame(payments)

# Step 6: Save payments CSV
output_folder = project_root / "data" / "historical"
output_folder.mkdir(parents=True, exist_ok=True)

output_file = output_folder / "payments.csv"
payments_df.to_csv(output_file, index=False)

print("Payments CSV generated successfully!")
print("Total payment attempts:", len(payments_df))
print("Successful payments:", (payments_df["payment_status"] == "SUCCESS").sum())
print("Failed payments:", (payments_df["payment_status"] == "FAILED").sum())
print("File location:", output_file)
