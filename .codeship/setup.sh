
if [ -d "$HOME/cache/wpcs" ];
then
	git -C $HOME/cache/wpcs fetch origin && git -C $HOME/cache/wpcs pull origin master
else
	git clone -q -b master https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards.git $HOME/cache/wpcs
fi

./vendor/bin/phpcs --config-set installed_paths $HOME/cache/wpcs
./vendor/bin/phpcs -i

url="https://api.github.com/repos/$CI_REPO_NAME/pulls/$CI_PR_NUMBER"

target_branch=$(curl -s -X GET -G \
$url \
-d access_token=$GITHUB_TOKEN | jq '.base.ref' | tr -d '"')

git remote set-branches --add origin $target_branch
git fetch origin $target_branch:$target_branch

git checkout $target_branch
git checkout $CI_BRANCH
