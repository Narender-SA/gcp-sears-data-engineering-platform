
from pathlib import Path
import pandas as pd

# 1. Prepare sample customer records
customers = [
    {
        "customer_id": "CUST1001",
        "customer_name": "Rahul Sharma",
        "email": "rahul@gmail.com",
        "phone": "9876543210",
        "city": "Hyderabad",
        "state": "Telangana",
        "region": "South",
        "registration_date": "2025-01-10",
        "updated_at": "2026-11-21 09:00:00",
        "is_deleted": False
    },
    {
        "customer_id": "CUST1002",
        "customer_name": "Priya Reddy",
        "email": "priya@gmail.com",
        "phone": "9876543211",
        "city": "Bengaluru",
        "state": "Karnataka",
        "region": "South",
        "registration_date": "2025-02-15",
        "updated_at": "2026-11-21 09:00:00",
        "is_deleted": False
    },
    {
        "customer_id": "CUST1003",
        "customer_name": "Amit Kumar",
        "email": "amit@gmail.com",
        "phone": "9876543212",
        "city": "Mumbai",
        "state": "Maharashtra",
        "region": "West",
        "registration_date": "2025-03-20",
        "updated_at": "2026-11-21 09:00:00",
        "is_deleted": False
    },
    {
        "customer_id": "CUST1004",
        "customer_name": "Sneha Patel",
        "email": "sneha@gmail.com",
        "phone": "9876543213",
        "city": "Ahmedabad",
        "state": "Gujarat",
        "region": "West",
        "registration_date": "2025-04-05",
        "updated_at": "2026-11-21 09:00:00",
        "is_deleted": False
    },
    {
        "customer_id": "CUST1005",
        "customer_name": "Arjun Singh",
        "email": "arjun@gmail.com",
        "phone": "9876543214",
        "city": "Delhi",
        "state": "Delhi",
        "region": "North",
        "registration_date": "2025-05-12",
        "updated_at": "2026-11-21 09:00:00",
        "is_deleted": False
    }
]

# 2. Convert Python records into a Pandas DataFrame
df = pd.DataFrame(customers)

# 3. Find the project root directory
project_root = Path(__file__).resolve().parents[2]

# 4. Create the output directory
output_folder = project_root / "data" / "historical"
output_folder.mkdir(parents=True, exist_ok=True)

# 5. Generate the CSV file
output_file = output_folder / "customers.csv"
df.to_csv(output_file, index=False)

print("Customer CSV generated successfully!")
print("Total customers:", len(df))
print("File location:", output_file)
