#include 'TOPCONN.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CTBOPDIF    ºAutor  ³MS		         ºFecha ³  28/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcula redondeos de conversion de monedas en OP           º±±
±±º          ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
User Function CtbOPdif (cTipo)
Local nRet 	  := 0
local nDifRed := ""
Local aArea   := GetArea( )
Local aSX6    := SX6->( GetArea() )

//Verifica y crea parametro para manejar correlativo de certificados
DbSelectArea("SX6")
DbSetOrder(1)
IF !DbSeek("  "+"MV_DIFPES")
   RecLock("SX6",.T.)
     Replace SX6->X6_FIL      With "  "
     Replace SX6->X6_VAR      With "MV_DIFPES"
     Replace SX6->X6_TIPO     With "N"
     Replace SX6->X6_DESCRIC  With "Valor limite para validar diferencias"
     Replace SX6->X6_DSCSPA   With "Valor limite para validar diferencias"
     Replace SX6->X6_DSCENG   With "Valor limite para validar diferencias"
     Replace SX6->X6_DESC1    With "en asientos contables"
     Replace SX6->X6_DSCSPA1  With "en asientos contables"
     Replace SX6->X6_DSCENG1  With "en asientos contables"
     Replace SX6->X6_CONTEUD  With "0.05"
     Replace SX6->X6_CONTSPA  With "0.05"
     Replace SX6->X6_CONTENG  With "0.05"
     Replace SX6->X6_PROPRI   With "U"
   SX6->(MsUnlock())
ENDIF
nDifRed:=GETMV("MV_DIFPES")

//Calculo de redondeo en Ordenes de Pago

cQuery := "SELECT SUM(EK_VALOR *  
cQuery += "(CASE	WHEN EK_TIPODOC = 'TB' AND EK_TIPO <> 'NCP' THEN -1 "
cQuery += "			WHEN EK_TIPODOC = 'RG' THEN 0 "
cQuery += "			WHEN EK_TIPODOC = 'PA' THEN -1 "
cQuery += "			WHEN EK_TIPODOC = 'TB' AND EK_TIPO = 'NCP' THEN 1 "
cQuery += "			WHEN EK_TIPODOC <> 'TB' THEN 1 "
cQuery += "			END)) AS VAL_OP, "
cQuery += "	(SELECT MAX(EK_NUM) FROM " + RetSqlName("SEK") + " WHERE EK_FILIAL = '" + xfilial("SEK") + "' AND EK_ORDPAGO = '" + SEK->EK_ORDPAGO + "' AND EK_TIPODOC= 'CP' AND D_E_L_E_T_ = ' ' GROUP BY EK_ORDPAGO) AS EK_NUM_MAX "
cQuery += " FROM " + RetSqlName("SEK") + " SEK "
cQuery += " WHERE EK_FILIAL = '" + xfilial("SEK") + "' AND EK_ORDPAGO = '" + SEK->EK_ORDPAGO + "'  AND D_E_L_E_T_ = ' '"
cQuery += "	GROUP BY EK_ORDPAGO"               
cQuery += "	UNION ALL "
cQuery += " SELECT SUM(FE_RETENC) AS VAL_OP, "
cQuery += "	(SELECT MAX(EK_NUM) FROM " + RetSqlName("SEK") + " WHERE EK_FILIAL = '" + xfilial("SEK") + "' AND EK_ORDPAGO = '" + SEK->EK_ORDPAGO + "' AND EK_TIPODOC= 'CP' AND D_E_L_E_T_ = ' ' GROUP BY EK_ORDPAGO) AS EK_NUM_MAX "
cQuery += " FROM " + RETSQLNAME('SFE') + " "
cQuery += " WHERE FE_ORDPAGO= '" + SEK->EK_ORDPAGO + "' " 
cQuery += " AND D_E_L_E_T_ <> '*'"	
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'AFNTMP',.T.,.T.)
DbSelectArea( 'AFNTMP' )
dbGoTop()
Do while !eof()            
		If SEK->EK_NUM = AFNTMP->EK_NUM_MAX   
	    nRet  += AFNTMP->VAL_OP 
		Else
		nRet := 0
		EndIf
		dbskip()
Enddo
DbCloseArea()


// analisis de dif. x redondeo                           
IF nRet < -NdifRed .or. nRet > nDifRed
      nRet := 0 	
Else
   	IF cTipo = 'C'.and. nRet < 0 
			nRet := nRet * -1	
		else
			If cTipo = 'D'.and. nRet > 0 
      	  	nRet := nRet 
			Else
				nRet := 0
			EndIf
		EndIf
EndIf					

RestArea( aSX6 )			
RestArea(aArea)

Return nRet


