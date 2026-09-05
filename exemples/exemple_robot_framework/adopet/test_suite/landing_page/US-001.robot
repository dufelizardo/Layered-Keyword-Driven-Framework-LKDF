*** Settings ***
Resource    ../../src/scenario/landing_page_scenario/landing_page_scenario.resource
Resource    ../../src/resource/config/driven/data_driven.resource
#===========================================================================================================
Suite Setup   PREREQUESITE: OPEN BROWSER AND ACCESS LANDING PAGE
#===========================================================================================================
*** Comments ***
    AdoPet Landing Page Scenario
    This scenario is used to test the AdoPet landing page.
#===========================================================================================================
*** Test Cases ***
CT-001 - US-001: Verify that the AdoPet landing page is displayed correctly
    [Documentation]    This test case is used to verify that the AdoPet landing page is displayed correctly.
    [Tags]    smoke    regression
    #=======================================================================================================
    SCENARIO: HOME SCENARIO    ${lading_page_displayed_correctly}
#===========================================================================================================

CT-002 - US-001: Verify that the AdoPet Lading Page is redirected to the adopter Home
    [Documentation]    This test case is used to verify that the AdoPet Lading Page is redirected to the adopter Home.
    [Tags]    smoke    regression
    #=======================================================================================================
    SCENARIO: HOME SCENARIO    ${lading_page_redirected_to_home}
    #=======================================================================================================
#===========================================================================================================

CT-003 - US-001: Verify that the AdoPet Lading Page is redirected to the adopter Login
    [Documentation]    This test case is used to verify that the AdoPet Lading Page is redirected to the adopter Login.
    [Tags]    regression
    #=======================================================================================================
    SCENARIO: HOME SCENARIO    ${lading_page_redirected_to_login}
    #=======================================================================================================
#===========================================================================================================

CT-004 - US-001: Verify that the AdoPet Lading Page is redirected to the adopter Registration
    [Documentation]    This test case is used to verify that the AdoPet Lading Page is redirected to the adopter Registration.
    [Tags]    smoke    regression
    #=======================================================================================================
    SCENARIO: HOME SCENARIO    ${lading_page_redirected_to_registration}
    #=======================================================================================================
#===========================================================================================================