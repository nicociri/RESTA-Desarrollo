#Include "RWMAKE.CH"
#include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ENCFACT   ºAutor  ³Microsiga           ºFecha ³  12/19/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Funcion para traer el valor de la factura del acopio      º±±
±±º          ³  Indefinido                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP         	                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ENCFACT()

Local lRet1		:=""
Local lRet2		:=""
Local cQuery	:=""
Local aDOC		:=M->C5_XDOCACO

			cQuery := "SELECT F2_VALMERC,F2_XNROACO FROM " + RetSqlName("SF2") + " "
			cQuery += "WHERE D_E_L_E_T_ = '' AND F2_XNROACO <> '' AND F2_ESPECIE='NF' AND F2_DOC " + aDOC + " "
			cQuery := PLSAvaSQL(cQuery)
		    If Select("TODO02") <> 0
          		DBSelectArea("TODO02")
          		TODO02->(DBCloseArea())
    	 	EndIf
   		  	// Executa a Query
     		PLSQuery(cQuery,"TODO02")
   		  	// Vai para o inicio da area de trabalho
     		TODO02->(DBGoTop())
  		   		While TODO02->(!Eof())
					lRet1:=TODO02->F2_VALMERC
					lRet2:=TODO02->F2_XNROACO
              		DbSkip()
				EndDo
				
M->C5_XTOTAL	:=lRet1
M->C5_XNROACO	:=lRet2

Return(lRet)      