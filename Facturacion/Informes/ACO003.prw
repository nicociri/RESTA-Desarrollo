#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
#Include "TopConn.CH"
#Include "TOTVS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������                                                         
�������������������������������������������������������������������������Ŀ��
���Programa  �ACO003  � Autor � Fernando Cardeza        � Data �02/12/13  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Informe de saldos por acopio monetario de acopio           ���
���          �                                                            ���
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function ACO003()    

Local oReport
Local cQuery
Local oSection
Private cPerg := "ACO003    "
Private _cTitFun:= ""
Private _cChave := "" 
Private _nTotal := 0

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
Local aOrdem      := {}

oReport := TReport():New(cPerg,"Informe de saldos por acopio monetario de acopio",cPerg,{|oReport| PrintReport(oReport)},"Informe de saldos por acopio monetario de acopio")
oReport:SetLandscape()     //
oReport:SetTotalInLine(.F.)//
oSection := TRSection():New(oReport,"Informe de saldos por acopio monetario de acopio",{},{"Informe de saldos por acopio monetario de acopio"})
TRCell():New(oSection,"ACOPIO") 
TRCell():New(oSection,"FECHA      ","","FECHA        ",GetSx3Cache("D2_EMISSAO","X3_PICTURE"),10) 
TRCell():New(oSection,"DESCRIPCION","","DESCRIPCION","@!",50) 
TRCell():New(oSection,"CLIENTE","","CLIENTE","@!",50) 
TRCell():New(oSection,"SALDO        ","","SALDO        ",GetSx3Cache("D2_TOTAL","X3_PICTURE"),16) 
TRCell():New(oSection,"TOTAL        ","","TOTAL        ",GetSx3Cache("D2_TOTAL","X3_PICTURE"),16) 

Return oReport

Static Function PrintReport(oReport)
//Local cAlias 	:= GetNextAlias()
Local oSection  := oReport:Section(1)
Local oBreak
Local cPart
Local cCase
Local nCont
Local cCodigos          := ""
Local aVerbas          := {}

Pergunte(cPerg,.F.)
	        
cQuery := " SELECT Z01_ACOPIO ACOPIO,'' FECHA,'1-'+Z01_DESC DESCRIPCION,Z01_CLIENT CLIENTE,Z01_XVFAC SALDO, 0 TOTAL "
cQuery += " FROM " + RETSQLNAME("Z01")
cQuery += " WHERE "
cQuery += " Z01_CLIENT BETWEEN '" +MV_PAR03+ "' AND '"+ MV_PAR04 +"' "
cQuery += " AND Z01_ACOPIO BETWEEN '" +MV_PAR01+ "' AND '" +MV_PAR02 +"' "
cQuery += " AND Z01_ACOPIO<>'' AND D_E_L_E_T_='' UNION ALL " 

cQuery += " SELECT F2_XNROACO ACOPIO,F2_EMISSAO FECHA,'2-'+RTRIM(F2_ESPECIE)+'-'+F2_DOC DESCRIPCION,F2_CLIENTE CLIENTE,F2_VALBRUT SALDO, 0 TOTAL "
cQuery += " FROM " + RETSQLNAME("SF2")
cQuery += " WHERE "
cQuery += " F2_CLIENTE BETWEEN '" +MV_PAR03+ "' AND '"+ MV_PAR04 +"' "
cQuery += " AND F2_TIPORET=''" //Es para diferenciar las facturas manuales del inicio del acopio y no traerlas
cQuery += " AND F2_XNROACO BETWEEN '" +MV_PAR01+ "' AND '" +MV_PAR02 +"' "
cQuery += " AND F2_XNROACO<>'' AND D_E_L_E_T_='' AND F2_ESPECIE in ('NF','NDC') UNION ALL "

cQuery += " SELECT F1_XNROACO ACOPIO,F1_EMISSAO FECHA,'3-'+RTRIM(F1_ESPECIE)+'-'+F1_DOC  DESCRIPCION,F1_FORNECE CLIENTE,-F1_VALBRUT SALDO, 0 TOTAL "
cQuery += " FROM " + RETSQLNAME("SF1")
cQuery += " WHERE "
cQuery += " F1_FORNECE BETWEEN '" +MV_PAR03+ "' AND '"+ MV_PAR04 +"' "
cQuery += " AND F1_XNROACO BETWEEN '" +MV_PAR01+ "' AND '" +MV_PAR02 +"' "
cQuery += " AND F1_XNROACO<>'' AND D_E_L_E_T_='' AND F1_ESPECIE not in ('NF','NDC','RFD') "

cQuery += " ORDER BY ACOPIO,DESCRIPCION,CLIENTE"

TcQuery cQuery New Alias cAlias

oSection:Init()
DO While !oReport:Cancel() .And. !cAlias->(EOF())
    IF !EMPTY(_cChave) 
     	IF _cChave <> cAlias->ACOPIO
     		_nTotal := cAlias->SALDO+cAlias->SALDO
     		oReport:ThinLine()
     		//     cAlias->(dbSkip())
     		//     LOOP
     	ENDIF
    ELSE 
    	_nTotal := cAlias->SALDO+cAlias->SALDO
    ENDIF 
     oReport:IncMeter()
     If oReport:Cancel()
          Exit
     EndIf
     //oSection:Init()
     oSection:Cell("ACOPIO"     ):SetBlock( { || cAlias->ACOPIO	 	})
     oSection:Cell("FECHA"      ):SetBlock( { || cAlias->FECHA		}) 
     oSection:Cell("DESCRIPCION"):SetBlock( { || cAlias->DESCRIPCION})
     oSection:Cell("CLIENTE"    ):SetBlock( { || Posicione("SA1",1,xFilial("SA1")+cAlias->CLIENTE,"A1_NOME")})
     oSection:Cell("SALDO"      ):SetBlock( { || cAlias->SALDO     	})
     oSection:Cell("TOTAL" 		):SetBlock( { || _nTotal 			}) 

     _cChave := cAlias->ACOPIO
     If cAlias->SALDO > 0
     	_nTotal := _nTotal - cAlias->SALDO
     EndIf
     oSection:PrintLine()             
     cAlias->(dbSkip())
ENDDO

//oSection:Cell("TOTAL" ):SetBlock( { || _nTotal }) 
//oSection:PrintLine()
cAlias->(DbCloseArea())

oSection:Finish()
//	
//oReport:Section(1):Print()
//#ENDIF
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