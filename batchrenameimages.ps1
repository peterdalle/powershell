# PowerShell script to batch rename photos in the current directory using the EXIF capture date in the photo.
# A file like "IMAG0583.jpg" will be renamed to "2013-05-11 13.14.21.jpg".
# (Don't forget to run the command 'Set-ExecutionPolicy Unrestricted' from an admin Powershell prompt to run scripts.)

$CurrentDir = $PSScriptRoot
$Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", ""
$No = New-Object System.Management.Automation.Host.ChoiceDescription "&No", ""
$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Yes, $No)
$Files = Get-ChildItem -Filter "*.jpg" | sort name
$NumFiles = @($Files).Count

# Get user input.
$UserInput = $host.ui.PromptForChoice("", "Do you want to rename $numFiles images in <$CurrentDir>?", $Options, 0) 
if (!$UserInput -and $NumFiles)
{  
	# Load assemblies needed for reading and parsing image EXIF metadata.
	[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") > $null
	[System.Reflection.Assembly]::LoadWithPartialName("System.Text") > $null

	$FilesRenamed = 0
	$FilesProcessed = 0

	# Go through each image in the current directory.
	foreach ($Filename in $Files)
	{
		# Combine current folder and file.
		$FullFilename = "$CurrentDir\$Filename"

		# Load image and get EXIF capture date.
		$Photo = [System.Drawing.Image]::FromFile($FullFilename)
		try
		{
			$DateProp = $Photo.GetPropertyItem(36867)
		}
		catch
		{
			try
			{
				$DateProp = $Photo.GetPropertyItem(306)
			}
			catch
			{
				continue
			}
		}
		$Photo.Dispose()

		# Get image capture date.
		$Encoding = New-Object System.Text.UTF8Encoding
		$date = $Encoding.GetString($DateProp.Value).Trim()
		$year = $date.Substring(0,4)
		$month = $date.Substring(5,2)
		$day = $date.Substring(8,2)
		$hour = $date.Substring(11,2)
		$minute = $date.Substring(14,2)
		$second = $date.Substring(17,2)

		# Create new filename in the format "yyyy-mm-dd hh.mm.ss.jpg".
		$NewFilename = "{0}-{1}-{2} {3}.{4}.{5}.jpg" -f $year, $month, $day, $hour, $minute, $second

		# If new filename is identical to old filename, do not rename.
		if (!($Filename -eq $NewFilename))
		{
			# If NewFilename already exists, add incrementing counter to filename to avoid conflicts.
			$counter = 0
			while (Test-Path $NewFilename)
			{
				# Create new filename in the format "yyyy-mm-dd hh.mm.ss #.jpg" where # is the incrementing counter.
				$counter++
				$NewFilename = "{0}-{1}-{2} {3}.{4}.{5} {6}.jpg" -f $year, $month, $day, $hour, $minute, $second, $counter
			}

			# Rename image with the new filename.
			Write-Output "Renaming $Filename to $Newfilename"
			Rename-Item $Filename.FullName -newName $NewFilename
			$FilesRenamed++
		}
		else
		{
			Write-Output "Skipping $Filename"
		}
		$FilesProcessed++
	}

	# Show results.
	if(!$FilesRenamed -eq $FilesProcessed)
	{
		 $Results = "{0} images renamed, {1} not renamed." -f $FilesRenamed, ($FilesProcessed - $FilesRenamed)
	}
	else
	{
		$Results = "{0} images renamed." -f $FilesRenamed
	}
	Write-Output $Results
}
