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

echo "Adding WPCS to phpcs path"
./vendor/bin/phpcs --config-set installed_paths $(pwd)/wpcs

echo "Checking installed paths"
./vendor/bin/phpcs -i

regexp="[[:digit:]]\+$"
PR_NUMBER=`echo $CIRCLE_PULL_REQUEST | grep -o $regexp`
echo "PR number is $PR_NUMBER"

url="https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/pulls/$PR_NUMBER"

if [[ -z $GITHUB_TOKEN ]];
then
	echo "GITHUB_TOKEN not set"
	exit 1
fi

target_branch=$(curl -X GET -G \
$url \
-d access_token=$GITHUB_TOKEN | jq '.base.ref' | tr -d '"')

git checkout $target_branch

git reset --hard origin/$target_branch

git checkout $CIRCLE_BRANCH

changed_files=$(git diff --name-only $target_branch..$CIRCLE_BRANCH -- '*.php')

if [[ -z $changed_files ]]
then
	echo "There are no files to check."
	exit 0
fi

./vendor/bin/phpcs $changed_files
