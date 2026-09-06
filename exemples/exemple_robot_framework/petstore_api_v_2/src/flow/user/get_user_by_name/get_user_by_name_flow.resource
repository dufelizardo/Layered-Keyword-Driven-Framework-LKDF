*** Settings ***
Library    String
Resource    ../../../pom/user/get_user_by_name/get_user_by_name_pom.resource
Resource    ../../../flow/user/create_user/create_user_flow.resource
Resource    ../../common/schema_validation_flow.resource
Resource    ../../../resource/config/schema/schema.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Seed A User For Lookup
    [Documentation]    Creates a fresh user via the Create User flow so this test has a guaranteed valid username
    ...    to look up.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${suffix}=    Generate Random String    8    [LOWER]
    ${username}=    Set Variable    lkdf_${suffix}
    ${custom_fields}=    Create Dictionary
    ...    username=${username}
    POST Create User - Status Code 200    ${custom_fields}
    RETURN    ${username}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Get User By Name - Status Code 200
    [Arguments]    ${username}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${username}' == '${EMPTY}'
        ${username}=    Seed A User For Lookup
    END
    ${response}=    Call GET Get User By Name    ${username}
    Should Be Equal As Integers    ${response.status_code}    200
    Validate Object Schema    ${response.json()}    ${USER_SCHEMA}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Get User By Name - Status Code 400
    [Arguments]    ${username}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${username}' == '${EMPTY}'
        ${username}=    Set Variable    invalid_user!!
    END
    ${response}=    Call GET Get User By Name    ${username}
    Should Be Equal As Integers    ${response.status_code}    400

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Get User By Name - Status Code 404
    [Arguments]    ${username}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${username}' == '${EMPTY}'
        ${username}=    Set Variable    nonexistent_user_999999999
    END
    ${response}=    Call GET Get User By Name    ${username}
    Should Be Equal As Integers    ${response.status_code}    404

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call GET Get User By Name
    [Documentation]    Calls the GET Get User By Name keyword from the POM.
    [Arguments]    ${username}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    GET Get User By Name    ${username}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

User - Get By Name - GET - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate Get User By Name test scenario based on the provided
    ...    HTTP status code.
    [Arguments]    ${meuUsername}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    GET Get User By Name - Status Code 200    ${meuUsername}
    ...    ELSE IF    '${meuHTTP}' == '400'    GET Get User By Name - Status Code 400    ${meuUsername}
    ...    ELSE IF    '${meuHTTP}' == '404'    GET Get User By Name - Status Code 404    ${meuUsername}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Get User By Name test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
