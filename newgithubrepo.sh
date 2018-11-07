#!/bin/bash
set -x
USERNAME=ernestfarias
REPONAME=util
echo "GitHub create new repo from bash - eaf"
#echo "{name:"${REPONAME}"}"
#should looks like  curl -u ernestfarias https://api.github.com/user/repos -d '{"name":"util"}'

curl -u $USERNAME https://api.github.com/user/repos -d '{"name":"'${REPONAME}'"}'
