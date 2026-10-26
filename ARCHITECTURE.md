# ARCHITECTURE

Revisar poucas vezes por ano. Escreva só o que muda pouco. Não tente manter este arquivo sincronizado linha a linha com o código.

## Visão geral

<Um parágrafo: que problema o sistema resolve, para quem, e as 3 a 5 partes principais.>

## Mapa do código (codemap)

Responde "onde está a coisa que faz X?" e "o que faz a coisa que estou olhando?". Cite nomes de módulos e tipos importantes, sem links: use busca de símbolo para achá-los.

- `<pasta/modulo>`: <o que faz, em uma linha>
- `<pasta/modulo>`: <o que faz, em uma linha>

## Camadas e direção de dependência

Dentro de cada domínio, o código só depende "para frente":

    Types -> Config -> Repo -> Service -> Runtime -> UI

Preocupações transversais (autenticação, telemetria, feature flags, conectores externos) entram por uma única interface explícita: `Providers`. Qualquer outro caminho de dependência é proibido.

Para projeto simples, reduza a poucas camadas (por exemplo `types`, `service`, `api`) e mantenha a regra de direção. Não construa camadas que ninguém usa.

## Módulos profundos e fronteiras de teste

Para cada módulo importante, registre a interface pública (poucas funções ou tipos) e o que ele esconde. A fronteira de teste fica em volta do módulo, não de cada função interna.

- `<modulo>`: interface `<funções ou tipos expostos>`; esconde `<o que fica dentro>`; testado por `<arquivo ou pasta de teste>`
- Se dois módulos pequenos só fazem sentido juntos, junte-os em um módulo profundo.

## Invariantes (o que NÃO pode acontecer)

Muitas regras importantes são ausências. Liste aqui:

- A camada `Types` não importa nada das outras camadas.
- A UI não acessa o banco diretamente.
- Nenhum dado externo é usado antes de ser parseado na borda (ver `docs/design-docs/core-beliefs.md`).
- <adicione os seus>

## Fronteiras

- Borda externa: <HTTP, CLI, filas, arquivos> onde os dados são parseados em tipos precisos.
- Borda de persistência: <banco, API de terceiros> e o módulo único responsável por ela.

## Preocupações transversais

Logging estruturado, tratamento de erros, configuração, segurança (ver `docs/SECURITY.md`).
