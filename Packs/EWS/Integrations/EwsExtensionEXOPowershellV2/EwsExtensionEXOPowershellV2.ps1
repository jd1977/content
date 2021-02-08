Import-Module ExchangeOnlineManagement

$COMMAND_PREFIX = "ews"
$INTEGRATION_ENTRY_CONTEXT = "EWS"

class ExchangeOnlinePowershellV2Client {
    [string]$url
    [System.Security.Cryptography.X509Certificates.X509Certificate2]$certificate
    [string]$organization
    [string]$app_id
    [SecureString]$password
    ExchangeOnlinePowershellV2Client(
        [string]$url,
        [string]$app_id,
        [string]$organization,
        [string]$certificate,
        [SecureString]$password
    ) {
        $this.url = $url
        $ByteArray = [System.Convert]::FromBase64String($certificate)
        $this.certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($ByteArray, $password)

        $this.organization = $organization
        $this.app_id = $app_id
    }
    CreateSession() {
        $cmd_params = @{
            "AppID"        = $this.app_id
            "Organization" = $this.organization
            "Certificate" = $this.certificate
        }
        Connect-ExchangeOnline @cmd_params -ShowBanner:$false -SkipImportSession
    }
    DisconnectSession() {
        Disconnect-ExchangeOnline -Confirm:$false
    }
    [PSObject]GetEXOCASMailbox(
        [string]$identity,
        [string]$organizational_unit,
        [string]$primary_smtp_address,
        [string]$user_principal_name,
        [int]$limit
    ) {
        $cmd_params = @{}
        if ($identity) {
            $cmd_params.Identity = $identity
        }
        if ($organizational_unit) {
            $cmd_params.OrganizationalUnit = $organizational_unit
        }
        if ($primary_smtp_address) {
            $cmd_params.PrimarySmtpAddress = $primary_smtp_address
        }
        if ($user_principal_name) {
            $cmd_params.UserPrincipalName = $user_principal_name
        }
        if ($limit -gt 0){
            return Get-EXOCASMailbox @cmd_params -ResultSize $limit
        } else
        {
            return Get-EXOCASMailbox @cmd_params -ResultSize Unlimited
        }

        <#
        .DESCRIPTION
        This cmdlet returns a variety of client access settings for one or more mailboxes.
        These settings include options for Outlook on the web, Exchange ActiveSync, POP3, and IMAP4.
        This cmdlet is available only in the Exchange Online PowerShell V2 module.

        .PARAMETER identity
        The Identity parameter specifies the mailbox you want to view.
        For the best performance, we recommend using the following values:
            * User ID or user principal name (UPN)
            * GUID

        Otherwise, you can use any value that uniquely identifies the mailbox. For example:
            * Name
            * Alias
            * Distinguished name (DN)
            * Domain\Username
            * Email address
            * LegacyExchangeDN
            * SamAccountName

        .PARAMETER organizational_unit
        The OrganizationalUnit parameter filters the results based on the object's location in Active Directory.

        .PARAMETER primary_smtp_address
        The PrimarySmtpAddress identifies the mailbox that you want to view by primary SMTP email address (for example, navin@contoso.onmicrosoft.com).
        Can't be used with user_principal_name.

        .PARAMETER user_principal_name
        The UserPrincipalName parameter identifies the mailbox that you want to view by UPN (for example, navin@contoso.onmicrosoft.com).
        Can't be used with primary_smtp_address.

        .EXAMPLE
        GetEXOCasMailbox("1254y894-feae-9yn7-a3e1-f2483a154tft")

        .OUTPUTS
        PSObject - Raw response

        .LINK
        https://docs.microsoft.com/en-us/powershell/module/exchange/get-exocasmailbox?view=exchange-ps
        #>
    }

    [PSObject]GetEXOMailbox(
        [string]$identity,
        [int]$limit
    ) {
        $cmd_params = @{}
        if ($identity) {
            $cmd_params.Identity = $identity
        }
        if ($limit -gt 0){
            return Get-EXOMailbox @cmd_params -ResultSize $limit
        } else
        {
            return Get-EXOMailbox @cmd_params -ResultSize Unlimited
        }
        <#
        .DESCRIPTION
        Use the Get-EXOMailbox cmdlet to view mailbox objects and attributes,
        populate property pages, or supply mailbox information to other tasks.
        This cmdlet is available only in the Exchange Online PowerShell V2 module

        .PARAMETER identity
        The Identity parameter specifies the mailbox you want to view.
        For the best performance, we recommend using the following values:
            * User ID or user principal name (UPN)
            * GUID

        Otherwise, you can use any value that uniquely identifies the mailbox. For example:
            * Name
            * Alias
            * Distinguished name (DN)
            * Domain\Username
            * Email address
            * LegacyExchangeDN
            * SamAccountName

        .EXAMPLE
        GetEXOMailbox("1254y894-feae-9yn7-a3e1-f2483a154tft")

        .OUTPUTS
        PSObject - Raw response

        .LINK
        https://docs.microsoft.com/en-us/powershell/module/exchange/get-exomailbox?view=exchange-ps
        #>
    }

    [PSObject]GetEXOMailboxPermission(
        [string]$identity
    ) {
        # Import and Execute command
        $cmd_params = @{}
        if ($identity) {
            $cmd_params.Identity = $identity
        }
        return Get-EXOMailboxPermission @cmd_params
        <#
        .DESCRIPTION
        View information about SendAs permissions that are configured for users.
        This command is available only in the Exchange Online PowerShell V2 module.

        .PARAMETER identity
        The Identity parameter the user that you want to view. You can use any value that uniquely identifies the user

        .EXAMPLE
        GetEXOMailboxPermission("1254y894-feae-9yn7-a3e1-f2483a154tft")

        .OUTPUTS
        PSObject - Raw response

        .LINK
        https://docs.microsoft.com/en-us/powershell/module/exchange/get-exomailboxpermission?view=exchange-ps
        #>
    }
    [PSObject]GetEXORecipientPermission(
        [string]$identity,
        [int]$limit
    ) {
        $cmd_params = @{}
        if ($identity) {
            $cmd_params.Identity = $identity
        }
        if ($limit -gt 0){
            return Get-EXORecipientPermission @cmd_params -ResultSize $limit
        }
        else
        {
            return Get-EXORecipientPermission @cmd_params -ResultSize Unlimited
        }
        <#
        .DESCRIPTION
        Use the Get-EXORecipientPermission cmdlet to view information about SendAs permissions that are
        configured for users in a cloud-based organization.
        This command is available only in the Exchange Online PowerShell V2 module

        .PARAMETER identity
        The Identity parameter specifies the mailbox you want to view.
        For the best performance, we recommend using the following values:
            * User ID or user principal name (UPN)
            * GUID

        Otherwise, you can use any value that uniquely identifies the mailbox. For example:
            * Name
            * Alias
            * Distinguished name (DN)
            * Domain\Username
            * Email address
            * LegacyExchangeDN
            * SamAccountName
        #>
    }
        [PSObject]GetEXORecipient(
        [string]$identity,
        [int]$limit
    )
        {
            $cmd_params = @{ }
            if ($identity)
            {
                $cmd_params.Identity = $identity
            }
            if ($limit -gt 0)
            {
                return Get-EXORecipient @cmd_params -ResultSize $limit
            }
            else
            {
                return Get-EXORecipient @cmd_params -ResultSize Unlimited
            }
            <#
            .DESCRIPTION
            Use the Get-ExORecipient cmdlet to view existing recipient objects in your organization.
            This cmdlet returns all mail-enabled objects (for example,
            mailboxes, mail users, mail contacts, and distribution groups).

            #>
        }
}

function GetEXORecipientCommand {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][ExchangeOnlinePowershellV2Client]$client,
        [hashtable]$kwargs
    )
    $identity = $kwargs.identity
    $limit = $kwargs.limit -as [int]
    $raw_response = $client.GetEXORecipient($identity, $limit)
    $human_readable = TableToMarkdown $raw_response "Results of $command"
    $entry_context = @{"$script:INTEGRATION_ENTRY_CONTEXT.Recipient(obj.Guid === val.Guid)" = $raw_response }
    return Write-Output $human_readable, $entry_context, $raw_response
}

function GetEXORecipientPermissionCommand {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][ExchangeOnlinePowershellV2Client]$client,
        [hashtable]$kwargs
    )
    $identity = $kwargs.identity
    $limit = $kwargs.limit -as [int]
    $raw_response = $client.GetEXORecipientPermission($identity, $limit)
    $human_readable = TableToMarkdown $raw_response "Results of $command"
    $entry_context = @{"$script:INTEGRATION_ENTRY_CONTEXT.RecipientPermission(obj.Guid === val.Guid)" = $raw_response }
    return Write-Output $human_readable, $entry_context, $raw_response
}
function GetEXOMailBoxPermissionCommand {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][ExchangeOnlinePowershellV2Client]$client,
        [hashtable]$kwargs
    )
    $identity = $kwargs.identity
    $raw_response = $client.GetEXOMailBoxPermission($identity)
    $human_readable = TableToMarkdown $raw_response "Results of $command"
    $entry_context = @{
        "$script:INTEGRATION_ENTRY_CONTEXT.MailboxPermission(obj.Identity === val.Identity)" = @{
            "Identity" = $identity
            "Permission" = $raw_response
        }
    }
    return Write-Output $human_readable, $entry_context, $raw_response
}
function GetEXOMailBoxCommand {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][ExchangeOnlinePowershellV2Client]$client,
        [hashtable]$kwargs
    )
    $identity = $kwargs.identity
    $limit = $kwargs.limit -as [int]
    $raw_response = $client.GetEXOMailBox($identity, $limit)
    $human_readable = TableToMarkdown $raw_response "Results of $command"
    $entry_context = @{
        "$script:INTEGRATION_ENTRY_CONTEXT.Mailbox(obj.Guid === val.Guid)" = $raw_response }
    return Write-Output $human_readable, $entry_context, $raw_response
}
function GetEXOCASMailboxCommand {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ExchangeOnlinePowershellV2Client]$client,
        [hashtable]$kwargs
    )
    $identity = $kwargs.identity
    $organizational_unit = $kwargs.organizational_unit
    $primary_smtp_address = $kwargs.primary_smtp_address
    $user_principal_name = $kwargs.user_principal_name
    $limit = $kwargs.limit -as [int]
    $raw_response = $client.GetEXOCASMailbox(
            $identity, $organizational_unit, $primary_smtp_address, $user_principal_name, $limit
    )
    $human_readable = TableToMarkdown $raw_response "Results of $command"
    $entry_context = @{"$script:INTEGRATION_ENTRY_CONTEXT.CASMailbox(obj.Guid === val.Guid)" = $raw_response }
    return Write-Output $human_readable, $entry_context, $raw_response
}
function TestModuleCommand(){
    Get-EXOMailbox
    $demisto.results("ok")
}
function Main {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
    $command = $demisto.GetCommand()
    $command_arguments = $demisto.Args()
    $integration_params = [Hashtable] $demisto.Params()

    if ($integration_params.certificate.password){
        $password = ConvertTo-SecureString $integration_params.certificate.password -AsPlainText -Force
    }
    else {
        $password = $null
    }

    $exo_client = [ExchangeOnlinePowershellV2Client]::new(
            $integration_params.url,
            $integration_params.app_id,
            $integration_params.organization,
            $integration_params.certificate.identifier,
            $password
            )
    try {
        # Creating ExchangeOnline client
        $exo_client.CreateSession()
        # Executing command
        $Demisto.Debug("Command being called is $Command")
        switch ($command) {
            "test-module" {
                ($human_readable, $entry_context, $raw_response) = TestModuleCommand
            }
            "$script:COMMAND_PREFIX-cas-mailbox-list" {
                ($human_readable, $entry_context, $raw_response) = GetEXOCASMailboxCommand $exo_client $command_arguments
            }
            "$script:COMMAND_PREFIX-mailbox-list" {
                ($human_readable, $entry_context, $raw_response) = GetEXOMailBoxCommand $exo_client $command_arguments
            }
            "$script:COMMAND_PREFIX-mailbox-permission-list" {
                ($human_readable, $entry_context, $raw_response) = GetEXOMailBoxPermissionCommand $exo_client $command_arguments
            }
            "$script:COMMAND_PREFIX-recipient-permission-get" {
                ($human_readable, $entry_context, $raw_response) = GetEXORecipientPermissionCommand $exo_client $command_arguments
            }
            "$script:COMMAND_PREFIX-recipient-list" {
                ($human_readable, $entry_context, $raw_response) = GetEXORecipientCommand $exo_client $command_arguments
            }
            default {
                ReturnError "Could not recognize $command"
            }
        }
        # Return results to Demisto Server
        ReturnOutputs $human_readable $entry_context $raw_response
    }
    catch {
        $Demisto.debug(
            "Integration: $script:INTEGRATION_NAME
        Command: $command
        Arguments: $($command_arguments | ConvertTo-Json)
        Error: $($_.Exception.Message)"
        )
        if ($command -ne "test-module") {
            ReturnError "Error:
            Integration: $script:INTEGRATION_NAME
            Command: $command
            Arguments: $($command_arguments | ConvertTo-Json)
            Error: $($_.Exception)"
        }
        else {
            ReturnError $_.Exception.Message
        }
    }
    finally {
        $exo_client.DisconnectSession()
    }
}

# Execute Main when not in Tests
if ($MyInvocation.ScriptName -notlike "*.tests.ps1" -AND -NOT $Test) {
    Main
}
