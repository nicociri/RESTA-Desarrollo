#include "rwmake.ch"
#INCLUDE "Protheus.ch"

User Function M462FIM()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM462fim   บAutor  ณms					 บ Data ณ  20/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada apos a gravacao da guia de Remito		   ฑฑ
ฑฑบ          ณSe utiliza para imprimir Remito                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Local _aRems	:= paramixb[1]
aCAI:={"","","",""}
aAREA:= GetArea()

IF Len(PARAMIXB[1]) < 1
	RETURN()
ENDIF

for nx := 1 to len(_aRems)
	SF2->(dbsetorder(1))
	SF2->(DBSEEK(xFILIAL("SF2")+_aRems[nx][2]+_aRems[nx][1]))
	
	SB1->(DbSetOrder(1)) // SB1->B1_FILIAL + SB1->B1_COD
	
	SD2->(DbSetOrder(3)) // SD1->D1_FILIAL, SD1->D1_DOC, SD1->D1_SERIE, SD1->D1_FORNECE, SD1->D1_LOJA, SD1->D1_COD, SD1->D1_ITEM
	SD2->( DbSeek( xFilial("SD2") +	SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
	
	Do While SD2->(!Eof()) .And. SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA == ;
		SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA
		
		
		// Traigo el costo mas nuevo entre el costo de la lista 001 y el costo de ultima compra en sb1, al momento de realizar la operacion .
		
		
		SB1->(DbSeek(xFilial("SB1") + SD2->D2_COD ))
		
		_nCostolp	:=  u_TraeCosLp(1,SB1->B1_COD)
		_dDataLP	:=  u_TraeCosLp(2,SB1->B1_COD)
		_nMoedaLP	:=  u_TraeCosLp(3,SB1->B1_COD)
		
		If _dDataLp > SB1->B1_UCOM  // si la fecha de la lista de precios es mayor a la fecha de ultima compra
			_nCustop	:= _ncostoLp   // asino como costo el costo de la lista de precios
			_nMoeda		:= _nMoedaLP
		Else
			_nCustop	:= SB1->B1_CUSTD   // asino como costo el costo de la lista de precios
			_nMoeda		:= SB1->B1_MCUSTD
		EndIf
		
		If _nCustop > 0 .and. Posicione("SF4", 1, xFilial("SF4") + SD2->D2_TES, "F4_ESTOQUE") == "S"
			
			Do Case
				Case _nMoeda == 1
					nCosEst1	:= _nCustop
					nCosEst2	:= 	_nCustop / RecMoeda( ddatabase , 2 )
					nCosEst3	:=  _nCustop / RecMoeda( ddatabase , 3 )
					nCosEst4	:= 	_nCustop / RecMoeda( ddatabase , 4 )
					nCosEst5	:=  _nCustop / RecMoeda( ddatabase , 5 )
					
				Case _nMoeda == 2
					nCosEst2	:= _nCustop
					nCosEst1	:=	nCosEst2 * RecMoeda( ddatabase , 2 )
					nCosEst3	:= 	nCosEst1 / RecMoeda( ddatabase , 3 )
					nCosEst4	:=  nCosEst1 / RecMoeda( ddatabase , 4 )
					nCosEst5	:=  nCosEst1 / RecMoeda( ddatabase , 5 )
					
				Case _nMoeda == 3
					nCosEst3	:= 	_nCustop
					nCosEst1	:=	nCosEst3 * RecMoeda( ddatabase , 3 )
					nCosEst2	:= 	nCosEst1 / RecMoeda( ddatabase , 2 )
					nCosEst4	:=  nCosEst1 / RecMoeda( ddatabase , 4 )
					nCosEst5	:=  nCosEst1 / RecMoeda( ddatabase , 5 )
					
				Case _nMoeda == 4
					nCosEst4	:=  _nCustop
					nCosEst1	:=	nCosEst4 * RecMoeda( ddatabase , 4 )
					nCosEst2	:= 	nCosEst1 / RecMoeda( ddatabase , 2 )
					nCosEst3	:=  nCosEst1 / RecMoeda( ddatabase , 3 )
					nCosEst5	:=  nCosEst1 / RecMoeda( ddatabase , 5 )
					
				Case _nMoeda == 5
					nCosEst5	:=  _nCustop
					nCosEst1	:=	nCosEst5 * RecMoeda( ddatabase , 5 )
					nCosEst2	:= 	nCosEst1 / RecMoeda( ddatabase , 2 )
					nCosEst3	:=  nCosEst1 / RecMoeda( ddatabase , 3 )
					nCosEst4	:=  nCosEst1 / RecMoeda( ddatabase , 4 )
					
			EndCase
			
			nCosEst1	:=	Round(nCosEst1 * SD2->D2_QUANT, TamSx3("D1_CUSTO")[2]  )
			nCosEst2	:= 	Round(nCosEst2 * SD2->D2_QUANT, TamSx3("D1_CUSTO2")[2] )
			nCosEst3	:=  Round(nCosEst3 * SD2->D2_QUANT, TamSx3("D1_CUSTO3")[2] )
			nCosEst4	:=  Round(nCosEst4 * SD2->D2_QUANT, TamSx3("D1_CUSTO4")[2] )
			nCosEst5	:=  Round(nCosEst5, TamSx3("D1_CUSTO5")[2] )
			
			If SD2->(RecLock("SD2",.F.))
				Replace SD2->D2_CUSRP1   With nCosEst1
				Replace SD2->D2_CUSRP2  With nCosEst2
				Replace SD2->D2_CUSRP3  With nCosEst3
				Replace SD2->D2_CUSRP4  With nCosEst4
				Replace SD2->D2_CUSRP5  With nCosEst5
				SD2->(MsUnLock())
			EndIf
			
		EndIf
		
		SD2->(DbSkip())
		
	EndDo
	
Next
/*IF !MSGYESNO('Desea Imprimir Remito?','Confirma?')
RestArea(aAREA)
Return()
Endif
/*
_cMensa1 := Space(50)
_cMensa2 := Space(50)
_cMensa3 := Space(50)
_cMensa4 := Space(50)
*/
_cMensa1 := SC5->C5_TRANSP
_cMensa2 := SC5->C5_XENDENT


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Interfaz para preguntar por transportista y direccion de entrega     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

DEFINE MSDIALOG oDlg TITLE "Transporte y Entrega" FROM 87,10 TO 200,813 OF oMainWnd PIXEL
@ 005,005 TO 50,750 PROMPT "Confirme Datos de Entrega" OF oDlg PIXEL
@ 14,11 Say OemToAnsi("Transportista:") Size 55,8 OF oDlg PIXEL
@ 25,11 Say OemToAnsi("Direccion de Entrega:")  Size 55,8 OF oDlg PIXEL
@ 12,75 MSGet _cMensa1 Size 50,10 F3 "SA4" OF oDlg PIXEL
@ 23,75 MSGet _cMensa2 Size 311,10 OF oDlg PIXEL
DEFINE SBUTTON oBtnOk FROM 40,300 TYPE 1 ENABLE ACTION (_nOkDlg := 1,oDlg:End()) OF oDlg PIXEL
ACTIVATE MSDIALOG oDlg CENTERED

RecLock("SF2",.F.)
IF SF2->( FieldPos( "F2_TRANSP" ) ) > 0
	REPLACE F2_TRANSP WITH _cMensa1
ENDIF
IF SF2->( FieldPos( "F2_XENDENT" ) ) > 0
	REPLACE F2_XENDENT WITH _cMensa2
ENDIF
MsUnLock()


If Len(ParamIXB[1]) > 1
	For nIdx := 1 To Len(ParamIXB[1])
		//U_RTOARG(ParamIXB[1][nIdx][2],ParamIXB[1][nIdx][1],.F.)
		u_KRem01 ('RFN',ParamIXB[1][nIdx][1],ParamIXB[1][nIdx][2])
	Next nIdx
Else
	//U_RTOARG(SF2->F2_DOC,SF2->F2_SERIE,.F.)
	u_KRem01 ('RFN  ',SF2->F2_SERIE,SF2->F2_DOC)
EndIf
/////////////////////////////////////////

RestArea(aAREA)

Return()
