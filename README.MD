## Simple Sysmon Upgrade

This is a simple script to check which version of Sysmon is installed and if it is not the desired one, upgrade it (or really uninstall the one you don't want and install the one you do want).  
This works by checking a SHA-256 hash of the File and comparing it to the desired version. When you want to deploy a new version, get the file hash of the new version, and update the parameters accordingly.

This is a simple upgrade script and as such just uses hashes to determine if an upgrade (really a re-install) to the desired version is needed. It could also downgrade using the same logic. If this is not what you are looking for or you do not like this approach, then I encourage you to check out jokezone's Update Sysmon script here: https://github.com/jokezone/Update-Sysmon. I just wanted to get the job done in as reliable of a quick method as I could, and this was the result.

## Instructions

1. Download Sysmon
2. Update any variables/parameters needed for your environment
3. You can either manually install using the script or deploy using a systems management tool or Group Policy