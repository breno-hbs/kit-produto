---
description: Coleta de lixo: desvios de padrão, documentação velha e dívida técnica, em passos pequenos
---

Faça uma limpeza proporcional:

1. Use o agente `docs-gardener` para checar e corrigir a documentação.
2. Procure no código violações de `ARCHITECTURE.md` (direção de dependência, invariantes) e de `docs/design-docs/core-beliefs.md` (parsing na borda, logs estruturados, utilitários duplicados). Liste cada achado com arquivo e linha.
   Procure também módulos rasos: grupos de arquivos pequenos que só fazem sentido juntos, sem fronteira de teste clara. Proponha aprofundá-los (um módulo com interface pequena) e registre cada candidato com o motivo e onde ficaria o teste. Isso é mudança de desenho: não execute sem aprovação do humano.
   Procure também documentação que apodreceu: a spec de uma funcionalidade já concluída (`passes: true`) que descreve algo diferente do código atual. Feche-a: marque como concluída com a data, tire os detalhes que divergem do código e deixe as decisões e os motivos em `docs/decisions.md`. Spec velha lida como se fosse atual engana o agente.
   Mova para `docs/exec-plans/completed/` todos os relatórios `docs/exec-plans/active/avaliacao-<id>-r<N>.md` das funcionalidades já com `passes: true`.
3. Corrija apenas o que for pequeno, seguro e coberto por testes, um item por commit. Registre o resto em `docs/exec-plans/tech-debt-tracker.md`.
4. Rode os testes antes e depois. Se piorar, reverta aquele item.
5. Zere "Ciclos desde a última /limpeza" em `docs/estado-atual.md`. Resuma em poucas linhas o que foi feito e o que ficou na dívida e termine com o próximo comando recomendado (normalmente `/proxima-feature`).

Trabalhe numa branch `limpeza/<data>` se estiver na `main`; o merge é do humano (regra 8 do `AGENTS.md`).

Se um mesmo erro aparecer pela segunda vez, proponha transformá-lo em verificação mecânica em `scripts/check-docs.sh` ou em um teste estrutural, com mensagem de erro que explique a correção (ou em script, se o passo for mecânico). Itens de `docs/exec-plans/tech-debt-tracker.md` marcados com a palavra "repetido" contam como segunda vez: agrupe os parecidos antes de propor, porque o padrão aparece melhor no conjunto do que item a item.

$ARGUMENTS
