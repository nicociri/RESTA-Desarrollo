#INCLUDE "PROTHEUS.CH"
#Include "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidacionºAutor  ³Microsiga           ºFecha ³  06/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Validación para el monto total de un acopio indefinido    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                            

User Function ValMonAco()
Local aArea     := GetArea()
Local cQuery   := ""	//Para ejecución de Query
Local cCliente := M->C5_CLIENTE
Local cTitulo1 := "Acopios Pendientes"
Local cTexto1  := ""
Local aAcopio  := {}
Local aLinea   := {}

aAcopio:=Pendient()

ModxAtuObj()
A410ReCalc()
oGetDad:oBrowse:Refresh()

If Len(aAcopio)>0
	List_Box(aAcopio)
EndIf                 

RestArea(aArea) 
Return(M->C5_NUM)     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALMONACO ºAutor  ³Microsiga           ºFecha ³  06/26/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function Pendient()

Local cQuery   :=  ""	//Para ejecución de Query
Local cCliente :=  M->C5_CLIENTE
Local aAcopio  := {}

cQuery := "exec [QRY_VAL_ACOPIO_"+SM0->M0_CODIGO+"]'"+ cCliente +"'"
cQuery := PLSAvaSQL(cQuery)
  If Select("TODO01") <> 0
	DBSelectArea("TODO01")
	TODO01->(DBCloseArea())
  EndIf
// Executa a Query
PLSQuery(cQuery,"TODO01")
// Vai para o inicio da area de trabalho
TODO01->(DBGoTop())
    While TODO01->(!Eof())
   		AADD( aAcopio, {ALLTRIM(Posicione("Z01",1,Xfilial("Z01")+TODO01->ACOPIO,"Z01_XDIRO")),TODO01->VALOR} )
    	DbSkip()
	Enddo

Return(aAcopio)  

/*/ 
+------------------------------------------------------------------------- 
| Función | LIST_BOX   | Autor | Cardeza Fernando        |Fecha |        |  
+------------------------------------------------------------------------- 
| Descripción | Programa que muestra la utilización de un LISTBOX() con |
|  
| grid.        															| 
+------------------------------------------------------------------------- 
| Uso  | Ventana para muestra 
+------------------------------------------------------------------------- 
/*/ 
Static Function List_Box(aAcopio) 
Local aVetor := aAcopio 
Local oDlg 
Local oLbx 
Local cTitulo := "Acopios Pendientes" 

	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
	@ 10,10 LISTBOX oLbx FIELDS HEADER "Dirección de Obra", "Monto" SIZE 240,95 OF oDlg	PIXEL
		oLbx:SetArray( aVetor ) 
		oLbx:bLine :={ || {aVetor[oLbx:nAT][1],aVetor[oLbx:nAT][2]}}
	DEFINE SBUTTON FROM 107,213 TYPE  1 ACTION oDlg:End() ENABLE OF oDlg 
	ACTIVATE MSDIALOG oDlg CENTER 

Return                            