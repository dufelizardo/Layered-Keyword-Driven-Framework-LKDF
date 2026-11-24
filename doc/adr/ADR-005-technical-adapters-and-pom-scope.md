# ADR-005 — Escopo do POM e adaptadores técnicos

- **Status:** Proposed
- **Data:** 2026-11-24
- **Decisores:** Mantenedor do LKDF
- **Relacionado:** ADR-001, ADR-002

## Contexto

A documentação usa POM (Page Object Model) como nome da camada técnica, mas atribui a ela interações de UI, API, gRPC e banco de dados. POM é um padrão normalmente associado à encapsulação de páginas/elementos de interface. Aplicá-lo como nome genérico para qualquer integração técnica pode gerar confusão conceitual.

## Decisão proposta

Adotar **Adapters** ou **Technical Adapters** como conceito abrangente para a fronteira de infraestrutura. Reservar **Page Objects/POM** aos adaptadores que encapsulam páginas, componentes e elementos de UI.

Exemplos de especializações possíveis:
- UI: Page Objects / Component Objects.
- API: API Clients ou API Adapters.
- Banco de dados: Repositories/Gateways de acesso técnico, quando necessários ao teste.
- Mensageria e outros protocolos: adapters específicos do protocolo.

A nomenclatura concreta de pacotes deve refletir a implementação existente e evitar renomeações amplas sem benefício. O documento pode manter “POM Layer” como nome histórico da quarta camada somente se declarar explicitamente que é um uso ampliado do termo; a recomendação é migrar gradualmente para “Adapter Layer” ou “Technical Adapter Layer”.

## Alternativas consideradas

1. Manter POM como nome de toda a infraestrutura — menor mudança documental, mas uso conceitualmente impreciso.
2. Renomear imediatamente todos os módulos — rejeitada sem análise de impacto do código.
3. Usar uma camada abrangente de adaptadores e POM como especialização de UI — proposta adotada.

## Consequências

Diagramas, exemplos, glossário e estrutura de pacotes devem ser harmonizados. A mudança de terminologia não deve implicar reestruturação automática do código.

## Critérios de conformidade

- POM/Page Object é usado para abstrações de UI.
- API, banco e outros protocolos possuem nomes próprios de adaptadores.
- O glossário define a camada técnica abrangente e suas especializações.
- Referências antigas são mantidas ou redirecionadas durante eventual migração documental.
