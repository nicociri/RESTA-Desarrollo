#INCLUDE "Protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LOCXPE08  �Autor  �                    �Fecha �  09/16/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Generico                                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function LOCXPE08
Local aDatos	:= {}
Local aAreaSD1 	:= SD1->(GetArea())
Local aAreaSB1 	:= SB1->(GetArea())
Local nCosEst1, nCosEst2, nCosEst3, nCosEst4, nCosEst5

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//���������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ[�

If IsInCallStack("MATA102N") .or. IsInCallStack("MATA101N")
	
	SB1->(DbSetOrder(1)) // SB1->B1_FILIAL + SB1->B1_COD
	
	SD1->(DbSetOrder(1)) // SD1->D1_FILIAL, SD1->D1_DOC, SD1->D1_SERIE, SD1->D1_FORNECE, SD1->D1_LOJA, SD1->D1_COD, SD1->D1_ITEM
	SD1->( DbSeek( xFilial("SD1") +	SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ) )
	
	Do While SD1->(!Eof()) .And. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == ;
		SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA
		
		
		// Traigo el costo mas nuevo entre el costo de la lista 001 y el costo de ultima compra en sb1, al momento de realizar la operacion .
		
		
		SB1->(DbSeek(xFilial("SB1") + SD1->D1_COD ))
		
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
		
		If _nCustop > 0 .and. Posicione("SF4", 1, xFilial("SF4") + SD1->D1_TES, "F4_ESTOQUE") == "S"
			
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
			
			nCosEst1	:=	Round(nCosEst1 * SD1->D1_QUANT, TamSx3("D1_CUSTO")[2]  )
			nCosEst2	:= 	Round(nCosEst2 * SD1->D1_QUANT, TamSx3("D1_CUSTO2")[2] )
			nCosEst3	:=  Round(nCosEst3 * SD1->D1_QUANT, TamSx3("D1_CUSTO3")[2] )
			nCosEst4	:=  Round(nCosEst4 * SD1->D1_QUANT, TamSx3("D1_CUSTO4")[2] )
			nCosEst5	:=  Round(nCosEst5, TamSx3("D1_CUSTO5")[2] )
			
			If SD1->(RecLock("SD1",.F.))
				Replace SD1->D1_CUSRP1   With nCosEst1
				Replace SD1->D1_CUSRP2  With nCosEst2
				Replace SD1->D1_CUSRP3  With nCosEst3
				Replace SD1->D1_CUSRP4  With nCosEst4
				Replace SD1->D1_CUSRP5  With nCosEst5
				SD1->(MsUnLock())
			EndIf
			
		EndIf
		
		SD1->(DbSkip())
		
	EndDo
	
EndIf

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//���������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ[�

If IsInCallStack("MATA462N") .or. IsInCallStack("MATA467N")
	
	SB1->(DbSetOrder(1)) // SB1->B1_FILIAL + SB1->B1_COD
	
	SD2->(DbSetOrder(3)) // SD1->D1_FILIAL, SD1->D1_DOC, SD1->D1_SERIE, SD1->D1_FORNECE, SD1->D1_LOJA, SD1->D1_COD, SD1->D1_ITEM
	SD2->( DbSeek( xFilial("SD1") +	SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
	
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

If (funname()=="MATA465N" .and. alltrim(cEspecie) =="NCC") .or. Funname()== 'MATA462DN'
	SB1->(DbSetOrder(1)) // SB1->B1_FILIAL + SB1->B1_COD
	
	SD1->(DbSetOrder(1)) // SD1->D1_FILIAL, SD1->D1_DOC, SD1->D1_SERIE, SD1->D1_FORNECE, SD1->D1_LOJA, SD1->D1_COD, SD1->D1_ITEM
	SD1->( DbSeek( xFilial("SD1") +	SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ) )
	
	Do While SD1->(!Eof()) .And. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == ;
		SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA
		
		If empty(SD1->D1_REMITO) .and. Empty(SD1->D1_NFORI)
			// Traigo el costo mas nuevo entre el costo de la lista 001 y el costo de ultima compra en sb1, al momento de realizar la operacion .
			
			
			SB1->(DbSeek(xFilial("SB1") + SD1->D1_COD ))
			
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
			
			If _nCustop > 0 .and. Posicione("SF4", 1, xFilial("SF4") + SD1->D1_TES, "F4_ESTOQUE") == "S"
				
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
				
				nCosEst1	:=	Round(nCosEst1 * SD1->D1_QUANT, TamSx3("D1_CUSTO")[2]  )
				nCosEst2	:= 	Round(nCosEst2 * SD1->D1_QUANT, TamSx3("D1_CUSTO2")[2] )
				nCosEst3	:=  Round(nCosEst3 * SD1->D1_QUANT, TamSx3("D1_CUSTO3")[2] )
				nCosEst4	:=  Round(nCosEst4 * SD1->D1_QUANT, TamSx3("D1_CUSTO4")[2] )
				nCosEst5	:=  Round(nCosEst5, TamSx3("D1_CUSTO5")[2] )
				
				If SD1->(RecLock("SD1",.F.))
					Replace SD1->D1_CUSRP1   With nCosEst1
					Replace SD1->D1_CUSRP2  With nCosEst2
					Replace SD1->D1_CUSRP3  With nCosEst3
					Replace SD1->D1_CUSRP4  With nCosEst4
					Replace SD1->D1_CUSRP5  With nCosEst5
					SD1->(MsUnLock())
				EndIf
				
			EndIf
			
			
		Else  // si viene de documento orignal me posiciono y busco el costo del documento original.
			
			If !Empty(SD1->D1_REMITO) // si viene de remito
				SD2->(Dbsetorder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
				SD2->(DBSEEK(XFILIAL("SD2")+SD1->D1_REMITO+SD1->D1_SERIREM+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEMREM))
				Reclock("SD1",.F.)
				Replace SD1->D1_CUSRP1   With SD2->D2_CUSRP1
				Replace SD1->D1_CUSRP2  With SD2->D2_CUSRP2
				Replace SD1->D1_CUSRP3  With SD2->D2_CUSRP3
				Replace SD1->D1_CUSRP4  With SD2->D2_CUSRP4
				Replace SD1->D1_CUSRP5  With SD2->D2_CUSRP5
				
				MsUnlock()
			ElseIf !Empty(SD1->D1_NFORI) 	// si viene de factura
				SD2->(Dbsetorder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
				SD2->(DBSEEK(XFILIAL("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEMREM))
				Reclock("SD1",.F.)
				Replace SD1->D1_CUSRP1   With SD2->D2_CUSRP1
				Replace SD1->D1_CUSRP2  With SD2->D2_CUSRP2
				Replace SD1->D1_CUSRP3  With SD2->D2_CUSRP3
				Replace SD1->D1_CUSRP4  With SD2->D2_CUSRP4
				Replace SD1->D1_CUSRP5  With SD2->D2_CUSRP5
				
				MsUnlock()
			ENDiF
		ENDiF
		
		
		
		
		SD1->(DbSkip())
	EndDo
	
	
EndIf

Return (.T.)




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  TraeCosLp  �Autor  �Microsiga           �Fecha �  08/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Trae El costo del producto  desde la lista de precios de compras���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TraeCosLp(nRetorno, CCodProd)
Local XRetorno
Local _cqueryAIB	:= ""
Local _cAliasAib	:= "QRYAIB"
Local _aArea	:= GetARea()

_cQueryAIB	:= "SELECT "
If nRetorno	== 1
	_cQueryAIB	+= " AIB_PRCCOM AS RETORNO "
ElseIf nRetorno == 2
	_cQueryAIB	+= " AIB_DATVIG AS RETORNO "
ElseIf nRetorno == 3
	_cQueryAIB	+= " AIB_MOEDA AS RETORNO "
EndIf
_cQueryAIB	+= " FROM " + RetSqlname("AIB") + "Where AIB_CODPRO ='"+ CCodProd+"' AND D_E_L_E_T_ ='' AND AIB_CODTAB = '" +GetNewPar("RE_CODTAB","001")+"' "
_cQueryAIB := ChangeQuery(_cQueryAIB)
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,_cQueryAIB), _cAliasAib, .F., .T.)

If !(_caliasAIB)->(EOF())
	
	xRetorno := (_cAliasAIB)->RETORNO
	
EndIf

(_cAliasAIB)->(dbclosearea())

If nRetorno	== 1 .or. nRetorno == 3
	If Empty(Xretorno)
		xRetorno	:= 0
	EndIf
ElseIf nRetorno == 2
	If Empty(Xretorno)
		xRetorno	:= ctod("  /  /    ")
	Else
		xRetorno	:= Stod(xRetorno)
	EndIf
EndIf


RestArea(_aArea)
Return xRetorno
