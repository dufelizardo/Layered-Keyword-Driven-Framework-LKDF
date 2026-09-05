*** Settings ***
Library    Browser
Resource    ../../pom/landing_page_pom/landing_page_pom.resource
#===========================================================================================================
*** Comments ***
    AdoPet Landing Page Flow
    This flow is used to define the steps for testing the AdoPet landing page.
#===========================================================================================================
*** Keywords ***
that the visitor accesses the AdoPet landing page
    [documentation]    This keyword is used to access the AdoPet landing page.
    #=======================================================================================================
    Landing page pom - Open Browser
    #=======================================================================================================
#===========================================================================================================
the "AdoPet" logo should be visible
    [documentation]    This keyword is used to verify that the "AdoPet" logo is visible on the landing page.
    #=======================================================================================================
    Landing page pom - Verify "AdoPet" logo visibility
    #=======================================================================================================
#===========================================================================================================
the text "Boas-vindas!" should be visible
    [documentation]    This keyword is used to verify that the text "Boas-vindas!" is visible on the landing
    ...    page.
    #=======================================================================================================
    Landing page pom - Verify "Boas-vindas!" text visibility
    Landing page pom - Verify "Descrption" text visibility
    #=======================================================================================================
#===========================================================================================================
the buttons "Ver pets disponíveis para adoção", "Cadastrar" and "Fazer login" should be visible
    #=======================================================================================================
    Landing page pom - Verify button "Ver pets disponíveis para adoção"    
    Landing page pom - Verify button "Cadastrar"                           
    Landing page pom - Verify button "Fazer login"                         
    #=======================================================================================================
#===========================================================================================================
the visitor clicks the button "${BUTTON_NAME_Landing_PAGE}"
    #=======================================================================================================
    Landing page pom - Click button "${BUTTON_NAME_Landing_PAGE}"
    #=======================================================================================================
#===========================================================================================================
the visitor should be redirected to either the adopter login/registration screen or the home page
    #=======================================================================================================
    Landing page pom - Verify redirection to either the adopter login/registration screen or the home page
    #=======================================================================================================
#===========================================================================================================