# Bloco 1: Descobrir

Objetivo: saber se o problema é real e vale resolver, gastando o mínimo antes de ter evidência. É a entrada do `/configurar-projeto`.

| Fase | Pergunta | Onde registrar | Portão |
| --- | --- | --- | --- |
| Ideia | Que problema, para quem, por que agora? | `docs/discovery/idea.md` | Explica o problema sem citar a solução |
| Pesquisa | Quem já resolve isso e como? | `docs/discovery/validacao.md` | Conversou com pessoas reais; hipóteses arriscadas listadas |
| Validação barata | As pessoas realmente querem? | `docs/discovery/validacao.md` | Experimento com critério de sucesso definido antes de rodar |
| Modelo de negócio | Como isso se sustenta? | `docs/discovery/idea.md` | A conta fecha em ordem de grandeza, ou vira hobby declarado |
| Critérios de parada | Quando mato ou mudo isto? | `docs/discovery/kill-criteria.md` | Escritos antes de investir, com prazo e número |

Validação barata: landing page com lista de espera, protótipo clicável, Concierge MVP (você faz o serviço à mão para poucas pessoas) ou Wizard of Oz (parece automático, mas há uma pessoa por trás).

IA nesta fase ajuda a organizar e rascunhar, mas não substitui conversar com pessoas reais. Dados de mercado gerados por IA podem estar inventados: confira as fontes.

## Mom Test (validação sem viés)

Pergunte sobre comportamento passado e dinheiro real, nunca sobre opinião futura.

| Evite | Pergunte |
| --- | --- |
| "Você usaria um app para dividir contas?" | "Como você fez da última vez que precisou dividir uma conta em grupo?" |
| "Você pagaria R$20 por mês?" | "Quanto tempo ou dinheiro você já gastou tentando resolver isso?" |
| "Isso seria útil?" | "Me conta a última vez que esse problema te incomodou de verdade." |

Evidência em gradiente: resposta educada ("seria legal") é sinal fraco; comportamento relatado com detalhe é evidência moderada; compromisso concreto (pagamento antecipado, cadastro real, reunião marcada, tempo investido) é evidência forte.

## Kill-criteria

Formato: "Se [métrica] não atingir [valor] até [data], então [parar, mudar ou reduzir]". Escreva ANTES de rodar o experimento. Exemplo: "Se menos de 10 pessoas entrarem na lista de espera em 2 semanas de divulgação, mudo o público ou encerro."

## Portão 1

- [ ] Conversou com pessoas reais do público (referência: 5 no nível mínimo; menos pode bastar em nicho pequeno, com o motivo registrado)
- [ ] Achou evidência de comportamento, não de opinião
- [ ] Alguém demonstrou disposição real (pagamento, cadastro, tempo), não só "eu usaria"
- [ ] A hipótese testada era a mais arriscada, não a mais fácil de testar
- [ ] `docs/discovery/kill-criteria.md` escrito e não violado

Passa quando cada item é verdadeiro OU tem justificativa em `docs/depth.md`. Se faltar algum sem justificativa: mude o público ou o problema, ou faça outra rodada de validação. Não force a passagem.
