# ADR-002 — Direção das dependências e uso de abstrações

- **Status:** Proposed
- **Data:** 2026-11-24
- **Decisores:** Mantenedor do LKDF
- **Relacionado:** ADR-001

## Contexto

A documentação caracteriza o LKDF como baseado em Clean Architecture e Dependency Inversion, mas apresenta exemplos em que FLOW recebe uma classe concreta de POM. Uma chamada de FLOW para um objeto POM pode ser válida como fluxo de controle, mas uma dependência de código direta sobre uma implementação concreta não demonstra inversão de dependência.

Clean Architecture não é sinônimo de uma pilha de chamadas descendentes. A direção das dependências de código deve ser explicada e demonstrada separadamente.

## Decisão proposta

1. Não declarar conformidade plena com Clean Architecture ou Dependency Inversion apenas com base na existência das quatro camadas.
2. Se a implementação adotar inversão de dependência, FLOW deve depender de contratos estáveis (interfaces/protocolos/ports) definidos em uma camada apropriada e os adaptadores concretos devem implementar esses contratos.
3. A composição dos objetos concretos deve ocorrer em um ponto de composição explícito (composition root, fixture ou mecanismo equivalente).
4. Se a implementação optar por dependências diretas FLOW → POM, documentar honestamente essa escolha como arquitetura em camadas com dependência descendente, sem afirmar que ela satisfaz integralmente a Dependency Rule da Clean Architecture.
5. Evitar abstrações sem necessidade concreta; cada contrato deve representar uma fronteira de mudança ou uma necessidade real de substituição/testabilidade.

## Alternativas consideradas

- **Dependência direta FLOW → POM:** simples e explícita, mas acopla FLOW à implementação técnica.
- **Ports/adapters com injeção:** reduz o acoplamento de código, mas adiciona contratos e composição.
- **Abstração genérica para tudo:** rejeitada por criar complexidade sem benefício demonstrado.

## Consequências

A decisão final depende da estrutura real do código e do nível de isolamento desejado. A documentação deverá apresentar um diagrama de dependências de código (imports) separado do diagrama de execução.

## Critérios de conformidade

- Diagrama de dependências de código corresponde aos imports reais.
- FLOW não importa implementações concretas de infraestrutura quando a opção por ports/adapters estiver adotada.
- O ponto de composição instancia e injeta implementações concretas.
- Testes substituem adaptadores por doubles/fakes quando isso for relevante.
