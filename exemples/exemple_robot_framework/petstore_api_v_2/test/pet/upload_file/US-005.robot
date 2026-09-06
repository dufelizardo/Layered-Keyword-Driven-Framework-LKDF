*** Settings ***
Resource    ../../../src/scenario/pet/upload_file/upload_file_scenario.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-005
Metadata    Test Suite Description        This test suite validates the POST upload pet image endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               POST    UploadPetImage    PetstoreAPIv2    US-005
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-005: Validate POST Upload Pet Image - HTTP 200 OK
    [Documentation]    Test case to validate the POST upload pet image endpoint with HTTP 200 OK response.
    [Tags]    POST    UploadPetImage    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - UPLOAD IMAGE - POST    1    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
