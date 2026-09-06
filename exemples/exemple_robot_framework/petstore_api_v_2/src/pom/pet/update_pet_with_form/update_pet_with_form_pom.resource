*** Settings ***
Resource    ../../common/petstore_v2_common.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
${ENDPOINT}    /pet
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
POST Update Pet With Form
    [Documentation]    Sends a form-urlencoded POST request to update a pet's name/status and returns the response.
    [Arguments]    ${pet_id}    ${form_data}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Get Petstore V2 Session

    ${response}=    POST On Session
    ...    petstore_v2_session
    ...    ${BASE_URL}${ENDPOINT}/${pet_id}
    ...    data=${form_data}
    ...    expected_status=ANY

    Log    ${response.status_code}
    Log    ${response.text}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
