*** Settings ***
Resource    ../../../pom/user/login_user/login_user_pom.resource
Resource    ../../common/schema_validation_flow.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
GET Login User - Status Code 200
    [Arguments]    ${username}=${EMPTY}    ${password}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${username}' == '${EMPTY}'
        ${username}=    Set Variable    lkdf_user
    END
    IF    '${password}' == '${EMPTY}'
        ${password}=    Set Variable    Password123
    END
    ${response}=    Call GET Login User    ${username}    ${password}
    Should Be Equal As Integers    ${response.status_code}    200
    # Known live-server issue — see KNOWN_ISSUES.md #1: server returns an ApiResponse object, doc says string.
    Validate Non Empty String    ${response.json()}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Login User - Status Code 400
    [Arguments]    ${username}=${EMPTY}    ${password}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    Call GET Login User    ${username}    ${password}
    Should Be Equal As Integers    ${response.status_code}    400

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call GET Login User
    [Documentation]    Calls the GET Login User keyword from the POM.
    [Arguments]    ${username}    ${password}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    GET Login User    ${username}    ${password}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

User - Login - GET - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate Login User test scenario based on the provided HTTP
    ...    status code.
    [Arguments]    ${meuUsername}    ${meuSenha}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    GET Login User - Status Code 200    ${meuUsername}    ${meuSenha}
    ...    ELSE IF    '${meuHTTP}' == '400'    GET Login User - Status Code 400    ${meuUsername}    ${meuSenha}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Login User test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
