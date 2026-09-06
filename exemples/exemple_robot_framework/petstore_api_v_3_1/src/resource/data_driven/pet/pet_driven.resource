*** Comments ***
    Swagger Petstore OpenAPI 3.1 - Pet data-driven dictionaries.
    Every variable is prefixed with its exact operation name to stay unique inside the shared
    config/driven/data_driven.resource aggregator namespace.
*** Variables ***
# update_pet (PUT /pet) — 400=Invalid ID supplied, 404=Pet not found, 405=Validation exception
&{update_pet_invalid_id_400}          id=invalid-id-format
&{update_pet_nonexistent_id_404}      id=${999999999}
&{update_pet_invalid_data_405}        name=${EMPTY}    status=invalid_status_value

# add_pet (POST /pet) — 405=Invalid input (required fields name/photoUrls violated)
&{add_pet_invalid_data_405}           name=${EMPTY}    photoUrls=${EMPTY}

# get_pet_by_id (GET /pet/{petId}) — the spec documents petId as exclusiveMinimum=1, exclusiveMaximum=10
# (only 2-9 are valid), so the negative values below are chosen to violate that documented range directly,
# rather than relying on a seeded/created pet's id (which would very likely fall outside 1-10 anyway).
${get_pet_by_id_invalid_id_400}       1
${get_pet_by_id_nonexistent_id_404}   999999999
