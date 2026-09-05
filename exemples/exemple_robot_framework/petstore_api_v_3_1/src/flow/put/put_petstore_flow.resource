*** Settings ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*keywords***
Build Flexible Update Pet PUT Payload
    [Documentation]    Builds a flexible PUT payload for updating a pet.
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${category}=    Create Dictionary
    ...    id=0
    ...    name=string
    ${tag}=    Create Dictionary
    ...    id=0
    ...    name=string
    ${tags}=    Create List    ${tag}
    ${photo_urls}=    Create List    string
    ${pet_details_category}=    Create Dictionary
    ...    id=0
    ...    name=string
    ${pet_details}=    Create Dictionary
    ...    id=10
    ...    category=${pet_details_category}
    ...    tag=${tag}
    ${base}=    Create Dictionary
    ...    id=0
    ...    category=${category}
    ...    name=doggie
    ...    photoUrls=${photo_urls}
    ...    tags=${tags}
    ...    status=available
    ...    availableInstances=7
    ...    petDetailsId=10
    ...    petDetails=${pet_details}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${payload}=    Evaluate    dict(${base}, **${custom_fields})
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    RETURN    ${payload}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════