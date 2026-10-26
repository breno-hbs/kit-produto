# ExecPlans: planos de execução

Um ExecPlan é um documento vivo que permite a um agente (ou a você daqui a um mês) entregar uma mudança grande do começo ao fim, partindo só do repositório e deste arquivo, sem memória de conversas.

## Quando usar

Use quando a mudança levar horas, tocar vários arquivos ou tiver incerteza real. Para mudança pequena, um plano de três linhas no próprio commit basta. Não escreva ExecPlan por formalidade.

## Regras

- Autossuficiente: contém tudo que um iniciante precisa. Defina em linguagem simples todo termo técnico que usar.
- Vivo: atualize ao longo do trabalho. Toda decisão vai no Decision Log, com o motivo.
- Comece pelo propósito: o que alguém consegue fazer depois da mudança que não conseguia antes, e como ver funcionando.
- Aceitação em comportamento observável ("subir o servidor e abrir /health retorna 200"), não em detalhe interno ("criei a classe X").
- Nomeie arquivos com caminho relativo à raiz e mostre o comando exato e onde rodar.
- Idempotente e seguro: os passos podem ser repetidos sem estragar nada; se algo for arriscado, descreva o plano de volta.
- Validação não é opcional: testes, execução real e a saída esperada.
- Marcos (milestones) contam a história: objetivo, trabalho, resultado, prova. Cada marco é verificável sozinho.
- Prototipe cedo o que for incerto, em marco rotulado como "protótipo", com critério para promover ou descartar.

## Modelo

Copie para `docs/exec-plans/active/AAAA-MM-DD-nome.md` e preencha. Ao terminar, mova para `completed/`.

    # <Descrição curta e orientada à ação>

    Este plano é um documento vivo. As seções Progresso, Surpresas e Descobertas, Registro de Decisões e Resultados e Retrospectiva devem ser mantidas atualizadas. Mantido conforme docs/PLANS.md.

    ## Propósito

    O que muda para o usuário e como ver funcionando.

    ## Progresso

    - [x] (AAAA-MM-DD HH:MM) Passo concluído.
    - [ ] Passo pendente.
    - [ ] Passo parcial (feito: X; falta: Y).

    ## Surpresas e Descobertas

    - Observação: ...
      Evidência: ...

    ## Registro de Decisões

    - Decisão: ...
      Motivo: ...
      Data/Autor: ...

    ## Resultados e Retrospectiva

    O que foi entregue, o que falta, o que aprendemos.

    ## Contexto e Orientação

    Estado atual relevante, com arquivos e módulos por caminho completo.

    ## Plano de Trabalho

    Sequência de edições em prosa: arquivo, local, o que mudar.

    ## Passos Concretos

    Comandos exatos, diretório de execução e saída esperada curta.

    ## Validação e Aceitação

    Como exercitar o sistema, entradas e saídas esperadas, comando de teste e resultado esperado.

    ## Idempotência e Recuperação

    O que pode ser repetido e como voltar atrás.

    ## Interfaces e Dependências

    Bibliotecas, módulos e assinaturas que devem existir ao final.

Ao revisar o plano, registre no fim uma nota dizendo o que mudou e por quê.
