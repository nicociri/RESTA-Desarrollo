#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                                         
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ACO001  ³ Autor ³ Fernando Cardeza        ³ Data ³02/12/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Seguros de acopios                                         ³±±
±±³          ³                                                            ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ACO001()

Local oReport
Local oSection
Local cPerg := "ACO001"

AjustaSX1()     
		If TRepInUse()	
			Pergunte(cPerg,.F.)	
			oReport := ReportDef()	
			oReport:PrintDialog()	
		EndIf
Return                        


Static Function ReportDef()
Local oReport
Local oSection
Local oBreak
oReport := TReport():New("ACO001","Informes de seguro por acopio ","ACO001",{|oReport| PrintReport(oReport)},"Informes de seguro por acopio ")
oSection := TRSection():New(oReport,"Informes de seguro por acopio 2",{"Z01"},{"Informes de seguro por acopio 2"})
TRCell():New(oSection,"Z01_ACOPIO","Z01") 
TRCell():New(oSection,"Z01_DESC"  ,"Z01") 
TRCell():New(oSection,"Z01_CLIENT","Z01") 
TRCell():New(oSection,"Z01_LOJA", "Z01") 
TRCell():New(oSection,"Z01_TPSEG1","Z01") 
TRCell():New(oSection,"Z01_CCLIET","Z01") 
TRCell():New(oSection,"Z01_XPORC" ,"Z01") 
TRCell():New(oSection,"Z01_POLIZA","Z01")        
Return oReport

Static Function PrintReport(oReport)
Local oSection 	:= oReport:Section(1)            
Local cAlias 	:= GetNextAlias()
Local xseg		:= "S"
Local xpoli		:= ""
//#IFDEF TOP
	
	MakeSqlExp("ACO001")
	
BEGIN REPORT QUERY oReport:Section(1)
BeginSql Alias cAlias
	SELECT  Z01_ACOPIO,Z01_DESC,Z01_CLIENT,Z01_LOJA,/*CASE Z01_TPSEG1 WHEN '1' THEN 'Adjudicado' WHEN '2' THEN 'Anticipo' ELSE '' END AS */Z01_TPSEG1,Z01_CCLIET,Z01_XPORC ,Z01_POLIZA
		FROM %table:Z01%
		WHERE Z01_CLIENT BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% AND
			  Z01_ACOPIO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND
			  Z01_XSEG=%Exp:xseg% AND Z01_POLIZA<>%Exp:xpoli% AND
			  %NotDel%
	UNION ALL
	SELECT	Z01_ACOPIO,Z01_DESC,Z01_CLIENT,Z01_LOJA,/*CASE Z01_TPSEG2 WHEN '1' THEN 'Adjudicado' WHEN '2' THEN 'Anticipo' ELSE '' END AS */Z01_TPSEG2,Z01_CCLIE2,Z01_XPORC2,Z01_POLIZ2
		FROM %table:Z01% 
		WHERE Z01_CLIENT BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% AND
			  Z01_ACOPIO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND
			  Z01_XSEG=%Exp:xseg% AND Z01_POLIZ2<>%Exp:xpoli% AND
			  %NotDel%
	ORDER BY Z01_ACOPIO
EndSql      
	END REPORT QUERY oReport:Section(1) 	
	
oReport:Section(1):Print()
//#ENDIF
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSx1  ºAutor ³Fernando Cardeza    º Data ³  02/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Parametros del Reporte							          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1()
	Local aArea := GetArea()
	Local aRegs := {}, i, j
	Local cPerg := ""
	cPerg := Padr("ACO001",Len(SX1->X1_GRUPO))

	DbSelectArea("SX1")
	DbSetOrder(1)

	aAdd(aRegs,{cPerg,"01","De Acopio	","De Acopio	","De Acopio	","mv_ch1","C",06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	aAdd(aRegs,{cPerg,"02","A Acopio 	","A Acopio 	","A Acopio 	","mv_ch2","C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	aAdd(aRegs,{cPerg,"03","De Cliente	","De Cliente	","De Cliente	","mv_ch3","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	aAdd(aRegs,{cPerg,"04","A Cliente	","A Cliente	","A Cliente	","mv_ch4","C",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	
	For i:=1 to Len(aRegs)
	   If !dbSeek(cPerg+aRegs[i,2])
		  RecLock("SX1",.T.)
		  For j:=1 to FCount()
			 If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			 Endif
		  Next
		  MsUnlock()
		Endif
	Next
	RestArea(aArea)
Return
