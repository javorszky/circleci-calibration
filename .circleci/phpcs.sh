#!/bin/bash

if [[ -z "${CIRCLE_PULL_REQUEST}" ]];
then
	echo "This is not a pull request, no PHPCS needed."
	exit 0
else
	echo "This is a pull request, continuing"
fi

# Get wpcs
echo "Grabbing WordPress Coding Standards"
git clone -b master https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards.git wpcs

echo "Current working directory"
pwd

echo "Adding WPCS to phpcs path"
./vendor/bin/phpcs --config-set installed_paths $(pwd)/wpcs

echo "Checking installed paths"
./vendor/bin/phpcs -i

echo "Parsing PR URL for the PR number"
regexp="[[:digit:]]\+$"
PR_NUMBER=`echo $CIRCLE_PULL_REQUEST | grep -o $regexp`
echo "PR number is $PR_NUMBER"

url="https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/pulls/$PR_NUMBER"

if [[ -z $GITHUB_TOKEN ]];
then
	echo "GITHUB_TOKEN not set"
else
	echo "GITHUB TOKEN set"
fi

target_branch=$(curl -X GET -G \
$url \
-d access_token=$GITHUB_TOKEN | jq '.base.ref' | tr -d '"')

echo "PR number from circle is $PR_NUMBER <-"

git checkout $target_branch

git reset --hard origin/$target_branch

git status
# echo "Fetching target branch: $target_branch"
# git fetch origin

# echo "Checking out target branch"
# git checkout $target_branch
# git checkout $CIRCLE_BRANCH

echo "Getting changed files:"
echo "git diff --name-only $target_branch..$CIRCLE_BRANCH -- '*.php'"

changed_files=$(git diff --name-only $target_branch..$CIRCLE_BRANCH -- '*.php')

echo "Changed files"
echo $changed_files
echo "End of changed files"

if [[ -z $changed_files ]]
then
	echo "There are no files to check, boo."
	exit 0
fi

./vendor/bin/phpcs --standard="WordPress-Extra" $changed_files
