# Bloco 3: Entregar

Objetivo: construir em fatias pequenas e verificáveis e colocar o produto diante de pessoas reais de forma controlada. Este é o bloco que os agentes do kit executam.

| Fase | Como o kit faz |
| --- | --- |
| Plano de execução | `feature_list.json`, ordenada por prioridade e dependência; cada item cabe em uma sessão |
| Estratégia de testes | Passos de verificação por funcionalidade; testes automatizados do projeto; `docs/QUALITY_SCORE.md` |
| Construção | `/proxima-feature`: agente `generator`, uma funcionalidade por ciclo, em TDD; `hitl` para quando precisa do humano; tela nova passa por protótipos descartáveis (`docs/FRONTEND.md`); ao final, o agente explica o que mudou (investigação agêntica) |
| Revisão | Agente `evaluator`, em contexto separado, quando a funcionalidade for difícil, sensível ou fechar um marco |
| Infra e entrega | `docs/operacao.md` (deploy e reversão), CI rodando `./scripts/check-docs.sh` e, depois de configurado, o teste e o lint do projeto |
| Instrumentação | Métricas definidas em `docs/product-specs/index.md` coletadas de fato |
| Alfa, beta e lançamento | `docs/operacao.md`; feature flags quando fizer sentido |

Fatias verticais: cada funcionalidade entrega algo que funciona de ponta a ponta, não uma camada isolada.

## Ao pedir uma tarefa a um agente, diga quatro coisas

1. O que você quer.
2. Como, em linhas gerais (deixe espaço para ele sugerir algo melhor).
3. O que você NÃO quer.
4. Como vocês vão saber que deu certo.

A maioria dos pedidos pula as duas últimas, e é aí que o agente entrega o que você não queria.

## Limites práticos

- Contexto: cada funcionalidade cabe em uma janela de contexto, com folga antes de a sessão degradar (regra prática: entre 100 e 140 mil tokens a qualidade começa a cair). Passou disso, divida a funcionalidade.
- Agentes em paralelo: o teto prático é de 2 a 5, quase sempre 2 ou 3. Passou disso, o humano perde o contexto do que cada um faz. Só funcionalidades sem `blocked_by` entre si.
- Antes de começar uma funcionalidade, defina o limite de tentativas ou de cota que o agente pode gastar nela; estourou, o humano decide. Registre o limite na linha "Limite desta funcionalidade" de `docs/estado-atual.md`; o `generator` o respeita e para ao atingi-lo.

## Portão 3

- [ ] Testes passam no commit exato que vai ser publicado (leia o resultado; não encadeie "testar e publicar" num comando só)
- [ ] O `evaluator` aprovou (ou a dispensa foi justificada em `docs/depth.md`)
- [ ] Plano de reversão existe e foi testado ao menos uma vez
- [ ] As métricas planejadas estão sendo coletadas
- [ ] Nenhum problema crítico aberto do beta

## Licença, se for publicar o código

Sem arquivo de licença, o código está sob direitos autorais totais: ninguém pode usar nem copiar. MIT é a opção aberta mais simples e comum em portfólio; Apache 2.0 acrescenta proteção contra patentes; GPL e AGPL obrigam quem modificar e distribuir a abrir também a modificação; produto comercial costuma ficar proprietário.
