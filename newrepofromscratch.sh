#!/bin/bash
set -x
USERNAME=ernestfarias
REPONAME=util
echo "GitHub create new repo from bash - eaf"
#echo "{name:"${REPONAME}"}"
#should looks like  curl -u ernestfarias https://api.github.com/user/repos -d '{"name":"util"}'

curl -u $USERNAME https://api.github.com/user/repos -d '{"name":"'${REPONAME}'"}'

#push contents
echo '"# -"'$REPONAME'"' >> README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin https://github.com/ernestfarias/-REPONAME.git
git push -u origin master

