#include 'protheus.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ Ma261D3  ³ Autor ³ Hugo Gabriel Bermudez  ³Fecha ³08/01/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Punto de Entrada para grabar registros en SD3 (destino)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Ninguno                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ACTUALIZACIONES EFECTUADAS DESDE LA CODIFICACION INICIAL      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Fecha  ³ BOPS ³  Motivo de la Alteracion                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Ma261d3
Local aArea    := GetArea()
Local nxLin			:= PARAMIXB
Local aArea			:= GetArea()

If FunName() != 'MATA261'
	Return(.T.)
EndIf


nPosOBS := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D3_XOBS'  } )

If !Empty(aCols[n,nPosOBS]) 
   dbSelectArea('SD3')
   RecLock('SD3',.F.)
   Replace D3_XOBS  With aCols[n,nPosobs]
   MsUnlock()
EndIf
                                         
	// Traigo el costo mas nuevo entre el costo de la lista 001 y el costo de ultima compra en sb1, al momento de realizar la operacion . 
		
		
		SB1->(DbSeek(xFilial("SB1") + SD3->D3_COD ))
		
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
		
		If _nCustop > 0
			
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

			nCosEst1	:=	Round(nCosEst1 * SD3->D3_QUANT, TamSx3("D1_CUSTO")[2]  )
			nCosEst2	:= 	Round(nCosEst2 * SD3->D3_QUANT, TamSx3("D1_CUSTO2")[2] )
			nCosEst3	:=  Round(nCosEst3 * SD3->D3_QUANT, TamSx3("D1_CUSTO3")[2] )
			nCosEst4	:=  Round(nCosEst4 * SD3->D3_QUANT, TamSx3("D1_CUSTO4")[2] )
			nCosEst5	:=  Round(nCosEst5, TamSx3("D1_CUSTO5")[2] )
			
			If SD3->(RecLock("SD3",.F.))
				Replace SD3->D3_CUSRP1   With nCosEst1
				Replace SD3->D3_CUSRP2  With nCosEst2
				Replace SD3->D3_CUSRP3  With nCosEst3
				Replace SD3->D3_CUSRP4  With nCosEst4
				Replace SD3->D3_CUSRP5  With nCosEst5
				SD3->(MsUnLock())
			EndIf
			
		EndIf
	



RestArea(aArea)
Return()
