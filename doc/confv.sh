# Variables de configuración

# Las siguientes líneas definen variables de configuración que,
# eventualmente, usted puede quedar cambiar para adaptar mejor estas fuentes
# a sus necesidades --después de modificar este archivo ejecute conf.sh.  

# Note que la sintaxis de este archivo es apropiada para
# ser usada por conf.sh, a continuación de cada variable debe haber
# dos líneas con comentarios.  La primera describe la variable y la segunda
# da una indicación de que hacer si ocurre algún problema.

PROYECTO=docsivelsjr
# Nombre del proyecto
#

PRY_VERSION="2.0prototipo9"
# Versión
#

PRY_DESC="Documentación de SIVeL personalizado para el SJR Colombia"
# Descripción corta
#

FECHA_PROX="20/03/2013"
# Fecha en la que esperamos liberar próxima versión
#

URLSITE="http://sivel.sf.net/1.2/"
# Sitio de desarrollo de este proyecto
#

CVSPROYECTO="sivel.cvs.sourceforge.net:/cvsroot/sivel/doc"
# CVSROOT del proyecto
#


# Variables empleadas en fuentes

# Las siguientes variables serán modificadas por conf.sh (normalmente no las debe editar)

MES_ACT="Marzo de 2014"
# Mes de actualización
#

FECHA_ACT="21/03/2014"
# Fecha de la actualización más reciente
#


# Ubicación y opciones 

CATALOG_DSSSL="/usr/local/share/sgml/catalog"
# Catalogo de hojas DSSSL
# Debe referenciar las de OpenJade y las de DocBook

DOCBOOK_DSSSL="/usr/local/share/sgml/docbook/dsssl/modular/"
# Directorio con las hojas de estilo DSSSL para DocBook
# Instale docbook-dsssl (http://docbook.sourceforge.net/projects/dsssl/)

DOCBOOK_XML_DIR="/usr/local/share/xml/docbook/4.2"
# Vía del DTD de DocBook XML
# Disponible en http://www.docbook.org

DOCBOOK_XSL="/usr/local/share/xsl/docbook/"
# Directorio con hojas de estilo XSL para DocBook
# Instale docbook-xsl (http://docbook.sourceforge.net/projects/xsl/index.html)

PAPEL="letter"
# Tamaño de papel, puede ser a4 o letter o alguno de los aceptados por gs
# 

REPASA_DOCBOOK_XSL_HTML="docbookrep_html.xsl"
# Ruta de hojas XSLT de repasa para convertir de DocBook a HTML
# 

SGML_XML="/usr/local/share/sgml/docbook/dsssl/modular//dtds/decls/xml.dcl"
# Declaración SGML de un documento XML
# Disponible junto con Docbook-DSSSL



# Métodos

ACT_PROC="act-scp"
# Regla para actualizar sitio de publicación
# Las que hay por defecto son act-scp y act-ncftpput

HTML_PROC="dbrep_html_xsltproc"
# Regla para generar HTML
# Las que están por defecto son: dbrep_html_xsltproc para generar en varios HTML con XSLTPROC, dbrep_html_jade para generar en varias páginas con Jade

PS_PROC="dbrep_ps_jade"
# Regla para generar PostScript
# Las que están por defecto son: dbrep_html_xsltproc para generar en varios HTML con XSLTPROC, dbrep_html_jade para generar en varias páginas con Jade

PDF_PROC="dbrep_pdf_ps"
# Regla para generar PDF
# Las que hay por defecto es dbrep_pdf_ps que genera PDF a  partir de PostScript



# Programas

AWK="/usr/bin/awk"
# Interprete POSIX Awk.  Empleado para transformar textos.
# Herramienta típica en sistemas Unix.

COLLATEINDEX="/usr/local/share/sgml/docbook/dsssl/modular/bin/collateindex.pl"
# Programa auxiliar de DocBook para generar indices
#

CONVERT="/usr/local/bin/convert"
# Programa para convertir imagenes de un formato a otro
# Hace parte del proyecto imagemagick http://www.imagemagick.org/

CP="/bin/cp"
# Para copiar archivos
# Herramienta típica en sistemas Unix.

CVS="/usr/bin/cvs"
# Para control de versiones
# Sugerido http://www.opencvs.org

DOT=""
# Convierte grafo en formato dotty a gráfica
# Hace parte del paquete graphviz http://graphviz.org

DVIPS="/usr/local/bin/dvips"
# Conversor de DVI a PostScript dvips
# 

ED="/bin/ed"
# Line oriented text editor.  Empleado para transformar textos.
# Herramienta típica en sistemas Unix.

FIG2DEV="/usr/local/bin/fig2dev"
# Convierte del formato de Xfig a gráfica
# Hace parte del paquete transfig

FIND="/usr/bin/find"
# Para ubicar archivos
# Herramienta típica en sistemas Unix.

GZIP="/usr/bin/gzip"
# Compresor.
# Herramienta típica en sistemas Unix.

ISPELL="/usr/local/bin/ispell"
# Corrector ortográfico internacional.
# http://fmg-www.cs.ucla.edu/fmg-members/geoff/ispell.html

JADE="/usr/local/bin/openjade"
# Motor para procesar hojas de estilo DSSSL
# Instale jade o openjade (http://openjade.sourceforge.net)

JADETEX="/usr/local/bin/jadetex"
# Para procesar TeX producido por Jade y generar DVI
# Instale jadetex (fuentes disponibles en http://openjade.sourceforge.net)

MAKE="/usr/bin/make"
# Ejecuta comandos requeridos
# Herramienta estándar en sistemas Unix

MKDIR="/bin/mkdir"
# Crea directorios
# Herramienta estándar en sistemas Unix

MV="/bin/mv"
# Mueve/renombra archivos
# Herramienta estándar en sistemas Unix

NCFTPPUT=""
# Programa para transferir archivos desde línea de comandos usando el protocolo FTP
# Es una herramienta del proyecto ncftp cliente http://www.ncftpd.com/

PDFJADETEX="/usr/local/bin/pdfjadetex"
# Para procesar TeX producido por Jade y generar PDF
# Instale jade o openjade (http://openjade.sourceforge.net)

PERL="/usr/bin/perl"
# Interprete del lenguaje Perl.
# Herramienta típica en sistemas Unix.  http://www.perl.org

PS2PDF="/usr/local/bin/ps2pdf"
# Conversor de PostScript a PDF
# 

RM="/bin/rm"
# Para eliminar archivos
# Herramienta típica en sistemas Unix.

RECODE="/usr/local/bin/recode"
# Para convertir entre diversas codificaciones
# En OpenBSD incluida en el paquete recode

SCP="/usr/bin/scp"
# Programa para transferir archivos desde la línea de comandos usando SSH
# Es una herramienta del proyecto ssh  http://www.openssh.org

SED="/usr/bin/sed"
# Stream Editor.  Empleado para transformar textos.
# Herramienta típica en sistemas Unix. 

TAR="/bin/tar"
# Empaquetador de archivos tar.
# Herramienta típica en sistemas Unix.
   
TIDY=""
# Validador de HTML.
# Sitio de desarrollo: http://www.w3.org/People/Raggett/tidy/

TOUCH="/usr/bin/touch"
# touch
# Herramienta típica en sistemas Unix. 

W3M="/usr/bin/lynx"
# Navegador de web en texto.
# http://www.w3m.org

W3M_OPT="-nolist"
# Opciones para visualizador HTML como texto
#

XMLLINT="/usr/local/bin/xmllint"
# Validador de XML
# xmllint está disponible junto con xsltproc en http://xmlsoft.org/XSLT/ 

XSLTPROC="/usr/local/bin/xsltproc"
# Procesador de XSL xsltproc
# Disponible en http://xmlsoft.org/XSLT/ 

ZIP="/usr/local/bin/zip"
# Compresor zip.
# Herramienta típica en sistemas Unix.



# Rutas de instalación

INSBIN="/usr/local/bin"
# Directorio de instalación de binarios
#

INSDOC="/usr/local/share/doc/docsivelsjr"
# Directorio para instalación de documentación Postscript y HTML
#

INSDATA="/usr/local/share/docsivelsjr"
# Directorio para instalación de datos del proyecto
#

