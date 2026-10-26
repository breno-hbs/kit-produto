---
description: Coleta de lixo: desvios de padrão, documentação velha e dívida técnica, em passos pequenos
---

Faça uma limpeza proporcional:

1. Use o agente `docs-gardener` para checar e corrigir a documentação.
2. Procure no código violações de `ARCHITECTURE.md` (direção de dependência, invariantes) e de `docs/design-docs/core-beliefs.md` (parsing na borda, logs estruturados, utilitários duplicados). Liste cada achado com arquivo e linha.
3. Corrija apenas o que for pequeno, seguro e coberto por testes, um item por commit. Registre o resto em `docs/exec-plans/tech-debt-tracker.md`.
4. Rode os testes antes e depois. Se piorar, reverta aquele item.
5. Resuma em poucas linhas o que foi feito e o que ficou na dívida.

Se um mesmo erro aparecer pela segunda vez, proponha transformá-lo em verificação mecânica em `scripts/check-docs.sh` ou em um teste estrutural, com mensagem de erro que explique a correção.

$ARGUMENTS
