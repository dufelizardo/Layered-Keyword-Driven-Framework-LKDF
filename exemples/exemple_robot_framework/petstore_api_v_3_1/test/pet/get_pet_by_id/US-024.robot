*** Settings ***
Resource    ../../../src/scenario/pet/get_pet_by_id/get_pet_by_id_scenario.resource
Resource    ../../../src/resource/config/driven/data_driven.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-024
Metadata    Test Suite Description        This test suite validates the GET pet by id endpoint of the Petstore OpenAPI 3.1 API.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               GET    GetPetById    PetstoreAPIv31    US-024
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-024: Validate GET Get Pet By Id - HTTP 200 OK
    [Documentation]    Test case to validate the GET pet by id endpoint with HTTP 200 OK response.
    [Tags]    GET    GetPetById    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - GET BY ID - GET    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-002 - US-024: Validate GET Get Pet By Id - HTTP 400 BAD REQUEST
    [Documentation]    Test case to validate the GET pet by id endpoint with HTTP 400 BAD REQUEST response
    ...    (petId=1 violates the documented exclusiveMinimum=1 boundary).
    [Tags]    GET    GetPetById    HTTP400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - GET BY ID - GET    ${get_pet_by_id_invalid_id_400}    400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-003 - US-024: Validate GET Get Pet By Id - HTTP 404 NOT FOUND
    [Documentation]    Test case to validate the GET pet by id endpoint with HTTP 404 NOT FOUND response.
    [Tags]    GET    GetPetById    HTTP404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - GET BY ID - GET    ${get_pet_by_id_nonexistent_id_404}    404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
