# ADR-006 — Verificação automatizada das regras arquiteturais

- **Status:** Proposed
- **Data:** 2026-11-24
- **Decisores:** Mantenedor do LKDF
- **Relacionado:** ADR-001, ADR-002, ADR-003

## Contexto

A documentação descreve regras estritas entre camadas e menciona ferramentas de verificação arquitetural e bloqueio de mudanças na CI. Uma regra arquitetural só é efetiva se estiver representada em configuração válida, executada automaticamente e integrada aos critérios de aprovação.

## Decisão proposta

1. Manter as regras de dependência em configuração versionada e revisada junto com o código.
2. Selecionar uma ferramenta compatível com a linguagem, estrutura de pacotes e versão utilizada (por exemplo, Import Linter para projetos Python).
3. Executar a verificação em CI em pull requests e alterações relevantes da branch principal.
4. Fazer a pipeline falhar quando um contrato arquitetural obrigatório for violado.
5. Testar a própria configuração com violações intencionais em ambiente controlado, para confirmar que a ferramenta detecta os casos proibidos.
6. Documentar versão da ferramenta, comando executado, localização do arquivo de configuração e regras cobertas.
7. Não afirmar que a arquitetura é “enforced” ou que PRs são bloqueados até que workflow e configuração reais tenham sido verificados.

## Alternativas consideradas

- Revisão manual apenas — insuficiente para garantir consistência contínua.
- Verificação automatizada em CI — proposta adotada.
- Ferramenta sem integração à CI — útil localmente, mas não garante aplicação no fluxo colaborativo.

## Consequências

A adoção exige manutenção de regras e pipeline. Falsos positivos e exceções devem ser tratados explicitamente, sem desabilitar contratos amplos para contornar falhas.

## Critérios de conformidade

- Arquivo de configuração existe no caminho documentado e é válido para a versão instalada.
- CI instala/usa a versão definida e executa a verificação.
- Uma violação de dependência provoca falha reproduzível.
- A documentação descreve apenas verificações realmente executadas.
