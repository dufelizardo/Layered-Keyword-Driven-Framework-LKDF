# ADR-007 — Evidências para alegações de escalabilidade e confiabilidade

- **Status:** Proposed
- **Data:** 2026-11-24
- **Decisores:** Mantenedor do LKDF
- **Relacionado:** README.md, WHITEPAPER.md

## Contexto

A documentação atribui ao LKDF garantias amplas, incluindo ausência de flakiness, crescimento de manutenção O(N), custo O(0) para novas variações e reduções quantitativas de esforço. Essas propriedades não decorrem automaticamente da separação em camadas. Flakiness e custo de manutenção dependem também de sincronização, ambiente, dados, concorrência, estabilidade do SUT, integrações, volume e frequência de mudanças.

## Decisão proposta

1. Diferenciar **objetivos arquiteturais**, **hipóteses**, **resultados medidos** e **garantias comprovadas**.
2. Não prometer eliminação de flakiness. Descrever a arquitetura como mecanismo que pode favorecer isolamento, reutilização, diagnóstico e redução de determinadas causas de instabilidade.
3. Não atribuir complexidade assintótica O(N), O(1), O(0) ou O(N²) ao custo total de manutenção sem definir formalmente a variável de entrada, o modelo de custo, as premissas e evidências.
4. Substituir afirmações quantitativas por resultados empíricos somente quando houver método reproduzível, amostra, baseline, período, métricas e limitações documentados.
5. Quando não houver dados, utilizar linguagem qualitativa e não absoluta: “busca reduzir”, “pode contribuir”, “foi projetado para”.
6. Para comparações com abordagens tradicionais, explicitar que resultados dependem da implementação comparada e do contexto.

## Métricas recomendadas

- Taxa de testes instáveis (reruns necessários / execuções totais), com definição operacional de instabilidade.
- Tempo de diagnóstico e resolução de falhas de automação.
- Esforço de manutenção por alteração do SUT.
- Reutilização de keywords/adapters e duplicação de lógica.
- Tempo para adicionar um novo cenário e uma nova variação de dados.
- Taxa de falhas atribuídas a ambiente, dados, sincronização e produto, separadamente.

## Alternativas consideradas

- Manter afirmações absolutas sem evidência — rejeitada por risco de inexatidão.
- Remover toda alegação de benefício — desnecessário, pois objetivos e hipóteses podem ser apresentados como tais.
- Qualificar alegações e publicar evidências reproduzíveis — proposta adotada.

## Consequências

README e whitepaper devem ser revisados para separar proposta arquitetural de resultados demonstrados. Qualquer percentual ou comparação deve apontar para sua fonte ou para o experimento que o produziu.

## Critérios de conformidade

- Cada número ou garantia possui fonte verificável ou método de medição reproduzível.
- Não há promessa absoluta de ausência de flakiness.
- Complexidade assintótica é apresentada apenas com modelo e premissas explícitos.
- Resultados publicados incluem contexto, limitações e baseline.
