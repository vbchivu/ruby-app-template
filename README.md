# Ruby App API - Development Setup Guide

## Overview

This guide details the steps required to set up the Ruby App Rails API application for local development on a fresh Ubuntu system (tested on LTS versions like 22.04/24.04).

The development environment uses:

* Ruby on Rails (API backend)
* PostgreSQL (Database)
* `rbenv` (To manage Ruby versions locally)
* Docker and Docker Compose (To containerize the application and database for consistent development)

## 1. Prerequisites

### 1.1. System Update

```bash
sudo apt update && sudo apt upgrade -y
```

### 1.2. Install Git & Curl

```bash
sudo apt install -y git curl
```

### 1.3. Install Docker Engine & Docker Compose

- **Docker Engine**: Follow the guide at: <https://docs.docker.com/engine/install/ubuntu/>
* **Post-installation steps**: <https://docs.docker.com/engine/install/linux-postinstall/>
* **Docker Compose Install Guide**: <https://docs.docker.com/compose/install/linux/>

Verify installations:

```bash
docker --version
docker compose version
```

### 1.4. Install Build Dependencies for Ruby

```bash
sudo apt install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev libdb-dev pkg-config
```

## 2. Project Setup Steps

### 2.1. Clone the Repository

```bash
git clone https://github.com/vbchivu/ruby_app.git
cd ruby_app
```

### 2.2. Install rbenv and ruby-build

```bash
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

type rbenv
```

### 2.3. Install Required Ruby Version

```bash
cat .ruby-version
cd "$(rbenv root)"/plugins/ruby-build && git pull && cd -
rbenv install $(cat .ruby-version)
rbenv local $(cat .ruby-version)
ruby -v
```

### 2.4. Install Bundler

```bash
gem install bundler
rbenv rehash
bundle -v
```

### 2.5. Install Gems

```bash
bundle install
```

### 2.6. Set up Docker Environment File (.env)

```bash
touch .env
```

Example `.env` file:

```env
# .env file - Store your secrets here
# DO NOT COMMIT THIS FILE TO GIT!

RUBY_APP_DATABASE_PASSWORD=your_dev_db_password_here
RAILS_MASTER_KEY=your_rails_master_key_here
```

### 2.7. Make Entrypoint Executable

```bash
chmod +x bin/docker-entrypoint
```

### 2.8. Build Docker Images

```bash
docker compose build
```

## 3. Running the Application

### 3.1. Start Containers

```bash
docker compose up -d
```

### 3.2. Database Setup

```bash
docker compose logs app
docker compose exec app bundle exec rails db:migrate
docker compose exec app bundle exec rails db:seed
```

### 3.3. Accessing the Application

Visit: <http://localhost:3000>

## 4. Common Development Tasks

### View Logs

```bash
docker compose logs
docker compose logs -f app
docker compose logs db
```

### Run Rails Console

```bash
docker compose exec app bundle exec rails c
```

### Run Tests

```bash
docker compose exec app bundle exec rails test
# or if using RSpec:
# docker compose exec app bundle exec rspec
```

### Stop Containers

```bash
docker compose down
```

### Stop and Remove Volumes (Caution: Deletes DB Data)

```bash
docker compose down -v
```

## 5. Configuration Summary

* **Ruby Version**: Defined in `.ruby-version`, managed by rbenv
* **Gems**: Defined in `Gemfile`, managed by bundler
* **Docker Build**: Defined in `Dockerfile`
* **Docker Services**: Defined in `docker-compose.yml`
* **Database Config**: Defined in `config/database.yml`
* **Secrets**: Managed via `.env` and `config/credentials.yml.enc`

This guide should provide a solid foundation for getting started with development on the Ruby App API project using Docker Compose on Ubuntu.
