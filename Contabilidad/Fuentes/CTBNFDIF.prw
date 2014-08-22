#include 'protheus.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³          ³ Autor ³ MICROSIGA             ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxis  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CtbNFDif(nDC1,cLP1)
Local lRet		:= .T.
Local nValDeb	:= 0
Local nValCrd	:= 0
Local dFecha1  := Ctod("  /  /  ")
Local cQuery    := ""
Local cSequen1 := ""
Local mvdifpes := 10
Local nDif1    := 0
Local aArea	:= GetArea()
Local aSX6  := SX6->( GetArea() )

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

mvdifpes:=GETMV("MV_DIFPES")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis.                                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nrecctk  := CTK->(RECNO())
nordctk  := CTK->(IndexOrd())
cSequen1 := CTK->CTK_SEQUEN
IF cLP1 != NIL
   cLP1     := IIF(empty(cLP1),CTK->CTK_LP,cLP1)
ELSE
   cLP1     := CTK->CTK_LP
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Query SE5     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF TOP

	cQuery := "SELECT ASIENTO.CTK_DC AS DC, SUM(ASIENTO.DEBE)AS D, SUM(ASIENTO.HABER) AS H FROM ( "  
	cQuery += "SELECT A.CTK_DC, A.CTK_VLR01 DEBE, 0.00 AS HABER FROM "
	cQuery += RetSQLName( "CTK" ) + " A WHERE A.CTK_FILIAL ='" + xfilial("CTK") + "'"
	cQuery += " AND A.CTK_SEQUEN = '" + cSequen1 + "'"
	cQuery += " AND (A.CTK_DC ='1' OR A.CTK_DC='3') "
	cQuery += " AND A.D_E_L_E_T_ <> '*' "
	cQuery += "UNION ALL "
	cQuery += "SELECT B.CTK_DC, 0.00 AS DEBE, B.CTK_VLR01 HABER FROM "
	cQuery += RetSQLName( "CTK" ) + " B WHERE B.CTK_FILIAL ='" + xfilial("CTK") + "'"
	cQuery += " AND B.CTK_SEQUEN = '" + cSequen1 + "'"
	cQuery += " AND (B.CTK_DC ='2' OR B.CTK_DC='3') "
	cQuery += " AND B.D_E_L_E_T_ <> '*' ) ASIENTO GROUP BY ASIENTO.CTK_DC "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)                                   

#ENDIF

DbselectArea("TMP")
dbGoTop()
While !Eof()  
    
    nValDeb += TMP->D
    nValCrd += TMP->H
    
    dbSkip()
End
DbCloseArea()


nDif1:= nValDeb - nValCrd

IF nDif1 < 0 .and. nDif1 >= -mvdifpes .and. nDC1=1
      nDif1 := nDif1 * -1
ELSEIF nDif1 > 0 .and.  nDif1 <= mvdifpes .and. nDC1=2

ELSE
     nDif1:=0
ENDIF




RestArea( aSX6 )
RestArea( aArea )
Return(nDif1)
