
--
-- PostgreSQL database dump
--

SET statement_timeout = 0;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: statusmigratorio; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO statusmigratorio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (0, 'SIN INFORMACIÓN', '2014-02-16', NULL, NULL, NULL);
INSERT INTO statusmigratorio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (1, 'MIGRANTE', '2014-02-16', NULL, NULL, NULL);
INSERT INTO statusmigratorio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (2, 'REFUGIADO', '2014-02-16', NULL, NULL, NULL);
INSERT INTO statusmigratorio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (4, 'APÁTRIDA', '2014-02-16', NULL, NULL, NULL);
INSERT INTO statusmigratorio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (5, 'NACIONAL POR NACIMIENTO', '2014-03-10', NULL, NULL, NULL);
INSERT INTO statusmigratorio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (6, 'NACIONAL POR NATURALIZACIÓN', '2014-03-10', NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--


--
-- PostgreSQL database dump
--

SET statement_timeout = 0;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: proteccion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (0, 'SIN INFORMACIÓN', '2014-02-16', NULL, NULL, NULL);
INSERT INTO proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (1, 'SOLICITANTE DE REFUGIO', '2014-02-16', NULL, NULL, NULL);
INSERT INTO proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (2, 'PROTECCIÓN TEMPORAL HUMANITARIA', '2014-02-16', NULL, NULL, NULL);
INSERT INTO proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (3, 'TRATA Y TRÁFICO', '2014-02-16', NULL, NULL, NULL);
INSERT INTO proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (4, 'NO RECONOCIDOS', '2014-02-16', NULL, NULL, NULL);
INSERT INTO proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (5, 'NO ESPECÍFICA', '2014-02-16', NULL, NULL, NULL);
INSERT INTO proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (6, 'PERSONA CON NECESIDAD DE PROTECCIÓN TEMPORAL', '2014-02-16', NULL, NULL, NULL);
INSERT INTO proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (7, 'OTRO', '2014-02-16', NULL, NULL, NULL);
INSERT INTO proteccion (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (8, 'PERSONA EN SITUACIÓN DE REFUGIO', '2014-03-10', NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: idioma; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (0, 'SIN INFORMACIÓN', '2014-02-18', NULL, NULL, NULL);
INSERT INTO idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (1, 'ESPAÑOL', '2014-02-18', NULL, NULL, NULL);
INSERT INTO idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (10, 'OTRO', '2014-02-18', NULL, NULL, NULL);
INSERT INTO idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (2, 'INGLÉS', '2014-02-18', NULL, NULL, NULL);
INSERT INTO idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (3, 'FRANCÉS', '2014-02-18', NULL, NULL, NULL);
INSERT INTO idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (4, 'ARABE', '2014-02-18', NULL, NULL, NULL);
INSERT INTO idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (5, 'ALEMÁN', '2014-02-18', NULL, NULL, NULL);
INSERT INTO idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (6, 'PORTUGUES', '2014-02-18', NULL, NULL, NULL);
INSERT INTO idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (7, 'JAPONES', '2014-02-18', NULL, NULL, NULL);
INSERT INTO idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (8, 'CHINO', '2014-02-18', NULL, NULL, NULL);
INSERT INTO idioma (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (9, 'AFRIKAN', '2014-02-18', NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: emprendimiento; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO emprendimiento (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (0, 'SIN INFORMACIÓN', '2014-02-14', NULL, NULL, NULL);
INSERT INTO emprendimiento (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (1, 'INFORMACIÓN Y CAPACITACIÓN', '2014-02-14', NULL, NULL, '2014-08-04 14:16:21.864164');
INSERT INTO emprendimiento (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (2, 'FORMULACIÓN DE PROYECTO DE EMPRENDIMIENTO', '2014-02-14', NULL, NULL, '2014-08-04 14:16:06.753018');
INSERT INTO emprendimiento (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (4, 'PAGO DE CUOTA EN CASO DE MICROCRÉDITO', '2014-02-14', NULL, NULL, '2014-08-04 14:17:22.171892');
INSERT INTO emprendimiento (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (5, 'INFORMACIÓN SOBRE INICIATIVA DE EMPRENDIMIENTO', '2014-02-14', NULL, NULL, '2014-08-04 14:17:03.670455');
INSERT INTO emprendimiento (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (6, 'SEGUIMIENTO Y EVALUACIÓN DE PROYECTO E INICIATIVA', '2014-02-14', NULL, NULL, '2014-08-04 14:17:41.68388');


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: aspsicosocial; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO aspsicosocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (0, 'SIN INFORMACIÓN', '2014-02-14', NULL, NULL, NULL);
INSERT INTO aspsicosocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (1, 'ATENCIÓN PSICOLÓGICA (INDIVIDUAL, GRUPAL O FAMILIAR)', '2014-02-14', NULL, NULL, NULL);
INSERT INTO aspsicosocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (102, 'PRIMEROS AUXILIOS PSICOLOGICOS', '2014-07-01', NULL, '2014-07-01 15:37:35.991268', '2014-07-01 15:37:35.991268');
INSERT INTO aspsicosocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (2, 'SEGUIMIENTO A - VISITAS', '2014-02-14', NULL, NULL, NULL);
INSERT INTO aspsicosocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (3, 'PARTICIPACIÓN', '2014-02-14', NULL, NULL, NULL);
INSERT INTO aspsicosocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (4, 'ACOMPAÑAMIENTO ESPIRITUAL, FORTALECIMIENTO TEJIDO SOCIAL', '2014-02-14', NULL, NULL, NULL);
INSERT INTO aspsicosocial (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (5, 'REDES DE APOYO', '2014-02-14', NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

