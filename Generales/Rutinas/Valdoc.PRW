#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALDOC   บAutor  ณPETRONATI            บFecha ณ  06/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacion EN COMPRAS QUE NO SE PUEDA CARGAR UNA FACTURA    บฑฑ
ฑฑบ          ณ DE UN PROVEEDOR MAS DE UNA VEZ                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
*/
User Function VALDOC()
           
Local lRet    	:= .T.
Local aArea   	:= GetArea()     
Local cFunc		:= Alltrim(FunName())   
Local cQuery

If cFunc $ " MATA465N "  //NCC C
	If Alltrim(cEspecie) $ "NCC  -"
		cQuery:=" SELECT SF1.F1_XNF,SF1.F1_XSERNF,SF1.F1_XESPNF,SF1.F1_DOC,SF1.F1_ESPECIE,SF1.F1_SERIE,SF1.F1_FORNECE "
		cQuery+=" FROM "+RetSqlName("SF1")+" SF1 "
		cQuery+=" WHERE SF1.D_E_L_E_T_<>'*' AND SF1.F1_XNF = " + "'"+ M->F1_XNF +"'" 
		cQuery+=" AND SF1.F1_XESPNF = " + "'" + M->F1_XESPNF + "'"
		cQuery+=" AND SF1.F1_XSERNF = " + "'" + M->F1_XSERNF +"'" 
		&&cQuery+=" AND SF1.F1_FORNECE = " + "'" + M->F1_FORNECE + "'"
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP1",.T.,.F.)
		DbSelectArea("TMP1")
		DbGotop()
		IF !TMP1->(EOF())
           Alert("COMPROBANTE YA FUE INGRESADO PARA ESTE CLIENTE, VERIFIQUE !!!","VALDOC")
           lRet  := .F.
        ENDIF 
        DbSelectArea("TMP1")
        DbCloseArea()
	EndIf
Endif

RestArea(aArea)
Return lRet     
