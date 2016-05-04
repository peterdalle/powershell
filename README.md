# PowerShell
A variety of PowerShell scripts I have collected elsewhere or written myself. 

## batchrenameimages.ps1
Batch rename photos (JPG only) in the current directory using the EXIF capture date in the photo. A file like "IMAG0583.jpg" will be renamed to something like "2013-01-11 13.14.21.jpg". Rewritten from a script I found long time ago. Please let me know of the original author so I can credit him or her.

Put the batch script inside the same directory as the image files and just run the script.

Sample output:
<pre>PS C:\Users\Peter> ./batchrenameimages.ps1
Do you want to rename 2 images in &lt;C:\Users\Peter&gt;?
[Y] Yes  [N] No  [?] Help (default is "Y"): Y
Renaming IMG_2076.jpg to 2016-01-15 08.40.31.jpg
Renaming IMG_2077.jpg to 2016-01-15 09.30.43.jpg
2 images renamed.</pre>

## uptime.ps1
Shows the computer's startup and shutdown time by reading the Windows event log. Originally written by <a href="https://www.pluralsight.com/blog/data-professional/why-metrics-matter-and-how-powershell-can-help">Adam Bertram at PluralSight</a>.

Sample output:
<pre>
PS C:\Users\Peter> ./uptime.ps1
Startup             Shutdown            Uptime (Days) Uptime (Min)
-------             --------            ------------- ------------
2016-04-02 17:56:40 2016-04-04 20:56:38          2,12      3059,96
2016-03-02 07:54:03 2016-03-02 17:54:28          0,42       600,43
2016-01-15 08:19:55 2016-02-02 17:54:28          17,4     25054,56</pre>

## Setup
Just run the command <code>Set-ExecutionPolicy Unrestricted</code> from an admin Powershell prompt to run the scripts.
