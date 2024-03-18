# Coding standards
* [Ruby](https://github.com/airbnb/ruby)
* [Rails](https://github.com/bbatsov/rails-style-guide)
* [Javascript](https://github.com/airbnb/javascript)

# Prerequisites
* Ruby
* MySQL
* Node.js
* Yarn

## Install Node.js
### e.g. Homebrew on Mac
```bash
$ sudo brew install node.js
```

## Install ImageMagic
### e.g. Homebrew on Mac
```bash
$ sudo brew install imagemagick

# Getting Started

## Set up environment variables
### MySQL
```bash
export RECMATCH_DATABASE_USERNAME=xxxx
export RECMATCH_DATABASE_PASSWORD=yyyy
export RECMATCH_DATABASE_HOST=localhost
```

### Redis (If you need)
```bash
export RECMATCH_REDIS_HOSTNAME=localhost
```

### SMTP (If you need)
```bash
export RECMATCH_SMTP_ADDRESS=localhost
export RECMATCH_SMTP_PORT=1025
export RECMATCH_SMTP_DOMAIN=localhost
```

## Install gems
```bash
$ bundle install
```

## Install Javascript/CSS libraries
```bash
$ yarn install
```

## Create Database
```bash
$ rails db:create
$ rails db:migrate
$ rails db:seed_fu
```

## Setup mailcatcher as a development mailserver
```bash
$ gem install mailcatcher
$ mailcatcher
```
- Go to http://localhost:1080/
- Send mail through smtp://localhost:1025

## Run
### Run on server

```bash
$ bundle exec unicorn_rails -E development -c config/unicorn.rb -D
```

### Run on localhost
```bash
$ rails s
```
