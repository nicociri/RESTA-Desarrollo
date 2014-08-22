#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PV	   ºAutor  ³Microsiga            ºFecha ³  12/30/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Completar                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PV_EF()
Local aArea		:= GetArea()
Local nI		:= 0
Local _cGrupo	:= ""  // guardo el grupo de producto
Local _cGrpSEst	:= GetNewPar("MV_XGRPSE","141|500|550|650|888|995|999")
For nI := 1 To Len(aCols)
	IF M->C5_DOCGER == '3'
		_cGrupo	:= posicione('SB1',1,XFILIAL('SB1')+aCols[nI, GdFieldPos("C6_PRODUTO")],"B1_GRUPO")
		If !Alltrim(_cGrupo) $ _cGrpSEst		// si el grupo esta en el parametro no hago nada
			cTES:= STR(VAL(posicione('SB1',1,XFILIAL('SB1')+aCols[nI, GdFieldPos("C6_PRODUTO")],"B1_TS"))+1,3)
		EndIf
	ELSE
		cTES:= posicione('SB1',1,XFILIAL('SB1')+aCols[nI, GdFieldPos("C6_PRODUTO")],"B1_TS")
	ENDIF
	aCols[nI, GdFieldPos("C6_TES")] := cTES
Next nI
oGetDad:oBrowse:Refresh()

RestArea(aArea)

Return
