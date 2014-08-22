#include "protheus.ch"     
#define F_NAME        1
#define F_SIZE        2
#define F_DATE        3
#define F_TIME        4
#define F_ATTR        5
//+--------------------------------------------------------------------+ 
//| Rutina | SELFILE  | Autor | FERNANDO CARDEZA  | Fecha | 10.01.2013 | 
//+--------------------------------------------------------------------+ 
//| Descr. | Función para selección de archivos excel.        
//+--------------------------------------------------------------------+ 
//| Uso    | CURSO DE ADVPL                                            | 
//+--------------------------------------------------------------------+ 
USER FUNCTION SELFILEXLS() 
LOCAL cFile		 	 := "" //
LOCAL aDirectory	 := {} //
LOCAL cDirectory 	 := "" //Solo directorio
LOCAL cFullDirectory := "" //Directorio + Archivo
LOCAL ExpC1 	 	 :=	"" //Máscara para filtro (Ej: 'Informes Protheus (*.##R) | *.##R'). 
LOCAL ExpC2 	 	 :=	"" //Título de la Ventana. 
LOCAL ExpN1 		   	   //Número de la máscara estándar ( Ex: 1 p/ *.exe ). 
LOCAL ExpC3		 	 :=	"" //Directorio inicial, si fuera necesario. 
LOCAL ExpL1 		 	   //(.T.) para mostrar el botón “Grabar” y (.F.) para el botón “Abrir”.
LOCAL ExpN2 	 		   //Máscara de bits para seleccionar las opciones de visualización del objeto. 
LOCAL ExpL2 	 	   	   //(.T.) para mostrar el directorio [Servidor] y (.F.) para no mostrar.

ExpC1:="Archivos de Excel|*.XLS"
ExpC2:="Abrir archivo de Excel"
ExpN1:=0
ExpC3:="C:\"
ExpL1:=.F.
ExpN2:= GETF_LOCALHARD + GETF_NETWORKDRIVE
ExpL2:=.T.
 
// Muestra la estructura del directorio y permite la selección de los archivos que se procesarán 

cFullDirectory	:= ALLTRIM  (cGetFile ( ExpC1, ExpC2, ExpN1, ExpC3, (.F.), ExpN2 ))
If !File(cFullDirectory)
   aDatos:={}
   Return (aDatos)
Endif 
aDirectory  	:= Directory(cFullDirectory,"D")
cFile			:= aDirectory[1,1]
cDirectory  	:= SUBSTR(cFullDirectory,1,(Len(cFullDirectory)-Len(cFile)))

aDatos			:= {cDirectory, cFile, cFullDirectory}

RETURN (aDatos)