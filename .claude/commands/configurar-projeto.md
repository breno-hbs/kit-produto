---
description: Início de projeto novo (ou existente). Confere o Portão 1, faz o brainstorming, classifica e propõe a configuração do kit sob medida. Só grava o que você traz e o design aprovado; a configuração do kit só depois da sua aprovação.
---

Você configura este repositório para o projeto descrito abaixo. Siga a ordem. Pare nos pontos marcados e espere o humano.

## 0. Portão 1 (Descobrir)

Leia `processo/bloco-1-descobrir.md`. Pergunte ao humano o que já existe: problema, evidência de pessoas reais, hipótese mais arriscada, critérios de parada. Mostre quais itens do Portão 1 estão cumpridos e quais faltam.

- Item faltando: o humano decide entre fazer a validação antes ou seguir assim mesmo. Se seguir, registre o item e o motivo em `docs/depth.md`.
- Projeto já existente (o repositório tem código): trate o Portão 1 como já passado, registre isso em `docs/depth.md` e descreva o código atual em vez de inventar estrutura.
- Guarde o que o humano trouxer em `docs/discovery/` (ideia, validação, critérios de parada). Não invente pesquisa, dados ou validação.

## 1. Brainstorming (obrigatório em todo projeto novo)

Use a skill `brainstorming` (instalada com `npx skills add https://github.com/obra/superpowers --skill brainstorming`). Se ela não estiver disponível, pare e diga ao humano o comando de instalação; só continue sem ela se ele mandar.

- Conduza o diálogo de design com o humano até ele aprovar o design. Não escreva código nem estrutura antes disso.
- Se uma dúvida de design só se resolve rodando algo, faça antes um protótipo curto e descartável (fora do código do produto) e só então aprove o design.
- Grave o design aprovado em `docs/product-specs/brainstorm.md`.
- Quando a skill sugerir seguir para outra skill de plano (ex.: `writing-plans`), NÃO siga: neste kit o planejamento é do agente `planner` e vem no passo 4.
- Diferencie fato, hipótese e suposição no que gravar.

## 2. Classificar

Com base no design aprovado, classifique o projeto como simples, intermediário ou complexo (usuários, funcionalidades, integrações, dados sensíveis, impacto de falha, custo). Justifique em 3 linhas e registre o nível de cada item em `docs/depth.md`.

## 3. Propor a configuração (PARE aqui e mostre; não grave nenhuma configuração do kit)

Apresente no chat, em formato curto:

- Valores para `AGENTS.md`: nome, objetivo, complexidade, comandos de teste e lint.
- `ARCHITECTURE.md`: camadas adequadas à stack e ao tamanho (projeto simples: 2 a 3 camadas), invariantes, bordas onde dados externos são parseados em tipos precisos (o equivalente da stack: Pydantic, Zod, Bean Validation etc.) e o modelo de dados.
- `init.sh`: o que instalar, como subir e qual teste básico de ponta a ponta.
- O que MANTER e o que REMOVER do kit, com motivo. Padrão: simples = `generator` + `evaluator` opcional e poucos documentos; intermediário = os 4 agentes; complexo = tudo, com `QUALITY_SCORE`, `SECURITY` e `operacao` completos. `docs/ia.md` só se o produto usa IA. Remover é a regra, não a exceção, com uma exceção: nunca remova `docs/SECURITY.md`; num projeto simples, reduza-o aos princípios mínimos e à lista "Sempre precisa de humano".
- Se houver interface: link do Paper em `docs/FRONTEND.md` e se vale instalar o plugin `frontend-design`.
- Permissões extras para `.claude/settings.json` (arquivos com credenciais da stack).
- Se o humano usa o Codex: se mantém os papéis em `.codex/agents/` (ver o README do kit, que depois da configuração fica em `docs/kit.md`).
- Lista "Sempre precisa de humano neste projeto" para `docs/SECURITY.md` (cobrança, acesso, dados, mensagens a usuários, produção), perguntando ao humano o que se aplica.
- Riscos e perguntas em aberto.

Espere a aprovação do humano. Aplique só o que ele aprovar.

## 4. Aplicar (depois da aprovação)

1. Preencha `AGENTS.md`, `ARCHITECTURE.md`, `init.sh` e `.claude/settings.json` como aprovado.
2. Remova o que foi aprovado remover e ajuste as listas de `scripts/check-docs.sh` e as referências em `AGENTS.md`, `processo/processo.md`, `.claude/agents/`, `.claude/commands/` e `docs/comandos.md` para que nenhum ponteiro fique quebrado.
3. Use o agente `planner` com o design aprovado e `docs/discovery/` para gerar `docs/product-specs/index.md` e `feature_list.json`.
4. Mova o `README.md` do kit para `docs/kit.md` (`git mv`) e crie um `README.md` curto do projeto: nome, objetivo, como subir com `./init.sh` e um ponteiro para `AGENTS.md`. Assim quem abre o repositório lê sobre o produto, não sobre o kit.
5. Acrescente ao `.github/workflows/check-docs.yml` os passos que preparam a stack (ex.: `actions/setup-node`, `actions/setup-python`) e rodam o comando de teste e lint aprovado em `AGENTS.md`. Hoje o workflow só valida a estrutura do repositório (`check-docs.sh`); sem este passo, o check verde do PR não diz que os testes do produto passam. Se o projeto ainda não tem testes, registre isso em `docs/exec-plans/tech-debt-tracker.md` e diga ao humano.
6. Rode `./scripts/check-docs.sh` e corrija até passar. `init.sh` ainda terá TODO se o ambiente não puder subir agora: diga isso explicitamente.
7. Registre em `docs/estado-atual.md` (onde estamos, o que ficou pendente; preserve a linha "Ciclos desde a última /limpeza: 0", que o `generator`, o `/limpeza` e o `marcar-concluida.sh` usam e o `check-docs.sh` exige) e em `docs/decisions.md` (o que foi decidido, o que foi removido e por quê).

Entregue em poucas linhas o que foi feito, as evidências (saída do `check-docs.sh`) e a próxima ação: revisar `feature_list.json` e rodar `/proxima-feature`.

Descrição do projeto / contexto: $ARGUMENTS
