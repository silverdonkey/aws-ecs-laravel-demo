<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>

<p align="center">
<a href="https://github.com/laravel/framework/actions"><img src="https://github.com/laravel/framework/workflows/tests/badge.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/dt/laravel/framework" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/v/laravel/framework" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/l/laravel/framework" alt="License"></a>
</p>

## Create project (using the docker container)
* docker exec <container-name> sh -c "cd /var/www/html && composer create-project laravel/laravel <folder>"

Local Dev: ( optional ) login to docker instance an run commands directly or use the ./ctl script

* docker exec -it aws-ecs-laravel-demo-app-1 bash
Add package
* composer require laravel/jetstream
* php artisan jetstream:install livewire

Create a test
* php artisan make:test RegisterTest

Verify
* ./ctl config
Run it

* ./ctl up -d
* ./ctl art migrate
* ./ctl npm install && ./ctl npm run dev
* open <http://localhost:8080>

Get Tests working

* ./ctl exec mysql mysql -u root -p -e "create database app_testing charset utf8mb4;"
* ./ctl exec mysql mysql -u root -p -e "grant all privileges on sdtesting.* to homestead@'%';"
