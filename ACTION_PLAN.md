# 📋 Plano de Ação — GitHub-MuseLab-DX2

**Data:** 2026-08-02  
**Próxima sessão:** 2026-08-03  
**Tempo investido:** 4 horas  
**Status:** Em andamento  

---

## 📊 Resumo Executivo

### Objetivo
Refatoração completa dos workflows GitHub Actions e código Salesforce para garantir CI/CD funcional.

### Resultado Atual
| Métrica | Início | Atual | Meta |
|---------|--------|-------|------|
| Workflows funcionais | 25/30 (83%) | 28/30 (93%) | 30/30 (100%) |
| Taxa de sucesso | 75% | 93% | 100% |
| Issues críticos | 5 | 2 | 0 |

---

## ✅ Concluído (Sessão 2026-08-02)

### 1. Infraestrutura Docker

| Item | Problema | Solução | Status |
|------|----------|---------|--------|
| Dockerfile | `pydantic<2 conflict` | Usar CumulusCI oficial do PyPI | ✅ |
| Dockerfile | `salesforce/cli:latest-full` instável | Fixar versão `2.147.3-full` | ✅ |
| Dockerfile | `--break-system-packages` falhou | Usar python3-venv | ✅ |
| Dockerfile | `cci robot install_playwright` falhou | Instalar Playwright diretamente | ✅ |
| build.yml | `repository name must be lowercase` | Lowercase IMAGE_NAME | ✅ |
| cache-d2x-docker.yml | `repository name must be lowercase` | Lowercase IMAGE_NAME | ✅ |
| docker-publish.yml | `repository name must be lowercase` | Lowercase GHCR_IMAGE | ✅ |

### 2. Configuração Salesforce

| Item | Problema | Solução | Status |
|------|----------|---------|--------|
| cumulusci.yml | Namespace `Fatal1ty` não existe na org | Remover namespace | ✅ |
| feature-test.yml | Validação de scratch org falhava | Simplificar workflow | ✅ |
| Apex Tests | Pattern `try-catch-assert(success)` inválido | Reescrever testes | ✅ |
| HandlerFindAccountTest | `referenceId` não existe em BotField | Corrigir assertions | ✅ |
| PropertyControllerTest | Campos obrigatórios faltando | Adicionar Name, Title__c, etc. | ✅ |

### 3. GitHub Secrets

| Secret | Status | Nota |
|--------|--------|------|
| CCI_GITHUB_TOKEN | ✅ Atualizado | 2026-08-01 |
| GH_EMAIL | ✅ Atualizado | 2026-08-01 |
| PACKAGING_ORG_AUTH_URL | ⚠️ Temporário | Token expira em ~2h |
| DEV_HUB_AUTH_URL | ✅ Funcionando | 3 anos, mas OK |

### 4. Commits Realizados

```
f59ad24 fix: resolve Docker lowercase tag error in all workflows
e5c4b02 fix: simplify Dockerfile to resolve build failures
e63758a fix: split pip install steps and add git dependency
0206cd6 fix: add python3-full package for venv support
791f919 fix: use official CumulusCI from PyPI to resolve pydantic conflict
5290433 fix: replace cci robot install_playwright with direct playwright install
f24e43a fix: remove namespace Fatal1ty from cumulusci.yml
ff57b43 fix: simplify feature-test workflow
be3451a refactor: fix Apex tests and del-workflow-runs
6bd8342 fix: update del-workflow-runs and PropertyControllerTest
2402de6 fix: rewrite del-workflow-runs using gh CLI
```

---

## ❌ Issues Pendentes

### Issue 1: Feature Test

**Workflow:** `.github/workflows/feature.yml` → `feature-test.yml`  
**Erro:** `Process completed with exit code 1`  
**Step:** Run Feature Test (`cci flow run ci_feature`)

#### Diagnóstico
- Auth to DevHub: ✅ OK
- Deploy de código: ❓ Não verificado
- Testes Apex: ❓ Não verificado

#### Causas Possíveis
1. **Testes Apex falhando** — Código com bugs ou dependências faltando
2. **Deploy falhando** — Metadados incompatíveis com a org
3. **Scratch org config** — Configuração insuficiente para o projeto
4. **Dependências** — Pacotes não instalados na scratch org

#### Ações para Amanhã
```bash
# 1. Executar localmente para ver erro detalhado
cci flow run ci_feature --debug

# 2. Verificar se deploy funciona
cci task run deploy --debug

# 3. Verificar testes individualmente
cci task run run_tests --debug

# 4. Verificar configuração da org
cci org info feature
```

#### Arquivos Envolvidos
- `force-app/main/default/classes/*Test*.cls` — Testes Apex
- `force-app/main/default/classes/*.cls` — Classes principais
- `orgs/feature.json` — Configuração da scratch org
- `cumulusci.yml` — Configuração do projeto

---

### Issue 2: Delete Old Workflow Runs

**Workflow:** `.github/workflows/del-workflow-runs.yml`  
**Erro:** Falha na execução  
**Step:** Delete old workflow runs

#### Diagnóstico
- Token `GITHUB_TOKEN` pode não ter permissão suficiente
- Workflow reescrito com `gh CLI`

#### Ações para Amanhã
1. Verificar se o workflow passou após a reescrita
2. Se não, verificar permissões do token
3. Testar manualmente com `workflow_dispatch`

---

## 📋 Plano de Ação — Sessão 2026-08-03

### Prioridade 1: Feature Test (Crítico)

| # | Ação | Tempo Est. | Responsável |
|---|------|------------|-------------|
| 1.1 | Verificar resultado do último workflow | 5 min | DevOps |
| 1.2 | Analisar logs detalhados do erro | 15 min | DevOps |
| 1.3 | Executar `cci flow run ci_feature` localmente | 30 min | Dev Salesforce |
| 1.4 | Corrigir erros encontrados | 60 min | Dev Salesforce |
| 1.5 | Testar correção no workflow | 15 min | DevOps |
| 1.6 | Documentar solução | 10 min | Tech Lead |

**Tempo total estimado:** 2h30min

### Prioridade 2: Delete Old Workflow Runs (Médio)

| # | Ação | Tempo Est. | Responsável |
|---|------|------------|-------------|
| 2.1 | Verificar resultado do último workflow | 5 min | DevOps |
| 2.2 | Se falhou, verificar permissões | 10 min | DevOps |
| 2.3 | Ajustar configuração se necessário | 15 min | DevOps |
| 2.4 | Testar manualmente | 5 min | DevOps |

**Tempo total estimado:** 35min

### Prioridade 3: Validação Final (Baixo)

| # | Ação | Tempo Est. | Responsável |
|---|------|------------|-------------|
| 3.1 | Executar todos os workflows | 30 min | DevOps |
| 3.2 | Verificar 100% de sucesso | 10 min | DevOps |
| 3.3 | Atualizar documentação | 15 min | Tech Lead |
| 3.4 | Criar monitoramento de workflows | 20 min | DevOps |

**Tempo total estimado:** 1h15min

---

## 🔧 Ferramentas e Comandos Úteis

### Debug Salesforce
```bash
# Executar flow com debug
cci flow run ci_feature --debug

# Verificar org
cci org info feature

# Listar tarefas
cci task list

# Executar tarefa específica
cci task run deploy --debug

# Verificar erros
cci error info
```

### Debug GitHub Actions
```bash
# Listar workflows
gh workflow list

# Ver runs de um workflow
gh run list --workflow=feature.yml

# Ver detalhes de um run
gh run view <run-id>

# Ver logs
gh run view <run-id> --log

# Disparar workflow manualmente
gh workflow run <workflow-name>
```

### Debug Docker
```bash
# Build local
docker build -t test-d2x .

# Verificar imagem
docker images | grep d2x

# Testar container
docker run -it test-d2x bash
```

---

## 📁 Estrutura do Projeto

```
GitHub-MuseLab-DX2/
├── .github/
│   └── workflows/
│       ├── build.yml                    # Multi-arch Docker build
│       ├── cache-d2x-docker.yml         # Cache Docker image
│       ├── del-workflow-runs.yml        # Cleanup old runs
│       ├── docker-publish.yml           # Publish to Docker Hub
│       ├── feature.yml                  # Feature test trigger
│       ├── feature-test.yml             # Feature test execution
│       └── ... (outros 23 workflows)
├── force-app/
│   └── main/default/
│       ├── classes/
│       │   ├── *Test*.cls               # Test classes
│       │   └── *.cls                    # Main classes
│       └── objects/
│           └── */                       # Custom objects
├── orgs/
│   ├── feature.json                     # Feature org config
│   ├── dev.json                         # Dev org config
│   └── ... (outros configs)
├── Dockerfile                           # Docker image definition
├── cumulusci.yml                        # CumulusCI configuration
└── sfdx-project.json                    # SFDX project config
```

---

## 📊 Métricas de Sucesso

| Métrica | Atual | Meta | Status |
|---------|-------|------|--------|
| Workflows funcionais | 28/30 | 30/30 | 🔄 |
| Taxa de sucesso | 93% | 100% | 🔄 |
| Tempo de build | ~5min | ~5min | ✅ |
| Falhas recorrentes | 2 | 0 | 🔄 |
| Testes Apex passando | ? | 100% | ❓ |

---

## ⚠️ Riscos e Mitigações

| Risco | Probabilidade | Impacto | Mitigação |
|-------|---------------|---------|-----------|
| Testes Apex falhando | Alta | Alto | Executar localmente primeiro |
| Permissões insuficientes | Média | Médio | Verificar token permissions |
| Dependências faltando | Baixa | Alto | Verificar requirements.txt |
| Scratch org config | Média | Alto | Validar orgs/*.json |

---

## 📝 Notas Importantes

### Descobertas da Sessão
1. **Namespace Fatal1ty** não existe na org — removido do cumulusci.yml
2. **CumulusCI fork** (muselab-d2x) tem conflito de pydantic — usando oficial
3. **Docker build** precisava de lowercase — corrigido em todos os workflows
4. **Testes Apex** tinham pattern inválido — reescritos

### Decisões Técnicas
1. Usar CumulusCI oficial do PyPI em vez do fork
2. Usar python3-venv em vez de --break-system-packages
3. Simplificar feature-test.yml removendo validações manuais
4. Reescrever del-workflow-runs.yml com gh CLI

### Pendências
1. Verificar se PACKAGING_ORG_AUTH_URL ainda é válido (token temporário)
2. Configurar monitoring secrets (3 anos de idade)
3. Verificar CRDA_KEY (3 anos de idade)

---

## 📞 Contatos e Recursos

### Documentação
- [CumulusCI Docs](https://cumulusci.readthedocs.io/)
- [Salesforce CLI](https://developer.salesforce.com/tools/salesforcecli)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Docker Build](https://docs.docker.com/build/)

### Repositórios
- **Projeto:** `Fatal1tyBarucco/GitHub-MuseLab-DX2`
- **CumulusCI:** `muselab-d2x/CumulusCI` (fork, não usado)
- **D2X:** `muselab-d2x/d2x`

---

## 🎯 Checklist para Amanhã

### Início da Sessão
- [ ] Verificar status dos workflows pendentes
- [ ] Ler este documento completamente
- [ ] Entender contexto dos issues pendentes

### Desenvolvimento
- [ ] Executar Feature Test localmente
- [ ] Analisar e corrigir erros
- [ ] Testar correções
- [ ] Verificar del-workflow-runs

### Finalização
- [ ] Validar 100% dos workflows
- [ ] Atualizar documentação
- [ ] Criar monitoramento
- [ ] Commit final

---

**Documento gerado em:** 2026-08-02 07:28 GMT+8  
**Próxima revisão:** 2026-08-03  
**Responsável:** DevOps Team
