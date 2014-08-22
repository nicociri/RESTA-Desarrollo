#INCLUDE 'TBICONN.CH'
#include "PROTHEUS.CH"
#INCLUDE "TCBROWSE.CH"


// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
// ฑฑบPrograma  ณ RotAuto   บAutor ณ MS                 บFecha ณ  12/06/12   บฑฑ
// ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
// ฑฑบDesc.     ณ                                                            บฑฑ
// ฑฑบ          ณ                                                            บฑฑ
// ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
// ฑฑบUso       ณ AP                                                         บฑฑ
// ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function RotAuto()

Local aTamanho := {Space(15),space(40),space(10),space(20)}

Private oDlg
Private aListB    := {}
Private oList
Private oBConfig
Private oBOK
Private oBSair
Private oBLog
Private oBLogA
Private ochk
Private oMod
Private cMod := "PCP"
Private aMod := {	"Maestros",;
					"Compras",;
					"Facturaci๓n",;
					"Stock",;
					"PCP",;
					"Financiero",;
					"Cantabilidad",;
					"Calidad",;
					"Asistencia T้cnica",;
					"Auxiliares";
				}

Private lchk := .t.


DEFINE MSDIALOG oDlg FROM 5, 5 TO 25, 80 TITLE OemToAnsi("Rotina Automatica" )
oDlg:lEscClose := .F.

@ 003 ,003 Say "Grupo" PIXEL of oDLG
@ 002 ,031 MSCOMBOBOX oMod VAR cMod ITEMS aMod size 60,08 pixel of oDlg ON CHANGE Carrega()
@ 013 ,003 LISTBOX oList ITEMS aTamanho FIELDS HEADER "","Descripci๓n","Operaci๓n","Rutina" SIZE 400, 125 OF oDlg PIXEL
@ 139 ,208 BUTTON oBOk 		PROMPT "Importar" SIZE 40 ,11  FONT oDlg:oFont ACTION Importar(aListB) OF oDlg PIXEL
@ 139 ,258 BUTTON oBSair 	PROMPT "Salir" SIZE 40 ,11  FONT oDlg:oFont ACTION oDlg:End() OF oDlg PIXEL

Carrega()

ACTIVATE MSDIALOG oDlg  CENTERED
Return

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
// ฑฑบPrograma  ณ marca     บAutor ณ MS                 บFecha ณ  12/06/12   บฑฑ
// ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
// ฑฑบDesc.     ณ                                                            บฑฑ
// ฑฑบ          ณ                                                            บฑฑ
// ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
// ฑฑบUso       ณ AP                                                         บฑฑ
// ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function marca(nLinha)

Local i    := 0

For i := 1 to Len(aListb)
	aListb[i,1]:= .F.
Next i

//If empty(aListb[nLinha,1])
	aListb[nLinha,1]:= .T.
// Else
	// aListb[nLinha,1]:=" "
// EndIF

oList:Refresh()

Return

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
// ฑฑบPrograma  ณ Carrega   บAutor ณ MS                 บFecha ณ  12/06/12   บฑฑ
// ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
// ฑฑบDesc.     ณ                                                            บฑฑ
// ฑฑบ          ณ                                                            บฑฑ
// ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
// ฑฑบUso       ณ AP                                                         บฑฑ
// ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function Carrega()

Local nLinha
Local oCheck	:= LoadBitmap( GetResources(), "LBOK" ) 
Local oUnCheck	:= LoadBitmap( GetResources(), "LBNO" ) 

aListb:={}

If cMod == "Maestros"
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	Padr("Productos",40)
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"Mata010"
	aListB[nLinha,5] := 	"1"
	

	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Proveedores"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"Mata020"
	aListB[nLinha,5] := 	"1"
	
	
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Clientes"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"Mata030"
	aListB[nLinha,5] := 	"1"
	
ElseIf cMod =="Compras"

	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Pedidos de compra"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"Mata120"
	aListB[nLinha,5] := 	"2"
	
		
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Factura de Entrada"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"Mata101n"
	aListB[nLinha,5] := 	"2"
	
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Anticipos"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"Fina050"
	aListB[nLinha,5] := 	"2"
	
	
ElseIf cMod =="Facturaci๓n"
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Pedido de Venta"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"Mata410"
	aListB[nLinha,5] := 	"2"

ElseIf cMod =="Financiero"
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Titulos a Cobrar"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"Fina040"
	aListB[nLinha,5] := 	"1"
	
ElseIf cMod =="Cantabilidad"
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Lancamentos Contabeis"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"CONA050"
	aListB[nLinha,5] := 	"2"
	
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Centro de custo"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"CONA060"
	aListB[nLinha,5] := 	"1"
	
	
ElseIf cMod =="Stock"
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Saldo Inicial"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"Mata220"
	aListB[nLinha,5] := 	"1"
	

	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Enderecamento"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"Mata265"
	aListB[nLinha,5] := 	"2"
	
	
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Inventario"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"Mata270"
	aListB[nLinha,5] := 	"1"
	
	
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Estructuras"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"Mata200"
	aListB[nLinha,5] := 	"1"
	
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Movimientos Internos"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"Mata241"
	aListB[nLinha,5] := 	"1"
	
ElseIf cMod =="PCP"
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Orden de Producci๓n"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"Mata650"
	aListB[nLinha,5] := 	"1"
	
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Recursos"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"Mata610"
	aListB[nLinha,5] := 	"1"
	
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Hojas de Ruta"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"Mata630"
	aListB[nLinha,5] := 	"1"

ElseIf cMod =="Calidad"

ElseIf cMod =="Asistencia T้cnica"
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Maestro CATD"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"ZM1"
	aListB[nLinha,5] := 	"1"

	
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"ำrdenes de Servicio"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"OST"
	aListB[nLinha,5] := 	"1"
	
	
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Maestro de Servicios"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"ZM4"
	aListB[nLinha,5] := 	"1"
	
	
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Artํculos"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"ZM5"
	aListB[nLinha,5] := 	"1"


	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Estructuras"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"ZM6"
	aListB[nLinha,5] := 	"1"


	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Tipos de Garantํas"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"ZM7"
	aListB[nLinha,5] := 	"1"
	

	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Garantํas X Artํculos"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"ZM8"
	aListB[nLinha,5] := 	"1"


	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Producto Componente"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"ZM9"
	aListB[nLinha,5] := 	"1"
	

	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Consumidores"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"ZMA"
	aListB[nLinha,5] := 	"1"


	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"Intervenciones"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"ZMB"
	aListB[nLinha,5] := 	"1"

ElseIf cMod =="Auxiliares"

	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"SFH Proveedores"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"SFH"
	aListB[nLinha,5] := 	"2"
	
	aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"SFH Clientes"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"SFH"
	aListB[nLinha,5] := 	"2"
	
		aadd(aListB,Array(5))
	nLinha := Len(aListB)
	aListB[nLinha,1] := 	.F.
	aListB[nLinha,2] := 	"SG5 Letra de Cambio"
	aListB[nLinha,3] := 	"Alta"
	aListB[nLinha,4] := 	"SG5"
	aListB[nLinha,5] := 	"2"


EndIf

oList:SetArray(aListB)
oList:bLine := { || {IIF( aListB[oList:nAT,1] , oCheck ,  oUnCheck ),;
                      aListB[oList:nAT,2],;
					  aListB[oList:nAT,3],;
					  aListB[oList:nAT,4];
					 };
				}
oList:bLDblClick := {|| marca(oList:nAT)}
oList:nAT:= 1
oList:Refresh()

Return

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
// ฑฑบPrograma  ณ Importar  บAutor ณ MS                 บFecha ณ  12/06/12   บฑฑ
// ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
// ฑฑบDesc.     ณ                                                            บฑฑ
// ฑฑบ          ณ                                                            บฑฑ
// ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
// ฑฑบUso       ณ AP                                                         บฑฑ
// ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function Importar(aList)

Local nX
Local cConstruc := " en Construcci๓n"

For nX:= 1 to Len(aList)
	If ! Empty(aList[nx,1])
		Do Case
			Case aList[nx,4] = "Mata010" 
				U_IMPSB1()				
			Case aList[nx,4] = "Mata020" 
				U_IMPSA2()
			Case aList[nx,4] = "Mata030" 
				U_IMPSA1()
			Case aList[nx,4] = "Mata120" 
				Alert("Pedido de Compra"+cConstruc)
			Case aList[nx,4] = "Mata101n" 
				U_IMPSF1()	
			Case aList[nx,4] = "Mata410"   
				U_IMPSC5()	
			Case aList[nx,4] = "Fina040" 
				U_IMPSE1()
			Case aList[nx,4] = "Fina050" 
				U_IMPSE2()	
			Case aList[nx,4] = "CONA050" 
				Alert("Lancamentos Contabeis"+cConstruc)
			Case aList[nx,4] = "CONA060" 
				Alert("Centro de Custo"+cConstruc)				
			Case aList[nx,4] = "Mata220" 
				U_IMPSB9()
			Case aList[nx,4] = "Mata265" 
				Alert("Enderecamento"+cConstruc)				 
			Case aList[nx,4] = "Mata270" 
				Alert("Inventario"+cConstruc)
			Case aList[nx,4] = "Mata200" 
				U_IMPSG1()	
			Case aList[nx,4] = "Mata241" 
				U_IMPSD3()
			Case aList[nx,4] = "Mata610" 
				U_IMPSH1()
			Case aList[nx,4] = "Mata630" 
				U_IMPSG2()			
			Case aList[nx,4] = "Mata650" 
				Alert("Ordem de Producao"+cConstruc)	
			Case aList[nx,4] = "ZM1" 
				U_IMPZM1()	
			Case aList[nx,4] = "OST" 
				U_IMPZM2()
			Case aList[nx,4] = "ZM4" 
				U_IMPZM4()
			Case aList[nx,4] = "ZM5" 
				U_IMPZM5()
			Case aList[nx,4] = "ZM6" 
				U_IMPZM6()
			Case aList[nx,4] = "ZM7" 
				U_IMPZM7()
			Case aList[nx,4] = "ZM8" 
				U_IMPZM8()
			Case aList[nx,4] = "ZM9" 
				U_IMPZM9()
			Case aList[nx,4] = "ZMA" 
				U_IMPZMA()
			Case aList[nx,4] = "ZMB" 
				U_IMPZMB()
			Case aList[nx,4] = "SFH"
				If 	aList[nx,2] == "SFH Proveedores"
					U_IMPAUX("SFH",1)
				Else
					U_IMPAUX("SFH",2)
				Endif
			Case aList[nx,4] = "SG5" 
				U_IMPSG5()
	    EndCase 
	EndIf
Next

Return 