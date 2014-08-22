#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������                                                         
�������������������������������������������������������������������������Ŀ��
���Programa  �ABMZ03  � Autor � Fernando Cardeza        � Data �02/12/13  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Informe de cumplea�os                                      ���
���          �                                                            ���
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function Z03ABMI()

Local oReport
Local oSection
Local cPerg := "Z03ABMI   "

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
oReport := TReport():New("Z03ABMI","Informes de cumplea�os ","Z03ABMI",{|oReport| PrintReport(oReport)},"Informes de cumplea�os")
oSection := TRSection():New(oReport,"Informes de cumplea�os",{"Z03"},{"Informes de cumpla�os"})
//	TRCell():New(/*oSection/, */*X3_CAMPO/, */*Tabla/, */*T�tulo/, */*Picture/, */*Tama�o/, */*lPixel/, */{|| code-block de impresi�n }/)
	TRCell():New(oSection	,"Z03_COD"    ,	/*Tabla*/,"Codigo") 
	TRCell():New(oSection	,"Z03_NOME"   ,	/*Tabla*/,"Nombre") 
	TRCell():New(oSection	,"Z03_CLIFOR" ,	/*Tabla*/,"Cod. Cli/Prov") 
	TRCell():New(oSection	,"Z03_LOJA"	  ,	/*Tabla*/,"Tienda") 
	TRCell():New(oSection	,"Z03_NOMEP"  ,	/*Tabla*/,"Nombre.Cli/Prov") 
	TRCell():New(oSection	,"Z03_FECHA"  ,	"Z03"    ,"Fecha Cump.") 
	TRCell():New(oSection	,"Z03_ANOS"	  ,	/*Tabla*/,"Edad") 
Return oReport

Static Function PrintReport(oReport)
Local oSection 	:= oReport:Section(1)            
Local cAlias 	:= GetNextAlias()    


cStatement:="exec [FECHA]'"+MV_PAR01+"','"+MV_PAR02+"','"+MV_PAR03+"','%"+ALLTRIM(MV_PAR04)+"%'"
If (TCSQLExec(cStatement) < 0)
    Return MsgStop("TCSQLError() " + TCSQLError())
EndIf     

MakeSqlExp("Z03ABMI")
	
BEGIN REPORT QUERY oReport:Section(1)
BeginSql Alias cAlias
	SELECT Z03_COD,Z03_NOME,Z03_CLIFOR,Z03_LOJA,Z03_NOMEP,Z03_FECHA,Z03_ANOS FROM TMPZ03
EndSql      
	END REPORT QUERY oReport:Section(1) 	
	
oReport:Section(1):Print()
cStatement:="DROP TABLE TMPZ03"
If (TCSQLExec(cStatement) < 0)
    Return MsgStop("TCSQLError() " + TCSQLError())
EndIf     
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

	aAdd(aRegs,{cPerg,"01","De Codigo	","De Codigo"    ,"De Codigo","mv_ch1","C",12,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	aAdd(aRegs,{cPerg,"02","A Codigo	","A Codigo	"    ,"A Codigo	","mv_ch2","C",12,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","" } ) 
	aAdd(aRegs,{cPerg,"03","Mes	"        ,"Mes"    ,     "Mes"       ,"mv_ch3","C",02,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	aAdd(aRegs,{cPerg,"04","Nombre	    ","Nombre	"    ,"Nombre	","mv_ch4","C",20,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	
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
