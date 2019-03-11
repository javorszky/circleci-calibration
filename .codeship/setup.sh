
if [ -d "$HOME/cache/wpcs" ];
then
	git -C $HOME/cache/wpcs fetch origin && git -C $HOME/cache/wpcs pull origin master
else
	git clone -q -b master https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards.git $HOME/cache/wpcs
fi

./vendor/bin/phpcs --config-set installed_paths $HOME/cache/wpcs
./vendor/bin/phpcs -i
