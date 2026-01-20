# syntax=docker/dockerfile:1
# check=error=true

# 1. BASE: Camada comum para build e produção
ARG RUBY_VERSION=3.4.8
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# Instalando pacotes essenciais de runtime e jemalloc para performance
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    postgresql-client \
    libpq5 && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Variáveis de ambiente de produção
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so"


# 2. BUILD: Estágio temporário para compilar Gems e Assets
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    libyaml-dev \
    pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Instalação das Gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile -j 1 --gemfile

# Copia o código e pré-compila assets
COPY . .
RUN bundle exec bootsnap precompile -j 1 app/ lib/
RUN RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile


# 3. FINAL: Imagem enxuta para rodar no seu servidor
FROM base

# Segurança: Rodar como usuário não-root
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash
USER 1000:1000

# Copia apenas o necessário do estágio de build
COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --chown=rails:rails --from=build /rails /rails

# Entrypoint configura o DB no boot (ajuste o database.yml antes!)
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# HEALTHCHECK ajustado para a porta 80 (Thruster)
# Se o Thruster estiver ativo, ele escuta na 80 e repassa para a 3000 interna
HEALTHCHECK --interval=15s --timeout=5s --start-period=45s --retries=3 \
    CMD curl -f http://localhost:80/up || exit 1

# Exposição da porta padrão do Thruster/Kamal-Proxy
EXPOSE 80

# Comando de inicialização usando Thruster para servir o Rails
# CMD ["./bin/thrust", "./bin/rails", "server"]
CMD ["./bin/thrust"]
