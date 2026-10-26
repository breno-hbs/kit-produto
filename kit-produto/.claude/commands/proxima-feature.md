---
description: Executa um ciclo completo para a próxima funcionalidade pendente (um passo por vez)
---

Execute um ciclo completo para UMA funcionalidade:

1. Use o agente `generator` para implementar a funcionalidade de maior prioridade com `"passes": false` em `feature_list.json`, seguindo o procedimento dele (início de sessão, implementação, auto-verificação, commit, progresso).
2. Decida se o avaliador é necessário: use o agente `evaluator` se a funcionalidade for complexa, tocar segurança ou dados, ou se for o fechamento de um marco. Para funcionalidade simples e bem testada, pule e diga que pulou.
3. Se o avaliador reprovar, devolva o relatório ao `generator` para corrigir e reavalie. No máximo 3 rodadas; depois pare e peça decisão humana.
4. Ao final, informe em poucas linhas: o que foi entregue, evidência de verificação, o que ficou pendente e a próxima funcionalidade.

Não inicie uma segunda funcionalidade neste ciclo.

$ARGUMENTS
