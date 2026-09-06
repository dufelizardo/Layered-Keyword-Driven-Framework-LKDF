*** Settings ***
Resource    ../../../flow/user/create_users_with_list_input/create_users_with_list_input_flow.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
USER - CREATE WITH LIST INPUT - POST
    [Documentation]    Test scenario for creating users with list input (POST /user/createWithList) on the
    ...    Swagger Petstore v2 API.
    [Arguments]    ${meuLista}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    User - Create With List Input - POST - By HTTP Status Code    ${meuLista}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
