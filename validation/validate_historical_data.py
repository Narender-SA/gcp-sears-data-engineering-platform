
from pathlib import Path
import pandas as pd


# Get the project root directory
PROJECT_ROOT = Path(__file__).resolve().parents[1]

# Location of historical CSV files
DATA_FOLDER = PROJECT_ROOT / "data" / "historical"


# Expected columns, primary keys, and mandatory fields
DATASETS = {
    "customers.csv": {
        "columns": [
            "customer_id", "customer_name", "email", "phone",
            "city", "state", "region", "registration_date",
            "updated_at", "is_deleted"
        ],
        "primary_key": "customer_id",
        "required": ["customer_id"]
    },

    "products.csv": {
        "columns": [
            "product_id", "product_name", "category", "brand",
            "list_price", "updated_at", "is_active"
        ],
        "primary_key": "product_id",
        "required": ["product_id"]
    },

    "orders.csv": {
        "columns": [
            "order_id", "customer_id", "order_timestamp",
            "order_status", "shipping_city", "shipping_state",
            "region", "currency", "created_at", "updated_at",
            "is_deleted"
        ],
        "primary_key": "order_id",
        "required": ["order_id", "customer_id"]
    },

    "order_items.csv": {
        "columns": [
            "order_item_id", "order_id", "product_id", "quantity",
            "unit_price_at_purchase", "discount_percent", "updated_at"
        ],
        "primary_key": "order_item_id",
        "required": ["order_item_id", "order_id", "product_id"]
    },

    "payments.csv": {
        "columns": [
            "payment_id", "order_id", "attempt_number",
            "payment_method", "payment_amount", "payment_status",
            "transaction_timestamp", "updated_at"
        ],
        "primary_key": "payment_id",
        "required": ["payment_id", "order_id"]
    },

    "shipments.csv": {
        "columns": [
            "shipment_id", "order_id", "carrier", "shipped_at",
            "delivered_at", "delivery_status", "updated_at"
        ],
        "primary_key": "shipment_id",
        "required": ["shipment_id", "order_id"]
    },

    "refunds.csv": {
        "columns": [
            "refund_id", "order_id", "payment_id", "refund_amount",
            "refund_reason", "refund_status", "refund_timestamp",
            "updated_at"
        ],
        "primary_key": "refund_id",
        "required": ["refund_id", "order_id", "payment_id"]
    },

    "order_events.csv": {
        "columns": [
            "event_id", "order_id", "old_status", "new_status",
            "event_timestamp", "source_updated_at"
        ],
        "primary_key": "event_id",
        "required": ["event_id", "order_id"]
    }
}


def validate_dataset(filename, config):

    file_path = DATA_FOLDER / filename

    print("\n" + "=" * 60)
    print(f"VALIDATING: {filename}")
    print("=" * 60)

    # Check 1: File availability
    if not file_path.exists():
        print("FAIL: File does not exist")
        return

    print("PASS: File exists")

    # Read CSV file
    df = pd.read_csv(file_path)

    print(f"Total records: {len(df)}")

    # Check 2: Schema validation
    missing_columns = [
        column for column in config["columns"]
        if column not in df.columns
    ]

    if missing_columns:
        print(f"FAIL: Missing columns: {missing_columns}")
    else:
        print("PASS: All expected columns are present")

    # Check 3: Primary-key validation
    primary_key = config["primary_key"]

    if primary_key in df.columns:

        null_keys = df[primary_key].isna().sum()
        duplicate_keys = df[primary_key].duplicated().sum()

        if null_keys == 0:
            print(f"PASS: No missing values in {primary_key}")
        else:
            print(f"FAIL: {null_keys} missing {primary_key} values")

        if duplicate_keys == 0:
            print(f"PASS: No duplicate values in {primary_key}")
        else:
            print(f"FAIL: {duplicate_keys} duplicate {primary_key} values")

    else:
        print(f"SKIP: Cannot validate missing or duplicate {primary_key} values")

    # Check 4: Mandatory-field validation
    for column in config["required"]:

        if column not in df.columns:
            print(f"SKIP: {column} is missing from the schema")
            continue

        missing_values = df[column].isna().sum()

        if missing_values == 0:
            print(f"PASS: No missing values in {column}")
        else:
            print(f"FAIL: {missing_values} missing values in {column}")


def validate_foreign_keys():

    print("\n" + "=" * 60)
    print("REFERENTIAL INTEGRITY VALIDATION")
    print("=" * 60)

    relationships = [
        ("orders.csv", "customer_id", "customers.csv", "customer_id"),

        ("order_items.csv", "order_id", "orders.csv", "order_id"),
        ("order_items.csv", "product_id", "products.csv", "product_id"),

        ("payments.csv", "order_id", "orders.csv", "order_id"),

        ("shipments.csv", "order_id", "orders.csv", "order_id"),

        ("refunds.csv", "order_id", "orders.csv", "order_id"),
        ("refunds.csv", "payment_id", "payments.csv", "payment_id"),

        ("order_events.csv", "order_id", "orders.csv", "order_id")
    ]

    for child_file, child_column, parent_file, parent_column in relationships:

        child_path = DATA_FOLDER / child_file
        parent_path = DATA_FOLDER / parent_file

        # Check that both files exist
        if not child_path.exists() or not parent_path.exists():
            print(f"SKIP: {child_file} -> {parent_file}: file missing")
            continue

        # Read both datasets as strings for ID comparison
        child_df = pd.read_csv(child_path, dtype=str)
        parent_df = pd.read_csv(parent_path, dtype=str)

        # Check that the required columns exist
        if child_column not in child_df.columns:
            print(f"SKIP: {child_file} is missing {child_column}")
            continue

        if parent_column not in parent_df.columns:
            print(f"SKIP: {parent_file} is missing {parent_column}")
            continue

        # Collect valid parent IDs
        parent_ids = set(parent_df[parent_column].dropna())

        # Find child records whose IDs do not exist in parent
        invalid_records = child_df[
            child_df[child_column].notna()
            & ~child_df[child_column].isin(parent_ids)
        ]

        invalid_count = len(invalid_records)

        if invalid_count == 0:
            print(
                f"PASS: {child_file}.{child_column} "
                f"-> {parent_file}.{parent_column}"
            )
        else:
            print(
                f"FAIL: {invalid_count} invalid references "
                f"in {child_file}.{child_column}"
            )

            print(
                "Invalid IDs:",
                invalid_records[child_column].drop_duplicates().head(5).tolist()
            )


def main():

    print("\nSEARS DATA QUALITY VALIDATION")
    print("Historical Data Validation Started")

    for filename, config in DATASETS.items():
        validate_dataset(filename, config)
        validate_foreign_keys()

    print("\n" + "=" * 60)
    print("HISTORICAL DATA VALIDATION COMPLETED")
    print("=" * 60)


if __name__ == "__main__":
    main()
