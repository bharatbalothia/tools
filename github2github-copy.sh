#!/bin/bash

org="<you org name>"

curl -s -H "Accept: application/vnd.github+json"   -H "Authorization: token <generate token from github account>"   https://api.<GitHub Enterprise Server hostname>/orgs/${org}/repos | jq -c '.[]' | while read -r repo_object
do
	repo_name=$(jq -r '.name' <<< "${repo_object}")
    repo_description=$(jq -r '.description' <<< "${repo_object}")
    git clone "https://<username on GitHub Enterprise Server>:<generated token in GitHub Enterprise Account>@<GitHub Enterprise Server Hostname>/${org}/${repo_name}.git"
	cd "$repo_name"
    body=$(jq --null-input  --arg name "$org-$repo_name"  --arg description "$repo_description"  '{"name": $name, "description": $description}')
    curl  -X POST -H "Accept: application/vnd.github+json" -H "Authorization: token <GitHub token>"  -d "${body}" https://api.github.com/user/repos
    git remote remove origin
    git remote add origin "https://<Username at GitHub Public>:<Token at GitHub Public>@github.com/<username at GitHub Public>/${org}-${repo_name}".git
	git branch -M main
	git push -u origin main
    cd ..
done

