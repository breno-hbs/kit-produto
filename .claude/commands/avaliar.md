---
description: Roda o avaliador independente sobre a última entrega
---

Use o agente `evaluator` para avaliar a funcionalidade indicada em $ARGUMENTS (id) ou, sem id, a do último commit da branch atual (em modo paralelo `passes` só muda no merge, então não use ele para escolher). Mostre o veredito, as falhas com evidência e o que não foi possível testar. Não corrija nada: só reporte. Termine com o próximo comando recomendado: se REPROVADO, `passes` desse id deve voltar a `false` (se já estiver `true`, o humano ou o `generator` o muda); peça ao `generator` que corrija a partir do relatório no relatório mais recente `docs/exec-plans/active/avaliacao-<id>-r<N>.md` e rode `/avaliar <id>` de novo (no máximo 3 rodadas, depois a decisão é do humano); se APROVADO, o humano abre o PR e faz o merge, e então `/proxima-feature`.

