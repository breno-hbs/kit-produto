# kit-produto

Kit único para ir de uma ideia a um produto com agentes de IA. Junta o processo do guia "Do Zero ao Produto com Agentes" (4 blocos e portões), o harness de execução (AGENTS.md, feature_list.json, planner, generator, evaluator) e as práticas de Anthropic e OpenAI sobre agentes de longa duração.

Princípio: o mínimo que funciona. Cada peça existe porque supomos que o modelo não faz aquilo sozinho. Teste removendo uma peça por vez.

## Como usar

1. Instale uma vez a skill de brainstorming (terceiros, não incluída aqui): `npx skills add https://github.com/obra/superpowers --skill brainstorming`. Leia o `SKILL.md` instalado antes de confiar nele.
   Opcional: as skills do Matt Pocock (`npx skills@latest add mattpocock/skills`, escopo global, symlink) cobrem um fluxo parecido (grill-with-docs, to-spec, to-tickets, implement, code-review). Não estão neste kit para não duplicar peças; teste num projeto real e leia cada `SKILL.md` antes de confiar. Se usar o setup delas, escolha markdown local como issue tracker.
2. Para cada ideia nova: crie o repositório a partir desta pasta (`git init`, GitHub).
3. Abra o Claude Code na pasta (direto ou por uma sessão no ORCA) e rode `/configurar-projeto <descrição>`. Ele confere o Portão 1, faz o brainstorming, classifica o projeto e PROPÕE a configuração do kit antes de gravar qualquer coisa.
4. Revise `docs/product-specs/index.md` e `feature_list.json`. É o momento de maior alavancagem humana.
5. Rode `/proxima-feature`. Uma funcionalidade por ciclo. Leia `docs/estado-atual.md` depois.
6. Rode `/limpeza` uma vez por semana.
7. Só depois de alguns ciclos manuais considere `scripts/ralph.sh` (loop automático com limite; não foi testado contra o CLI).

## O que tem aqui

| Peça | Para quê |
| --- | --- |
| `AGENTS.md` (+ `CLAUDE.md` que o importa) | Índice curto e regras que o agente lê sempre |
| `processo/` | Os 4 blocos do guia, um arquivo por bloco, com portões e checklists. O agente lê só o bloco atual |
| `docs/discovery/` | Bloco 1: ideia, validação, critérios de parada |
| `docs/product-specs/` | Visão, escopo do MVP, o que não faremos, métricas |
| `feature_list.json` | Lista verificável de funcionalidades; agentes só mudam `passes` |
| `ARCHITECTURE.md` | Mapa do código, camadas, invariantes, dados |
| `docs/estado-atual.md`, `decisions.md`, `depth.md`, `risks.md` | Estado, decisões com motivo, profundidade por item, riscos |
| `docs/operacao.md`, `docs/SECURITY.md`, `docs/FRONTEND.md`, `docs/ia.md` | Deploy e incidentes, segurança e legal, design (com o Paper), IA no produto (opcional) |
| `init.sh` | Sobe o ambiente e testa o básico, sempre no início da sessão |
| `.claude/agents/` | planner, generator, evaluator, docs-gardener |
| `.codex/agents/` | generator e evaluator para o Codex, apontando para os mesmos arquivos (opcional, não testado) |
| `.claude/commands/` | `/configurar-projeto`, `/proxima-feature`, `/avaliar`, `/limpeza` |
| `scripts/check-docs.sh` | Verificação mecânica da base de conhecimento (rode no CI também) |

## Nomes unificados (o que mudou em relação ao guia e ao Playbook Template)

| Antes (guia e template) | Agora |
| --- | --- |
| construtor, revisor | `generator`, `evaluator` |
| `handoff.md` | `docs/estado-atual.md` |
| `tasks.md`, `definition-of-done.md` | `feature_list.json` + regras do `AGENTS.md` |
| `prd.md`, `vision.md`, `mvp-scope.md`, `metrics.md`, `roadmap.md` | `docs/product-specs/index.md` |
| `idea.md`, `research.md`, `users.md`, `assumptions.md`, `validation.md` | `docs/discovery/idea.md` e `validacao.md` |
| `adr/`, `decisions.md` | `docs/decisions.md` |
| `architecture.md`, `data-model.md`, `data-governance.md` | `ARCHITECTURE.md` |
| `brand.md`, `flows.md` | `docs/FRONTEND.md` |
| `legal.md`, `security.md` | `docs/SECURITY.md` |
| `runbook.md`, `incident-playbook.md`, `restore-test.md` | `docs/operacao.md` |
| `ai/models.md`, `guardrails.md`, `ai-data-policy.md`, `evals/`, `prompts/` | `docs/ia.md` |

O mapa completo está em `processo/processo.md`. Ao configurar um projeto, o `/configurar-projeto` remove o que o projeto não precisa.

## Codex (opcional)

O Codex lê `AGENTS.md` nativamente, e o `CLAUDE.md` de uma linha (`@AGENTS.md`) faz o Claude Code carregar as mesmas regras. Os subagentes não portam sozinhos: por isso `.codex/agents/` tem os papéis no formato TOML, mas só com um ponteiro para `.claude/agents/`, que é a fonte única. Não testado; não use `.codex/agents/` ainda. Sugestão: use o Codex só como revisor de diff depois de alguns ciclos estáveis. No ORCA, o menu do terminal do agente tem "Hand Off to Another Agent": abre uma sessão nova (pode ser o Codex) com um prompt de passagem gerado da sessão anterior. Cada aba de Codex roda o próprio servidor, então recursos compartilhados do Codex (como `codex agents`) não enxergam sessões iniciadas no ORCA.

## Setup (ORCA, Claude Code Pro, Paper, Fluid Voice)

- O ORCA orquestra; o Claude Code dentro dele lê o `CLAUDE.md`. Comece com um agente. Em paralelo: um agente por funcionalidade, um worktree cada; `passes` e `docs/estado-atual.md` só no merge, feito por você (regra 9 do `AGENTS.md`).
- Permissões: por padrão o ORCA abre o Claude com `--dangerously-skip-permissions`. Em projeto com dados ou deploy reais, mude em Settings → Agents para Manual ou Auto. Não testei se as regras `deny` de `.claude/settings.json` continuam valendo no modo sem prompts: verifique antes de confiar nelas.
- Worktree novo vem limpo (sem `.env`, `node_modules`). O `.worktreeinclude` copia o `.env` para cada worktree e o `init.sh` instala as dependências. Hook de criação: em Settings → Repository → Hooks do ORCA, configure `./init.sh` para rodar após criar o worktree. O `orca.yaml` traz o compartilhamento de `node_modules` desligado (dois agentes instalando ao mesmo tempo num diretório compartilhado podem se atrapalhar); ligue só se o custo de instalar incomodar.
- Painéis opcionais do ORCA: Agent Dashboard (experimental; quadro Working / Needs You / Done), Histórico de sessões (retoma com `claude --resume`) e Cmd-J (pula entre worktrees e abas). Não precisa ligar nenhum.
- Modelo por papel (`model:` em `.claude/agents/`): o modelo mais forte vale mais onde o erro se propaga, que é planejar (`planner`) e avaliar (`evaluator`); a execução (`generator`, `docs-gardener`) tolera um modelo mais barato com bons testes. Plano Pro: o kit vem com todos em Opus; se a cota apertar, passe `generator` e `docs-gardener` para `sonnet`; o avaliador é opcional. Reavalie a escolha a cada modelo novo.
- Paper Design: link do arquivo em `docs/FRONTEND.md`; o generator consulta antes de codar e o evaluator compara a tela com o quadro.
- Fluid Voice: dite o pedido, revise a transcrição antes de enviar e registre as decisões em `docs/`.

## Poucas skills e plugins

Skill, plugin e MCP demais podem atrapalhar: cada um pode forçar procedimentos que serviam para modelos menos capazes e hoje só limitam o agente, além de ocupar contexto. No Claude Code, rode `/skills` e desative as que o projeto não usa; rode `/context` para ver o peso. Mantenha só o que é crítico (por exemplo, `brainstorming` e, se houver interface, `frontend-design`) e teste removendo uma peça por vez, como o resto do kit.

## Quando NÃO usar tudo

- Projeto pequeno (script, protótipo de uma tarde): use só `AGENTS.md`, `init.sh`, `feature_list.json` e `docs/SECURITY.md` reduzido aos princípios mínimos e à lista "Sempre precisa de humano". Apague o resto (e tire os nomes apagados da lista do `scripts/check-docs.sh`).
- Avaliador: custa várias vezes mais e só compensa quando a tarefa está perto do limite do que o gerador faz sozinho. No teste da Anthropic o harness completo custou mais de 20 vezes o modo solo (US$ 200 contra US$ 9), com resultado visivelmente melhor, mas não é regra para tudo.
- Camadas rígidas de arquitetura: para projeto simples, reduza a duas ou três.

## Observações honestas

- Os resultados citados nos artigos de origem são relatos dos autores, sem verificação independente, e dependem de modelos e ferramentas específicos.
- O avaliador também é um modelo e tende a ser generoso. Calibre-o com exemplos seus em `docs/FRONTEND.md` e leia os relatórios nas primeiras rodadas.
- Em `.claude/settings.json` há só permissões negativas básicas (`.env`, `secrets/`, `rm -rf`, `push --force`). Elas barram as ferramentas de arquivo e comandos que citam o arquivo; um `grep -r` na pasta inteira pode escapar. Ative o sandbox do Claude Code e ajuste conforme o projeto antes de dar autonomia longa a qualquer agente.
- Este kit ainda não rodou num projeto real. O primeiro projeto vai mostrar o que cortar.

## Fontes de origem

Guia "Do Zero ao Produto com Agentes" e Playbook Template (do autor); OpenAI, "Harness engineering" (Ryan Lopopolo) e "Using PLANS.md for multi-hour problem solving"; Anthropic, "Effective harnesses for long-running agents", "Harness design for long-running application development", "Effective context engineering for AI agents", "Building effective agents"; Geoffrey Huntley, "Everything is a Ralph loop"; Alexis King, "Parse, don't validate"; matklad, "ARCHITECTURE.md"; agents.md; skill brainstorming do repositório obra/superpowers (uso opcional, instalada à parte); skills de Matt Pocock (mattpocock/skills; fluxo grill, spec, tickets, implement e review; uso opcional, instaladas à parte).
