## About this PoC project
Main Goals
- Dockerize existing and new php (Laravel) based Web apps
- Code base stored in GitHub repo
- Use Docker for local development and in production
- Provide a CI/CD Pipeline to build, test and deploy on AWS: CodeBuild
    - RollingDeployment Strategy vs Blue-Green Deployment
- Use Cloud native technologies and tools
    - AWS S3 Service (for providing secure env config)
    - AWS Elastic Container Registry - ECR private repositories
    - AWS Elastic Container Service - ECS 
    - AWS Load Balancing
    - AWS RDS (MySql/MariaDB)
    - AWS MemoryDB (Redis Cluster)


<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>

<p align="center">
<a href="https://github.com/laravel/framework/actions"><img src="https://github.com/laravel/framework/workflows/tests/badge.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/dt/laravel/framework" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/v/laravel/framework" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/l/laravel/framework" alt="License"></a>
</p>

## About Laravel

Laravel is a web application framework with expressive, elegant syntax. We believe development must be an enjoyable and creative experience to be truly fulfilling. Laravel takes the pain out of development by easing common tasks used in many web projects, such as:

- [Laravel Framework](https://laravel.com/docs/routing).
- [Powerful dependency injection container](https://laravel.com/docs/container).
- Multiple back-ends for [session](https://laravel.com/docs/session) and [cache](https://laravel.com/docs/cache) storage.
- Expressive, intuitive [database ORM](https://laravel.com/docs/eloquent).
- Database agnostic [schema migrations](https://laravel.com/docs/migrations).
- [Robust background job processing](https://laravel.com/docs/queues).
- [Real-time event broadcasting](https://laravel.com/docs/broadcasting).

Laravel is accessible, powerful, and provides tools required for large, robust applications.


## Create project and start developing
- [Create project](https://bootcamp.laravel.com/blade/installation#installation-via-docker)
- Local Development: use Laravel Sail

### Notes for local development

Create Project using the ./ctl script. Then:
- docker exec -it aws-ecs-laravel-demo-app-1 sh -c "cd /var/www/html && composer create-project laravel/laravel"

Local Dev:
Login to docker instance an run commands directly
- docker exec -it <container-name\> bash OR
- use the ./ctl script: ./ctl <command\> OR
- use Laravel Sail: sail <command\>

We will be using Sail!

Installing Laravel Breeze with Blade

- sail composer require laravel/breeze --dev
- sail php artisan breeze:install blade
- (optional): if you want to use Redis with the predis driver
  - sail composer require predis/predis

Important note about Redis: if you configure AWS Cluster, only "predis" will work locally with Laravel-Cluster config. "phpredis" will work with Laravel-Cluster config against local Redis Server, which ist not a cluster!


Verify
- sail config
- sail up -d
- sail art migrate
- sail npm install && sail npm run dev
- open http://localhost:8080

Bsp for creating Test-DB (dbname=testing, dbuser=homestead)
- sail exec mysql mysql -u root -p -e "create database testing charset utf8mb4;"
- sail exec mysql mysql -u root -p -e "grant all privileges on testing.* to homestead@'%';"
