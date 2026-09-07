# DW Call Center Analytics (Monitoramento de Ligações)

Arquitetura de Data Warehouse estruturada em modelo dimensional (**Star Schema**) voltada para o monitoramento operacional de chamadas e análise de produtividade de agentes. 

Este projeto foi desenvolvido para endereçar problemas críticos de operação — como a falta de assertividade na identificação de gargalos no aproveitamento de ligações —, centralizando dados transacionais e agregados para apoiar a tomada de decisão.

---

## Arquitetura do Banco de Dados (Star Schema)

O modelo dimensional é composto por **4 Dimensões** e **2 Tabelas Fato**, garantindo isolamento semântico e alta performance para consultas analíticas.

### Diagrama Entidade-Relacionamento (DER)
![DER do Projeto](./DER%20-%20PROJETO%20MONITORAMENTO.jpg)

### Estrutura das Tabelas
* **Dimensões:**
  * `dim_filial`: Armazena os dados das unidades/lojas.
  * `dim_agente`: Cadastro dos operadores/atendentes.
  * `dim_tempo`: Calendário relacional customizado para análises temporais.
  * `dim_caracteristicas`: Detalhes de qualificação e comportamento associados às chamadas.
* **Fatos:**
  * `fato_ligacoes`: Grão transacional a nível de chamada individual (inclui métricas de tempo falado, flags de leads queimados e controle de chamadas duplicadas via *Unique Key* em `id_chamada_origem`).
  * `fato_produtividade_agente`: Grão consolidado diário por agente e filial, blindado contra duplicidades através de uma restrição composta (`id_data`, `id_agente`, `id_filial`).

---

## Tecnologias Utilizadas
* **Banco de Dados:** PostgreSQL
* **Modelagem Visual:** DbSchema / LucidApp
* **Versionamento:** Git & GitHub

---

## Como Executar o Script

Se você deseja subir essa estrutura no seu ambiente PostgreSQL local:

1. Clone o repositório:
   ```bash
   git clone [https://github.com/Amanda2F/dw-call-center-analytics.git)

2. Abra o seu gerenciador de banco de dados (ex: pgAdmin) e crie um banco vazio:
	```SQL
	CREATE DATABASE dw_monitoramento;
	
3. Execute o script DDL contido no arquivo schema_dw.sql para criar todas as tabelas, chaves estrangeiras e sequências automaticamente.
	
