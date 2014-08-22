#include "protheus.ch"
#include "topconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LJ7002    ºAutor  ³Microsiga           º Data ³  01/15/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada chamado após toda a gravação dos dados    º±±
±±º          ³ e impressão do cupom fiscal na Venda Assistida.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Lj7002

Local nTipo   := ParamIxb[1]
local aArea	  := GetArea()
Local aAreaL1 := SL1->(GetArea())
Local aAreaL2 := SL2->(GetArea())
Local aAreaD2 := SD2->(GetArea())
Local aAreaA1 := SA1->(GetArea())
Local aAreaF2 := SF2->(GetArea())
Local cChave  := xFilial("SL1") + SL1->L1_NUM
Local aArea   := GetArea()
Local cFilSD2 := xFilial('SD2')
Local cFilSL2 := xFilial('SL2')
Local cFilSL1 := xFilial('SL1')

// Solo si es impresion de facturas

If nTipo==2
	SD2->(dbSetorder(1))
	SD2->(DbSeek(xFilial("SD2")+SL1->L1_DOC+SL1->L1_SERIE))
	
	
	SB1->(DbSetOrder(1)) // SB1->B1_FILIAL + SB1->B1_COD
	
	SD2->(DbSetOrder(3)) // SD1->D1_FILIAL, SD1->D1_DOC, SD1->D1_SERIE, SD1->D1_FORNECE, SD1->D1_LOJA, SD1->D1_COD, SD1->D1_ITEM
	SD2->( DbSeek( xFilial("SD1") +	SL1->L1_DOC + SL1->L1_SERIE + SL1->L1_CLIENTE + SL1->L1_LOJA ) )
	
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
EndIf

RestArea (aAreaSL4 )
RestArea( aAreaA1 )
RestArea( aAreaF2 )
RestArea( aAreaD2 )
RestArea( aAreaL2 )
RestArea( aAreaL1 )
RestArea( aArea )

Return
