--
-- PostgreSQL database dump
--

\restrict IexlMi7UvaZUeyXkqTbuZUqXj3XkhkVZbXfM5YTAf7uejrBQbAXiPYD67vmG2by

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-09-07 12:31:14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 16437)
-- Name: dim_agente; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dim_agente (
    id_agente integer NOT NULL,
    nome_agente character varying(255) NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 16436)
-- Name: dim_agente_id_agente_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dim_agente_id_agente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 221
-- Name: dim_agente_id_agente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dim_agente_id_agente_seq OWNED BY public.dim_agente.id_agente;


--
-- TOC entry 226 (class 1259 OID 16454)
-- Name: dim_caracteristicas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dim_caracteristicas (
    id_caracteristicas integer NOT NULL,
    lista_id integer NOT NULL,
    lista_nome character varying(255) NOT NULL,
    qualificacao character varying(50) NOT NULL,
    comportamento character varying(50) NOT NULL
);


--
-- TOC entry 225 (class 1259 OID 16453)
-- Name: dim_caracteristicas_id_caracteristicas_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dim_caracteristicas_id_caracteristicas_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 225
-- Name: dim_caracteristicas_id_caracteristicas_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dim_caracteristicas_id_caracteristicas_seq OWNED BY public.dim_caracteristicas.id_caracteristicas;


--
-- TOC entry 220 (class 1259 OID 16427)
-- Name: dim_filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dim_filial (
    id_filial integer NOT NULL,
    loja character varying(120) NOT NULL,
    sigla_uf character(2) NOT NULL
);


--
-- TOC entry 219 (class 1259 OID 16426)
-- Name: dim_filial_id_filial_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dim_filial_id_filial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 219
-- Name: dim_filial_id_filial_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dim_filial_id_filial_seq OWNED BY public.dim_filial.id_filial;


--
-- TOC entry 224 (class 1259 OID 16446)
-- Name: dim_tempo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dim_tempo (
    id_data integer NOT NULL,
    data_completa date,
    ano smallint,
    mes smallint,
    dia smallint,
    dia_semana character varying(15),
    eh_fim_semana boolean
);


--
-- TOC entry 223 (class 1259 OID 16445)
-- Name: dim_tempo_id_data_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dim_tempo_id_data_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 223
-- Name: dim_tempo_id_data_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dim_tempo_id_data_seq OWNED BY public.dim_tempo.id_data;


--
-- TOC entry 228 (class 1259 OID 16466)
-- Name: fato_ligacoes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fato_ligacoes (
    id_ligacoes integer NOT NULL,
    id_data integer NOT NULL,
    id_agente integer NOT NULL,
    id_filial integer NOT NULL,
    id_caracteristicas integer NOT NULL,
    id_chamada_origem character varying(64) NOT NULL,
    data_hora timestamp without time zone NOT NULL,
    tipo_telefone character varying(10),
    tipo_ligacao character varying(25),
    tempo_falado_seg integer NOT NULL,
    finalizado_agente boolean,
    lead_queimado boolean DEFAULT false NOT NULL,
    audio_url text
);


--
-- TOC entry 227 (class 1259 OID 16465)
-- Name: fato_ligacoes_id_ligacoes_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fato_ligacoes_id_ligacoes_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 227
-- Name: fato_ligacoes_id_ligacoes_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fato_ligacoes_id_ligacoes_seq OWNED BY public.fato_ligacoes.id_ligacoes;


--
-- TOC entry 230 (class 1259 OID 16507)
-- Name: fato_produtividade_agente; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fato_produtividade_agente (
    id_produtividade integer NOT NULL,
    id_data integer NOT NULL,
    id_agente integer NOT NULL,
    id_filial integer NOT NULL,
    tempo_em_ligacao_seg integer,
    qtd_ligacoes_diario smallint,
    tempo_logado_seg integer,
    tpa_seg integer
);


--
-- TOC entry 229 (class 1259 OID 16506)
-- Name: fato_produtividade_agente_id_produtividade_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fato_produtividade_agente_id_produtividade_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 229
-- Name: fato_produtividade_agente_id_produtividade_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fato_produtividade_agente_id_produtividade_seq OWNED BY public.fato_produtividade_agente.id_produtividade;


--
-- TOC entry 4882 (class 2604 OID 16440)
-- Name: dim_agente id_agente; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_agente ALTER COLUMN id_agente SET DEFAULT nextval('public.dim_agente_id_agente_seq'::regclass);


--
-- TOC entry 4884 (class 2604 OID 16457)
-- Name: dim_caracteristicas id_caracteristicas; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_caracteristicas ALTER COLUMN id_caracteristicas SET DEFAULT nextval('public.dim_caracteristicas_id_caracteristicas_seq'::regclass);


--
-- TOC entry 4881 (class 2604 OID 16430)
-- Name: dim_filial id_filial; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_filial ALTER COLUMN id_filial SET DEFAULT nextval('public.dim_filial_id_filial_seq'::regclass);


--
-- TOC entry 4883 (class 2604 OID 16449)
-- Name: dim_tempo id_data; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_tempo ALTER COLUMN id_data SET DEFAULT nextval('public.dim_tempo_id_data_seq'::regclass);


--
-- TOC entry 4885 (class 2604 OID 16469)
-- Name: fato_ligacoes id_ligacoes; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fato_ligacoes ALTER COLUMN id_ligacoes SET DEFAULT nextval('public.fato_ligacoes_id_ligacoes_seq'::regclass);


--
-- TOC entry 4887 (class 2604 OID 16510)
-- Name: fato_produtividade_agente id_produtividade; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fato_produtividade_agente ALTER COLUMN id_produtividade SET DEFAULT nextval('public.fato_produtividade_agente_id_produtividade_seq'::regclass);


--
-- TOC entry 4891 (class 2606 OID 16444)
-- Name: dim_agente pk_dim_agente; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_agente
    ADD CONSTRAINT pk_dim_agente PRIMARY KEY (id_agente);


--
-- TOC entry 4895 (class 2606 OID 16464)
-- Name: dim_caracteristicas pk_dim_caracteristicas; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_caracteristicas
    ADD CONSTRAINT pk_dim_caracteristicas PRIMARY KEY (id_caracteristicas);


--
-- TOC entry 4889 (class 2606 OID 16435)
-- Name: dim_filial pk_dim_filial; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_filial
    ADD CONSTRAINT pk_dim_filial PRIMARY KEY (id_filial);


--
-- TOC entry 4893 (class 2606 OID 16452)
-- Name: dim_tempo pk_dim_tempo; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_tempo
    ADD CONSTRAINT pk_dim_tempo PRIMARY KEY (id_data);


--
-- TOC entry 4897 (class 2606 OID 16483)
-- Name: fato_ligacoes pk_fato_ligacoes; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fato_ligacoes
    ADD CONSTRAINT pk_fato_ligacoes PRIMARY KEY (id_ligacoes);


--
-- TOC entry 4901 (class 2606 OID 16516)
-- Name: fato_produtividade_agente pk_fato_produtividade_agente; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fato_produtividade_agente
    ADD CONSTRAINT pk_fato_produtividade_agente PRIMARY KEY (id_produtividade);


--
-- TOC entry 4899 (class 2606 OID 16485)
-- Name: fato_ligacoes unq_fato_ligacoes; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fato_ligacoes
    ADD CONSTRAINT unq_fato_ligacoes UNIQUE (id_chamada_origem);


--
-- TOC entry 4903 (class 2606 OID 16518)
-- Name: fato_produtividade_agente unq_fato_produtividade_agente; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fato_produtividade_agente
    ADD CONSTRAINT unq_fato_produtividade_agente UNIQUE (id_data, id_agente, id_filial);


--
-- TOC entry 4904 (class 2606 OID 16491)
-- Name: fato_ligacoes fk_fato_ligacoes_dim_agente; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fato_ligacoes
    ADD CONSTRAINT fk_fato_ligacoes_dim_agente FOREIGN KEY (id_agente) REFERENCES public.dim_agente(id_agente);


--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 4904
-- Name: CONSTRAINT fk_fato_ligacoes_dim_agente ON fato_ligacoes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT fk_fato_ligacoes_dim_agente ON public.fato_ligacoes IS 'id_agente';


--
-- TOC entry 4905 (class 2606 OID 16501)
-- Name: fato_ligacoes fk_fato_ligacoes_dim_caracteristicas; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fato_ligacoes
    ADD CONSTRAINT fk_fato_ligacoes_dim_caracteristicas FOREIGN KEY (id_caracteristicas) REFERENCES public.dim_caracteristicas(id_caracteristicas);


--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 4905
-- Name: CONSTRAINT fk_fato_ligacoes_dim_caracteristicas ON fato_ligacoes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT fk_fato_ligacoes_dim_caracteristicas ON public.fato_ligacoes IS 'id_caracteristicas';


--
-- TOC entry 4906 (class 2606 OID 16496)
-- Name: fato_ligacoes fk_fato_ligacoes_dim_filial; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fato_ligacoes
    ADD CONSTRAINT fk_fato_ligacoes_dim_filial FOREIGN KEY (id_filial) REFERENCES public.dim_filial(id_filial);


--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 4906
-- Name: CONSTRAINT fk_fato_ligacoes_dim_filial ON fato_ligacoes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT fk_fato_ligacoes_dim_filial ON public.fato_ligacoes IS 'id_filial';


--
-- TOC entry 4907 (class 2606 OID 16486)
-- Name: fato_ligacoes fk_fato_ligacoes_dim_tempo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fato_ligacoes
    ADD CONSTRAINT fk_fato_ligacoes_dim_tempo FOREIGN KEY (id_data) REFERENCES public.dim_tempo(id_data);


--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 4907
-- Name: CONSTRAINT fk_fato_ligacoes_dim_tempo ON fato_ligacoes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT fk_fato_ligacoes_dim_tempo ON public.fato_ligacoes IS 'id_data';


--
-- TOC entry 4908 (class 2606 OID 16524)
-- Name: fato_produtividade_agente fk_fato_produtividade_agente_dim_agente; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fato_produtividade_agente
    ADD CONSTRAINT fk_fato_produtividade_agente_dim_agente FOREIGN KEY (id_agente) REFERENCES public.dim_agente(id_agente);


--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 4908
-- Name: CONSTRAINT fk_fato_produtividade_agente_dim_agente ON fato_produtividade_agente; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT fk_fato_produtividade_agente_dim_agente ON public.fato_produtividade_agente IS 'id_agente';


--
-- TOC entry 4909 (class 2606 OID 16529)
-- Name: fato_produtividade_agente fk_fato_produtividade_agente_dim_filial; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fato_produtividade_agente
    ADD CONSTRAINT fk_fato_produtividade_agente_dim_filial FOREIGN KEY (id_filial) REFERENCES public.dim_filial(id_filial);


--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 4909
-- Name: CONSTRAINT fk_fato_produtividade_agente_dim_filial ON fato_produtividade_agente; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT fk_fato_produtividade_agente_dim_filial ON public.fato_produtividade_agente IS 'id_filial';


--
-- TOC entry 4910 (class 2606 OID 16519)
-- Name: fato_produtividade_agente fk_fato_produtividade_agente_dim_tempo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fato_produtividade_agente
    ADD CONSTRAINT fk_fato_produtividade_agente_dim_tempo FOREIGN KEY (id_data) REFERENCES public.dim_tempo(id_data);


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 4910
-- Name: CONSTRAINT fk_fato_produtividade_agente_dim_tempo ON fato_produtividade_agente; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT fk_fato_produtividade_agente_dim_tempo ON public.fato_produtividade_agente IS 'id_data';


-- Completed on 2026-09-07 12:31:14

--
-- PostgreSQL database dump complete
--

\unrestrict IexlMi7UvaZUeyXkqTbuZUqXj3XkhkVZbXfM5YTAf7uejrBQbAXiPYD67vmG2by

