# Front-end e critérios de design

Para qualquer interface, o planejador cria uma linguagem visual específica do produto antes da implementação e o gerador a segue. Para instruções detalhadas de estética, instale a skill oficial `frontend-design` (plugin `frontend-design` do repositório `anthropics/claude-code`) em vez de duplicá-la aqui. Este arquivo guarda só o que é do SEU produto.

## Fonte da verdade visual: Paper Design

- Arquivo/quadro de referência no Paper: <LINK_OU_NOME_DO_ARQUIVO>
- O `generator` consulta o design no Paper (via MCP) ANTES de codar uma tela e não inventa estilo que contradiga o quadro.
- O `evaluator` compara a tela rodando com o quadro do Paper, além dos critérios abaixo, e registra as divergências.
- Se o design mudar, atualize o Paper e a seção abaixo juntos. Sem MCP do Paper conectado, use só a seção abaixo.

## Protótipos descartáveis (tela nova sem design aprovado)

O agente ainda enxerga mal a interface e não faz bom front-end sozinho num código maduro. Para tela nova sem desenho no Paper:

1. Peça 3 versões diferentes da tela, em uma rota descartável que você alterna com um clique.
2. Escolha uma (ou misture), registre a escolha em `docs/decisions.md` e leve o resultado para o Paper e para a seção abaixo.
3. Só então implemente de verdade, apagando as rotas descartáveis.

## Linguagem visual do produto (preencher na fase de planejamento)

- Assunto, público e função principal da interface: <...>
- Paleta (4 a 6 cores nomeadas com hex): <...>
- Tipografia e papel de cada família: <...>
- Layout: <conceito em uma frase e alinhamento>
- Princípio que torna este produto reconhecível: <...>

## Critérios de avaliação (usados pelo avaliador, com pesos)

Notas de 0 a 5. Reprova se qualquer critério ficar abaixo do mínimo.

| Critério | O que olhar | Peso | Mínimo |
| --- | --- | --- | --- |
| Qualidade do design | O conjunto parece coerente, com identidade própria, e não uma soma de partes | alto | 3 |
| Originalidade | Há decisões deliberadas ou só modelo pronto, padrão de biblioteca e traços típicos de página gerada por IA | alto | 3 |
| Técnica | Hierarquia tipográfica, espaçamento, contraste, harmonia de cor | médio | 3 |
| Funcionalidade | Usuário entende o que a interface faz, acha a ação principal e conclui a tarefa sem adivinhar | médio | 3 |

Piso de qualidade (sempre): responsivo até celular, foco de teclado visível, movimento reduzido respeitado, contraste adequado.

## Calibração do avaliador

Registre aqui 2 a 3 exemplos de nota dada e o porquê (bom e ruim). Sem isso o avaliador oscila. Revise quando discordar de uma nota.
