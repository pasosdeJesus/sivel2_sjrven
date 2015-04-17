
# EVOLUCION DEL TIEMPO DE RESPUESTA DE SIVeL - SJR Venezuela 2.0a1

Tiempos en segundos.

## ESPECIFICACION DE SERVIDORES

SERVIDOR SJR-1:
* AMD FX-6100 3315MHz, 6 núcleos
* RAM: 8G
* Disco: 2 discos de 1T
* Plataforma: adJ 5.4p1, PostgreSQL 9.3.2, ruby 2.0.0, RoR 4.1.0rc1, unicorn-4.8.2
* Cortafuegos con adJ 5.5 
* Conexión a Internet en Bogotá por Claro 12MB fibra óptica. 6M de subida.

SERVIDOR SJR-1d:
El mismo SJR-1 pero con
* Plataforma: adJ 5.4p1, PostgreSQL 9.3.2, ruby 2.0.0, RoR 4.1.0rc1, webricks. Modo desarrollo

SERVIDOR SJR-55:
El mismo SJR-1 pero con
* Plataforma: adJ 5.5, PostgreSQL 9.3.5, ruby 2.1.0, RoR 4.1.6, unicorn 4.8.3

SERVIDOR SJR-55d:
El mismo SJR-55 pero con
* Plataforma: adJ 5.5, PostgreSQL 9.3.5, ruby 2.1.0, RoR 4.1.6, webricks modo desarrollo

SERVIDOR SJR-552b2d:
El mismo SJR-55 pero con
* Plataforma: adJ 5.5, PostgreSQL 9.3.5, ruby 2.1.0, RoR 4.2.0.beta2, webricks modo desarrollo

SERVIDOR SJR-552b2d:
El mismo SJR-55 pero con
* Plataforma: adJ 5.5, PostgreSQL 9.3.5, ruby 2.1.0, RoR 4.2.0.beta2, unicorn 4.8.3

SERVIDOR SJR-56:
El mismo SJR-1 pero con
* Plataforma: adJ 5.6, PostgreSQL 9.4.1, ruby 2.2.2, RoR 4.2.1, unicorn 4.8.3



## ESPECIFICACION DE CLIENTES

CLIENTE V-1:
* AMD E-450. 1647.97 MHz
* RAM: 4G
* Disco: 500G
* Plataforma: adJ 5.6, chrome 32
* Conexión a Internet por UNE Inalámbrico 2MB

CLIENTE W-1:
* AMD Athlon 64 X2 Dual Core 5600+. 2813Mhz
* RAM: 1G
* Disco: 1T
* Conexión a servidor directa LAN 100G.
* Plataforma: adJ 5.5, chrome 32

CLIENTE V-2:
* Intel Core i7
* RAM: 4G
* Disco:700GB 
* Plataforma: adJ 5.6, chromium 40.0.2214
* Conexión a Internet por UNE Inalámbrico 2MB



## MEDICIONES

### Fecha: 7.Oct.2014. Servidor: SJR-1. Cliente: V-1
* Autenticar: 1,5
* Lista de actividades: 0,5
* Editar una actividad: 0,7
* Lista de casos: 0,6
* Editar un caso: 3,4
* Agregar etiqueta y guardar: 2,5
* Editar de nuevo: 2,5

### Fecha: 7.Oct.2014. Servidor: SJR-1. Cliente: W-1
* Autenticar: <0,5
* Lista de actividades: <0,5
* Editar una actividad: <0,5
* Lista de casos: <0,5
* Editar un caso: 1,77
* Agregar etiqueta y guardar: 0,7
* Editar de nuevo: 2

### Fecha: 7.Oct.2014. Servidor: SJR-55. Cliente: V-1
* Autenticar: 2,8
* Lista de actividades: 2,5
* Editar una actividad: 0,5
* Lista de casos: 1,5
* Editar un caso: 8,1
* Agregar etiqueta y guardar: 2,1
* Editar de nuevo: 8,1

### Fecha: 7.Oct.2014. Servidor: SJR-55d. Cliente: V-1
* Autenticar: <0,5
* Lista de actividades: 2,5
* Editar una actividad: 2,5
* Lista de casos:  2,5
* Editar un caso: 10,5
* Agregar etiqueta y guardar: 3,5
* Editar de nuevo: 6,5


### Fecha: 10.Oct.2014. Servidor: SJR-552b2d. Cliente: V-1
* Autenticar: 2,5
* Lista de actividades: 1,8
* Editar una actividad: 2
* Lista de casos:  2
* Editar un caso: 4
* Agregar etiqueta y guardar: 8
* Editar de nuevo: 5

### Fecha: 10.Oct.2014. Servidor: SJR-552b2. Cliente: V-1
* Autenticar: 2,5
* Lista de actividades: 0,6
* Editar una actividad: 1,5
* Lista de casos:  2
* Editar un caso: 4,5
* Agregar etiqueta y guardar: 1,5
* Editar de nuevo: 5

### Fecha: 16.Abr.2015. Servidor: SJR-56. Cliente: V-2
* Autenticar: 2,1
* Lista de actividades: 1,3
* Editar una actividad: 1,5
* Lista de casos:  0,7
* Editar un caso: 6,15
* Agregar etiqueta y guardar: 2,7
* Editar de nuevo: 4,38






