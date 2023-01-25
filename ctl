#!/usr/bin/env bash

# Set environment variables for dev
export CONTAINER_ENV=${CONTAINER_ENV:-local}
export APP_ENV=${APP_ENV:-local}
export APP_PORT=${APP_PORT:-8080}
export DB_PORT=${DB_PORT:-33060}
export DB_ROOT_PASS=${DB_ROOT_PASS:-secret}
export DB_DATABASE=${DB_DATABASE:-homestead}
export DB_USERNAME=${DB_USERNAME:-homestead}
export DB_PASSWORD=${DB_PASSWORD:-secret}


# Create docker-compose command to run
COMPOSE="docker-compose"

if [ $# -gt 0 ]; then

    if [ "$1" == "artisan" ] || [ "$1" == "art" ]; then
        shift 1
        $COMPOSE exec \
            app \
            php artisan "$@"

    elif [ "$1" == "composer" ] || [ "$1" == "comp" ]; then
        shift 1
        $COMPOSE exec \
            app \
            composer "$@"

    elif [ "$1" == "test" ]; then
        shift 1
        $COMPOSE exec \
            app \
            ./vendor/bin/phpunit "$@"

    elif [ "$1" == "npm" ]; then
        shift 1
        $COMPOSE run --rm \
            node \
            npm "$@"

    else
        $COMPOSE "$@"
    fi

else
    # '>&2 ' echoes to StdErr instead of to StdOut
    >&2 echo "No command passed to ctl"
    exit 1
fi
