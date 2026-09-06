*** Settings ***
Resource    ../../common/petstore_v2_common.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
${ENDPOINT}    /user/login
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
GET Login User
    [Documentation]    Sends a GET request to log a user into the system and returns the response.
    [Arguments]    ${username}    ${password}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Get Petstore V2 Session

    ${params}=    Create Dictionary
    ...    username=${username}
    ...    password=${password}

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
