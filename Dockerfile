# Dockerfile

# Use the same Ruby version we used for generation
FROM ruby:3.2

# Set environment variables
# - RAILS_LOG_TO_STDOUT: Ensures Rails logs go to the container log
# - BUNDLE_PATH: Installs gems into a specific directory within the container
# - NODE_VERSION: Specify Node.js version (adjust if needed for your assets/JS)
ENV RAILS_LOG_TO_STDOUT="true" \
    BUNDLE_PATH="/gems" \
    NODE_VERSION="18"

# Install essential dependencies:
# - build-essential: For compiling native gem extensions
# - postgresql-client: For the 'pg' gem to connect to PostgreSQL
# - nodejs & npm: For JavaScript runtime / asset pipeline (via nvm for specific version)
# - curl: Needed by nvm install script
# - gnupg: Needed by yarn install script
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    postgresql-client \
    curl \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js using nvm (Node Version Manager) for better version control
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
ENV NVM_DIR="/root/.nvm"
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION} && nvm alias default ${NODE_VERSION} && nvm use default
ENV NODE_PATH="$NVM_DIR/v${NODE_VERSION}/lib/node_modules"
ENV PATH="$NVM_DIR/versions/node/v${NODE_VERSION}/bin:${PATH}"

# Install Yarn (optional, but common for Rails JS management)
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn

# Set the working directory inside the container
WORKDIR /ruby_app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application code into the working directory
# This is done last to leverage Docker cache - bundle install won't re-run
# unless Gemfile/Gemfile.lock changes.
COPY . .

# Expose port 3000 to the Docker network (the default Rails port)
EXPOSE 3000

# The main command to run when the container starts
# Binds the server to 0.0.0.0 to make it accessible from outside the container
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]