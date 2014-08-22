#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ARFISF06 บ Autor ณ Totvs              บ Data ณ  08/04/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Genera Archivo de Retenciones                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ARCIBA                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function ARFISF06()
    
	Local 	aStruRETN:={}
	Local 	aStruRETC:={}	
	Private cArqTrabN:=""
	Private cArqTrabC:=""		
	Private aArqTrab:={}

	//Estrutura para nota fiscal  normal - Informacoes para ini        
	Aadd(aStruRETN,{"TIPOPER"  ,"C",01,0}) //Tipo de Operaci๓n
	Aadd(aStruRETN,{"CODNOR"   ,"C",03,0}) //Codigo de Norma
	Aadd(aStruRETN,{"EMISSAO"  ,"C",10,0}) //Fecha de Retenci๓n
	Aadd(aStruRETN,{"TIPOCOM"  ,"C",02,0}) //Tipo de Comprobante
	Aadd(aStruRETN,{"LETRA"    ,"C",01,0}) //Letra de Comprobante
	Aadd(aStruRETN,{"COMPROB"  ,"C",15,0}) //Numero de Comprobante
	Aadd(aStruRETN,{"FECHA"    ,"C",10,0}) //Fecha de Comprobante
	Aadd(aStruRETN,{"MONTO"    ,"N",09,2}) //Monto
	Aadd(aStruRETN,{"NROCERT"  ,"C",16,0}) //Nro Certificado Proprio
	Aadd(aStruRETN,{"TIPODOC"  ,"C",01,0}) //Tipo de Documento
	Aadd(aStruRETN,{"DOCUM"    ,"C",11,0}) //Numero de Documento
	Aadd(aStruRETN,{"SITIB"    ,"C",01,0}) //Situaci๓n Ingresos Brutos
	Aadd(aStruRETN,{"NROIB"    ,"C",10,0}) //Nro. Inscrici๓n Ingresos Brutos
	Aadd(aStruRETN,{"SITIVA"   ,"C",01,0}) //Situaci๓n IVA
	Aadd(aStruRETN,{"RAZON"    ,"C",30,0}) //Raz๓n Social del Retenido
	Aadd(aStruRETN,{"OUTROSCON","C",10,0}) //Otros Conceptos
	Aadd(aStruRETN,{"IVA"      ,"C",10,0}) //IVA
	Aadd(aStruRETN,{"MONTOSU"  ,"N",09,2}) //Monto Sujeto a Ret./Percep.
	Aadd(aStruRETN,{"ALIQ"     ,"N",09,2}) //Alํcuota
	Aadd(aStruRETN,{"RETPRA"   ,"N",09,2}) //Ret./Percep. Practicadas
	Aadd(aStruRETN,{"MONTORET" ,"N",09,2}) //Total Monto Retenido
		
	cArqTrabN:=CriaTrab(aStruRETN,.T.,'dbf')
	dbUseArea(.T.,"DBFCDX",cArqTrabN,'TRBn')
	aAdd(aArqTrab,{cArqTrabN,'TRBn'})
	
	//Estrutura para NF de credito
	Aadd(aStruRETC,{"TIPOPER"  ,"C",01,0}) //Tipo de Operaci๓n
	Aadd(aStruRETC,{"NRONFC"   ,"C",12,0}) //Numero da NF de credito
	Aadd(aStruRETC,{"EMISSAO"  ,"C",10,0}) //Fecha de NF credito    
	Aadd(aStruRETC,{"MONTO"    ,"N",14,2}) //monto
	Aadd(aStruRETC,{"NROCERT"  ,"C",16,0}) //Nro Certificado Proprio
	Aadd(aStruRETC,{"TIPOCOM"  ,"C",02,0}) //Tipo de Comprobante
	Aadd(aStruRETC,{"LETRA"    ,"C",01,0}) //Letra de Comprobante
	Aadd(aStruRETC,{"COMPROB"  ,"C",15,0}) //Numero de Comprobante
	Aadd(aStruRETC,{"EMIOP"    ,"C",10,0}) //Fecha de Retenci๓n Orden de pago original
	Aadd(aStruRETC,{"COMOP"    ,"C",15,0}) //Numero de Comprobante Orden de pago original
	Aadd(aStruRETC,{"ALIQ"     ,"N",09,2}) //Alํcuota OP original
	Aadd(aStruRETC,{"RETPRA"   ,"N",14,2}) //Ret./Percep. Practicadas original
	
	cArqTrabC := CriaTrab(aStruRETC,.T.,'dbf')
	dbUseArea(.T.,"DBFCDX",cArqTrabC,'TRBc')	
	aAdd(aArqTrab,{cArqTrabC,'TRBc'})
	
	If _aTotal[7][1][3] =='1'//Retencao
		FRET()
	ElseIf _aTotal[7][1][3] == '2'//Percepcao
		FPER()	
	ElseIf _aTotal[7][1][3] =='3'//ambos
		FAMB()	
	EndIf	

Return aArqTrab

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FRET     บ Autor ณ Totvs              บ Data ณ  03/05/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Genera Archivo de Retenciones                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ARCIBA                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function FRET() 	
	
	Local cQueryn:= ""
    Local cQueryc:= "" 
	
	If Substr(_aTotal[07][01][04],1,1) =="1"//Retencion

		//Query para Retenci๓n 
		cQueryn:=" SELECT '1' TIPOPER,'008' CODNOR,SFE.FE_EMISSAO EMISSAO,'03' TIPOCOM,' ' LETRA,SFE.FE_ORDPAGO COMPROB,"+CRLF
		cQueryn+=" SFE.FE_EMISSAO FECHA,SFE.FE_VALBASE MONTO,SFE.FE_NROCERT NROCERT,'2' TIPODOC,SA2.A2_CGC DOCUM,"+CRLF
	 	cQueryn+=" CASE WHEN FH_TIPO IS NULL THEN '4'"+CRLF
	 	cQueryn+=" 		ELSE"+CRLF
	 	cQueryn+=" 			CASE SFH.FH_TIPO	WHEN 'V' THEN '2'"+CRLF
	 	cQueryn+="  		   				    WHEN 'N' THEN '4'"+CRLF
	 	cQueryn+="  		ELSE"+CRLF
	 	cQueryn+=" 				'1'"+CRLF
	 	cQueryn+=" 			END"+CRLF 
	 	cQueryn+=" 		END AS SITIB,"+CRLF
		cQueryn+=" SA2.A2_NROIB NROIB,"+CRLF
		cQueryn+="        CASE  SA2.A2_TIPO WHEN 'I' THEN '1'"+CRLF   
        cQueryn+="                          WHEN 'N' THEN '2'"+CRLF   
        cQueryn+="                          WHEN 'X' THEN '3'"+CRLF
		cQueryn+="                          WHEN 'M' THEN '4'"+CRLF 
		cQueryn+="	                        ELSE          '5'"+CRLF 
		cQueryn+="				            END SITIVA,"+CRLF 
		cQueryn+=" SA2.A2_NOME RAZON,'0000000,00' OUTROSCON,'0000000,00' IVA,FE_VALBASE MONTOSU,FE_ALIQ ALIQ,"+CRLF
		cQueryn+=" SFE.FE_RETENC MONTORET"+CRLF		
		cQueryn+=" FROM "+RetSqlName('SFE')+" SFE"+CRLF
		cQueryn+=" LEFT JOIN "+RetSqlName('SA2')+" SA2"+CRLF 
        cQueryn+=" ON SFE.FE_FORNECE=SA2.A2_COD AND SFE.FE_LOJA=SA2.A2_LOJA AND SA2.A2_FILIAL='"+xFilial('SA2')+"' AND SA2.D_E_L_E_T_=''"+CRLF  
		cQueryn+=" LEFT JOIN (SELECT DISTINCT FH_TIPO,FH_FORNECE,FH_LOJA,FH_FILIAL,D_E_L_E_T_ FROM "+RetSqlName('SFH')+CRLF
		cQueryn+=" WHERE FH_ZONFIS='CF' AND FH_FORNECE <> '') SFH"+CRLF 
        cQueryn+=" ON SFH.FH_FORNECE = SA2.A2_COD AND SFH.FH_LOJA = SA2.A2_LOJA AND SFH.FH_FILIAL='"+xFilial('SFH')+"' AND SFH.D_E_L_E_T_ =''"+CRLF
		cQueryn+=" WHERE FE_FILIAL = '"+xFilial('SFE')+"'"+CRLF
		cQueryn+=" AND SFE.FE_FORNECE <> ''"+CRLF
		cQueryn+=" AND SFE.FE_NROCERT <> 'NORET'"+CRLF
		cQueryn+=" AND SFE.FE_TIPO='B'"+CRLF		
		cQueryn+=" AND SFE.FE_EST='CF'"+CRLF
		cQueryn+=" AND SFE.FE_VALBASE > 0"+CRLF
		cQueryn+=" AND SFE.FE_EMISSAO BETWEEN '"+dTOs(MV_PAR01)+"' AND '"+dTOs(MV_PAR02)+"'"+CRLF
		cQueryn+=" AND (FE_DTESTOR='' OR FE_DTESTOR >'"+dTOs(MV_PAR02)+"')"+CRLF
		cQueryn+=" AND SFE.D_E_L_E_T_ = '' "+CRLF
		cQueryn+=" ORDER BY SFE.FE_EMISSAO"+CRLF		
		
		cQueryn:=ChangeQuery(cQueryn)	
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryn),"TRAN",.T.,.F.)
		
		TCSetField("TRAN","MONTO"    ,"N",09,02)
		TCSetField("TRAN","MONTOSU"  ,"N",09,02)		
		TCSetField("TRAN","ALIQ"     ,"N",02,02)
		TCSetField("TRAN","MONTORET" ,"N",09,02)
		TCSetField("TRAN","EMISSAO"  ,"D",08,00)
		TCSetField("TRAN","FECHA"    ,"D",08,00)	   	
	     
		TRAn->(dbGotop())
		
		While TRAn->(!Eof())
			
			dbSelectArea("TRBn")
			
			//cria tabela temporaria para geracao do txt
			If RecLock("TRBn",.T.) 
				TRBn->TIPOPER   := TRAn->TIPOPER
				TRBn->CODNOR    := TRAn->CODNOR
				TRBn->EMISSAO   := ConvDat(TRAn->EMISSAO)
				TRBn->TIPOCOM   := TRAn->TIPOCOM
				TRBn->LETRA     := TRAn->LETRA    
				TRBn->COMPROB   := TRAn->COMPROB
				TRBn->FECHA     := ConvDat(TRAn->FECHA)
				TRBn->MONTO     := ROUND(TRAn->MONTO,2) 
				TRBn->NROCERT   := TRAn->NROCERT  
				TRBn->TIPODOC   := TRAn->TIPODOC  
				TRBn->DOCUM     := TRAn->DOCUM 
				TRBn->SITIB     := TRAn->SITIB    
 			 TRBn->SITIB     := IF(EMPTY(ALLTRIM(TRAn->NROIB)),'4',TRAn->SITIB )
				TRBn->NROIB     := TRAn->NROIB
				TRBn->SITIVA    := TRAn->SITIVA
				TRBn->RAZON     := Substr(TRAn->RAZON,1,30)
				TRBn->OUTROSCON := TRAN->OUTROSCON
				TRBn->IVA       := TRAN->IVA 
				TRBn->MONTOSU   := ROUND(TRAn->MONTOSU,2)
				TRBn->ALIQ      := ROUND(TRAn->ALIQ,2)
				TRBn->RETPRA    := ROUND(((TRAn->MONTO*TRAn->ALIQ)/100),2)
				TRBn->MONTORET  := ROUND(TRAn->MONTORET,2)
			EndIf
			MsUnlock()
			TRAn->(dbSkip())
		End
    
    	If MsgYesNo("ฟVerificar los datos para la exportacion?")
			 TRelARCIBA('TRBn')
		EndIf
	
	    TRAn->(dbCloseArea())
        
    ElseIf Substr(_aTotal[07][01][04],1,1) =="2"
    
	    //Query para Estorno de retencion
		cQueryc:=" SELECT '1' TIPOPER,CASE WHEN SFE.FE_ORDPAGO='' THEN SFE.FE_NFISCAL ELSE SFE.FE_ORDPAGO END NRONFC,SFE.FE_EMISSAO EMISSAO,SFE.FE_RETENC RETPRA, "+CRLF
		cQueryc+=" SFE.FE_VALBASE MONTO,SFE.FE_NRETORI NROCERT,'03' TIPOCOM,' ' LETRA,SFE.FE_ORDPAGO COMPROB, SFE.FE_DTRETOR EMIOP, SFE.FE_ORDPAGO COMOP, SFE.FE_ALIQ ALIQ "+CRLF
		cQueryc+=" FROM "+RetSqlName('SFE')+" SFE"+CRLF
		cQueryc+=" WHERE FE_FILIAL = '"+xFilial('SFE')+"'"+CRLF
		cQueryc+=" AND SFE.FE_FORNECE <>''"+CRLF
		cQueryc+=" AND SFE.FE_NROCERT <> 'NORET' "+CRLF
		cQueryc+=" AND SFE.FE_TIPO='B'"+CRLF
		cQueryc+=" AND SFE.FE_EST='CF'"+CRLF
		cQueryc+=" AND SFE.FE_VALBASE < 0 "+CRLF
		cQueryc+=" AND SFE.FE_DTRETOR < '"+dTOs(MV_PAR01)+"'"+CRLF			
		cQueryc+=" AND SFE.FE_DTESTOR BETWEEN '"+dTOs(MV_PAR01)+"' AND '"+dTOs(MV_PAR02)+"'"+CRLF 

		cQueryc+=" AND SFE.D_E_L_E_T_ = '' "+CRLF
		cQueryc+=" ORDER BY SFE.FE_NRETORI "+CRLF
	
		cQueryc:=ChangeQuery(cQueryc)	

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryc),"TRAc",.T.,.F.)
		
		TCSetField("TRAc","MONTO"  ,"N",09,02)
		TCSetField("TRAc","EMISSAO","D",08,00)
		TCSetField("TRAc","EMIOP","D",08,00)
		
		TRAc->(dbGotop())
		
		While TRAc->(!Eof())
	
			dbSelectArea("TRBc")
			
			If RecLock("TRBc",.T.) 
				TRBc->TIPOPER := TRAc->TIPOPER
				TRBc->NRONFC  := TRAc->NRONFC
				TRBc->EMISSAO := ConvDat(TRAc->EMISSAO)
				TRBc->MONTO   := ROUND(If(TRAc->MONTO < 0,TRAc->MONTO *(-1),TRAc->MONTO),2) 
				TRBc->NROCERT := TRAc->NROCERT  
				TRBc->TIPOCOM := TRAc->TIPOCOM
				TRBc->LETRA   := TRAc->LETRA    
				TRBc->COMPROB := TRAc->COMPROB
				TRBc->EMIOP   := ConvDat(TRAc->EMIOP)
				TRBc->COMOP   := TRAc->COMOP
				TRBc->ALIQ    := ROUND(TRAc->ALIQ,2)
				TRBc->RETPRA  := If(TRAc->RETPRA < 0, TRAc->RETPRA * (-1),TRAc->RETPRA)
			EndIf
			MsUnlock()
			TRAc->(dbSkip())
		End
	    
       	If MsgYesNo("ฟVerificar los datos para la exportacion?")
			 TRelARCIBA('TRBc')
		EndIf
	    
	    TRAc->(dbCloseArea())
	EndIf
Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FPERC    บ Autor ณ Totvs              บ Data ณ  08/04/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Genera Archivo de Percepcion                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ARCIBA                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function FPER()
    
	Local cQueryn := ""
	Local cQueryc := "" 
	Local aLivros := {}
    Local nBas    := 0
    Local nAliq   := 0
	Local nVal    := 0
	
	//busca numero dos livros no arquivo SFB e monta o campo de acordo com on numero do livro
	aLivros:=BUSCASFB()
	
	If Len(aLivros)	<> 0
	
		If Substr(_aTotal[07][01][04],1,1) =="1" 
				
			//Query para Percepcion 
			cQueryn:=" SELECT '2' TIPOPER,'014' CODNOR,SF3.F3_EMISSAO EMISSAO,"+CRLF
			cQueryn+=" SF3.F3_ESPECIE AS GM1, SF3.F3_SERIE GM2,"
			cQueryn+=" SF3.F3_SERIE LETRA,SF3.F3_NFISCAL COMPROB,SF3.F3_EMISSAO FECHA,SF3.F3_VALCONT MONTO,"+CRLF
			cQueryn+=" '' NROCERT,'2' TIPODOC,SA1.A1_CGC DOCUM,"+CRLF
		 	cQueryn+=" CASE WHEN FH_TIPO IS NULL THEN '4'"+CRLF
		 	cQueryn+=" 		ELSE"+CRLF
		 	cQueryn+=" 			CASE SFH.FH_TIPO	WHEN 'V' THEN '2'"+CRLF
		 	cQueryn+="  		   				    WHEN 'N' THEN '4'"+CRLF
		 	cQueryn+="  		ELSE"+CRLF
		 	cQueryn+=" 				'1'"+CRLF
		 	cQueryn+=" 			END"+CRLF
		 	cQueryn+=" 		END AS SITIB,"+CRLF
			//cQueryn+=" SA1.A1_INSCR NROIB,"+CRLF
			cQueryn+=" SA1.A1_NIGB NROIB,"+CRLF
			cQueryn+="        CASE  SA1.A1_TIPO WHEN 'I' THEN '1'"+CRLF
			cQueryn+="                          WHEN 'N' THEN '2'"+CRLF
			cQueryn+="     		                WHEN 'X' THEN '3'"+CRLF
			cQueryn+="				            WHEN 'M' THEN '4'"+CRLF
			cQueryn+="		  ELSE                            '5'"+CRLF
			cQueryn+="		  END AS SITIVA,"+CRLF
			cQueryn+=" SA1.A1_NOME RAZON,'0000000,00' OUTROSCON,'0000000,00' IVA,"+CRLF
	
			// ADICIONA CAMPOS DE ACORDO COM O NUMERO DO LIVRO FISCAL EX: F3_BASIMP+1 == BASIMP1
			//CASO EXISTA MAIS DE UM LIVRO OS CAMPOS SERAO SOMADOS   EX: BASIMP1 + BASIMP2 ...    
			
			//BASE PARA IMPOSTO
			For nBas:=1 To Len(aLivros)
		
				If nBas < Len(aLivros)
					cQueryn+=" SF3.F3_BASIMP"+aLivros[nBas]+"+"+CRLF
				Else	
					cQueryn+=" SF3.F3_BASIMP"+aLivros[nBas]+" "	+CRLF
				EndIf
	
			Next		
			cQueryn+=" AS MONTOSU,"+CRLF
			
			//ALIQUOTA			
			For nAliq:=1 To Len(aLivros)
	
				If nAliq <  Len(aLivros) 
					cQueryn+=" SF3.F3_ALQIMP"+aLivros[nAliq]+"+"+CRLF
				Else
					cQueryn+=" SF3.F3_ALQIMP"+aLivros[nAliq]+" "+CRLF		
				EndIf
	
			Next	
			cQueryn+=" AS ALIQ,"+CRLF
			
			//TOTAL MONTO RETIDO 		
			For nVal:=1 To Len(aLivros)
	
				If nVal  <  Len(aLivros)  
					cQueryn+=" SF3.F3_VALIMP"+aLivros[nVal]+"+"+CRLF
				Else
					cQueryn+=" SF3.F3_VALIMP"+aLivros[nVal]+" "+CRLF
				EndIf		
	
			Next		
			cQueryn+=" AS MONTORET"+CRLF
			
			cQueryn+=" FROM "+RetSqlName('SF3')+" SF3"+CRLF
			cQueryn+=" LEFT JOIN "+RetSqlName('SA1')+" SA1"+CRLF
	        cQueryn+=" ON SF3.F3_CLIEFOR=SA1.A1_COD AND SF3.F3_LOJA=SA1.A1_LOJA AND SA1.A1_FILIAL='"+xFilial('SA1')+"' AND SA1.D_E_L_E_T_=''"+CRLF
			cQueryn+=" LEFT JOIN (SELECT  DISTINCT FH_TIPO,FH_CLIENTE,FH_LOJA,FH_FILIAL,D_E_L_E_T_ FROM "+RetSqlName('SFH')+CRLF
			cQueryn+=" WHERE FH_ZONFIS='CF' AND FH_CLIENTE <>'') SFH"+CRLF	
	        cQueryn+=" ON SFH.FH_CLIENTE = SA1.A1_COD AND SFH.FH_LOJA = SA1.A1_LOJA AND SFH.FH_FILIAL='"+xFilial('SFH')+"' AND SFH.D_E_L_E_T_ =''"+CRLF
			cQueryn+=" WHERE F3_FILIAL = '"+xFilial('SF3')+"'"+CRLF
			cQueryn+=" AND F3_TIPOMOV='V'"+CRLF
			For nVal:=1 To Len(aLivros)		
				cQueryn+=" AND SF3.F3_BASIMP"+aLivros[1]+" <> 0 "+CRLF
			Next
			cQueryn+=" AND SUBSTRING(SF3.F3_ESPECIE,1,2) <> 'NC'"+CRLF
			cQueryn+=" AND SF3.F3_EMISSAO BETWEEN '"+dTOs(MV_PAR01)+ "' AND '"+dTOs(MV_PAR02)+"'"+CRLF
		    cQueryn+=" AND SF3.F3_DTCANC=''"
		    cQueryn+=" AND SF3.D_E_L_E_T_ = ''"+CRLF
			cQueryn+=" ORDER BY SF3.F3_EMISSAO"+CRLF
		
			cQueryn:=ChangeQuery(cQueryn)	
	
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryn),"TRAN",.T.,.F.)
			
			TCSetField("TRAN","MONTO"   ,"N",09,02)
			TCSetField("TRAN","MONTOSU" ,"N",09,02)
			TCSetField("TRAN","ALIQ"    ,"N",02,02)		
			TCSetField("TRAN","MONTORET","N",09,02)
			TCSetField("TRAN","EMISSAO" ,"D",08,00)
			TCSetField("TRAN","FECHA"   ,"D",08,00)
	
			TRAn->(dbGotop())
			
			While TRAn->(!Eof())
				
				dbSelectArea("TRBn")
				
				If RecLock("TRBn",.T.) 
					TRBn->TIPOPER   := TRAn->TIPOPER
					TRBn->CODNOR    := TRAn->CODNOR
					TRBn->EMISSAO   := ConvDat(TRAn->EMISSAO)
					TRBn->TIPOCOM   := TipoCom(TRAn->GM1,TRAn->GM2)
					TRBn->LETRA     := TRAn->LETRA    
					TRBn->COMPROB   := TRAn->COMPROB
					TRBn->FECHA     := ConvDat(TRAn->FECHA)
					TRBn->MONTO     := ROUND(TRAn->MONTO,2) 
					TRBn->NROCERT   := TRAn->NROCERT  
					TRBn->TIPODOC   := TRAn->TIPODOC  
					TRBn->DOCUM     := TRAn->DOCUM 
					TRBn->SITIB     := TRAn->SITIB
 			 TRBn->SITIB     := IF(EMPTY(ALLTRIM(TRAn->NROIB)),'4',TRAn->SITIB )
					TRBn->NROIB     := TRAn->NROIB
					TRBn->SITIVA    := TRAn->SITIVA
					TRBn->RAZON     := SubStr(TRAn->RAZON,1,30)
					TRBn->OUTROSCON := TRAN->OUTROSCON
					TRBn->IVA       := TRAn->IVA
					TRBn->MONTOSU   := ROUND(TRAn->MONTOSU,2)
					TRBn->ALIQ      := ROUND(TRAn->ALIQ,2)
					TRBn->RETPRA    := ROUND(TRAn->MONTORET,2)//((TRAn->MONTOSU * TRBn->ALIQ)/100 ,2)
					TRBn->MONTORET  := ROUND(TRAn->MONTORET,2)
				EndIf
				MsUnlock()
				TRAn->(dbSkip())
			End
		    
	       	If MsgYesNo("ฟVerificar los datos para la exportacion?")
				 TRelARCIBA('TRBn')
			EndIf
		   
		ElseIf Substr(_aTotal[07][01][04],1,1) =="2"
	    
			//QUERY PARA  NF DE CREDITO
			cQueryc:=" SELECT '2' TIPOPER,SF3.F3_NFISCAL NRONFC,SF3.F3_EMISSAO EMISSAO,"+CRLF
			//BASE PARA IMPOSTO
			For nBas:=1 To Len(aLivros)
				If nBas < Len(aLivros)
					cQueryc+=" SF3.F3_BASIMP"+aLivros[nBas]+"+"	+CRLF
				Else	
					cQueryc+=" SF3.F3_BASIMP"+aLivros[nBas]+" "+CRLF
				EndIf
			Next		
			cQueryc+=" AS MONTO,"+CRLF	
			cQueryc+=" ' '  NROCERT,"+CRLF
			cQueryc+=" CASE WHEN EXISTS(SELECT D2_ESPECIE FROM "+RetSqlName('SD2')+" WHERE D2_DOC=SD2.D2_NFORI AND D2_SERIE=SD2.D2_SERIORI AND D2_CLIENTE=SD2.D2_CLIENTE AND D2_LOJA=SD2.D2_LOJA AND D_E_L_E_T_='' AND D2_FILIAL=SD2.D2_FILIAL ) THEN"+CRLF 
			cQueryc+="      (SELECT D2_ESPECIE FROM "+RetSqlName('SD2')+" WHERE D2_DOC=SD2.D2_NFORI AND D2_SERIE=SD2.D2_SERIORI AND D2_CLIENTE=SD2.D2_CLIENTE AND D2_LOJA=SD2.D2_LOJA AND D_E_L_E_T_='' AND D2_FILIAL=SD2.D2_FILIAL)"+CRLF 
			cQueryc+=" ELSE"+CRLF 
			cQueryc+="		CASE WHEN EXISTS(SELECT D2_ESPECIE FROM "+RetSqlName('SD2')+" WHERE D2_DOC=SD1.D1_NFORI AND D2_SERIE=SD1.D1_SERIORI AND D2_CLIENTE=SD1.D1_FORNECE AND D2_LOJA=SD1.D1_LOJA AND D_E_L_E_T_='' AND D2_FILIAL=SD1.D1_FILIAL ) THEN"+CRLF 
			cQueryc+="  		(SELECT D2_ESPECIE FROM "+RetSqlName('SD2')+" WHERE D2_DOC=SD1.D1_NFORI AND D2_SERIE=SD1.D1_SERIORI AND RIGHT(D2_ITEM,2)=SD1.D1_ITEMORI AND D2_CLIENTE=SD1.D1_FORNECE AND D2_LOJA=SD1.D1_LOJA AND D_E_L_E_T_='' AND D2_FILIAL=SD1.D1_FILIAL)"+CRLF 
			cQueryc+=" 		ELSE"+CRLF 
			cQueryc+="  		CASE WHEN EXISTS(SELECT D1_ESPECIE FROM "+RetSqlName('SD1')+" WHERE D1_DOC=SD1.D1_NFORI AND D1_SERIE=SD1.D1_SERIORI AND D1_FORNECE=SD1.D1_FORNECE AND D1_LOJA=SD1.D1_LOJA AND D_E_L_E_T_='' AND D1_FILIAL=SD1.D1_FILIAL ) THEN"+CRLF 
			cQueryc+=" 				(SELECT D1_ESPECIE FROM "+RetSqlName('SD1')+" WHERE D1_DOC=SD1.D1_NFORI AND D1_SERIE=SD1.D1_SERIORI AND RIGHT(D1_ITEM,2)=SD1.D1_ITEMORI AND D1_FORNECE=SD1.D1_FORNECE AND D1_LOJA=SD1.D1_LOJA AND D_E_L_E_T_='' AND D1_FILIAL=SD1.D1_FILIAL)"+CRLF 
			cQueryc+="  		ELSE"+CRLF 
			cQueryc+=" 				CASE WHEN EXISTS(SELECT D1_ESPECIE FROM "+RetSqlName('SD1')+" WHERE D1_DOC=SD2.D2_NFORI AND D1_SERIE=SD2.D2_SERIORI AND D1_FORNECE=SD2.D2_CLIENTE AND D1_LOJA=SD2.D2_LOJA AND D_E_L_E_T_='' AND D1_FILIAL=SD2.D2_FILIAL ) THEN"+CRLF 
			cQueryc+=" 					(SELECT D1_ESPECIE FROM "+RetSqlName('SD1')+" WHERE D1_DOC=SD2.D2_NFORI AND D1_SERIE=SD2.D2_SERIORI AND RIGHT(D1_ITEM,2)=SD2.D2_ITEMORI AND D1_FORNECE=SD2.D2_CLIENTE AND D1_LOJA=SD2.D2_LOJA AND D_E_L_E_T_='' AND D1_FILIAL=SD2.D2_FILIAL)"+CRLF 
			cQueryc+="  			ELSE"+CRLF 
			cQueryc+="  				CASE WHEN SD1.D1_ESPECIE='NCC' THEN" +CRLF
			cQueryc+=" 						' '"+CRLF 
			cQueryc+=" 			   		ELSE"+CRLF 
			cQueryc+=" 						' '"+CRLF 
			cQueryc+=" 					END"+CRLF 
			cQueryc+="  			END"+CRLF 
			cQueryc+="  		END"+CRLF 
			cQueryc+=" 		END"+CRLF 
	 		cQueryc+=" END AS GM1,"+CRLF 
			cQueryc+=" CASE WHEN EXISTS(SELECT D2_ESPECIE FROM "+RetSqlName('SD2')+" WHERE D2_DOC=SD2.D2_NFORI AND D2_SERIE=SD2.D2_SERIORI AND D2_CLIENTE=SD2.D2_CLIENTE AND D2_LOJA=SD2.D2_LOJA AND D_E_L_E_T_='' AND D2_FILIAL=SD2.D2_FILIAL ) THEN"+CRLF
			cQueryc+="		SD2.D2_SERIORI"+CRLF 
			cQueryc+=" ELSE"+CRLF 
			cQueryc+="		CASE WHEN EXISTS(SELECT D2_ESPECIE FROM "+RetSqlName('SD2')+" WHERE D2_DOC=SD1.D1_NFORI AND D2_SERIE=SD1.D1_SERIORI AND D2_CLIENTE=SD1.D1_FORNECE AND D2_LOJA=SD1.D1_LOJA AND D_E_L_E_T_='' AND D2_FILIAL=SD1.D1_FILIAL ) THEN"+CRLF 
			cQueryc+="  		SD1.D1_SERIORI"+CRLF 
			cQueryc+=" 		ELSE"+CRLF 
			cQueryc+="  		CASE WHEN EXISTS(SELECT D1_ESPECIE FROM "+RetSqlName('SD1')+" WHERE D1_DOC=SD1.D1_NFORI AND D1_SERIE=SD1.D1_SERIORI AND D1_FORNECE=SD1.D1_FORNECE AND D1_LOJA=SD1.D1_LOJA AND D_E_L_E_T_='' AND D1_FILIAL=SD1.D1_FILIAL ) THEN"+CRLF 
			cQueryc+=" 				SD1.D1_SERIORI"+CRLF 
			cQueryc+="  		ELSE"+CRLF 
			cQueryc+=" 				CASE WHEN EXISTS(SELECT D1_ESPECIE FROM "+RetSqlName('SD1')+" WHERE D1_DOC=SD2.D2_NFORI AND D1_SERIE=SD2.D2_SERIORI AND D1_FORNECE=SD2.D2_CLIENTE AND D1_LOJA=SD2.D2_LOJA AND D_E_L_E_T_='' AND D1_FILIAL=SD2.D2_FILIAL ) THEN"+CRLF 
			cQueryc+=" 					SD2.D2_SERIORI"+CRLF 
			cQueryc+="  			ELSE"+CRLF 
			cQueryc+="  				CASE WHEN SD1.D1_ESPECIE='NCC' THEN"+CRLF 
			cQueryc+=" 						SD1.D1_SERIE"+CRLF 
			cQueryc+=" 					ELSE"+CRLF 
			cQueryc+=" 						SD2.D2_SERIE"+CRLF 
			cQueryc+=" 					END"+CRLF 
			cQueryc+="  			END"+CRLF 
			cQueryc+="  		END"+CRLF 
			cQueryc+=" 		END"+CRLF 
	 		cQueryc+=" END AS GM2,"+CRLF
	 		cQueryc+=" CASE WHEN SF3.F3_ESPECIE ='NCC' THEN"+CRLF   
			cQueryc+=" 		CASE WHEN SD1.D1_SERIORI <> '' THEN"
			cQueryc+=" 			SD1.D1_SERIORI"
			cQueryc+=" 		ELSE"
			cQueryc+=" 			SD1.D1_SERIE"
			cQueryc+=" 		END"					
			cQueryc+=" ELSE"+CRLF 
			cQueryc+="		CASE WHEN SD2.D2_SERIORI <> '' THEN"
			cQueryc+="			SD2.D2_SERIORI"
			cQueryc+=" 		ELSE"
			cQueryc+=" 			SD2.D2_SERIE"
			cQueryc+="		END"								
			cQueryc+=" END LETRA,"+CRLF 	
			cQueryc+=" CASE WHEN SF3.F3_ESPECIE ='NCC' THEN"+CRLF   
			cQueryc+=" 		SD1.D1_NFORI"+CRLF 
			cQueryc+=" ELSE"+CRLF 
			cQueryc+=" 		SD2.D2_NFORI"+CRLF 
			cQueryc+=" END  COMPROB"+CRLF 				
			cQueryc+=" FROM     "+RetSqlName('SF3')+" SF3"+CRLF 
			cQueryc+=" LEFT JOIN "+RetSqlName('SD1')+" SD1"+CRLF
			cQueryc+=" ON SD1.D1_FILIAL  =SF3.F3_FILIAL"+CRLF 
			cQueryc+=" AND SD1.D1_DOC    =SF3.F3_NFISCAL"+CRLF 
			cQueryc+=" AND SD1.D1_SERIE  =SF3.F3_SERIE"+CRLF  
			cQueryc+=" AND SD1.D1_ESPECIE=SF3.F3_ESPECIE"+CRLF  
			cQueryc+=" AND SD1.D1_FORNECE=SF3.F3_CLIEFOR"+CRLF  
			cQueryc+=" AND SD1.D1_LOJA   =SF3.F3_LOJA"  +CRLF 
			cQueryc+=" AND SD1.D_E_L_E_T_=''"+CRLF
			cQueryc+=" LEFT JOIN "+RetSqlName('SD2')+" SD2"+CRLF
			cQueryc+=" ON SD2.D2_FILIAL =SF3.F3_FILIAL"+CRLF 
			cQueryc+=" AND SD2.D2_DOC    =SF3.F3_NFISCAL"+CRLF  
			cQueryc+=" AND SD2.D2_SERIE  =SF3.F3_SERIE"+CRLF  
			cQueryc+=" AND SD2.D2_ESPECIE=SF3.F3_ESPECIE"+CRLF  
			cQueryc+=" AND SD2.D2_CLIENTE=SF3.F3_CLIEFOR"+CRLF 
			cQueryc+=" AND SD2.D2_LOJA   =SF3.F3_LOJA"+CRLF  
			cQueryc+=" AND SD2.D_E_L_E_T_=''"+CRLF
			cQueryc+=" WHERE F3_FILIAL = '"+xFilial('SF3')+"'"+CRLF
			cQueryc+=" AND F3_TIPOMOV='V'"+CRLF 
			cQueryc+=" AND SF3.F3_BASIMP"+aLivros[1]+" <> 0 "+CRLF
			cQueryc+=" AND F3_ESPECIE LIKE 'NC%'"                                                                  
			cQueryc+=" AND SF3.F3_EMISSAO BETWEEN '"+dTOs(MV_PAR01)+"' AND '"+dTOs(MV_PAR02)+"'"+CRLF
		    cQueryc+=" AND SF3.F3_DTCANC=''"+CRLF 
			cQueryc+=" AND SF3.D_E_L_E_T_ = ''"+CRLF 
			cQueryc+=" ORDER BY SF3.F3_EMISSAO"+CRLF 	
	
			cQueryc:=ChangeQuery(cQueryc)	
	 		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryc),"TRAc",.T.,.F.)
			
			TCSetField("TRAc","MONTO"  ,"N",09,02)
			TCSetField("TRAc","EMISSAO","D",08,00)
			
			TRAc->(dbGotop())
			
			While TRAc->(!Eof())
		
				dbSelectArea("TRBc")
				
				If RecLock("TRBc",.T.) 
					TRBc->TIPOPER := TRAc->TIPOPER
					TRBc->NRONFC  := TRAc->NRONFC
					TRBc->EMISSAO := ConvDat(TRAc->EMISSAO)
					TRBc->MONTO   := ROUND(If(TRAc->MONTO < 0,TRAc->MONTO *(-1),TRAc->MONTO),2) 
					TRBc->NROCERT := TRAc->NROCERT  
					TRBc->TIPOCOM := TIPOCOM(TRAc->GM1,TRAc->GM2)
					TRBc->LETRA   := TRAc->LETRA 
					If !Empty(TRAc->COMPROB)   
	                	TRBc->COMPROB := TRAc->COMPROB
	                Else 
	                	TRBc->COMPROB := TRAc->NRONFC
	                EndIf
				EndIf
				MsUnlock()
				TRAc->(dbSkip())
			End
	       	If MsgYesNo("ฟVerificar los datos para la exportacion?")
				 TRelARCIBA('TRBc')
			EndIf
		    
		    TRAc->(dbCloseArea())  
		EndIf
	EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FAMB     บ Autor ณ Totvs              บ Data ณ  08/04/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Genera Archivo de Retenciones/Percepciones                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ARCIBA                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function FAMB()

	Local cQueryn	:= ""
	Local cQueryc	:= ""    
	Local aLivros:={}
	Local nBas:=0
	Local nAliq:=0
	Local nVal:=0
	aLivros:=BUSCASFB()

	If Len(aLivros)	<> 0
		If Substr(_aTotal[07][01][04],1,1) =="1"
	
			//Query para Retenci๓n do tipo normal
			cQueryn:=" SELECT '1' TIPOPER,'008' CODNOR,SFE.FE_EMISSAO EMISSAO,' ' AS GM1, ' ' AS GM2,' ' LETRA,SFE.FE_ORDPAGO COMPROB,"+CRLF
			cQueryn+=" SFE.FE_EMISSAO FECHA,SFE.FE_VALBASE MONTO,SFE.FE_NROCERT NROCERT,'2' TIPODOC,SA2.A2_CGC DOCUM,"+CRLF
		 	cQueryn+=" CASE WHEN FH_TIPO IS NULL THEN '4'"+CRLF
		 	cQueryn+=" 		ELSE"+CRLF
		 	cQueryn+=" 			CASE SFH.FH_TIPO	WHEN 'V' THEN '2'"+CRLF
		 	cQueryn+="  		   				    WHEN 'N' THEN '4'"+CRLF
		 	cQueryn+="  			ELSE"+CRLF
		 	cQueryn+=" 				'1'"+CRLF
		 	cQueryn+=" 			END"+CRLF
		 	cQueryn+=" 		END AS SITIB,"+CRLF
			cQueryn+=" SA2.A2_NROIB NROIB,"+CRLF
			cQueryn+="        CASE  SA2.A2_TIPO WHEN 'I' THEN '1'"+CRLF
	        cQueryn+="                          WHEN 'N' THEN '2'"+CRLF
	        cQueryn+="                          WHEN 'X' THEN '3'"+CRLF
			cQueryn+="                          WHEN 'M' THEN '4'"+CRLF 
			cQueryn+="	                        ELSE          '5'"+CRLF 
			cQueryn+="				            END SITIVA,"+CRLF 
			cQueryn+=" SA2.A2_NOME RAZON,'0000000,00' OUTROSCON,'0000000,00' IVA,FE_VALBASE MONTOSU,FE_ALIQ ALIQ,"+CRLF
			cQueryn+=" SFE.FE_RETENC MONTORET"+CRLF
			cQueryn+=" FROM "+RetSqlName('SFE')+" SFE"+CRLF
			cQueryn+=" LEFT JOIN "+RetSqlName('SA2')+" SA2"+CRLF 
	        cQueryn+=" ON SFE.FE_FORNECE=SA2.A2_COD AND SFE.FE_LOJA=SA2.A2_LOJA AND SA2.A2_FILIAL='"+xFilial('SA2')+"' AND SA2.D_E_L_E_T_=''"+CRLF 
			cQueryn+=" LEFT JOIN (SELECT DISTINCT FH_TIPO,FH_FORNECE,FH_LOJA,FH_FILIAL,D_E_L_E_T_ FROM "+RetSqlName('SFH')+CRLF
			cQueryn+=" WHERE FH_ZONFIS='CF' AND FH_FORNECE <>'') SFH"+CRLF
	        cQueryn+=" ON SFH.FH_FORNECE = SA2.A2_COD AND SFH.FH_LOJA = SA2.A2_LOJA AND SFH.FH_FILIAL='"+xFilial('SFH')+"' AND SFH.D_E_L_E_T_ =''"+CRLF
			cQueryn+=" WHERE FE_FILIAL = '"+xFilial('SFE')+"'"+CRLF
			cQueryn+=" AND SFE.FE_FORNECE <> ''"+CRLF
			cQueryn+=" AND SFE.FE_NROCERT <> 'NORET'"+CRLF
			cQueryn+=" AND SFE.FE_TIPO='B'"+CRLF
			cQueryn+=" AND SFE.FE_EST='CF'"+CRLF
			cQueryn+=" AND SFE.FE_VALBASE > 0"+CRLF
			cQueryn+=" AND SFE.FE_EMISSAO BETWEEN '"+dTOs(MV_PAR01)+"' AND '"+dTOs(MV_PAR02)+"'"+CRLF
			cQueryn+=" AND (FE_DTESTOR='' OR FE_DTESTOR >'"+dTOs(MV_PAR02)+"')"+CRLF
			cQueryn+=" AND SFE.D_E_L_E_T_ = '' "+CRLF
	
			//UNI RETENCAO COM PERCEPCAO
			cQueryn+=" UNION ALL"+CRLF	
			//Query para Percepci๓n normal
			cQueryn+=" SELECT '2' TIPOPER,'014' CODNOR,SF3.F3_EMISSAO EMISSAO,"+CRLF
			cQueryn+=" SF3.F3_ESPECIE AS GM1, SF3.F3_SERIE AS GM2,"
			cQueryn+=" SF3.F3_SERIE LETRA,SF3.F3_NFISCAL COMPROB,SF3.F3_EMISSAO FECHA,SF3.F3_VALCONT MONTO,"+CRLF
			cQueryn+=" '' NROCERT,'2' TIPODOC,SA1.A1_CGC DOCUM,"+CRLF
		 	cQueryn+=" CASE WHEN FH_TIPO IS NULL THEN '4'"+CRLF
		 	cQueryn+=" 		ELSE"+CRLF
		 	cQueryn+=" 			CASE SFH.FH_TIPO	WHEN 'V' THEN '2'"+CRLF
		 	cQueryn+="  		   				    WHEN 'N' THEN '4'"+CRLF
		 	cQueryn+="  			ELSE"+CRLF
		 	cQueryn+=" 				'1'"+CRLF
		 	cQueryn+=" 			END"+CRLF
		 	cQueryn+=" 		END AS SITIB,"+CRLF
			cQueryn+=" SA1.A1_NIGB NROIB,"+CRLF
//			cQueryn+=" SA1.A1_INSCR NROIB,"+CRLF
			cQueryn+=" CASE  SA1.A1_TIPO WHEN 'I' THEN '1'"+CRLF
			cQueryn+="                          WHEN 'N' THEN '2'"+CRLF
			cQueryn+="     		                WHEN 'X' THEN '3'"+CRLF
			cQueryn+="				            WHEN 'M' THEN '4'"+CRLF
			cQueryn+="				            ELSE          '5'"+CRLF
			cQueryn+="				            END SITIVA,"+CRLF
			cQueryn+=" SA1.A1_NOME RAZON,'0000000,00' OUTROSCON,'0000000,00' IVA,"+CRLF
	
			// ADICIONA CAMPOS DE ACORDO COM O NUMERO DO LIVRO FISCAL EX: F3_BASIMP+1 == BASIMP1
			//CASO EXISTA MAIS DE UM LIVRO OS CAMPOS SERAO SOMADOS   EX: BASIMP1 + BASIMP2 ...    
			
			//BASE PARA IMPOSTO
			For nBas:=1 To Len(aLivros)
		
				If nBas < Len(aLivros)
					cQueryn+=" SF3.F3_BASIMP"+aLivros[nBas]+"+"	+CRLF
				Else	
					cQueryn+=" SF3.F3_BASIMP"+aLivros[nBas]+" "	+CRLF						
				EndIf
	
			Next		
			cQueryn+=" AS MONTOSU,"+CRLF	
			
			//ALIQUOTA			
			For nAliq:=1 To Len(aLivros)
	
				If nAliq <  Len(aLivros) 
					cQueryn+=" SF3.F3_ALQIMP"+aLivros[nAliq]+"+"+CRLF
				Else
					cQueryn+=" SF3.F3_ALQIMP"+aLivros[nAliq]+" "+CRLF			
				EndIf
	
			Next	
			cQueryn+=" AS ALIQ,"+CRLF
			
			//TOTAL MONTO RETIDO 		
			For nVal:=1 To Len(aLivros)
	
				If nVal  <  Len(aLivros)  
					cQueryn+=" SF3.F3_VALIMP"+aLivros[nVal]+"+"+CRLF
				Else
					cQueryn+=" SF3.F3_VALIMP"+aLivros[nVal]+" "+CRLF
				EndIf		
	
			Next		
			cQueryn+=" AS MONTORET"+CRLF
			
			cQueryn+=" FROM "+RetSqlName('SF3')+" SF3"+CRLF
			cQueryn+=" LEFT JOIN "+RetSqlName('SA1')+" SA1"+CRLF
	        cQueryn+=" ON SF3.F3_CLIEFOR=SA1.A1_COD AND SF3.F3_LOJA=SA1.A1_LOJA AND SA1.A1_FILIAL='"+xFilial('SA1')+"' AND SA1.D_E_L_E_T_=''"+CRLF
			cQueryn+=" LEFT JOIN (SELECT  DISTINCT FH_TIPO,FH_CLIENTE,FH_LOJA,FH_FILIAL,D_E_L_E_T_ FROM "+RetSqlName('SFH')+CRLF
			cQueryn+=" WHERE FH_ZONFIS='CF' AND FH_CLIENTE <>'') SFH"+CRLF
	        cQueryn+=" ON SFH.FH_CLIENTE = SA1.A1_COD AND SFH.FH_LOJA = SA1.A1_LOJA AND SFH.FH_FILIAL='"+xFilial('SFH')+"' AND SFH.D_E_L_E_T_ =''"+CRLF
			cQueryn+=" WHERE F3_FILIAL = '"+xFilial('SF3')+"'"+CRLF
			cQueryn+=" AND F3_TIPOMOV='V'"+CRLF
			cQueryn+=" AND SF3.F3_BASIMP"+aLivros[1]+" <> 0 "+CRLF
			cQueryn+=" AND SUBSTRING(SF3.F3_ESPECIE,1,2) <> 'NC'"+CRLF
			cQueryn+=" AND SF3.F3_EMISSAO BETWEEN '"+dTOs(MV_PAR01)+ "' AND '"+dTOs(MV_PAR02)+"'"+CRLF 
		    cQueryn+=" AND SF3.D_E_L_E_T_ = ''"+CRLF 
		    cQueryn+=" AND SF3.F3_DTCANC=''"		
	
			cQueryn:=ChangeQuery(cQueryn)	
	
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryn),"TRAn",.T.,.F.)
			
			TCSetField("TRAN","MONTO"    ,"N",09,02)
			TCSetField("TRAN","MONTOSU"  ,"N",09,02)		
			TCSetField("TRAN","ALIQ"     ,"N",02,02)
			TCSetField("TRAN","MONTORET" ,"N",09,02)
			TCSetField("TRAN","EMISSAO"  ,"D",08,00)
			TCSetField("TRAN","FECHA" ,"D",08,00)
			
			TRAn->(dbGotop())
			ProcRegua(LastRec())
			
			While TRAn->(!Eof())
				
				dbSelectArea("TRBn")
				If RecLock("TRBn",.T.) 
					TRBn->TIPOPER  :=TRAn->TIPOPER
					TRBn->CODNOR   :=TRAn->CODNOR
					TRBn->EMISSAO  :=ConvDat(TRAn->EMISSAO)
					TRBn->TIPOCOM  :=TipoCom(TRAn->GM1,TRAn->GM2)
					TRBn->LETRA    :=TRAn->LETRA    
					TRBn->COMPROB  :=TRAn->COMPROB
					TRBn->FECHA    :=ConvDat(TRAn->FECHA)
					TRBn->MONTO    :=ROUND(TRAn->MONTO,2) 
					TRBn->NROCERT  :=TRAn->NROCERT  
					TRBn->TIPODOC  :=TRAn->TIPODOC  
					TRBn->DOCUM    :=TRAn->DOCUM 
					TRBn->SITIB    :=TRAn->SITIB 
 			 TRBn->SITIB     := IF(EMPTY(ALLTRIM(TRAn->NROIB)),'4',TRAn->SITIB )
					TRBn->NROIB    :=TRAn->NROIB
					TRBn->SITIVA   :=TRAn->SITIVA
					TRBn->RAZON    := SubStr(TRAn->RAZON,1,30)
					TRBn->OUTROSCON:= TRAN->OUTROSCON
					TRBn->IVA      :=TRAN->IVA 
					TRBn->MONTOSU  :=ROUND(TRAn->MONTOSU,2)
					TRBn->ALIQ     :=ROUND(TRAn->ALIQ,2)
					TRBn->RETPRA   :=ROUND(TRAn->MONTORET,2)
					TRBn->MONTORET :=ROUND(TRAn->MONTORET,2)
				EndIf
				MsUnlock()
				TRAn->(dbSkip())
			
			End
			
			If MsgYesNo("ฟVerificar los datos para la exportacion?")
				 TRelARCIBA('TRBn')
			EndIf
				
		ElseIf Substr(_aTotal[07][01][04],1,1) =="2"
		
		    //Query para retencao  de NF de Credito 
			cQueryc:=" SELECT '1' TIPOPER,CASE WHEN SFE.FE_ORDPAGO='' THEN SFE.FE_NFISCAL ELSE SFE.FE_ORDPAGO END NRONFC,SFE.FE_EMISSAO EMISSAO,"+CRLF
			cQueryc+=" SFE.FE_VALBASE MONTO,SFE.FE_NRETORI NROCERT,' ' AS GM1, ' ' AS GM2,' ' LETRA,SFE.FE_ORDPAGO COMPROB"+CRLF
			cQueryc+=" FROM "+RetSqlName('SFE')+" SFE"+CRLF
			cQueryc+=" WHERE FE_FILIAL = '"+xFilial('SFE')+"'"+CRLF
			cQueryc+=" AND SFE.FE_FORNECE <>''"+CRLF
			cQueryc+=" AND SFE.FE_NROCERT <> 'NORET' "+CRLF
			cQueryc+=" AND SFE.FE_TIPO='B'"+CRLF
			cQueryc+=" AND SFE.FE_EST='CF'"+CRLF
			cQueryc+=" AND SFE.FE_VALBASE < 0 "+CRLF
			cQueryc+=" AND SFE.FE_DTRETOR < '"+dTOs(MV_PAR01)+"'"+CRLF
			cQueryc+=" AND SFE.FE_DTESTOR BETWEEN '"+dTOs(MV_PAR01)+"' AND '"+dTOs(MV_PAR02)+"'"+CRLF 
			cQueryc+=" AND SFE.D_E_L_E_T_ = '' "+CRLF
			cQueryc+=" UNION ALL "+CRLF //uniao  da retencao com a percepcao
			
			//QUERY PARA PERCEPCAO DE NF DE CREDITO
			cQueryc+=" SELECT '2' TIPOPER,SF3.F3_NFISCAL NRONFC,SF3.F3_EMISSAO EMISSAO,"+CRLF
			//BASE PARA IMPOSTO
			For nBas:=1 To Len(aLivros)
				If nBas < Len(aLivros)
					cQueryc+=" SF3.F3_BASIMP"+aLivros[nBas]+"+"+CRLF		
				Else	
					cQueryc+=" SF3.F3_BASIMP"+aLivros[nBas]+" "+CRLF								
				EndIf
			Next		
			cQueryc+=" AS MONTO,"+CRLF	
			cQueryc+=" ' '  NROCERT,"+CRLF
			cQueryc+=" CASE WHEN EXISTS(SELECT SUBSTRING(D2_ESPECIE,1,2) FROM "+RetSqlName('SD2')+" WHERE D2_DOC=SD2.D2_NFORI AND D2_SERIE=SD2.D2_SERIORI AND D2_CLIENTE=SD2.D2_CLIENTE AND D2_LOJA=SD2.D2_LOJA AND D_E_L_E_T_='' AND D2_FILIAL=SD2.D2_FILIAL ) THEN"+CRLF 
			cQueryc+="      (SELECT D2_ESPECIE FROM "+RetSqlName('SD2')+" WHERE D2_DOC=SD2.D2_NFORI AND D2_SERIE=SD2.D2_SERIORI AND D2_CLIENTE=SD2.D2_CLIENTE AND D2_LOJA=SD2.D2_LOJA AND D_E_L_E_T_='' AND D2_FILIAL=SD2.D2_FILIAL)"+CRLF 
			cQueryc+=" ELSE"+CRLF 
			cQueryc+="		CASE WHEN EXISTS(SELECT SUBSTRING(D2_ESPECIE,1,2) FROM "+RetSqlName('SD2')+" WHERE D2_DOC=SD1.D1_NFORI AND D2_SERIE=SD1.D1_SERIORI AND D2_CLIENTE=SD1.D1_FORNECE AND D2_LOJA=SD1.D1_LOJA AND D_E_L_E_T_='' AND D2_FILIAL=SD1.D1_FILIAL ) THEN"+CRLF 
			cQueryc+="  		(SELECT D2_ESPECIE FROM "+RetSqlName('SD2')+" WHERE D2_DOC=SD1.D1_NFORI AND D2_SERIE=SD1.D1_SERIORI AND D2_CLIENTE=SD1.D1_FORNECE AND D2_LOJA=SD1.D1_LOJA AND D_E_L_E_T_='' AND D2_FILIAL=SD1.D1_FILIAL)"+CRLF 
			cQueryc+=" 		ELSE"+CRLF 
			cQueryc+="  		CASE WHEN EXISTS(SELECT SUBSTRING(D1_ESPECIE,1,2) FROM "+RetSqlName('SD1')+" WHERE D1_DOC=SD1.D1_NFORI AND D1_SERIE=SD1.D1_SERIORI AND D1_FORNECE=SD1.D1_FORNECE AND D1_LOJA=SD1.D1_LOJA AND D_E_L_E_T_='' AND D1_FILIAL=SD1.D1_FILIAL ) THEN"+CRLF 
			cQueryc+=" 				(SELECT D1_ESPECIE FROM "+RetSqlName('SD1')+" WHERE D1_DOC=SD1.D1_NFORI AND D1_SERIE=SD1.D1_SERIORI AND D1_FORNECE=SD1.D1_FORNECE AND D1_LOJA=SD1.D1_LOJA AND D_E_L_E_T_='' AND D1_FILIAL=SD1.D1_FILIAL)"+CRLF 
			cQueryc+="  		ELSE"+CRLF 
			cQueryc+=" 				CASE WHEN EXISTS(SELECT SUBSTRING(D1_ESPECIE,1,2) FROM "+RetSqlName('SD1')+" WHERE D1_DOC=SD2.D2_NFORI AND D1_SERIE=SD2.D2_SERIORI AND D1_FORNECE=SD2.D2_CLIENTE AND D1_LOJA=SD2.D2_LOJA AND D_E_L_E_T_='' AND D1_FILIAL=SD2.D2_FILIAL ) THEN"+CRLF 
			cQueryc+=" 					(SELECT SUBSTRING(D1_ESPECIE,1,2) FROM "+RetSqlName('SD1')+" WHERE D1_DOC=SD2.D2_NFORI AND D1_SERIE=SD2.D2_SERIORI AND D1_FORNECE=SD2.D2_CLIENTE AND D1_LOJA=SD2.D2_LOJA AND D_E_L_E_T_='' AND D1_FILIAL=SD2.D2_FILIAL)"+CRLF 
			cQueryc+="  			ELSE"+CRLF 
			cQueryc+="  				CASE WHEN SD1.D1_ESPECIE='NCC' THEN" +CRLF
			cQueryc+=" 						' '"+CRLF 
			cQueryc+=" 			   		ELSE"+CRLF 
			cQueryc+=" 						' '"+CRLF 
			cQueryc+=" 					END"+CRLF 
			cQueryc+="  			END"+CRLF 
			cQueryc+="  		END"+CRLF 
			cQueryc+=" 		END"+CRLF 
	 		cQueryc+=" END AS GM1,"+CRLF 
			cQueryc+=" CASE WHEN EXISTS(SELECT SUBSTRING(D2_ESPECIE,1,2) FROM "+RetSqlName('SD2')+" WHERE D2_DOC=SD2.D2_NFORI AND D2_SERIE=SD2.D2_SERIORI AND D2_CLIENTE=SD2.D2_CLIENTE AND D2_LOJA=SD2.D2_LOJA AND D_E_L_E_T_='' AND D2_FILIAL=SD2.D2_FILIAL ) THEN"+CRLF
			cQueryc+="		SD2.D2_SERIORI"+CRLF 
			cQueryc+=" ELSE"+CRLF 
			cQueryc+="		CASE WHEN EXISTS(SELECT SUBSTRING(D2_ESPECIE,1,2) FROM "+RetSqlName('SD2')+" WHERE D2_DOC=SD1.D1_NFORI AND D2_SERIE=SD1.D1_SERIORI AND D2_CLIENTE=SD1.D1_FORNECE AND D2_LOJA=SD1.D1_LOJA AND D_E_L_E_T_='' AND D2_FILIAL=SD1.D1_FILIAL ) THEN"+CRLF 
			cQueryc+="  		SD1.D1_SERIORI"+CRLF 
			cQueryc+=" 		ELSE"+CRLF 
			cQueryc+="  		CASE WHEN EXISTS(SELECT SUBSTRING(D1_ESPECIE,1,2) FROM "+RetSqlName('SD1')+" WHERE D1_DOC=SD1.D1_NFORI AND D1_SERIE=SD1.D1_SERIORI AND D1_FORNECE=SD1.D1_FORNECE AND D1_LOJA=SD1.D1_LOJA AND D_E_L_E_T_='' AND D1_FILIAL=SD1.D1_FILIAL ) THEN"+CRLF 
			cQueryc+=" 				SD1.D1_SERIORI"+CRLF 
			cQueryc+="  		ELSE"+CRLF 
			cQueryc+=" 				CASE WHEN EXISTS(SELECT SUBSTRING(D1_ESPECIE,1,2) FROM "+RetSqlName('SD1')+" WHERE D1_DOC=SD2.D2_NFORI AND D1_SERIE=SD2.D2_SERIORI AND D1_FORNECE=SD2.D2_CLIENTE AND D1_LOJA=SD2.D2_LOJA AND D_E_L_E_T_='' AND D1_FILIAL=SD2.D2_FILIAL ) THEN"+CRLF 
			cQueryc+=" 					SD2.D2_SERIORI"+CRLF 
			cQueryc+="  			ELSE"+CRLF 
			cQueryc+="  				CASE WHEN SD1.D1_ESPECIE='NCC' THEN"+CRLF 
			cQueryc+=" 						SD1.D1_SERIE"+CRLF 
			cQueryc+=" 					ELSE"+CRLF 
			cQueryc+=" 						SD2.D2_SERIE"+CRLF 
			cQueryc+=" 					END"+CRLF 
			cQueryc+="  			END"+CRLF 
			cQueryc+="  		END"+CRLF 
			cQueryc+=" 		END"+CRLF 
	 		cQueryc+=" END AS GM2,"+CRLF
			cQueryc+=" CASE WHEN SF3.F3_ESPECIE ='NCC' THEN"+CRLF   
			cQueryc+=" 		CASE WHEN SD1.D1_SERIORI<>'' THEN "+CRLF 
			cQueryc+=" 			SD1.D1_SERIORI"
			cQueryc+=" 		ELSE"
			cQueryc+=" 			SD1.D1_SERIE"
			cQueryc+=" 		END"				
			cQueryc+=" ELSE"+CRLF
			cQueryc+=" 		CASE WHEN SD2.D2_SERIORI<>'' THEN"+CRLF
			cQueryc+=" 			SD2.D2_SERIORI"
			cQueryc+=" 		ELSE"
			cQueryc+=" 			SD2.D2_SERIE"
			cQueryc+=" 		END"			
			cQueryc+=" END LETRA,"+CRLF 	
			cQueryc+=" CASE WHEN SF3.F3_ESPECIE ='NCC' THEN"+CRLF   
			cQueryc+=" 		SD1.D1_NFORI"+CRLF 
			cQueryc+=" ELSE"+CRLF 
			cQueryc+=" 		SD2.D2_NFORI"+CRLF 
			cQueryc+=" END  COMPROB"+CRLF 				
			cQueryc+=" FROM     "+RetSqlName('SF3')+" SF3"+CRLF 
			cQueryc+=" LEFT JOIN "+RetSqlName('SD1')+" SD1"+CRLF
			cQueryc+=" ON SD1.D1_FILIAL  =SF3.F3_FILIAL"+CRLF 
			cQueryc+=" AND SD1.D1_DOC    =SF3.F3_NFISCAL"+CRLF  
			cQueryc+=" AND SD1.D1_SERIE  =SF3.F3_SERIE"+CRLF  
			cQueryc+=" AND SD1.D1_ESPECIE=SF3.F3_ESPECIE"+CRLF  
			cQueryc+=" AND SD1.D1_FORNECE=SF3.F3_CLIEFOR"+CRLF  
			cQueryc+=" AND SD1.D1_LOJA   =SF3.F3_LOJA"+CRLF   
			cQueryc+=" AND SD1.D_E_L_E_T_=''"+CRLF
			cQueryc+=" LEFT JOIN "+RetSqlName('SD2')+" SD2"+CRLF
			cQueryc+=" ON SD2.D2_FILIAL =SF3.F3_FILIAL"+CRLF 
			cQueryc+=" AND SD2.D2_DOC    =SF3.F3_NFISCAL"+CRLF  
			cQueryc+=" AND SD2.D2_SERIE  =SF3.F3_SERIE"+CRLF  
			cQueryc+=" AND SD2.D2_ESPECIE=SF3.F3_ESPECIE"+CRLF  
			cQueryc+=" AND SD2.D2_CLIENTE=SF3.F3_CLIEFOR"+CRLF 
			cQueryc+=" AND SD2.D2_LOJA   =SF3.F3_LOJA"+CRLF  
			cQueryc+=" AND SD2.D_E_L_E_T_=''"+CRLF
			cQueryc+=" WHERE F3_FILIAL = '"+xFilial('SF3')+"'"+CRLF
			cQueryc+=" AND F3_TIPOMOV='V'"+CRLF 
			cQueryc+=" AND SF3.F3_BASIMP"+aLivros[1]+" <> 0 "+CRLF
			cQueryc+=" AND SUBSTRING(F3_ESPECIE,1,2)='NC'"+CRLF 
			cQueryc+=" AND SF3.F3_EMISSAO BETWEEN '"+dTOs(MV_PAR01)+"' AND '"+dTOs(MV_PAR02)+"'"+CRLF
		    cQueryc+=" AND SF3.F3_DTCANC=''"+CRLF 
			cQueryc+=" AND SF3.D_E_L_E_T_ = ''"+CRLF 
	
			cQueryc:=ChangeQuery(cQueryc)	
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryc),"TRAc",.T.,.F.)
			
			TCSetField("TRAc","MONTO"    ,"N",09,02)
			TCSetField("TRAc","EMISSAO"  ,"D",08,00)
			
			TRAc->(dbGotop())
			
			While TRAc->(!Eof())
		
				dbSelectArea("TRBc")
				
				If RecLock("TRBc",.T.) 
					TRBc->TIPOPER := TRAc->TIPOPER
					TRBc->NRONFC  := TRAc->NRONFC
					TRBc->EMISSAO := ConvDat(TRAc->EMISSAO)
					TRBc->MONTO   := ROUND(If(TRAc->MONTO < 0,TRAc->MONTO *(-1),TRAc->MONTO),2) 
					TRBc->NROCERT := TRAc->NROCERT  
					TRBc->TIPOCOM:=TIPOCOM(TRAc->GM1,TRAc->GM2)
					TRBc->LETRA   := TRAc->LETRA    
					If !Empty(TRAc->COMPROB)
						TRBc->COMPROB := TRAc->COMPROB
					Else
						TRBc->COMPROB := TRAc->NRONFC					
					EndIf
				EndIf
				MsUnlock()
				TRAc->(dbSkip())
			End
		    
		    If MsgYesNo("ฟVerificar los datos para la exportacion?")
				 TRelARCIBA('TRBc')
			EndIf
		    
		    TRAc->(dbCloseArea())
		EndIF
	EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BuscaSFB บ Autor ณ Totvs              บ Data ณ  05/05/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescrip.  ณ Busca numero dos livros de acordo para montagem dos campos  ฑฑ
ฑฑณ          ณ F3_ALQIMP,F3_VALIMP e F3_BASIMP                             ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ARCIBA                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function BuscaSFB()
	
	Local cQuery := "" 
	Local aLivro := {}
		
	cQuery:=" SELECT FB_CPOLVRO LIVRO"
	cQuery+=" FROM "+RetSqlName('SFB')+" SFB"
	cQuery+=" WHERE FB_CLASSE='P'"
	cQuery+=" AND SFB.D_E_L_E_T_=''	
	cQuery+=" AND SFB.FB_FILIAL='"+xFilial('SFB')+"'"	
	cQuery+=" AND SFB.FB_CLASSIF='1'"
	cQuery+=" AND SFB.FB_ESTADO='CF'"
	
	cQuery := ChangeQuery(cQuery)		
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRA",.T.,.F.)

	While TRA->(!Eof())
		aAdd(aLivro,TRA->LIVRO)
		TRA->(dbSkip())
	End
	aAdd(aLivro,"5")
	
Return aLivro

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTRelARCIBAบ Autor ณ Renato Nagib       บ Data ณ  28/04/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescrip.  ณ Relatorio de conferencia para exportacao do txt ARCIBA      ฑฑ
ฑฑณ          ณ                                                             ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ARCIBA                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function TRelARCIBA(cArq)
	
	Local olReport
	Private cArqTrab:=cArq

	If TRepInUse()
		olReport:=ReportDef()
		olReport:PrintDialog()
	EndIf
	
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บ Autor ณ Renato Nagib       บ Data ณ  28/04/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescrip.  ณ Definicao do relatorio                                      ฑฑ
ฑฑณ          ณ                                                             ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ARCIBA                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ReportDef()
	
	Local olReport
	Local oSection
	
	olReport:=TReport():New("ARCIBAtxt","Datos para exportaci๓n",,{|olReport| PrintReport(olReport)},"Conferencia de los datos para exportacion txt")
	
	oSection:=TRSection():new(olReport,"Impostos",{cArqTrab})
	
	olReport:SetLandScape(.T.)

	If cArqTrab == 'TRBn'
		TRCell():New(oSection,"OP "        ,,,"@E 9"             ,02)
		TRCell():New(oSection,"NOR "       ,,,"@E 999"           ,04)
		TRCell():New(oSection,"FECHA RET " ,,,                   ,20)
		TRCell():New(oSection,"TPCOM"      ,,,"@E 99"            ,07)
		TRCell():New(oSection,"LTR "       ,,,"@!"               ,04)
		TRCell():New(oSection,"COMPROBANTE",,,"@!"               ,20)
  		TRCell():New(oSection,"FECHA EMI"  ,,,                   ,20)
		TRCell():New(oSection,"MONTO"      ,,,"@E   9,999,999.99",16)
		TRCell():New(oSection,"CERT"       ,,,"@!"               ,21)
		TRCell():New(oSection,"TPDOC"      ,,,"@!"               ,01)
		TRCell():New(oSection,"DOCUMENTO"  ,,,"@!"               ,18)
		TRCell():New(oSection,"SIB"        ,,,"@!"               ,06)
		TRCell():New(oSection,"NROIB"      ,,,"@E 9999999999"    ,15)
		TRCell():New(oSection,"SIVA"       ,,,"@E 9"             ,06)
		TRCell():New(oSection,"RAZON"      ,,,"@!"               ,30)
		//TRCell():New(oSection,"OTROSCOM"   ,,,"@E 9999999.99"    ,16)
		//TRCell():New(oSection,"IVA"        ,,,"@E 9999999.99"    ,16)
		TRCell():New(oSection,"MONTSU"     ,,,"@E   9,999,999.99",16)
		TRCell():New(oSection,"ALIQ"       ,,,"@E 99.99"         ,08)
		TRCell():New(oSection,"RETPRA"     ,,,"@E   9,999,999.99",16)
		TRCell():New(oSection,"MONTRET"    ,,,"@E   9,999,999.99",16)
		TRCell():New(oSection," "          ,,,                   ,10)
	Else
		TRCell():New(oSection,"TIPOPER"  ,,,"@E 9"             ,01)		
		TRCell():New(oSection,"NRONFC"   ,,,"@!"               ,16)
		TRCell():New(oSection,"FECHA"    ,,,                   ,20)
		TRCell():New(oSection,"MONTO"    ,,,"@E 999,999,999.99",14)
		TRCell():New(oSection,"NROCERT"  ,,,"@!"               ,16)
		TRCell():New(oSection,"TIPOCOM"  ,,,"@E 99"            ,02)
		TRCell():New(oSection,"LETRA"    ,,,"@!"               ,01)
		TRCell():New(oSection,"COMPROB"  ,,,"@!"               ,15)
		TRCell():New(oSection,"EMISION_OP"  ,,,                   ,20)
		TRCell():New(oSection,"NUMERO_OP"  ,,,"@!"               ,15)
		TRCell():New(oSection,"ALIQ"       ,,,"@E 99.99"         ,08)
		TRCell():New(oSection,"RETPRA"     ,,,"@E   9,999,999.99",16)
	EndIf
Return olReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  PrintReportบ Autor ณ Renato Nagib       บ Data ณ  28/04/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescrip.  ณ Impressao do relatorio                                      ฑฑ
ฑฑณ          ณ                                                             ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ARCIBA                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function PrintReport(olReport)
	
	Local olSection:=olReport:Section(1)

	If cArqTrab == 'TRBn'
		olReport:Section(1):Cell("OP "        ):SetBlock({|| TRBn->TIPOPER  })	
		olReport:Section(1):Cell("NOR"        ):SetBlock({|| TRBn->CODNOR   })	
	  	olReport:Section(1):Cell("FECHA RET"  ):SetBlock({|| TRBn->EMISSAO  })	
		olReport:Section(1):Cell("TPCOM"      ):SetBlock({|| TRBn->TIPOCOM  })	
		olReport:Section(1):Cell("LTR"        ):SetBlock({|| TRBn->LETRA    })	
		olReport:Section(1):Cell("COMPROBANTE"):SetBlock({|| TRBn->COMPROB  })	
		olReport:Section(1):Cell("FECHA EMI"  ):SetBlock({|| TRBn->FECHA    })	
		olReport:Section(1):Cell("MONTO"      ):SetBlock({|| TRBn->MONTO    })	
		olReport:Section(1):Cell("CERT"       ):SetBlock({|| TRBn->NROCERT  })	
		olReport:Section(1):Cell("TPDOC"      ):SetBlock({|| TRBn->TIPODOC  })	
		olReport:Section(1):Cell("DOCUMENTO"  ):SetBlock({|| TRBn->DOCUM    })	
		olReport:Section(1):Cell("SIB"        ):SetBlock({|| TRBn->SITIB    })	
		olReport:Section(1):Cell("NROIB"      ):SetBlock({|| TRBn->NROIB    })	
		olReport:Section(1):Cell("SIVA"       ):SetBlock({|| TRBn->SITIVA   })	
		olReport:Section(1):Cell("RAZON"      ):SetBlock({|| TRBn->RAZON    })	
		olReport:Section(1):Cell("MONTSU"     ):SetBlock({|| TRBn->MONTOSU  })	
		olReport:Section(1):Cell("ALIQ"       ):SetBlock({|| TRBn->ALIQ     })	
		olReport:Section(1):Cell("RETPRA"     ):SetBlock({|| TRBn->RETPRA   })	
		olReport:Section(1):Cell("MONTRET"    ):SetBlock({|| TRBn->MONTORET })	
		olReport:Section(1):Cell(" "          ):SetBlock({|| " "            })	
	Else
		olReport:Section(1):Cell("TIPOPER"  ):SetBlock({|| TRBc->TIPOPER  })		
		olReport:Section(1):Cell("NRONFC"   ):SetBlock({|| TRBc->NRONFC  })	
		olReport:Section(1):Cell("FECHA"    ):SetBlock({|| TRBc->EMISSAO  })	
		olReport:Section(1):Cell("MONTO"    ):SetBlock({|| TRBc->MONTO    })	
		olReport:Section(1):Cell("NROCERT"  ):SetBlock({|| TRBc->NROCERT  })	
		olReport:Section(1):Cell("TIPOCOM"  ):SetBlock({|| TRBc->TIPOCOM  })	
		olReport:Section(1):Cell("LETRA"    ):SetBlock({|| TRBc->LETRA    })	
		olReport:Section(1):Cell("COMPROB"  ):SetBlock({|| TRBc->COMPROB  })	
		olReport:Section(1):Cell("EMISION_OP"    ):SetBlock({|| TRBc->EMIOP    })	
		olReport:Section(1):Cell("NUMERO_OP"  ):SetBlock({|| TRBc->COMOP  })	
		olReport:Section(1):Cell("ALIQ"       ):SetBlock({|| TRBc->ALIQ     })	
		olReport:Section(1):Cell("RETPRA"     ):SetBlock({|| TRBc->RETPRA   })	
	EndIf
	olSection:Print()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  PrintReportบ Autor ณ Renato Nagib       บ Data ณ  28/04/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescrip.  ณ Exclui o arquivo temporario processado                      ฑฑ
ฑฑณ          ณ                                                             ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ARCIBA                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/      
Static Function DelARCIBA(aArqTrab)

	Local nArq:= 0
	
	For nArq:=1 To Len(aArqTrab)
		If File(aArqTrab[nArq,1]+GetDBExtension())
			dbSelectArea(aArqTrab[nArq,2])
			dbCloseArea()
			Ferase(aArqTrab[nArq,1]+GetDBExtension())
			Ferase(aArqTrab[nArq,1]+OrdBagExt())
		Endif	
	Next	
	
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TipCom   บ Autor ณ Ivan Haponczuk     บ Data ณ  03/01/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescrip.  ณ Retorna o tipo do comprovante de acordo com o tipo da nota  ฑฑ
ฑฑณ          ณ e a serie.                                                  ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ARCIBA                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function TipoCom(clGM1,clGM2)

	Local clTipoCom := ""
	
	clGM1 := AllTrim(clGM1)
	clGM2 := AllTrim(clGM2)
	clGM3 := clGM1 +"|"+clGM2
	
	If !Empty(clGM1)
		Do Case       
		    //Facturas se envian como tipo 01
			Case clGM3 == "NF"
				clTipoCom := "01"
			//Otros comprobantes se envian como 02	
			OtherWise 
				clTipoCom := "02"
		EndCase
	EndIf
	
	If Empty(clGM1) .And. Empty(clGM2)
		clTipoCom := "03"
	EndIf

Return clTipoCom

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ConvDat  บ Autor ณ Ivan Haponczuk     บ Data ณ  05/01/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescrip.  ณ Converte a data para o formato padrao do arquivo ARCIBA     ฑฑ
ฑฑณ          ณ                                                             ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ARCIBA                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ConvDat(dData)

	Local cData := DTOS(dData)
	
	cData := SubStr(cData,7,2) + "/" + SubStr(cData,5,2) + "/" + SubStr(cData,1,4)

Return cData