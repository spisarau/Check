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
    $adUser=$(Get-ADUser -Filter {userPrincipalName -Like $UPN} -Server $gc);
 
    #Check if user exists
    if ($adUser -eq $null) {return "$left`"$exception`":`"User is not found`"$right"; };
    #Getting Acces to Exchange functions
    Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn   
    #Searching in all domains in the forest
    Set-ADServerSettings -ViewEntireForest $true
    
    $i=$adUser.PropertyCount;
    
    foreach ($name in $adUser.PropertyNames ){
         $i--;
         $body="${body}`"${name}`":`"$($adUser.$name)`"$(if($i -ne 0) {","})" }
    
    #Check if CheckExchangeAttributes enabled
    $result="${left}${body}${right}";
    if ( $CheckExchangeAttributes -eq $false ) 
        {
        return "$result";
        }
    
    #Check if Mailbox created
    $mailbox=$(Get-Mailbox -Filter {userPrincipalName -Like $UPN})
    
    if ($mailbox -eq $null) { return "$result"; };
    
    $mailboxstat=$(Get-MailboxStatistics $UPN)
   
    $primaryMail=$mailbox.PrimarySmtpAddress.ToString();
    $body="${body},`"Alias`":`"$($mailbox.Alias)`"," ;
    $body="${body}`"ServerName`":`"$($mailbox.ServerName)`"," ;
    $body="${body}`"ProhibitSendQuota`":`"$($mailbox.ProhibitSendQuota)`",";
    $body="${body}`"DisplayName`":`"$($mailboxstat.DisplayName)`",";
    $body="${body}`"ItemCount`":`"$($mailboxstat.ItemCount)`",";
    $body="${body}`"StorageLimitStatus`":`"$($mailboxstat.StorageLimitStatus)`",";
    $body="${body}`"LastLogonTime`":`"$($mailboxstat.LastLogonTime)`",";
    $body="${body}`"IsInAcceptedDomain`":`"$(IsInAcceptedDomain($mailbox.PrimarySmtpAddress.ToString()).ToString())`"";

    return "$result";
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