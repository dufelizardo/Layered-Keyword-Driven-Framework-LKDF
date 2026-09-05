*** Settings ***
#===========================================================================================================
*** Comments ***
    AdoPet Landing Page Scenario
    This scenario is used to test the AdoPet landing page.
#===========================================================================================================
*** Keywords ***
Landing page locator - Verify "AdoPet" logo visibility
    [Documentation]    This keyword is used to verify that the "AdoPet" logo is visible on the landing page.
    #=======================================================================================================
    ${locator}=    Set Variable    css=img[alt="Logo AdoPet"]
    RETURN    ${locator}
    #=======================================================================================================
#===========================================================================================================

Landing page locator - Verify "Boas-vindas!" text visibility
    [Documentation]    This keyword is used to verify that the text "Boas-vindas!" is visible on the landing page.
    #=======================================================================================================
    ${locator}=    Set Variable    text=Boas-vindas!
    RETURN    ${locator}
    #=======================================================================================================
#===========================================================================================================

Landing page locator - Verify "Descrption" text visibility
    [Documentation]    This keyword is used to verify that the text "Descrption" is visible on the landing page.
    #=======================================================================================================
    ${locator}=    Set Variable    xpath=//p[contains(text(),'Adotar pode mudar uma vida. Que tal buscar seu novo')]
    RETURN    ${locator}
    #=======================================================================================================
#===========================================================================================================
Landing page locator - Verify button "Ver pets disponíveis para adoção" visibility
    [Documentation]    This keyword is used to verify that the button "Ver pets disponíveis para adoção" is visible on the landing page.
    #=======================================================================================================
    ${locator}=    Set Variable    xpath=//a[contains(text(),'Ver pets disponíveis para adoção')]
    RETURN    ${locator}
    #=======================================================================================================
#===========================================================================================================

Landing page locator - Verify button "Cadastrar" visibility
    [Documentation]    This keyword is used to verify that the button "Cadastrar" is visible on the landing page.
    #=======================================================================================================
    ${locator}=    Set Variable    xpath=//a[contains(text(),'Cadastrar')]
    RETURN    ${locator}
    #=======================================================================================================
#===========================================================================================================

Landing page locator - Verify button "Fazer login" visibility
    [Documentation]    This keyword is used to verify that the button "Fazer login" is visible on the landing page.
    #=======================================================================================================
    ${locator}=    Set Variable    xpath=//a[contains(text(),'Fazer login')]
    RETURN    ${locator}
    #=======================================================================================================
#===========================================================================================================
    
Landing page locator - Verify URL login
    [Documentation]    This keyword is used to verify the current URL against the login/registration or home page URLs.
    #=======================================================================================================
    ${locator}=    Set Variable    login
    RETURN    ${locator}
    #=======================================================================================================
#===========================================================================================================

Landing page locator - Verify URL registration
    [Documentation]    This keyword is used to verify the current URL against the login/registration or home page URLs.
    #=======================================================================================================
    ${locator}=    Set Variable    cadastro
    RETURN    ${locator}
    #=======================================================================================================
#===========================================================================================================

Landing page locator - Verify URL home page
    [Documentation]    This keyword is used to verify that the current URL matches the home page URL.
    #=======================================================================================================
    ${locator}=    Set Variable    home
    RETURN    ${locator}
    #=======================================================================================================
#===========================================================================================================

Landing page Locator - URL base
    [Documentation]    This keyword is used to verify that the current URL matches the base URL.
    #=======================================================================================================
    ${locator}=    Set Variable    https://adopet-frontend-cypress.vercel.app/
    RETURN    ${locator}
    #=======================================================================================================
#===========================================================================================================