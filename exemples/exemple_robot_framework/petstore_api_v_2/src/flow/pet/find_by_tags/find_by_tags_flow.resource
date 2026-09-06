*** Settings ***
Resource    ../../../pom/pet/find_by_tags/find_by_tags_pom.resource
Resource    ../../common/schema_validation_flow.resource
Resource    ../../../resource/config/schema/schema.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Build Find Pets By Tags Params
    [Documentation]    Builds the list of tag values used to query pets by tags.
    [Arguments]    ${custom_tags}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    $custom_tags == ''
        ${tags_list}=    Create List    string
    ELSE
        ${tags_list}=    Set Variable    ${custom_tags}
    END
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    RETURN    ${tags_list}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Find Pets By Tags - Status Code 200
    [Arguments]    ${custom_tags}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${tags_list}=    Build Find Pets By Tags Params    ${custom_tags}
    ${response}=    Call GET Find Pets By Tags    ${tags_list}
    Should Be Equal As Integers    ${response.status_code}    200
    Validate Array Schema    ${response.json()}    ${PET_SCHEMA}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Find Pets By Tags - Status Code 400
    [Arguments]    ${custom_tags}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${tags_list}=    Build Find Pets By Tags Params    ${custom_tags}
    ${response}=    Call GET Find Pets By Tags    ${tags_list}
    Should Be Equal As Integers    ${response.status_code}    400

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call GET Find Pets By Tags
    [Documentation]    Calls the GET Find Pets By Tags keyword from the POM.
    [Arguments]    ${tags_list}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    GET Find Pets By Tags    ${tags_list}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Pet - Find By Tags - GET - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate Find Pets By Tags test scenario based on the provided
    ...    HTTP status code.
    [Arguments]    ${meuTags}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    GET Find Pets By Tags - Status Code 200    ${meuTags}
    ...    ELSE IF    '${meuHTTP}' == '400'    GET Find Pets By Tags - Status Code 400    ${meuTags}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Find Pets By Tags test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
