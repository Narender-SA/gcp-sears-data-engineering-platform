
from pathlib import Path
import pandas as pd
import random

# Step 1: Find project root
project_root = Path(__file__).resolve().parents[2]

# Step 2: Read existing payment data
payments_file = project_root / "data" / "historical" / "payments.csv"
payments_df = pd.read_csv(payments_file)

# Step 3: Select only successful payments
successful_payments = payments_df[
    payments_df["payment_status"] == "SUCCESS"
]

# Step 4: Prepare refund options
refund_reasons = [
    "DAMAGED_PRODUCT",
    "WRONG_PRODUCT",
    "CUSTOMER_REQUEST",
    "LATE_DELIVERY"
]

refunds = []
refund_counter = 1000

# Step 5: Generate refunds for some successful payments
for _, payment in successful_payments.iterrows():

    # Only some successful payments will receive refunds
    if random.random() > 0.20:
        continue

    refund_counter += 1

    original_amount = float(payment["payment_amount"])

    # Generate a full or partial refund
    refund_amount = round(
        original_amount * random.choice([0.25, 0.50, 1.00]), 2
    )

    refund = {
        "refund_id": f"REF{refund_counter}",
        "order_id": payment["order_id"],
        "payment_id": payment["payment_id"],
        "refund_amount": refund_amount,
        "refund_reason": random.choice(refund_reasons),
        "refund_status": random.choice(["SUCCESS", "FAILED"]),
        "refund_timestamp": "2026-11-21 12:00:00",
        "updated_at": "2026-11-21 12:00:00"
    }

    refunds.append(refund)

# Step 6: Convert to DataFrame
refunds_df = pd.DataFrame(refunds)

# Step 7: Save refunds CSV
output_folder = project_root / "data" / "historical"
output_folder.mkdir(parents=True, exist_ok=True)

output_file = output_folder / "refunds.csv"
refunds_df.to_csv(output_file, index=False)

print("Refunds CSV generated successfully!")
print("Total refunds:", len(refunds_df))

if not refunds_df.empty:
    print(
        "Successful refunds:",
        (refunds_df["refund_status"] == "SUCCESS").sum()
    )
    print(
        "Failed refunds:",
        (refunds_df["refund_status"] == "FAILED").sum()
    )
else:
    print("No refunds generated in this run.")

print("File location:", output_file)
