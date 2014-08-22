#Include "RWMAKE.CH"
#include "PROTHEUS.CH"

User Function ENCFACT()

Local lRet		:=.T.
Local lRet1		:=""
Local lRet2		:=""
Local cQuery	:=""
Local aDOC		:=M->C5_XDOCACO

			cQuery := "SELECT F2_VALMERC,F2_XNROACO FROM " + RetSqlName("SF2") + " "
			cQuery += "WHERE D_E_L_E_T_ = '' AND F2_XNROACO <> '' AND F2_ESPECIE='NF' AND F2_DOC= '" + aDOC + "' " 
			cQuery += " AND F2_CLIENTE= '"+ALLTRIM(M->C5_CLIENTE)+"' AND F2_LOJA= '"+ ALLTRIM(M->C5_LOJACLI) + "' "
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
	If !Empty(lRet2)				
		M->C5_XTOTACO	:=lRet1
		M->C5_XNROACO	:=lRet2
	Else
		Alert("El documento seleccionado no es valido, revisar el cliente/loja ingresado")
		lRet:=.F.
	EndIf
Return(lRet)      