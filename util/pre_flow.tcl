post_message "git rev [exec git rev-parse HEAD]"

# make 'components' package
exec "util/components_pkg.sh"
