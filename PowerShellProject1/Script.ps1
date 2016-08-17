#------------------------------------------------------------------------
# Source File Information (DO NOT MODIFY)
# Source ID: 52be7cc0-5586-4a88-b800-c5082abeb046
# Source File: ..\Downloads\AD Editor\AD Editor\AD Editor.psproj
#------------------------------------------------------------------------

#----------------------------------------------
#region Import Assemblies
#----------------------------------------------
[void][Reflection.Assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][Reflection.Assembly]::Load('System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][Reflection.Assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
#endregion Import Assemblies

#Define a Param block to use custom parameters in the project
#Param ($CustomParameter)

function Main {
<#
    .SYNOPSIS
        The Main function starts the project application.
    
    .PARAMETER Commandline
        $Commandline contains the complete argument string passed to the script packager executable.
    
    .NOTES
        Use this function to initialize your script and to call GUI forms.
		
    .NOTES
        To get the console output in the Packager (Forms Engine) use: 
		$ConsoleOutput (Type: System.Collections.ArrayList)
#>
	Param ([String]$Commandline)
		
	#--------------------------------------------------------------------------
	#TODO: Add initialization script here (Load modules and check requirements)
	
	
	#--------------------------------------------------------------------------
	
	if((Call-MainForm_psf) -eq 'OK')
	{
		
	}
	
	$global:ExitCode = 0 #Set the exit code for the Packager
}







#endregion Source: Startup.pss

#region Source: MainForm.psf
function Call-MainForm_psf
{
	[void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	#endregion Import Assemblies

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$MainForm = New-Object 'System.Windows.Forms.Form'
	$picturebox1 = New-Object 'System.Windows.Forms.PictureBox'
	$buttonUPLOAD = New-Object 'System.Windows.Forms.Button'
	$combobox1 = New-Object 'System.Windows.Forms.ComboBox'
	$labelSelectPicture = New-Object 'System.Windows.Forms.Label'
	$textbox1 = New-Object 'System.Windows.Forms.TextBox'
	$Browse = New-Object 'System.Windows.Forms.Button'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
		#----------------------------------------------
	do
	{
		$cred = Get-Credential #Read credentials
		$username = $cred.username
		$password = $cred.GetNetworkCredential().password
		
		#$fileSelected = ""
		
		# Get current domain using logged-on user's credentials
		$CurrentDomain = "LDAP://" + ([ADSI]"").distinguishedName
		$domain = New-Object System.DirectoryServices.DirectoryEntry($CurrentDomain, $UserName, $Password)
	} until ($domain.Name -ne $null)
	
	
	
	<#if ($domain.name -eq $null)
	{
		$OUTPUT =[System.Windows.Forms.MessageBox]::Show("Your username and password are not recognized! Do you want to try again?", "Message", 5)
		if ($OUTPUT -eq "Retry")
		{
			
			
		}
		else
		{
			exit #terminate the script
		}#>
		
		
		
		#	write-host "Authentication failed - please verify your username and password."
	#	exit #terminate the script.
	<#}else
	{
		write-host "Successfully authenticated "
	}#>
	
	if ((Get-ADUser $username -properties memberof).memberof -like "CN=AD_Edit*")
	{
		
		
		$MainForm_Load = {
			
			$MainForm.StartPosition= "CenterScreen"
			
		}
		
		$Browse_Click = {
			<#$ScriptPath = $script:MyInvocation.MyCommand.Path
			$ScriptDir = Split-Path $scriptpath
			. "$ScriptDir\BrowseFileDialog.ps1"#>
			#TODO: Place custom script here
			
			$initialDirectory = "c:\"
			[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
			$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
			$OpenFileDialog.initialDirectory = $initialDirectory
			$OpenFileDialog.filter = "All files (*.*)| *.*"
			$OpenFileDialog.ShowHelp = $true
			$OpenFileDialog.ShowDialog() | Out-Null
			#$fileSelected = $OpenFileDialog.filename
			$global:fileSelected = $OpenFileDialog.filename
			$textbox1.text = $fileSelected
			$imagepath = (Get-Item $openFileDialog.FileName)
			$image = [System.Drawing.Image]::Fromfile($imagepath)
			$picturebox1.image = $image
			
			Write-Host this is file path $fileSelected
			
		                   }
		
		}
	else
	{
		[void][System.Windows.Forms.MessageBox]::Show("You are not authorized to use this application. ", "Warning Message")
		exit
	}
	
	<#  $combobox1_Click = {
		
		Get-ADUser -Filter * | where { $_.enabled -eq $true } | select samaccountname
		
		
	}  #>
	#region Control Helper Functions
	function Load-ComboBox 
	{
	<#
		.SYNOPSIS
			This functions helps you load items into a ComboBox.
	
		.DESCRIPTION
			Use this function to dynamically load items into the ComboBox control.
	
		.PARAMETER  ComboBox
			The ComboBox control you want to add items to.
	
		.PARAMETER  Items
			The object or objects you wish to load into the ComboBox's Items collection.
	
		.PARAMETER  DisplayMember
			Indicates the property to display for the items in this control.
		
		.PARAMETER  Append
			Adds the item(s) to the ComboBox without clearing the Items collection.
		
		.EXAMPLE
			Load-ComboBox $combobox1 "Red", "White", "Blue"
		
		.EXAMPLE
			Load-ComboBox $combobox1 "Red" -Append
			Load-ComboBox $combobox1 "White" -Append
			Load-ComboBox $combobox1 "Blue" -Append
		
		.EXAMPLE
			Load-ComboBox $combobox1 (Get-Process) "ProcessName"
	#>
		Param (
			[ValidateNotNull()]
			[Parameter(Mandatory=$true)]
			[System.Windows.Forms.ComboBox]$ComboBox,
			[ValidateNotNull()]
			[Parameter(Mandatory=$true)]
			$Items,
		    [Parameter(Mandatory=$false)]
			[string]$DisplayMember,
			[switch]$Append
		)
		
		if(-not $Append)
		{
			$ComboBox.Items.Clear()	
		}
		
		if($Items -is [Object[]])
		{
			$ComboBox.Items.AddRange($Items)
		}
		elseif ($Items -is [Array])
		{
			$ComboBox.BeginUpdate()
			foreach($obj in $Items)
			{
				$ComboBox.Items.Add($obj)	
			}
			$ComboBox.EndUpdate()
		}
		else
		{
			$ComboBox.Items.Add($Items)	
		}
		
		$ComboBox.DisplayMember = $DisplayMember
		
		
	}
	#endregion
	
	
	$combobox1_Click= {
		#TODO: Place custom script here
		
		Load-ComboBox $combobox1  (Get-ADUser -Filter * | where { $_.enabled -eq $true } | select -ExpandProperty samaccountname) "samaccountname"
	}
	#else
	#{	
	#	$form1_Load
	#}
	
	
	$buttonUPLOAD_Click= {
		#TODO: Place custom script here
		$global:userselected = $combobox1.SelectedItem
		$global:photo = [byte[]](Get-Content  $global:fileSelected -Encoding byte)
		
		write-host This is the selected user -> $global:userselected
		write-host This is the selected file -> $global:fileSelected
		write-host This is the selected photo -> $global:photo
		
		if (Get-ADUser $global:userselected -Properties thumbnailphoto | where { $_.thumbnailphoto -ne $null })
		{
			Set-ADUser $global:userselected -Replace @{ thumbnailphoto = "$global:photo" } -ErrorVariable Err1 -ErrorAction Stop
			if ($Err1 -ne $null)
			{
				[System.Windows.Forms.MessageBox]::Show($Err1, "Error", 0)
			}
			else
			{
				
				$output = [System.Windows.Forms.MessageBox]::Show("You are ready.Do you want to continue?", "Message", 4)
				if ($OUTPUT -eq "YES")
				{
					$combobox1.SelectedItem = $null
					$textbox1.ResetText()
					$picturebox1.Image = $null
					
				}
				else
				{
					$MainForm.Close()
				}
			}
		}
		else
		{
			Set-ADUser $global:userselected -Add @{ thumbnailphoto = "$global:photo" } -ErrorVariable Err -ErrorAction Stop
			if ($Err -ne $null)
			{
				[System.Windows.Forms.MessageBox]::Show($Err, "Error", 0)
			}
			else
			{
				$output = [System.Windows.Forms.MessageBox]::Show("You are ready. Do you want to continue?", "Message", 4)
				if ($OUTPUT -eq "YES")
				{
					$combobox1.SelectedItem = $null
					$textbox1.ResetText()
					$picturebox1.Image = $null
					
				}
				else
				{
					$MainForm.Close()
					
					
				}
				
			} #endof endfunction
			
		} #endofelsefunction
			
			
			
		
										}
	
	
	
	
	
	
		# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$MainForm.WindowState = $InitialFormWindowState
	}
	
	$Form_StoreValues_Closing=
	{
		#Store the control values
		$script:MainForm_combobox1 = $combobox1.Text
		$script:MainForm_combobox1_SelectedItem = $combobox1.SelectedItem
		$script:MainForm_textbox1 = $textbox1.Text
	}

	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$buttonUPLOAD.remove_Click($buttonUPLOAD_Click)
			$combobox1.remove_Click($combobox1_Click)
			$Browse.remove_Click($Browse_Click)
			$MainForm.remove_Load($MainForm_Load)
			$MainForm.remove_Load($Form_StateCorrection_Load)
			$MainForm.remove_Closing($Form_StoreValues_Closing)
			$MainForm.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch [Exception]
		{ }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$MainForm.SuspendLayout()
	#
	# MainForm
	#
	$MainForm.Controls.Add($picturebox1)
	$MainForm.Controls.Add($buttonUPLOAD)
	$MainForm.Controls.Add($combobox1)
	$MainForm.Controls.Add($labelSelectPicture)
	$MainForm.Controls.Add($textbox1)
	$MainForm.Controls.Add($Browse)
	$MainForm.AutoScaleMode = 'None'
	$MainForm.AutoValidate = 'EnablePreventFocusChange'
	$MainForm.ClientSize = '842, 565'
	$MainForm.Name = 'MainForm'
	$MainForm.StartPosition = 'CenterScreen'
	$MainForm.Text = 'Main Form'
	$MainForm.add_Load($MainForm_Load)
	#
	# picturebox1
	#
	$picturebox1.Location = '121, 285'
	$picturebox1.Name = 'picturebox1'
	$picturebox1.Size = '245, 200'
	$picturebox1.SizeMode = 'StretchImage'
	$picturebox1.TabIndex = 5
	$picturebox1.TabStop = $False
	#
	# buttonUPLOAD
	#
	$buttonUPLOAD.Location = '509, 384'
	$buttonUPLOAD.Name = 'buttonUPLOAD'
	$buttonUPLOAD.Size = '160, 54'
	$buttonUPLOAD.TabIndex = 4
	$buttonUPLOAD.Text = 'UPLOAD'
	$buttonUPLOAD.UseVisualStyleBackColor = $True
	$buttonUPLOAD.add_Click($buttonUPLOAD_Click)
	#
	# combobox1
	#
	$combobox1.FormattingEnabled = $True
	$combobox1.Location = '121, 47'
	$combobox1.Name = 'combobox1'
	$combobox1.Size = '388, 21'
	$combobox1.TabIndex = 3
	$combobox1.add_Click($combobox1_Click)
	#
	# labelSelectPicture
	#
	$labelSelectPicture.Location = '77, 172'
	$labelSelectPicture.Name = 'labelSelectPicture'
	$labelSelectPicture.Size = '131, 23'
	$labelSelectPicture.TabIndex = 2
	$labelSelectPicture.Text = 'Select Picture'
	#
	# textbox1
	#
	$textbox1.Location = '42, 209'
	$textbox1.Name = 'textbox1'
	$textbox1.Size = '418, 20'
	$textbox1.TabIndex = 1
	#
	# Browse
	#
	$Browse.Location = '509, 196'
	$Browse.Name = 'Browse'
	$Browse.Size = '191, 44'
	$Browse.TabIndex = 0
	$Browse.Text = 'Browse'
	$Browse.UseVisualStyleBackColor = $True
	$Browse.add_Click($Browse_Click)
	$MainForm.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $MainForm.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$MainForm.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$MainForm.add_FormClosed($Form_Cleanup_FormClosed)
	#Store the control values when form is closing
	$MainForm.add_Closing($Form_StoreValues_Closing)
	#Show the Form
	return $MainForm.ShowDialog()

}
#endregion Source: MainForm.psf

#region Source: Globals.ps1
	#--------------------------------------------
	# Declare Global Variables and Functions here
	#--------------------------------------------
	$global:userselected = $null
	$global:fileSelected = $null
	$global:photo = $null
	
	#Sample function that provides the location of the script
	function Get-ScriptDirectory
	{
	<#
		.SYNOPSIS
			Get-ScriptDirectory returns the proper location of the script.
	
		.OUTPUTS
			System.String
		
		.NOTES
			Returns the correct path within a packaged executable.
	#>
		[OutputType([string])]
		param ()
		if ($hostinvocation -ne $null)
		{
			Split-Path $hostinvocation.MyCommand.path
		}
		else
		{
			Split-Path $script:MyInvocation.MyCommand.Path
		}
	}
	
	#function UploadPicture
	#{
	#	$userselected = $combobox1.SelectedItem
	#	$photo = [byte[]](Get-Content  $fileSelected -Encoding byte)
	#	
	#	write-host This is the selected user -> $userselected
	#	write-host This is the selected file -> $fileSelected
	#	write-host This is the selected photo -> $photo
	#	
	#	Set-ADUser $userselected -Add @{thumbnailphoto = "$photo" } -ErrorAction SilentlyContinue
			
	#}
		
		
	
	#Sample variable that provides the location of the script
	[string]$ScriptDirectory = Get-ScriptDirectory
	#[string]$UploadPictire = UploadPicture
	
	
	
#endregion Source: Globals.ps1

#region Source: BrowseFileDialog.ps1
function Call-BrowseFileDialog_ps1
{
	<#	
		Powered by zOri
	#>
	#$initialDirectory = "c:\"
	#[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
	#$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
	#$OpenFileDialog.initialDirectory = $initialDirectory
	#$OpenFileDialog.filter = "All files (*.*)| *.*"
	#$OpenFileDialog.ShowHelp = $true
	#$OpenFileDialog.ShowDialog() | Out-Null
	#$fileSelected = $OpenFileDialog.filename
	#$textbox1.text = $fileSelected
	#$imagepath= (Get-Item $openFileDialog.FileName)
	#$image= [System.Drawing.Image]::Fromfile($imagepath)
	#$picturebox1.image = $image
	#
	#write-host This is the selected file Browse -> $fileSelected
	
	#function UploadPicture
	#{
	#	$userselected = $combobox1.SelectedItem
	#	$photo = [byte[]](Get-Content  $fileselected -Encoding byte)
	#	
	#	Set-ADUser $userselected -Add @{ thumbnailphoto = "$photo" } -ErrorAction SilentlyContinue
	#	
	#}
	#	
}
#endregion Source: BrowseFileDialog.ps1

#region Source: error_message.psf
function Call-error_message_psf
{
#region File Recovery Data (DO NOT MODIFY)
<#RecoveryData:
uwsAAB+LCAAAAAAABADNll1v2jAUhu8n7T94uUZA+AgghUg00A2NkgpCt+6mcsKBeXXsynbaZr9+
DqEtbUoTqraakFA+3uP3tc8jO/YMQn4NIhlihZG+kISzvtGomobz+RNCtifImjBMjwmFKY7AASG4
uIhASryG6pVc2bWcJqsM/kCokEquoG/ME6kgqv4gbMlvZPWYiyj7r6DnXlXQ2TZKq1pPfxXkxlTF
AvoMYiUwraDTOKAk/A6Jzy+B9YNOB7fDtmX2mi2od3sGYjpK31jp8UwDhb8JXQqtM1zOlOBUZhPU
QU8FvwKhkm3BIFZ8HmIKQxIBS0NoqVVBZtOu3UmLSk/4EgznWDsV1riUAFNz8lcXNLqtCmpYjcKi
dJUNZzO1Qq0PtyrNIqK8dHStvbe6CcfL7ZgX6bVd27y9kxa38yhWirN3b2iwsZmN/Nn5S23NL8SE
h1jpCIbT7Ol2Wr3ceuxb6B3LEjVZL7t6ii2rhNzHwZgt4Va3v4x6082yURYSzoiMMZ2rhMIRDi9d
TrkwHF/E8Fz9LhCazPDy0eQvNo+egFHLyPhPOXEn3nx0GCdDgilfz0BqY8NxMQuBlljrB7xMy3wN
X5uopfnqWAfzld8r9vFVNsphfB2OygQHQN+dFJq6nHuLwWw09fzBwv/mzca/RkP/MG7GkT4RB5Ss
NQJHXHc0msAqfwAUbUyt/Dmzj5u9wUtTZPa6GtV6qZ3nnqN6aY50NqTDIZ0OPcRDvocm3tfxFH15
mZHHNwMpIdINBXmn3T5JnEiGXFASvAEUdu1+1KcuGYYf4fHmqBc7ph+AH2Mk8A1h69d41Zur9qqz
Ms1lu46buNjrZ0Q/ZE4uF/D2Rve3GfJ2bfdj3fkHBooV7LsLAAA=#>
#endregion
	#----------------------------------------------
	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	#endregion Import Assemblies

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$form1 = New-Object 'System.Windows.Forms.Form'
	$buttonRETRY = New-Object 'System.Windows.Forms.Button'
	$buttonCLOSE = New-Object 'System.Windows.Forms.Button'
	$labelYOUARENOTAUTHORIZEDT = New-Object 'System.Windows.Forms.Label'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
	$form1_Load={
		#TODO: Initialize Form Controls here
		
	#$buttonCLOSE_Click={
	#	#TODO: Place custom script here
	#	$form1.Close()
		
	}
	
	$buttonRETRY_Click={
		#TODO: Place custom script here
		$ScriptPath = $script:MyInvocation.MyCommand.Path
		$ScriptDir = Split-Path $scriptpath
		. "$ScriptDir\MainForm.psf"
	}
		# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$form1.WindowState = $InitialFormWindowState
	}
	
	$Form_StoreValues_Closing=
	{
		#Store the control values
	}

	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$buttonRETRY.remove_Click($buttonRETRY_Click)
			$form1.remove_Load($form1_Load)
			$form1.remove_Load($Form_StateCorrection_Load)
			$form1.remove_Closing($Form_StoreValues_Closing)
			$form1.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch [Exception]
		{ }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$form1.SuspendLayout()
	#
	# form1
	#
	$form1.Controls.Add($buttonRETRY)
	$form1.Controls.Add($buttonCLOSE)
	$form1.Controls.Add($labelYOUARENOTAUTHORIZEDT)
	$form1.AutoScaleDimensions = '6, 13'
	$form1.AutoScaleMode = 'Font'
	$form1.ClientSize = '284, 262'
	$form1.Name = 'form1'
	$form1.Text = 'Form'
	$form1.add_Load($form1_Load)
	#
	# buttonRETRY
	#
	$buttonRETRY.Location = '39, 169'
	$buttonRETRY.Name = 'buttonRETRY'
	$buttonRETRY.Size = '80, 46'
	$buttonRETRY.TabIndex = 2
	$buttonRETRY.Text = 'RETRY'
	$buttonRETRY.UseVisualStyleBackColor = $True
	$buttonRETRY.add_Click($buttonRETRY_Click)
	#
	# buttonCLOSE
	#
	$buttonCLOSE.DialogResult = 'Cancel'
	$buttonCLOSE.Location = '161, 169'
	$buttonCLOSE.Name = 'buttonCLOSE'
	$buttonCLOSE.Size = '76, 46'
	$buttonCLOSE.TabIndex = 1
	$buttonCLOSE.Text = 'CLOSE'
	$buttonCLOSE.UseVisualStyleBackColor = $True
	#
	# labelYOUARENOTAUTHORIZEDT
	#
	$labelYOUARENOTAUTHORIZEDT.ImageAlign = 'BottomLeft'
	$labelYOUARENOTAUTHORIZEDT.Location = '39, 43'
	$labelYOUARENOTAUTHORIZEDT.Name = 'labelYOUARENOTAUTHORIZEDT'
	$labelYOUARENOTAUTHORIZEDT.Size = '198, 102'
	$labelYOUARENOTAUTHORIZEDT.TabIndex = 0
	$labelYOUARENOTAUTHORIZEDT.Text = 'YOU ARE NOT AUTHORIZED TO LOGIN !'
	$form1.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $form1.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$form1.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$form1.add_FormClosed($Form_Cleanup_FormClosed)
	#Store the control values when form is closing
	$form1.add_Closing($Form_StoreValues_Closing)
	#Show the Form
	return $form1.ShowDialog()

}
#endregion Source: error_message.psf

#Start the application
Main ($CommandLine)
