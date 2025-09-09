#!/bin/sh
# from kas setuptool a while ago
if [ -z "$USER_ID" ]; then
        # Not an autobuilder call.
        GOSU=""
        sudo git config --system safe.directory "*"
elif [ "$USER_ID" = 0 ]; then
        # We shall run everything as root
        GOSU=""
else
        sudo git config --system safe.directory "*"
        GROUP_ID=${GROUP_ID:-$(id -g)}
        groupmod -o --gid "$GROUP_ID" mantle
        usermod -o --uid "$USER_ID" --gid "$GROUP_ID" mantle >/dev/null
        chown -R "$USER_ID":"$GROUP_ID" /mantle
        # copy host SSH config into home of mantle
	# kas puts it here from the --ssh-key cmd option
        if [ -d /var/kas/userdata/.ssh ]; then
                cp -a /var/kas/userdata/.ssh /mantle/
        fi
        GOSU="gosu mantle"
fi

if [ "$PWD" = / ]; then
        cd /mantle || exit 1
fi

if [ -n "$1" ]; then
        case "$1" in
        build|checkout|dump|for-all-repos|lock|menu|shell|help|-*)
                exec $GOSU kas "$@"
                ;;
        *)
                exec $GOSU "$@"
                ;;
        esac
else
        exec $GOSU bash
fi
