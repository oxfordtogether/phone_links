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

SET default_table_access_method = heap;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admins (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    person_id bigint NOT NULL,
    status_change_notes_ciphertext text,
    status character varying NOT NULL,
    status_change_datetime timestamp without time zone
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
    reason_for_referral_ciphertext text,
    living_arrangements_ciphertext text,
    other_information_ciphertext text,
    additional_needs_ciphertext text,
    pod_id bigint,
    call_frequency_ciphertext text,
    added_to_waiting_list date,
    status_change_notes_ciphertext text,
    status character varying NOT NULL,
    status_change_datetime timestamp without time zone,
    languages_notes_ciphertext text,
    summary_ciphertext text
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
    experience_ciphertext text,
    pod_id bigint,
    added_to_waiting_list date,
    status_change_notes_ciphertext text,
    status character varying NOT NULL,
    status_change_datetime timestamp without time zone,
    languages_notes_ciphertext text,
    check_in_frequency character varying,
    next_check_in date,
    pod_whatsapp_membership boolean,
    has_capacity boolean,
    capacity_notes_ciphertext text,
    capacity_last_updated timestamp without time zone
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
-- Name: emergency_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.emergency_contacts (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    callee_id bigint NOT NULL,
    name_ciphertext text NOT NULL,
    contact_details_ciphertext text NOT NULL,
    relationship_ciphertext text NOT NULL
);


--
-- Name: emergency_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.emergency_contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: emergency_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.emergency_contacts_id_seq OWNED BY public.emergency_contacts.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    type character varying,
    version character varying,
    occurred_at timestamp without time zone,
    sensitive_data_ciphertext text,
    non_sensitive_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    person_id bigint NOT NULL,
    replacement_event_id bigint,
    created_by_id bigint,
    match_id bigint,
    report_id bigint,
    note_id bigint
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: match_status_changes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.match_status_changes (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone NOT NULL,
    match_id bigint,
    status character varying NOT NULL,
    created_by_id bigint,
    notes_ciphertext text,
    datetime timestamp without time zone NOT NULL
);


--
-- Name: match_status_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.match_status_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: match_status_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.match_status_changes_id_seq OWNED BY public.match_status_changes.id;


--
-- Name: matches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.matches (
    id bigint NOT NULL,
    caller_id bigint NOT NULL,
    callee_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    pod_id bigint NOT NULL,
    deleted_at timestamp without time zone,
    status character varying,
    status_change_notes_ciphertext text,
    status_change_datetime timestamp without time zone,
    report_frequency character varying,
    alerts_paused_until date
);


--
-- Name: matches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.matches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: matches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.matches_id_seq OWNED BY public.matches.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notes (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    person_id bigint,
    created_by_id bigint NOT NULL,
    deleted_at timestamp without time zone,
    content_ciphertext text,
    note_type character varying
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notes_id_seq OWNED BY public.notes.id;


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
    auth0_id character varying,
    flag_in_progress boolean,
    age_bracket character varying,
    flag_change_notes_ciphertext text,
    flag_change_datetime timestamp without time zone,
    invite_email_sent_at timestamp without time zone,
    opas_id character varying
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
-- Name: person_flag_changes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_flag_changes (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    person_id bigint,
    flag_in_progress boolean,
    notes_ciphertext text,
    datetime timestamp without time zone,
    created_by_id bigint
);


--
-- Name: person_flag_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.person_flag_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_flag_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.person_flag_changes_id_seq OWNED BY public.person_flag_changes.id;


--
-- Name: pod_leaders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pod_leaders (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    person_id bigint NOT NULL,
    status_change_notes_ciphertext text,
    status character varying NOT NULL,
    status_change_datetime timestamp without time zone,
    report_received_email_updates boolean
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
-- Name: pod_supporters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pod_supporters (
    id bigint NOT NULL,
    pod_id bigint NOT NULL,
    supporter_id bigint NOT NULL
);


--
-- Name: pod_supporters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pod_supporters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pod_supporters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pod_supporters_id_seq OWNED BY public.pod_supporters.id;


--
-- Name: pods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pods (
    id bigint NOT NULL,
    name character varying,
    pod_leader_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    theme character varying,
    safeguarding_lead_id bigint
);


--
-- Name: pods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pods_id_seq OWNED BY public.pods.id;


--
-- Name: referral_status_changes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.referral_status_changes (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    referral_id bigint NOT NULL,
    status character varying NOT NULL,
    notes_ciphertext text,
    datetime timestamp without time zone NOT NULL,
    created_by_id bigint NOT NULL
);


--
-- Name: referral_status_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.referral_status_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: referral_status_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.referral_status_changes_id_seq OWNED BY public.referral_status_changes.id;


--
-- Name: referrals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.referrals (
    id bigint NOT NULL,
    submitted_at timestamp without time zone NOT NULL,
    referrer_type character varying,
    referrer_organisation_ciphertext text,
    referrer_full_name_ciphertext text,
    referrer_phone_ciphertext text,
    referrer_email_ciphertext text,
    first_name_ciphertext text NOT NULL,
    last_name_ciphertext text NOT NULL,
    phone_ciphertext text NOT NULL,
    age_bracket character varying,
    date_of_birth_ciphertext text,
    address_line_1_ciphertext text,
    address_line_2_ciphertext text,
    address_town_ciphertext text,
    address_postcode_ciphertext text,
    reason_for_referral_ciphertext text,
    additional_needs_ciphertext text,
    other_information_ciphertext text,
    other_support_ciphertext text,
    languages_ciphertext text,
    emergency_contact_name_ciphertext text,
    emergency_contact_relationship_ciphertext text,
    emergency_contact_details_ciphertext text,
    callee_id bigint,
    status character varying NOT NULL,
    notes_ciphertext text,
    status_changed_at timestamp without time zone NOT NULL,
    confirm_consent boolean NOT NULL,
    confirm_data_shared boolean NOT NULL,
    confirm_data_protection boolean NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: referrals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.referrals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: referrals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.referrals_id_seq OWNED BY public.referrals.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reports (
    id bigint NOT NULL,
    duration character varying,
    callee_feeling character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    summary_ciphertext text,
    match_id bigint,
    legacy_caller_email_ciphertext text,
    legacy_caller_name_ciphertext text,
    legacy_callee_name_ciphertext text,
    legacy_time_and_date_ciphertext text,
    legacy_time character varying,
    legacy_date character varying,
    legacy_duration character varying,
    concerns boolean,
    concerns_notes_ciphertext text,
    legacy_outcome_ciphertext text,
    legacy_pod_id integer,
    archived_at timestamp without time zone,
    caller_feeling character varying,
    date_of_call date,
    no_answer_notes_ciphertext text
);


--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reports_id_seq OWNED BY public.reports.id;


--
-- Name: role_status_changes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_status_changes (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    caller_id bigint,
    callee_id bigint,
    admin_id bigint,
    pod_leader_id bigint,
    status character varying NOT NULL,
    notes_ciphertext text,
    datetime timestamp without time zone NOT NULL,
    created_by_id bigint
);


--
-- Name: role_status_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.role_status_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: role_status_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.role_status_changes_id_seq OWNED BY public.role_status_changes.id;


--
-- Name: safeguarding_concern_status_changes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.safeguarding_concern_status_changes (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    safeguarding_concern_id bigint NOT NULL,
    status character varying NOT NULL,
    notes_ciphertext text,
    datetime timestamp without time zone NOT NULL,
    created_by_id bigint NOT NULL
);


--
-- Name: safeguarding_concern_status_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.safeguarding_concern_status_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: safeguarding_concern_status_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.safeguarding_concern_status_changes_id_seq OWNED BY public.safeguarding_concern_status_changes.id;


--
-- Name: safeguarding_concerns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.safeguarding_concerns (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    person_id bigint NOT NULL,
    created_by_id bigint NOT NULL,
    concerns_ciphertext text NOT NULL,
    status character varying NOT NULL,
    status_changed_at timestamp without time zone NOT NULL,
    status_changed_notes_ciphertext text
);


--
-- Name: safeguarding_concerns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.safeguarding_concerns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: safeguarding_concerns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.safeguarding_concerns_id_seq OWNED BY public.safeguarding_concerns.id;


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
-- Name: emergency_contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emergency_contacts ALTER COLUMN id SET DEFAULT nextval('public.emergency_contacts_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: match_status_changes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match_status_changes ALTER COLUMN id SET DEFAULT nextval('public.match_status_changes_id_seq'::regclass);


--
-- Name: matches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matches ALTER COLUMN id SET DEFAULT nextval('public.matches_id_seq'::regclass);


--
-- Name: notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes ALTER COLUMN id SET DEFAULT nextval('public.notes_id_seq'::regclass);


--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people ALTER COLUMN id SET DEFAULT nextval('public.people_id_seq'::regclass);


--
-- Name: person_flag_changes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_flag_changes ALTER COLUMN id SET DEFAULT nextval('public.person_flag_changes_id_seq'::regclass);


--
-- Name: pod_leaders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pod_leaders ALTER COLUMN id SET DEFAULT nextval('public.pod_leaders_id_seq'::regclass);


--
-- Name: pod_supporters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pod_supporters ALTER COLUMN id SET DEFAULT nextval('public.pod_supporters_id_seq'::regclass);


--
-- Name: pods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pods ALTER COLUMN id SET DEFAULT nextval('public.pods_id_seq'::regclass);


--
-- Name: referral_status_changes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.referral_status_changes ALTER COLUMN id SET DEFAULT nextval('public.referral_status_changes_id_seq'::regclass);


--
-- Name: referrals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.referrals ALTER COLUMN id SET DEFAULT nextval('public.referrals_id_seq'::regclass);


--
-- Name: reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports ALTER COLUMN id SET DEFAULT nextval('public.reports_id_seq'::regclass);


--
-- Name: role_status_changes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_status_changes ALTER COLUMN id SET DEFAULT nextval('public.role_status_changes_id_seq'::regclass);


--
-- Name: safeguarding_concern_status_changes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.safeguarding_concern_status_changes ALTER COLUMN id SET DEFAULT nextval('public.safeguarding_concern_status_changes_id_seq'::regclass);


--
-- Name: safeguarding_concerns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.safeguarding_concerns ALTER COLUMN id SET DEFAULT nextval('public.safeguarding_concerns_id_seq'::regclass);


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
-- Name: emergency_contacts emergency_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emergency_contacts
    ADD CONSTRAINT emergency_contacts_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: match_status_changes match_status_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match_status_changes
    ADD CONSTRAINT match_status_changes_pkey PRIMARY KEY (id);


--
-- Name: matches matches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: person_flag_changes person_flag_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_flag_changes
    ADD CONSTRAINT person_flag_changes_pkey PRIMARY KEY (id);


--
-- Name: pod_leaders pod_leaders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pod_leaders
    ADD CONSTRAINT pod_leaders_pkey PRIMARY KEY (id);


--
-- Name: pod_supporters pod_supporters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pod_supporters
    ADD CONSTRAINT pod_supporters_pkey PRIMARY KEY (id);


--
-- Name: pods pods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pods
    ADD CONSTRAINT pods_pkey PRIMARY KEY (id);


--
-- Name: referral_status_changes referral_status_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.referral_status_changes
    ADD CONSTRAINT referral_status_changes_pkey PRIMARY KEY (id);


--
-- Name: referrals referrals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_pkey PRIMARY KEY (id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: role_status_changes role_status_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_status_changes
    ADD CONSTRAINT role_status_changes_pkey PRIMARY KEY (id);


--
-- Name: safeguarding_concern_status_changes safeguarding_concern_status_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.safeguarding_concern_status_changes
    ADD CONSTRAINT safeguarding_concern_status_changes_pkey PRIMARY KEY (id);


--
-- Name: safeguarding_concerns safeguarding_concerns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.safeguarding_concerns
    ADD CONSTRAINT safeguarding_concerns_pkey PRIMARY KEY (id);


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
-- Name: index_callees_on_pod_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_callees_on_pod_id ON public.callees USING btree (pod_id);


--
-- Name: index_callers_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_callers_on_person_id ON public.callers USING btree (person_id);


--
-- Name: index_callers_on_pod_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_callers_on_pod_id ON public.callers USING btree (pod_id);


--
-- Name: index_emergency_contacts_on_callee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_emergency_contacts_on_callee_id ON public.emergency_contacts USING btree (callee_id);


--
-- Name: index_events_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_created_by_id ON public.events USING btree (created_by_id);


--
-- Name: index_events_on_match_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_match_id ON public.events USING btree (match_id);


--
-- Name: index_events_on_note_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_note_id ON public.events USING btree (note_id);


--
-- Name: index_events_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_person_id ON public.events USING btree (person_id);


--
-- Name: index_events_on_replacement_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_replacement_event_id ON public.events USING btree (replacement_event_id);


--
-- Name: index_events_on_report_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_report_id ON public.events USING btree (report_id);


--
-- Name: index_match_status_changes_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_match_status_changes_on_created_by_id ON public.match_status_changes USING btree (created_by_id);


--
-- Name: index_match_status_changes_on_match_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_match_status_changes_on_match_id ON public.match_status_changes USING btree (match_id);


--
-- Name: index_matches_on_callee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_matches_on_callee_id ON public.matches USING btree (callee_id);


--
-- Name: index_matches_on_callee_id_and_caller_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_matches_on_callee_id_and_caller_id ON public.matches USING btree (callee_id, caller_id);


--
-- Name: index_matches_on_caller_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_matches_on_caller_id ON public.matches USING btree (caller_id);


--
-- Name: index_matches_on_pod_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_matches_on_pod_id ON public.matches USING btree (pod_id);


--
-- Name: index_notes_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_created_by_id ON public.notes USING btree (created_by_id);


--
-- Name: index_notes_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_person_id ON public.notes USING btree (person_id);


--
-- Name: index_person_flag_changes_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_flag_changes_on_created_by_id ON public.person_flag_changes USING btree (created_by_id);


--
-- Name: index_person_flag_changes_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_flag_changes_on_person_id ON public.person_flag_changes USING btree (person_id);


--
-- Name: index_pod_leaders_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pod_leaders_on_person_id ON public.pod_leaders USING btree (person_id);


--
-- Name: index_pod_supporters_on_pod_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pod_supporters_on_pod_id ON public.pod_supporters USING btree (pod_id);


--
-- Name: index_pod_supporters_on_supporter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pod_supporters_on_supporter_id ON public.pod_supporters USING btree (supporter_id);


--
-- Name: index_pods_on_pod_leader_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pods_on_pod_leader_id ON public.pods USING btree (pod_leader_id);


--
-- Name: index_pods_on_safeguarding_lead_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pods_on_safeguarding_lead_id ON public.pods USING btree (safeguarding_lead_id);


--
-- Name: index_referral_status_changes_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_referral_status_changes_on_created_by_id ON public.referral_status_changes USING btree (created_by_id);


--
-- Name: index_referral_status_changes_on_referral_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_referral_status_changes_on_referral_id ON public.referral_status_changes USING btree (referral_id);


--
-- Name: index_referrals_on_callee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_referrals_on_callee_id ON public.referrals USING btree (callee_id);


--
-- Name: index_reports_on_match_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reports_on_match_id ON public.reports USING btree (match_id);


--
-- Name: index_role_status_changes_on_admin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_role_status_changes_on_admin_id ON public.role_status_changes USING btree (admin_id);


--
-- Name: index_role_status_changes_on_callee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_role_status_changes_on_callee_id ON public.role_status_changes USING btree (callee_id);


--
-- Name: index_role_status_changes_on_caller_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_role_status_changes_on_caller_id ON public.role_status_changes USING btree (caller_id);


--
-- Name: index_role_status_changes_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_role_status_changes_on_created_by_id ON public.role_status_changes USING btree (created_by_id);


--
-- Name: index_role_status_changes_on_pod_leader_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_role_status_changes_on_pod_leader_id ON public.role_status_changes USING btree (pod_leader_id);


--
-- Name: index_safeguarding_concern_status_changes_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_safeguarding_concern_status_changes_on_created_by_id ON public.safeguarding_concern_status_changes USING btree (created_by_id);


--
-- Name: index_safeguarding_concerns_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_safeguarding_concerns_on_created_by_id ON public.safeguarding_concerns USING btree (created_by_id);


--
-- Name: index_safeguarding_concerns_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_safeguarding_concerns_on_person_id ON public.safeguarding_concerns USING btree (person_id);


--
-- Name: safeguarding_concerns_on_status_changes; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX safeguarding_concerns_on_status_changes ON public.safeguarding_concern_status_changes USING btree (safeguarding_concern_id);


--
-- Name: pod_supporters fk_rails_0ad7126891; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pod_supporters
    ADD CONSTRAINT fk_rails_0ad7126891 FOREIGN KEY (supporter_id) REFERENCES public.pod_leaders(id);


--
-- Name: events fk_rails_0dd58ac981; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_rails_0dd58ac981 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: events fk_rails_1f2fddcdaa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_rails_1f2fddcdaa FOREIGN KEY (created_by_id) REFERENCES public.people(id);


--
-- Name: notes fk_rails_27aea6a7e9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT fk_rails_27aea6a7e9 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: emergency_contacts fk_rails_27ba376a32; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emergency_contacts
    ADD CONSTRAINT fk_rails_27ba376a32 FOREIGN KEY (callee_id) REFERENCES public.callees(id);


--
-- Name: safeguarding_concerns fk_rails_299444fc6c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.safeguarding_concerns
    ADD CONSTRAINT fk_rails_299444fc6c FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: callers fk_rails_2fcae7eb33; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.callers
    ADD CONSTRAINT fk_rails_2fcae7eb33 FOREIGN KEY (pod_id) REFERENCES public.pods(id);


--
-- Name: match_status_changes fk_rails_3e27337676; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match_status_changes
    ADD CONSTRAINT fk_rails_3e27337676 FOREIGN KEY (created_by_id) REFERENCES public.people(id);


--
-- Name: safeguarding_concern_status_changes fk_rails_40143a54c2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.safeguarding_concern_status_changes
    ADD CONSTRAINT fk_rails_40143a54c2 FOREIGN KEY (created_by_id) REFERENCES public.people(id);


--
-- Name: pod_leaders fk_rails_46322976c4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pod_leaders
    ADD CONSTRAINT fk_rails_46322976c4 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: pods fk_rails_464113068e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pods
    ADD CONSTRAINT fk_rails_464113068e FOREIGN KEY (pod_leader_id) REFERENCES public.pod_leaders(id);


--
-- Name: notes fk_rails_492bbd23f7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT fk_rails_492bbd23f7 FOREIGN KEY (created_by_id) REFERENCES public.people(id);


--
-- Name: role_status_changes fk_rails_4b94fae5f4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_status_changes
    ADD CONSTRAINT fk_rails_4b94fae5f4 FOREIGN KEY (pod_leader_id) REFERENCES public.pod_leaders(id);


--
-- Name: reports fk_rails_4d81dc2685; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT fk_rails_4d81dc2685 FOREIGN KEY (match_id) REFERENCES public.matches(id);


--
-- Name: matches fk_rails_51008760a5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT fk_rails_51008760a5 FOREIGN KEY (caller_id) REFERENCES public.callers(id);


--
-- Name: admins fk_rails_53af473728; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT fk_rails_53af473728 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: events fk_rails_5718cd1e6b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_rails_5718cd1e6b FOREIGN KEY (match_id) REFERENCES public.matches(id);


--
-- Name: match_status_changes fk_rails_5c47c12d87; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match_status_changes
    ADD CONSTRAINT fk_rails_5c47c12d87 FOREIGN KEY (match_id) REFERENCES public.matches(id);


--
-- Name: role_status_changes fk_rails_5c95418a55; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_status_changes
    ADD CONSTRAINT fk_rails_5c95418a55 FOREIGN KEY (admin_id) REFERENCES public.admins(id);


--
-- Name: pods fk_rails_62a7a8f2fd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pods
    ADD CONSTRAINT fk_rails_62a7a8f2fd FOREIGN KEY (safeguarding_lead_id) REFERENCES public.people(id);


--
-- Name: role_status_changes fk_rails_66538fd5d7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_status_changes
    ADD CONSTRAINT fk_rails_66538fd5d7 FOREIGN KEY (created_by_id) REFERENCES public.people(id);


--
-- Name: matches fk_rails_69b1603b02; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT fk_rails_69b1603b02 FOREIGN KEY (callee_id) REFERENCES public.callees(id);


--
-- Name: person_flag_changes fk_rails_736966842e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_flag_changes
    ADD CONSTRAINT fk_rails_736966842e FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: callees fk_rails_78fe3fbded; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.callees
    ADD CONSTRAINT fk_rails_78fe3fbded FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: role_status_changes fk_rails_85ebe94056; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_status_changes
    ADD CONSTRAINT fk_rails_85ebe94056 FOREIGN KEY (caller_id) REFERENCES public.callers(id);


--
-- Name: role_status_changes fk_rails_8dc64b3f50; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_status_changes
    ADD CONSTRAINT fk_rails_8dc64b3f50 FOREIGN KEY (callee_id) REFERENCES public.callees(id);


--
-- Name: events fk_rails_994e0816d3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_rails_994e0816d3 FOREIGN KEY (report_id) REFERENCES public.reports(id);


--
-- Name: callees fk_rails_9c9ab4a301; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.callees
    ADD CONSTRAINT fk_rails_9c9ab4a301 FOREIGN KEY (pod_id) REFERENCES public.pods(id);


--
-- Name: callers fk_rails_a909fc7ff6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.callers
    ADD CONSTRAINT fk_rails_a909fc7ff6 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: matches fk_rails_ae1d288fdb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT fk_rails_ae1d288fdb FOREIGN KEY (pod_id) REFERENCES public.pods(id);


--
-- Name: events fk_rails_b241ca1d8a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_rails_b241ca1d8a FOREIGN KEY (note_id) REFERENCES public.notes(id);


--
-- Name: person_flag_changes fk_rails_b478c163a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_flag_changes
    ADD CONSTRAINT fk_rails_b478c163a7 FOREIGN KEY (created_by_id) REFERENCES public.people(id);


--
-- Name: referrals fk_rails_bf1604e992; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT fk_rails_bf1604e992 FOREIGN KEY (callee_id) REFERENCES public.callees(id);


--
-- Name: safeguarding_concerns fk_rails_cbb7ffc243; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.safeguarding_concerns
    ADD CONSTRAINT fk_rails_cbb7ffc243 FOREIGN KEY (created_by_id) REFERENCES public.people(id);


--
-- Name: pod_supporters fk_rails_d43ab75516; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pod_supporters
    ADD CONSTRAINT fk_rails_d43ab75516 FOREIGN KEY (pod_id) REFERENCES public.pods(id);


--
-- Name: referral_status_changes fk_rails_d532508123; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.referral_status_changes
    ADD CONSTRAINT fk_rails_d532508123 FOREIGN KEY (created_by_id) REFERENCES public.people(id);


--
-- Name: events fk_rails_df200f81d0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_rails_df200f81d0 FOREIGN KEY (replacement_event_id) REFERENCES public.events(id);


--
-- Name: safeguarding_concern_status_changes fk_rails_e6451f98a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.safeguarding_concern_status_changes
    ADD CONSTRAINT fk_rails_e6451f98a7 FOREIGN KEY (safeguarding_concern_id) REFERENCES public.safeguarding_concerns(id);


--
-- Name: referral_status_changes fk_rails_ec2aa0bf11; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.referral_status_changes
    ADD CONSTRAINT fk_rails_ec2aa0bf11 FOREIGN KEY (referral_id) REFERENCES public.referrals(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20210201135857'),
('20210202145925'),
('20210205174703'),
('20210206134510'),
('20210206182028'),
('20210208194108'),
('20210209092549'),
('20210209171012'),
('20210216093905'),
('20210216095558'),
('20210216112002'),
('20210216113251'),
('20210217150541'),
('20210217150818'),
('20210218162712'),
('20210219100515'),
('20210225165903'),
('20210301204932'),
('20210302084427'),
('20210303105023'),
('20210303201322'),
('20210303223122'),
('20210308123420'),
('20210308152630'),
('20210312184948'),
('20210314175851'),
('20210315165450'),
('20210321171009'),
('20210322172217'),
('20210323141425'),
('20210324081428'),
('20210324112724'),
('20210329123023'),
('20210411145446'),
('20210412170354'),
('20210503101028'),
('20210505110236'),
('20210618114520');


