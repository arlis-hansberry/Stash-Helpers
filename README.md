# Stash-Helpers
This module was written to help automate creating a Stash Pull Request in Powershell. Additional functionality may be added later and I will use this as a generic module to house Powershell functions specific to Stash.


# Usage
This module can be installed from the PowerShell Gallery using the command below.
```
Install-Module Stash-Helpers -Repository PSGallery
```
## New-StashHelpersPullRequest
This cmdlet creates a Stash Pull Request.
```
New-StashHelpersPullRequest -stashUrl 'stash.example.com' -stashUsername 'username' -stashPassword 'password' -Title 'Stash Pull Request Title' -Description 'Stash Pull Request Description' -SourceBranch 'develop' -ProjectKey 'projectkey' -RepoName 'repository name' -DestBranch 'master' -ReviewerUsers 'username'
```

# Authors
- Arlis Halcomb
