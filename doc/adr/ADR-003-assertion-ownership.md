# ADR-003 — Responsabilidade pelas asserções

- **Status:** Proposed
- **Data:** 2026-11-24
- **Decisores:** Mantenedor do LKDF
- **Relacionado:** ADR-001

## Contexto

A documentação posiciona validações funcionais na camada FLOW e proíbe domain/business assertions em TEST. Entretanto, exemplos de TEST incluem uma asserção direta sobre a URL final, e outro exemplo executa uma validação chamando FLOW diretamente após a execução do SCENARIO. Isso torna ambíguo o contrato de validação e pode violar a regra de não-bypass.

## Decisão proposta

- **FLOW** é responsável pelas validações funcionais e de negócio que fazem parte da regra ou do comportamento esperado do caso.
- **POM/Adapters** executam operações técnicas e, quando necessário, expõem estado técnico observado; não decidem se o comportamento atende ao requisito.
- **SCENARIO** compõe as etapas e pode invocar operações de validação do FLOW na posição apropriada da jornada.
- **TEST** declara o caso, fornece dados e delega a execução ao SCENARIO. Não deve duplicar regras de negócio em assertions locais.
- Assertions de infraestrutura do runner (por exemplo, falha de setup, fixture indisponível ou processo encerrado incorretamente) podem existir fora de FLOW, desde que sejam claramente classificadas como verificações técnicas, não como critérios funcionais.

As validações devem ser executadas por meio da camada responsável, sem chamadas avulsas de TEST diretamente para FLOW que contornem SCENARIO.

## Alternativas consideradas

1. Permitir assertions funcionais em qualquer camada — rejeitada por diluir responsabilidades.
2. Concentrar validações funcionais em FLOW e reservar TEST à declaração/execução — proposta adotada.
3. Proibir qualquer assertion fora de FLOW, inclusive asserções do próprio runner — rejeitada por confundir validação funcional com integridade da infraestrutura.

## Consequências

Os exemplos da documentação devem ser corrigidos para refletir a regra. O contrato deve diferenciar claramente assertion funcional, assertion técnica e falha de infraestrutura.

## Critérios de conformidade

- TEST não contém assertions de critérios de aceitação ou regras de negócio.
- Validações funcionais são implementadas em FLOW e orquestradas por SCENARIO.
- Não há bypass de SCENARIO para executar validações funcionais.
- As verificações técnicas do runner são identificadas e justificadas.
