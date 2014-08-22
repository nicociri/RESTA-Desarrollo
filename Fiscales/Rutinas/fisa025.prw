#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "FISA025.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FISA025  ³ Autor ³ Ivan Haponczuk      ³ Data ³ 10.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Consulta de impostos / retencoes - Argentina               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Uso      ³ Fiscal - Argentina                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function FISA025()

	Local   nCliFor  := 0            //1-Fornecedor, 2-Cliente
	Local   dDatIni  := dDatabase    //Data de inicio do periodo
	Local   dDatFim  := dDataBase    //Data do fim do periodo
	Local   cAlias   := ""           //Alias da tabela que vai ser usada (SFE/SF3)
	Local   cTipImp  := ""           //I-Imposto, P-Percepção, R-Retenção
	Local   cCmbCli  := ""           //Fornecedor/Cliente
	Local   cCmbTip  := ""           //Tipo do imposto
	Local   cCmbDoc  := ""           //Tipo do documento
	Local   cCmbSer  := ""           //Serie do documento
	Local   cCmbRet  := ""           //Numero do comprovante de rentacao
	Local   cProv    := ""           //Provincia
	Local   cDocNum  := Space(12)    //Numero do documento
	Local   cCodIni  := Space(6)     //Codigo inicial do cli/for
	Local   cLojIni  := Space(2)     //Loja inicial do cli/for
	Local   cCodFin  := Space(6)     //Codigo final do cli/for
	Local   cLojFin  := Space(2)     //Loja final do cli/for
	Local   aClassif := {}           //Array com as classificações fiscais selecionadas
	Local   aImps    := {}           //Vetor com impostos classificados
	Local   aConcep  := {}           //Vetor com os conceitos de acordo com as classificacoes fiscais
	Local   aHead    := {}           //Cabecalho da getdados a ser apresentada
	Local   lOk      := .F.          //Variável que controla se o processo esta certo
	Private lChk01   := .T.          //Consulta por classe
	Private lChk02   := .F.          //Consulta especifica por documento
	Private lChk03   := .F.          //Consulta por comprovante de retencao
	
	dDatIni := STOD(SubStr(DTOS(dDataBase),1,6)+"01")
	
	Do While !lOk
		lOk := Tela1(@nCliFor,@cTipImp,@dDatIni,@dDatFim,@cCmbCli,@cCmbTip,@cCmbDoc,@cCmbSer,@cDocNum,@cCmbRet)
		If !lOk
			Exit
		EndIf
		
		//+------------------------------------------------+
		//| Consulta por classe                            |
		//+------------------------------------------------+
		If lOk .and. lChk01
			lOk := Tela2(nCliFor,cCmbCli,cTipImp,@cProv,@aClassif,@aConcep,@cCodIni,@cLojIni,@cCodFin,@cLojFin)
			If lOk
				If cTipImp == "R" //para retencoes
					If Len(aClassif) > 0
						cAlias := "SFE"
						aHead  := FQryFE(nCliFor,dDatIni,dDatFim,,,cCodIni,cLojIni,cCodFin,cLojFin,cProv,aClassif,aConcep)
					EndIf
				Else //para impostos/percepcoes
					aImps := FaImps(aClassif,{cTipImp},cProv)
					If Len(aImps) > 0
						cAlias := "SF3"
						aHead := FQryF3(nCliFor,dDatIni,dDatFim,aImps,,,,cCodIni,cLojIni,cCodFin,cLojFin,aConcep)
					EndIf
				EndIf
			EndIf
		EndIf

		//+------------------------------------------------+
		//| Consulta especifica com documento              |
		//+------------------------------------------------+
		If lOk .and. lChk02
			If cCmbDoc $ "OP|RC" //Ordem de pago|Recibo
				cAlias := "SFE"
				aHead := FQryFE(nCliFor,dDatIni,dDatFim,cCmbDoc,cDocNum)
			Else //Para as demais especies
				aImps := FaImps()
				If Len(aImps) > 0
					cAlias := "SF3"
					aHead := FQryF3(nCliFor,dDatIni,dDatFim,aImps,cCmbDoc,cCmbSer,cDocNum)
				EndIf
			EndIf
		EndIf
		
		//+------------------------------------------------+
		//| Consulta por comprovante de retencao           |
		//+------------------------------------------------+
		If lOk .and. lChk03
			cAlias := "SFE"
			aHead := FQryFE(nCliFor,dDatIni,dDatFim,,cCmbRet)
		EndIf
	EndDo

	If lOk	
		If Len(aHead) > 0
			Tela3(cAlias,aHead)
		Else
			MsgAlert(STR0001)//Não há resultados para esta consulta.
		EndIf
	EndIf
	
	If Select("QRYCON") > 0
		QRYCON->(dbCloseArea())
	EndIf

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Tela1    ³ Autor ³ Ivan Haponczuk      ³ Data ³ 11.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cria a primeira tela de configurações.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nPar01 - Movimento ao (1=Fornecedor, 2=Cliente)            ³±±
±±³          ³ cPar02 - Tipo do imposto (I=Imposto, P=Percepção,          ³±±
±±³          ³          R=Retenção)                                       ³±±
±±³          ³ dPar03 - Data inicial do periodo                           ³±±
±±³          ³ dPar04 - Data final do periodo                             ³±±
±±³          ³ cPar05 - (Fornecedores/Clientes)                           ³±±
±±³          ³ cPar06 - (Impostos/Percepcoes/Retencoes)                   ³±±
±±³          ³ cPar07 - Especie do documento                              ³±±
±±³          ³ cPar08 - Serie do documento                                ³±±
±±³          ³ cPar09 - Numero do documento                               ³±±
±±³          ³ cPar10 - Numero do comprovante de retencao                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ lRet - .T. se confirmado e validado ou .F. caso contrario  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Argentina                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Tela1(nCliFor,cTipImp,dDatIni,dDatFim,cCmbCli,cCmbTip,cCmbDoc,cCmbSer,cDocNum,cCmbRet)

	Local   aCmbCli := {STR0002,STR0003}//Fornecedores###Clientes
	Local   aCmbTip := {STR0004,STR0005,STR0006}//Impostos###Percepções###Retenções
	Local   aCmbDoc := FaCmbDoc() //Lista as especies das notas
	Local   aCmbSer := FaCmbSer() //Lista as series das notas
	Local   aCmbRet := FRetCerts(1) //Lista as retencoes a fornecedores
	Local   lOk     := .F.
	
	oDlg01:=MSDialog():New(000,000,365,430,STR0007,,,,,,,,,.T.)//Consultar de Impostos
	
		//+------------------------------------------------+
		//| Periodo                                        |
		//+------------------------------------------------+
		@005,005 To 045,170 prompt STR0008 Pixel Of oDlg01//Período
		oSay01 := tSay():New(017,015,{||STR0009},oDlg01,,,,,,.T.,,,100,20)//Movimento de:
		oCmb01 := tComboBox():New(027,015,{|u|if(PCount()>0,cCmbCli:=u,cCmbCli)},aCmbCli,050,020,oDlg01,,{|| FChCliFor(aScan(aCmbCli,{|x| x == cCmbCli})) },,,,.T.)
		oSay02 := tSay():New(017,075,{||STR0010},oDlg01,,,,,,.T.,,,100,20)//Da data:
		oGet01 := TGet():New(027,075,{|u| if(PCount()>0,dDatIni:=u,dDatIni)},oDlg01,040,007,,,,,,,,.T.)
		oSay03 := tSay():New(017,120,{||STR0011},oDlg01,,,,,,.T.,,,100,20)//Até a data:
		oGet02 := TGet():New(027,120,{|u| if(PCount()>0,dDatFim:=u,dDatFim)},oDlg01,040,007,,,,,,,,.T.)
		
		oBtn01:=sButton():New(012,180,1,{|| lOk:=.T. ,oDlg01:End() },oDlg01,.T.,,)
		oBtn02:=sButton():New(028,180,2,{|| lOk:=.F. ,oDlg01:End() },oDlg01,.T.,,)

		//+------------------------------------------------+
		//| Por classe                                     |
		//+------------------------------------------------+
		@050,005 To 085,210 prompt STR0012 Pixel Of oDlg01//Por classe
		oChk01 := TCheckBox():New(065,015,"",{|| lChk01 },oDlg01,100,210,,,,,,,,.T.,,,)
		oChk01:bLClicked := {|| ChgChk(1) }
		oCmb02 := tComboBox():New(065,035,{|u| if(PCount()>0,cCmbTip:=u,cCmbTip)},aCmbTip,060,020,oDlg01,,,,,,.T.,,,,{|| lChk01 })

		//+------------------------------------------------+
		//| Especifica por documento                       |
		//+------------------------------------------------+		
		@090,005 To 137,210 prompt STR0013 Pixel Of oDlg01//Específica por documento
		oChk02 := TCheckBox():New(105,015,"",{|| lChk02 },oDlg01,100,210,,,,,,,,.T.,,,)
		oChk02:bLClicked := {|| ChgChk(2) }
		oSay04 := tSay():New(106,035,{||STR0014}  ,oDlg01,,,,,,.T.,,,100,20)//Tipo:
		oSay05 := tSay():New(106,085,{||STR0015} ,oDlg01,,,,,,.T.,,,100,20)//Série:
		oSay06 := tSay():New(106,125,{||STR0016},oDlg01,,,,,,.T.,,,100,20)//Número:
		oCmb03 := tComboBox():New(0117,035,{|u|if(PCount()>0,cCmbDoc:=u,cCmbDoc)},aCmbDoc,040,020,oDlg01,,,,,,.T.,,,,{|| lChk02 })
		oCmb04 := tComboBox():New(0117,085,{|u|if(PCount()>0,cCmbSer:=u,cCmbSer)},aCmbSer,030,020,oDlg01,,,,,,.T.,,,,{|| lChk02 .and. !(cCmbDoc$"OP|RC") })
		oGet03 := TGet():New(117,125,{|u| if(PCount()>0,cDocNum:=u,cDocNum)},oDlg01,070,007,,,,,,,,.T.,,,{|| lChk02 })
	
		//+------------------------------------------------+
		//| Por comprovante de retencao                    |
		//+------------------------------------------------+
		@142,005 To 177,210 prompt STR0017 Pixel Of oDlg01//Por comprovante de retenção
		oChk03 := TCheckBox():New(157,015,"",{|| lChk03 },oDlg01,100,210,,,,,,,,.T.,,,)
		oChk03:bLClicked := {|| ChgChk(3) }
		oCmbRet := tComboBox():New(0157,035,{|u|if(PCount()>0,cCmbRet:=u,cCmbRet)},aCmbRet,060,020,oDlg01,,,,,,.T.,,,,{|| lChk03 })
		
	oDlg01:Activate(,,,.T.,,,)

	//+------------------------+
	//| 1 - Fornecedores       |
	//| 2 - Clientes           |
	//+------------------------+
	nCliFor := aScan(aCmbCli,{|x| x == cCmbCli})

	//+------------------------+
	//| I - Imposto            |
	//| P - Percepcao          |
	//| R - Retencao           |
	//+------------------------+
	cTipImp := SubStr(cCmbTip,1,1)

Return lOk

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ChgChk   ³ Autor ³ Ivan Haponczuk      ³ Data ³ 11.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faz a selecao do checkbox clicado e remove as demais       ³±±
±±³          ³ selecoes.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nPar01 - Numero da opcao escolhida                         ³±±
±±³          ³          1 = Por classe                                    ³±±
±±³          ³          2 = Especifica por documento                      ³±±
±±³          ³          3 = Por comprovante de retencao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nulo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Argentina                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ChgChk(nChk)

	lChk01 := .F.
	lChk02 := .F.
	lChk03 := .F.

	If nChk == 1
		lChk01 := .T.
	ElseIf nChk == 2
		lChk02 := .T.
	Else
		lChk03 := .T.
	EndIf

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FChCliFor³ Autor ³ Ivan Haponczuk      ³ Data ³ 11.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Recria as opcoes do combo de numero dos certificados.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nPar01 - Movimento ao (1=Fornecedor, 2=Cliente)            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nulo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Argentina                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FChCliFor(nCliFor)

	Local aCerts := FRetCerts(nCliFor)

	oCmbRet:aItems:=aCerts
	oCmbRet:Refresh()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FRetCerts³ Autor ³ Ivan Haponczuk      ³ Data ³ 11.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Busca os numeros dos certificados.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nPar01 - Movimento ao (1=Fornecedor, 2=Cliente)            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aRet - Vetor com o numero dos certificados encontrados     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Argentina                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FRetCerts(nCliFor)

	Local cQry   := ""
	Local aCerts := {""}

	// Query
	cQry := " SELECT"
	cQry += " DISTINCT SFE.FE_NROCERT"
	cQry += " FROM "+RetSqlName("SFE")+" SFE"
	cQry += " WHERE SFE.FE_FILIAL = '"+xFilial("SFE")+"'"
	cQry += " AND SFE.D_E_L_E_T_ = ' '"
 	cQry += " AND SFE.FE_NROCERT <> 'NORET'"
	If nCliFor == 1
		// Filtro por fornecedor
		cQry += " AND SFE.FE_FORNECE <> ' '"
	Else
		// Filtro por cliente
		cQry += " AND SFE.FE_CLIENTE <> ' '"
	EndIf
	    
	If Select("QRY") > 0                 
	   dbSelectArea("QRY")
	   dbCloseArea()
	Endif
	
	cQry := ChangeQuery(cQry)
	TCQUERY cQry NEW ALIAS "QRY"  
	
	dbSelectArea("QRY")
	While !QRY->(EOF())
	   aAdd(aCerts,QRY->FE_NROCERT)
	   QRY->(dbSkip())
	EndDo	
	QRY->(dbCloseArea())
	
Return aCerts

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Tela2    ³ Autor ³ Ivan Haponczuk      ³ Data ³ 11.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cria a primeira tela de configurações.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nPar01 - Movimento ao (1=Fornecedor, 2=Cliente)            ³±±
±±³          ³ cPar02 - (Fornecedores/Clientes)                           ³±±
±±³          ³ cPar03 - (Impostos/Percepcoes/Retencoes)                   ³±±
±±³          ³ cPar04 - Provincia            o                            ³±±
±±³          ³ cPar05 - Array com as classificacoes fiscais               ³±±
±±³          ³ cPar06 - Array com os conceitos usados (CFOS/CONCEPTS)     ³±±
±±³          ³ cPar07 - Codigo do cliente/fornecedor                      ³±±
±±³          ³ cPar08 - Codigo da loja                                    ³±±
±±³          ³ cPar09 - Codito ate cliente/fornecedor                     ³±±
±±³          ³ cPar10 - Codigo ate loja                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ lRet - .T. se confirmado e validado ou .F. caso contrario  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Argentina                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Tela2(nCliFor,cCmbCli,cTipImp,cProv,aClassif,aConcep,cCodIni,cLojIni,cCodFin,cLojFin)

	Local nI      := 0
	Local cImpIVA := ""
	Local cImpGAN := ""
	Local cImpSUS := ""
	Local cImpIBB := ""
	Local cImpIMP := ""
	Local cImpPRV := "" 
	Local cImpMun := ""
	Local aImpIVA := {}
	Local aImpGAN := {}
	Local aImpSUS := {}
	Local aImpIBB := {}
	Local aImpIMP := {}
	Local aImpPRV := {}
	Local aImpMun := {}
	Local lImpIVA := .F.
	Local lImpGAN := .F.
	Local lImpSUS := .F.
	Local lImpIBB := .F.
	Local lImpIMP := .F.
	Local lImpMUN := .F.
	Local lImpINT := .F.
	Local lOk     := .F.
	Local aImps   := {}
	
	cProv    := ""
	aClassif := {}
	aConcep  := {}
	cCodIni  := Space(6)
	cLojIni  := Space(2)
	cCodFin  := Space(6)
	cLojFin  := Space(2)

	// Faz a carga dos conceitos de IVA
	aImps := FaImps({"3"},{cTipImp})
	aImpIVA := RetConFF(aImps,nCliFor)

	//Faz a carga dos conceitos de Ganancias
	aImps := FaImps({"4"},{cTipImp})
	aAdd(aImps,{"GAN",0})
	aImpGAN := RetConFF(aImps,0)

	//Faz a carga dos conceitos de SUSS
	aImpSUS := RetX5Tab("CS")

	//Faz a carga dos conceitos de Ingressos Brutos
	aImps := FaImps({"1"},{cTipImp})
	aImpIBB := RetConFF(aImps,nCliFor)

	//Faz a carga dos conceitos de Importações
	aImps := FaImps({"7"},{cTipImp})
	aImpIMP := RetConFF(aImps,0)
	
	//Faz a carga dos conceitos de impostos municipais
	aImpMun := {}

	//Faz a carga das provincias
	aImpPRV := RetX5Tab("12")
	
	oDlg02:=MSDialog():New(000,000,490,450,STR0018+cCmbCli,,,,,,,,,.T.)//Selecione os impostos para os 
	
		@005,005 To 045,180 prompt cCmbCli Pixel Of oDlg02
		oSay01 := tSay():New(017,010,{||STR0019},oDlg02,,,,,,.T.,,,100,20)//Do código:
		oSay02 := tSay():New(017,095,{||STR0020},oDlg02,,,,,,.T.,,,100,20)//Da Loja:
		oGet01 := TGet():New(015,045,{|u| if(PCount()>0,cCodIni:=u,cCodIni)},oDlg02,040,007,,,,,,,,.T.)
		oGet01:cF3 := Iif(nCliFor==1,"FOR","SA1")
		oGet02 := TGet():New(015,125,{|u| if(PCount()>0,cLojIni:=u,cLojIni)},oDlg02,020,007,,,,,,,,.T.)
		
		oSay03 := tSay():New(032,010,{||STR0021},oDlg02,,,,,,.T.,,,100,20)//Até código:
		oSay04 := tSay():New(032,095,{||STR0022},oDlg02,,,,,,.T.,,,100,20)//Até Loja:
		oGet03 := TGet():New(030,045,{|u| if(PCount()>0,cCodFin:=u,cCodFin)},oDlg02,040,007,,,,,,,,.T.)
		oGet03:cF3 := Iif(nCliFor==1,"FOR","SA1")
		oGet04 := TGet():New(030,125,{|u| if(PCount()>0,cLojFin:=u,cLojFin)},oDlg02,020,007,,,,,,,,.T.)
	
		oBtn01:=sButton():New(012,190,1,{|| lOk:=.T. ,oDlg02:End() },oDlg02,.T.,,)
		oBtn02:=sButton():New(028,190,2,{|| lOk:=.F. ,oDlg02:End() },oDlg02,.T.,,)

		@050,005 To 080,220 prompt STR0023 Pixel Of oDlg02//Local
		
		//Est/Dist/Reg
		oSay05 := tSay():New(064,015,{||STR0024},oDlg02,,,,,,.T.,,,100,20)//Est/Dist/Reg
		oCmb01 := tComboBox():New(062,100,{|u| if(PCount()>0,cImpPRV:=u,cImpPRV)},aImpPRV,110,020,oDlg02,,,{|| },,,.T.)
		
		@085,005 To 240,220 prompt STR0025 Pixel Of oDlg02//Impostos/Conceitos
		
		//IVA
		oChk01 := TCheckBox():New(101,015,"",{|| lImpIVA },oDlg02,100,210,,,,,,,,.T.,,,)
		oChk01:bLClicked := {|| lImpIVA:=!lImpIVA }
		oSay06 := tSay():New(103,030,{||STR0026},oDlg02,,,,,,.T.,,,100,20)//IVA
		oCmb02 := tComboBox():New(100,100,{|u| if(PCount()>0,cImpIVA:=u,cImpIVA)},aImpIVA,110,020,oDlg02,,,{|| },,,.T.,,,,{|| lImpIVA })
	
		//Ganancias
		oChk02 := TCheckBox():New(121,015,"",{|| lImpGAN },oDlg02,100,210,,,,,,,,.T.,,,)
		oChk02:bLClicked := {|| lImpGAN:=!lImpGAN }
		oSay07 := tSay():New(123,030,{||STR0027},oDlg02,,,,,,.T.,,,100,20)//Ganancias
		oCmb03 := tComboBox():New(120,100,{|u| if(PCount()>0,cImpGAN:=u,cImpGAN)},aImpGAN,110,020,oDlg02,,,{|| },,,.T.,,,,{|| lImpGAN })
		
		//SUSS
		oChk03 := TCheckBox():New(141,015,"",{|| lImpSUS },oDlg02,100,210,,,,,,,,.T.,,,)
		oChk03:bLClicked := {|| lImpSUS:=!lImpSUS }
		oSay08 := tSay():New(143,030,{||STR0028},oDlg02,,,,,,.T.,,,100,20)//SUSS
		oCmb04 := tComboBox():New(140,100,{|u| if(PCount()>0,cImpSUS:=u,cImpSUS)},aImpSUS,110,020,oDlg02,,,{|| },,,.T.,,,,{|| lImpSUS })
		
		//Ingressos brutos
		oChk04 := TCheckBox():New(161,015,"",{|| lImpIBB },oDlg02,100,210,,,,,,,,.T.,,,)
		oChk04:bLClicked := {|| lImpIBB:=!lImpIBB }
		oSay09 := tSay():New(163,030,{||STR0029},oDlg02,,,,,,.T.,,,100,20)//Ingressos Brutos
		oCmb05 := tComboBox():New(160,100,{|u| if(PCount()>0,cImpIBB:=u,cImpIBB)},aImpIBB,110,020,oDlg02,,,{|| },,,.T.,,,,{|| lImpIBB })
		
		//Impostos de importações
		oChk05 := TCheckBox():New(181,015,"",{|| lImpIMP },oDlg02,100,210,,,,,,,,.T.,,,)
		oChk05:bLClicked := {|| lImpIMP:=!lImpIMP }
		oSay10 := tSay():New(183,030,{||STR0030},oDlg02,,,,,,.T.,,,100,20)//Imp. de Importações
		oCmb06 := tComboBox():New(180,100,{|u| if(PCount()>0,cImpIMP:=u,cImpIMP)},aImpIMP,110,020,oDlg02,,,{|| },,,.T.,,,,{|| lImpIMP })
		
		//Impostos municipais
		oChk06 := TCheckBox():New(201,015,"",{|| lImpMUN },oDlg02,100,210,,,,,,,,.T.,,,)
		oChk06:bLClicked := {|| lImpMUN:=!lImpMUN }
		oSay11 := tSay():New(203,030,{||STR0031},oDlg02,,,,,,.T.,,,100,20)//Imp. Municipais
		oCmb07 := tComboBox():New(200,100,{|u| if(PCount()>0,cImpMUN:=u,cImpMUN)},aImpMUN,110,020,oDlg02,,,{|| },,,.T.,,,,{|| lImpMUN })
	
		//Impostos internos
		oChk07 := TCheckBox():New(221,015,"",{|| lImpINT },oDlg02,100,210,,,,,,,,.T.,,,)
		oChk07:bLClicked := {|| lImpINT:=!lImpINT }
		oSay12 := tSay():New(223,030,{||STR0032},oDlg02,,,,,,.T.,,,100,20)//Imp. Internos

	oDlg02:Activate(,,,.T.,,,)

	//Alimenta vetor com a classificacao dos impostos selecionados
	Iif(lImpIBB,aAdd(aClassif,"1"),) //1 - Ingressos brutos
	Iif(lImpINT,aAdd(aClassif,"2"),) //2 - Impostos internos
	Iif(lImpIVA,aAdd(aClassif,"3"),) //3 - IVA
	Iif(lImpGAN,aAdd(aClassif,"4"),) //4 - Ganancias
	Iif(lImpMUN,aAdd(aClassif,"5"),) //5 - Impostos municipais
	Iif(lImpSUS,aAdd(aClassif,"6"),) //6 - SUSS
	Iif(lImpIMP,aAdd(aClassif,"7"),) //7 - Impostos importação
	
	//Alimenta vetor com os conceitos selecionados
	For nI:=1 To 7
		aAdd(aConcep,"")
	Next nI
	Iif(lImpIBB,aConcep[1] := SubStr(cImpIBB,1,5),)          //1 - Ingressos brutos
	Iif(lImpINT,aConcep[2] := "",)                           //2 - Impostos internos
	Iif(lImpIVA,aConcep[3] := SubStr(cImpIVA,1,5),)          //3 - IVA
	Iif(lImpGAN,aConcep[4] := AllTrim(SubStr(cImpGAN,1,2)),) //4 - Ganancias
	Iif(lImpMUN,aConcep[5] := "",)                           //5 - Impostos municipais
	Iif(lImpSUS,aConcep[6] := AllTrim(SubStr(cImpSUS,1,1)),) //6 - SUSS
	Iif(lImpIMP,aConcep[7] := SubStr(cImpIMP,1,2),)          //7 - Impostos importação
	
	//Provincia selecionada
	cProv := SubStr(cImpPRV,1,2)

Return lOk

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ RetX5Tab ³ Autor ³ Ivan Haponczuk      ³ Data ³ 11.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna os dados de uma determinada tabela de tabelas      ³±±
±±³          ³ genericas (SX5).                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cPar01 - Codigo da tabela                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aRet - Dados da tabela selecionada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Argentina                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RetX5Tab(cTab)

	Local aRet := {}
	
	aAdd(aRet,"")
	dbSelectArea("SX5")
    SX5->(dbSetOrder(1))
    SX5->(dbGoTop())
    If SX5->(dbSeek(xFilial("SX5")+cTab))
    	Do While SX5->X5_TABELA == cTab .and. SX5->(!EOF())
    		aAdd(aRet,AllTrim(SX5->X5_CHAVE)+" - "+AllTrim(SX5->X5_DESCRI))
    		SX5->(dbSkip())
    	EndDo
	EndIf

Return aRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ RetConFF ³ Autor ³ Ivan Haponczuk      ³ Data ³ 11.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna os conceitos da tabela SFF dos impostos indicados. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aPar01 - Array com as informacoes dos impostos.            ³±±
±±³          ³ nPar02 - Movimento ao (1=Fornecedor, 2=Cliente)            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aRet - Array com os codigos e descricoes dos conceitos     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Argentina                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RetConFF(aImps,nCliFor)

	Local nI      := 0
	Local cQry    := ""
	Local aConcep := {}
	
	Default aImps := {}
	
	cQry := " SELECT"
	cQry += "  SFF.FF_ITEM"
	cQry += " ,SFF.FF_CFO_C"
	cQry += " ,SFF.FF_CFO_V"
	cQry += " ,SFF.FF_CONCEPT"
	cQry += " FROM "+RetSqlName("SFF")+" SFF"
	cQry += " WHERE SFF.FF_FILIAL = '"+xFilial("SFF")+"'"
	cQry += " AND SFF.D_E_L_E_T_ = ' '"
	If Len(aImps) == 0
		cQry += " AND SFF.FF_IMPOSTO = '*'"
	Else
		cQry += " AND ( SFF.FF_IMPOSTO = '"+aImps[1,1]+"'"
		For nI:=2 To Len(aImps)
			cQry += " OR SFF.FF_IMPOSTO = '"+aImps[nI,1]+"'"
		Next nI
		cQry += " )"
	EndIf

	If nCliFor == 1 .And. SFF->(FieldPos('FF_FORNECE')) > 0
		cQry += " AND SFF.FF_FORNECE <> ''" //Fornecedor
	EndIf
	cQry := ChangeQuery(cQry)
	TCQUERY CQRY NEW ALIAS "QRY"
	
	aAdd(aConcep,"")
	dbSelectArea("QRY")
	Do While QRY->(!EOF())
		If nCliFor == 1
			Iif(!Empty(QRY->FF_CFO_C),aAdd(aConcep,QRY->FF_CFO_C+" - "+QRY->FF_CONCEPT),) //Mov. de entrada
		ElseIf nCliFor == 2
			Iif(!Empty(QRY->FF_CFO_V),aAdd(aConcep,QRY->FF_CFO_V+" - "+QRY->FF_CONCEPT),) //Mov. de saida
		Else
			Iif(!Empty(QRY->FF_ITEM),aAdd(aConcep,QRY->FF_ITEM+" - "+QRY->FF_CONCEPT),) //Independente do movimento
		EndIf
		QRY->(dbSkip())
	EndDo
	QRY->(dbCloseArea())

Return aConcep

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FaImps   ³ Autor ³ Ivan Haponczuk      ³ Data ³ 11.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Busca as informacoes dos impostos de acordo com os         ³±±
±±³          ³ paramentros informados.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aPar01 - Array com as classificacoes fiscais               ³±±
±±³          ³ aPar02 - Array com as classes dos impostos                 ³±±
±±³          ³ cPar03 - Provincia                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aRet - Array com as informacoes dos impostos               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Argentina                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FaImps(aClassif,aClasse,cProv)

	Local nI    := 0
	Local cQry  := ""
	Local aImps := {}
	
	//Se estiver vazio traz todos impostos classificados
	Default aClassif := {}
	Default aClasse  := {}
	Default cProv    := ""
	
	cQry := " SELECT"
	cQry += "  SFB.FB_CODIGO"
	cQry += " ,SFB.FB_CPOLVRO"
	cQry += " ,SFB.FB_CLASSIF"
	cQry += " FROM "+RetSqlName("SFB")+" SFB"
	cQry += " WHERE SFB.FB_FILIAL = '"+xFilial("SFB")+"'"
	cQry += " AND SFB.D_E_L_E_T_ = ' '"
	
	//Faz o filtro do campo classif
	If Len(aClassif) <= 0
		cQry += " AND SFB.FB_CLASSIF <> ' '"
	Else
		cQry += " AND ("
		cQry += " SFB.FB_CLASSIF = '"+aClassif[1]+"'"
		For nI:=2 To Len(aClassif)
			cQry += " OR SFB.FB_CLASSIF = '"+aClassif[nI]+"'"
		Next nI
		cQry += " )"
	EndIf
	
	//Faz o filtro do campo classe
	If Len(aClasse) <= 0
		cQry += " AND SFB.FB_CLASSE <> ' '"
	Else
		cQry += " AND ("
		cQry += " SFB.FB_CLASSE = '"+aClasse[1]+"'"
		For nI:=2 To Len(aClasse)
			cQry += " OR SFB.FB_CLASSE = '"+aClasse[nI]+"'"
		Next nI
		cQry += " )"
	EndIf
	
	//Faz o filtro por provincia
	If !Empty(cProv)
		cQry += " AND SFB.FB_ESTADO = '"+cProv+"'"
	EndIf
	
	cQry += "ORDER BY SFB.FB_CPOLVRO"
	
	cQry := ChangeQuery(cQry)
	TCQUERY CQRY NEW ALIAS "QRY"
	
	dbSelectArea("QRY")
	Do While QRY->(!EOF())
		aAdd(aImps,{QRY->FB_CODIGO,QRY->FB_CPOLVRO,QRY->FB_CLASSIF})
		QRY->(dbSkip())
	EndDo
	QRY->(dbCloseArea())

Return aImps

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FaCmbSer ³ Autor ³ Ivan Haponczuk      ³ Data ³ 11.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Busca seres utilizadas nas notas do sistema.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aRet - Array com as series do sistema                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Argentina                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FaCmbSer()

	Local cQry   := ""
	Local aSerie := {}
	
	aAdd(aSerie,"")
	
	cQry := " SELECT"
	cQry += " SF3.F3_SERIE"
	cQry += " FROM "+RetSqlName("SF3")+" SF3"
	cQry += " WHERE SF3.F3_FILIAL = '"+xFilial("SF3")+"'"
	cQry += " AND SF3.D_E_L_E_T_ = ' '"
	cQry += " GROUP BY SF3.F3_SERIE"

	TCQUERY CQRY NEW ALIAS "QRY"
	
	dbSelectArea("QRY")
	Do While QRY->(!EOF())
		aAdd(aSerie,QRY->F3_SERIE)
		QRY->(dbSkip())
	EndDo
	QRY->(dbCloseArea())

Return aSerie

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FaCmbDoc ³ Autor ³ Ivan Haponczuk      ³ Data ³ 11.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna os tipos de documentos utilizados no sistema.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aRet - Array com as tipos de documentos suportados.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Argentina                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FaCmbDoc()

	Local cQry     := ""
	Local aEspecie := {}
	
	aAdd(aEspecie,"OP") //Ordem de pago
	aAdd(aEspecie,"RC") //Recibo

	cQry := " SELECT"
	cQry += " SF3.F3_ESPECIE"
	cQry += " FROM "+RetSqlName("SF3")+" SF3"
	cQry += " GROUP BY SF3.F3_ESPECIE"
	
	cQry := ChangeQuery(cQry)
	TCQUERY CQRY NEW ALIAS "QRY"
	
	dbSelectArea("QRY")
	Do While QRY->(!EOF())
		aAdd(aEspecie,QRY->F3_ESPECIE)
		QRY->(dbSkip())
	EndDo
	QRY->(dbCloseArea())

Return aEspecie

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FQryFE   ³ Autor ³ Ivan Haponczuk      ³ Data ³ 11.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faz a consulta nos certificados de retencao de acordo com  ³±±
±±³          ³ os paramentros informados.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nPar01 - Movimento ao (1=Fornecedor, 2=Cliente)            ³±±
±±³          ³ dPar02 - Data inicial do periodo                           ³±±
±±³          ³ dPar03 - Data final do periodo                             ³±±
±±³          ³ cPar04 - Especie do documento                              ³±±
±±³          ³ cPar05 - Numero do comprovante de retencao                 ³±±
±±³          ³ cPar06 - Codigo do cliente/fornecedor                      ³±±
±±³          ³ cPar07 - Codigo da loja                                    ³±±
±±³          ³ cPar08 - Codito ate cliente/fornecedor                     ³±±
±±³          ³ cPar09 - Codigo ate loja                                   ³±±
±±³          ³ cPar10 - Provincia            o                            ³±±
±±³          ³ cPar11 - Array com as classificacoes fiscais               ³±±
±±³          ³ cPar12 - Array com os conceitos usados (CFOS/CONCEPTS)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aRet - Array com os campos que devem ser apresentados      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Argentina                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FQryFE(nCliFor,dDadaDe,dDataAte,cEspecie,cDocNum,cCodIni,cLojIni,cCodFin,cLojFin,cProv,aClassif,aConcep)
 
	Local nI    := 0
	Local cQry  := ""
 	Local aHead := {}

	Default nCliFor  := 1
	Default dDadaDe  := dDataBase
	Default dDataAte := dDataBase
	Default cEspecie := ""
	Default cDocNum  := ""
	Default cProv    := ""
	Default cCodIni  := ""
	Default cLojIni  := ""
	Default cCodFin  := ""
	Default cLojFin  := ""
	Default aConcep  := {}
	Default aClassif := {}
	
	aAdd(aHead,"FE_NROCERT")
	If nCliFor == 1
		aAdd(aHead,"FE_FORNECE")
		aAdd(aHead,"FE_LOJA")		
	Else
		aAdd(aHead,"FE_CLIENTE")
		aAdd(aHead,"FE_LOJCLI")
	EndIf
	If nCliFor == 2
		aAdd(aHead,"A1_NOME")
		aAdd(aHead,"A1_CGC")
	Else
		aAdd(aHead,"A2_NOME")
		aAdd(aHead,"A2_CGC")
	EndIf
	aAdd(aHead,"FE_CONCEPT")
	aAdd(aHead,"FE_TIPO")
	aAdd(aHead,"FE_ORDPAGO")
	aAdd(aHead,"FE_VALBASE")
	aAdd(aHead,"FE_ALIQ")
	aAdd(aHead,"FE_RETENC")
	
	cQry := " SELECT"
	cQry += "  SFE.FE_FILIAL"
	For nI:=1 To Len(aHead)
		cQry += " ,"+aHead[nI]
	Next nI
	cQry += " FROM "+RetSqlName("SFE")+" SFE"  
  	If nCliFor == 2                                                      
		cQry += " INNER JOIN "+RetSqlName("SA1")+" SA1"
		cQry += " ON SA1.A1_COD = SFE.FE_CLIENTE "
		cQry += " AND SA1.A1_LOJA = SFE.FE_LOJCLI "
	Else
		cQry += " INNER JOIN "+RetSqlName("SA2")+" SA2"
		cQry += " ON SA2.A2_COD = SFE.FE_FORNECE " 
		cQry += " AND SA2.A2_LOJA = SFE.FE_LOJA "
	EndIf 
	cQry += " WHERE SFE.FE_FILIAL = '"+xFilial("SFE")+"'"
	cQry += " AND SFE.D_E_L_E_T_ = ' '"
	cQry += " AND SFE.FE_NROCERT <> 'NORET'"
 	
 	//Filtra movimentos de fornecedores/clientes
 	If nCliFor == 1
		cQry += " AND SFE.FE_FORNECE <> ''" //Fornecedor
	Else
		cQry += " AND SFE.FE_CLIENTE <> ''" //Cliente
	EndIf
 
	//Filtra movimento entra as datas
	cQry += " AND SFE.FE_EMISSAO >= '"+DTOS(dDadaDe)+"'"
	cQry += " AND SFE.FE_EMISSAO <= '"+DTOS(dDataAte)+"'"
	
	//Filtra pro numero do documento
	If !Empty(cDocNum)
		If cEspecie == "OP"
			cQry += " AND SFE.FE_ORDPAGO = '"+cDocNum+"'"
		ElseIf cEspecie == "RC"
			cQry+=" AND SFE.FE_RECIBO = '"+cDocNum+"'" 
		Else
			cQry+=" AND SFE.FE_NROCERT = '"+cDocNum+"'" 
		EndIf
	Else
		If cEspecie == "OP"
			cQry += " AND SFE.FE_ORDPAGO <> ''"
		ElseIf cEspecie == "RC"
			cQry += " AND SFE.FE_RECIBO <> ''"
		EndIf
	EndIf
	
	//Filtra por provincia
	If !Empty(cProv)
		cQry += " AND SFE.FE_EST = '"+cProv+"'"
	EndIf
	
	//Filtra do cliente/fornecedor ate cliente/fornecedor
	If !Empty(cCodIni) .or. !Empty(cLojIni) .or. !Empty(cCodFin) .or. !Empty(cLojFin)
	 	If nCliFor == 1 //Fornecedor
			cQry += " AND SFE.FE_FORNECE >= '"+cCodIni+"'"
			cQry += " AND SFE.FE_FORNECE <= '"+cCodFin+"'"
			cQry += " AND SFE.FE_LOJA >= '"+cLojIni+"'"
			cQry += " AND SFE.FE_LOJA <= '"+cLojFin+"'"
		Else //Cliente
			cQry += " AND SFE.FE_CLIENTE >= '"+cCodIni+"'"
			cQry += " AND SFE.FE_CLIENTE <= '"+cCodFin+"'"
			cQry += " AND SFE.FE_LOJCLI >= '"+cLojIni+"'"
			cQry += " AND SFE.FE_LOJCLI <= '"+cLojFin+"'"
		EndIf
	EndIf
	
	//Filtra pelo imposto e conceito
	If Len(aClassif) > 0
		cQry += " AND ("
		For nI:=1 To Len(aClassif)
			If nI > 1
				cQry += " OR"
			EndIf
			If aClassif[nI] == "1"//Ingressos brutos
				cQry += " ( SFE.FE_TIPO = 'B'"
				If !Empty(aConcep[1])
					cQry += " AND SFE.FE_CFO = '"+aConcep[1]+"'"
				EndIf
				cQry += " )"
			ElseIf aClassif[nI] == "3"//IVA
				cQry += " ( SFE.FE_TIPO = 'I'"
				If !Empty(aConcep[3])
					cQry += " AND  SFE.FE_CFO = '"+aConcep[3]+"'"
				EndIf
				cQry += " )"
			ElseIf aClassif[nI] == "4"//Ganancias
				cQry += " ( SFE.FE_TIPO = 'G'"
				If !Empty(aConcep[4])
					cQry += " AND SFE.FE_CONCEPT = '"+aConcep[4]+"'"
				EndIf
				cQry += " )"
			ElseIf aClassif[nI] == "6"//SUSS
				cQry += " ( SFE.FE_TIPO = 'S'"
				If !Empty(aConcep[6])
					cQry += " AND SFE.FE_CONCEPT = '"+aConcep[6]+"'"
				EndIf
				cQry += " )"
			Else
				cQry += " SFE.FE_TIPO = '*'"
			EndIf
		Next nI
		cQry += " )"
	EndIf

	cQry := ChangeQuery(cQry)	
	TCQUERY CQRY NEW ALIAS "QRYCON"
	
	dbSelectArea("QRYCON")
	QRYCON->(dbGoTop())
	If QRYCON->(EOF())
		aHead := {}
	EndIf

Return aHead

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FQryF3   ³ Autor ³ Ivan Haponczuk      ³ Data ³ 11.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faz a consulta nos certificados de retencao de acordo com  ³±±
±±³          ³ os paramentros informados.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nPar01 - Movimento ao (1=Fornecedor, 2=Cliente)            ³±±
±±³          ³ dPar02 - Data inicial do periodo                           ³±±
±±³          ³ dPar03 - Data final do periodo                             ³±±
±±³          ³ aPar04 - Vetor com as informacoes dos impostos             ³±±
±±³          ³ cPar05 - Especie do documento                              ³±±
±±³          ³ cPar06 - Serie do documento                                ³±±
±±³          ³ cPar07 - Numero do documento                               ³±±
±±³          ³ cPar08 - Codigo do cliente/fornecedor                      ³±±
±±³          ³ cPar09 - Codigo da loja                                    ³±±
±±³          ³ cPar10 - Codito ate cliente/fornecedor                     ³±±
±±³          ³ cPar11 - Codigo ate loja                                   ³±±
±±³          ³ cPar12 - Array com os conceitos usados (CFOS/CONCEPTS)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aRet - Array com os campos que devem ser apresentados      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Argentina                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FQryF3(nCliFor,dDadaDe,dDataAte,aImps,cEspecie,cSerie,cDocNum,cCodIni,cLojIni,cCodFin,cLojFin,aConcep)

	Local nI    := 1
	Local nX    := 0
	Local cQry  := ""
	Local aHead := {}
	Local aStruSF3  := {}
	Default nCliFor  := 1
	Default dDadaDe  := dDataBase
	Default dDataAte := dDataBase
	Default cEspecie := ""
	Default cSerie   := ""
	Default cDocNum  := ""
	Default cCodIni  := ""
	Default cLojIni  := ""
	Default cCodFin  := ""
	Default cLojFin  := ""
	Default aImps    := {}
	Default aConcep  := {}
	
	//Adiciona campos a serem apresentados
	aAdd(aHead,"FB_DESCR")
	aAdd(aHead,"F3_ESPECIE")
	aAdd(aHead,"F3_ENTRADA")                                            
	aAdd(aHead,"F3_CLIEFOR")
	If nCliFor == 2
		aAdd(aHead,"A1_NOME")
		aAdd(aHead,"A1_CGC")
	Else
		aAdd(aHead,"A2_NOME")
		aAdd(aHead,"A2_CGC")
	EndIf		
	aAdd(aHead,"F3_LOJA")
	aAdd(aHead,"F3_SERIE")
	aAdd(aHead,"F3_NFISCAL")
	aAdd(aHead,"F3_CFO")
	
	//Seleciona os campos 

	aStruSF3  := SF3->(dbStruct())
	
	
	cQry := " SELECT"
	cQry += "  SF3.F3_FILIAL"
	For nI:=1 To Len(aHead)
		cQry += " ,"+aHead[nI]
	Next nI
	
	//Filtra campos de valores 
	aAdd(aHead,"F3_BASIMP1")
	aAdd(aHead,"F3_ALQIMP1")
	aAdd(aHead,"F3_VALIMP1")
	cQry += " ,( CASE"
	For nI:=1 To Len(aImps)
			cQry += " WHEN FB_CPOLVRO = '"+aImps[nI,2]+"' THEN SF3.F3_BASIMP"+aImps[nI,2]
	Next nI
	cQry += " ELSE 0 END ) AS F3_BASIMP1"
	cQry += " ,( CASE"
	For nI:=1 To Len(aImps)
		cQry += " WHEN FB_CPOLVRO = '"+aImps[nI,2]+"' THEN SF3.F3_ALQIMP"+aImps[nI,2]
	Next nI
	cQry += " ELSE 0 END ) AS F3_ALQIMP1"
	cQry += " ,( CASE"
	For nI:=1 To Len(aImps)
		cQry += " WHEN FB_CPOLVRO = '"+aImps[nI,2]+"' THEN SF3.F3_VALIMP"+aImps[nI,2]
	Next nI
	cQry += " ELSE 0 END ) AS F3_VALIMP1"
	
	cQry += " FROM "+RetSqlName("SF3")+" SF3"
	
	//Filtra pelos impostos e conceitos
	If nCliFor == 2                                                      
		cQry += " INNER JOIN "+RetSqlName("SA1")+" SA1"
		cQry += " ON SA1.A1_COD = SF3.F3_CLIEFOR "
		cQry += " AND SA1.A1_LOJA = SF3.F3_LOJA "
	Else
		cQry += " INNER JOIN "+RetSqlName("SA2")+" SA2"
		cQry += " ON SA2.A2_COD = SF3.F3_CLIEFOR "
		cQry += " AND SA2.A2_LOJA = SF3.F3_LOJA "
	EndIf	 
	cQry += " INNER JOIN "+RetSqlName("SFB")+" SFB ON (	"
	For nI:=1 To Len(aImps)
		If nI > 1
			cQry += " OR"
		EndIf
		cQry += " ( SFB.FB_CODIGO = '"+aImps[nI,1]+"' AND SF3.F3_BASIMP"+aImps[nI,2]+" > '0'"
		
		//Filtra por conceito
		If Len(aConcep) > 0
			If !Empty(aConcep[Val(aImps[nI,3])])
				cQry += " AND SF3.F3_CFO = '"+aConcep[Val(aImps[nI,3])]+"'"
			EndIf
		EndIf
		
		cQry += " )"
	Next nI  
	cQry += " AND SFB.FB_FILIAL = '"+xFilial("SFB")+"'"
	cQry += " AND SFB.D_E_L_E_T_ = ' '"
	cQry += " )"
	
	cQry += " WHERE SF3.F3_FILIAL = '"+xFilial("SF3")+"'"
	cQry += " AND SF3.D_E_L_E_T_ = ' '"
	
	//Filtra movimentos de fornecedores/clientes
	If nCliFor == 1
		cQry += " AND SF3.F3_TIPOMOV = 'C'" //Fornecedor
	Else
		cQry += " AND SF3.F3_TIPOMOV = 'V'" //Cliente
	EndIf
	
	//Filtra movimento entra as datas
	cQry += " AND SF3.F3_EMISSAO >= '"+DTOS(dDadaDe)+"'"
	cQry += " AND SF3.F3_EMISSAO <= '"+DTOS(dDataAte)+"'"
	
	//Filtra por especie
	If !Empty(cEspecie)
		cQry += " AND SF3.F3_ESPECIE = '"+cEspecie+"'"
	EndIf
	
	//Filtra por serie
	If !Empty(cSerie)
		cQry += " AND SF3.F3_SERIE = '"+cSerie+"'"
	EndIf
	
	//Filtra pro numero do documento
	If !Empty(cDocNum)
		cQry += " AND SF3.F3_NFISCAL = '"+cDocNum+"'"
	EndIf
	
	//Filtra do cliente/fornecedor ate cliente/fornecedor
	If !Empty(cCodIni) .or. !Empty(cLojIni) .or. !Empty(cCodFin) .or. !Empty(cLojFin)
		cQry += " AND SF3.F3_CLIEFOR >= '"+cCodIni+"'"
		cQry += " AND SF3.F3_CLIEFOR <= '"+cCodFin+"'"
		cQry += " AND SF3.F3_LOJA >= '"+cLojIni+"'"
		cQry += " AND SF3.F3_LOJA <= '"+cLojFin+"'"
	EndIf
	
	//Ordenado por imposto
	cQry += " ORDER BY SFB.FB_DESCR"
	
	cQry := ChangeQuery(cQry)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry ),"QRYCON",.T.,.T.)
	For nX := 1 To Len(aStruSF3)
		If aStruSF3[nX][2] <> "C" .And. FieldPos(aStruSF3[nX][1])<>0
			TcSetField("QRYCON",aStruSF3[nX][1],aStruSF3[nX][2],aStruSF3[nX][3],aStruSF3[nX][4])
		EndIf
	Next nX
	
	

	dbSelectArea("QRYCON")
	QRYCON->(dbGoTop())
	If QRYCON->(EOF())
		aHead := {}
	EndIf

Return aHead

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Tela3    ³ Autor ³ Ivan Haponczuk      ³ Data ³ 11.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cria tela de apresentacao dos dados da consulta.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cPar01 - Alias da tabela a ser usada                       ³±±
±±³          ³ aPar02 - Array com os campos da query a serem apresentados ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nulo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Argentina                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Tela3(cAlias,aHead)

	Local   nI       := 0
	Local   nTotBas  := 0
	Local   nTotVal  := 0
	Local   cTotBas  := ""
	Local   cTotVal  := ""
	Local   aSize    := MsAdvSize()
	Local   aHeader  := {} 
	Local	lCred	 := .F.
	Private aCols    := {}
	Private aButtons := {}
	
	//Define os campos de totais
	If cAlias == "SF3"
		cTotBas  := "F3_BASIMP1"
		cTotVal  := "F3_VALIMP1"
	ElseIf cAlias == "SFE"
		cTotBas  := "FE_VALBASE"
		cTotVal  := "FE_RETENC"
	EndIf	
	
	//Busca dados dos campos a serem apresentados
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	For nI:=1 To Len(aHead)
		SX3->(dbSeek(aHead[nI]))
		Aadd(aHeader,{ AllTrim(X3Titulo()),;
		     TRIM(SX3->X3_CAMPO),;
		     SX3->X3_PICTURE,;
		     SX3->X3_TAMANHO,;
		     SX3->X3_DECIMAL,;
	         SX3->X3_VALID,;
	         SX3->X3_USADO,;
	         SX3->X3_TIPO,;
	         SX3->X3_ARQUIVO,;
	         SX3->X3_CONTEXT } )
	Next nI
	
	//Preenche o vetos com os dados da query
   	dbSelectArea("QRYCON") 
   	
	QRYCON->(dbGoTop())
	Do While QRYCON->(!EOF())
	
		aAdd(aCols,Array(Len(aHead)+1)) 
		For nI:=1 To Len(aHead)
			aCols[Len(aCols)][nI] := &("QRYCON->"+aHead[nI]) 
			
			If Alltrim(aHead[nI])=="F3_ESPECIE" .And. Alltrim(aCols[Len(aCols)][nI])$"NCP/NDI/NCC/NDE"
				lCred := .T.
			ElseIf Alltrim(aHead[nI])$"F3_VALIMP1/FE_RETENC/F3_BASIMP1/FE_VALBASE" .And. lCred
				aCols[Len(aCols)][nI] := aCols[Len(aCols)][nI] * (-1)
			EndIf                                   
			
		Next nI
	   
	   aCols[Len(aCols)][nI] := .F.      

	    If lCred
			nTotVal  -= &("QRYCON->"+cTotVal)
			nTotBas  -= &("QRYCON->"+cTotBas)
		Else
			nTotVal  += &("QRYCON->"+cTotVal) 
			nTotBas  += &("QRYCON->"+cTotBas)
		EndIf
		
		lCred := .F.
		QRYCON->(dbSkip())  
		
	EndDo        
	
	//Cria linha dos totalizadores
	aAdd(aCols,Array(Len(aHead)+1))
	aCols[Len(aCols)][1] := STR0039//TOTAIS
	aCols[Len(aCols)][aScan(aHead,{|x| x == cTotBas})] := nTotBas
	aCols[Len(aCols)][aScan(aHead,{|x| x == cTotVal})] := nTotVal
	aCols[Len(aCols)][Len(aCols[Len(aCols)])] := .F.

	oDlg03:=MSDialog():New(000,000,aSize[6],aSize[5],STR0040,,,,,,,,,.T.)//"Consulta de Impostos"
	
		oGetDados:=	MsNewGetDados():New(015,000,(aSize[6]/2),(aSize[5]/2),1,"AllwaysTrue","AllwaysTrue",,,,,"AllwaysTrue",,,oDlg03,aHeader,aCols)  
		aAdd(aButtons,{"PAPEL_ESCRITO",{|| FConImp(aHeader,aCols)},STR0033,STR0034,{|| .T.}})//Imprimir###Imprimir
		
	oDlg03:Activate(,,,.T.,,,{|| EnchoiceBar(oDlg03,{||oDlg03:End()},{||oDlg03:End()},,@aButtons)})

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FConImp  ³ Autor ³ Ivan Haponczuk      ³ Data ³ 11.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inicializa a impressao dos dados apresentados na tela.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aPar01 - Array com os campos a serem apresentados          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nulo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Argentina                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FConImp(aHeader,aCols)

	Local oReport := Nil

	oReport := TReport():New("CONIMP",STR0035,,{|oReport| FSetImp(oReport,aHeader,aCols)},STR0036)//Relatorio de Consulta de Impostos###Relatorio de Consulta de Impostos
	oReport:SetLandscape() 
	oReport:SetTotalInLine(.F.)
	oReport:PrintDialog()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FSetImp  ³ Autor ³ Ivan Haponczuk      ³ Data ³ 11.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inicializa a impressao dos dados apresentados na tela.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oPar01 - Objeto de impressao do relatorio                  ³±±
±±³          ³ aPar02 - Array com os campos a serem apresentados          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nulo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Argentina                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FSetImp(oReport,aHeader,aCols)

	Local nI      := 0
	Local nJ      := 0
	Local nLin    := 0
	Local nAltPag := 0
	
	oReport:SetTitle(STR0037)//Relatorio de Consulta de Impostos
	oDetalhe := TRSection():New(oReport,STR0038,)//Relatorio de Consulta de Impostos
	For nI:=1 To Len(aHeader)
		TRCell():New(oDetalhe,aHeader[nI,2],,aHeader[nI,1],,aHeader[nI,4],.F.)
	Next nI
	nAltPag := oReport:PageHeight() - 2
	nLin := 0
	oReport:SetMeter(QRYCON->(RecCount()) + 1)
	oDetalhe:Init()
	
	For nI:=1 to Len(aCols)
		For nJ:=1 To Len(aHeader)
			oDetalhe:Cell(aHeader[nJ,2]):SetValue(aCols[nI,nJ])
		Next nJ
		oDetalhe:PrintLine()
		nLin := oReport:Row()
		If nLin >= nAltPag
			oReport:EndPage()
			oDetalhe:Init()
		Endif
		QRYCON->(dbSkip())
		oReport:IncMeter()
	Next nI
	oReport:IncMeter()

Return Nil
