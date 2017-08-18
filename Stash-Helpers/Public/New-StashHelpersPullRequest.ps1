function New-StashHelpersPullRequest
{
    Param(
	$stashUrl,
    $stashUsername,
    $stashPassword,
    $stashPostRequestFile = "$PSScriptRoot\StashPostRequestBody.json",
    $Title = "Stash Pull Request Title",
    $Description = "Stash Pull Request Description. Please ignore or decline this pull request",
    $SourceBranch = "develop",
    $ProjectKey,
    $RepoName,
    $DestBranch = "master",
    $ReviewerUsers
    )
    $stashUri = "https://$stashUrl/rest/api/1.0/projects/$ProjectKey/repos/$RepoName/pull-requests"
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $stashUsername,$stashPassword)))

    #Split comma separated list of users into an array
    $ReviewerUsers = $ReviewerUsers -split(",")

    $stashPostRequestBody = Get-Content $stashPostRequestFile | Out-string | ConvertFrom-Json
    $stashPostRequestBody.title = $Title
    $stashPostRequestBody.description = $Description

    $stashPostRequestBody.fromRef.id = "refs/heads/$SourceBranch"
    $stashPostRequestBody.fromRef.repository.slug = $RepoName
    $stashPostRequestBody.fromRef.repository.project.key = $ProjectKey

    $stashPostRequestBody.toRef.id = "refs/heads/$DestBranch"
    $stashPostRequestBody.toRef.repository.slug = $RepoName
    $stashPostRequestBody.toRef.repository.project.key = $ProjectKey

    $reviewerUserJson = @"
    {
            "user": {
                "name": "Globalusername"
            }
    }
"@
   
    foreach($reviewer in $ReviewerUsers)
    {
        $addReviewerUser = $reviewerUserJson | Out-String | ConvertFrom-Json
        $addReviewerUser.user.name = $reviewer
        $stashPostRequestBody.reviewers += $addReviewerUser
    }

    $requestBody = $stashPostRequestBody | ConvertTo-Json -Depth 9

    try
    {
        $restResult = Invoke-RestMethod -UseBasicParsing -Uri $stashUri -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Method Post -Body $requestBody -ContentType "application/json"
    }
    catch
    {
        $ErrorMessage = $_.Exception
    }

    return $restResult
}