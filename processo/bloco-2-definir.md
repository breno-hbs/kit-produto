# Bloco 2: Definir

Objetivo: transformar a evidência do bloco 1 em decisões escritas sobre o que será feito e como. Defina o suficiente para testar a hipótese e aceitar ou rejeitar o resultado; não é preciso fechar 100% antes da primeira linha de código.

No kit, este bloco é feito pelo `/configurar-projeto` e pelo agente `planner`.

| Fase | Onde registrar | Portão |
| --- | --- | --- |
| Visão, escopo do MVP, não faremos, métricas | `docs/product-specs/index.md` | Alguém de fora entende o MVP em 2 minutos |
| Requisitos e roadmap | `docs/product-specs/index.md` + `feature_list.json` | Cada funcionalidade tem passos de verificação observáveis |
| Design e identidade | `docs/FRONTEND.md` + Paper | Fluxos principais cabem em poucas telas |
| Arquitetura e dados | `ARCHITECTURE.md` + `docs/decisions.md` | Cada decisão relevante tem motivo escrito |
| Legal, privacidade, segurança | `docs/SECURITY.md` | Segredos fora do repositório; base legal de cada dado pessoal; ameaças principais mitigadas |

A lista de "não faremos" é tão importante quanto a de "faremos". Em projeto intermediário ou complexo, dê um id a cada requisito (`REQ-001`) e repita-o no campo opcional `"req"` das funcionalidades do `feature_list.json`.

## Sessão de perguntas difíceis (antes de escrever a spec)

O `/configurar-projeto` usa a skill `brainstorming` para isso. Se ela não estiver disponível, peça explicitamente: "me faça perguntas difíceis até não sobrar ambiguidade, não escreva nada ainda". Escrever a spec cedo demais cimenta a ambiguidade em vez de resolvê-la.

## Design é um ciclo, não uma fase

Uso real expõe fricção que a definição inicial não previu. Ciclo: observar uso real, achar a fricção, ajustar o fluxo ou a tela, validar com poucas pessoas, registrar em `docs/FRONTEND.md`.

## Reconhecer o que já é commodity

Antes de construir do zero, pergunte: isso é o meu diferencial ou é comum a qualquer projeto parecido? Se não é diferencial, procure algo pronto.

| Necessidade | Quando se aplica |
| --- | --- |
| Hospedagem e deploy | Se algo roda publicamente |
| Rastreio de erro | Se há usuário real |
| Autenticação | Só se existe conta ou login |
| Pagamento | Só se você cobra |
| E-mail transacional | Só se precisa notificar ou confirmar |
| Banco gerenciado | Só se persiste dado |
| Métricas de uso | Só depois que há gente usando |
| Tarefa agendada ou em segundo plano | Só se algo roda fora do fluxo do usuário |

## Módulos profundos

Prefira poucos módulos com interface simples escondendo bastante complexidade a muitos módulos rasos. Quando um agente implementa, você desenha a interface e delega o interior: o diff é revisável na fronteira. Registre a interface em `ARCHITECTURE.md` ou `docs/decisions.md` ANTES de pedir a implementação.

## Portão 2

- [ ] Toda funcionalidade tem passos de verificação que um usuário (ou o avaliador) consegue executar
- [ ] Decisão de arquitetura não trivial está em `docs/decisions.md`
- [ ] Profundidade de legal, segurança e dados registrada em `docs/depth.md`
- [ ] Lista "Sempre precisa de humano" preenchida em `docs/SECURITY.md` (ou justificada como vazia em `docs/depth.md`)
- [ ] Alguém de fora entende o MVP em 2 minutos

Se dois documentos conflitarem: a spec manda sobre "o quê", `ARCHITECTURE.md` sobre "como" e "fora de escopo" sobre o que não entra. O conflito resolvido vira uma linha em `docs/decisions.md`.
