# Script to disable M365 Services in PowerShell

clear

###############################################################################

# VARIABLES TO CHANGE   # M365x612603:ENTERPRISEPREMIUM is E5   # M365x612603:ENTERPRISEPACK is E3
$skuid = "M365x612603:ENTERPRISEPREMIUM"

# To pull the list and save it in a variable for the script containing only the UPN of the users to work with
$users = Get-Content -Path "C:\Users\PowerShell User Management\FILENAME.csv"

###############################################################################

$Continue = 1

DO
{


    # Display Licensing Summary
    echo "SCRIPT TO MANAGE O365 SERVICES"

    # Define service to Work with

    echo "Select which one of the following services you want to disable:"
    echo " "
    echo "##############################################################"
    echo " "
    echo "For Exchange Online (Plan 2) enter EXCHANGE_S_STANDARD"
    echo "For SharePoint Online (Plan 2) enter SHAREPOINTENTERPRISE"
    echo "For Office ProPlus enter OFFICESUBSCRIPTION"
    echo "For Yammer enter YAMMER_ENTERPRISE"
    echo "For Microsoft Teams enter TEAMS1"
    echo " "
    echo "##############################################################"
    echo " "

    $disableplan = Read-Host -Prompt 'Enter Selection: '

    echo "The service plan selected is: "
    echo $disableplan

    #$disableplan = "YAMMER_ENTERPRISE"
    $Continue = Read-Host -Prompt 'Do you want to continue? Yes press 1, To EXIT press 0: '




    ###############################################################################

    # ACTIONS TO PERFORM MENU

    IF ($Continue -eq "1")
        {

        echo "Select which of the following actions you would like to perform:"
        echo " "
        echo "##############################################################"
        echo " "
        echo "For Current Status of the service | Press 1"
        echo "For Disabling the service         | Press 2"
        echo "For Enabling the service          | Press 3"
        echo "To Details on specific user       | Press 4"
        echo "To Exit                           | Press 0" 
        echo " "
        echo "##############################################################"
        echo " "

        $Continue = Read-Host -Prompt 'Enter Selection: '

        }
        ELSE {}

    ###############################################################################

    # TO SHOW STATUS OF THE USERS

    IF($Continue -eq "1")
        {
        foreach ($user in $users)
        {   
            $usuario = Get-MsolUser -UserPrincipalName $user
            foreach($licencia in $usuario.Licenses)
                {
                    foreach($servSta in $licencia.ServiceStatus)
                    {
                        IF($servSta.ServicePlan.ServiceName -eq $disableplan)
                            {

                            ###############################################################################
                            echo ===================================
                            echo $usuario.UserPrincipalName
                            #(Get-MsolUser -UserPrincipalName $usuario.UserPrincipalName).Licenses.ServiceStatus
                            #echo $servSta.ServicePlan
                            echo $servSta.ServicePlan.ServiceType
                            echo $servSta.ProvisioningStatus
                            echo ===================================
                            ###############################################################################
                    
                            }
                            ELSE {}

                
                    }
                }
        }
        }
        ELSE {}

    ###############################################################################

    # TO DISABLE A SERVICE 

    IF($Continue -eq "2")
        {
        foreach ($user in $users)
        {   
            $usuario = Get-MsolUser -UserPrincipalName $user
            foreach($licencia in $usuario.Licenses)
                {
                    foreach($servSta in $licencia.ServiceStatus)
                    {
                        IF($servSta.ServicePlan.ServiceName -eq $disableplan)
                            {

                            ###############################################################################
                    
                            IF($servSta.ProvisioningStatus -eq "Success")
                                {
                        
                                ###############################################################################

                                # TO DISABLE A SERVICE 

                                $LO = New-MsolLicenseOptions -AccountSkuId $skuid -DisabledPlans $disableplan
                                Set-MsolUserLicense -UserPrincipalName $usuario.UserPrincipalName -LicenseOptions $LO
                   
                                ###############################################################################

                                echo ===================================
                                echo $usuario.UserPrincipalName
                                #(Get-MsolUser -UserPrincipalName $usuario.UserPrincipalName).Licenses.ServiceStatus
                                #echo $servSta.ServicePlan
                                echo $servSta.ServicePlan.ServiceType
                                echo "Service Disable Successfully"
                                #echo $servSta.ProvisioningStatus
                                echo ===================================
                                ###############################################################################

                                }
                                ELSE {

                                echo $usuario.UserPrincipalName
                                echo $servSta.ServicePlan.ServiceType
                                echo "Service already Disable"

                                }
                    
                    
                            }
                            ELSE {}

                
                    }
                }
        }
        }
        ELSE {}

    ###############################################################################



    ###############################################################################

    # TO ENABLE A SERVICE 


    IF($Continue -eq "3")
        {
        foreach ($user in $users)
        {   
            $usuario = Get-MsolUser -UserPrincipalName $user
            foreach($licencia in $usuario.Licenses)
                {
                    foreach($servSta in $licencia.ServiceStatus)
                    {
                        IF($servSta.ServicePlan.ServiceName -eq $disableplan)
                            {

                            ###############################################################################
                    
                            IF($servSta.ProvisioningStatus -eq "Disable")
                                {
                        
                                ###############################################################################

                                # TO DISABLE A SERVICE 

                                $LO = New-MsolLicenseOptions -AccountSkuId $skuid
                                Set-MsolUserLicense -UserPrincipalName $usuario.UserPrincipalName -LicenseOptions $LO
                   
                                ###############################################################################

                                echo ===================================
                                echo $usuario.UserPrincipalName
                                #(Get-MsolUser -UserPrincipalName $usuario.UserPrincipalName).Licenses.ServiceStatus
                                #echo $servSta.ServicePlan
                                echo "Service Enable Successfully"
                                echo $servSta.ServicePlan.ServiceType
                                #echo $servSta.ProvisioningStatus
                                echo ===================================
                                ###############################################################################

                                }
                                ELSE {

                                echo $usuario.UserPrincipalName
                                echo $servSta.ServicePlan.ServiceType
                                echo "Service already Enable"

                                }
                    
                    
                            }
                            ELSE {}

                
                    }
                }
        }
        }
        ELSE {}

    ###############################################################################
    

    # TO SHOW STATUS OF THE USERS

    IF ($Continue -eq "4")
        {
        
        $user = Read-Host -Prompt 'Enter the User Principal Name: '
        $display_user = (Get-MsolUser -UserPrincipalName $user).Licenses.ServiceStatus
        echo "The user $user licensing details are: " 
        echo $display_user | ft
        }
        ELSE {}

    ###############################################################################



    IF ($Continue -ne "0")

        {

        $Continue = Read-Host -Prompt 'Do you want to perform other action ( Yes press 1, To EXIT press 0 )'

        }
        ELSE {}


} While ($Continue -ne "0")

Echo "Exiting Script..."
