# Comandos: o que, quando, onde

Fonte única. O README do kit (`docs/kit.md` depois da configuração), o `AGENTS.md` e a aba "Comandos" do guia "Ciclo do Produto" espelham esta tabela: se mudar, mude aqui primeiro.

Todos os comandos de barra rodam no Claude Code, na pasta do projeto. Cada um termina dizendo qual é o próximo comando recomendado (o `/avaliar` diz o que fazer se reprovou ou aprovou; reprovada, a funcionalidade volta a `passes: false`).

| Comando | Quando | Onde | Quem decide o resultado |
| --- | --- | --- | --- |
| `/configurar-projeto <descrição>` | Uma vez, no início de um projeto (Portão 1 passado) | Claude Code, na pasta do projeto recém-criado | Você aprova a proposta antes de o kit ser configurado |
| `/proxima-feature [id]` | Uma vez por ciclo, depois do Portão 2. Em modo paralelo o id é obrigatório | Claude Code (ou ORCA), numa branch `feat/<id>` | Você faz o merge do PR |
| `/avaliar` | Depois de uma entrega delicada (segurança, dados, marco) ou quando o `/proxima-feature` pedir | Claude Code, na branch da funcionalidade | Você lê o relatório em `docs/exec-plans/active/` |
| `/limpeza` | Uma vez por semana (rotina de domingo) ou quando o contador de ciclos em `docs/estado-atual.md` chegar a 5 | Claude Code; se estiver na `main`, ele cria a branch `limpeza/<data>` | Você faz o merge |

Scripts (sem IA, rodam no terminal):

| Script | Quando |
| --- | --- |
| `./init.sh` | Início de toda sessão |
| `./scripts/check-docs.sh` | Antes de abrir PR; o GitHub roda sozinho em todo push |
| `./scripts/marcar-concluida.sh <id>` | Modo paralelo: no merge, para marcar `passes` e somar ao contador de ciclos |
| `./scripts/ralph.sh` | Só depois de alguns ciclos manuais (não testado contra o CLI). Aceita `RALPH_FLAGS` com flags do CLI, como `--permission-mode` e `--max-budget-usd` (exemplo no cabeçalho do script) |

## Rotina semanal (domingo)

Espelhada num cartão do Trello e na Fase 6 do guia "Ciclo do Produto". Os mesmos itens nos três lugares:

1. Rodar `/limpeza` em cada projeto e fazer o merge do PR dela.
2. Rodar `./scripts/check-docs.sh` e conferir se as Actions do GitHub estão verdes.
3. Revisar `docs/risks.md` e `docs/discovery/kill-criteria.md` (algum critério foi atingido?).
4. Escolher as funcionalidades da semana (`/proxima-feature <id>`).
5. Uma vez por mês, se saiu modelo novo, rodar os evals pessoais (`docs/decisions.md`).

## Contador de ciclos

`docs/estado-atual.md` tem a linha "Ciclos desde a última /limpeza". O `generator` soma 1 ao concluir um ciclo, uma vez por funcionalidade (o retrabalho depois de REPROVADO não soma de novo) (em modo paralelo ele não toca no arquivo: quem soma é o `marcar-concluida.sh`, no merge) e o `/limpeza` zera. Com 5 ou mais, o `/proxima-feature` avisa no relatório final.
