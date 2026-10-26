# Comandos: o que, quando, onde

Fonte única. O README, o `AGENTS.md` e a aba "Comandos" do guia "Ciclo do Produto" espelham esta tabela: se mudar, mude aqui primeiro.

Todos os comandos de barra rodam no Claude Code, na pasta do projeto. Cada um termina dizendo qual é o próximo comando recomendado.

| Comando | Quando | Onde | Quem decide o resultado |
| --- | --- | --- | --- |
| `/configurar-projeto <descrição>` | Uma vez, no início de um projeto (Portão 1 passado) | Claude Code, na pasta do projeto recém-criado | Você aprova a proposta antes de qualquer gravação |
| `/proxima-feature [id]` | Uma vez por ciclo, depois do Portão 2. Em modo paralelo o id é obrigatório | Claude Code (ou ORCA), numa branch `feat/<id>` | Você faz o merge do PR |
| `/avaliar` | Depois de uma entrega delicada (segurança, dados, marco) ou quando o `/proxima-feature` pedir | Claude Code, na branch da funcionalidade | Você lê o relatório em `docs/exec-plans/active/` |
| `/limpeza` | Uma vez por semana (rotina de domingo) ou quando o contador de ciclos em `docs/estado-atual.md` chegar a 5 | Claude Code, numa branch `limpeza/<data>` | Você faz o merge |

Scripts (sem IA, rodam no terminal):

| Script | Quando |
| --- | --- |
| `./init.sh` | Início de toda sessão |
| `./scripts/check-docs.sh` | Antes de abrir PR; o GitHub roda sozinho em todo push |
| `./scripts/marcar-concluida.sh <id>` | Modo paralelo: no merge, para marcar `passes` e somar ao contador de ciclos |
| `./scripts/ralph.sh` | Só depois de alguns ciclos manuais (não testado contra o CLI) |

## Contador de ciclos

`docs/estado-atual.md` tem a linha "Ciclos desde a última /limpeza". O `generator` soma 1 ao concluir um ciclo (em modo paralelo, quem soma é o `marcar-concluida.sh`, no merge) e o `/limpeza` zera. Com 5 ou mais, o `/proxima-feature` avisa no relatório final.
