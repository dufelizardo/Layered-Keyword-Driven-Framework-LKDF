*** Settings ***
Library    Browser
Resource    ../../resource/locators/Landing_page_locator/Landing_page_locator.resource
#===========================================================================================================
*** Comments ***
    AdoPet Landing Page Scenario
    This scenario is used to test the AdoPet landing page.
#===========================================================================================================
*** Keywords ***
Landing page pom - Open Browser
    [Documentation]    This keyword is used to open the browser and access the AdoPet landing page.
    #=======================================================================================================
    New Browser    chromium    headless=false
    New Page       https://adopet-frontend-cypress.vercel.app/
    #=======================================================================================================
#===========================================================================================================

Landing page pom - Verify "AdoPet" logo visibility
    [Documentation]    This keyword is used to verify that the "AdoPet" logo is visible on the landing page.
    #=======================================================================================================
    ${locator}=    Landing page locator - Verify "AdoPet" logo visibility
    Wait For Elements State    ${locator}    visible    timeout=10s
    #=======================================================================================================
#===========================================================================================================

Landing page pom - Verify "Boas-vindas!" text visibility
    [Documentation]    This keyword is used to verify that the text "Boas-vindas!" is visible on the landing page.
    #=======================================================================================================
    ${locator}=    Landing page locator - Verify "Boas-vindas!" text visibility
    Wait For Elements State    ${locator}    visible    timeout=10s
    ${text}=    Get Text    ${locator}
    Should Contain    ${text}    Boas-vindas!
    #=======================================================================================================
#===========================================================================================================

Landing page pom - Verify "Descrption" text visibility
    [Documentation]    This keyword is used to verify that the text "Descrption" is visible on the landing 
    ...    page.
    #=======================================================================================================
    ${locator}=    Landing page locator - Verify "Descrption" text visibility
    Wait For Elements State    ${locator}    visible    timeout=10s
    ${text}=    Get Text    ${locator}
    Should Contain    ${text}    Adotar pode mudar uma vida. Que tal buscar seu novo
    #=======================================================================================================
#===========================================================================================================

Landing page pom - Verify button "Ver pets disponíveis para adoção"    
    [Documentation]    This keyword is used to verify that the button "Ver pets disponíveis para adoção" is visible on the landing page.
    #=======================================================================================================
    ${locator}=    Landing page locator - Verify button "Ver pets disponíveis para adoção" visibility
    Wait For Elements State    ${locator}    visible    timeout=10s
    ${atribute}=    Get Attribute    ${locator}    href
    Should Contain    ${atribute}    /home
    #=======================================================================================================
#===========================================================================================================

Landing page pom - Verify button "Cadastrar"                           
    [Documentation]    This keyword is used to verify that the button "Cadastrar" is visible on the landing page.
    #=======================================================================================================
    ${locator}=    Landing page locator - Verify button "Cadastrar" visibility
    Wait For Elements State    ${locator}    visible    timeout=10s
    ${atribute}=    Get Attribute    ${locator}    href
    Should Contain    ${atribute}    /cadastro
    #=======================================================================================================
#===========================================================================================================

Landing page pom - Verify button "Fazer login" 
    [Documentation]    This keyword is used to verify that the button "Fazer login" is visible on the landing page.
    #=======================================================================================================
    ${locator}=    Landing page locator - Verify button "Fazer login" visibility
    Wait For Elements State    ${locator}    visible    timeout=10s
    ${atribute}=    Get Attribute    ${locator}    href
    Should Contain    ${atribute}    /login
    #=======================================================================================================
#===========================================================================================================

Landing page pom - Click button "${BUTTON_NAME_HOME}"
    [Documentation]    This keyword is used to click the button "${BUTTON_NAME_HOME}" on the landing page.
    #=======================================================================================================
    ${locator_vps}=    Landing page locator - Verify button "Ver pets disponíveis para adoção" visibility
    ${locator_c}=      Landing page locator - Verify button "Cadastrar" visibility
    ${locator_f}=      Landing page locator - Verify button "Fazer login" visibility
    Run Keyword If    '${BUTTON_NAME_HOME}' == 'Ver pets disponíveis para adoção'    Click    ${locator_vps}
    ...    ELSE IF    '${BUTTON_NAME_HOME}' == 'Cadastrar'      Click    ${locator_c}
    ...    ELSE IF    '${BUTTON_NAME_HOME}' == 'Fazer login'    Click    ${locator_f}
    ...    ELSE IF    '${BUTTON_NAME_HOME}' == '${EMPTY}'       No Operation
    ...    ELSE    Fail    Button "${BUTTON_NAME_HOME}" not found on the landing page
    #=======================================================================================================
#===========================================================================================================

Landing page pom - Verify redirection to either the adopter login/registration screen or the home page
    [Documentation]    This keyword is used to verify that the visitor is redirected to either the adopter login/registration screen or the home page.
    #=======================================================================================================
    ${locator_reg}=    Landing page locator - Verify URL login
    ${locator_login}=    Landing page locator - Verify URL registration
    ${locator_home}=         Landing page locator - Verify URL home page
    ${locator_base}=         Landing page Locator - URL base
    ${current_url}=          Get Url
    Run Keyword If    '${current_url}' == '${locator_base}'                    Log    Visitor not redirected and stays on the landing page
    ...    ELSE IF    '${current_url}' == '${locator_base}${locator_reg}'      Log    Visitor redirected to the adopter login screen
    ...    ELSE IF    '${current_url}' == '${locator_base}${locator_login}'    Log    Visitor redirected to the adopter registration screen
    ...    ELSE IF    '${current_url}' == '${locator_base}${locator_home}'     Log    Visitor redirected to the home page
    ...    ELSE    Fail    Visitor not redirected to either the adopter login/registration screen or the home page
    #=======================================================================================================
#===========================================================================================================