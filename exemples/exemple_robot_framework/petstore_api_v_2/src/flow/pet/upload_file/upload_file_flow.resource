*** Settings ***
Library    OperatingSystem
Resource    ../../../pom/pet/upload_file/upload_file_pom.resource
Resource    ../../common/schema_validation_flow.resource
Resource    ../../../resource/config/schema/schema.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Build Upload Pet Image Fixture
    [Documentation]    Creates a throwaway image file used as the upload fixture for the uploadImage endpoint.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${fixture_dir}=    Set Variable    ${TEMPDIR}/lkdf_pet_upload
    Create Directory    ${fixture_dir}
    ${file_path}=    Set Variable    ${fixture_dir}/sample.png
    Create Binary File    ${file_path}    dummy-image-content
    RETURN    ${file_path}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

POST Upload Pet Image - Status Code 200
    [Arguments]    ${pet_id}    ${additional_metadata}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${file_path}=    Build Upload Pet Image Fixture
    ${response}=    Call POST Upload Pet Image    ${pet_id}    ${file_path}    ${additional_metadata}
    Should Be Equal As Integers    ${response.status_code}    200
    Validate Object Schema    ${response.json()}    ${API_RESPONSE_SCHEMA}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call POST Upload Pet Image
    [Documentation]    Calls the POST Upload Pet Image keyword from the POM.
    [Arguments]    ${pet_id}    ${file_path}    ${additional_metadata}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    POST Upload Pet Image    ${pet_id}    ${file_path}    ${additional_metadata}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Pet - Upload Image - POST - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate Upload Pet Image test scenario based on the provided HTTP
    ...    status code.
    [Arguments]    ${meuPetId}    ${meuMetadata}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    POST Upload Pet Image - Status Code 200    ${meuPetId}    ${meuMetadata}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Upload Pet Image test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
