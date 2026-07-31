# 🔄 Plano de Refatoração — GitHub-MuseLab-DX2

**Projeto:** GitHub-MuseLab-DX2 (Salesforce 2GP)
**API Version Atual:** 65.0
**API Version Alvo:** 67.0 (Summer '26)
**Data:** 2026-07-31

---

## 📊 Diagnóstico Geral

| Área | Estado Atual | Ação Necessária |
|------|-------------|-----------------|
| API Version | 65.0 | Atualizar para 67.0 |
| Aura Components | 31 componentes | Migrar para LWC |
| Apex Classes | 51 classes | Refatorar padrões modernos |
| Triggers | 3 triggers | OK (usa framework) |
| Flows | 6 flows | Revisar versões |
| Testes | Padrões antigos | Modernizar |
| sfdx-project.json | Formato antigo | Atualizar |

---

## 🎯 Fase 1 — Atualização de API Version (65.0 → 67.0)

### 1.1 sfdx-project.json
- Atualizar `sourceApiVersion` de `65.0` para `67.0`

### 1.2 Todos os metadados XML
- Atualizar `<apiVersion>` em todos os `.cls-meta.xml`, `.trigger-meta.xml`, `.flow-meta.xml`, etc.

---

## 🎯 Fase 2 — Modernização Apex

### 2.1 Security Enforcement (USER_MODE)
**Problema:** SOQL queries sem segurança em runtime.
**Solução:** Adicionar `WITH USER_MODE` ou `WITH SYSTEM_MODE` conforme necessário.

**Classes afetadas:**
- `PropertyController.cls` — 4 queries SOQL
- `BinanceAPI.cls` — 1 query SOQL
- `SlackOpportunityPublisher.cls` — 1 query SOQL
- `PostPriceChangeToSlack.cls` — 1 query SOQL
- `BotController.cls` — 1 query SOQL
- `HandlerFindAccount.cls`, `HandlerFindContact.cls`, etc.

### 2.2 Modernização de Testes
**Problema:** `testMethod` keyword deprecated desde API 58.0.
**Solução:** Substituir `testMethod` por `@IsTest`.

**Classes afetadas:**
- `BotTest.cls` — 15 métodos usando `testMethod`

### 2.3 Duplicate Code
**Problema:** `QueueableSlackCall` duplicado em `PostPriceChangeToSlack` e `SlackOpportunityPublisher`.
**Solução:** Criar classe utilitária `SlackQueueable.cls`.

### 2.4 Access Modifiers
**Problema:** `PropertyController` usa `global` desnecessário.
**Solução:** Mudar para `public`.

### 2.5 Hardcoded Endpoints
**Problema:** `BinanceAPI` usa endpoint hardcoded.
**Solução:** Usar Named Credentials.

### 2.6 Null Safety
**Problema:** Falta de verificação de nulidade.
**Solução:** Adicionar null checks em `OrderTriggerHandler`, `BinanceAPI`.

---

## 🎯 Fase 3 — Migração Aura → LWC

### 3.1 Prioridade Alta (componentes usados em produção)
- `PropertyTileList` → LWC
- `PropertyTile` → LWC
- `PropertyPaginator` → LWC
- `PropertySummary` → LWC
- `PictureCarousel` → LWC
- `Map` / `MapCard` → LWC

### 3.2 Prioridade Média (componentes de demonstração)
- `Bot` → LWC
- `MortgageCalculator` / `MortgageCalculatorCard` → LWC
- `SmartHome` / `SmartHomeCard` → LWC
- `SimilarProperties` → LWC

### 3.3 Prioridade Baixa (componentes legados)
- `EinsteinVision*` (5 componentes) — Einstein Vision descontinuado
- `DaysOnMarketEstimator` → LWC
- `HelloWorld` / `HelloWorldTest` → LWC
- `TradeCmp` → LWC
- `SmartLights`, `SmartLocks`, `SmartThermostat`, `SmartPriceCalculator` → LWC

---

## 🎯 Fase 4 — Flows e Automação

- Revisar versões dos flows para API 67.0
- Verificar se `ProcessoOrdem` pode ser simplificado
- Atualizar `Criacao_de_Ordem` flow

---

## 🎯 Fase 5 — Limpeza

- Remover `1705705722978-diagnosis.json` (arquivo de diagnóstico)
- Remover `crda` (binário)
- Atualizar `.nvmrc` para Node 22
- Atualizar README.md

---

## 📋 Ordem de Execução

1. ✅ Atualizar API Version (sfdx-project.json + metadados)
2. ✅ Refatorar Apex (security, testes, duplicatas)
3. ✅ Migrar Aura → LWC (prioridade alta primeiro)
4. ✅ Atualizar Flows
5. ✅ Limpeza geral
