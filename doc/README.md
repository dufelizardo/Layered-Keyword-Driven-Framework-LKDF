# LKDF — Architecture Decision Records (ADRs)

Este diretório registra decisões arquiteturais e orientações para implementação do **Layered Keyword-Driven Framework (LKDF)**.

Os ADRs documentam decisões, contexto, alternativas, consequências e critérios de validação. Eles não comprovam que uma decisão já esteja implementada. A situação de cada decisão deve ser atualizada somente após inspeção do código e dos pipelines.

## Convenções

- **Proposed**: decisão proposta, ainda sujeita à validação.
- **Accepted**: decisão aprovada para orientar a implementação.
- **Implemented**: implementação verificada no repositório.
- **Superseded**: substituída por outro ADR.
- **Rejected**: avaliada e não adotada.

Cada ADR deve conter contexto, decisão, consequências e critérios de conformidade.

## Índice

| ADR | Decisão | Situação |
| --- | --- | --- |
| [ADR-001](adr/ADR-001-layer-boundaries.md) | Responsabilidades e limites das quatro camadas | Proposed |
| [ADR-002](adr/ADR-002-dependency-direction-and-abstractions.md) | Direção das dependências e uso de abstrações | Proposed |
| [ADR-003](adr/ADR-003-assertion-ownership.md) | Responsabilidade pelas asserções | Proposed |
| [ADR-004](adr/ADR-004-test-data-and-parameterization.md) | Dados de teste e parametrização | Proposed |
| [ADR-005](adr/ADR-005-technical-adapters-and-pom-scope.md) | Escopo do POM e adaptadores técnicos | Proposed |
| [ADR-006](adr/ADR-006-architecture-enforcement.md) | Verificação automatizada das regras arquiteturais | Proposed |
| [ADR-007](adr/ADR-007-claims-and-measurement.md) | Evidências para alegações de escalabilidade e confiabilidade | Proposed |

## Observação sobre o estado atual

Os ADRs foram elaborados a partir da revisão da documentação pública do LKDF. Antes de marcar qualquer decisão como **Implemented**, é necessário confrontá-la com a estrutura real do código, dependências, fixtures, configuração do runner e workflows de CI. Onde a implementação ainda não foi verificada, este diretório não presume sua existência.
