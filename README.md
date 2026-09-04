# ConectaTrampos

O ConectaTrampos é uma plataforma moderna de marketplace de serviços desenvolvida para conectar prestadores de serviço (profissionais) a clientes de forma rápida, segura e eficiente.

A aplicação permite que profissionais criem portfólios detalhados e que clientes encontrem a solução ideal para suas necessidades através de um sistema de busca inteligente e avaliações reais.

## Tecnologias

Este projeto utiliza o que há de mais moderno no ecossistema Ruby on Rails (v8.0+):

- Linguagem: Ruby 3.4.8

- Framework: Ruby on Rails 8.1.2

- Banco de Dados: Postgresql

- Autenticação: Devise

- Frontend: Tailwind CSS

- Interatividade: Hotwire (Turbo & Stimulus)

- Containerização: Docker & Docker Compose

- Uploads: Active Storage

## Funcionalidades Planejadas (MVP)

### Para Clientes:

- [x] Busca de profissionais por categoria e localização.

- [x] Filtros avançados de busca com atualização em tempo real (Hotwire).

- [x] Sistema de solicitação de orçamentos.

- [x] Avaliação e feedback de serviços prestados.

### Para Profissionais:

- [x] Perfil profissional customizável com bio e portfólio.

- [x] Gerenciamento de serviços oferecidos.

- [x] Painel (Dashboard) para gestão de pedidos e mensagens.

## Notas Técnicas — Correções Futuras (Auditoria AGENTS.md)

> Anotações geradas em 2026-09-04 a partir da auditoria contra `AGENTS.md`. Não alteram comportamento; apenas documentam débitos técnicos para correção incremental.

### 1. Testes (Crítico — AGENTS.md:13)
- [ ] Adicionar `rspec-rails` ao `Gemfile` (grupo `:development, :test`) — hoje não existe `spec/` nem `test/`.
- [ ] Cobrir `User#profile_incomplete?` / `User#address_incomplete?` (`app/models/user.rb:19`), `ApplicationController#onboarding_path_for` (`app/controllers/application_controller.rb:27`) e fluxo `ServiceRequestsController#start` / `#create`.

### 2. Models — Bugs e Modelagem (AGENTS.md:6)
- [ ] `app/models/profile.rb:8` — método `profile_incomplete?` quebrado (`profile.nil?` dentro de `Profile`; deveria ser `self` ou removido — a lógica canônica está em `User`).
- [ ] `app/models/profile.rb:7` — `accepts_nested_attributes_for :user` invertido (`Profile belongs_to :user`). Decidir: ou `User accepts_nested_attributes_for :profile` ou remover e tratar `name` só em `User`.
- [ ] Adicionar `dependent: :destroy` em `has_many :profile_categories`, `has_many :proposals` (`app/models/profile.rb:3`, `app/models/category.rb:2`).
- [ ] Trocar `status` string solto por `enum` em `ServiceRequest` (`app/models/service_request.rb:6`) e `Proposal` (`app/models/proposal.rb:5`) — ex: `enum :status, { pending: "pending", ... }`.
- [ ] Adicionar validações faltantes em `Profile` (`phone`, `description`) e manter validações de `Address`/`Category` coerentes.

### 3. Banco / Migrations (AGENTS.md:10, 11)
- [ ] Criar migration para FK + índices faltantes: `service_requests.user_id`, `service_requests.category_id` (`db/migrate/20260416012359_create_service_requests.rb:4`) e `proposals.profile_id`, `proposals.service_request_id` (`db/migrate/20260416132825_create_proposals.rb:4`) com `null: false` onde fizer sentido. Hoje `db/schema.rb:70` não tem `add_foreign_key` para essas tabelas.

### 4. Views / Controllers (AGENTS.md:7, 9)
- [ ] `app/views/profiles/_form.html.erb:35` — `Category.all` dentro da view (query na view). Mover para `ProfilesController#new/edit` (`@categories = Category.order(:name)`).
- [ ] `app/views/profiles/_form.html.erb:1` e `app/views/addresses/_form.html.erb:1` — `url: profile_path` / `address_path` forçado quebra `POST` em `new`. Usar apenas `form_with(model: profile)` e deixar o Rails inferir a rota.
- [ ] `ProfilesController:25` / `AddressesController:24` — atribuição redundante de `@profile/@address` após `before_action :set_profile` (`app/controllers/profiles_controller.rb:4`).
- [ ] `app/views/layouts/_navbar.html.erb:40` — remover bloco comentado morto (44 linhas) e corrigir `app/views/layouts/_navbar.html.erb:1` `(click.away)` (sintaxe Alpine) incompatível com Stimulus.

### 5. Funcionalidades vs. README (MVP)
- [ ] README marca `[x]` para busca por categoria/localização, filtros Hotwire, avaliações e dashboard, mas não há implementação — ajustar README ou implementar incrementalmente.

### 6. Estilo / Lint (AGENTS.md:5)
- [ ] Rodar `bundle exec rubocop -a` — 16 offenses menores (ex: `ApplicationController:11` `SpaceInsideArrayLiteralBrackets`, trailing newlines em `Gemfile:35`, `db/seeds.rb:17`).

## Contribuição

Sinta-se à vontade para abrir issues ou enviar pull requests. Toda ajuda para conectar mais brasileiros ao seu próximo "trampo" é bem-vinda!