# Segurança

Mantenha proporcional ao risco do projeto.

## Princípios mínimos

- Segredos nunca entram no repositório nem em logs. Use variáveis de ambiente e um arquivo `.env.example` sem valores reais.
- Todo dado externo é parseado na borda (ver `docs/design-docs/core-beliefs.md`).
- Dependências novas exigem justificativa em `docs/decisions.md`.
- Permissões dos agentes ficam em `.claude/settings.json` do projeto e devem ser o mínimo necessário.

## Legal e privacidade

Nível registrado em `docs/depth.md`. Se o produto coleta dado pessoal: base legal (LGPD), finalidade, retenção e regra de exclusão de cada dado; termos de uso e política de privacidade quando houver usuários. Se o código for público, declare uma licença (ver `processo/bloco-3-entregar.md`).

## Se o produto usa agentes ou IA

- [ ] Conteúdo externo é tratado como dado, nunca como instrução
- [ ] Ação irreversível exige aprovação humana
- [ ] Segredo nunca coexiste, no mesmo agente, com uma via livre de saída de dados
- [ ] Ferramentas com a permissão mínima necessária
- [ ] Saída de ferramenta é validada antes de virar a próxima ação

## Ações que exigem aprovação humana

Apagar dados, rodar migração em produção, enviar mensagem ou e-mail a terceiros, qualquer operação financeira, mudar permissões, publicar.

## Revisão de segurança

A cada funcionalidade que toque autenticação, dados pessoais ou entrada do usuário, o avaliador inclui uma checagem de segurança no relatório. Para projetos de risco maior, planeje uma etapa dedicada de modelagem de ameaças e revisão de commits.
