# ADR-004 — Dados de teste e parametrização

- **Status:** Proposed
- **Data:** 2026-11-24
- **Decisores:** Mantenedor do LKDF
- **Relacionado:** ADR-001

## Contexto

O LKDF posiciona TEST como responsável por selecionar e injetar datasets e descreve SCENARIO como declarativo e livre de valores concretos. Os exemplos utilizam dicionários e acessos por strings, como `dataset["username_input"]`. É necessário definir o contrato dos dados e evitar que parametrização seja confundida com custo de engenharia nulo.

## Decisão proposta

1. TEST seleciona e fornece os dados necessários à execução; não implementa regras de negócio para interpretar esses dados.
2. O contrato de cada dataset deve ser documentado: campos obrigatórios, tipos, formatos, restrições, valores opcionais e finalidade.
3. Sempre que a complexidade justificar, preferir estruturas tipadas/validadas (por exemplo, dataclasses, modelos ou schemas) a dicionários livres com chaves mágicas.
4. SCENARIO pode encaminhar os dados recebidos, mas não deve conter valores de negócio hardcoded nem lógica de decisão sobre o dataset.
5. Dados sensíveis não devem ser versionados em texto aberto. Usar mecanismos de secrets/configuração adequados e dados sintéticos em exemplos.
6. A adição de uma variação de dados pode não exigir alteração de código, mas ainda possui custo de criação, revisão, validação e manutenção. Não caracterizar esse custo total como O(0).

## Alternativas consideradas

- Dicionários livres em todo o sistema — simples, porém sujeitos a erros de chave e ausência de contrato.
- Estruturas tipadas ou schemas — oferecem validação e documentação, com custo de definição e manutenção.
- Dados embutidos em TEST/SCENARIO — rejeitados como padrão por misturar variação com estrutura/execução.

## Consequências

A documentação deve incluir ao menos um exemplo de schema ou estrutura tipada e explicar como os datasets são validados antes da execução.

## Critérios de conformidade

- Datasets possuem contrato verificável.
- Dados de exemplo são fictícios e não contêm credenciais ou informações reais.
- Erros de schema são detectados antes ou no início da execução, com mensagem útil.
- A documentação diferencia custo de alteração de código do custo total de manutenção dos dados.
