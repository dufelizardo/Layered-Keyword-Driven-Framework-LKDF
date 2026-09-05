*** Settings ***
Resource    ../../flow/landing_page_flow/landing_page_flow.resource
#===========================================================================================================
*** Comments ***
    AdoPet Landing Page Scenario
    This scenario is used to test the AdoPet landing page.
#===========================================================================================================
*** Keywords ***
PREREQUESITE: OPEN BROWSER AND ACCESS LANDING PAGE
    [Documentation]    This keyword is used to open the browser and access the AdoPet landing page.
    [Tags]    home    pre-requisite
    #=======================================================================================================
    Given that the visitor accesses the AdoPet landing page
    #=======================================================================================================
#===========================================================================================================

SCENARIO: HOME SCENARIO
    [Documentation]    This scenario is used to test the AdoPet home page.
    [Tags]    home    scenario
    [Arguments]    ${DICIONARIO}
    #=======================================================================================================
    Given the "AdoPet" logo should be visible
    Then the text "Boas-vindas!" should be visible
    And the buttons "Ver pets disponíveis para adoção", "Cadastrar" and "Fazer login" should be visible
    When the visitor clicks the button "${DICIONARIO['BUTTON_NAME_LADING_PAGE']}"
    Then the visitor should be redirected to either the adopter login/registration screen or the home page
    #=======================================================================================================
#===========================================================================================================