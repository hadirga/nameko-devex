#!/bin/bash

# DIR="${BASH_SOURCE%/*}"
# if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
# . "$DIR/nex-include.sh"

# to ensure if 1 command fails.. build fail
set -e

# ensure prefix is pass in
if [ $# -lt 1 ] ; then
	echo "NEX smoketest needs prefix"
	echo "nex-smoketest.sh acceptance"
	exit
fi

PREFIX=$1

# check if doing local smoke test
if [ "${PREFIX}" != "local" ]; then
    echo "Remote Smoke Test in CF"
    STD_APP_URL=${PREFIX}
else
    echo "Local Smoke Test"
    STD_APP_URL=http://localhost:8000
fi

echo STD_APP_URL=${STD_APP_URL}

# Test: Create Products
echo "=== Creating a product id: the_odyssey ==="
curl -s -XPOST  "${STD_APP_URL}/products" \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{"id": "the_odyssey", "title": "The Odyssey", "passenger_capacity": 101, "maximum_speed": 5, "in_stock": 10}' | jq .
echo
echo "=== Creating a product id: the_honda ==="
curl -s -XPOST  "${STD_APP_URL}/products" \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{"id": "the_honda", "title": "The Honda", "passenger_capacity": 101, "maximum_speed": 25, "in_stock": 8}' | jq .
echo

# Test: Get Product
echo "=== Getting product id: the_odyssey ==="
curl -s "${STD_APP_URL}/products/the_odyssey" | jq .
echo

# Test: Create Orders
echo "=== Creating Order: the_odyssey ==="
ORDER_ID=$(
    curl -s -XPOST "${STD_APP_URL}/orders" \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{"order_details": [{"product_id": "the_odyssey", "price": "100000.99", "quantity": 1}]}' 
)
echo ${ORDER_ID} | jq .
ID=$(echo ${ORDER_ID} | jq '.id')
echo
echo "=== Creating Order with two products: the_odyssey and the_honda ==="
ORDER_ID2=$(
    curl -s -XPOST "${STD_APP_URL}/orders" \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{"order_details": [{"product_id": "the_odyssey", "price": "100000.99", "quantity": 1},{"product_id": "the_honda", "price": "1200.99", "quantity": 7}]}' 
)
echo ${ORDER_ID2} | jq .
echo

# Test: Get Orders list
echo "=== Getting Orders list ==="
curl -s "${STD_APP_URL}/orders/list" | jq .
echo

# Test: Get Order back
echo "=== Getting Order back ==="
curl -s "${STD_APP_URL}/orders/${ID}" | jq .
echo

# Test: Delete Product
echo "=== Deleting product id: the_odyssey ==="
curl -s -XDELETE "${STD_APP_URL}/products/delete/the_odyssey" | jq .
echo

# Test: Get Product
echo "=== Getting product id: the_odyssey ==="
curl -s "${STD_APP_URL}/products/the_odyssey" | jq .
echo