-- =====================================================================
-- Projeto Monitoramento (teleatendimento) - Modelo dimensional (estrela)
-- PostgreSQL 18
--
-- Observações:
--   * Os dados de agentes (dim_agente.nome_agente) e filiais (dim_filial.loja)
--     são MASCARADOS antes da carga ("Operador N" / "Filial N").
--   * dim_tempo usa id_data no formato YYYYMMDD (ex.: 20260812), sem SERIAL.
--   * As chaves naturais têm UNIQUE para que o merge/JOIN da carga
--     nunca duplique linhas da fato.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. DIMENSÕES
-- ---------------------------------------------------------------------

CREATE TABLE dim_filial (
    id_filial  SERIAL       NOT NULL,
    loja       VARCHAR(120) NOT NULL,   -- valor mascarado ("Filial N")
    sigla_uf   CHAR(2)      NOT NULL,
    CONSTRAINT pk_dim_filial PRIMARY KEY (id_filial),
    CONSTRAINT uq_dim_filial UNIQUE (sigla_uf, loja)
);

CREATE TABLE dim_agente (
    id_agente    SERIAL       NOT NULL,
    nome_agente  VARCHAR(255) NOT NULL, -- valor mascarado ("Operador N")
    CONSTRAINT pk_dim_agente PRIMARY KEY (id_agente),
    CONSTRAINT uq_dim_agente UNIQUE (nome_agente)
);

CREATE TABLE dim_caracteristicas (
    id_caracteristicas  SERIAL      NOT NULL,
    lista_id            INT         NOT NULL,  -- -1 = não informado
    qualificacao        VARCHAR(50) NOT NULL,
    comportamento       VARCHAR(50) NOT NULL,
    CONSTRAINT pk_dim_caracteristicas PRIMARY KEY (id_caracteristicas),
    CONSTRAINT uq_dim_caracteristicas UNIQUE (lista_id, qualificacao, comportamento)
);

CREATE TABLE dim_tempo (
    id_data        INT         NOT NULL,   -- YYYYMMDD (preenchido manualmente)
    data_completa  DATE,
    ano            SMALLINT,
    mes            SMALLINT,
    dia            SMALLINT,
    dia_semana     VARCHAR(15),
    eh_fim_semana  BOOLEAN,
    CONSTRAINT pk_dim_tempo PRIMARY KEY (id_data)
);


-- ---------------------------------------------------------------------
-- 2. FATOS
-- ---------------------------------------------------------------------

CREATE TABLE fato_ligacoes (
    id_ligacoes         SERIAL       NOT NULL,
    id_data             INT          NOT NULL,
    id_agente           INT          NOT NULL,
    id_filial           INT          NOT NULL,
    id_caracteristicas  INT          NOT NULL,
    id_chamada_origem   VARCHAR(64)  NOT NULL,
    data_hora           TIMESTAMP    NOT NULL,
    tipo_telefone       VARCHAR(10),
    tipo_ligacao        VARCHAR(25),
    tempo_falado_seg    INT          NOT NULL,
    finalizado_agente   BOOLEAN,
    audio_url           TEXT,
    CONSTRAINT pk_fato_ligacoes PRIMARY KEY (id_ligacoes),
    CONSTRAINT unq_fato_ligacoes UNIQUE (id_chamada_origem),
    CONSTRAINT fk_fato_ligacoes_dim_tempo
        FOREIGN KEY (id_data) REFERENCES dim_tempo (id_data),
    CONSTRAINT fk_fato_ligacoes_dim_agente
        FOREIGN KEY (id_agente) REFERENCES dim_agente (id_agente),
    CONSTRAINT fk_fato_ligacoes_dim_filial
        FOREIGN KEY (id_filial) REFERENCES dim_filial (id_filial),
    CONSTRAINT fk_fato_ligacoes_dim_caracteristicas
        FOREIGN KEY (id_caracteristicas) REFERENCES dim_caracteristicas (id_caracteristicas)
);

CREATE TABLE fato_produtividade_agente (
    id_produtividade       SERIAL   NOT NULL,
    id_data                INT      NOT NULL,
    id_agente              INT      NOT NULL,
    id_filial              INT      NOT NULL,
    tempo_em_ligacao_seg   INT,
    qtd_ligacoes_diario    SMALLINT,
    tempo_logado_seg       INT,
    tpa_seg                INT,
    qtd_leads_queimados    SMALLINT,
    CONSTRAINT pk_fato_produtividade_agente PRIMARY KEY (id_produtividade),
    CONSTRAINT unq_fato_produtividade_agente UNIQUE (id_data, id_agente, id_filial),
    CONSTRAINT fk_fato_produtividade_agente_dim_tempo
        FOREIGN KEY (id_data) REFERENCES dim_tempo (id_data),
    CONSTRAINT fk_fato_produtividade_agente_dim_agente
        FOREIGN KEY (id_agente) REFERENCES dim_agente (id_agente),
    CONSTRAINT fk_fato_produtividade_agente_dim_filial
        FOREIGN KEY (id_filial) REFERENCES dim_filial (id_filial)
);


-- ---------------------------------------------------------------------
-- 3. ÍNDICES NAS FKs (o Postgres não cria índice automático para FK)
--    Os índices de dim_* e das UNIQUE já existem por causa das constraints.
-- ---------------------------------------------------------------------

CREATE INDEX idx_fato_ligacoes_id_data           ON fato_ligacoes (id_data);
CREATE INDEX idx_fato_ligacoes_id_agente         ON fato_ligacoes (id_agente);
CREATE INDEX idx_fato_ligacoes_id_filial         ON fato_ligacoes (id_filial);
CREATE INDEX idx_fato_ligacoes_id_caracteristicas ON fato_ligacoes (id_caracteristicas);


-- ---------------------------------------------------------------------
-- 4. CARGA INICIAL DA dim_tempo (calendário)
--    Ajuste o intervalo conforme os períodos que você for carregar.
-- ---------------------------------------------------------------------

INSERT INTO dim_tempo (id_data, data_completa, ano, mes, dia, dia_semana, eh_fim_semana)
SELECT to_char(d, 'YYYYMMDD')::int,
       d::date,
       EXTRACT(YEAR  FROM d),
       EXTRACT(MONTH FROM d),
       EXTRACT(DAY   FROM d),
       (ARRAY['domingo','segunda-feira','terça-feira','quarta-feira',
              'quinta-feira','sexta-feira','sábado'])[EXTRACT(DOW FROM d)::int + 1],
       EXTRACT(DOW FROM d) IN (0, 6)
FROM generate_series('2026-01-01'::date, '2026-12-31'::date, interval '1 day') AS d;