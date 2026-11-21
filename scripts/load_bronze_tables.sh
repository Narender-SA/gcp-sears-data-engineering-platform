
#!/bin/bash

# SEARS - Bronze Layer Ingestion

PROJECT_ID="project-2425d17e-9385-4676-aab"
DATASET="sears_bronze"
BUCKET="sears-ecommerce-landing-20261121"
LOCATION="asia-south1"

load_csv() {
    TABLE=$1
    SCHEMA=$2

    echo "Loading ${TABLE}..."

    bq load \
        --location="${LOCATION}" \
        --source_format=CSV \
        --skip_leading_rows=1 \
        --schema="${SCHEMA}" \
        "${PROJECT_ID}:${DATASET}.${TABLE}_raw" \
        "gs://${BUCKET}/historical/${TABLE}/${TABLE}.csv"

    if [ $? -eq 0 ]; then
        echo "SUCCESS: ${TABLE}_raw loaded"
    else
        echo "FAILED: ${TABLE}_raw"
        exit 1
    fi
}

load_csv "products" \
"product_id:STRING,product_name:STRING,category:STRING,brand:STRING,list_price:STRING,updated_at:STRING,is_active:STRING"

load_csv "orders" \
"order_id:STRING,customer_id:STRING,order_timestamp:STRING,order_status:STRING,shipping_city:STRING,shipping_state:STRING,region:STRING,currency:STRING,created_at:STRING,updated_at:STRING,is_deleted:STRING"

load_csv "order_items" \
"order_item_id:STRING,order_id:STRING,product_id:STRING,quantity:STRING,unit_price_at_purchase:STRING,discount_percent:STRING,updated_at:STRING"

load_csv "payments" \
"payment_id:STRING,order_id:STRING,attempt_number:STRING,payment_method:STRING,payment_amount:STRING,payment_status:STRING,transaction_timestamp:STRING,updated_at:STRING"

load_csv "shipments" \
"shipment_id:STRING,order_id:STRING,carrier:STRING,shipped_at:STRING,delivered_at:STRING,delivery_status:STRING,updated_at:STRING"

load_csv "refunds" \
"refund_id:STRING,order_id:STRING,payment_id:STRING,refund_amount:STRING,refund_reason:STRING,refund_status:STRING,refund_timestamp:STRING,updated_at:STRING"

load_csv "order_events" \
"event_id:STRING,order_id:STRING,old_status:STRING,new_status:STRING,event_timestamp:STRING,source_updated_at:STRING"

echo "All seven Bronze tables processed."
