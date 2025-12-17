# Sistema de Gestão de Clube de Ténis e Padel 🎾

**Universidade do Algarve - FCT**
**Unidade Curricular:** Bases de Dados (2025/26)

## Sobre o Projeto

Este projeto consiste na implementação de uma base de dados relacional para a gestão de um clube desportivo de luxo. O sistema automatiza a gestão de reservas, sócios, cálculo de preços e registo de incidentes, utilizando **PostgreSQL**.

O sistema distingue regras de negócio entre Sócios e Não-Sócios (como antecedência de reservas), calcula preços dinamicamente com base no piso e iluminação, gere torneios e aplica penalizações automáticas em caso de danos materiais através de *Triggers*. Inclui ainda vistas dedicadas para operações de receção e marketing.

## Estrutura dos Ficheiros

Os scripts SQL estão organizados da seguinte forma:

| Ficheiro | Descrição |
| :--- | :--- |
| `ddl.sql` | Criação das tabelas e Triggers de validação. |
| `proc_func.sql` | Funções de lógica de negócio (cálculo de preços). |
| `view.sql` | Vistas (Views) de suporte à gestão e operação. |
| `dml_insert.sql` | Povoamento com dados de teste e histórico. |
| `queries.sql` | Conjunto de queries para análise de dados. |

## 🚀 Como Executar

A ordem de execução recomendada é:

1.  `ddl.sql`
2.  `proc_func.sql`
3.  `view.sql`
4.  `dml_insert.sql`
5.  `queries.sql`

## 👥 Autores

* **João Teixeira** (a88333)
* **Guilherme Silva** (a88351)
* **Mohammed Rohaim** (a90251)

---
*Este repositório serve como portfólio*
