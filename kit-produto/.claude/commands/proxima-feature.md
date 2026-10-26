---
description: Executa um ciclo completo para a próxima funcionalidade pendente (um passo por vez)
---

Execute um ciclo completo para UMA funcionalidade:

0. Antes de implementar, avalie o tamanho da funcionalidade de maior prioridade com `"passes": false`. Se ela não cabe numa única janela de contexto (ou passa de ~500 linhas de lógica; testes, docs e JSON/YAML não contam), pare e peça ao humano para dividi-la em `feature_list.json`. Não comece uma funcionalidade grande demais.
1. Use o agente `generator` para implementar a funcionalidade de maior prioridade com `"passes": false` em `feature_list.json`, seguindo o procedimento dele (início de sessão, implementação, auto-verificação, commit, progresso).
2. Decida se o avaliador é necessário: use o agente `evaluator` se a funcionalidade for complexa, tocar segurança ou dados, ou se for o fechamento de um marco. Para funcionalidade simples e bem testada, pule e diga que pulou.
3. Se o avaliador reprovar, devolva o relatório ao `generator` para corrigir e reavalie. No máximo 3 rodadas; depois pare e peça decisão humana.
4. Ao final, informe em poucas linhas: o que foi entregue, evidência de verificação, o que ficou pendente e a próxima funcionalidade.

Não inicie uma segunda funcionalidade neste ciclo. Ao final, lembre o humano de limpar o contexto (`/clear`) antes do próximo ciclo; só reaproveite a sessão se ainda houver folga clara.

$ARGUMENTS
