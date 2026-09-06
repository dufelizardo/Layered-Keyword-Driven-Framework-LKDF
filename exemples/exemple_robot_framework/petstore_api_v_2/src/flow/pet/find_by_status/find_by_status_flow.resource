*** Settings ***
Resource    ../../../pom/pet/find_by_status/find_by_status_pom.resource
Resource    ../../common/schema_validation_flow.resource
Resource    ../../../resource/config/schema/schema.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Build Find Pets By Status Params
    [Documentation]    Builds the list of status values used to query pets by status.
    [Arguments]    ${custom_status}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    $custom_status == ''
        ${status_list}=    Create List    available
    ELSE
        ${status_list}=    Set Variable    ${custom_status}
    END
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    RETURN    ${status_list}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Find Pets By Status - Status Code 200
    [Arguments]    ${custom_status}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${status_list}=    Build Find Pets By Status Params    ${custom_status}
    ${response}=    Call GET Find Pets By Status    ${status_list}
    Should Be Equal As Integers    ${response.status_code}    200
    # Known live-server issue — see KNOWN_ISSUES.md #2: some Pets on the shared public demo are missing 'name'.
    Validate Array Schema    ${response.json()}    ${PET_SCHEMA}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Find Pets By Status - Status Code 400
    [Arguments]    ${custom_status}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${status_list}=    Build Find Pets By Status Params    ${custom_status}
    ${response}=    Call GET Find Pets By Status    ${status_list}
    Should Be Equal As Integers    ${response.status_code}    400

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call GET Find Pets By Status
    [Documentation]    Calls the GET Find Pets By Status keyword from the POM.
    [Arguments]    ${status_list}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    GET Find Pets By Status    ${status_list}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Pet - Find By Status - GET - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate Find Pets By Status test scenario based on the provided
    ...    HTTP status code.
    [Arguments]    ${meuStatus}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    GET Find Pets By Status - Status Code 200    ${meuStatus}
    ...    ELSE IF    '${meuHTTP}' == '400'    GET Find Pets By Status - Status Code 400    ${meuStatus}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Find Pets By Status test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
