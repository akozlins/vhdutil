post_message "git rev [exec git rev-parse HEAD]"

# make 'components' package
exec "util/altera/components_pkg.sh"
