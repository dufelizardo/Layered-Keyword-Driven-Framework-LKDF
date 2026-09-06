*** Settings ***
Resource    ../../common/petstore_v2_common.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
${ENDPOINT}    /pet/findByStatus
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
GET Find Pets By Status
    [Documentation]    Sends a GET request to find pets by status and returns the response.
    [Arguments]    ${status_list}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Get Petstore V2 Session

    ${params}=    Create Dictionary
    ...    status=${status_list}

    ${response}=    GET On Session
    ...    petstore_v2_session
    ...    ${BASE_URL}${ENDPOINT}
    ...    params=${params}
    ...    expected_status=ANY

    Log    ${response.status_code}
    Log    ${response.text}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
