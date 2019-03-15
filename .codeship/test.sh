url="https://api.github.com/repos/$CI_REPO_NAME/pulls/$CI_PR_NUMBER"

target_branch=$(curl -s -X GET -G \
$url \
-d access_token=$GITHUB_TOKEN | jq '.base.ref' | tr -d '"')

git remote set-branches --add origin $target_branch
git fetch origin $target_branch:$target_branch

git checkout $target_branch
git checkout $CI_BRANCH

changed_files=$(git diff --name-only $target_branch..$CI_BRANCH -- '*.php')

if [[ -z $changed_files ]]
then
	echo "There are no files to check."
	exit 0
fi

if [ ! -f phpcs.xml ]
then
	echo "No phpcs.xml file found. Nothing to do."
	exit 0
fi

echo "Running phpcs..."
./vendor/bin/phpcs $changed_files
