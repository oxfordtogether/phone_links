SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

--
-- Name: admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admins (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    person_id bigint NOT NULL,
    start_date date NOT NULL,
    end_date date
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: callees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.callees (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    person_id bigint NOT NULL,
    start_date date NOT NULL,
    end_date date
);


--
-- Name: callees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.callees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: callees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.callees_id_seq OWNED BY public.callees.id;


--
-- Name: callers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.callers (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    person_id bigint NOT NULL,
    start_date date NOT NULL,
    end_date date
);


--
-- Name: callers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.callers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: callers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.callers_id_seq OWNED BY public.callers.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    title_ciphertext text,
    first_name_ciphertext text NOT NULL,
    last_name_ciphertext text NOT NULL,
    phone_ciphertext text,
    email_ciphertext text,
    address_line_1_ciphertext text,
    address_line_2_ciphertext text,
    address_town_ciphertext text,
    address_postcode_ciphertext text,
    auth0_id character varying
);


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.people_id_seq OWNED BY public.people.id;


--
-- Name: pod_leaders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pod_leaders (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    person_id bigint NOT NULL,
    start_date date NOT NULL,
    end_date date
);


--
-- Name: pod_leaders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pod_leaders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pod_leaders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pod_leaders_id_seq OWNED BY public.pod_leaders.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- Name: callees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.callees ALTER COLUMN id SET DEFAULT nextval('public.callees_id_seq'::regclass);


--
-- Name: callers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.callers ALTER COLUMN id SET DEFAULT nextval('public.callers_id_seq'::regclass);


--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people ALTER COLUMN id SET DEFAULT nextval('public.people_id_seq'::regclass);


--
-- Name: pod_leaders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pod_leaders ALTER COLUMN id SET DEFAULT nextval('public.pod_leaders_id_seq'::regclass);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: callees callees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.callees
    ADD CONSTRAINT callees_pkey PRIMARY KEY (id);


--
-- Name: callers callers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.callers
    ADD CONSTRAINT callers_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: pod_leaders pod_leaders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pod_leaders
    ADD CONSTRAINT pod_leaders_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_admins_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admins_on_person_id ON public.admins USING btree (person_id);


--
-- Name: index_callees_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_callees_on_person_id ON public.callees USING btree (person_id);


--
-- Name: index_callers_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_callers_on_person_id ON public.callers USING btree (person_id);


--
-- Name: index_pod_leaders_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pod_leaders_on_person_id ON public.pod_leaders USING btree (person_id);


--
-- Name: pod_leaders fk_rails_46322976c4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pod_leaders
    ADD CONSTRAINT fk_rails_46322976c4 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: admins fk_rails_53af473728; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT fk_rails_53af473728 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: callees fk_rails_78fe3fbded; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.callees
    ADD CONSTRAINT fk_rails_78fe3fbded FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: callers fk_rails_a909fc7ff6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.callers
    ADD CONSTRAINT fk_rails_a909fc7ff6 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20210201135857');


