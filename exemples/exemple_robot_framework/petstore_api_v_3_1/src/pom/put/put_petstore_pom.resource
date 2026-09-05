*** Settings ***
Library    RequestsLibrary
#Library    JsonLibrary
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
${HOST_URL}        https://petstore3.swagger.io
${BASE_URL}        /api/v3
${ENDPOINT}        /pet
${CONTENT_TYPE}    application/json
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
PUT Update Pet
    [Documentation]    Sends a PUT request to update a pet and verifies the response.
    [Arguments]    ${payload}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Create Session    nomeapp    ${HOST_URL}    verify=False

    ${headers}=    Create Dictionary
    ...    Content-Type=${CONTENT_TYPE}

    ${response}=    PUT On Session
    ...    nomeapp
    ...    ${BASE_URL}${ENDPOINT}
    ...    json=${payload}
    ...    headers=${headers}
    ...    expected_status=ANY

    Log    ${response.status_code}
    Log    ${response.text}

    Should Be Equal As Strings    ${response.status_code}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════