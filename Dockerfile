# # syntax=docker/dockerfile:1
# # check=error=true

# # 1. BASE: Camada comum para build e produção
# ARG RUBY_VERSION=3.4.8
# FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# WORKDIR /rails

# # Instalando pacotes essenciais de runtime e jemalloc para performance
# RUN apt-get update -qq && \
#     apt-get install --no-install-recommends -y \
#     curl \
#     libjemalloc2 \
#     libvips \
#     postgresql-client \
#     libpq5 && \
#     ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
#     rm -rf /var/lib/apt/lists /var/cache/apt/archives

# # Variáveis de ambiente de produção
# ENV RAILS_ENV="production" \
#     BUNDLE_DEPLOYMENT="1" \
#     BUNDLE_PATH="/usr/local/bundle" \
#     BUNDLE_WITHOUT="development" \
#     LD_PRELOAD="/usr/local/lib/libjemalloc.so"


# # 2. BUILD: Estágio temporário para compilar Gems e Assets
# FROM base AS build

# RUN apt-get update -qq && \
#     apt-get install --no-install-recommends -y \
#     build-essential \
#     git \
#     libpq-dev \
#     libyaml-dev \
#     pkg-config && \
#     rm -rf /var/lib/apt/lists /var/cache/apt/archives

# # Instalação das Gems
# COPY Gemfile Gemfile.lock ./
# RUN bundle install && \
#     rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
#     bundle exec bootsnap precompile -j 1 --gemfile

# # Copia o código e pré-compila assets
# COPY . .
# RUN bundle exec bootsnap precompile -j 1 app/ lib/
# RUN RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile


# # 3. FINAL: Imagem enxuta para rodar no seu servidor
# FROM base

# # Segurança: Rodar como usuário não-root
# RUN groupadd --system --gid 1000 rails && \
#     useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash
# USER 1000:1000

# # Copia apenas o necessário do estágio de build
# COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
# COPY --chown=rails:rails --from=build /rails /rails

# # Entrypoint configura o DB no boot (ajuste o database.yml antes!)
# ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# # Exposição da porta padrão do Thruster/Kamal-Proxy
# EXPOSE 80
# CMD ["./bin/thrust", "./bin/rails", "server"]


# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t kamal .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name kamal kamal

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.8
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment variables and enable jemalloc for reduced memory usage and latency.
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY vendor/* ./vendor/
COPY Gemfile Gemfile.lock ./

RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    # -j 1 disable parallel compilation to avoid a QEMU bug: https://github.com/rails/bootsnap/issues/495
    bundle exec bootsnap precompile -j 1 --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times.
# -j 1 disable parallel compilation to avoid a QEMU bug: https://github.com/rails/bootsnap/issues/495
RUN bundle exec bootsnap precompile -j 1 app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile




# Final stage for app image
FROM base

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash
USER 1000:1000

# Copy built artifacts: gems, application
COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --chown=rails:rails --from=build /rails /rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start server via Thruster by default, this can be overwritten at runtime
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]
