# Qual funcionalidade pegar

Fonte única da regra. `AGENTS.md`, o agente `generator` e o `/proxima-feature` apontam para cá: se mudar a regra, mude só aqui.

## Escolha

1. **Id indicado pelo humano** (ex.: `/proxima-feature F003`): é essa. Em modo paralelo (regra 9 do `AGENTS.md`) o id é obrigatório: `passes` só muda no merge, então dois agentes sem id pegariam a mesma. Sem id nesse modo, pare e peça.
2. **Sem id**, a de maior prioridade em `feature_list.json` que:
   - tem `"passes": false`;
   - não tem `blocked_by` pendente (todos os ids listados já estão com `passes: true`);
   - não é `hitl`;
   - não toca nada da lista "Sempre precisa de humano" de `docs/SECURITY.md`.
3. As `hitl` e as da lista esperam o humano: diga quais são. Se só sobrarem elas, pare e diga o que falta (decisão ou teste humano). Não adivinhe.
4. Uma funcionalidade por sessão. Não comece uma segunda.

## Tamanho

Antes de implementar, confira se cabe numa única janela de contexto e em até ~500 linhas de lógica (testes, docs e JSON/YAML não contam). Se não couber, pare e peça ao humano para dividi-la em `feature_list.json`.

## Aprovação humana

Quando o humano aprova na conversa uma funcionalidade `hitl` ou da lista, registre a aprovação em `docs/decisions.md` (o quê, quem aprovou, data) antes de mexer no código: o avaliador procura lá.
