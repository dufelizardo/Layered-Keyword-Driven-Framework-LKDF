*** Settings ***
Resource    ../../../pom/user/create_users_with_list_input/create_users_with_list_input_pom.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Build Create Users With List Input Payload
    [Documentation]    Builds a list of User objects used as the list-input payload.
    [Arguments]    ${custom_list}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${user_one}=    Create Dictionary
    ...    id=0
    ...    username=lkdf_user_one
    ...    firstName=John
    ...    lastName=Doe
    ...    email=john.doe@example.com
    ...    password=Password123
    ...    phone=+55 11 90000-0000
    ...    userStatus=1
    ${user_two}=    Create Dictionary
    ...    id=0
    ...    username=lkdf_user_two
    ...    firstName=Jane
    ...    lastName=Doe
    ...    email=jane.doe@example.com
    ...    password=Password123
    ...    phone=+55 11 90000-0001
    ...    userStatus=1
    ${base_list}=    Create List    ${user_one}    ${user_two}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    $custom_list == ''
        ${payload}=    Set Variable    ${base_list}
    ELSE
        ${payload}=    Set Variable    ${custom_list}
    END
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    RETURN    ${payload}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

POST Create Users With List Input - Status Code 200
    [Arguments]    ${custom_list}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${payload}=    Build Create Users With List Input Payload    ${custom_list}
    ${response}=    Call POST Create Users With List Input    ${payload}
    Should Be Equal As Integers    ${response.status_code}    200

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call POST Create Users With List Input
    [Documentation]    Calls the POST Create Users With List Input keyword from the POM.
    [Arguments]    ${payload}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    POST Create Users With List Input    ${payload}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

User - Create With List Input - POST - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate Create Users With List Input test scenario based on
    ...    the provided HTTP status code.
    [Arguments]    ${meuLista}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    POST Create Users With List Input - Status Code 200    ${meuLista}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Create Users With List Input
    ...    test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
