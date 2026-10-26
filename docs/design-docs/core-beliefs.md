# Crenças fundamentais

Princípios que valem para todo o repositório. Mantenha curto. Cada regra aqui deve, sempre que possível, virar uma verificação mecânica (teste estrutural ou lint) com mensagem de erro que diga como corrigir.

## 1. O repositório é o sistema de registro

O agente só enxerga o que está no repositório. Decisão tomada em conversa, documento externo ou cabeça de alguém não existe até virar arquivo em `docs/`.

## 2. Parse, não valide

Dado externo (HTTP, arquivo, banco, saída de modelo) entra no sistema na borda e sai de lá convertido em um tipo preciso que torna estados ilegais impossíveis de representar. Depois da borda, nenhuma função re-verifica o que o tipo já garante.

- Python: modelos Pydantic ou tipos com construtor que levanta erro; funções internas recebem o modelo, não `dict`.
- TypeScript: esquema Zod na borda; funções internas recebem o tipo inferido.
- Desconfie de funções que só retornam `None`/`void` e existem para levantar erro: provavelmente deveriam retornar o tipo refinado.
- Não sondar dados "no escuro" (acessar campos de um `dict` de formato presumido).

## 3. Mapa, não manual

`AGENTS.md` é índice. Contexto é recurso escasso: quando tudo é importante, nada é. Regra nova vai para o arquivo certo em `docs/` e ganha uma linha de ponteiro, não um parágrafo no índice.

## 4. Limites rígidos, liberdade dentro deles

Imponha fronteiras e invariantes (camadas, direção de dependência, parsing na borda). Dentro delas, o agente escolhe como implementar. O estilo não precisa agradar a um humano; precisa estar correto, ser fácil de manter e legível para a próxima sessão.

## 5. Prefira tecnologia simples e conhecida

Dependências estáveis e bem representadas no treinamento dos modelos são mais fáceis de o agente usar. Só adicione dependência que justifique o custo.

## 6. Um passo por vez, ambiente sempre limpo

Uma funcionalidade por sessão. Ao terminar: testes passando, commit descritivo, progresso registrado. O próximo agente começa do zero e precisa conseguir assumir sem adivinhar.

## 7. Quem faz não avalia sozinho

Agentes tendem a elogiar o próprio trabalho. Quando a tarefa estiver perto do limite do que o gerador faz sozinho, um avaliador independente e cético, que usa o aplicativo rodando, reprova com evidência. Em tarefa simples, o avaliador é custo sem ganho: não use.

## 8. Cada peça do harness é uma suposição

Todo agente, comando e regra extra existe porque supomos que o modelo não faz aquilo sozinho. Ao trocar de modelo, teste removendo uma peça por vez e veja se o resultado piora. Se não piorar, tire.

## 9. Coleta de lixo contínua

O agente replica padrões existentes, inclusive os ruins. Pague a dívida em parcelas pequenas e frequentes (`/limpeza`) em vez de em mutirões.

## 10. Módulos profundos, feedback rápido

Prefira poucos módulos com interface pequena e muita lógica dentro (módulos profundos) a muitos arquivos minúsculos que dependem uns dos outros (módulos rasos). O agente navega melhor, e fica claro onde traçar a fronteira de teste: em volta do módulo, pela interface pública. Você desenha a interface e delega a implementação; precisa saber o que o módulo faz e como se comporta, não ler cada linha dentro dele.

A qualidade dos testes, tipos e lint é o teto da qualidade do que o agente entrega. Se o resultado é ruim, melhore o feedback antes de reescrever o pedido. Quando der, escreva o teste primeiro (TDD).

Teste verifica comportamento, não repete a implementação. Um teste que só afirma que uma constante vale o que acabou de ser escrito (`assert LIMITE == 4`) dá falsa confiança. Gaste a atenção nas bordas: o que o sistema precisa garantir, os limites de desempenho e o que você não aceita trocar.

## 11. Fatias verticais

Quebre o trabalho em fatias finas que atravessam todas as camadas, não em fases por camada. Cada fatia deixa algo que já roda de ponta a ponta e que dá feedback imediato. A primeira fatia é a mais importante.

## 12. O que é mecânico vira script

Se uma etapa tem sempre a mesma resposta (renomear em massa, migrar de um padrão para outro, conferir um formato), transforme-a em script ou verificação mecânica e deixe o agente só com o que exige julgamento. Se o mesmo erro do agente aparecer duas vezes, a correção é uma regra mecânica (lint, teste estrutural ou verificação em `scripts/check-docs.sh`), não um pedido mais comprido.

## Regras de ouro (acrescente conforme os erros aparecerem)

- Preferir utilitários compartilhados a funções auxiliares duplicadas.
- Logs estruturados, nunca `print` solto.
- <sua regra, com a verificação mecânica que a impõe>
