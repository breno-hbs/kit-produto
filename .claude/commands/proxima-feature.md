---
description: Executa um ciclo completo para a próxima funcionalidade pendente (um passo por vez)
---

Execute um ciclo completo para UMA funcionalidade:

0. Escolha e confira o tamanho da funcionalidade conforme `docs/selecao-de-funcionalidade.md` ($ARGUMENTS pode trazer o id; em modo paralelo ele é obrigatório). Se ela não cabe numa janela de contexto, pare e peça ao humano para dividi-la. Não comece uma funcionalidade grande demais.
1. Use o agente `generator` para implementar a funcionalidade escolhida no passo 0 (passe o id a ele), seguindo o procedimento dele (início de sessão, implementação, auto-verificação, commit, progresso).
2. Decida se o avaliador é necessário: use o agente `evaluator` se a funcionalidade for complexa, tocar segurança ou dados, tocar algo da lista "Sempre precisa de humano" de `docs/SECURITY.md`, ou se for o fechamento de um marco. Para funcionalidade simples e bem testada, pule e diga que pulou.
3. Se o avaliador reprovar, devolva o relatório ao `generator` para corrigir e reavalie. No máximo 3 rodadas; depois pare e peça decisão humana.
4. Antes de encerrar, faça a investigação agêntica (leia o `git diff` e o `git log` do ciclo, porque você só recebeu o resumo do gerador): explique ao humano, sem exigir leitura linha a linha, o que mudou e como as peças se encaixam (módulos tocados, quem chama quem, mudança na interface pública, impacto em latência ou dados). Se a interface pública mudou, diga isso em destaque.
5. Se esta foi a primeira funcionalidade de um tipo novo (primeira tela, primeiro endpoint, primeira integração), peça ao agente que registre em `docs/decisions.md` ou `docs/design-docs/core-beliefs.md` como este projeto faz esse tipo de coisa (padrões, convenções, armadilhas). As próximas do mesmo tipo precisam de menos supervisão.
6. Ao final, informe em poucas linhas: o que foi entregue, evidência de verificação, o que ficou pendente e a próxima funcionalidade.

Não inicie uma segunda funcionalidade neste ciclo. Ao final, lembre o humano de limpar o contexto (`/clear`) antes do próximo ciclo; só reaproveite a sessão se ainda houver folga clara.

$ARGUMENTS
