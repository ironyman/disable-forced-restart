
function Remove-Stupid {
	Param ([string]$Path)

	if (-Not (Test-Path -Path $Path)) {
		return
	}

	$currentIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
	$objUser = New-Object System.Security.Principal.NTAccount($currentIdentity.Name)

	$colRights = [System.Security.AccessControl.FileSystemRights]'Read, Write,FullControl' 
	$InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::None 
	$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None 
	$objType = [System.Security.AccessControl.AccessControlType]::Allow 

	$objACE = New-Object System.Security.AccessControl.FileSystemAccessRule `
	    ($objUser, $colRights, $InheritanceFlag, $PropagationFlag, $objType) 

	$ACL = Get-Acl -Path $Path 
	$ACL.AddAccessRule($objACE) 
	$ACL.SetAccessRuleProtection($true, $false)
	$ACL.SetOwner($objUser)
	Set-Acl -Path $Path -AclObject $ACL

	del -Verbose $Path
}

Remove-Stupid -Path  "C:\windows\system32\MusNotification.exe"
Remove-Stupid -Path  "C:\windows\system32\MusNotificationUX.exe"