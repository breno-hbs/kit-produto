# Processo: 4 blocos e portões

Toda ideia até um produto real passa por 4 blocos. Cada um termina num artefato e num portão de decisão. O portão trava o INVESTIMENTO (tempo, dinheiro, escopo) numa aposta ainda não validada, não qualquer atividade fora de ordem. Depois do primeiro MVP, Descobrir e Entregar rodam em paralelo (dual-track): o portão passa a ser "aprovar antes de comprometer recursos numa aposta grande nova".

Leia só o bloco atual: `processo/bloco-1-descobrir.md`, `processo/bloco-2-definir.md`, `processo/bloco-3-entregar.md`, `processo/bloco-4-sustentar.md`.

| Bloco | Pergunta central | Portão para avançar |
| --- | --- | --- |
| 1. Descobrir | O problema é real e vale resolver? | Evidência de pessoas reais; hipótese mais arriscada testada; critérios de parada escritos |
| 2. Definir | O que exatamente vamos fazer, e como? | Cada funcionalidade com critério testável; decisões com motivo escrito |
| 3. Entregar | Funciona para pessoas reais? | Testes e avaliação passam; plano de reversão testado |
| 4. Sustentar | Continua funcionando e evoluindo? | Métricas, custo e incidentes sob controle |

Rastreabilidade: por quê (visão) → o quê (spec e `feature_list.json`) → como (`ARCHITECTURE.md`) → provar (testes e avaliação). Funcionalidade que não aponta para uma necessidade do produto é candidata a corte.

## Princípios

1. Documentos são a memória, não a sua cabeça nem o histórico do chat.
2. Cada fase termina com um artefato e um portão.
3. Profundidade proporcional: pule, faça o mínimo ou faça completo.
4. A IA executa, você mantém o julgamento.
5. Valide primeiro a hipótese mais arriscada, e barato.
6. Uma fonte de verdade por assunto.
7. Tudo é rastreável.
8. Meça em vez de achar.

## Profundidade proporcional

Registre em `docs/depth.md` o nível de cada item (Pulado, Mínimo ou Completo) e o motivo. Suba o nível quando: outras pessoas vão usar; há dado pessoal ou financeiro de terceiros; há dinheiro envolvido; a ação é difícil de desfazer; um erro afeta reputação ou saúde de alguém.

Um item do portão que não se aplica ao nível escolhido precisa de uma linha em `docs/depth.md` explicando por quê. Sem isso, o portão não passa.

## Onde cada coisa mora neste kit

| Documento do processo | Arquivo no kit |
| --- | --- |
| Ideia, pesquisa, usuários, hipóteses, validação | `docs/discovery/idea.md` e `docs/discovery/validacao.md` |
| Critérios de parada | `docs/discovery/kill-criteria.md` |
| Visão, escopo do MVP, não faremos, métricas, requisitos, roadmap | `docs/product-specs/index.md` |
| Design e identidade, fluxos | `docs/FRONTEND.md` (+ telas no Paper) |
| Arquitetura, dados | `ARCHITECTURE.md` |
| Decisões com motivo (ADR leve) | `docs/decisions.md` |
| Legal, privacidade e segurança | `docs/SECURITY.md` |
| Tarefas e critério de pronto | `feature_list.json` + regras do `AGENTS.md` |
| Estado atual (handoff) | `docs/estado-atual.md` |
| Riscos | `docs/risks.md` |
| Profundidade por item | `docs/depth.md` |
| Deploy, reversão, incidentes, backup | `docs/operacao.md` |
| IA no produto (modelos, guardrails, dados, avaliações) | `docs/ia.md` (só se o produto usa IA) |
