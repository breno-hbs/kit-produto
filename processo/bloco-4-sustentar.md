# Bloco 4: Sustentar

Objetivo: manter o produto funcionando, aprender com o uso real e decidir o que melhorar, manter ou encerrar. Depois do MVP, descoberta e entrega correm em paralelo.

| Fase | Pergunta | Onde registrar | Portão |
| --- | --- | --- | --- |
| Operação | Como sei que quebrou? | `docs/operacao.md` | Alertas chegam a uma pessoa; custo tem teto |
| Incidentes | O que faço quando quebra? | `docs/operacao.md` | Dono, canal e passos definidos |
| Backup | Consigo restaurar? | `docs/operacao.md` | Restauração testada, não só configurada |
| Suporte | Como os usuários falam comigo? | `docs/discovery/validacao.md` | Todo feedback tem destino |
| Crescimento | O que melhora agora? | `feature_list.json` | Cada experimento tem hipótese e critério de sucesso |
| Dívida técnica | O que limpar e atualizar? | `docs/exec-plans/tech-debt-tracker.md` | Dívida listada e priorizada; vulnerabilidades tratadas |
| Encerramento | Como desligo com segurança? | `docs/operacao.md` | Usuários avisados; dados tratados conforme a política |

Rotina: `/limpeza` toda semana; `./scripts/check-docs.sh` no CI; depois de alguns ciclos, remover do kit o que ninguém usou.
