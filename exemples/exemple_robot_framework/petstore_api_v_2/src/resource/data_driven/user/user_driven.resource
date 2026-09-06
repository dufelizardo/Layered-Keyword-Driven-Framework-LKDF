*** Comments ***
    Swagger Petstore v2 - User data-driven dictionaries.
    Every variable is prefixed with its exact operation name to stay unique inside the shared
    config/driven/data_driven.resource aggregator namespace.
*** Variables ***
# login_user (GET /user/login) — 400: no documented rule; business rule: blank credentials are invalid
${login_user_invalid_username_400}            ${EMPTY}
${login_user_invalid_password_400}            ${EMPTY}

# get_user_by_name (GET /user/{username}) — 400: business rule (username with invalid characters), 404=User not found
${get_user_by_name_invalid_username_400}      invalid username with spaces!
${get_user_by_name_nonexistent_username_404}  nonexistent_user_999999999

# update_user (PUT /user/{username}) — same business rule above, applied to the path identifier
${update_user_invalid_username_400}           invalid username with spaces!
${update_user_nonexistent_username_404}       nonexistent_user_999999999

# delete_user (DELETE /user/{username}) — same as above
${delete_user_invalid_username_400}           invalid username with spaces!
${delete_user_nonexistent_username_404}       nonexistent_user_999999999
