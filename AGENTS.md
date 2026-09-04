# AGENTS.md

## 1. Objetivo

Este projeto é uma aplicação Ruby on Rails.

### Stack principal

- Ruby
- Ruby on Rails
- PostgreSQL
- Tailwind CSS
- RSpec

O objetivo é manter uma aplicação simples, idiomática, testável e fácil de manter.

**Priorize sempre a solução mais simples que resolva o problema.**

---

## 2. Regra principal

**Não faça grandes modificações sem necessidade.**

Antes de alterar o código:

1. Entenda a implementação existente.
2. Identifique o menor conjunto de arquivos necessário para resolver o problema.
3. Preserve a arquitetura e os padrões já utilizados no projeto.
4. Evite refatorações que não sejam necessárias para a tarefa.
5. Não altere código não relacionado ao problema.

Se uma solução exigir uma mudança arquitetural significativa, explique primeiro:

- o motivo;
- o impacto;
- as alternativas possíveis.

Não implemente mudanças arquiteturais significativas sem confirmação.

---

## 3. Filosofia Rails

Siga as convenções e boas práticas do Ruby on Rails.

### Prioridades

1. Convenções do Rails antes de soluções customizadas.
2. Código simples antes de abstrações prematuras.
3. Active Record antes de introduzir camadas desnecessárias.
4. Controllers RESTful.
5. Routes RESTful.
6. Regras de negócio próximas ao domínio quando fizer sentido.
7. Service Objects somente quando houver complexidade real.
8. Evitar callbacks quando uma solução explícita for mais clara.
9. Evitar concerns quando eles não trouxerem uma reutilização real.
10. Priorizar legibilidade e manutenção.

### Evite abstrações prematuras

Não transforme automaticamente código simples em:

- Service Objects;
- Interactors;
- Repositories;
- Form Objects;
- Query Objects;
- Concerns;
- Design Patterns.

Essas abstrações devem existir somente quando houver uma necessidade clara.

---

## 4. Escopo das alterações

Ao implementar uma tarefa:

- Faça somente o que foi solicitado.
- Não aproveite a tarefa para refatorar outras partes do sistema.
- Não reorganize diretórios sem necessidade.
- Não renomeie classes, métodos ou arquivos sem necessidade.
- Não altere a estrutura do banco sem necessidade.
- Não substitua uma implementação existente apenas porque existe outra abordagem que você prefere.
- Não modifique funcionalidades não relacionadas à tarefa.

Se encontrar problemas não relacionados à tarefa, apenas informe-os.

---

## 5. Ruby

Escreva Ruby idiomático, simples e legível.

### Prefira

- métodos pequenos;
- nomes claros;
- guard clauses;
- early return quando melhorar a legibilidade;
- composição simples;
- código explícito;
- responsabilidades bem definidas.

### Evite

- metaprogramação desnecessária;
- métodos excessivamente genéricos;
- abstrações prematuras;
- código excessivamente "inteligente";
- one-liners difíceis de entender;
- soluções excessivamente complexas para problemas simples.

**Legibilidade é mais importante do que reduzir a quantidade de linhas.**

---

## 6. Models

Utilize Active Record de forma idiomática.

### Boas práticas

- Utilize associações corretamente.
- Utilize validações quando apropriado.
- Utilize scopes quando melhorarem a legibilidade ou forem reutilizados.
- Mantenha regras relacionadas ao domínio próximas do model quando isso fizer sentido.
- Utilize enums do Rails quando apropriado.
- Utilize callbacks somente quando realmente necessários.

### Evite

- Models gigantes.
- Callbacks complexos.
- Queries espalhadas pelo código.
- Abstrações desnecessárias.
- Colocar toda a lógica da aplicação dentro dos models.

Não mova lógica para outro objeto simplesmente para "deixar o model pequeno".

A separação deve existir quando houver uma responsabilidade real.

---

## 7. Controllers

Controllers devem permanecer pequenos e focados em HTTP.

### Responsabilidades

Controllers devem principalmente:

- receber requisições;
- validar parâmetros;
- chamar o domínio apropriado;
- decidir a resposta;
- redirecionar ou renderizar.

### Exemplo

```ruby
def create
  @post = current_user.posts.build(post_params)

  if @post.save
    redirect_to @post
  else
    render :new, status: :unprocessable_entity
  end
end
```

Evite colocar regras complexas de negócio diretamente no controller.

Utilize private methods para parâmetros e pequenas responsabilidades auxiliares.

---

## 8. Routes

Utilize rotas RESTful sempre que possível.

Prefira:

```ruby
resources :posts
```

a criar diversas rotas customizadas sem necessidade.

Evite criar rotas customizadas quando uma rota RESTful existente resolver o problema.

Não altere a estrutura das rotas sem necessidade.

---

## 9. Views

Mantenha as views simples.

### Prefira

- HTML semântico;
- partials quando houver repetição real;
- helpers para pequenas transformações de apresentação;
- componentes existentes do projeto;
- Tailwind seguindo o padrão já utilizado.

### Evite

- lógica de negócio nas views;
- queries diretamente nas views;
- JavaScript quando HTML/CSS/Rails já resolverem o problema;
- criação excessiva de partials sem reutilização real.

Não transforme toda pequena repetição em uma abstração.

---

## 10. PostgreSQL

Utilize PostgreSQL de forma idiomática.

Ao alterar o banco:

- sempre utilize migrations;
- nunca altere o schema manualmente quando uma migration for apropriada;
- utilize foreign keys quando apropriado;
- utilize índices quando necessário;
- preserve integridade referencial;
- considere constraints quando fizer sentido.

### Índices

Considere índices para colunas frequentemente utilizadas em:

- buscas;
- joins;
- foreign keys;
- ordenações;
- filtros.

Não crie índices indiscriminadamente.

### Alterações destrutivas

Nunca execute automaticamente operações destrutivas.

Exemplos:

- remover tabelas;
- remover colunas;
- apagar dados;
- alterar dados existentes;
- migrations destrutivas.

Essas alterações exigem confirmação explícita.

---

## 11. Migrations

Migrations devem ser pequenas e claras.

Ao criar uma migration:

1. Utilize os generators do Rails quando apropriado.
2. Revise a migration gerada.
3. Considere índices e foreign keys.
4. Não coloque lógica de negócio em migrations.
5. Evite migrations excessivamente complexas.

Não altere migrations antigas que já foram executadas em ambientes compartilhados ou produção, salvo quando houver uma razão clara e confirmação.

Prefira criar uma nova migration.

---

## 12. Tailwind CSS

Utilize Tailwind seguindo o padrão existente no projeto.

### Regras

- Preserve o design atual.
- Utilize as classes existentes quando possível.
- Evite introduzir outra biblioteca de UI.
- Evite CSS customizado quando Tailwind resolver adequadamente.
- Não altere componentes visuais não relacionados à tarefa.
- Não faça redesign sem solicitação explícita.

Se já existir um padrão visual no projeto, siga esse padrão.

---

## 13. RSpec

Testes fazem parte da implementação.

Sempre que alterar comportamento:

1. Procure os testes existentes.
2. Entenda o comportamento esperado.
3. Atualize os testes quando necessário.
4. Adicione testes para comportamentos novos.
5. Execute os testes relacionados.
6. Sempre que possível, execute a suíte completa.

### Princípios

Priorize testes de comportamento.

Evite testes excessivamente acoplados à implementação interna.

Não altere testes apenas para fazê-los passar.

Se o teste estiver correto e a implementação estiver errada, corrija a implementação.

---

## 14. Testes antes da implementação

Antes de alterar uma funcionalidade existente:

- procure os testes relacionados;
- entenda o comportamento esperado;
- identifique casos existentes;
- preserve os comportamentos que não fazem parte da tarefa.

Quando apropriado, escreva ou ajuste o teste antes de modificar a implementação.

---

## 15. Gems e dependências

**Não adicione novas gems automaticamente.**

Antes de adicionar uma gem:

1. Verifique se o Rails já possui uma solução.
2. Verifique se Ruby já possui uma solução adequada.
3. Verifique se alguma dependência existente resolve o problema.
4. Avalie a complexidade adicionada.
5. Avalie o impacto de manutenção.
6. Explique a necessidade antes de adicionar a dependência.

### Regra

> Nunca adicione uma gem apenas por conveniência.

Uma nova dependência deve resolver um problema real.

---

## 16. Segurança

Não introduza práticas inseguras.

Tenha atenção especial a:

- SQL Injection;
- XSS;
- CSRF;
- mass assignment;
- autenticação;
- autorização;
- exposição de dados;
- parâmetros recebidos pelo usuário;
- uploads;
- secrets;
- tokens;
- credenciais.

Nunca coloque:

- senhas;
- tokens;
- API keys;
- secrets;
- credenciais

diretamente no código ou no repositório.

Utilize os mecanismos apropriados do Rails para secrets e credenciais.

---

## 17. Antes de modificar qualquer arquivo

Antes de editar:

1. Leia o código relacionado.
2. Procure os testes existentes.
3. Procure implementações semelhantes no projeto.
4. Entenda como a funcionalidade funciona atualmente.
5. Identifique as dependências da mudança.
6. Determine o menor conjunto de alterações necessário.

**Não faça alterações baseadas apenas em suposições.**

---

## 18. Durante a implementação

Faça alterações incrementais.

Após cada mudança significativa:

- verifique erros de sintaxe;
- execute os testes relacionados;
- verifique possíveis regressões;
- mantenha o diff pequeno;
- preserve o estilo existente.

### Evite

Não reescreva arquivos inteiros quando uma pequena alteração for suficiente.

Não formate ou reorganize arquivos inteiros sem necessidade.

Não altere código que não precisa ser alterado.

---

## 19. Antes de finalizar

Antes de considerar uma tarefa concluída:

- execute os testes relevantes;
- execute a suíte completa quando possível;
- verifique migrations;
- verifique rotas quando aplicável;
- execute lint quando configurado;
- verifique erros de sintaxe;
- revise o diff;
- confirme que somente arquivos necessários foram modificados.

O resultado final deve conter somente as alterações necessárias para a tarefa.

---

## 20. Mudanças que exigem confirmação

Peça confirmação antes de executar:

- remover tabelas;
- remover colunas;
- apagar dados;
- alterar dados existentes;
- executar migrations destrutivas;
- adicionar dependências importantes;
- trocar bibliotecas;
- alterar autenticação;
- alterar autorização;
- modificar arquitetura;
- introduzir uma nova camada arquitetural;
- realizar grandes refatorações;
- alterar configurações de produção;
- alterar infraestrutura;
- alterar deploy;
- modificar comportamento de funcionalidades não relacionadas.

---

## 21. Regra contra overengineering

Quando houver duas soluções válidas, prefira a solução:

- menor;
- mais simples;
- mais idiomática para Rails;
- mais fácil de testar;
- mais fácil de entender;
- que introduza menos código;
- que altere menos arquivos;
- que utilize recursos existentes.

### Regra de ouro

> Faça a menor mudança possível para produzir a solução correta.

Não otimize código que não precisa ser otimizado.

Não crie abstrações para problemas que ainda não existem.

Não transforme uma tarefa simples em uma refatoração arquitetural.

---

## 22. Preservação do código existente

O código existente deve ser tratado como uma decisão arquitetural já tomada, salvo quando houver evidência de que precisa ser alterado.

Antes de substituir uma implementação:

- entenda por que ela existe;
- procure usos;
- procure testes;
- procure dependências;
- considere possíveis efeitos colaterais.

Não substitua código simplesmente por preferência pessoal.

---

## 23. Compatibilidade

Ao implementar uma mudança:

- preserve APIs existentes quando possível;
- preserve rotas existentes quando possível;
- preserve contratos existentes;
- preserve comportamento não relacionado;
- evite breaking changes.

Se uma breaking change for necessária, explique antes.

---

## 24. Performance

Não faça otimizações prematuras.

Primeiro priorize:

1. Correção.
2. Clareza.
3. Manutenibilidade.

Otimize quando houver:

- evidência de problema;
- query claramente ineficiente;
- N+1 conhecido;
- processamento desnecessário;
- gargalo identificado.

Não complique o código apenas para uma possível melhoria futura.

---

## 25. Comunicação

Antes de implementar uma tarefa complexa, apresente brevemente:

- o que será alterado;
- quais arquivos provavelmente serão modificados;
- como pretende testar;
- possíveis impactos.

Para tarefas simples, não é necessário criar um plano extenso.

Após implementar, informe:

- o que foi alterado;
- testes executados;
- eventuais problemas encontrados;
- decisões importantes tomadas.

Se houver dúvida sobre requisito ou comportamento esperado:

**pergunte antes de assumir.**

---

## 26. Prioridades

Ao tomar decisões técnicas, utilize esta ordem de prioridade:

1. Correção
2. Segurança
3. Simplicidade
4. Convenções Rails
5. Testabilidade
6. Manutenibilidade
7. Performance quando houver necessidade real

---

## 27. Checklist final

Antes de finalizar qualquer tarefa, confirme:

- [ ] A alteração resolve exatamente o problema solicitado?
- [ ] Evitei alterações fora do escopo?
- [ ] Preservei a arquitetura existente?
- [ ] Segui as convenções do Rails?
- [ ] Evitei abstrações desnecessárias?
- [ ] Evitei adicionar gems sem necessidade?
- [ ] Atualizei ou criei os testes necessários?
- [ ] Executei os testes relevantes?
- [ ] Revisei as migrations?
- [ ] Revisei as rotas quando aplicável?
- [ ] Verifiquei segurança?
- [ ] Revisei o diff?
- [ ] O código continua simples e legível?

---

## 28. Princípio final

Este projeto deve evoluir de forma incremental.

**Não tente melhorar tudo de uma vez.**

Prefira:

> uma pequena mudança correta

em vez de:

> uma grande mudança "perfeita".

O agente deve atuar como um desenvolvedor Rails cuidadoso, preservando o que já funciona e modificando somente o necessário.