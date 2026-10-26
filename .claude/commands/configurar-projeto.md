---
description: Início de projeto novo (ou existente): confere o Portão 1, faz o brainstorming, classifica e propõe a configuração do kit sob medida. Nada é gravado sem aprovação.
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
- Grave o design aprovado em `docs/product-specs/brainstorm.md`.
- Quando a skill sugerir seguir para outra skill de plano (ex.: `writing-plans`), NÃO siga: neste kit o planejamento é do agente `planner` e vem no passo 4.
- Diferencie fato, hipótese e suposição no que gravar.

## 2. Classificar

Com base no design aprovado, classifique o projeto como simples, intermediário ou complexo (usuários, funcionalidades, integrações, dados sensíveis, impacto de falha, custo). Justifique em 3 linhas e registre o nível de cada item em `docs/depth.md`.

## 3. Propor a configuração (PARE aqui e mostre; não grave nada)

Apresente no chat, em formato curto:

- Valores para `AGENTS.md`: nome, objetivo, complexidade, comandos de teste e lint.
- `ARCHITECTURE.md`: camadas adequadas à stack e ao tamanho (projeto simples: 2 a 3 camadas), invariantes, bordas onde dados externos são parseados em tipos precisos (o equivalente da stack: Pydantic, Zod, Bean Validation etc.) e o modelo de dados.
- `init.sh`: o que instalar, como subir e qual teste básico de ponta a ponta.
- O que MANTER e o que REMOVER do kit, com motivo. Padrão: simples = `generator` + `evaluator` opcional e poucos documentos; intermediário = os 4 agentes; complexo = tudo, com `QUALITY_SCORE`, `SECURITY` e `operacao` completos. `docs/ia.md` só se o produto usa IA. Remover é a regra, não a exceção.
- Se houver interface: link do Paper em `docs/FRONTEND.md` e se vale instalar o plugin `frontend-design`.
- Permissões extras para `.claude/settings.json` (arquivos com credenciais da stack).
- Se o humano usa o Codex: se mantém os papéis em `.codex/agents/` (ver README).
- Lista "Sempre precisa de humano neste projeto" para `docs/SECURITY.md` (cobrança, acesso, dados, mensagens a usuários, produção), perguntando ao humano o que se aplica.
- Riscos e perguntas em aberto.

Espere a aprovação do humano. Aplique só o que ele aprovar.

## 4. Aplicar (depois da aprovação)

1. Preencha `AGENTS.md`, `ARCHITECTURE.md`, `init.sh` e `.claude/settings.json` como aprovado.
2. Remova o que foi aprovado remover e ajuste as listas de `scripts/check-docs.sh` e as referências em `AGENTS.md` e `processo/processo.md` para que nenhum ponteiro fique quebrado.
3. Use o agente `planner` com o design aprovado e `docs/discovery/` para gerar `docs/product-specs/index.md` e `feature_list.json`.
4. Rode `./scripts/check-docs.sh` e corrija até passar. `init.sh` ainda terá TODO se o ambiente não puder subir agora: diga isso explicitamente.
5. Registre em `docs/estado-atual.md` (onde estamos, o que ficou pendente) e em `docs/decisions.md` (o que foi decidido, o que foi removido e por quê).

Entregue em poucas linhas o que foi feito, as evidências (saída do `check-docs.sh`) e a próxima ação: revisar `feature_list.json` e rodar `/proxima-feature`.

Descrição do projeto / contexto: $ARGUMENTS
