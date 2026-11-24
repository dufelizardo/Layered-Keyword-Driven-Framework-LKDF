# ADR-001 — Responsabilidades e limites das quatro camadas

- **Status:** Proposed
- **Data:** 2026-11-24
- **Decisores:** Mantenedor do LKDF
- **Relacionado:** README.md, WHITEPAPER.md

## Contexto

O LKDF define quatro camadas: TEST, SCENARIO, FLOW e POM. A documentação atribui a cada camada uma responsabilidade distinta, mas também estabelece proibições absolutas de acesso e bypass. Exemplos documentados precisam respeitar essas regras; caso contrário, a arquitetura ensinada contradiz a própria especificação.

## Decisão proposta

Adotar os seguintes limites como contrato arquitetural:

| Camada | Responsabilidade | Pode conhecer diretamente |
| --- | --- | --- |
| TEST | Declarar e parametrizar casos de teste, selecionar datasets e iniciar a execução | SCENARIO e mecanismos de configuração/fixture explicitamente permitidos |
| SCENARIO | Compor a jornada funcional em uma sequência declarativa | FLOW |
| FLOW | Implementar operações de negócio, decisões do fluxo e validações funcionais | Abstrações de acesso técnico, não detalhes concretos de infraestrutura quando houver inversão de dependência |
| POM / Adapters | Encapsular interação técnica com o SUT: seletores, comandos de UI, contratos HTTP e acesso técnico | Bibliotecas e detalhes da tecnologia de automação |

A regra de dependência deve ser definida separadamente da sequência de execução. O fato de TEST iniciar SCENARIO, que chama FLOW e este acionar um adaptador, descreve o fluxo de controle em runtime; não define, por si só, a direção dos imports.

Nenhuma camada deve acessar uma camada intermediária ignorando a composição prevista. Exceções técnicas (por exemplo, fixtures do runner) precisam ser explicitamente documentadas e limitadas.

## Alternativas consideradas

1. Manter descrições genéricas sem contrato por camada — rejeitada por permitir interpretações divergentes.
2. Definir responsabilidades, permissões e exceções explicitamente — proposta adotada.

## Consequências

- Exemplos e código de produção devem ser revisados contra a matriz.
- A documentação deve distinguir fluxo de controle, dependência de código e ciclo de vida do runner.
- A regra de não-bypass não deve impedir mecanismos legítimos de injeção de dependência ou fixtures; essas exceções devem ser especificadas.

## Critérios de conformidade

- Cada módulo/pacote possui uma camada identificável.
- Não existem imports ou chamadas entre camadas fora da matriz aprovada.
- Exceções de infraestrutura estão documentadas e cobertas por testes de arquitetura.
- Exemplos da documentação compilam/executam ou são identificados claramente como pseudocódigo.
