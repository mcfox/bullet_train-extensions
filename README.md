# bullet_train-extensions

Engine Rails com helpers e partials Tailwind reutilizáveis (Bullet Train / Rails).

## O que inclui
- Helper TailwindUiHelpers#show_tabs
- Partials de atributos: toggle, pre, json, cents, workflow_state
- Partials de fields: toggle_field, cents_field
- Suporte para resolução de caminhos em `themes/attributes` e `themes/filoo/attributes` (e equivalentes para fields)

## Como usar neste projeto (path gem)
1. No Gemfile já existe:

```ruby
gem "bullet_train-extensions", path: "../bullet_train-extensions"
```

2. Rode `bundle install` e reinicie o servidor.

3. Use nas views normalmente, por exemplo:

```erb
<%= render "themes/attributes/toggle", object: @record, attribute: :active %>
<%= render "themes/fields/toggle_field", form: f, method: :active %>
<%= show_tabs({ "Aba 1" => "partial/path", "Aba 2" => { partial: "other/path", locals: { foo: 1 } } }) %>
```

## Como publicar no RubyGems
1. Garanta que você tem uma conta no RubyGems e que `gem signin` está configurado.
2. Atualize a versão em `version.rb`.
3. Gere o `.gem`:

```bash
cd bullet_train-extensions
gem build bullet_train-extensions.gemspec
```

4. Faça o push:

```bash
gem push bullet_train-extensions-<versao>.gem
```

5. Em outros projetos, basta adicionar no Gemfile:

```ruby
gem "bullet_train-extensions"
```

ou usar via Git:

```ruby
gem "bullet_train-extensions", github: "mcfox/bullet_train-extensions"
```

## Notas
- O engine não isola namespace para facilitar a resolução de partials.
- O helper é incluído automaticamente no ActionView.
- Se você tiver mais partials (ex.: json_field, workflow_state_field, etc.), adicione-os em `app/views/themes/...` dentro do engine.

## Devo subir o arquivo .gem para o GitHub?
Não. O arquivo .gem é um artefato gerado e não deve ser commitado no repositório.

O fluxo recomendado é:
- Gere o .gem localmente apenas para testar/validar a gemspec (como no CI).
- Publique no RubyGems com `gem push` (veja a seção acima).
- Adicione `*.gem` ao `.gitignore` (já configurado neste repo) para evitar commits acidentais.
- Se quiser disponibilizar binários/artefatos, use GitHub Releases, mas ainda assim não versione o `.gem` no git.
