--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: es_co_utf_8; Type: COLLATION; Schema: public; Owner: -
--

CREATE COLLATION es_co_utf_8 (lc_collate = 'es_CO.UTF-8', lc_ctype = 'es_CO.UTF-8');


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: soundexesp(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION soundexesp(input text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE STRICT COST 500
    AS $$
DECLARE
	soundex text='';	
	-- para determinar la primera letra
	pri_letra text;
	resto text;
	sustituida text ='';
	-- para quitar adyacentes
	anterior text;
	actual text;
	corregido text;
BEGIN
       -- devolver null si recibi un string en blanco o con espacios en blanco
	IF length(trim(input))= 0 then
		RETURN NULL;
	end IF;
 
 
	-- 1: LIMPIEZA:
		-- pasar a mayuscula, eliminar la letra "H" inicial, los acentos y la enie
		-- 'holá coñó' => 'OLA CONO'
		input=translate(ltrim(trim(upper(input)),'H'),'ÑÁÉÍÓÚÀÈÌÒÙÜ','NAEIOUAEIOUU');
 
		-- eliminar caracteres no alfabéticos (números, símbolos como &,%,",*,!,+, etc.
		input=regexp_replace(input, '[^a-zA-Z]', '', 'g');
 
	-- 2: PRIMERA LETRA ES IMPORTANTE, DEBO ASOCIAR LAS SIMILARES
	--  'vaca' se convierte en 'baca'  y 'zapote' se convierte en 'sapote'
	-- un fenomeno importante es GE y GI se vuelven JE y JI; CA se vuelve KA, etc
	pri_letra =substr(input,1,1);
	resto =substr(input,2);
	CASE 
		when pri_letra IN ('V') then
			sustituida='B';
		when pri_letra IN ('Z','X') then
			sustituida='S';
		when pri_letra IN ('G') AND substr(input,2,1) IN ('E','I') then
			sustituida='J';
		when pri_letra IN('C') AND substr(input,2,1) NOT IN ('H','E','I') then
			sustituida='K';
		else
			sustituida=pri_letra;
 
	end case;
	--corregir el parametro con las consonantes sustituidas:
	input=sustituida || resto;		
 
	-- 3: corregir "letras compuestas" y volverlas una sola
	input=REPLACE(input,'CH','V');
	input=REPLACE(input,'QU','K');
	input=REPLACE(input,'LL','J');
	input=REPLACE(input,'CE','S');
	input=REPLACE(input,'CI','S');
	input=REPLACE(input,'YA','J');
	input=REPLACE(input,'YE','J');
	input=REPLACE(input,'YI','J');
	input=REPLACE(input,'YO','J');
	input=REPLACE(input,'YU','J');
	input=REPLACE(input,'GE','J');
	input=REPLACE(input,'GI','J');
	input=REPLACE(input,'NY','N');
	-- para debug:    --return input;
 
	-- EMPIEZA EL CALCULO DEL SOUNDEX
	-- 4: OBTENER PRIMERA letra
	pri_letra=substr(input,1,1);
 
	-- 5: retener el resto del string
	resto=substr(input,2);
 
	--6: en el resto del string, quitar vocales y vocales fonéticas
	resto=translate(resto,'@AEIOUHWY','@');
 
	--7: convertir las letras foneticamente equivalentes a numeros  (esto hace que B sea equivalente a V, C con S y Z, etc.)
	resto=translate(resto, 'BPFVCGKSXZDTLMNRQJ', '111122222233455677');
	-- así va quedando la cosa
	soundex=pri_letra || resto;
 
	--8: eliminar números iguales adyacentes (A11233 se vuelve A123)
	anterior=substr(soundex,1,1);
	corregido=anterior;
 
	FOR i IN 2 .. length(soundex) LOOP
		actual = substr(soundex, i, 1);
		IF actual <> anterior THEN
			corregido=corregido || actual;
			anterior=actual;			
		END IF;
	END LOOP;
	-- así va la cosa
	soundex=corregido;
 
	-- 9: siempre retornar un string de 4 posiciones
	soundex=rpad(soundex,4,'0');
	soundex=substr(soundex,1,4);		
 
	-- YA ESTUVO
	RETURN soundex;	
END;	
$$;


--
-- Name: acto_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE acto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: anexo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE anexo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: antecedente_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE antecedente_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aspsicosocial_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE aspsicosocial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: aspsicosocial; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE aspsicosocial (
    id integer DEFAULT nextval('aspsicosocial_id_seq'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT aspsicosocial_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: aspsicosocial_respuesta; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE aspsicosocial_respuesta (
    id_respuesta integer NOT NULL,
    id_aspsicosocial integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: caso_etiqueta_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE caso_etiqueta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: caso_presponsable_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE caso_presponsable_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: respuesta_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE respuesta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_oficina_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sip_oficina_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_oficina; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sip_oficina (
    id integer DEFAULT nextval('sip_oficina_id_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT regionsjr_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_persona_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sip_persona_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_persona; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sip_persona (
    id integer DEFAULT nextval('sip_persona_id_seq'::regclass) NOT NULL,
    nombres character varying(100) COLLATE public.es_co_utf_8 NOT NULL,
    apellidos character varying(100) COLLATE public.es_co_utf_8 NOT NULL,
    anionac integer,
    mesnac integer,
    dianac integer,
    sexo character(1) NOT NULL,
    numerodocumento character varying(100),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_pais integer,
    nacionalde integer,
    tdocumento_id integer,
    id_departamento integer,
    id_municipio integer,
    id_clase integer,
    CONSTRAINT persona_check CHECK (((dianac IS NULL) OR ((((dianac >= 1) AND ((((((((mesnac = 1) OR (mesnac = 3)) OR (mesnac = 5)) OR (mesnac = 7)) OR (mesnac = 8)) OR (mesnac = 10)) OR (mesnac = 12)) AND (dianac <= 31))) OR (((((mesnac = 4) OR (mesnac = 6)) OR (mesnac = 9)) OR (mesnac = 11)) AND (dianac <= 30))) OR ((mesnac = 2) AND (dianac <= 29))))),
    CONSTRAINT persona_mesnac_check CHECK (((mesnac IS NULL) OR ((mesnac >= 1) AND (mesnac <= 12)))),
    CONSTRAINT persona_sexo_check CHECK ((((sexo = 'S'::bpchar) OR (sexo = 'F'::bpchar)) OR (sexo = 'M'::bpchar)))
);


--
-- Name: sivel2_gen_caso_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_caso_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_caso; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_caso (
    id integer DEFAULT nextval('sivel2_gen_caso_id_seq'::regclass) NOT NULL,
    titulo character varying(50),
    fecha date NOT NULL,
    hora character varying(10),
    duracion character varying(10),
    memo text NOT NULL,
    grconfiabilidad character varying(5),
    gresclarecimiento character varying(5),
    grimpunidad character varying(5),
    grinformacion character varying(5),
    bienes text,
    id_intervalo integer DEFAULT 5,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_casosjr; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_casosjr (
    id_caso integer NOT NULL,
    fecharec date NOT NULL,
    asesor integer NOT NULL,
    oficina_id integer DEFAULT 1,
    direccion character varying(1000),
    telefono character varying(1000),
    contacto integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    dependen integer,
    sustento character varying(1000),
    leerescribir boolean,
    trabaja boolean,
    ingresomensual integer,
    gastos integer,
    estrato character(1),
    id_statusmigratorio integer DEFAULT 0,
    id_proteccion integer DEFAULT 0,
    id_idioma integer DEFAULT 0,
    concentimientosjr boolean,
    concentimientobd boolean,
    fechasalida date,
    id_salida integer,
    fechallegada date,
    id_llegada integer,
    categoriaref integer,
    observacionesref character varying(5000),
    comosupo_id integer DEFAULT 1
);


--
-- Name: sivel2_sjr_respuesta; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_respuesta (
    id_caso integer NOT NULL,
    fechaatencion date NOT NULL,
    prorrogas boolean,
    numprorrogas integer,
    montoprorrogas integer,
    fechaultima date,
    lugarultima character varying(500),
    entregada boolean,
    proxprorroga boolean,
    turno character varying(100),
    lugar character varying(500),
    descamp character varying(5000),
    compromisos character varying(5000),
    remision character varying(5000),
    orientaciones character varying(5000),
    gestionessjr character varying(5000),
    observaciones character varying(5000),
    id_personadesea integer DEFAULT 0,
    verifcsjr character varying(5000),
    verifcper character varying(5000),
    efectividad character varying(5000),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id integer DEFAULT nextval('respuesta_seq'::regclass) NOT NULL,
    detallear character varying(5000),
    montoar integer,
    cantidadayes character varying(50),
    institucionayes character varying(500),
    informacionder boolean,
    accionesder character varying(5000),
    detallemotivo character varying(5000),
    difobsprog character varying(5000),
    detalleal character varying(5000),
    montoal integer,
    detalleap character varying(5000),
    montoap integer,
    detalleem character varying(5000),
    montoem integer
);


--
-- Name: sivel2_sjr_statusmigratorio_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_statusmigratorio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_statusmigratorio; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_statusmigratorio (
    id integer DEFAULT nextval('sivel2_sjr_statusmigratorio_id_seq'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT statusmigratorio_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE usuario (
    id integer DEFAULT nextval('usuario_id_seq'::regclass) NOT NULL,
    nusuario character varying(15) NOT NULL,
    password character varying(64) DEFAULT ''::character varying NOT NULL,
    nombre character varying(50) COLLATE public.es_co_utf_8,
    descripcion character varying(50),
    rol integer DEFAULT 4,
    idioma character varying(6) DEFAULT 'es_CO'::character varying NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    sign_in_count integer DEFAULT 0 NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    oficina_id integer,
    failed_attempts integer DEFAULT 0,
    unlock_token character varying(255),
    locked_at timestamp without time zone,
    CONSTRAINT usuario_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion))),
    CONSTRAINT usuario_rol_check CHECK ((rol >= 1))
);


--
-- Name: conscaso1; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW conscaso1 AS
 SELECT sivel2_sjr_casosjr.id_caso AS caso_id,
    array_to_string(ARRAY( SELECT (((sip_persona.nombres)::text || ' '::text) || (sip_persona.apellidos)::text)
           FROM sip_persona
          WHERE (sip_persona.id = sivel2_sjr_casosjr.contacto)), ', '::text) AS contacto_nombre,
    sivel2_sjr_casosjr.fecharec,
    sip_oficina.nombre AS regionsjr_nombre,
    usuario.nusuario,
    sivel2_gen_caso.fecha AS caso_fecha,
    sivel2_sjr_statusmigratorio.nombre AS statusmigratorio_nombre,
    array_to_string(ARRAY( SELECT sivel2_sjr_respuesta.fechaatencion
           FROM sivel2_sjr_respuesta
          WHERE (sivel2_sjr_respuesta.id_caso = sivel2_sjr_casosjr.id_caso)
          ORDER BY sivel2_sjr_respuesta.fechaatencion DESC
         LIMIT 1), ', '::text) AS respuesta_ultimafechaatencion,
    sivel2_gen_caso.memo AS caso_memo
   FROM sivel2_sjr_casosjr,
    sivel2_gen_caso,
    sip_oficina,
    usuario,
    sivel2_sjr_statusmigratorio
  WHERE ((((sivel2_sjr_casosjr.id_caso = sivel2_gen_caso.id) AND (sip_oficina.id = sivel2_sjr_casosjr.oficina_id)) AND (usuario.id = sivel2_sjr_casosjr.asesor)) AND (sivel2_sjr_statusmigratorio.id = sivel2_sjr_casosjr.id_statusmigratorio));


--
-- Name: contexto_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contexto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_actividad; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cor1440_gen_actividad (
    id integer NOT NULL,
    minutos integer,
    nombre character varying(500),
    objetivo character varying(5000),
    resultado character varying(5000),
    fecha date,
    observaciones character varying(5000),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    oficina_id integer NOT NULL,
    rangoedadac_id integer,
    usuario_id integer,
    lugar character varying(500)
);


--
-- Name: cor1440_gen_actividad_actividadtipo; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cor1440_gen_actividad_actividadtipo (
    actividad_id integer,
    actividadtipo_id integer
);


--
-- Name: cor1440_gen_actividad_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cor1440_gen_actividad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_actividad_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cor1440_gen_actividad_id_seq OWNED BY cor1440_gen_actividad.id;


--
-- Name: cor1440_gen_actividad_proyecto; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cor1440_gen_actividad_proyecto (
    id integer NOT NULL,
    actividad_id integer,
    proyecto_id integer
);


--
-- Name: cor1440_gen_actividad_proyecto_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cor1440_gen_actividad_proyecto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_actividad_proyecto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cor1440_gen_actividad_proyecto_id_seq OWNED BY cor1440_gen_actividad_proyecto.id;


--
-- Name: cor1440_gen_actividad_proyectofinanciero; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cor1440_gen_actividad_proyectofinanciero (
    actividad_id integer NOT NULL,
    proyectofinanciero_id integer NOT NULL
);


--
-- Name: cor1440_gen_actividad_rangoedadac; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cor1440_gen_actividad_rangoedadac (
    id integer NOT NULL,
    actividad_id integer,
    rangoedadac_id integer,
    ml integer,
    mr integer,
    fl integer,
    fr integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: cor1440_gen_actividad_rangoedadac_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cor1440_gen_actividad_rangoedadac_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_actividad_rangoedadac_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cor1440_gen_actividad_rangoedadac_id_seq OWNED BY cor1440_gen_actividad_rangoedadac.id;


--
-- Name: cor1440_gen_actividad_sip_anexo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cor1440_gen_actividad_sip_anexo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_actividad_sip_anexo; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cor1440_gen_actividad_sip_anexo (
    actividad_id integer NOT NULL,
    anexo_id integer NOT NULL,
    id integer DEFAULT nextval('cor1440_gen_actividad_sip_anexo_id_seq'::regclass) NOT NULL
);


--
-- Name: cor1440_gen_actividad_usuario; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cor1440_gen_actividad_usuario (
    actividad_id integer NOT NULL,
    usuario_id integer NOT NULL
);


--
-- Name: cor1440_gen_actividadarea; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cor1440_gen_actividadarea (
    id integer NOT NULL,
    nombre character varying(500),
    observaciones character varying(5000),
    fechacreacion date DEFAULT ('now'::text)::date,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: cor1440_gen_actividadarea_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cor1440_gen_actividadarea_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_actividadarea_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cor1440_gen_actividadarea_id_seq OWNED BY cor1440_gen_actividadarea.id;


--
-- Name: cor1440_gen_actividadareas_actividad; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cor1440_gen_actividadareas_actividad (
    id integer NOT NULL,
    actividad_id integer,
    actividadarea_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: cor1440_gen_actividadareas_actividad_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cor1440_gen_actividadareas_actividad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_actividadareas_actividad_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cor1440_gen_actividadareas_actividad_id_seq OWNED BY cor1440_gen_actividadareas_actividad.id;


--
-- Name: cor1440_gen_actividadtipo; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cor1440_gen_actividadtipo (
    id integer NOT NULL,
    nombre character varying(500) NOT NULL,
    observaciones character varying(5000),
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cor1440_gen_actividadtipo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cor1440_gen_actividadtipo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_actividadtipo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cor1440_gen_actividadtipo_id_seq OWNED BY cor1440_gen_actividadtipo.id;


--
-- Name: cor1440_gen_financiador; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cor1440_gen_financiador (
    id integer NOT NULL,
    nombre character varying(1000),
    observaciones character varying(5000),
    fechacreacion date,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: cor1440_gen_financiador_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cor1440_gen_financiador_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_financiador_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cor1440_gen_financiador_id_seq OWNED BY cor1440_gen_financiador.id;


--
-- Name: cor1440_gen_financiador_proyectofinanciero; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cor1440_gen_financiador_proyectofinanciero (
    financiador_id integer NOT NULL,
    proyectofinanciero_id integer NOT NULL
);


--
-- Name: cor1440_gen_informe; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cor1440_gen_informe (
    id integer NOT NULL,
    titulo character varying(500) NOT NULL,
    filtrofechaini date NOT NULL,
    filtrofechafin date NOT NULL,
    filtroproyecto integer,
    filtroactividadarea integer,
    columnanombre boolean,
    columnatipo boolean,
    columnaobjetivo boolean,
    columnaproyecto boolean,
    columnapoblacion boolean,
    recomendaciones character varying(5000),
    avances character varying(5000),
    logros character varying(5000),
    dificultades character varying(5000),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    filtroproyectofinanciero integer
);


--
-- Name: cor1440_gen_informe_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cor1440_gen_informe_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_informe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cor1440_gen_informe_id_seq OWNED BY cor1440_gen_informe.id;


--
-- Name: cor1440_gen_proyecto; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cor1440_gen_proyecto (
    id integer NOT NULL,
    nombre character varying(1000),
    observaciones character varying(5000),
    fechainicio date,
    fechacierre date,
    resultados character varying(5000),
    fechacreacion date,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: cor1440_gen_proyecto_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cor1440_gen_proyecto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_proyecto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cor1440_gen_proyecto_id_seq OWNED BY cor1440_gen_proyecto.id;


--
-- Name: cor1440_gen_proyecto_proyectofinanciero; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cor1440_gen_proyecto_proyectofinanciero (
    proyecto_id integer NOT NULL,
    proyectofinanciero_id integer NOT NULL
);


--
-- Name: cor1440_gen_proyectofinanciero; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cor1440_gen_proyectofinanciero (
    id integer NOT NULL,
    nombre character varying(1000),
    observaciones character varying(5000),
    fechainicio date,
    fechacierre date,
    responsable_id integer,
    fechacreacion date,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    compromisos character varying(5000),
    monto integer
);


--
-- Name: cor1440_gen_proyectofinanciero_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cor1440_gen_proyectofinanciero_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_proyectofinanciero_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cor1440_gen_proyectofinanciero_id_seq OWNED BY cor1440_gen_proyectofinanciero.id;


--
-- Name: cor1440_gen_rangoedadac; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cor1440_gen_rangoedadac (
    id integer NOT NULL,
    nombre character varying(255),
    limiteinferior integer,
    limitesuperior integer,
    fechacreacion date,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000)
);


--
-- Name: cor1440_gen_rangoedadac_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cor1440_gen_rangoedadac_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cor1440_gen_rangoedadac_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cor1440_gen_rangoedadac_id_seq OWNED BY cor1440_gen_rangoedadac.id;


--
-- Name: desplazamiento_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE desplazamiento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: emprendimiento_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE emprendimiento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: emprendimiento; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE emprendimiento (
    id integer DEFAULT nextval('emprendimiento_id_seq'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT emprendimiento_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: emprendimiento_respuesta; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE emprendimiento_respuesta (
    id_respuesta integer NOT NULL,
    id_emprendimiento integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: fotra_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fotra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grupoper_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE grupoper_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: instanciader_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE instanciader_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mecanismoder_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mecanismoder_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: motivoconsulta_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE motivoconsulta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refugio; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE refugio (
    id integer NOT NULL,
    id_caso integer,
    fechasalida date,
    id_salida integer,
    fechallegada date,
    id_llegada integer,
    id_causaref integer,
    observaciones character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: refugio_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE refugio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refugio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE refugio_id_seq OWNED BY refugio.id;


--
-- Name: regimensalud_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE regimensalud_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resagresion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE resagresion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sip_anexo; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sip_anexo (
    id integer NOT NULL,
    descripcion character varying(1500),
    adjunto_file_name character varying(255),
    adjunto_content_type character varying(255),
    adjunto_file_size integer,
    adjunto_updated_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sip_anexo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sip_anexo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_anexo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sip_anexo_id_seq OWNED BY sip_anexo.id;


--
-- Name: sip_clase_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sip_clase_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_clase; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sip_clase (
    id_clalocal integer,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    id_tclase character varying(10) DEFAULT 'CP'::character varying NOT NULL,
    latitud double precision,
    longitud double precision,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_municipio integer,
    id integer DEFAULT nextval('sip_clase_id_seq'::regclass) NOT NULL,
    observaciones character varying(5000),
    CONSTRAINT clase_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_departamento_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sip_departamento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_departamento; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sip_departamento (
    id_deplocal integer,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    latitud double precision,
    longitud double precision,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_pais integer DEFAULT 0 NOT NULL,
    id integer DEFAULT nextval('sip_departamento_id_seq'::regclass) NOT NULL,
    observaciones character varying(5000),
    CONSTRAINT departamento_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_etiqueta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sip_etiqueta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_etiqueta; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sip_etiqueta (
    id integer DEFAULT nextval('sip_etiqueta_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    observaciones character varying(500),
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT etiqueta_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_fuenteprensa_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sip_fuenteprensa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_fuenteprensa; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sip_fuenteprensa (
    id integer DEFAULT nextval('sip_fuenteprensa_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    tfuente character varying(25),
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT sip_fuenteprensa_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_municipio_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sip_municipio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_municipio; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sip_municipio (
    id_munlocal integer,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    latitud double precision,
    longitud double precision,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_departamento integer,
    id integer DEFAULT nextval('sip_municipio_id_seq'::regclass) NOT NULL,
    observaciones character varying(5000),
    CONSTRAINT municipio_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_mundep_sinorden; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW sip_mundep_sinorden AS
 SELECT ((sip_departamento.id_deplocal * 1000) + sip_municipio.id_munlocal) AS idlocal,
    (((sip_municipio.nombre)::text || ' / '::text) || (sip_departamento.nombre)::text) AS nombre
   FROM (sip_municipio
     JOIN sip_departamento ON ((sip_municipio.id_departamento = sip_departamento.id)))
  WHERE (sip_departamento.id_pais = 170)
UNION
 SELECT sip_departamento.id_deplocal AS idlocal,
    sip_departamento.nombre
   FROM sip_departamento
  WHERE (sip_departamento.id_pais = 170);


--
-- Name: sip_mundep; Type: MATERIALIZED VIEW; Schema: public; Owner: -; Tablespace: 
--

CREATE MATERIALIZED VIEW sip_mundep AS
 SELECT sip_mundep_sinorden.idlocal,
    sip_mundep_sinorden.nombre,
    to_tsvector('spanish'::regconfig, unaccent(sip_mundep_sinorden.nombre)) AS mundep
   FROM sip_mundep_sinorden
  ORDER BY (sip_mundep_sinorden.nombre COLLATE es_co_utf_8)
  WITH NO DATA;


--
-- Name: sip_pais; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sip_pais (
    id integer NOT NULL,
    nombre character varying(200) NOT NULL,
    nombreiso character varying(200) NOT NULL,
    latitud double precision,
    longitud double precision,
    alfa2 character varying(2),
    alfa3 character varying(3),
    codiso integer,
    div1 character varying(100),
    div2 character varying(100),
    div3 character varying(100),
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT pais_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_pais_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sip_pais_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_pais_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sip_pais_id_seq OWNED BY sip_pais.id;


--
-- Name: sip_persona_trelacion; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sip_persona_trelacion (
    persona1 integer NOT NULL,
    persona2 integer NOT NULL,
    id_trelacion character(2) DEFAULT 'SI'::bpchar NOT NULL,
    observaciones character varying(200),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sip_tclase; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sip_tclase (
    id character varying(10) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT tclase_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_tdocumento; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sip_tdocumento (
    id integer NOT NULL,
    nombre character varying(500) NOT NULL,
    sigla character varying(100),
    formatoregex character varying(500),
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000)
);


--
-- Name: sip_tdocumento_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sip_tdocumento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_tdocumento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sip_tdocumento_id_seq OWNED BY sip_tdocumento.id;


--
-- Name: sip_trelacion; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sip_trelacion (
    id character(2) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    observaciones character varying(200),
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    inverso character varying(2),
    CONSTRAINT trelacion_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_tsitio_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sip_tsitio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_tsitio; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sip_tsitio (
    id integer DEFAULT nextval('sip_tsitio_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT tsitio_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sip_ubicacion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sip_ubicacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sip_ubicacion; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sip_ubicacion (
    id integer DEFAULT nextval('sip_ubicacion_id_seq'::regclass) NOT NULL,
    lugar character varying(500) COLLATE public.es_co_utf_8,
    sitio character varying(500) COLLATE public.es_co_utf_8,
    id_tsitio integer DEFAULT 1 NOT NULL,
    id_caso integer NOT NULL,
    latitud double precision,
    longitud double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_pais integer DEFAULT 0,
    id_departamento integer,
    id_municipio integer,
    id_clase integer
);


--
-- Name: sivel2_gen_actividadoficio_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_actividadoficio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_actividadoficio; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_actividadoficio (
    id integer DEFAULT nextval('sivel2_gen_actividadoficio_id_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT actividadoficio_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_acto; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_acto (
    id_presponsable integer NOT NULL,
    id_categoria integer NOT NULL,
    id_persona integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id integer DEFAULT nextval('acto_seq'::regclass) NOT NULL
);


--
-- Name: sivel2_gen_actocolectivo; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_actocolectivo (
    id_presponsable integer NOT NULL,
    id_categoria integer NOT NULL,
    id_grupoper integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_anexo_caso; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_anexo_caso (
    id integer DEFAULT nextval('anexo_seq'::regclass) NOT NULL,
    id_caso integer NOT NULL,
    fecha date NOT NULL,
    fuenteprensa_id integer,
    fechaffrecuente date,
    id_fotra integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_anexo integer NOT NULL
);


--
-- Name: sivel2_gen_antecedente; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_antecedente (
    id integer DEFAULT nextval('antecedente_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT antecedente_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_antecedente_caso; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_antecedente_caso (
    id_antecedente integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_antecedente_comunidad; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_antecedente_comunidad (
    id_antecedente integer NOT NULL,
    id_grupoper integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_antecedente_victima; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_antecedente_victima (
    id_antecedente integer NOT NULL,
    id_persona integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_victima integer
);


--
-- Name: sivel2_gen_caso_categoria_presponsable; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_caso_categoria_presponsable (
    id_tviolencia character varying(1) NOT NULL,
    id_supracategoria integer NOT NULL,
    id_categoria integer NOT NULL,
    id_caso integer NOT NULL,
    id_presponsable integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_caso_presponsable integer NOT NULL
);


--
-- Name: sivel2_gen_caso_contexto; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_caso_contexto (
    id_caso integer NOT NULL,
    id_contexto integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_caso_etiqueta; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_caso_etiqueta (
    id_caso integer NOT NULL,
    id_etiqueta integer NOT NULL,
    id_usuario integer NOT NULL,
    fecha date NOT NULL,
    observaciones character varying(5000),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id integer DEFAULT nextval('caso_etiqueta_seq'::regclass) NOT NULL
);


--
-- Name: sivel2_gen_caso_fotra; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_caso_fotra (
    id_caso integer NOT NULL,
    id_fotra integer NOT NULL,
    anotacion character varying(200),
    fecha date NOT NULL,
    ubicacionfisica character varying(100),
    tfuente character varying(25),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_caso_frontera; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_caso_frontera (
    id_frontera integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_caso_fuenteprensa; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_caso_fuenteprensa (
    fecha date NOT NULL,
    ubicacion character varying(100),
    clasificacion character varying(100),
    ubicacionfisica character varying(100),
    fuenteprensa_id integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_caso_presponsable; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_caso_presponsable (
    id_caso integer NOT NULL,
    id_presponsable integer NOT NULL,
    tipo integer DEFAULT 0 NOT NULL,
    bloque character varying(50),
    frente character varying(50),
    brigada character varying(50),
    batallon character varying(50),
    division character varying(50),
    otro character varying(500),
    id integer DEFAULT nextval('caso_presponsable_seq'::regclass) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_caso_region; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_caso_region (
    id_region integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_caso_usuario; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_caso_usuario (
    id_usuario integer NOT NULL,
    id_caso integer NOT NULL,
    fechainicio date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_categoria; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_categoria (
    id integer NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    id_pconsolidado integer,
    contadaen integer,
    tipocat character(1) DEFAULT 'I'::bpchar,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    supracategoria_id integer,
    CONSTRAINT categoria_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion))),
    CONSTRAINT categoria_tipocat_check CHECK ((((tipocat = 'I'::bpchar) OR (tipocat = 'C'::bpchar)) OR (tipocat = 'O'::bpchar)))
);


--
-- Name: sivel2_gen_comunidad_filiacion; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_comunidad_filiacion (
    id_filiacion integer DEFAULT 10 NOT NULL,
    id_grupoper integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_comunidad_organizacion; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_comunidad_organizacion (
    id_organizacion integer DEFAULT 16 NOT NULL,
    id_grupoper integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_comunidad_profesion; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_comunidad_profesion (
    id_profesion integer DEFAULT 22 NOT NULL,
    id_grupoper integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_comunidad_rangoedad; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_comunidad_rangoedad (
    id_rangoedad integer DEFAULT 6 NOT NULL,
    id_grupoper integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_comunidad_sectorsocial; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_comunidad_sectorsocial (
    id_sectorsocial integer DEFAULT 15 NOT NULL,
    id_grupoper integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_comunidad_vinculoestado; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_comunidad_vinculoestado (
    id_vinculoestado integer DEFAULT 38 NOT NULL,
    id_grupoper integer NOT NULL,
    id_caso integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_conscaso1; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW sivel2_gen_conscaso1 AS
 SELECT casosjr.id_caso AS caso_id,
    array_to_string(ARRAY( SELECT (((persona.nombres)::text || ' '::text) || (persona.apellidos)::text)
           FROM sip_persona persona
          WHERE (persona.id = casosjr.contacto)), ', '::text) AS contacto_nombre,
    casosjr.fecharec,
    oficina.nombre AS oficina_nombre,
    usuario.nusuario,
    caso.fecha AS caso_fecha,
    statusmigratorio.nombre AS statusmigratorio_nombre,
    array_to_string(ARRAY( SELECT respuesta.fechaatencion
           FROM sivel2_sjr_respuesta respuesta
          WHERE (respuesta.id_caso = casosjr.id_caso)
          ORDER BY respuesta.fechaatencion DESC
         LIMIT 1), ', '::text) AS respuesta_ultimafechaatencion,
    caso.memo AS caso_memo
   FROM sivel2_sjr_casosjr casosjr,
    sivel2_gen_caso caso,
    sip_oficina oficina,
    usuario,
    sivel2_sjr_statusmigratorio statusmigratorio
  WHERE ((((casosjr.id_caso = caso.id) AND (oficina.id = casosjr.oficina_id)) AND (usuario.id = casosjr.asesor)) AND (statusmigratorio.id = casosjr.id_statusmigratorio));


--
-- Name: sivel2_gen_conscaso; Type: MATERIALIZED VIEW; Schema: public; Owner: -; Tablespace: 
--

CREATE MATERIALIZED VIEW sivel2_gen_conscaso AS
 SELECT sivel2_gen_conscaso1.caso_id,
    sivel2_gen_conscaso1.contacto_nombre,
    sivel2_gen_conscaso1.fecharec,
    sivel2_gen_conscaso1.oficina_nombre,
    sivel2_gen_conscaso1.nusuario,
    sivel2_gen_conscaso1.caso_fecha,
    sivel2_gen_conscaso1.statusmigratorio_nombre,
    sivel2_gen_conscaso1.respuesta_ultimafechaatencion,
    sivel2_gen_conscaso1.caso_memo,
    to_tsvector('spanish'::regconfig, unaccent(((((((((((((((((sivel2_gen_conscaso1.caso_id || ' '::text) || sivel2_gen_conscaso1.contacto_nombre) || ' '::text) || replace(((sivel2_gen_conscaso1.fecharec)::character varying)::text, '-'::text, ' '::text)) || ' '::text) || (sivel2_gen_conscaso1.oficina_nombre)::text) || ' '::text) || (sivel2_gen_conscaso1.nusuario)::text) || ' '::text) || replace(((sivel2_gen_conscaso1.caso_fecha)::character varying)::text, '-'::text, ' '::text)) || ' '::text) || (sivel2_gen_conscaso1.statusmigratorio_nombre)::text) || ' '::text) || replace(((sivel2_gen_conscaso1.respuesta_ultimafechaatencion)::character varying)::text, '-'::text, ' '::text)) || ' '::text) || sivel2_gen_conscaso1.caso_memo))) AS q
   FROM sivel2_gen_conscaso1
  WITH NO DATA;


--
-- Name: sivel2_gen_contexto; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_contexto (
    id integer DEFAULT nextval('contexto_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT contexto_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_escolaridad_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_escolaridad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_escolaridad; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_escolaridad (
    id integer DEFAULT nextval('sivel2_gen_escolaridad_id_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT escolaridad_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_estadocivil_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_estadocivil_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_estadocivil; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_estadocivil (
    id integer DEFAULT nextval('sivel2_gen_estadocivil_id_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT estadocivil_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_etnia_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_etnia_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_etnia; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_etnia (
    id integer DEFAULT nextval('sivel2_gen_etnia_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    descripcion character varying(1000),
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT etnia_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_filiacion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_filiacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_filiacion; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_filiacion (
    id integer DEFAULT nextval('sivel2_gen_filiacion_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT filiacion_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_fotra; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_fotra (
    id integer DEFAULT nextval('fotra_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_frontera_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_frontera_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_frontera; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_frontera (
    id integer DEFAULT nextval('sivel2_gen_frontera_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT frontera_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_grupoper; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_grupoper (
    id integer DEFAULT nextval('grupoper_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    anotaciones character varying(1000),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_iglesia_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_iglesia_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_iglesia; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_iglesia (
    id integer DEFAULT nextval('sivel2_gen_iglesia_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    descripcion character varying(1000),
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT iglesia_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_intervalo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_intervalo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_intervalo; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_intervalo (
    id integer DEFAULT nextval('sivel2_gen_intervalo_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    rango character varying(25) NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT intervalo_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_maternidad_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_maternidad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_maternidad; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_maternidad (
    id integer DEFAULT nextval('sivel2_gen_maternidad_id_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT maternidad_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_organizacion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_organizacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_organizacion; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_organizacion (
    id integer DEFAULT nextval('sivel2_gen_organizacion_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT organizacion_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_pconsolidado_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_pconsolidado_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_pconsolidado; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_pconsolidado (
    id integer DEFAULT nextval('sivel2_gen_pconsolidado_id_seq'::regclass) NOT NULL,
    rotulo character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    tipoviolencia character varying(25) NOT NULL,
    clasificacion character varying(25) NOT NULL,
    peso integer DEFAULT 0,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT pconsolidado_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_presponsable_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_presponsable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_presponsable; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_presponsable (
    id integer DEFAULT nextval('sivel2_gen_presponsable_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    papa integer,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT presponsable_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_profesion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_profesion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_profesion; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_profesion (
    id integer DEFAULT nextval('sivel2_gen_profesion_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT profesion_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_rangoedad_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_rangoedad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_rangoedad; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_rangoedad (
    id integer DEFAULT nextval('sivel2_gen_rangoedad_id_seq'::regclass) NOT NULL,
    nombre character varying(20) COLLATE public.es_co_utf_8 NOT NULL,
    rango character varying(20) NOT NULL,
    limiteinferior integer DEFAULT 0 NOT NULL,
    limitesuperior integer DEFAULT 0 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT rangoedad_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_regimensalud; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_regimensalud (
    id integer DEFAULT nextval('regimensalud_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT '2013-05-13'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT regimensalud_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_region_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_region; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_region (
    id integer DEFAULT nextval('sivel2_gen_region_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT region_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_sectorsocial_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_sectorsocial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_sectorsocial; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_sectorsocial (
    id integer DEFAULT nextval('sivel2_gen_sectorsocial_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT sectorsocial_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_supracategoria_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_supracategoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_supracategoria; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_supracategoria (
    codigo integer,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    id_tviolencia character varying(1) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    id integer DEFAULT nextval('sivel2_gen_supracategoria_id_seq'::regclass) NOT NULL,
    CONSTRAINT supracategoria_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_gen_tviolencia; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_tviolencia (
    id character(1) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    nomcorto character varying(10) NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT tviolencia_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: victima_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE victima_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_victima; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_victima (
    id_persona integer NOT NULL,
    id_caso integer NOT NULL,
    hijos integer,
    id_profesion integer DEFAULT 22 NOT NULL,
    id_rangoedad integer DEFAULT 6 NOT NULL,
    id_filiacion integer DEFAULT 10 NOT NULL,
    id_sectorsocial integer DEFAULT 15 NOT NULL,
    id_organizacion integer DEFAULT 16 NOT NULL,
    id_vinculoestado integer DEFAULT 38 NOT NULL,
    organizacionarmada integer DEFAULT 35 NOT NULL,
    anotaciones character varying(1000),
    id_etnia integer DEFAULT 1,
    id_iglesia integer DEFAULT 1,
    orientacionsexual character(1) DEFAULT 'H'::bpchar NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id integer DEFAULT nextval('victima_seq'::regclass) NOT NULL,
    CONSTRAINT victima_hijos_check CHECK (((hijos IS NULL) OR ((hijos >= 0) AND (hijos <= 100)))),
    CONSTRAINT victima_orientacionsexual_check CHECK (((((((orientacionsexual = 'L'::bpchar) OR (orientacionsexual = 'G'::bpchar)) OR (orientacionsexual = 'B'::bpchar)) OR (orientacionsexual = 'T'::bpchar)) OR (orientacionsexual = 'I'::bpchar)) OR (orientacionsexual = 'H'::bpchar)))
);


--
-- Name: sivel2_gen_victimacolectiva; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_victimacolectiva (
    id_grupoper integer NOT NULL,
    id_caso integer NOT NULL,
    personasaprox integer,
    organizacionarmada integer DEFAULT 35,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_gen_vinculoestado_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_gen_vinculoestado_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_gen_vinculoestado; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_gen_vinculoestado (
    id integer DEFAULT nextval('sivel2_gen_vinculoestado_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT vinculoestado_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_acreditacion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_acreditacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_acreditacion; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_acreditacion (
    id integer DEFAULT nextval('sivel2_sjr_acreditacion_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT '2013-05-24'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT acreditacion_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_actosjr; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_actosjr (
    fecha date NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_acto integer NOT NULL,
    desplazamiento_id integer
);


--
-- Name: sivel2_sjr_actualizacionbase; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_actualizacionbase (
    id character varying(10) NOT NULL,
    fecha date NOT NULL,
    descripcion character varying(500) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_aslegal_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_aslegal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_aslegal; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_aslegal (
    id integer DEFAULT nextval('sivel2_sjr_aslegal_id_seq'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT aslegal_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_aslegal_respuesta; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_aslegal_respuesta (
    id_respuesta integer NOT NULL,
    id_aslegal integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_ayudaestado_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_ayudaestado_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_ayudaestado; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_ayudaestado (
    id integer DEFAULT nextval('sivel2_sjr_ayudaestado_id_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT ayudaestado_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_ayudaestado_derecho; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_ayudaestado_derecho (
    ayudaestado_id integer,
    derecho_id integer
);


--
-- Name: sivel2_sjr_ayudaestado_respuesta; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_ayudaestado_respuesta (
    id_respuesta integer NOT NULL,
    id_ayudaestado integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_ayudasjr_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_ayudasjr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_ayudasjr; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_ayudasjr (
    id integer DEFAULT nextval('sivel2_sjr_ayudasjr_id_seq'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT ayudasjr_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_ayudasjr_derecho; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_ayudasjr_derecho (
    ayudasjr_id integer,
    derecho_id integer
);


--
-- Name: sivel2_sjr_ayudasjr_respuesta; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_ayudasjr_respuesta (
    id_ayudasjr integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_respuesta integer NOT NULL
);


--
-- Name: sivel2_sjr_clasifdesp_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_clasifdesp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_clasifdesp; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_clasifdesp (
    id integer DEFAULT nextval('sivel2_sjr_clasifdesp_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT '2013-05-24'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT clasifdesp_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_comosupo; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_comosupo (
    id integer NOT NULL,
    nombre character varying(500) NOT NULL,
    observaciones character varying(5000),
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_comosupo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_comosupo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_comosupo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sivel2_sjr_comosupo_id_seq OWNED BY sivel2_sjr_comosupo.id;


--
-- Name: sivel2_sjr_declaroante_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_declaroante_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_declaroante; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_declaroante (
    id integer DEFAULT nextval('sivel2_sjr_declaroante_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT '2013-05-24'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT declaroante_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_derecho_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_derecho_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_derecho; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_derecho (
    id integer DEFAULT nextval('sivel2_sjr_derecho_id_seq'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    fechacreacion date DEFAULT '2013-06-12'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT derecho_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_derecho_respuesta; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_derecho_respuesta (
    id_respuesta integer NOT NULL,
    id_derecho integer DEFAULT 9 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_desplazamiento; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_desplazamiento (
    id_caso integer NOT NULL,
    fechaexpulsion date NOT NULL,
    id_expulsion integer NOT NULL,
    fechallegada date NOT NULL,
    id_llegada integer NOT NULL,
    id_clasifdesp integer DEFAULT 0 NOT NULL,
    id_tipodesp integer DEFAULT 0 NOT NULL,
    descripcion character varying(5000),
    otrosdatos character varying(1000),
    declaro character(1),
    hechosdeclarados character varying(5000),
    fechadeclaracion date,
    departamentodecl integer,
    municipiodecl integer,
    id_declaroante integer DEFAULT 0,
    id_inclusion integer DEFAULT 0,
    id_acreditacion integer DEFAULT 0,
    retornado boolean,
    reubicado boolean,
    connacionalretorno boolean,
    acompestado boolean,
    connacionaldeportado boolean,
    oficioantes character varying(5000),
    id_modalidadtierra integer DEFAULT 0,
    materialesperdidos character varying(5000),
    inmaterialesperdidos character varying(5000),
    protegiorupta boolean,
    documentostierra character varying(5000),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    paisdecl integer,
    id integer DEFAULT nextval('desplazamiento_seq'::regclass) NOT NULL,
    CONSTRAINT desplazamiento_declaro_check CHECK ((((declaro = 'S'::bpchar) OR (declaro = 'N'::bpchar)) OR (declaro = 'R'::bpchar)))
);


--
-- Name: sivel2_sjr_etiqueta_usuario; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_etiqueta_usuario (
    id integer NOT NULL,
    etiqueta_id integer,
    usuario_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_etiqueta_usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_etiqueta_usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_etiqueta_usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sivel2_sjr_etiqueta_usuario_id_seq OWNED BY sivel2_sjr_etiqueta_usuario.id;


--
-- Name: sivel2_sjr_idioma_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_idioma_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_idioma; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_idioma (
    id integer DEFAULT nextval('sivel2_sjr_idioma_id_seq'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    fechacreacion date DEFAULT '2014-02-14'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT idioma_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_inclusion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_inclusion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_inclusion; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_inclusion (
    id integer DEFAULT nextval('sivel2_sjr_inclusion_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT '2013-05-24'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT inclusion_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_instanciader; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_instanciader (
    id integer DEFAULT nextval('instanciader_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT '2013-06-12'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT instanciader_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_mecanismoder; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_mecanismoder (
    id integer DEFAULT nextval('mecanismoder_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT '2013-06-12'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT mecanismoder_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_modalidadtierra_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_modalidadtierra_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_modalidadtierra; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_modalidadtierra (
    id integer DEFAULT nextval('sivel2_sjr_modalidadtierra_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT '2013-05-24'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT modalidadtierra_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_motivoconsulta; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_motivoconsulta (
    id integer DEFAULT nextval('motivoconsulta_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT '2013-05-13'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT motivoconsulta_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_motivosjr_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_motivosjr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_motivosjr; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_motivosjr (
    id integer DEFAULT nextval('sivel2_sjr_motivosjr_id_seq'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    fechacreacion date DEFAULT '2013-06-16'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT motivosjr_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_motivosjr_derecho; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_motivosjr_derecho (
    motivosjr_id integer,
    derecho_id integer
);


--
-- Name: sivel2_sjr_motivosjr_respuesta; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_motivosjr_respuesta (
    id_respuesta integer NOT NULL,
    id_motivosjr integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_personadesea_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_personadesea_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_personadesea; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_personadesea (
    id integer DEFAULT nextval('sivel2_sjr_personadesea_id_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT '2013-06-17'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT personadesea_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_progestado_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_progestado_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_progestado; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_progestado (
    id integer DEFAULT nextval('sivel2_sjr_progestado_id_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT '2013-06-17'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT progestado_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_progestado_derecho; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_progestado_derecho (
    progestado_id integer,
    derecho_id integer
);


--
-- Name: sivel2_sjr_progestado_respuesta; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_progestado_respuesta (
    id_respuesta integer NOT NULL,
    id_progestado integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sivel2_sjr_proteccion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_proteccion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_proteccion; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_proteccion (
    id integer DEFAULT nextval('sivel2_sjr_proteccion_id_seq'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT proteccion_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_resagresion; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_resagresion (
    id integer DEFAULT nextval('resagresion_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT resagresion_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_rolfamilia_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_rolfamilia_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_rolfamilia; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_rolfamilia (
    id integer DEFAULT nextval('sivel2_sjr_rolfamilia_id_seq'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    fechacreacion date DEFAULT ('now'::text)::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT rolfamilia_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_tipodesp_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sivel2_sjr_tipodesp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sivel2_sjr_tipodesp; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_tipodesp (
    id integer DEFAULT nextval('sivel2_sjr_tipodesp_id_seq'::regclass) NOT NULL,
    nombre character varying(500) COLLATE public.es_co_utf_8 NOT NULL,
    fechacreacion date DEFAULT '2013-05-24'::date NOT NULL,
    fechadeshabilitacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    observaciones character varying(5000),
    CONSTRAINT tipodesp_check CHECK (((fechadeshabilitacion IS NULL) OR (fechadeshabilitacion >= fechacreacion)))
);


--
-- Name: sivel2_sjr_victimasjr; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sivel2_sjr_victimasjr (
    sindocumento boolean,
    id_estadocivil integer DEFAULT 0,
    id_rolfamilia integer DEFAULT 0 NOT NULL,
    cabezafamilia boolean,
    id_maternidad integer DEFAULT 0,
    discapacitado boolean,
    id_actividadoficio integer DEFAULT 0,
    id_escolaridad integer DEFAULT 0,
    asisteescuela boolean,
    tienesisben boolean,
    id_departamento integer,
    id_municipio integer,
    nivelsisben integer,
    id_regimensalud integer DEFAULT 0,
    eps character varying(1000),
    libretamilitar boolean,
    distrito integer,
    progadultomayor boolean,
    fechadesagregacion date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id_victima integer NOT NULL,
    id_pais integer,
    enfermedad character varying(5000),
    ndiscapacidad character varying(100)
);


--
-- Name: vvictimasoundexesp; Type: MATERIALIZED VIEW; Schema: public; Owner: -; Tablespace: 
--

CREATE MATERIALIZED VIEW vvictimasoundexesp AS
 SELECT sivel2_gen_victima.id_caso,
    sip_persona.id AS id_persona,
    (((sip_persona.nombres)::text || ' '::text) || (sip_persona.apellidos)::text) AS nomap,
    ( SELECT array_to_string(array_agg(soundexesp(n.s)), ' '::text) AS array_to_string
           FROM ( SELECT unnest(string_to_array(regexp_replace((((sip_persona.nombres)::text || ' '::text) || (sip_persona.apellidos)::text), '  *'::text, ' '::text), ' '::text)) AS s
                  ORDER BY unnest(string_to_array(regexp_replace((((sip_persona.nombres)::text || ' '::text) || (sip_persona.apellidos)::text), '  *'::text, ' '::text), ' '::text))) n) AS nomsoundexesp
   FROM sip_persona,
    sivel2_gen_victima
  WHERE (sip_persona.id = sivel2_gen_victima.id_persona)
  WITH NO DATA;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_actividad ALTER COLUMN id SET DEFAULT nextval('cor1440_gen_actividad_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_actividad_proyecto ALTER COLUMN id SET DEFAULT nextval('cor1440_gen_actividad_proyecto_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_actividad_rangoedadac ALTER COLUMN id SET DEFAULT nextval('cor1440_gen_actividad_rangoedadac_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_actividadarea ALTER COLUMN id SET DEFAULT nextval('cor1440_gen_actividadarea_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_actividadareas_actividad ALTER COLUMN id SET DEFAULT nextval('cor1440_gen_actividadareas_actividad_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_actividadtipo ALTER COLUMN id SET DEFAULT nextval('cor1440_gen_actividadtipo_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_financiador ALTER COLUMN id SET DEFAULT nextval('cor1440_gen_financiador_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_informe ALTER COLUMN id SET DEFAULT nextval('cor1440_gen_informe_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_proyecto ALTER COLUMN id SET DEFAULT nextval('cor1440_gen_proyecto_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_proyectofinanciero ALTER COLUMN id SET DEFAULT nextval('cor1440_gen_proyectofinanciero_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_rangoedadac ALTER COLUMN id SET DEFAULT nextval('cor1440_gen_rangoedadac_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY refugio ALTER COLUMN id SET DEFAULT nextval('refugio_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_anexo ALTER COLUMN id SET DEFAULT nextval('sip_anexo_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_pais ALTER COLUMN id SET DEFAULT nextval('sip_pais_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_tdocumento ALTER COLUMN id SET DEFAULT nextval('sip_tdocumento_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_comosupo ALTER COLUMN id SET DEFAULT nextval('sivel2_sjr_comosupo_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_etiqueta_usuario ALTER COLUMN id SET DEFAULT nextval('sivel2_sjr_etiqueta_usuario_id_seq'::regclass);


--
-- Name: actividad_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cor1440_gen_actividad
    ADD CONSTRAINT actividad_pkey PRIMARY KEY (id);


--
-- Name: actividad_rangoedadac_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cor1440_gen_actividad_rangoedadac
    ADD CONSTRAINT actividad_rangoedadac_pkey PRIMARY KEY (id);


--
-- Name: actividadarea_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cor1440_gen_actividadarea
    ADD CONSTRAINT actividadarea_pkey PRIMARY KEY (id);


--
-- Name: actividadareas_actividad_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cor1440_gen_actividadareas_actividad
    ADD CONSTRAINT actividadareas_actividad_pkey PRIMARY KEY (id);


--
-- Name: actividadoficio_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_actividadoficio
    ADD CONSTRAINT actividadoficio_pkey PRIMARY KEY (id);


--
-- Name: acto_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_acto
    ADD CONSTRAINT acto_id_key UNIQUE (id);


--
-- Name: acto_id_presponsable_id_categoria_id_persona_id_caso_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_acto
    ADD CONSTRAINT acto_id_presponsable_id_categoria_id_persona_id_caso_key UNIQUE (id_presponsable, id_categoria, id_persona, id_caso);


--
-- Name: acto_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_acto
    ADD CONSTRAINT acto_pkey PRIMARY KEY (id);


--
-- Name: actocolectivo_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_actocolectivo
    ADD CONSTRAINT actocolectivo_pkey PRIMARY KEY (id_presponsable, id_categoria, id_grupoper, id_caso);


--
-- Name: actosjr_id_acto_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_actosjr
    ADD CONSTRAINT actosjr_id_acto_key UNIQUE (id_acto);


--
-- Name: actosjr_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_actosjr
    ADD CONSTRAINT actosjr_pkey PRIMARY KEY (id_acto);


--
-- Name: actualizacionbase_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_actualizacionbase
    ADD CONSTRAINT actualizacionbase_pkey PRIMARY KEY (id);


--
-- Name: anexo_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_anexo_caso
    ADD CONSTRAINT anexo_pkey PRIMARY KEY (id);


--
-- Name: anexoactividad_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_anexo
    ADD CONSTRAINT anexoactividad_pkey PRIMARY KEY (id);


--
-- Name: antecedente_caso_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_antecedente_caso
    ADD CONSTRAINT antecedente_caso_pkey PRIMARY KEY (id_antecedente, id_caso);


--
-- Name: antecedente_comunidad_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_antecedente_comunidad
    ADD CONSTRAINT antecedente_comunidad_pkey PRIMARY KEY (id_antecedente, id_grupoper, id_caso);


--
-- Name: antecedente_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_antecedente
    ADD CONSTRAINT antecedente_pkey PRIMARY KEY (id);


--
-- Name: antecedente_victima_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_antecedente_victima
    ADD CONSTRAINT antecedente_victima_pkey PRIMARY KEY (id_antecedente, id_persona, id_caso);


--
-- Name: aslegal_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_aslegal
    ADD CONSTRAINT aslegal_pkey PRIMARY KEY (id);


--
-- Name: aslegal_respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_aslegal_respuesta
    ADD CONSTRAINT aslegal_respuesta_pkey PRIMARY KEY (id_respuesta, id_aslegal);


--
-- Name: aspsicosocial_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY aspsicosocial
    ADD CONSTRAINT aspsicosocial_pkey PRIMARY KEY (id);


--
-- Name: aspsicosocial_respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY aspsicosocial_respuesta
    ADD CONSTRAINT aspsicosocial_respuesta_pkey PRIMARY KEY (id_respuesta, id_aspsicosocial);


--
-- Name: ayudaestado_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_ayudaestado
    ADD CONSTRAINT ayudaestado_pkey PRIMARY KEY (id);


--
-- Name: ayudaestado_respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_ayudaestado_respuesta
    ADD CONSTRAINT ayudaestado_respuesta_pkey PRIMARY KEY (id_respuesta, id_ayudaestado);


--
-- Name: ayudasjr_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_ayudasjr
    ADD CONSTRAINT ayudasjr_pkey PRIMARY KEY (id);


--
-- Name: ayudasjr_respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_ayudasjr_respuesta
    ADD CONSTRAINT ayudasjr_respuesta_pkey PRIMARY KEY (id_respuesta, id_ayudasjr);


--
-- Name: caso_categoria_presponsable_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_caso_categoria_presponsable
    ADD CONSTRAINT caso_categoria_presponsable_pkey PRIMARY KEY (id_tviolencia, id_supracategoria, id_categoria, id_caso_presponsable);


--
-- Name: caso_contexto_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_caso_contexto
    ADD CONSTRAINT caso_contexto_pkey PRIMARY KEY (id_caso, id_contexto);


--
-- Name: caso_etiqueta_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_caso_etiqueta
    ADD CONSTRAINT caso_etiqueta_id_key UNIQUE (id);


--
-- Name: caso_etiqueta_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_caso_etiqueta
    ADD CONSTRAINT caso_etiqueta_pkey PRIMARY KEY (id);


--
-- Name: caso_fotra_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_caso_fotra
    ADD CONSTRAINT caso_fotra_pkey PRIMARY KEY (id_caso, id_fotra, fecha);


--
-- Name: caso_frontera_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_caso_frontera
    ADD CONSTRAINT caso_frontera_pkey PRIMARY KEY (id_frontera, id_caso);


--
-- Name: caso_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_caso
    ADD CONSTRAINT caso_pkey PRIMARY KEY (id);


--
-- Name: caso_presponsable_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_caso_presponsable
    ADD CONSTRAINT caso_presponsable_id_key UNIQUE (id);


--
-- Name: caso_presponsable_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_caso_presponsable
    ADD CONSTRAINT caso_presponsable_pkey PRIMARY KEY (id);


--
-- Name: caso_region_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_caso_region
    ADD CONSTRAINT caso_region_pkey PRIMARY KEY (id_region, id_caso);


--
-- Name: caso_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_caso_usuario
    ADD CONSTRAINT caso_usuario_pkey PRIMARY KEY (id_usuario, id_caso);


--
-- Name: casosjr_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_pkey PRIMARY KEY (id_caso);


--
-- Name: categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id);


--
-- Name: clasifdesp_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_clasifdesp
    ADD CONSTRAINT clasifdesp_pkey PRIMARY KEY (id);


--
-- Name: comosupo_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_comosupo
    ADD CONSTRAINT comosupo_pkey PRIMARY KEY (id);


--
-- Name: comunidad_filiacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_comunidad_filiacion
    ADD CONSTRAINT comunidad_filiacion_pkey PRIMARY KEY (id_filiacion, id_grupoper, id_caso);


--
-- Name: comunidad_organizacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_comunidad_organizacion
    ADD CONSTRAINT comunidad_organizacion_pkey PRIMARY KEY (id_organizacion, id_grupoper, id_caso);


--
-- Name: comunidad_profesion_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_comunidad_profesion
    ADD CONSTRAINT comunidad_profesion_pkey PRIMARY KEY (id_profesion, id_grupoper, id_caso);


--
-- Name: comunidad_rangoedad_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_comunidad_rangoedad
    ADD CONSTRAINT comunidad_rangoedad_pkey PRIMARY KEY (id_rangoedad, id_grupoper, id_caso);


--
-- Name: comunidad_sectorsocial_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_comunidad_sectorsocial
    ADD CONSTRAINT comunidad_sectorsocial_pkey PRIMARY KEY (id_sectorsocial, id_grupoper, id_caso);


--
-- Name: comunidad_vinculoestado_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_comunidad_vinculoestado
    ADD CONSTRAINT comunidad_vinculoestado_pkey PRIMARY KEY (id_vinculoestado, id_grupoper, id_caso);


--
-- Name: contexto_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_contexto
    ADD CONSTRAINT contexto_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_actividad_proyecto_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cor1440_gen_actividad_proyecto
    ADD CONSTRAINT cor1440_gen_actividad_proyecto_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_actividad_sip_anexo_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cor1440_gen_actividad_sip_anexo
    ADD CONSTRAINT cor1440_gen_actividad_sip_anexo_id_key UNIQUE (id);


--
-- Name: cor1440_gen_actividad_sip_anexo_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cor1440_gen_actividad_sip_anexo
    ADD CONSTRAINT cor1440_gen_actividad_sip_anexo_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_actividadtipo_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cor1440_gen_actividadtipo
    ADD CONSTRAINT cor1440_gen_actividadtipo_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_financiador_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cor1440_gen_financiador
    ADD CONSTRAINT cor1440_gen_financiador_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_informe_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cor1440_gen_informe
    ADD CONSTRAINT cor1440_gen_informe_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_proyecto_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cor1440_gen_proyecto
    ADD CONSTRAINT cor1440_gen_proyecto_pkey PRIMARY KEY (id);


--
-- Name: cor1440_gen_proyectofinanciero_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cor1440_gen_proyectofinanciero
    ADD CONSTRAINT cor1440_gen_proyectofinanciero_pkey PRIMARY KEY (id);


--
-- Name: declaroante_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_declaroante
    ADD CONSTRAINT declaroante_pkey PRIMARY KEY (id);


--
-- Name: derecho_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_derecho
    ADD CONSTRAINT derecho_pkey PRIMARY KEY (id);


--
-- Name: derecho_respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_derecho_respuesta
    ADD CONSTRAINT derecho_respuesta_pkey PRIMARY KEY (id_respuesta, id_derecho);


--
-- Name: desplazamiento_id_caso_fechaexpulsion_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_id_caso_fechaexpulsion_key UNIQUE (id_caso, fechaexpulsion);


--
-- Name: desplazamiento_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_id_key UNIQUE (id);


--
-- Name: desplazamiento_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_pkey PRIMARY KEY (id);


--
-- Name: emprendimiento_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY emprendimiento
    ADD CONSTRAINT emprendimiento_pkey PRIMARY KEY (id);


--
-- Name: emprendimiento_respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY emprendimiento_respuesta
    ADD CONSTRAINT emprendimiento_respuesta_pkey PRIMARY KEY (id_respuesta, id_emprendimiento);


--
-- Name: escolaridad_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_escolaridad
    ADD CONSTRAINT escolaridad_pkey PRIMARY KEY (id);


--
-- Name: estadocivil_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_estadocivil
    ADD CONSTRAINT estadocivil_pkey PRIMARY KEY (id);


--
-- Name: etiqueta_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_etiqueta
    ADD CONSTRAINT etiqueta_pkey PRIMARY KEY (id);


--
-- Name: etiqueta_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_etiqueta_usuario
    ADD CONSTRAINT etiqueta_usuario_pkey PRIMARY KEY (id);


--
-- Name: etnia_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_etnia
    ADD CONSTRAINT etnia_pkey PRIMARY KEY (id);


--
-- Name: filiacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_filiacion
    ADD CONSTRAINT filiacion_pkey PRIMARY KEY (id);


--
-- Name: fotra_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_fotra
    ADD CONSTRAINT fotra_pkey PRIMARY KEY (id);


--
-- Name: frontera_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_frontera
    ADD CONSTRAINT frontera_pkey PRIMARY KEY (id);


--
-- Name: grupoper_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_grupoper
    ADD CONSTRAINT grupoper_pkey PRIMARY KEY (id);


--
-- Name: idioma_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_idioma
    ADD CONSTRAINT idioma_pkey PRIMARY KEY (id);


--
-- Name: iglesia_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_iglesia
    ADD CONSTRAINT iglesia_pkey PRIMARY KEY (id);


--
-- Name: inclusion_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_inclusion
    ADD CONSTRAINT inclusion_pkey PRIMARY KEY (id);


--
-- Name: instanciader_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_instanciader
    ADD CONSTRAINT instanciader_pkey PRIMARY KEY (id);


--
-- Name: intervalo_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_intervalo
    ADD CONSTRAINT intervalo_pkey PRIMARY KEY (id);


--
-- Name: maternidad_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_maternidad
    ADD CONSTRAINT maternidad_pkey PRIMARY KEY (id);


--
-- Name: mecanismoder_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_mecanismoder
    ADD CONSTRAINT mecanismoder_pkey PRIMARY KEY (id);


--
-- Name: modalidadtierra_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_modalidadtierra
    ADD CONSTRAINT modalidadtierra_pkey PRIMARY KEY (id);


--
-- Name: motivoconsulta_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_motivoconsulta
    ADD CONSTRAINT motivoconsulta_pkey PRIMARY KEY (id);


--
-- Name: motivosjr_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_motivosjr
    ADD CONSTRAINT motivosjr_pkey PRIMARY KEY (id);


--
-- Name: motivosjr_respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_motivosjr_respuesta
    ADD CONSTRAINT motivosjr_respuesta_pkey PRIMARY KEY (id_respuesta, id_motivosjr);


--
-- Name: organizacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_organizacion
    ADD CONSTRAINT organizacion_pkey PRIMARY KEY (id);


--
-- Name: pais_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_pais
    ADD CONSTRAINT pais_pkey PRIMARY KEY (id);


--
-- Name: pconsolidado_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_pconsolidado
    ADD CONSTRAINT pconsolidado_pkey PRIMARY KEY (id);


--
-- Name: persona_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_persona
    ADD CONSTRAINT persona_pkey PRIMARY KEY (id);


--
-- Name: persona_trelacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_persona_trelacion
    ADD CONSTRAINT persona_trelacion_pkey PRIMARY KEY (persona1, persona2, id_trelacion);


--
-- Name: personadesea_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_personadesea
    ADD CONSTRAINT personadesea_pkey PRIMARY KEY (id);


--
-- Name: presponsable_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_presponsable
    ADD CONSTRAINT presponsable_pkey PRIMARY KEY (id);


--
-- Name: profesion_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_profesion
    ADD CONSTRAINT profesion_pkey PRIMARY KEY (id);


--
-- Name: progestado_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_progestado
    ADD CONSTRAINT progestado_pkey PRIMARY KEY (id);


--
-- Name: progestado_respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_progestado_respuesta
    ADD CONSTRAINT progestado_respuesta_pkey PRIMARY KEY (id_respuesta, id_progestado);


--
-- Name: proteccion_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_proteccion
    ADD CONSTRAINT proteccion_pkey PRIMARY KEY (id);


--
-- Name: rangoedad_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_rangoedad
    ADD CONSTRAINT rangoedad_pkey PRIMARY KEY (id);


--
-- Name: rangoedadac_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cor1440_gen_rangoedadac
    ADD CONSTRAINT rangoedadac_pkey PRIMARY KEY (id);


--
-- Name: refugio_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY refugio
    ADD CONSTRAINT refugio_pkey PRIMARY KEY (id);


--
-- Name: regimensalud_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_regimensalud
    ADD CONSTRAINT regimensalud_pkey PRIMARY KEY (id);


--
-- Name: region_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: regionsjr_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_oficina
    ADD CONSTRAINT regionsjr_pkey PRIMARY KEY (id);


--
-- Name: resagresion_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_resagresion
    ADD CONSTRAINT resagresion_pkey PRIMARY KEY (id);


--
-- Name: respuesta_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_respuesta
    ADD CONSTRAINT respuesta_id_key UNIQUE (id);


--
-- Name: respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_respuesta
    ADD CONSTRAINT respuesta_pkey PRIMARY KEY (id);


--
-- Name: rolfamilia_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_rolfamilia
    ADD CONSTRAINT rolfamilia_pkey PRIMARY KEY (id);


--
-- Name: sectorsocial_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_sectorsocial
    ADD CONSTRAINT sectorsocial_pkey PRIMARY KEY (id);


--
-- Name: sip_clase_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_clase
    ADD CONSTRAINT sip_clase_id_key UNIQUE (id);


--
-- Name: sip_clase_id_municipio_id_clalocal_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_clase
    ADD CONSTRAINT sip_clase_id_municipio_id_clalocal_key UNIQUE (id_municipio, id_clalocal);


--
-- Name: sip_clase_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_clase
    ADD CONSTRAINT sip_clase_pkey PRIMARY KEY (id);


--
-- Name: sip_departamento_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_departamento
    ADD CONSTRAINT sip_departamento_id_key UNIQUE (id);


--
-- Name: sip_departamento_id_pais_id_deplocal_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_departamento
    ADD CONSTRAINT sip_departamento_id_pais_id_deplocal_key UNIQUE (id_pais, id_deplocal);


--
-- Name: sip_departamento_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_departamento
    ADD CONSTRAINT sip_departamento_pkey PRIMARY KEY (id);


--
-- Name: sip_fuenteprensa_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_fuenteprensa
    ADD CONSTRAINT sip_fuenteprensa_pkey PRIMARY KEY (id);


--
-- Name: sip_municipio_id_departamento_id_munlocal_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_municipio
    ADD CONSTRAINT sip_municipio_id_departamento_id_munlocal_key UNIQUE (id_departamento, id_munlocal);


--
-- Name: sip_municipio_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_municipio
    ADD CONSTRAINT sip_municipio_id_key UNIQUE (id);


--
-- Name: sip_municipio_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_municipio
    ADD CONSTRAINT sip_municipio_pkey PRIMARY KEY (id);


--
-- Name: sivel2_gen_caso_fuenteprensa_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_caso_fuenteprensa
    ADD CONSTRAINT sivel2_gen_caso_fuenteprensa_pkey PRIMARY KEY (fecha, fuenteprensa_id, id_caso);


--
-- Name: sivel2_gen_supracategoria_id_tviolencia_codigo_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_supracategoria
    ADD CONSTRAINT sivel2_gen_supracategoria_id_tviolencia_codigo_key UNIQUE (id_tviolencia, codigo);


--
-- Name: sivel2_gen_supracategoria_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_supracategoria
    ADD CONSTRAINT sivel2_gen_supracategoria_pkey PRIMARY KEY (id);


--
-- Name: statusmigratorio_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_statusmigratorio
    ADD CONSTRAINT statusmigratorio_pkey PRIMARY KEY (id);


--
-- Name: tclase_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_tclase
    ADD CONSTRAINT tclase_pkey PRIMARY KEY (id);


--
-- Name: tdocumento_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_tdocumento
    ADD CONSTRAINT tdocumento_pkey PRIMARY KEY (id);


--
-- Name: tipodesp_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_tipodesp
    ADD CONSTRAINT tipodesp_pkey PRIMARY KEY (id);


--
-- Name: trelacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_trelacion
    ADD CONSTRAINT trelacion_pkey PRIMARY KEY (id);


--
-- Name: tsitio_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_tsitio
    ADD CONSTRAINT tsitio_pkey PRIMARY KEY (id);


--
-- Name: tviolencia_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_tviolencia
    ADD CONSTRAINT tviolencia_pkey PRIMARY KEY (id);


--
-- Name: ubicacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sip_ubicacion
    ADD CONSTRAINT ubicacion_pkey PRIMARY KEY (id);


--
-- Name: usuario_nusuario_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT usuario_nusuario_key UNIQUE (nusuario);


--
-- Name: usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- Name: victima_id_caso_id_persona_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_victima
    ADD CONSTRAINT victima_id_caso_id_persona_key UNIQUE (id_caso, id_persona);


--
-- Name: victima_id_caso_id_persona_key1; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_victima
    ADD CONSTRAINT victima_id_caso_id_persona_key1 UNIQUE (id_caso, id_persona);


--
-- Name: victima_id_caso_id_persona_key2; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_victima
    ADD CONSTRAINT victima_id_caso_id_persona_key2 UNIQUE (id_caso, id_persona);


--
-- Name: victima_id_caso_id_persona_key3; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_victima
    ADD CONSTRAINT victima_id_caso_id_persona_key3 UNIQUE (id_caso, id_persona);


--
-- Name: victima_id_caso_id_persona_key4; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_victima
    ADD CONSTRAINT victima_id_caso_id_persona_key4 UNIQUE (id_caso, id_persona);


--
-- Name: victima_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_victima
    ADD CONSTRAINT victima_id_key UNIQUE (id);


--
-- Name: victima_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_victima
    ADD CONSTRAINT victima_pkey PRIMARY KEY (id);


--
-- Name: victimacolectiva_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_victimacolectiva
    ADD CONSTRAINT victimacolectiva_pkey PRIMARY KEY (id_grupoper, id_caso);


--
-- Name: victimasjr_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_sjr_victimasjr
    ADD CONSTRAINT victimasjr_pkey PRIMARY KEY (id_victima);


--
-- Name: vinculoestado_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sivel2_gen_vinculoestado
    ADD CONSTRAINT vinculoestado_pkey PRIMARY KEY (id);


--
-- Name: busca_conscaso; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX busca_conscaso ON sivel2_gen_conscaso USING gin (q);


--
-- Name: index_cor1440_gen_actividad_on_usuario_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cor1440_gen_actividad_on_usuario_id ON cor1440_gen_actividad USING btree (usuario_id);


--
-- Name: index_cor1440_gen_actividad_sip_anexo_on_anexo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cor1440_gen_actividad_sip_anexo_on_anexo_id ON cor1440_gen_actividad_sip_anexo USING btree (anexo_id);


--
-- Name: index_sivel2_gen_actividad_on_rangoedadac_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sivel2_gen_actividad_on_rangoedadac_id ON cor1440_gen_actividad USING btree (rangoedadac_id);


--
-- Name: index_sivel2_gen_actividad_rangoedadac_on_actividad_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sivel2_gen_actividad_rangoedadac_on_actividad_id ON cor1440_gen_actividad_rangoedadac USING btree (actividad_id);


--
-- Name: index_sivel2_gen_actividad_rangoedadac_on_rangoedadac_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sivel2_gen_actividad_rangoedadac_on_rangoedadac_id ON cor1440_gen_actividad_rangoedadac USING btree (rangoedadac_id);


--
-- Name: index_sivel2_sjr_casosjr_on_comosupo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sivel2_sjr_casosjr_on_comosupo_id ON sivel2_sjr_casosjr USING btree (comosupo_id);


--
-- Name: index_usuario_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_usuario_on_email ON usuario USING btree (email);


--
-- Name: index_usuario_on_regionsjr_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_usuario_on_regionsjr_id ON usuario USING btree (oficina_id);


--
-- Name: index_usuario_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_usuario_on_reset_password_token ON usuario USING btree (reset_password_token);


--
-- Name: sip_busca_mundep; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX sip_busca_mundep ON sip_mundep USING gin (mundep);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: usuario_nusuario; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX usuario_nusuario ON usuario USING btree (nusuario);


--
-- Name: actividad_regionsjr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_actividad
    ADD CONSTRAINT actividad_regionsjr_id_fkey FOREIGN KEY (oficina_id) REFERENCES sip_oficina(id);


--
-- Name: acto_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_acto
    ADD CONSTRAINT acto_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: acto_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_acto
    ADD CONSTRAINT acto_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES sivel2_gen_categoria(id);


--
-- Name: acto_id_persona_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_acto
    ADD CONSTRAINT acto_id_persona_fkey FOREIGN KEY (id_persona) REFERENCES sip_persona(id);


--
-- Name: acto_id_presponsable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_acto
    ADD CONSTRAINT acto_id_presponsable_fkey FOREIGN KEY (id_presponsable) REFERENCES sivel2_gen_presponsable(id);


--
-- Name: actocolectivo_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_actocolectivo
    ADD CONSTRAINT actocolectivo_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: actocolectivo_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_actocolectivo
    ADD CONSTRAINT actocolectivo_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES sivel2_gen_categoria(id);


--
-- Name: actocolectivo_id_grupoper_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_actocolectivo
    ADD CONSTRAINT actocolectivo_id_grupoper_fkey FOREIGN KEY (id_grupoper) REFERENCES sivel2_gen_grupoper(id);


--
-- Name: actocolectivo_id_grupoper_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_actocolectivo
    ADD CONSTRAINT actocolectivo_id_grupoper_fkey1 FOREIGN KEY (id_grupoper, id_caso) REFERENCES sivel2_gen_victimacolectiva(id_grupoper, id_caso);


--
-- Name: actocolectivo_id_presponsable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_actocolectivo
    ADD CONSTRAINT actocolectivo_id_presponsable_fkey FOREIGN KEY (id_presponsable) REFERENCES sivel2_gen_presponsable(id);


--
-- Name: actosjr_desplazamiento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_actosjr
    ADD CONSTRAINT actosjr_desplazamiento_id_fkey FOREIGN KEY (desplazamiento_id) REFERENCES sivel2_sjr_desplazamiento(id);


--
-- Name: actosjr_id_acto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_actosjr
    ADD CONSTRAINT actosjr_id_acto_fkey FOREIGN KEY (id_acto) REFERENCES sivel2_gen_acto(id);


--
-- Name: anexo_fuenteprensa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_anexo_caso
    ADD CONSTRAINT anexo_fuenteprensa_id_fkey FOREIGN KEY (fuenteprensa_id) REFERENCES sip_fuenteprensa(id);


--
-- Name: anexo_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_anexo_caso
    ADD CONSTRAINT anexo_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: anexo_id_fotra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_anexo_caso
    ADD CONSTRAINT anexo_id_fotra_fkey FOREIGN KEY (id_fotra) REFERENCES sivel2_gen_fotra(id);


--
-- Name: antecedente_caso_id_antecedente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_antecedente_caso
    ADD CONSTRAINT antecedente_caso_id_antecedente_fkey FOREIGN KEY (id_antecedente) REFERENCES sivel2_gen_antecedente(id);


--
-- Name: antecedente_caso_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_antecedente_caso
    ADD CONSTRAINT antecedente_caso_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: antecedente_comunidad_id_antecedente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_antecedente_comunidad
    ADD CONSTRAINT antecedente_comunidad_id_antecedente_fkey FOREIGN KEY (id_antecedente) REFERENCES sivel2_gen_antecedente(id);


--
-- Name: antecedente_comunidad_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_antecedente_comunidad
    ADD CONSTRAINT antecedente_comunidad_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: antecedente_comunidad_id_grupoper_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_antecedente_comunidad
    ADD CONSTRAINT antecedente_comunidad_id_grupoper_fkey FOREIGN KEY (id_grupoper) REFERENCES sivel2_gen_grupoper(id);


--
-- Name: antecedente_comunidad_id_grupoper_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_antecedente_comunidad
    ADD CONSTRAINT antecedente_comunidad_id_grupoper_fkey1 FOREIGN KEY (id_grupoper, id_caso) REFERENCES sivel2_gen_victimacolectiva(id_grupoper, id_caso);


--
-- Name: antecedente_victima_id_antecedente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_antecedente_victima
    ADD CONSTRAINT antecedente_victima_id_antecedente_fkey FOREIGN KEY (id_antecedente) REFERENCES sivel2_gen_antecedente(id);


--
-- Name: antecedente_victima_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_antecedente_victima
    ADD CONSTRAINT antecedente_victima_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: antecedente_victima_id_persona_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_antecedente_victima
    ADD CONSTRAINT antecedente_victima_id_persona_fkey FOREIGN KEY (id_persona) REFERENCES sip_persona(id);


--
-- Name: antecedente_victima_id_victima_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_antecedente_victima
    ADD CONSTRAINT antecedente_victima_id_victima_fkey FOREIGN KEY (id_victima) REFERENCES sivel2_gen_victima(id);


--
-- Name: aslegal_respuesta_id_aslegal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_aslegal_respuesta
    ADD CONSTRAINT aslegal_respuesta_id_aslegal_fkey FOREIGN KEY (id_aslegal) REFERENCES sivel2_sjr_aslegal(id);


--
-- Name: aslegal_respuesta_id_respuesta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_aslegal_respuesta
    ADD CONSTRAINT aslegal_respuesta_id_respuesta_fkey FOREIGN KEY (id_respuesta) REFERENCES sivel2_sjr_respuesta(id);


--
-- Name: aspsicosocial_respuesta_id_aspsicosocial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY aspsicosocial_respuesta
    ADD CONSTRAINT aspsicosocial_respuesta_id_aspsicosocial_fkey FOREIGN KEY (id_aspsicosocial) REFERENCES aspsicosocial(id);


--
-- Name: aspsicosocial_respuesta_id_respuesta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY aspsicosocial_respuesta
    ADD CONSTRAINT aspsicosocial_respuesta_id_respuesta_fkey FOREIGN KEY (id_respuesta) REFERENCES sivel2_sjr_respuesta(id);


--
-- Name: ayudaestado_respuesta_id_ayudaestado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_ayudaestado_respuesta
    ADD CONSTRAINT ayudaestado_respuesta_id_ayudaestado_fkey FOREIGN KEY (id_ayudaestado) REFERENCES sivel2_sjr_ayudaestado(id);


--
-- Name: ayudaestado_respuesta_id_respuesta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_ayudaestado_respuesta
    ADD CONSTRAINT ayudaestado_respuesta_id_respuesta_fkey FOREIGN KEY (id_respuesta) REFERENCES sivel2_sjr_respuesta(id);


--
-- Name: ayudasjr_respuesta_id_ayudasjr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_ayudasjr_respuesta
    ADD CONSTRAINT ayudasjr_respuesta_id_ayudasjr_fkey FOREIGN KEY (id_ayudasjr) REFERENCES sivel2_sjr_ayudasjr(id);


--
-- Name: ayudasjr_respuesta_id_respuesta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_ayudasjr_respuesta
    ADD CONSTRAINT ayudasjr_respuesta_id_respuesta_fkey FOREIGN KEY (id_respuesta) REFERENCES sivel2_sjr_respuesta(id);


--
-- Name: caso_categoria_presponsable_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_categoria_presponsable
    ADD CONSTRAINT caso_categoria_presponsable_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: caso_categoria_presponsable_id_caso_presponsable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_categoria_presponsable
    ADD CONSTRAINT caso_categoria_presponsable_id_caso_presponsable_fkey FOREIGN KEY (id_caso_presponsable) REFERENCES sivel2_gen_caso_presponsable(id);


--
-- Name: caso_categoria_presponsable_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_categoria_presponsable
    ADD CONSTRAINT caso_categoria_presponsable_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES sivel2_gen_categoria(id);


--
-- Name: caso_categoria_presponsable_id_presponsable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_categoria_presponsable
    ADD CONSTRAINT caso_categoria_presponsable_id_presponsable_fkey FOREIGN KEY (id_presponsable) REFERENCES sivel2_gen_presponsable(id);


--
-- Name: caso_categoria_presponsable_id_tviolencia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_categoria_presponsable
    ADD CONSTRAINT caso_categoria_presponsable_id_tviolencia_fkey FOREIGN KEY (id_tviolencia) REFERENCES sivel2_gen_tviolencia(id);


--
-- Name: caso_contexto_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_contexto
    ADD CONSTRAINT caso_contexto_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: caso_contexto_id_contexto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_contexto
    ADD CONSTRAINT caso_contexto_id_contexto_fkey FOREIGN KEY (id_contexto) REFERENCES sivel2_gen_contexto(id);


--
-- Name: caso_etiqueta_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_etiqueta
    ADD CONSTRAINT caso_etiqueta_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: caso_etiqueta_id_etiqueta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_etiqueta
    ADD CONSTRAINT caso_etiqueta_id_etiqueta_fkey FOREIGN KEY (id_etiqueta) REFERENCES sip_etiqueta(id);


--
-- Name: caso_etiqueta_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_etiqueta
    ADD CONSTRAINT caso_etiqueta_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES usuario(id);


--
-- Name: caso_fotra_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_fotra
    ADD CONSTRAINT caso_fotra_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: caso_fotra_id_fotra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_fotra
    ADD CONSTRAINT caso_fotra_id_fotra_fkey FOREIGN KEY (id_fotra) REFERENCES sivel2_gen_fotra(id);


--
-- Name: caso_frontera_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_frontera
    ADD CONSTRAINT caso_frontera_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: caso_frontera_id_frontera_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_frontera
    ADD CONSTRAINT caso_frontera_id_frontera_fkey FOREIGN KEY (id_frontera) REFERENCES sivel2_gen_frontera(id);


--
-- Name: caso_funcionario_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_usuario
    ADD CONSTRAINT caso_funcionario_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: caso_presponsable_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_presponsable
    ADD CONSTRAINT caso_presponsable_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: caso_presponsable_id_presponsable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_presponsable
    ADD CONSTRAINT caso_presponsable_id_presponsable_fkey FOREIGN KEY (id_presponsable) REFERENCES sivel2_gen_presponsable(id);


--
-- Name: caso_region_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_region
    ADD CONSTRAINT caso_region_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: caso_region_id_region_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_region
    ADD CONSTRAINT caso_region_id_region_fkey FOREIGN KEY (id_region) REFERENCES sivel2_gen_region(id);


--
-- Name: caso_usuario_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_usuario
    ADD CONSTRAINT caso_usuario_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: caso_usuario_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_usuario
    ADD CONSTRAINT caso_usuario_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES usuario(id);


--
-- Name: casosjr_asesor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_asesor_fkey FOREIGN KEY (asesor) REFERENCES usuario(id);


--
-- Name: casosjr_categoriaref_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_categoriaref_fkey FOREIGN KEY (categoriaref) REFERENCES sivel2_gen_categoria(id);


--
-- Name: casosjr_comosupo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_comosupo_id_fkey FOREIGN KEY (comosupo_id) REFERENCES sivel2_sjr_comosupo(id);


--
-- Name: casosjr_contacto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_contacto_fkey FOREIGN KEY (contacto) REFERENCES sip_persona(id);


--
-- Name: casosjr_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: casosjr_id_idioma_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_id_idioma_fkey FOREIGN KEY (id_idioma) REFERENCES sivel2_sjr_idioma(id);


--
-- Name: casosjr_id_llegada_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_id_llegada_fkey FOREIGN KEY (id_llegada) REFERENCES sip_ubicacion(id);


--
-- Name: casosjr_id_proteccion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_id_proteccion_fkey FOREIGN KEY (id_proteccion) REFERENCES sivel2_sjr_proteccion(id);


--
-- Name: casosjr_id_regionsjr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_id_regionsjr_fkey FOREIGN KEY (oficina_id) REFERENCES sip_oficina(id);


--
-- Name: casosjr_id_salida_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_id_salida_fkey FOREIGN KEY (id_salida) REFERENCES sip_ubicacion(id);


--
-- Name: casosjr_id_statusmigratorio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_casosjr
    ADD CONSTRAINT casosjr_id_statusmigratorio_fkey FOREIGN KEY (id_statusmigratorio) REFERENCES sivel2_sjr_statusmigratorio(id);


--
-- Name: categoria_contadaen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_categoria
    ADD CONSTRAINT categoria_contadaen_fkey FOREIGN KEY (contadaen) REFERENCES sivel2_gen_categoria(id);


--
-- Name: clase_id_tclase_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_clase
    ADD CONSTRAINT clase_id_tclase_fkey FOREIGN KEY (id_tclase) REFERENCES sip_tclase(id);


--
-- Name: comunidad_filiacion_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_filiacion
    ADD CONSTRAINT comunidad_filiacion_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: comunidad_filiacion_id_filiacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_filiacion
    ADD CONSTRAINT comunidad_filiacion_id_filiacion_fkey FOREIGN KEY (id_filiacion) REFERENCES sivel2_gen_filiacion(id);


--
-- Name: comunidad_filiacion_id_grupoper_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_filiacion
    ADD CONSTRAINT comunidad_filiacion_id_grupoper_fkey FOREIGN KEY (id_grupoper) REFERENCES sivel2_gen_grupoper(id);


--
-- Name: comunidad_filiacion_id_grupoper_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_filiacion
    ADD CONSTRAINT comunidad_filiacion_id_grupoper_fkey1 FOREIGN KEY (id_grupoper, id_caso) REFERENCES sivel2_gen_victimacolectiva(id_grupoper, id_caso);


--
-- Name: comunidad_organizacion_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_organizacion
    ADD CONSTRAINT comunidad_organizacion_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: comunidad_organizacion_id_grupoper_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_organizacion
    ADD CONSTRAINT comunidad_organizacion_id_grupoper_fkey FOREIGN KEY (id_grupoper) REFERENCES sivel2_gen_grupoper(id);


--
-- Name: comunidad_organizacion_id_grupoper_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_organizacion
    ADD CONSTRAINT comunidad_organizacion_id_grupoper_fkey1 FOREIGN KEY (id_grupoper, id_caso) REFERENCES sivel2_gen_victimacolectiva(id_grupoper, id_caso);


--
-- Name: comunidad_organizacion_id_organizacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_organizacion
    ADD CONSTRAINT comunidad_organizacion_id_organizacion_fkey FOREIGN KEY (id_organizacion) REFERENCES sivel2_gen_organizacion(id);


--
-- Name: comunidad_profesion_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_profesion
    ADD CONSTRAINT comunidad_profesion_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: comunidad_profesion_id_grupoper_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_profesion
    ADD CONSTRAINT comunidad_profesion_id_grupoper_fkey FOREIGN KEY (id_grupoper) REFERENCES sivel2_gen_grupoper(id);


--
-- Name: comunidad_profesion_id_grupoper_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_profesion
    ADD CONSTRAINT comunidad_profesion_id_grupoper_fkey1 FOREIGN KEY (id_grupoper, id_caso) REFERENCES sivel2_gen_victimacolectiva(id_grupoper, id_caso);


--
-- Name: comunidad_profesion_id_profesion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_profesion
    ADD CONSTRAINT comunidad_profesion_id_profesion_fkey FOREIGN KEY (id_profesion) REFERENCES sivel2_gen_profesion(id);


--
-- Name: comunidad_rangoedad_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_rangoedad
    ADD CONSTRAINT comunidad_rangoedad_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: comunidad_rangoedad_id_grupoper_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_rangoedad
    ADD CONSTRAINT comunidad_rangoedad_id_grupoper_fkey FOREIGN KEY (id_grupoper) REFERENCES sivel2_gen_grupoper(id);


--
-- Name: comunidad_rangoedad_id_grupoper_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_rangoedad
    ADD CONSTRAINT comunidad_rangoedad_id_grupoper_fkey1 FOREIGN KEY (id_grupoper, id_caso) REFERENCES sivel2_gen_victimacolectiva(id_grupoper, id_caso);


--
-- Name: comunidad_rangoedad_id_rangoedad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_rangoedad
    ADD CONSTRAINT comunidad_rangoedad_id_rangoedad_fkey FOREIGN KEY (id_rangoedad) REFERENCES sivel2_gen_rangoedad(id);


--
-- Name: comunidad_sectorsocial_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_sectorsocial
    ADD CONSTRAINT comunidad_sectorsocial_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: comunidad_sectorsocial_id_grupoper_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_sectorsocial
    ADD CONSTRAINT comunidad_sectorsocial_id_grupoper_fkey FOREIGN KEY (id_grupoper) REFERENCES sivel2_gen_grupoper(id);


--
-- Name: comunidad_sectorsocial_id_grupoper_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_sectorsocial
    ADD CONSTRAINT comunidad_sectorsocial_id_grupoper_fkey1 FOREIGN KEY (id_grupoper, id_caso) REFERENCES sivel2_gen_victimacolectiva(id_grupoper, id_caso);


--
-- Name: comunidad_sectorsocial_id_sector_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_sectorsocial
    ADD CONSTRAINT comunidad_sectorsocial_id_sector_fkey FOREIGN KEY (id_sectorsocial) REFERENCES sivel2_gen_sectorsocial(id);


--
-- Name: comunidad_sectorsocial_id_sectorsocial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_sectorsocial
    ADD CONSTRAINT comunidad_sectorsocial_id_sectorsocial_fkey FOREIGN KEY (id_sectorsocial) REFERENCES sivel2_gen_sectorsocial(id);


--
-- Name: comunidad_vinculoestado_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_vinculoestado
    ADD CONSTRAINT comunidad_vinculoestado_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: comunidad_vinculoestado_id_grupoper_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_vinculoestado
    ADD CONSTRAINT comunidad_vinculoestado_id_grupoper_fkey FOREIGN KEY (id_grupoper) REFERENCES sivel2_gen_grupoper(id);


--
-- Name: comunidad_vinculoestado_id_grupoper_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_vinculoestado
    ADD CONSTRAINT comunidad_vinculoestado_id_grupoper_fkey1 FOREIGN KEY (id_grupoper, id_caso) REFERENCES sivel2_gen_victimacolectiva(id_grupoper, id_caso);


--
-- Name: comunidad_vinculoestado_id_vinculoestado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_comunidad_vinculoestado
    ADD CONSTRAINT comunidad_vinculoestado_id_vinculoestado_fkey FOREIGN KEY (id_vinculoestado) REFERENCES sivel2_gen_vinculoestado(id);


--
-- Name: cor1440_gen_actividad_actividadtipo_actividad_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_actividad_actividadtipo
    ADD CONSTRAINT cor1440_gen_actividad_actividadtipo_actividad_id_fkey FOREIGN KEY (actividad_id) REFERENCES cor1440_gen_actividad(id);


--
-- Name: cor1440_gen_actividad_actividadtipo_actividadtipo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_actividad_actividadtipo
    ADD CONSTRAINT cor1440_gen_actividad_actividadtipo_actividadtipo_id_fkey FOREIGN KEY (actividadtipo_id) REFERENCES cor1440_gen_actividadtipo(id);


--
-- Name: departamento_id_pais_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_departamento
    ADD CONSTRAINT departamento_id_pais_fkey FOREIGN KEY (id_pais) REFERENCES sip_pais(id);


--
-- Name: derecho_respuesta_id_derecho_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_derecho_respuesta
    ADD CONSTRAINT derecho_respuesta_id_derecho_fkey FOREIGN KEY (id_derecho) REFERENCES sivel2_sjr_derecho(id);


--
-- Name: derecho_respuesta_id_respuesta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_derecho_respuesta
    ADD CONSTRAINT derecho_respuesta_id_respuesta_fkey FOREIGN KEY (id_respuesta) REFERENCES sivel2_sjr_respuesta(id);


--
-- Name: desplazamiento_expulsion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_expulsion_fkey FOREIGN KEY (id_expulsion) REFERENCES sip_ubicacion(id);


--
-- Name: desplazamiento_id_expulsion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_id_expulsion_fkey FOREIGN KEY (id_expulsion) REFERENCES sip_ubicacion(id);


--
-- Name: desplazamiento_id_llegada_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_id_llegada_fkey FOREIGN KEY (id_llegada) REFERENCES sip_ubicacion(id);


--
-- Name: desplazamiento_id_tipodesp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_id_tipodesp_fkey FOREIGN KEY (id_tipodesp) REFERENCES sivel2_sjr_tipodesp(id);


--
-- Name: desplazamiento_llegada_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_llegada_fkey FOREIGN KEY (id_llegada) REFERENCES sip_ubicacion(id);


--
-- Name: desplazamiento_paisdecl_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_desplazamiento
    ADD CONSTRAINT desplazamiento_paisdecl_fkey FOREIGN KEY (paisdecl) REFERENCES sip_pais(id);


--
-- Name: emprendimiento_respuesta_id_emprendimiento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY emprendimiento_respuesta
    ADD CONSTRAINT emprendimiento_respuesta_id_emprendimiento_fkey FOREIGN KEY (id_emprendimiento) REFERENCES emprendimiento(id);


--
-- Name: emprendimiento_respuesta_id_respuesta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY emprendimiento_respuesta
    ADD CONSTRAINT emprendimiento_respuesta_id_respuesta_fkey FOREIGN KEY (id_respuesta) REFERENCES sivel2_sjr_respuesta(id);


--
-- Name: fk_rails_00fcb50e1e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_motivosjr_derecho
    ADD CONSTRAINT fk_rails_00fcb50e1e FOREIGN KEY (derecho_id) REFERENCES sivel2_sjr_derecho(id);


--
-- Name: fk_rails_0cd09d688c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_financiador_proyectofinanciero
    ADD CONSTRAINT fk_rails_0cd09d688c FOREIGN KEY (financiador_id) REFERENCES cor1440_gen_financiador(id);


--
-- Name: fk_rails_115bca8b2c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_progestado_derecho
    ADD CONSTRAINT fk_rails_115bca8b2c FOREIGN KEY (derecho_id) REFERENCES sivel2_sjr_derecho(id);


--
-- Name: fk_rails_1e1b715428; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_ayudasjr_derecho
    ADD CONSTRAINT fk_rails_1e1b715428 FOREIGN KEY (ayudasjr_id) REFERENCES sivel2_sjr_ayudasjr(id);


--
-- Name: fk_rails_294895347e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_informe
    ADD CONSTRAINT fk_rails_294895347e FOREIGN KEY (filtroproyecto) REFERENCES cor1440_gen_proyecto(id);


--
-- Name: fk_rails_395faa0882; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_actividad_proyecto
    ADD CONSTRAINT fk_rails_395faa0882 FOREIGN KEY (actividad_id) REFERENCES cor1440_gen_actividad(id);


--
-- Name: fk_rails_40cb623d50; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_informe
    ADD CONSTRAINT fk_rails_40cb623d50 FOREIGN KEY (filtroproyectofinanciero) REFERENCES cor1440_gen_proyectofinanciero(id);


--
-- Name: fk_rails_4426fc905e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_actividad
    ADD CONSTRAINT fk_rails_4426fc905e FOREIGN KEY (usuario_id) REFERENCES usuario(id);


--
-- Name: fk_rails_49ec1ae361; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_actividad_sip_anexo
    ADD CONSTRAINT fk_rails_49ec1ae361 FOREIGN KEY (anexo_id) REFERENCES sip_anexo(id);


--
-- Name: fk_rails_524486e06b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_actividad_proyectofinanciero
    ADD CONSTRAINT fk_rails_524486e06b FOREIGN KEY (proyectofinanciero_id) REFERENCES cor1440_gen_proyectofinanciero(id);


--
-- Name: fk_rails_5ff8e2bab4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_ayudasjr_derecho
    ADD CONSTRAINT fk_rails_5ff8e2bab4 FOREIGN KEY (derecho_id) REFERENCES sivel2_sjr_derecho(id);


--
-- Name: fk_rails_69992070a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_ayudaestado_derecho
    ADD CONSTRAINT fk_rails_69992070a3 FOREIGN KEY (ayudaestado_id) REFERENCES sivel2_sjr_ayudaestado(id);


--
-- Name: fk_rails_a8489e0d62; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_actividad_proyectofinanciero
    ADD CONSTRAINT fk_rails_a8489e0d62 FOREIGN KEY (actividad_id) REFERENCES cor1440_gen_actividad(id);


--
-- Name: fk_rails_b0849b6ac6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_ayudaestado_derecho
    ADD CONSTRAINT fk_rails_b0849b6ac6 FOREIGN KEY (derecho_id) REFERENCES sivel2_sjr_derecho(id);


--
-- Name: fk_rails_b909b1844d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_motivosjr_derecho
    ADD CONSTRAINT fk_rails_b909b1844d FOREIGN KEY (motivosjr_id) REFERENCES sivel2_sjr_motivosjr(id);


--
-- Name: fk_rails_c02831dd89; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_informe
    ADD CONSTRAINT fk_rails_c02831dd89 FOREIGN KEY (filtroactividadarea) REFERENCES cor1440_gen_actividadarea(id);


--
-- Name: fk_rails_ca93eb04dc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_financiador_proyectofinanciero
    ADD CONSTRAINT fk_rails_ca93eb04dc FOREIGN KEY (proyectofinanciero_id) REFERENCES cor1440_gen_proyectofinanciero(id);


--
-- Name: fk_rails_cc9d44f9de; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_actividad_sip_anexo
    ADD CONSTRAINT fk_rails_cc9d44f9de FOREIGN KEY (actividad_id) REFERENCES cor1440_gen_actividad(id);


--
-- Name: fk_rails_cf5d592625; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_actividad_proyecto
    ADD CONSTRAINT fk_rails_cf5d592625 FOREIGN KEY (proyecto_id) REFERENCES cor1440_gen_proyecto(id);


--
-- Name: fk_rails_f808034a20; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_progestado_derecho
    ADD CONSTRAINT fk_rails_f808034a20 FOREIGN KEY (progestado_id) REFERENCES sivel2_sjr_progestado(id);


--
-- Name: lf_proyectofinanciero_responsable; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cor1440_gen_proyectofinanciero
    ADD CONSTRAINT lf_proyectofinanciero_responsable FOREIGN KEY (responsable_id) REFERENCES usuario(id);


--
-- Name: motivosjr_respuesta_id_motivosjr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_motivosjr_respuesta
    ADD CONSTRAINT motivosjr_respuesta_id_motivosjr_fkey FOREIGN KEY (id_motivosjr) REFERENCES sivel2_sjr_motivosjr(id);


--
-- Name: motivosjr_respuesta_id_respuesta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_motivosjr_respuesta
    ADD CONSTRAINT motivosjr_respuesta_id_respuesta_fkey FOREIGN KEY (id_respuesta) REFERENCES sivel2_sjr_respuesta(id);


--
-- Name: persona_id_pais_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_persona
    ADD CONSTRAINT persona_id_pais_fkey FOREIGN KEY (id_pais) REFERENCES sip_pais(id);


--
-- Name: persona_nacionalde_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_persona
    ADD CONSTRAINT persona_nacionalde_fkey FOREIGN KEY (nacionalde) REFERENCES sip_pais(id);


--
-- Name: persona_tdocumento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_persona
    ADD CONSTRAINT persona_tdocumento_id_fkey FOREIGN KEY (tdocumento_id) REFERENCES sip_tdocumento(id);


--
-- Name: persona_trelacion_id_trelacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_persona_trelacion
    ADD CONSTRAINT persona_trelacion_id_trelacion_fkey FOREIGN KEY (id_trelacion) REFERENCES sip_trelacion(id);


--
-- Name: persona_trelacion_persona1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_persona_trelacion
    ADD CONSTRAINT persona_trelacion_persona1_fkey FOREIGN KEY (persona1) REFERENCES sip_persona(id);


--
-- Name: persona_trelacion_persona2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_persona_trelacion
    ADD CONSTRAINT persona_trelacion_persona2_fkey FOREIGN KEY (persona2) REFERENCES sip_persona(id);


--
-- Name: presponsable_papa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_presponsable
    ADD CONSTRAINT presponsable_papa_fkey FOREIGN KEY (papa) REFERENCES sivel2_gen_presponsable(id);


--
-- Name: progestado_respuesta_id_progestado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_progestado_respuesta
    ADD CONSTRAINT progestado_respuesta_id_progestado_fkey FOREIGN KEY (id_progestado) REFERENCES sivel2_sjr_progestado(id);


--
-- Name: progestado_respuesta_id_respuesta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_progestado_respuesta
    ADD CONSTRAINT progestado_respuesta_id_respuesta_fkey FOREIGN KEY (id_respuesta) REFERENCES sivel2_sjr_respuesta(id);


--
-- Name: respuesta_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_respuesta
    ADD CONSTRAINT respuesta_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_sjr_casosjr(id_caso);


--
-- Name: respuesta_id_personadesea_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_respuesta
    ADD CONSTRAINT respuesta_id_personadesea_fkey FOREIGN KEY (id_personadesea) REFERENCES sivel2_sjr_personadesea(id);


--
-- Name: sip_clase_id_municipio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_clase
    ADD CONSTRAINT sip_clase_id_municipio_fkey FOREIGN KEY (id_municipio) REFERENCES sip_municipio(id);


--
-- Name: sip_municipio_id_departamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_municipio
    ADD CONSTRAINT sip_municipio_id_departamento_fkey FOREIGN KEY (id_departamento) REFERENCES sip_departamento(id);


--
-- Name: sip_persona_id_clase_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_persona
    ADD CONSTRAINT sip_persona_id_clase_fkey FOREIGN KEY (id_clase) REFERENCES sip_clase(id);


--
-- Name: sip_persona_id_departamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_persona
    ADD CONSTRAINT sip_persona_id_departamento_fkey FOREIGN KEY (id_departamento) REFERENCES sip_departamento(id);


--
-- Name: sip_persona_id_municipio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_persona
    ADD CONSTRAINT sip_persona_id_municipio_fkey FOREIGN KEY (id_municipio) REFERENCES sip_municipio(id);


--
-- Name: sip_ubicacion_id_clase_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_ubicacion
    ADD CONSTRAINT sip_ubicacion_id_clase_fkey FOREIGN KEY (id_clase) REFERENCES sip_clase(id);


--
-- Name: sip_ubicacion_id_departamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_ubicacion
    ADD CONSTRAINT sip_ubicacion_id_departamento_fkey FOREIGN KEY (id_departamento) REFERENCES sip_departamento(id);


--
-- Name: sip_ubicacion_id_municipio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_ubicacion
    ADD CONSTRAINT sip_ubicacion_id_municipio_fkey FOREIGN KEY (id_municipio) REFERENCES sip_municipio(id);


--
-- Name: sivel2_gen_caso_fuenteprensa_fuenteprensa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_fuenteprensa
    ADD CONSTRAINT sivel2_gen_caso_fuenteprensa_fuenteprensa_id_fkey FOREIGN KEY (fuenteprensa_id) REFERENCES sip_fuenteprensa(id);


--
-- Name: sivel2_gen_caso_fuenteprensa_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_caso_fuenteprensa
    ADD CONSTRAINT sivel2_gen_caso_fuenteprensa_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: sivel2_gen_categoria_supracategoria_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_categoria
    ADD CONSTRAINT sivel2_gen_categoria_supracategoria_id_fkey FOREIGN KEY (supracategoria_id) REFERENCES sivel2_gen_supracategoria(id);


--
-- Name: supracategoria_id_tviolencia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_supracategoria
    ADD CONSTRAINT supracategoria_id_tviolencia_fkey FOREIGN KEY (id_tviolencia) REFERENCES sivel2_gen_tviolencia(id);


--
-- Name: trelacion_inverso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_trelacion
    ADD CONSTRAINT trelacion_inverso_fkey FOREIGN KEY (inverso) REFERENCES sip_trelacion(id);


--
-- Name: ubicacion_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_ubicacion
    ADD CONSTRAINT ubicacion_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: ubicacion_id_pais_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_ubicacion
    ADD CONSTRAINT ubicacion_id_pais_fkey FOREIGN KEY (id_pais) REFERENCES sip_pais(id);


--
-- Name: ubicacion_id_tsitio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sip_ubicacion
    ADD CONSTRAINT ubicacion_id_tsitio_fkey FOREIGN KEY (id_tsitio) REFERENCES sip_tsitio(id);


--
-- Name: victima_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_antecedente_victima
    ADD CONSTRAINT victima_fkey FOREIGN KEY (id_caso, id_persona) REFERENCES sivel2_gen_victima(id_caso, id_persona);


--
-- Name: victima_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_victima
    ADD CONSTRAINT victima_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: victima_id_etnia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_victima
    ADD CONSTRAINT victima_id_etnia_fkey FOREIGN KEY (id_etnia) REFERENCES sivel2_gen_etnia(id);


--
-- Name: victima_id_iglesia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_victima
    ADD CONSTRAINT victima_id_iglesia_fkey FOREIGN KEY (id_iglesia) REFERENCES sivel2_gen_iglesia(id);


--
-- Name: victima_id_persona_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_victima
    ADD CONSTRAINT victima_id_persona_fkey FOREIGN KEY (id_persona) REFERENCES sip_persona(id);


--
-- Name: victima_id_profesion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_victima
    ADD CONSTRAINT victima_id_profesion_fkey FOREIGN KEY (id_profesion) REFERENCES sivel2_gen_profesion(id);


--
-- Name: victima_id_rangoedad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_victima
    ADD CONSTRAINT victima_id_rangoedad_fkey FOREIGN KEY (id_rangoedad) REFERENCES sivel2_gen_rangoedad(id);


--
-- Name: victima_id_sectorsocial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_victima
    ADD CONSTRAINT victima_id_sectorsocial_fkey FOREIGN KEY (id_sectorsocial) REFERENCES sivel2_gen_sectorsocial(id);


--
-- Name: victima_organizacionarmada_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_victima
    ADD CONSTRAINT victima_organizacionarmada_fkey FOREIGN KEY (organizacionarmada) REFERENCES sivel2_gen_presponsable(id);


--
-- Name: victimacolectiva_id_caso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_victimacolectiva
    ADD CONSTRAINT victimacolectiva_id_caso_fkey FOREIGN KEY (id_caso) REFERENCES sivel2_gen_caso(id);


--
-- Name: victimacolectiva_id_grupoper_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_victimacolectiva
    ADD CONSTRAINT victimacolectiva_id_grupoper_fkey FOREIGN KEY (id_grupoper) REFERENCES sivel2_gen_grupoper(id);


--
-- Name: victimacolectiva_organizacionarmada_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_gen_victimacolectiva
    ADD CONSTRAINT victimacolectiva_organizacionarmada_fkey FOREIGN KEY (organizacionarmada) REFERENCES sivel2_gen_presponsable(id);


--
-- Name: victimasjr_id_actividadoficio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_victimasjr
    ADD CONSTRAINT victimasjr_id_actividadoficio_fkey FOREIGN KEY (id_actividadoficio) REFERENCES sivel2_gen_actividadoficio(id);


--
-- Name: victimasjr_id_escolaridad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_victimasjr
    ADD CONSTRAINT victimasjr_id_escolaridad_fkey FOREIGN KEY (id_escolaridad) REFERENCES sivel2_gen_escolaridad(id);


--
-- Name: victimasjr_id_estadocivil_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_victimasjr
    ADD CONSTRAINT victimasjr_id_estadocivil_fkey FOREIGN KEY (id_estadocivil) REFERENCES sivel2_gen_estadocivil(id);


--
-- Name: victimasjr_id_maternidad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_victimasjr
    ADD CONSTRAINT victimasjr_id_maternidad_fkey FOREIGN KEY (id_maternidad) REFERENCES sivel2_gen_maternidad(id);


--
-- Name: victimasjr_id_pais_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_victimasjr
    ADD CONSTRAINT victimasjr_id_pais_fkey FOREIGN KEY (id_pais) REFERENCES sip_pais(id);


--
-- Name: victimasjr_id_rolfamilia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_victimasjr
    ADD CONSTRAINT victimasjr_id_rolfamilia_fkey FOREIGN KEY (id_rolfamilia) REFERENCES sivel2_sjr_rolfamilia(id);


--
-- Name: victimasjr_id_victima_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sivel2_sjr_victimasjr
    ADD CONSTRAINT victimasjr_id_victima_fkey FOREIGN KEY (id_victima) REFERENCES sivel2_gen_victima(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20131128151014');

INSERT INTO schema_migrations (version) VALUES ('20131204135932');

INSERT INTO schema_migrations (version) VALUES ('20131204140000');

INSERT INTO schema_migrations (version) VALUES ('20131204143718');

INSERT INTO schema_migrations (version) VALUES ('20131204183530');

INSERT INTO schema_migrations (version) VALUES ('20131205233111');

INSERT INTO schema_migrations (version) VALUES ('20131206081531');

INSERT INTO schema_migrations (version) VALUES ('20131210221541');

INSERT INTO schema_migrations (version) VALUES ('20131220103409');

INSERT INTO schema_migrations (version) VALUES ('20131223175141');

INSERT INTO schema_migrations (version) VALUES ('20140117212555');

INSERT INTO schema_migrations (version) VALUES ('20140129151136');

INSERT INTO schema_migrations (version) VALUES ('20140207102709');

INSERT INTO schema_migrations (version) VALUES ('20140207102739');

INSERT INTO schema_migrations (version) VALUES ('20140211162355');

INSERT INTO schema_migrations (version) VALUES ('20140211164659');

INSERT INTO schema_migrations (version) VALUES ('20140211172443');

INSERT INTO schema_migrations (version) VALUES ('20140217100541');

INSERT INTO schema_migrations (version) VALUES ('20140313012209');

INSERT INTO schema_migrations (version) VALUES ('20140317121823');

INSERT INTO schema_migrations (version) VALUES ('20140514142421');

INSERT INTO schema_migrations (version) VALUES ('20140518120059');

INSERT INTO schema_migrations (version) VALUES ('20140527110223');

INSERT INTO schema_migrations (version) VALUES ('20140528043115');

INSERT INTO schema_migrations (version) VALUES ('20140611110441');

INSERT INTO schema_migrations (version) VALUES ('20140611111020');

INSERT INTO schema_migrations (version) VALUES ('20140613044320');

INSERT INTO schema_migrations (version) VALUES ('20140613200951');

INSERT INTO schema_migrations (version) VALUES ('20140620112004');

INSERT INTO schema_migrations (version) VALUES ('20140704035033');

INSERT INTO schema_migrations (version) VALUES ('20140804194616');

INSERT INTO schema_migrations (version) VALUES ('20140804200235');

INSERT INTO schema_migrations (version) VALUES ('20140804202100');

INSERT INTO schema_migrations (version) VALUES ('20140804202101');

INSERT INTO schema_migrations (version) VALUES ('20140804202958');

INSERT INTO schema_migrations (version) VALUES ('20140804210000');

INSERT INTO schema_migrations (version) VALUES ('20140805030341');

INSERT INTO schema_migrations (version) VALUES ('20140814184537');

INSERT INTO schema_migrations (version) VALUES ('20140815111351');

INSERT INTO schema_migrations (version) VALUES ('20140815111352');

INSERT INTO schema_migrations (version) VALUES ('20140815121224');

INSERT INTO schema_migrations (version) VALUES ('20140815123542');

INSERT INTO schema_migrations (version) VALUES ('20140815124157');

INSERT INTO schema_migrations (version) VALUES ('20140815124606');

INSERT INTO schema_migrations (version) VALUES ('20140827142659');

INSERT INTO schema_migrations (version) VALUES ('20140901105741');

INSERT INTO schema_migrations (version) VALUES ('20140901106000');

INSERT INTO schema_migrations (version) VALUES ('20140902101425');

INSERT INTO schema_migrations (version) VALUES ('20140904033941');

INSERT INTO schema_migrations (version) VALUES ('20140904211823');

INSERT INTO schema_migrations (version) VALUES ('20140904213327');

INSERT INTO schema_migrations (version) VALUES ('20140905121420');

INSERT INTO schema_migrations (version) VALUES ('20140909141336');

INSERT INTO schema_migrations (version) VALUES ('20140909165233');

INSERT INTO schema_migrations (version) VALUES ('20140918115412');

INSERT INTO schema_migrations (version) VALUES ('20140922102737');

INSERT INTO schema_migrations (version) VALUES ('20140922110956');

INSERT INTO schema_migrations (version) VALUES ('20141002140242');

INSERT INTO schema_migrations (version) VALUES ('20141111102451');

INSERT INTO schema_migrations (version) VALUES ('20141111203313');

INSERT INTO schema_migrations (version) VALUES ('20141112111129');

INSERT INTO schema_migrations (version) VALUES ('20141126085907');

INSERT INTO schema_migrations (version) VALUES ('20141222174237');

INSERT INTO schema_migrations (version) VALUES ('20141222174247');

INSERT INTO schema_migrations (version) VALUES ('20141222174257');

INSERT INTO schema_migrations (version) VALUES ('20141222174267');

INSERT INTO schema_migrations (version) VALUES ('20141225174739');

INSERT INTO schema_migrations (version) VALUES ('20150213114933');

INSERT INTO schema_migrations (version) VALUES ('20150217185859');

INSERT INTO schema_migrations (version) VALUES ('20150225140336');

INSERT INTO schema_migrations (version) VALUES ('20150313153722');

INSERT INTO schema_migrations (version) VALUES ('20150317084149');

INSERT INTO schema_migrations (version) VALUES ('20150317084737');

INSERT INTO schema_migrations (version) VALUES ('20150317090631');

INSERT INTO schema_migrations (version) VALUES ('20150413000000');

INSERT INTO schema_migrations (version) VALUES ('20150413160156');

INSERT INTO schema_migrations (version) VALUES ('20150413160157');

INSERT INTO schema_migrations (version) VALUES ('20150413160158');

INSERT INTO schema_migrations (version) VALUES ('20150413160159');

INSERT INTO schema_migrations (version) VALUES ('20150416074423');

INSERT INTO schema_migrations (version) VALUES ('20150416090140');

INSERT INTO schema_migrations (version) VALUES ('20150416095646');

INSERT INTO schema_migrations (version) VALUES ('20150416101228');

INSERT INTO schema_migrations (version) VALUES ('20150417071153');

INSERT INTO schema_migrations (version) VALUES ('20150417180000');

INSERT INTO schema_migrations (version) VALUES ('20150417180314');

INSERT INTO schema_migrations (version) VALUES ('20150419000000');

INSERT INTO schema_migrations (version) VALUES ('20150420104520');

INSERT INTO schema_migrations (version) VALUES ('20150420110000');

INSERT INTO schema_migrations (version) VALUES ('20150420125522');

INSERT INTO schema_migrations (version) VALUES ('20150420153835');

INSERT INTO schema_migrations (version) VALUES ('20150420200255');

INSERT INTO schema_migrations (version) VALUES ('20150503120915');

INSERT INTO schema_migrations (version) VALUES ('20150510125926');

INSERT INTO schema_migrations (version) VALUES ('20150513112126');

INSERT INTO schema_migrations (version) VALUES ('20150513130058');

INSERT INTO schema_migrations (version) VALUES ('20150513130510');

INSERT INTO schema_migrations (version) VALUES ('20150513160835');

INSERT INTO schema_migrations (version) VALUES ('20150520115257');

INSERT INTO schema_migrations (version) VALUES ('20150521092657');

INSERT INTO schema_migrations (version) VALUES ('20150521181918');

INSERT INTO schema_migrations (version) VALUES ('20150521191227');

INSERT INTO schema_migrations (version) VALUES ('20150528100944');

INSERT INTO schema_migrations (version) VALUES ('20150602094513');

INSERT INTO schema_migrations (version) VALUES ('20150602095241');

INSERT INTO schema_migrations (version) VALUES ('20150602104342');

INSERT INTO schema_migrations (version) VALUES ('20150609094809');

INSERT INTO schema_migrations (version) VALUES ('20150609094820');

INSERT INTO schema_migrations (version) VALUES ('20150612160810');

INSERT INTO schema_migrations (version) VALUES ('20150612203808');

INSERT INTO schema_migrations (version) VALUES ('20150615024318');

INSERT INTO schema_migrations (version) VALUES ('20150616030659');

INSERT INTO schema_migrations (version) VALUES ('20150616095023');

INSERT INTO schema_migrations (version) VALUES ('20150616100351');

INSERT INTO schema_migrations (version) VALUES ('20150616100551');

INSERT INTO schema_migrations (version) VALUES ('20150624200701');

INSERT INTO schema_migrations (version) VALUES ('20150707164448');

INSERT INTO schema_migrations (version) VALUES ('20150709203137');

INSERT INTO schema_migrations (version) VALUES ('20150710012947');

INSERT INTO schema_migrations (version) VALUES ('20150710114451');

INSERT INTO schema_migrations (version) VALUES ('20150716085420');

INSERT INTO schema_migrations (version) VALUES ('20150716171420');

INSERT INTO schema_migrations (version) VALUES ('20150716192356');

INSERT INTO schema_migrations (version) VALUES ('20150717101243');

INSERT INTO schema_migrations (version) VALUES ('20150717161539');

INSERT INTO schema_migrations (version) VALUES ('20150720115701');

INSERT INTO schema_migrations (version) VALUES ('20150720120236');

INSERT INTO schema_migrations (version) VALUES ('20150723204552');

INSERT INTO schema_migrations (version) VALUES ('20150723233138');

INSERT INTO schema_migrations (version) VALUES ('20150724000152');

INSERT INTO schema_migrations (version) VALUES ('20150724003736');

INSERT INTO schema_migrations (version) VALUES ('20150724024110');

INSERT INTO schema_migrations (version) VALUES ('20150724032940');

