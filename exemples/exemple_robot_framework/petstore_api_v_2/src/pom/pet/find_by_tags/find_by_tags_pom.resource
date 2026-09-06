*** Settings ***
Resource    ../../common/petstore_v2_common.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
${ENDPOINT}    /pet/findByTags
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
GET Find Pets By Tags
    [Documentation]    Sends a GET request to find pets by tags and returns the response.
    [Arguments]    ${tags_list}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Get Petstore V2 Session

    ${params}=    Create Dictionary
    ...    tags=${tags_list}

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
