*** Settings ***
Resource    ../../common/petstore_v2_common.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
${ENDPOINT}    /pet
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
POST Upload Pet Image
    [Documentation]    Sends a multipart POST request to upload an image for a pet and returns the response.
    [Arguments]    ${pet_id}    ${file_path}    ${additional_metadata}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Get Petstore V2 Session

    ${data}=    Create Dictionary
    ...    additionalMetadata=${additional_metadata}

    ${files}=    Create Dictionary
    ...    file=${file_path}

    ${response}=    POST On Session
    ...    petstore_v2_session
    ...    ${BASE_URL}${ENDPOINT}/${pet_id}/uploadImage
    ...    data=${data}
    ...    files=${files}
    ...    expected_status=ANY

    Log    ${response.status_code}
    Log    ${response.text}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
