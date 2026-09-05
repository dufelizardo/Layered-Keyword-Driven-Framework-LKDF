*** Settings ***
Resource    ../../flow/put/put_petstore_flow.resource
Resource    ../../pom/put/put_petstore_pom.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
PET - UPDATE - PUT 
    [Documentation]    Cenário de teste para o endpoint de atualização de Pet. 
    [Arguments]    ${meuPet}    ${meuHTTP} 
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${campos}=    Create Dictionary 
    ...    id=${meuPet['id']} 
    ...    category=${meuPet['category']} 
    ...    name=${meuPet['name']} 
    ...    photoUrls=${meuPet['photoUrls']} 
    ...    tags=${meuPet['tags']} 
    ...    status=${meuPet['status']} 
    ...    availableInstances=${meuPet['availableInstances']} 
    ...    petDetailsId=${meuPet['petDetailsId']} 
    ...    petDetails=${meuPet['petDetails']} 
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${payload_data}=    Build Flexible Update Pet PUT Payload    ${campos} 
    ${json_payload_pet}=     Evaluate    json.dumps(${payload_data})    json 
    Log To Console    Payload Montado: ${json_payload_pet} 
    Set Global Variable    ${json_payload_pet} 
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    ${meuPet['${meuHTTP}']} == 200    PUT Update Pet    ${meuPet['payload']}
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════