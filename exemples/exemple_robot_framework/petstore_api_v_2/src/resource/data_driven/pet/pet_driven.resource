*** Comments ***
    Swagger Petstore v2 - Pet data-driven dictionaries.
    Every variable is prefixed with its exact operation name to stay unique inside the shared
    config/driven/data_driven.resource aggregator namespace.
*** Variables ***
# update_pet (PUT /pet) — 400=Invalid ID supplied, 404=Pet not found, 405=Validation exception
&{update_pet_invalid_id_400}                id=invalid-id-format
&{update_pet_nonexistent_id_404}            id=999999999
&{update_pet_invalid_data_405}              name=${EMPTY}    status=invalid_status_value

# add_pet (POST /pet) — 405=Invalid input (required fields name/photoUrls violated)
&{add_pet_invalid_data_405}                 name=${EMPTY}    photoUrls=${EMPTY}

# find_by_status (GET /pet/findByStatus) — 400=Invalid status value (outside enum available|pending|sold)
@{find_by_status_invalid_value_400}         invalid_status_value

# find_by_tags (GET /pet/findByTags) — 400: no documented enum for tags; business rule: a blank tag is invalid
@{find_by_tags_invalid_value_400}           ${EMPTY}

# get_pet_by_id (GET /pet/{petId}) — 400=Invalid ID supplied (petId is not int64), 404=Pet not found
${get_pet_by_id_invalid_id_400}             not-a-numeric-id
${get_pet_by_id_nonexistent_id_404}         999999999

# update_pet_with_form (POST /pet/{petId}) — 405=Invalid input
&{update_pet_with_form_invalid_data_405}    name=${EMPTY}    status=invalid_status_value

# delete_pet (DELETE /pet/{petId}) — 400=Invalid ID supplied, 404=Pet not found
${delete_pet_invalid_id_400}                not-a-numeric-id
${delete_pet_nonexistent_id_404}            999999999
