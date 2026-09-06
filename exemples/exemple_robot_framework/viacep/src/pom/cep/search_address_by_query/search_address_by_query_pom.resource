*** Settings ***
Resource    ../../common/viacep_common.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
GET Search Address By Query
    [Documentation]    Sends a GET request to search addresses by UF/city/street and returns the response.
    [Arguments]    ${uf}    ${city}    ${street}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Get ViaCEP Session

    ${city_encoded}=      Evaluate    urllib.parse.quote($city)      modules=urllib.parse
    ${street_encoded}=    Evaluate    urllib.parse.quote($street)    modules=urllib.parse

    ${response}=    GET On Session
    ...    viacep_session
    ...    /ws/${uf}/${city_encoded}/${street_encoded}/json/
    ...    expected_status=ANY

    Log    ${response.status_code}
    Log    ${response.text}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
