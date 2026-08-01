# REFACTORING PLAN - GitHub MuseLab DX2

**Data:** 2026-08-01
**Release atual:** v0.1.3
**Responsável:** Renato Barucco

---

## Diagnóstico da Pipeline

### Erro Principal
- **Workflow "Run Tests"** falha com **exit code 4** (pytest: no tests collected)
- Causa: diretório `tests/` **não existe**

---

## Erros Encontrados

| # | Severidade | Arquivo | Problema | Status |
|---|-----------|---------|----------|--------|
| 1 | 🔴 CRÍTICO | `tests/` | Diretório não existe - pytest falha | ASIS: inexistente / TOBE: criar com testes básicos |
| 2 | 🔴 CRÍTICO | `d2x/__main__.py` | Arquivo não existe - `python -m d2x` falha | ASIS: inexistente / TOBE: criar entrypoint |
| 3 | 🟡 MÉDIO | `d2x/cli/main.py:42,59` | `bare except` - deveria ser `except Exception` | ASIS: bare except / TOBE: except Exception |
| 4 | 🟡 MÉDIO | `d2x/cli/main.py:6` | `import pdb` em código de produção | ASIS: import direto / TOBE: import condicional |
| 5 | 🟡 MÉDIO | `d2x/parse/sf/auth_url.py:76,100,102` | 3x `type: ignore` sem justificativa | ASIS: type: ignore / TOBE: tipagem correta |
| 6 | 🟢 BAIXO | `pyproject.toml` | `pyyaml` não listado como dependência | ASIS: ausente / TOBE: adicionar |
| 7 | 🟢 BAIXO | `cache-d2x-docker.yml`, `prepare.yml` | Ações GitHub deprecated (v3/v4) | ASIS: v3/v4 / TOBE: v5+ |

---

## Plano de Ação

- [x] 1. Criar diretório `tests/` com testes básicos (21 testes)
- [x] 2. Criar `d2x/__main__.py`
- [x] 3. Corrigir bare excepts em `cli/main.py`
- [x] 4. Corrigir import pdb em `cli/main.py`
- [x] 5. Corrigir type: ignore em `parse/sf/auth_url.py`
- [x] 6. Adicionar pyyaml ao pyproject.toml
- [x] 7. Atualizar ações deprecated nos workflows
- [x] 8. Corrigir deprecations do Pydantic (Config → ConfigDict, dict → model_dump)

---

## Log de Progresso

| Data | Ação | Status |
|------|------|--------|
| 2026-08-01 | Diagnóstico inicial | ✅ Concluído |
| 2026-08-01 | README revertido | ✅ Concluído |
| 2026-08-01 | Erro #1: Criar tests/ (21 testes) | ✅ Concluído |
| 2026-08-01 | Erro #2: Criar __main__.py | ✅ Concluído |
| 2026-08-01 | Erro #3-4: Corrigir bare except + pdb | ✅ Concluído |
| 2026-08-01 | Erro #5: Corrigir type: ignore | ✅ Concluído |
| 2026-08-01 | Erro #6: Adicionar pyyaml | ✅ Concluído |
| 2026-08-01 | Erro #7: Atualizar ações deprecated | ✅ Concluído |
| 2026-08-01 | Erro #8: Deprecations Pydantic | ✅ Concluído |
