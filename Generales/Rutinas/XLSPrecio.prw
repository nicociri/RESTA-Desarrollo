#include "Protheus.ch"
#Include "RWMAKE.CH"
#Include "tbiconn.ch"
///////////////////////////////////////Nota////////////////////////////////////////////////
//Cada vez que se agregue una constante hay que agregar el ejemplo en la funcion List_box()
///////////////////////////////////////////////////////////////////////////////////////////
#DEFINE CAMP1 1 //Proveedor 		 
#DEFINE CAMP2 2 //Tienda 		
#DEFINE CAMP3 3 // 		
#DEFINE CAMP4 4 //
#DEFINE CAMP5 5 // 
#DEFINE CAMP6 6 //
#DEFINE CAMP7 7 //
#DEFINE CAMP8 8 //
#DEFINE CAMP9 9 //
#DEFINE CAMP10 10 // 
#DEFINE CAMP11 11 //
#DEFINE CAMP12 12 //



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บAutor  ณMicrosiga           บFecha ณ  01/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Cardeza Fernando                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Modificaci๓n de listas de precios masiva                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/     
*-------------------------*
User Function COMMOD()   
*-------------------------*

Local aExcel	:={}
Local aCpo 		:={}
Local xAutoItem	:={}
Local aAutoErro 
Local aCabec	:={}  
Local aDados	:={}
Local aImport	:={}
Local lError	:=.F.

U_ListBoxIte() //Lista condiciones necesarias para la ejecusion del programa
U_List_Box() //Lista browser con ejemplo de la estructura que debe tener el excel 

If !(lOk := MsgYesNo("ฟDesea continuar con el proceso?","Advertencia") )
MsgInfo("Proceso cancelado " )
Return
Endif

aExcel:=U_CargaXLS() //genera el array del excel y lo vuelca en la matriz aExcel
For nI := 1 to Len(aExcel) 
	If nI == 1 // cabecera con los campos a ser migrados
		aCabec:=aClone(aExcel[nI])
	Else                          
		aDados:=aClone(aExcel[nI])
		If Len(aCabec) <> Len(aDados)
			If Len(aCabec) > Len(aDados)
				MsgAlert('Existen mแs campos definidos que datos. Ver lํnea: '+AllTrim(str(nI)),'Atenci๓n')
			Else
				MsgAlert('Existen mแs datos que campos definidos. Ver lํnea: '+AllTrim(str(nI)),,'Atenci๓n')
			Endif
			lError := .T.
		Else
			AAdd(aImport,aClone(aDados))
		Endif
	Endif
Next nI     

If !lError
	Processa({|| ModAIA(aCabec,aImport)},"Espere, Actualizando lista... Puede demorar")
Endif

Return

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
// ฑฑบPrograma  ณ Grava    บ Autor ณ Ivaldo Junior      บ Data ณ  27/02/09   บฑฑ
// ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
// ฑฑบDesc.     ณExecuta a importa็ใo dos registros.                         บฑฑ
// ฑฑบ          ณ                                                            บฑฑ
// ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
// ฑฑบUso       ณ AP                                                         บฑฑ
// ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function ModAIA(aCabec,aImport)

Local nX 		:= 0
Local nCpo      := 0                            
Local cCod      := ""
Local nPosCod   := 0
Local nPosLoj   := 0
Local nPosFor   := 0
Local nPosTab   := 0
Local nCantErr  := 0
Local nCantErr1 := 0
Local lsalir    := .F.
Local aNoCpos   := {"AIA_FILIAL"}
Local cDirLog   := "\log\"
Local cSubdir   := "Listas\"
Local PARAMIXB1 := 4
Local dDataDe   := dDataBase
Local dDataAte  := CtoD("01/01/2030")

Private lMsErroAuto 	:= .F.
Private aVector       	:= {}
Private aCab	       	:= {}


ProcRegua(Len(aImport))
//AIA
//AIB
nPosFor:= aScan( aCabec,{|x| allTrim(x) == "AIB_CODFOR" })
nPosLoj:= aScan( aCabec,{|x| allTrim(x) == "AIB_LOJFOR" })
nPosTab:= aScan( aCabec,{|x| allTrim(x) == "AIB_CODTAB" })
nPosCod:= aScan( aCabec,{|x| allTrim(x) == "AIB_CODPRO" })


For nX:=1 To Len(aImport)
	IncProc("Importaci๓n: Insertando registro "+AllTrim( Str(nX) )+" de "+AllTrim( Str(Len(aImport)) ))

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "COM" TABLES "AIA","AIB"

Begin Transaction
	aVector  := {}
	acab	 := {}                                                                                                         
 	DbSelectArea("AIA")
 	DbSetOrder(1)//AIA_FILIAL+AIA_CODFOR+AIA_LOJFOR+AIA_CODTAB         
 	DbSelectArea("AIB")
 	DbSetOrder(2)//AIB_FILIAL+AIB_CODFOR+AIB_LOJFOR+AIB_CODTAB+AIB_CODPRO  

	If nPosFor*nPosLoj*nPosCod*nPosTab > 0 .And. DbSeek( xFilial("AIB")+aImport[nX][nPosFor]+aImport[nX][nPosLoj]+aImport[nX][nPosTab])//+aImport[nX][nPosCod])
	    
	    For nCpo := 1 To Len(aCabec)
				Aadd(aVector,{Alltrim(aCabec[nCpo]),valorCpo(aCabec[nCpo],aImport[nX][nCpo]),Nil})
		Next nCpo
	    
	If Len(aCab)==0
		Aadd(aCab,{"AIA_FILIAL",valorCpo("AIB_FILIAL",xFilial("AIA"))	   ,Nil})
		Aadd(aCab,{"AIA_CODFOR",valorCpo("AIB_CODFOR",aImport[nX][nPosFor]),Nil})
		Aadd(aCab,{"AIA_LOJFOR",valorCpo("AIB_LOJFOR",aImport[nX][nPosLoj]),Nil})
		Aadd(aCab,{"AIA_CODTAB",valorCpo("AIB_CODTAB",aImport[nX][nPosTab]),Nil})
		Aadd(aCab,{"AIA_DESCRI","TABLA DE PRECIO GENERADA"				   ,Nil})	
		Aadd(aCab,{"AIA_DATDE" ,dDataDe									   ,Nil})	
		Aadd(aCab,{"AIA_DATATE",dDataAte								   ,Nil})	
	EndIf				
		
	PARAMIXB2 := aClone(aCab)		
	PARAMIXB3 := aClone(aVector)                                      
	
	MSExecAuto({|x,y,z| coma010(x,y,z)},5,PARAMIXB2,PARAMIXB3) //Borrado del item 	
	MSExecAuto({|x,y,z| coma010(x,y,z)},PARAMIXB1,PARAMIXB2,PARAMIXB3)// agregado del item				
								
		If lMsErroAuto
			ProcLogAtu("ERRO",'Atenci๓n',"Error en la modificacion de Clientes")
			If !ExistDir(cDirLog)		
				MakeDir(cDirLog)
			EndIf
			If !ExistDir(cDirLog+cSubdir)		
				MakeDir(cDirLog+cSubdir)
			EndIf
			MOSTRAERRO(cDirLog+cSubdir)
			lMsErroAuto := .F.
			DisarmTransaction()
			nCantErr += 1
		EndIf	
	Else                
	nCantErr1 += 1
	EndIf	

End Transaction
//RESET ENVIRONMENT	
	If lsalir
		Exit
	Endif
Next

If nCantErr > 0 .or. nCantErr1 > 0
	If nCantErr > 0
		MsgAlert("Fin del Proceso. Registros con errores: "+str(nCantErr),'Atenci๓n')
    endif
    If nCantErr1 > 0
    	MsgAlert("Fin del proceso. Registros no encontrados: " + str(nCantErr1),'Atenci๓n')
    endif
else
MsgAlert('Proceso finalizado con ้xito','Atenci๓n')
Endif

Return
       

/*/ 
+------------------------------------------------------------------------- 
| Funci๓n | LIST_BOX   | Autor | Cardeza Fernando        |Fecha |        |  
+------------------------------------------------------------------------- 
| Descripci๓n | Programa que muestra la utilizaci๓n de un LISTBOX() con |
|  
| grid.        															| 
+------------------------------------------------------------------------- 
| Uso  | Ventana para muestra de estructura del excel a importar
+------------------------------------------------------------------------- 
/*/ 
#include "protheus.ch"

User Function List_Box() 
Local aVetor := {} 
Local oDlg 
Local oLbx 
Local cTitulo := "Excel para modificaci๓n" 


AADD( aVetor, { "Carแcter de 6","Carแcter de 2","Carแcter de 3","Carแcter de 4","Carแcter de 4","N๚merico","N๚merico","N๚merico","N๚merico","N๚merico","N๚merico","N๚merico" } ) 
AADD( aVetor, { "000332"	   ,"01" 		   , "002" 	  	   ,"0001"	   	   ,"16001010250"  , "10,00"  , "06,67"  , "05,61"  , "00,00"  , "00,00"  , "00,00"  , "00,00"   } )
// Monta la pantalla para que el usuario visualice consulta. 

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL

@ 10,10 LISTBOX oLbx FIELDS HEADER "AIB_CODFOR","AIB_LOJFOR","AIB_CODTAB","AIB_ITEM","AIB_CODPRO","AIB_PRCCOM","AIB_DESC1","AIB_DESC2","AIB_DESC3","AIB_DESC4","AIB_DESC5","AIB_DESC6" SIZE 240,95 OF oDlg	PIXEL
	oLbx:SetArray( aVetor ) 
	oLbx:bLine := {|| {aVetor[oLbx:nAt,CAMP1],;
					   aVetor[oLbx:nAt,CAMP2],; 
					   aVetor[oLbx:nAt,CAMP3],;
					   aVetor[oLbx:nAt,CAMP4],;
					   aVetor[oLbx:nAt,CAMP5],;
					   aVetor[oLbx:nAt,CAMP6],;
					   aVetor[oLbx:nAt,CAMP7],;
					   aVetor[oLbx:nAt,CAMP8],;
					   aVetor[oLbx:nAt,CAMP9],;
					   aVetor[oLbx:nAt,CAMP10],;
					   aVetor[oLbx:nAt,CAMP11],;
					   aVetor[oLbx:nAt,CAMP12]}} 
DEFINE SBUTTON FROM 107,213 TYPE  1 ACTION oDlg:End() ENABLE OF oDlg 
ACTIVATE MSDIALOG oDlg CENTER 
Return                                      

/*
+-------------------------------------------------------------------------- 
| Funci๓n | LISTBOXITE    | Autor | Cardeza Fernando    | Fecha |         |
|+------------------------------------------------------------------------- 
| Descripci๓n                                                             |
| Programa que muestra la utilizaci๓n de LISTBOX() como lista simple.     |   
|+------------------------------------------------------------------------- 
| Uso  | Muestra las condiciones necesarias para la ejecusion de la rutina|
|+------------------------------------------------------------------------- 
*/ 
User Function ListBoxIte() 
Local aVetor   := {} 
Local oDlg     := Nil 
Local oLbx     := Nil 
Local cTitulo  := "Leer antes de comenzar..." 
Local nChave   := 0 
Local cChave   := "" 
AADD( aVetor, "El siguiente programa ejecuta una rutina automแtica para la modificaci๓n masiva de precios") 
AADD( aVetor, "------------------------------------------------------------------------------------------")
AADD( aVetor, "Enumeraci๓n de condiciones necesarias para el correcto funcionamiento de la rutina")
AADD( aVetor, "1 - El c๓digo y tienda deben existir en el maestro de Proveedores")
AADD( aVetor, "2 - El usuario en su pc local debe tener instalado el Ms Office") 
AADD( aVetor, "3 - El archivo seleccionado debe tener extensi๓n *.xls (Libro de Excel 97-2003)") 
AADD( aVetor, "4 - El archivo a importar debe tener la estructura del siguiente browser") 
//+-----------------------------------------------+
//| Monta la pantalla para que el usuario visualice consulta |        
//+-----------------------------------------------+

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL 
@ 10,10 LISTBOX oLbx VAR nChave ITEMS aVetor SIZE 230,95 OF oDlg PIXEL 
oLbx:bChange := {|| cChave := SubStr(aVetor[nChave],1,2) } 
DEFINE SBUTTON FROM 107,213 TYPE  1 ACTION oDlg:End() ENABLE OF oDlg 
ACTIVATE MSDIALOG oDlg CENTER 
Return                                                      

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
// ฑฑบPrograma  ณ valorCpo บ Autor ณ Fernando Cardeza   บ Data ณ  27/02/13   บฑฑ
// ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
// ฑฑบDesc.     ณ Retorna el valor formateado segun el tipo de dato del cpo  บฑฑ
// ฑฑบ          ณ                                                            บฑฑ
// ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
// ฑฑบUso       ณ AP                                                         บฑฑ
// ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function valorCpo(cCampo,cValor)	

Local aArea    := GetArea()
Local aAreaSX3 := SX3->(GetArea())
Local xValor

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek(allTrim(cCampo))
	If X3_TIPO $ "C/M"
		xValor := cValor
	Elseif X3_TIPO == "N"
		xValor := Val(cValor)
	Elseif X3_TIPO == "D"
		xValor := CtoD(cValor)
	Endif
EndIf

RestArea(aAreaSX3)
RestArea(aArea)

Return xValor


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณMaRejTabComณ Autor ณ Eduardo Riera         ณ Data ณ03.10.03 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณRotina de reajuste da tabela de preco                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณExpN1: Numerico (Preco de Compra)                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpC1: Fornecedor                                           ณฑฑ
ฑฑณ          ณExpC2: Loja                                                 ณฑฑ
ฑฑณ          ณExpC3: Tabela de Preco                                      ณฑฑ
ฑฑณ          ณExpC4: Codigo do Produto                                    ณฑฑ
ฑฑณ          ณExpN1: Fator                                                ณฑฑ
ฑฑณ          ณExpN2: Decimais a serem consideradas                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao Efetuada                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MaRejTab(cCodFor,cLoja,cCodTab,cCodPro,nFator,nDecimais,cdesc1,cdesc2,cdesc3,cdesc4,cdesc5,cdesc6)

Local aArea    := GetArea()
Local aAreaAIA := AIA->(GetArea())
Local aAreaAIB := AIB->(GetArea())
Local nBase    := 0

DEFAULT nDecimais := TamSx3("AIB_PRCVEN")[2]

dbSelectArea("AIB")
dbSetOrder(2)
If DbSeek(xFilial("AIB")+cCodFor+cLoja+cCodTab+cCodPro)
	While !Eof() .And. AIB->AIB_FILIAL == xFilial("AIB") .And.;
			AIB->AIB_CODFOR == cCodFor .And.;
			AIB->AIB_LOJFOR == cLoja .And.;
			AIB->AIB_CODTAB == cCodTab .And.;
			AIB->AIB_CODPRO == cCodPro

		Begin Transaction

			RecLock("AIB")

			nBase   := AIB->AIB_PRCCOM

			AIB->AIB_PRCCOM := If(nFator > 0, NoRound(nBase * nFator,nDecimais), nBase )
			AIB->AIB_DESC1 :=cdesc1
			AIB->AIB_DESC2 :=cdesc2
			AIB->AIB_DESC3 :=cdesc3
			AIB->AIB_DESC4 :=cdesc4 
			AIB->AIB_DESC5 :=cdesc5
			AIB->AIB_DESC6 :=cdesc6
			
			MsUnLock()

		End Transaction 
		
		dbSelectArea("AIB")
		dbSkip()
	EndDo
EndIf
RestArea(aAreaAIB)
RestArea(aAreaAIA)
RestArea(aArea)
Return(.T.)