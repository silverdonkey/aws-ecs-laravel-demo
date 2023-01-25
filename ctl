#!/usr/bin/env bash

# Set environment variables for dev
export CONTAINER_ENV=${CONTAINER_ENV:-local}
export APP_ENV=${APP_ENV:-local}
export APP_PORT=${APP_PORT:-8080}
export DB_PORT=${DB_PORT:-3306}
export DB_ROOT_PASS=${DB_ROOT_PASS:-secret}
export DB_DATABASE=${DB_DATABASE:-homestead}
export DB_USERNAME=${DB_USERNAME:-homestead}
export DB_PASSWORD=${DB_PASSWORD:-secret}


# Default pseudo-TTY allocation for dev
# like the '-it' option for docker (docker-compose does not have the '-it')
TTY=""

# Then we update it to use the docker-compose.ci.yml file
# if we're running in a GitHub Action
if [ ! -z "$CODEBUILD_BUILD_ID" ] || [ ! -z "$GITHUB_RUN_NUMBER" ]; then
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
        $COMPOSE exec $TTY \
            app \
            php artisan "$@"

    elif [ "$1" == "composer" ] || [ "$1" == "comp" ]; then
        shift 1
        $COMPOSE exec $TTY \
            app \
            composer "$@"

    elif [ "$1" == "test" ]; then
        shift 1
        $COMPOSE exec $TTY \
            app \
            ./vendor/bin/phpunit "$@"

    elif [ "$1" == "npm" ]; then
        shift 1
        $COMPOSE run --rm \
            node \
            npm "$@"
    elif [ "$1" == "push" ]; then
        shift 1
        source ./docker/.secrets
        dock-aws --profile $AWS_PROFILE ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
        docker tag aws-ecs-laravel-demo/app:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/myshippingdocker/$1-base-image:latest
        docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/myshippingdocker/$1-base-image:latest
    else
        $COMPOSE "$@"
    fi

else
    # '>&2 ' echoes to StdErr instead of to StdOut
    >&2 echo "No command passed to ctl"
    exit 1
fi
