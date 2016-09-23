##############################################################################
##----------------------------------------------------------------------------
## Get OpenLDAP Users and Search for User
##----------------------------------------------------------------------------
## Author: Mike Burr
##----------------------------------------------------------------------------
## Modified By: Harmik Singh Batth
## Date: 19 Sep 2016
## Version: 1.0
## Changes: 
##
##############################################################################

#Clear the scrren
Clear-host

#Main script

#Load the assemblies
[System.Reflection.Assembly]::LoadWithPartialName("System.DirectoryServices.Protocols")
[System.Reflection.Assembly]::LoadWithPartialName("System.Net")

#Connects to Ldap Server on the standard port
$strLDAPServer = "Server.Ldap.au" $Specify your Ldap server IP or FQDN
$strLDAPServerPort = "389" #Replace the Ldap port used. Possible values 389, 2389. Use 636 for https (SSL)
$c = New-Object System.DirectoryServices.Protocols.LdapConnection "$strLDAPServer:$strLDAPServerPort"
          
#Choose whether SSL is used or not
#Set session options
$c.SessionOptions.SecureSocketLayer = $false;

#Choose your Ldap version
#Possiblevalues 3 for LDAP V3 or 2 for LDAP V2 protocols
$c.SessionOptions.ProtocolVersion = 3 

# Pick Authentication type:
# Anonymous, Basic, Digest, DPA (Distributed Password Authentication),
# External, Kerberos, Msn, Negotiate, Ntlm, Sicily
$c.AuthType = [System.DirectoryServices.Protocols.AuthType]::Basic

# Gets username and password.
$user = Read-Host -Prompt "Username"
$pass = Read-Host -AsSecureString "Password"

# In case, you are looking to specify username and password inside script, uncomment following two line
# You will laso need to comment out above two lines
#$user = "cn=username,dc=ldap,dc=au" 
#$pass = "password" #Replace with password for the user

$credentials = new-object "System.Net.NetworkCredential" -ArgumentList $user,$pass

# Bind with the network credentials. Depending on the type of server,
# the username will take different forms. Authentication type is controlled
# above with the AuthType
$c.Bind($credentials);

$Basedn = 'dc=ldap,dc=dd'
$filter = "(objectClass=person)"
$scope = [System.DirectoryServices.Protocols.SearchScope]::Subtree
$attrlist = ,"*"

$r = New-Object System.DirectoryServices.Protocols.SearchRequest -ArgumentList `
                $basedn,$filter,$scope,$attrlist

#$re is a System.DirectoryServices.Protocols.SearchResponse
$re = $c.SendRequest($r);

#How many results do we have?
write-host $re.Entries.Count

foreach ($i in $re.Entries)
{
   #Do something with each entry here, such as read attributes
   $i.DistinguishedName
} 
