*** Comments ***
    Swagger Petstore v2 - Store data-driven dictionaries.
    Every variable is prefixed with its exact operation name to stay unique inside the shared
    config/driven/data_driven.resource aggregator namespace.
*** Variables ***
# place_order (POST /store/order) — 400=Invalid Order (status outside enum + business rule: negative quantity is invalid)
&{place_order_invalid_data_400}         quantity=-1    status=invalid_status_value

# get_order_by_id (GET /store/order/{orderId}) — 400=Invalid ID supplied, 404=Order not found
${get_order_by_id_invalid_id_400}       not-a-numeric-id
${get_order_by_id_nonexistent_id_404}   999999999

# delete_order (DELETE /store/order/{orderId}) — 400=Invalid ID supplied, 404=Order not found
${delete_order_invalid_id_400}          not-a-numeric-id
${delete_order_nonexistent_id_404}      999999999
