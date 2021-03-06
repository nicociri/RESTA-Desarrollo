#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
#Include "TopConn.CH"
#Include "TOTVS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������                                                         
�������������������������������������������������������������������������Ŀ��
���Programa  �ACO005  � Autor � Fernando Cardeza        � Data �02/12/13  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Informe Completo de Acopios					              ���
���          �                                                            ���
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function ACO005()    

Local oReport
Local cQuery
Local oSection
Private cPerg := "ACO005    "
Private _cTitFun:= ""
Private _cChave := "" 
Private _nTotal := 0
Private aGrupo  := {}
Private cPedidos:=""
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
Local cTitulo	  := "Informe de acopio"
Local cDescripcion:= "Informe global de acopio, con tiene las siguientes columnas: N� de Acopio / N� de Vendedor / N� de Cliente / Nombre de Cliente / Fecha de Alta / Fecha de Vencimiento / Nombre de la Obra (contacto) / Monto Inicial (sin Impuestos) / Monto Inicial BK/ Saldo (sin impuestos)/ Saldo BK/ N� de grupos acopiados en lista de acopio)/ Sucursal de Origen."

oReport := TReport():New(cPerg,cTitulo,cPerg,{|oReport| PrintReport(oReport)},cDescripcion)
oReport:SetLandscape()     
oReport:SetTotalInLine(.F.)
oSection := TRSection():New(oReport,"Informe global de acopio 3",{},{"Acopio"})
TRCell():New(oSection,"ACOPIO","","ACOPIO",GetSx3Cache("A1_COD","X3_PICTURE"),7)
TRCell():New(oSection,"VENDEDOR","","VENDEDOR",GetSx3Cache("A1_COD","X3_PICTURE"),7)                     
TRCell():New(oSection,"CLIENTE","","CLIENTE",GetSx3Cache("A1_COD","X3_PICTURE"),7) 
TRCell():New(oSection,"NOMBRE_CLIENTE","","NOMBRE DE CLIENTE","@!",50)                            
TRCell():New(oSection,"FECHA_EMISION","","FECHA DE EMISION",GetSx3Cache("D2_EMISSAO","X3_PICTURE"),12)  
TRCell():New(oSection,"FECHA_VENCIMIENTO","","FECHA DE VENCIMIENTO",GetSx3Cache("D2_EMISSAO","X3_PICTURE"),12)
TRCell():New(oSection,"DIRECCION_DE_OBRA","","DIRECCION DE OBRA","@!",50)                         
TRCell():New(oSection,"SALDO_INICIAL","","SALDO INICIAL",GetSx3Cache("D2_TOTAL","X3_PICTURE"),16) 
TRCell():New(oSection,"SALDO_INICIAL_BK","","SALDO INICIAL BK",GetSx3Cache("D2_TOTAL","X3_PICTURE"),16) 
TRCell():New(oSection,"SALDO","","SALDO",GetSx3Cache("D2_TOTAL","X3_PICTURE"),16) 
TRCell():New(oSection,"SALDO_BK","","SALDO BK",GetSx3Cache("D2_TOTAL","X3_PICTURE"),16)
TRCell():New(oSection,"FAMILIAS","","FAMILIAS","@!",100)  
TRCell():New(oSection,"SUCURSAL","","SUCURSAL","@!",8)  
TRCell():New(oSection,"PEDIDOS","","PEDIDOS","@!",100) 
 
Return oReport

Static Function PrintReport(oReport)
//Local cAlias 	:= GetNextAlias()
Local oSection  := oReport:Section(1)
Local oBreak
Local cPart
Local cCase
Local nCont
Local cCodigos          := ""
Local cPedidos			:= ""
Local cGrupo 			:= ""
Local aVerbas           := {}
Local cDirObra			:= ""
Local cC5_XCONTAC		:= ""

Pergunte(cPerg,.F.)

cQuery := " SELECT "	        
cQuery += " Z01_ACOPIO ACOPIO, "
cQuery += " Z01_TIPO TIPO, "
cQuery += " (SELECT A1_VEND FROM "+ RETSQLNAME("SA1") +" WHERE D_E_L_E_T_='' AND A1_COD=Z01_CLIENT AND A1_LOJA=Z01_LOJA) VENDEDOR,"
cQuery += "	Z01_CLIENT CLIENTE, "
cQuery += "	Z01_NOME NOMBRE_CLIENTE, "
cQuery += "	Z01_EMIS FECHA_EMISION,
cQuery += " Z01_FCHVEN FECHA_VENCIMIENTO, "
cQuery += "	Z01_XDIRO DIRECCION_DE_OBRA, "
cQuery += "	Z01_XENVIO FACTURACION,
cQuery += "	Z01_XVFAC SALDO_INICIAL, " 
cQuery += "	Z01_XVFAC SALDO_INICIAL_BK, "
cQuery += "	0 SALDO, " 
cQuery += "	0 SALDO_BK, "
cQuery += "	Z01_XCDTAB FAMILIAS, "
cQuery += "	Z01_XFILIA SUCURSAL, "
cQuery += "	'' PEDIDOS "
cQuery += " FROM " + RETSQLNAME("Z01")
cQuery += " WHERE "                                                   
cQuery += " Z01_ACOPIO BETWEEN '" +MV_PAR01+ "' AND '" +MV_PAR02 +"' "
cQuery += " AND Z01_CLIENT BETWEEN '" +MV_PAR03+ "' AND '"+ MV_PAR04 +"' "
cQuery += " AND Z01_XFILIA BETWEEN '" +MV_PAR05+ "' AND '" +MV_PAR06 +"' "
cQuery += " AND D_E_L_E_T_='' " 
cQuery += " ORDER BY ACOPIO"

TcQuery cQuery New Alias cAlias

oSection:Init()
DO While !oReport:Cancel() .And. !cAlias->(EOF())
     oReport:IncMeter()
     If oReport:Cancel()
          Exit
     EndIf
     aGRUPO:={}
	
	cQuery := "SELECT SUBSTRING(DA1_CODPRO,1,3) COD,DA1_VLRDES VALOR FROM " + RetSqlName("DA1") 
	cQuery += " WHERE D_E_L_E_T_='' AND DA1_ATIVO = '1' AND DA1_CODTAB='"+ALLTRIM(cAlias->FAMILIAS)+"'"
	cQuery += " GROUP BY SUBSTRING(DA1_CODPRO,1,3),DA1_VLRDES "
	cQuery += " ORDER BY SUBSTRING(DA1_CODPRO,1,3) "
	cQuery := PLSAvaSQL(cQuery)
  	If Select("TODO01") <> 0
		DBSelectArea("TODO01")
		TODO01->(DBCloseArea())
  	EndIf
		PLSQuery(cQuery,"TODO01")
		TODO01->(DBGoTop())
    While TODO01->(!Eof()) 
    		AADD(aGRUPO,TODO01->COD+" ("+ALLTRIM(Transform(TODO01->VALOR, "@E 999.99"))+")")  // GRUPO
   		DbSkip()
	Enddo
     cGrupo:=""
     cGrupo:=fGrupo() //Funcion que trae los grupos acopiados
  	
  	/*********************************************************************************************/
  	cPedidos:=""
	
	cQuery := " SELECT C5_NUM FROM " + RetSqlName("SC5") 
	cQuery += " WHERE D_E_L_E_T_='' AND C5_XNROACO='"+ALLTRIM(cAlias->ACOPIO)+"'"
	cQuery += " GROUP BY C5_NUM "
	cQuery := PLSAvaSQL(cQuery)
  	If Select("TODO01") <> 0
		DBSelectArea("TODO01")
		TODO01->(DBCloseArea())
  	EndIf
		PLSQuery(cQuery,"TODO01")
		TODO01->(DBGoTop())   
		DBSelectArea("TODO01")
    While TODO01->(!Eof()) 
    	cPedidos+=TODO01->C5_NUM +" / "  // GRUPO
   		DbSkip()
	Enddo
    
  	
  	
  	cQuery := "exec [QRY_VAL_ACOPIO_"+SM0->M0_CODIGO+"]'"+ ALLTRIM(cAlias->CLIENTE) +"'"
	cQuery := PLSAvaSQL(cQuery)
  	If Select("TODO01") <> 0
		DBSelectArea("TODO01")
		TODO01->(DBCloseArea())
  	EndIf
		PLSQuery(cQuery,"TODO01")
		TODO01->(DBGoTop())   
		DBSelectArea("TODO01")
    While TODO01->(!Eof()) 
    	If ALLTRIM(TODO01->ACOPIO)==ALLTRIM(cAlias->ACOPIO)
   			cValor:=TODO01->VALOR
   		EndIf
    	DbSkip()
	Enddo
  	If cAlias->FACTURACION=='1'
  		cSaldoIni	:=cAlias->SALDO_INICIAL
  		cSaldoInibk	:=0
  		cSaldo		:=cValor
  		cSaldobk	:=0
  	ElseIf cAlias->FACTURACION=='2' 
  		cSaldoIni	:=0
  		cSaldoInibk	:=cAlias->SALDO_INICIAL
  		cSaldo		:=0
  		cSaldobk	:=cValor
  	Else                    
  		cSaldoIni	:=0
  		cSaldoInibk	:=0
  		cSaldo		:=0
  		cSaldobk	:=0
  	EndIf
//oSection:Init()                               
		oSection:Cell("ACOPIO"     		 ):SetBlock( { || cAlias->ACOPIO		 	})
		oSection:Cell("VENDEDOR"   		 ):SetBlock( { || cAlias->VENDEDOR			})
		oSection:Cell("CLIENTE"		     ):SetBlock( { || cAlias->CLIENTE			})                                                    
		oSection:Cell("NOMBRE_CLIENTE"   ):SetBlock( { || Posicione("SA1",1,xFilial("SA1")+cAlias->CLIENTE,"A1_NOME")})                                                    
		oSection:Cell("FECHA_EMISION"    ):SetBlock( { || CTOD(SUBSTR(cAlias->FECHA_EMISION,7,2) +"/"+ SUBSTR(cAlias->FECHA_EMISION,5,2) +"/"+ SUBSTR(cAlias->FECHA_EMISION,1,4))	 })                                                     
		oSection:Cell("FECHA_VENCIMIENTO"):SetBlock( { || CTOD(SUBSTR(cAlias->FECHA_VENCIMIENTO,7,2) +"/"+ SUBSTR(cAlias->FECHA_VENCIMIENTO,5,2) +"/"+ SUBSTR(cAlias->FECHA_VENCIMIENTO,1,4))})                                                 
		oSection:Cell("DIRECCION_DE_OBRA"):SetBlock( { || cAlias->DIRECCION_DE_OBRA	})                                           
//		oSection:Cell("FACTURACION"  	 ):SetBlock( { || cAlias->FACTURACION		})                                                       
		oSection:Cell("SALDO_INICIAL"	 ):SetBlock( { || cSaldoIni					})
		oSection:Cell("SALDO_INICIAL_BK" ):SetBlock( { || cSaldoInibk				}) 
		oSection:Cell("SALDO"			 ):SetBlock( { || cSaldo					})
		oSection:Cell("SALDO_BK"   	 	 ):SetBlock( { || cSaldobk					})                                         
		oSection:Cell("FAMILIAS"    	 ):SetBlock( { || cGrupo					})                                           
		oSection:Cell("SUCURSAL"     	 ):SetBlock( { || cAlias->SUCURSAL			})
		oSection:Cell("PEDIDOS"     	 ):SetBlock( { || cPedidos					})
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

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funci�n     � IMPDETAL � Autor � Ariel A. Musumeci   � Data � 08.05.00 ���
�������������������������������������������������������������������������Ĵ��
���Descripci�n � Rutina de Impresi�n de Detalles.                         ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
/*/
Static Function fGrupo()
Local cGrupo:=""  

For l:=1 to LEN(aGRUPO)	
 cGrupo+=aGRUPO[l]
 If LEN(aGRUPO)>l
  	cGrupo+=" - "
 EndIf
Next
Return (cGRUPO)
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

	aAdd(aRegs,{cPerg,"01","De Acopio	","De Acopio	","De Acopio	","mv_ch1","C",06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","Z01","","" } )
	aAdd(aRegs,{cPerg,"02","A Acopio 	","A Acopio 	","A Acopio 	","mv_ch2","C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","Z01","","" } )
	aAdd(aRegs,{cPerg,"03","De Cliente	","De Cliente	","De Cliente	","mv_ch3","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","" } )
	aAdd(aRegs,{cPerg,"04","A Cliente	","A Cliente	","A Cliente	","mv_ch4","C",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","" } )
	aAdd(aRegs,{cPerg,"05","De Sucursal	","De Sucursal	","De Sucursal	","mv_ch5","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","" } )
	aAdd(aRegs,{cPerg,"06","A Sucursal	","A Sucursal	","A Sucursal	","mv_ch6","C",06,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","" } )
	
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
