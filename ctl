#!/usr/bin/env bash

# First, we update the XDEBUG_HOST variable if we're in GitHub Actions
# It uses a nonsense value, we don't need it for CI runs
# see https://docs.github.com/en/actions/reference/environment-variables
#
if [ ! -z "$BUILD_NUMBER" ]; then
    # We need the full path here because /sbin is not in user Jenkin's $PATH
    export XDEBUG_HOST=$(/sbin/ifconfig docker0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1)
elif [ ! -z "$GITHUB_RUN_NUMBER" ]; then
    export XDEBUG_HOST="127.0.0.1"
else
    export XDEBUG_HOST=$(ipconfig getifaddr en1)
fi

# Set environment variables for dev
export CONTAINER_ENV=${CONTAINER_ENV:-local}
export APP_ENV=${APP_ENV:-local}
export APP_PORT=${APP_PORT:-8080}
export DB_PORT=${DB_PORT:-33060}
export DB_ROOT_PASS=${DB_ROOT_PASS:-secret}
export DB_NAME=${DB_NAME:-homestead}
export DB_USERNAME=${DB_USERNAME:-homestead}
export DB_PASSWORD=${DB_PASSWORD:-secret}

# Decide which docker-compose file to use
COMPOSE_FILE="dev"
# Default pseudo-TTY allocation for dev
# like the '-it' option for docker (docker-compose does not have the '-it')
TTY=""

# Then we update it to use the docker-compose.ci.yml file
# if we're running in a GitHub Action
if [ ! -z "$BUILD_NUMBER" ] || [ ! -z "$GITHUB_RUN_NUMBER" ]; then
    COMPOSE_FILE="ci"
    # Disable pseudo-TTY allocation for CI (Jenkins)
    # e.g. makes it non-interactive
    TTY="-T"
fi

# Create docker-compose command to run
COMPOSE="docker-compose"

if [ $# -gt 0 ]; then

    if [ "$1" == "artisan" ] || [ "$1" == "art" ]; then
        shift 1
        $COMPOSE run --rm $TTY \
            -w /var/www/html \
            php artisan "$@"

    elif [ "$1" == "composer" ] || [ "$1" == "comp" ]; then
        shift 1
        $COMPOSE run --rm $TTY \
            -w /var/www/html \
            composer "$@"

    elif [ "$1" == "test" ]; then
        shift 1
        $COMPOSE run --rm $TTY \
            -w /var/www/html \
            ./vendor/bin/phpunit "$@"

    elif [ "$1" == "t" ]; then
        shift 1
        $COMPOSE exec \
            sh -c "cd /var/www/html && ./vendor/bin/phpunit $@"

    else
        $COMPOSE "$@"
    fi

else
    >&2 echo "No command passed to ctl"
    exit 1
fi
