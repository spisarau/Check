Import-Module ActiveDirectory
function Check-UPN {
 
[CmdletBinding()]
Param(
    [parameter(Mandatory=$true)]
    [ValidatePattern('[A-Za-z0-9.]*@[A-Za-z0-9.]*')]
    [String]$UPN,
    [parameter(Mandatory=$false)]
   
    [bool]$CheckExchangeAttributes=$true
    );
    
     $exception="exception"
     $left="{";
     $right="}";
     $body="";
    try{
    
    
    $gc=[system.directoryservices.activedirectory.forest]::GetCurrentForest().Name+':3268';
    [Microsoft.ActiveDirectory.Management.ADUser]$adUser=$(Get-ADUser -Filter {userPrincipalName -Like $UPN} -Server $gc);
 
    #Check if user exist
    if ($adUser -eq $null) {return "$left`"$exception`":`"User not found`"$right"; };
    Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn   
    Set-ADServerSettings -ViewEntireForest $true
    $i=$adUser.PropertyCount;
    
    foreach ($name in $adUser.PropertyNames ){
         $i--;
         $body="${body}`"${name}`":`"$($adUser.$name.ToString())`"$(if($i -ne 0) {","})" }
    
    #Check is CheckExchangeAttributes enabled
    if ( $CheckExchangeAttributes -eq $false ) {
        return "${left}${body}${right}";}
    
    #Check is Mailbox created
    $mailbox=$(Get-Mailbox -Filter {userPrincipalName -Like $UPN})
    $mailboxstat=$(Get-MailboxStatistics $UPN)
    
    if ($mailbox -eq $null) { return "${left}${body}${right}"; };
    
   
    $primaryMail=$mailbox.PrimarySmtpAddress.ToString();
    $body="${body},`"Alias`":`"$($mailbox.Alias.ToString())`"," ;
    $body="${body}`"ServerName`":`"$($mailbox.ServerName.ToString())`"," ;
    $body="${body}`"ProhibitSendQuota`":`"$($mailbox.ProhibitSendQuota.ToString())`",";
    $body="${body}`"DisplayName`":`"$(if($mailboxstat.DisplayName -ne $null){$mailboxstat.DisplayName.ToString()})`",";
    $body="${body}`"ItemCount`":`"$($mailboxstat.ItemCount.ToString())`",";
    $body="${body}`"StorageLimitStatus`":`"$(if($mailboxstat.StorageLimitStatus -ne $null){$mailboxstat.StorageLimitStatus.ToString()})`",";
    $body="${body}`"LastLogonTime`":`"$($mailboxstat.LastLogonTime.ToString())`",";
    $body="${body}`"IsInAcceptedDomain`":`"$(IsInAcceptedDomain($mailbox.PrimarySmtpAddress.ToString()).ToString())`"";

    return "${left}${body}${right}";
    }
    catch {return "$left`"$exception`":`"$_`"$right";}
}

function IsInAcceptedDomain {
Param(
    [parameter(Mandatory=$true)]
    [String]$UPN
)
 $acceptedDomains=$(Get-AcceptedDomain)
 $index=$($UPN.IndexOf('@')+1);
 $upnDomain=$UPN.Substring($index);
 foreach($acceptedDomain in $acceptedDomains)
 {
 if($acceptedDomain.DomainName.ToString() -eq $upnDomain)
 {return $true;}

 }
 return $false;
}

Export-ModuleMember -Function Check-UPN