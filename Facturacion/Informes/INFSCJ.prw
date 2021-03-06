#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������                                                         
�������������������������������������������������������������������������Ŀ��
���Programa  �		  � Autor � Fernando Cardeza        � Data �02/12/13  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Informe de presupuestos                                    ���
���          �                                                            ���
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function INFSCJ()

Local oReport
Local oSection
Local cPerg := "INFSCJ    "

AjustaSX1(cPerg)     
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
oReport := TReport():New("INFSCJ","Informe de presupuestos ","INFSCJ",{|oReport| PrintReport(oReport)},"Informe de presupuestos")
oSection := TRSection():New(oReport,"Informe de presupuestos",{"SCJ"},{"Informe de presupuestos"})
//	TRCell():New(/*oSection/, */*X3_CAMPO/, */*Tabla/, */*T�tulo/, */*Picture/, */*Tama�o/, */*lPixel/, */{|| code-block de impresi�n }/)
	TRCell():New(oSection	,"CJ_FILIAL"    ,	"SCJ",) 
	TRCell():New(oSection	,"CJ_EMISSAO"   ,	"SCJ",) 
	TRCell():New(oSection	,"CJ_NUM"	    ,	/*Tabla*/,"Num. Presup.",GetSx3Cache("A1_NOME","X3_PICTURE"),8) 
	TRCell():New(oSection	,"CJ_CLIENTE"	,	/*Tabla*/,"Cod. Cliente",GetSx3Cache("A1_NOME","X3_PICTURE"),8)
	TRCell():New(oSection	,"CJ_LOJA"		,	"SCJ",) 
	TRCell():New(oSection	,"CJ_NOME"		,	/*Tabla*/,"Nombre.Cliente",GetSx3Cache("A1_NOME","X3_PICTURE"),80)
	TRCell():New(oSection	,"CJ_DIROBRA"	,	/*Tabla*/,"Obra",GetSx3Cache("A1_NOME","X3_PICTURE"),80)
	TRCell():New(oSection	,"CJ_XESTADO"	,	"SCJ",)
	TRCell():New(oSection	,"CJ_VALIDA"	,	"SCJ",) 
	TRCell():New(oSection	,"CJ_VALOR"		,	/*Tabla*/,"Valor",GetSx3Cache("D2_TOTAL","X3_PICTURE"),16)
Return oReport

Static Function PrintReport(oReport)
Local oSection 	:= oReport:Section(1)            
Local cAlias 	:= GetNextAlias()    

MakeSqlExp("INFSCJ")
	
BEGIN REPORT QUERY oReport:Section(1)
BeginSql Alias cAlias
	SELECT CJ_FILIAL,CJ_NUM,
	CJ_STATUS,CJ_EMISSAO,
	CJ_CLIENTE,CJ_LOJA,(select A1_NOME from %Table:SA1% where %notdel% and CJ_CLIENTE=A1_COD and CJ_LOJA=A1_LOJA)CJ_NOME,
	(select U5_CONTAT from %Table:SU5% where %notdel% and U5_CODCONT=CJ_XCONTAC) CJ_DIROBRA,CJ_XESTADO,CJ_VALIDA,(select SUM(CK_VALOR) from %Table:SCK% where %notdel% and CK_NUM=CJ_NUM and CK_FILIAL=CJ_FILIAL) CJ_VALOR
	FROM %Table:SCJ% 
	WHERE %notdel% and CJ_NUM>=%exp:MV_PAR01% and CJ_NUM<=%exp:MV_PAR02% and CJ_FILIAL>=%exp:MV_PAR03% and
	 CJ_FILIAL<=%exp:MV_PAR04% and CJ_CLIENTE>=%exp:MV_PAR05% and CJ_CLIENTE<=%exp:MV_PAR06% and 
	 CJ_EMISSAO>=%exp:DTOS(MV_PAR07)% and CJ_EMISSAO<=%exp:DTOS(MV_PAR08)% and CJ_XESTADO>=%exp:MV_PAR09% and CJ_XESTADO<=%exp:MV_PAR10% 
	 and CJ_VEND>=%exp:MV_PAR11% and CJ_VEND<=%exp:MV_PAR12%
	ORDER BY CJ_NOME
EndSql      
	END REPORT QUERY oReport:Section(1) 	
	
oReport:Section(1):Print()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSx1  �Autor �Fernando Cardeza    � Data �  02/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Parametros del Reporte							          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function AjustaSX1(cPerg)
	Local aArea := GetArea()
	Local aRegs := {}, i, j
	
	DbSelectArea("SX1")
	DbSetOrder(1)

	aAdd(aRegs,{cPerg,"01","De Codigo	","De Codigo"    ,"De Codigo"	,"mv_ch1","C",06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","SCJ","" } )
	aAdd(aRegs,{cPerg,"02","A Codigo	","A Codigo	"    ,"A Codigo	"	,"mv_ch2","C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","SCJ","" } ) 
	aAdd(aRegs,{cPerg,"03","De Filial"   ,"De Filial"    ,"De Filial"	,"mv_ch3","C",02,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","SM0","" } )
	aAdd(aRegs,{cPerg,"04","A Filial "	 ,"A Filial "    ,"A Filial "	,"mv_ch4","C",02,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","SM0","" } )
	aAdd(aRegs,{cPerg,"05","De Cliente	","De Cliente"   ,"De Cliente"	,"mv_ch5","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","SA1","" } )
	aAdd(aRegs,{cPerg,"06","A Cliente	","A Cliente"	 ,"A Cliente"	,"mv_ch6","C",06,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","","SA1","" } )
	aAdd(aRegs,{cPerg,"07","De Fecha	","De Fecha"  	 ,"De Fecha"	,"mv_ch7","C",08,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	aAdd(aRegs,{cPerg,"08","A Fecha	"	 ,"A Fecha	"	 ,"A Fecha"		,"mv_ch8","C",08,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )  
	
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
