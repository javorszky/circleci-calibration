changed_files=$(git diff --name-only $target_branch..$CI_BRANCH -- '*.php')

echo "target branch is $target_branch"
echo "ci branch is $CI_BRANCH"

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
