# Dockerized App + DB - Initial Setup Guide

## Goal

If the goal is Dockerized development from the start, installing Rails and its dependencies directly on your host machine is unnecessary and even counter-productive. We want the development environment to mirror the containerized production environment as closely as possible.

So, yes, we'll take a slightly different approach. We'll use Docker itself to generate the initial Rails application files.

## Plan

1. Use a temporary Ruby Docker container to run the `rails new` command.  
2. Mount a local directory into the container so that the generated project files are created directly on your host machine.  
3. Specify the project name (`ruby_app`) and database (`postgresql`) within the command.  
4. After generation, we'll create the Dockerfile and docker-compose.yml files to define our development environment.  

---

## Step 1: Generate the Rails App using Docker

Ensure Docker is installed and running. Navigate to the directory where you want the `ruby_app` project to be created and run:

```bash
docker run --rm -v "${PWD}":/usr/src/app -w /usr/src/app ruby:3.2 sh -c "gem install rails && rails new ruby_app -d postgresql --skip-bundle"
```

### Explanation

- `docker run`: Executes a command in a new container.
- `--rm`: Automatically removes the container when it exits.
- `-v "${PWD}":/usr/src/app`: Mounts the current directory.
- `-w /usr/src/app`: Sets working directory.
- `ruby:3.2`: Uses the Ruby 3.2 Docker image.
- `sh -c "..."`: Runs shell commands:
  - `gem install rails`: Installs Rails.
  - `rails new ruby_app -d postgresql --skip-bundle`: Creates the app.

---

## Step 2: Check File Ownership

After generation, check file ownership:

```bash
ls -l
```

If files are owned by `root`, fix it:

```bash
sudo chown -R $(id -u):$(id -g) ruby_app
```

---

## Next Steps

Create these essential files:

1. **Dockerfile**: Defines Rails app image build.
2. **docker-compose.yml**: Defines services (Rails app, PostgreSQL) and connections.

---

## Step 3: Other Dependencies

### 1. Install Prerequisites

```bash
sudo apt update
sudo apt install -y git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev libdb-dev
```

### 2. Install rbenv

```bash
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
```

### 3. Configure Shell for rbenv

```bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
```

### 4. Install ruby-build Plugin

```bash
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
```

### 5. Update ruby-build

```bash
cd "$(rbenv root)"/plugins/ruby-build
git pull
cd -
```

### 6. Install Ruby 3.2.4

```bash
rbenv install 3.2.4
```

### 7. Set Ruby 3.2.4 Locally

```bash
cd /home/projects/ruby_app/
rbenv local 3.2.4
```

### 8. Install Bundler

```bash
gem install bundler
rbenv rehash
```

### 9. Verify Versions

```bash
ruby -v
bundle -v
```

### 10. Install Project Dependencies

```bash
bundle install
```

---

## Package Purpose Breakdown

- `git`, `curl`: Download tools.
- `build-essential`: Compilers & tools.
- `autoconf`, `bison`: Build system tools.
- `libssl-dev`, `libyaml-dev`, `libreadline-dev`: Ruby SSL, YAML, and terminal support.
- `zlib1g-dev`, `libffi-dev`: Compression and C interface libraries.
- `libgdbm-dev`, `libdb-dev`: Database libraries.

---

## Step 4: Configuration Files

Use the Dockerfile, docker-compose.yml, database.yml, and Gemfile in this project to set up your Rails app.

---

## Step 5: Run Project

### 1. Build the Images

```bash
docker-compose build
```

### 2. Create the Database

```bash
docker-compose run --rm app rails db:create
```

### 3. Start the Services

```bash
docker-compose up
```

### 4. Access Your App

Visit: [http://localhost:3000](http://localhost:3000)

---

You're now up and running with a fully Dockerized Rails app!
