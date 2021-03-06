#DEFINE BOTTOMPAGE 60
#INCLUDE "PROTHEUS.CH"
#INCLUDE "CTACTECOB.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �CTACTECOB  � Autor � MS			        � Data � 01.03.00 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Cuenta corriente de Cliente                                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Totvs Argentina                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CTACTECOB()

Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport := ReportDef()
	oReport:PrintDialog()
Endif

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportDef �Autor  �MS				     � Data �  21/07/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tratamanto release 04                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportDef()

Local oReport,oSection1,oSection2
Local cReport := "CTACTECOB"
Local cTitulo := STR0003 	// "Informe de Pagos"
Local cDescri := STR0003
Local cPerg := "CTACTECOB "  // "FIR13X"
Local aAjustaX1[0], aHelpSX1[0]
Local aOrdem   := {"Informe Estandard","Por grupo de cliente"}   // Ordem do Relatorio.

//���������������������������������������������������������������������Ŀ
//� Ajusta la tabla de preguntas.                                       �
//�����������������������������������������������������������������������

// Hace primero la matriz de help.
// Cada linea de la matriz es el help de un campo diferente y cada
// colunma de la matriz es una linea del help en la pantalla para el usuario.
aAdd(aHelpSX1, {"Digite el c�digo inicial del intervalo de", "c�digos de clientes que se desea", "imprimir (F3 disponible)."})
aAdd(aHelpSX1, {"Digite el c�digo final del intervalo de", "c�digos de clientes que se desea", "imprimir (F3 disponible)."})
aAdd(aHelpSX1, {"Digite la fecha inicial del intervalo de", "fechas."})
aAdd(aHelpSX1, {"Digite la fecha final del intervalo de", "fechas."})
aAdd(aHelpSX1, {"Elija si desea imprimir el informa", "analitico o sintetico."})
aAdd(aHelpSX1, {"Informe si debe considerar los t�tulos", "sin saldo."})
aAdd(aHelpSX1, {"Informe la orden a ser considerada."})
aAdd(aHelpSX1, {"Informe si debe imprimir una p�gina", "por cliente."})
aAdd(aHelpSX1, {"Informe cual formato ser� considerado."})
aAdd(aHelpSX1, {"Informe cual fecha ser� considerada."})
aAdd(aHelpSX1, {"Informe si debe calcular y mostrar", "el saldo inicial."})
aAdd(aHelpSX1, {"Informe la tasa de conversi�n a", "ser considerada."})
aAdd(aHelpSX1, {"Elija la moneda que se desea considerar", "en la generaci�n del informe."})
aAdd(aHelpSX1, {"Informe si debe imprimir registros", "en otras monedas."})
aAdd(aHelpSX1, {"Digite el c�digo del grupo de clientes", "."})

// Hace la matriz de preguntas.
aAdd(aAjustaX1, {"01", "�De cliente?",            "G", {"C", 06,, "SA1"},,, aHelpSX1[1]})
aAdd(aAjustaX1, {"02", "�A cliente?",             "G", {"C", 06,, "SA1"},,, aHelpSX1[2]})
aAdd(aAjustaX1, {"03", "�De fecha?",              "G", {"D"},,, aHelpSX1[3]})
aAdd(aAjustaX1, {"04", "�A fecha?",               "G", {"D"},,, aHelpSX1[4]})
aAdd(aAjustaX1, {"05", "�Imprime?",               "C", {1, "Analitico"   , "Sintetico"},,, aHelpSX1[5]})
aAdd(aAjustaX1, {"06", "�Imprime saldo cero?",    "C", {2, "Si"          , "No"       },,, aHelpSX1[6]})
aAdd(aAjustaX1, {"07", "�Ordenado por?",          "C", {1, "Codigo"      , "R. social"},,, aHelpSX1[7]})
aAdd(aAjustaX1, {"08", "�Pagina por cliente?",    "C", {1, "No"          , "Si"       },,, aHelpSX1[8]})
aAdd(aAjustaX1, {"09", "�Formato?",               "C", {1, "Normal"      , "Archivo"  },,, aHelpSX1[9]})
aAdd(aAjustaX1, {"10", "�Fecha de referencia?",   "C", {1, "Emision"     , "Vencimiento", "Registro"},,, aHelpSX1[10]})
aAdd(aAjustaX1, {"11", "�Saldo inicial?",         "C", {1, "Si"          , "No"       },,, aHelpSX1[11]})
aAdd(aAjustaX1, {"12", "�Convierte valores por?", "C", {2, "Tasa del dia", "Tasa del mov."},,, aHelpSX1[12]})
aAdd(aAjustaX1, {"13", "�Que moneda?",            "C", {1, "Moneda 1"    , "Moneda 2", "Moneda 3", "Moneda 4", "Moneda 5"},,, aHelpSX1[13]})
aAdd(aAjustaX1, {"14", "�Otras monedas?",         "C", {1, "Convertir"   , "No imprimir"},,, aHelpSX1[14]})
aAdd(aAjustaX1, {"15", "�Grupo de clientes?",     "G", {"C", 06,, "SA1"},,, aHelpSX1[15]})


DbSelectArea("SX1")
IF SX1->(DbSeek(cPerg+"13"))
   IF RecLock("SX1",.F.)
      Replace X1_TAMANHO   With 2
	  Replace X1_GSC       With "G"
	  Replace X1_TIPO      With "N"
	  Replace X1_VALID     With "U_McVerMoeda() .and. VerifMoeda(mv_par12)"
      SX1->(MsUnlock())
   ENDIF
ENDIF

// Atualiza a tabela de perguntas (SX1).
AjustaX1(cPerg, aAjustaX1, .F.)
Pergunte(cPerg, .F.)

oReport := TReport():New(cReport, cTitulo, cPerg, {|oReport| ReportPrint(oReport, "SE1")}, cDescri)
oSection1 := TRSection():New( oReport,STR0039, {"SA1"}, aOrdem) // Se agrego el orden Fernando Cardeza
TrPosition():New(oSection1,'SA1',1,{|| xFilial('SA1')+TRB->CODCLI+TRB->LOJA} )
oSection2 := TRSection():New( oSection1,STR0040 ,  )
TRCell():New( oSection2,"E1_TIPO"      ,"SE1", /*X3Titulo*/, /*Picture*/, 05 /*Tamanho*/, /*lPixel*/,)
TRCell():New( oSection2,"E1_NUM"       ,"SE1", /*X3Titulo*/, /*Picture*/, TamSX3("E1_NUM")[1] + TamSx3("E1_PREFIXO")[1] + 7 /*Tamanho*/, /*lPixel*/,)
TRCell():New( oSection2,"E1_EMISSAO"   ,"SE1", /*X3Titulo*/, /*Picture*/, 15 /*Tamanho*/, /*lPixel*/,)
TRCell():New( oSection2,"E1_VENCREA"   ,"SE1", STR0033 + CRLF + STR0034 /*X3Titulo*/   ,/*Picture*/,/*Tamanho*/,/*lPixel*/,)
TRCell():New( oSection2,"DEBITO"       ,"   ", STR0035 /*X3Titulo*/, PesqPict("SE1","E1_VALOR")/*Picture*/, 15 /*Tamanho*/, /*lPixel*/,)
TRCell():New( oSection2,"CREDITO"      ,"   ", STR0036 /*X3Titulo*/, PesqPict("SE1","E1_VALOR")/*Picture*/, 15 /*Tamanho*/, /*lPixel*/,)
TRCell():New( oSection2,"SALDO"        ,"   ", STR0038 + CRLF + STR0037 /*X3Titulo*/, PesqPict("SE1","E1_VALOR") /*Picture*/, 15 /*Tamanho*/, /*lPixel*/,)
TRCell():New( oSection2,"MONEDA"       ,"   ", STR0043 + CRLF + STR0044 /*X3Titulo*/, /*Picture*/, 8/*Tamanho*/, /*lPixel*/,)
TRCell():New( oSection2, "A1_COD"   ,"SA1",/*X3Titulo*/  ,/*Picture*/,TamSX3("A1_COD")[1]+TamSx3("A1_LOJA")[1]+2,/*lPixel*/,)
TRCell():New( oSection2, "A1_NOME"  ,"SA1",/*X3Titulo*/  ,/*Picture*/,/*Tamanho*/,/*lPixel*/,)

TrPosition():New(oSection2,'SA1',1,{|| xFilial('SA1')+TRB->CODCLI+TRB->LOJA} )

oSection2:Cell("DEBITO" ):SetHeaderAlign("RIGHT")
oSection2:Cell("CREDITO"):SetHeaderAlign("RIGHT")
oSection2:Cell("SALDO"  ):SetHeaderAlign("RIGHT")

Return oReport


/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �ReportPrint�Autor  �Paulo Augusto       � Data �  21/07/06   ���
��������������������������������������������������������������������������͹��
���Desc.     �Rotina de impressao                                          ���
��������������������������������������������������������������������������͹��
���Uso       � SIGAFIN                                                     ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function ReportPrint( oReport )
Local oSection1 := oReport:Section(1)
Local oSection2 := oSection1:Section(1)
Local lAgregSEK := .F., cLoja
Local nOrdem    := oSection1:GetOrder()
//Local _nOrden   := oSection1:GetOrder()   //Antes tenia un 1 // [8] Ordem a ser selecionada.
Local aTipDoc   := {{"FT ", "FT"}, {"NF ", "FT"}, {"NCC", "NC"}, {"NDC", "ND"}}
Local nDebCli   := 0
Local nCredCli  := 0
Local nSalAC    := 0
Local nTotDeb   := 0
Local nTotCred  := 0
Local nTotMO    := 0
Local nRecno    := 0
Local aFields[0]
Local cDbfTmp
Local cNtxTmp
Local cSerie
Local cRecibo
Local nOrdSe1
Local nRecSe1
Local cTipo
Local nPosTp
Local lSalAnt
Local lCancel
Local aReg
Local cFiltro    := oSection1:GetAdvPlExp('SA1')
Local nMoeda     := mv_par13
Local lFuturo    := .F.
Private nDecs    := MsDecimais(1)
Private cCodCli  := ""
Private cCliente := ""
Private cTelef   := ""
Private cContact := ""

If !Empty(oReport:uParam)
	Pergunte(oReport:uParam,.F.)
Endif

IF empty(MV_PAR13)
   MSGINFO("Debe informar la moneda del reporte!!")
   Return
ENDIF


oReport:SetTitle(STR0003 + STR0041  + SuperGetMv("MV_MOEDA"+LTrim(Str(MV_PAR13))))
AAdd(aFields, {"CODCLI",    "C", TamSX3('A1_COD')[1],  0})
AAdd(aFields, {"LOJA" ,     "C", TamSX3('A1_LOJA')[1], 0})
AAdd(aFields, {"CLIENTE",   "C", 25, 0})
AAdd(aFields, {"TIPODOC",   "C",  2, 0})
AAdd(aFields, {"SERIE",     "C",  3, 0})
AAdd(aFields, {"NRODOC",    "C", 13, 0})
AAdd(aFields, {"FECHA",     "D",  8, 0})
AAdd(aFields, {"FECVTO",    "D",  8, 0})
AAdd(aFields, {"CREDITO",   "N", 15, 2})
AAdd(aFields, {"DEBITO",    "N", 15, 2})
AAdd(aFields, {"SALDO",     "N", 15, 2})
AAdd(aFields, {"TIPSAL",    "C",  1, 2})
AAdd(aFields, {"TELEFONOS", "C", 40, 0})
AAdd(aFields, {"CONTACTO",  "C", 40, 0})
AAdd(aFields, {"MONEDA",    "C",  6, 0})
AAdd(aFields, {"CANCEL",    "C",  1, 0})
AAdd(aFields, {"FCDEPOS",   "D",  8, 0})
AAdd(aFields, {"MCDTREV",   "D",  8, 0})

cDbfTmp := CriaTrab(aFields, .T.) + GetDBExtension()
cNtxTmp := CriaTrab(nil , .F.) + OrdBagExt()

If !Empty(Select("TRB"))
	DbSelectArea("TRB")
	DbCloseArea()
Endif
FErase(cNtxTmp)

DbUseArea(.T., __cRDDNTTS, cDbfTmp, "TRB", .F., .F.)
DbCreateIndex(cNtxTmp, "CODCLI+TIPODOC+SERIE+NRODOC", { || CODCLI+TIPODOC+SERIE+NRODOC }, .F.)

DbSelectArea("SA1")
DbSetOrder(1)

//------------------------------------------------------------------------------------
//   RECORRE LOS TITULOS DEL CLIENTE
//
//------------------------------------------------------------------------------------


DbSelectArea("SE1")
DbSetOrder(2)

If mv_par08 == 2
	oSection1:SetPageBreak()
Endif

If !Empty(mv_par01)
	DbSeek(xFilial("SE1") + mv_par01, .T.)
Else
	DbSeek(xFilial("SE1"))
Endif


Do While !eof() .AND. E1_FILIAL == xFilial() .AND. E1_CLIENTE <= mv_par02

	DbSelectArea("SA1")
	DbSeek(xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA)
		
	If nOrdem == 2
		If ALLTRIM(SA1->A1_GRPVEN)<>ALLTRIM(mv_par15) .OR. SE1->E1_CLIENTE<>SA1->A1_COD .OR. SA1->A1_LOJA<>SE1->E1_LOJA
			DbSelectArea("SE1")
			DbSkip()
			Loop
		Endif
	EndIf
	
	If !Empty(cFiltro) .And. !(&(cFiltro))
		DbSelectArea("SE1")
		DbSkip()
		Loop
	Endif

	// Imprime otras monedas?
	If mv_par14 == 2 .and. SE1->E1_MOEDA <> mv_par13
		DbSelectArea("SE1")
		DbSkip()
		Loop
	Endif

	//Filtra diferencias de cambio
	IF SE1->E1_MOEDA <> mv_par13 .and.  ( SE1->E1_TIPO=="DCC" .or. SE1->E1_TIPO=="DDC")
		DbSelectArea("SE1")
		DbSkip()
		Loop
	ENDIF

	//Filtra recibos anticipados
	IF SE1->E1_TIPO=="RA "
		DbSelectArea("SE1")
		DbSkip()
		Loop
	ENDIF

	//Filtra diferencias de cambio cuando es a tasa del dia
	IF mv_par12 == 1 .and.  ( SE1->E1_TIPO=="DCC" .or. SE1->E1_TIPO=="DDC")
		DbSelectArea("SE1")
		DbSkip()
		Loop
	ENDIF


	DbSelectArea("SE1")
	If !(left(AllTrim(E1_TIPO), 2) $ "TF-CH") .and. E1_EMISSAO <= dDataBase
		cCodCli  := SA1->A1_COD
		cCliente := SA1->A1_NOME
		cTelef   := SA1->A1_TEL
		cContact := SA1->A1_CONTATO

		If	(mv_par10 < 2 .AND. E1_EMISSAO < min(mv_par03, dDatabase)) .OR.;
			(mv_par10 > 1 .AND. E1_VENCREA < mv_par03)

			DbSelectArea("TRB")
			If !DbSeek(SE1->E1_CLIENTE + "SA")
				TRB->( DbAppend() )
				TRB->CODCLI    := cCodCli
				TRB->LOJA      := SA1->A1_LOJA
				TRB->CLIENTE   := cCliente
				TRB->TELEFONOS := cTelef
				TRB->CONTACTO  := cContact
				TRB->TIPODOC   := "SA"
				TRB->FECHA     := mv_par03 - 1
			Endif

			DbSelectArea("SE1")
			If AllTrim(E1_TIPO) $ MV_CRNEG + "|" + MVRECANT .or. SubStr(E1_TIPO, 3, 1) == "-"
				TRB->CREDITO += xMcMoeda(1)
				TRB->SALDO   -= xMcMoeda(2)
			ElseIf (AllTrim(E1_TIPO) <> AllTrim(SuperGetMv("MV_SIMB1") ))
				TRB->DEBITO  += xMcMoeda(1)
				TRB->SALDO   += xMcMoeda(2)
			Endif
			LeBaixaMfatur(SE1->(E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO + E1_CLIENTE + E1_LOJA))
			DbSelectArea("SE1")

		ElseIf (AllTrim(E1_TIPO) <> AllTrim(SuperGetMv("MV_SIMB1") ))
			IF	(mv_par10 < 2 .AND. E1_EMISSAO <= mv_par04) .OR.;
				(mv_par10 > 1 .AND. E1_VENCREA <= mv_par04)

				TRB->( DbAppend() )
				TRB->CODCLI    := cCodCli
				TRB->LOJA      := SA1->A1_LOJA
				TRB->CLIENTE   := cCliente
				TRB->TELEFONOS := cTelef
				TRB->CONTACTO  := cContact

				DbSelectArea("SE1")
				cTipo  := SE1->E1_TIPO
				nPosTp := AScan(aTipDoc, {|a| a[1] == E1_TIPO})
				cTipo  := IIf(nPosTp > 0, aTipDoc[nPosTp][2], cTipo)
				TRB->SERIE   := AllTrim(E1_PREFIXO)
				TRB->NRODOC  := E1_NUM
				TRB->FECHA   := E1_EMISSAO
				TRB->FECVTO  := FecDisp("SE1")  // E1_VENCREA
				TRB->FCDEPOS := IIf(TRB->FECVTO > mv_par04 .and. cTipo  $ "CH ", TRB->FECVTO, ctod(""))
				TRB->TIPODOC := cTipo
				TRB->MONEDA  := "  " + AllTrim(SuperGetMv("MV_SIMB" + AllTrim(STR(E1_MOEDA))))
				If AllTrim(E1_TIPO) $ MV_CRNEG + "|" + MVRECANT .or. SubStr(E1_TIPO, 3, 1) == "-"
					TRB->TIPSAL  := "A"
					TRB->CREDITO := +xMcMoeda(1)
					TRB->SALDO   := -xMcMoeda(2)
				Else
					TRB->TIPSAL  := "D"
					TRB->DEBITO  := +xMcMoeda(1)
					TRB->SALDO   := +xMcMoeda(2)
				Endif
				LeBaixaMfatur(SE1->(E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO + E1_CLIENTE + E1_LOJA))
				DbSelectArea("SE1")
			Endif
		Endif
	Endif
	DbSkip()
EndDo

//------------------------------------------------------------------------------------
//   RECORRE LOS RECIBOS DE COBRO DEL CLIENTE
//   RECIBOS ACTIVOS
//
//------------------------------------------------------------------------------------

DbSelectArea("SEL")
DbSetOrder(3)
If !Empty(mv_par01)
	DbSeek(xFilial("SEL") +  mv_par01, .T.)
Else
	DbSeek(xFilial("SEL"))
Endif

Do While !eof() .AND. EL_FILIAL == xFilial("SEL") .AND. EL_CLIORIG <= mv_par02//Do While !eof() .AND. EL_FILIAL == xFilial("SEL") .AND. EL_CLIENTE <= mv_par02

	DbSelectArea("SA1")
	DbSeek(xFilial("SA1") + SEL->EL_CLIORIG + SEL->EL_LOJORIG)//	DbSeek(xFilial("SA1") + SEL->EL_CLIENTE + SEL->EL_LOJA)
	
	If nOrdem == 2
		If ALLTRIM(SA1->A1_GRPVEN)<>ALLTRIM(mv_par15) .OR. SEL->EL_CLIORIG<>SA1->A1_COD .OR. SA1->A1_LOJA<>SEL->EL_LOJORIG//		If ALLTRIM(SA1->A1_GRPVEN)<>ALLTRIM(mv_par15) .OR. SEL->EL_CLIENTE<>SA1->A1_COD .OR. SA1->A1_LOJA<>SEL->EL_LOJA
			DbSelectArea("SEL")
			DbSkip()
			Loop
		Endif
	EndIf
	
	If !Empty(cFiltro) .And. !(&(cFiltro))
		DbSelectArea("SEL")
		DbSkip()
		Loop
	Endif


	// Imprime otras monedas?
	If mv_par14 == 2 .and. val(SEL->EL_MOEDA) <> mv_par13
		DbSelectArea("SEL")
		DbSkip()
		Loop
	Endif

	DbSelectArea("SEL")
	If EL_DTDIGIT > dDataBase .or. (EL_DTDIGIT < mv_par03 .and. EL_CANCEL) .or. (EL_DTDIGIT > mv_par04)
		DbSkip()
		Loop
	Endif


	cCodCli  := SA1->A1_COD
	cCliente := SA1->A1_NOME
	lSalAnt  := EL_DTDIGIT < mv_par03
	lCancel  := EL_CANCEL
	If lSalAnt
		DbSelectArea("TRB")
		If !DbSeek(SEL->EL_CLIORIG + "SA", .F.)//		If !DbSeek(SEL->EL_CLIENTE + "SA", .F.)
			TRB->(DbAppend())
			TRB->CODCLI    := cCodCli
			TRB->LOJA      := SA1->A1_LOJA
			TRB->CLIENTE   := cCliente
			TRB->TIPODOC   := "SA"
			TRB->FECHA     := mv_par03 - 1
			TRB->TELEFONOS := SA1->A1_TEL
			TRB->CONTACTO  := SA1->A1_ENDREC
		Endif
	ElseIf EL_DTDIGIT <= mv_par04
		DbSelectArea("TRB")
		TRB->(DbAppend())
		TRB->CODCLI    := cCodCli
		TRB->LOJA      := SA1->A1_LOJA
		TRB->CLIENTE   := cCliente
		TRB->SERIE     := SEL->EL_SERIE
		TRB->NRODOC    := IIf(!Empty(Val(SEL->EL_RECIBO)), StrZero(Val(SEL->EL_RECIBO), 12), SEL->EL_RECIBO)
		TRB->FECHA     := SEL->EL_DTDIGIT
		TRB->FECVTO    := FecDisp("SEL")  // SEL->EL_DTDIGIT
		TRB->FCDEPOS   := IIf(TRB->FECVTO > mv_par04 , TRB->FECVTO, ctod(""))
		TRB->TIPODOC   := IIf(lCancel, "RA", "RC")
		TRB->TIPSAL    := "A"
		TRB->TELEFONOS := SA1->A1_TEL
		TRB->CONTACTO  := SA1->A1_ENDREC
		TRB->MONEDA    := "  " + AllTrim(SuperGetMv("MV_SIMB" + AllTrim(STR(VAL(SEL->EL_MOEDA)))))
	
	Endif

	DbSelectArea("SEL")
	//---------------------------------
    //revisa si es de compensacion
   	cQuery := " SELECT * "
   	cQuery += " FROM "+RetSqlName("SEL")
   	cQuery += " WHERE EL_TIPODOC <> 'TB' AND EL_RECIBO='"+EL_RECIBO+"' "
   	cQuery += " AND EL_SERIE = '"+EL_SERIE+"'  "

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SELNEW', .F., .T.)
	DbSelectArea("SELNEW")
	IF SELNEW->(Eof())
	   lRecCmp:=.T.
	ELSE
	   lRecCmp:=.F.
	ENDIF
	SELNEW->(DbCloseArea())

	//---------------------------------

	DbSelectArea("SEL")
	cRecibo := xFilial("SEL") + EL_RECIBO + EL_SERIE
	Do While !eof() .AND. EL_FILIAL + EL_RECIBO + EL_SERIE == cRecibo

		// Imprime otras monedas?
		If mv_par14 == 2 .and. val(SEL->EL_MOEDA) <> mv_par13
			DbSelectArea("SEL")
			DbSkip()
			Loop
		Endif
		IF  Alltrim(SEL->EL_TIPO)=="CH" .and. (EL_DTDIGIT >= mv_par03 .and. EL_DTDIGIT <= mv_par04)
		    TRB->FECVTO    := FecDisp("SEL")  // SEL->EL_DTDIGIT
			TRB->FCDEPOS   := IIf(TRB->FECVTO > mv_par04 , TRB->FECVTO, ctod(""))
		ENDIF

		IF !lRecCmp .and. MV_PAR12==1//Recibo normal
			If (AllTrim(EL_TIPODOC) $ "TB/RA") //.or. (EL_DTDIGIT < mv_par03 .and. EL_CANCEL) .or. (EL_TIPODOC == "RA" .and. !EL_CANCEL) .or. (EL_DTDIGIT > mv_par04)
				DbSelectArea("SEL")
				DbSkip()
				Loop
			Endif
			//Obtiene valores
			If AllTrim(EL_TIPO) $ (MV_CRNEG + "|" + MVRECANT) .and. !(AllTrim(EL_TIPO) $ "TF;CH;EF")
				TRB->CREDITO -= xMcMoeda(4)
			Else
				TRB->CREDITO += xMcMoeda(4)
			Endif

		ElseIF  MV_PAR12==2//Recibo normal tasa movimiento

			If (AllTrim(EL_TIPODOC) $ "TB/RA") .or. (EL_DTDIGIT < mv_par03 .and. EL_CANCEL) .or. (EL_TIPODOC == "RA" .and. !EL_CANCEL) .or. (EL_DTDIGIT > mv_par04)
				DbSelectArea("SEL")
				DbSkip()
				Loop
			Endif
			//Obtiene valores
			If AllTrim(EL_TIPO) $ (MV_CRNEG + "|" + MVRECANT) .and. AllTrim(EL_TIPODOC) == "TB"
				TRB->CREDITO -= xMcMoeda(4)
			Else
				TRB->CREDITO += xMcMoeda(4)
			Endif

		ElseIf lRecCmp  .and. MV_PAR12==1//Recibo compensacion

			If !(EL_TIPODOC == "TB")
				DbSelectArea("SEL")
				DbSkip()
				Loop
			Endif
			//Obtiene valores
			If AllTrim(EL_TIPO) $ (MV_CRNEG + "|" + MVRECANT) .and. !(AllTrim(EL_TIPO) $ "TF;CH;EF")
				TRB->CREDITO -= xMcMoeda(4)
			Else
				TRB->CREDITO += xMcMoeda(4)
			Endif
		ENDIF

		If EL_TIPODOC == "RA" .and. !lCancel
			nOrdSE1  := SE1->(IndexOrd())
			nRecSE1  := SE1->(Recno())
			SE1->(DbSetOrder(2))
			If SE1->(DbSeek(xFilial("SE1") + SEL->(EL_CLIORIG + EL_LOJORIG + EL_PREFIXO + EL_NUMERO + EL_PARCELA + EL_TIPO)))//			If SE1->(DbSeek(xFilial("SE1") + SEL->(EL_CLIENTE + EL_LOJA + EL_PREFIXO + EL_NUMERO + EL_PARCELA + EL_TIPO)))
				TRB->SALDO -= xMcMoeda(1)
			Endif
			SE1->(DbSetOrder(nOrdSE1))
			SE1->(DbGoTo(nRecSE1))
		Endif
		DbSkip()
	EndDo

    //---------------------------------------------------
	//Control por saldo anterior
    //---------------------------------------------------
	If lSalAnt

		If TRB->CREDITO > TRB->DEBITO
			TRB->TIPSAL := "A"
		Else
			TRB->TIPSAL := "D"
		Endif

    //---------------------------------------------------
	//Recibo anulado, copia registro
    //---------------------------------------------------
	ElseIf lCancel
	    //Fecha anulacion en blanco o fecha anulacion menor a parametros
	    IF Empty(TRB->MCDTREV) .or. ( TRB->MCDTREV <= MV_PAR04)
			// Guarda el registro actual.
			aRegs := {}
			For nX := 1 to TRB->(FCount())
				aAdd(aRegs, TRB->(FieldGet(nX)))
			Next

			// Crea una copia del registro, con DEBITO y CREDITO inversos.
			TRB->(DbAppend())
			For nX := 1 to len(aRegs)
				cCampo := AllTrim(TRB->(Field(nX)))
				If cCampo == "DEBITO"
					TRB->CREDITO := aRegs[nX]
				ElseIf cCampo == "CREDITO"
					TRB->DEBITO := aRegs[nX]
				Else
					TRB->(FieldPut(nX, aRegs[nX]))
				Endif
			Next
			TRB->CANCEL := "X"
			//Informa fecha de reversion como fecha de anulacion
			IF !Empty(TRB->MCDTREV)
			   TRB->FECHA   := TRB->MCDTREV
		    ENDIF
		ENDIF
	Endif
    //---------------------------------------------------
EndDo

DbSelectArea("TRB")
DbClearIndex()
FErase(cNtxTmp)

If mv_par07 < 2
	If mv_par10 == 1
		DbCreateIndex( cNtxTmp, "CODCLI+DTOS(FECHA)+DTOS(FCDEPOS)+TIPODOC+SERIE+NRODOC", ;
		{|| CODCLI+DTOS(FCDEPOS)+DTOS(FECHA)+TIPODOC+SERIE+NRODOC }, .F.)
	ElseIf mv_par10 == 2
		DbCreateIndex( cNtxTmp, "CODCLI+DTOS(FCDEPOS)+DTOS(FECVTO)+TIPODOC+SERIE+NRODOC", ;
		{|| CODCLI+DTOS(FCDEPOS)+DTOS(FECVTO)+TIPODOC+SERIE+NRODOC }, .F.)
	Else
		DbCreateIndex( cNtxTmp, "CODCLI+DTOS(FCDEPOS)+DTOS(FECHA)+TIPODOC+SERIE+NRODOC", ;
		{|| CODCLI+DTOS(FCDEPOS)+DTOS(FECHA)+TIPODOC+SERIE+NRODOC }, .F.)
	Endif
Else
	If mv_par10 == 1
		DbCreateIndex( cNtxTmp, "CLIENTE+DTOS(FECHA)+DTOS(FCDEPOS)+TIPODOC+SERIE+NRODOC", ;
		{|| CLIENTE+DTOS(FCDEPOS)+DTOS(FECHA)+TIPODOC+SERIE+NRODOC }, .F.)
	ElseIf mv_par10 == 2
		DbCreateIndex( cNtxTmp, "CLIENTE+DTOS(FCDEPOS)+DTOS(FECHA)+TIPODOC+SERIE+NRODOC", ;
		{|| CLIENTE+DTOS(FCDEPOS)+DTOS(FECHA)+TIPODOC+SERIE+NRODOC }, .F.)
	Else
		DbCreateIndex( cNtxTmp, "CLIENTE+DTOS(FCDEPOS)+DTOS(FECVTO)+TIPODOC+SERIE+NRODOC", ;
		{|| CLIENTE+DTOS(FCDEPOS)+DTOS(FECVTO)+TIPODOC+SERIE+NRODOC }, .F.)
	Endif
Endif



DbSelectArea("TRB")
DbGoTop()

oReport:SetMeter(TRB->(RecCount()) + 1)
If MV_PAR05==2
	oSection2:Cell("E1_TIPO"   ):Disable()
	oSection2:Cell("E1_EMISSAO"):Disable()
	oSection2:Cell("E1_VENCREA"):Disable()
	oSection2:Cell("E1_EMISSAO"):Disable()
	oSection2:Cell("E1_NUM"):SetTitle(" ")
Endif
oSection1:SetHeaderPage(.T.)
oSection2:SetHeaderPage(.T.)

Do While !eof()
	cCodCli  := CODCLI
	cCliente := AllTrim( CLIENTE   )
	cTelef   := AllTrim( TELEFONOS )
	cContact := AllTrim( CONTACTO  )
	lFuturo  := .F.
	
	oSection2:Init()

	Do While !eof() .AND. CODCLI ==  cCodCli

		// Verifica si son titulos de emision futura.
		If !lFuturo .and. !empty(TRB->FCDEPOS)
			lFuturo := .T.
			cDisp   := cTelef + " - " + cContact
			If mv_par05 < 2
				oReport:ThinLine()
				oReport:SkipLine()
				oReport:PrintText(STR0010 + cCodCli + " (" + Left(cDisp, 40) + ")" )
			Else
				oReport:PrintText(cCodCli  +  "  " + cCliente + " (" +  Left(cDisp, 40) + ")")
			Endif
			oSection2:Cell("E1_TIPO"   ):Hide()
			oSection2:Cell("E1_NUM"    ):Hide()
			oSection2:Cell("E1_EMISSAO"):Hide()
			oSection2:Cell("E1_VENCREA"):Hide()
			oSection2:Cell("E1_EMISSAO"):Hide()
			oSection2:Cell("DEBITO" ):SetBlock({|| nDebCLi })
			oSection2:Cell("CREDITO"):SetBlock({|| nCredCli})
			oSection2:Cell("SALDO"  ):SetBlock({|| nSalAC  })
			oSection2:PrintLine()
			oSection2:Cell("E1_TIPO"   ):Show()
			oSection2:Cell("E1_NUM"    ):Show()
			oSection2:Cell("E1_EMISSAO"):Show()
			oSection2:Cell("E1_VENCREA"):Show()
			oSection2:Cell("E1_EMISSAO"):Show()

			oReport:ThinLine()
			oReport:SkipLine()
			oReport:PrintText(upper("Valores a depositar"))
		Endif

		// Resumido, com saldo inicial ou diferente de saldo anterior.
		If MV_PAR05 <> 2 .or. MV_PAR11 <> 1 .or. TIPODOC <> "SA"
			nCredCli += TRB->CREDITO
			nDebCli  += TRB->DEBITO
		Endif

		nTotCred += TRB->CREDITO
		nTotDeb  += TRB->DEBITO
		nSalAC   += TRB->(DEBITO - CREDITO)
		nTotMO   += TRB->SALDO

		If mv_par05 == 1 // .AND. !Empty( VALOR )
			DbSelectArea("TRB")
			If TIPODOC == "SA"
				oSection2:Cell("E1_NUM"    ):SetBlock({|| STR0012 })
				oSection2:Cell("E1_EMISSAO"):SetBlock({|| TRB->FECHA })
			Else
				oSection2:Cell("E1_TIPO"   ):SetBlock({|| IIf(TRB->CANCEL == "X", "AN ", "") + TRB->TIPODOC })
				oSection2:Cell("E1_NUM"    ):SetBlock({|| Transform(TRB->NRODOC, IIf(TRB->TIPODOC == 'RC', PesqPict('SEL','EL_RECIBO'), PesqPict('SE1','E1_NUM')))})
				oSection2:Cell("E1_EMISSAO"):SetBlock({|| TRB->FECHA })
				oSection2:Cell("E1_VENCREA"):SetBlock({|| TRB->FECVTO })
			Endif
			oSection2:Cell("DEBITO" ):SetBlock({|| TRB->DEBITO})
			oSection2:Cell("CREDITO"):SetBlock({|| TRB->CREDITO})
			oSection2:Cell("SALDO"  ):SetBlock({|| nSalAC})
			oSection2:Cell("MONEDA" ):SetBlock({|| TRB->MONEDA})
						
			// Imprime linea.
				oSection2:PrintLine()
		Endif

		DbSkip()
		oReport:IncMeter()
	EndDo

	If (mv_par06 < 2 .OR. cCodCli <> CodCli) .AND. mv_par09 == 1
		cDisp := cTelef + " - " + cContact
		If mv_par05 < 2
			oReport:ThinLine()
			oReport:SkipLine()
			oReport:PrintText(STR0010 + cCodCli + " (" + Left( cDisp, 40 ) + ")" )
		Else
			oReport:PrintText(cCodCli  +  "  " + cCliente + " (" +  Left( cDisp, 40 ) + ")")
		Endif
		oSection2:Cell("E1_TIPO"   ):Hide()
		oSection2:Cell("E1_NUM"    ):Hide()
		oSection2:Cell("E1_EMISSAO"):Hide()
		oSection2:Cell("E1_VENCREA"):Hide()
		oSection2:Cell("E1_EMISSAO"):Hide()
		oSection2:Cell("DEBITO" ):SetBlock({|| nDebCLi })
		oSection2:Cell("CREDITO"):SetBlock({|| nCredCli})
		oSection2:Cell("SALDO"  ):SetBlock({|| nSalAC  })
		oSection2:Cell("A1_COD"   ):Hide()
		oSection2:Cell("A1_NOME"  ):Hide()
		oSection2:PrintLine()
		oSection2:Cell("E1_TIPO"   ):Show()
		oSection2:Cell("E1_NUM"    ):Show()
		oSection2:Cell("E1_EMISSAO"):Show()
		oSection2:Cell("E1_VENCREA"):Show()
		oSection2:Cell("E1_EMISSAO"):Show()
		oSection2:Cell("A1_COD"   ):Show()
		oSection2:Cell("A1_NOME"  ):Show()
		If mv_par05 < 2
			oReport:ThinLine()
			oReport:SkipLine()
		Endif
		nDebCli  := 0
		nCredCli := 0
		nSalAC   := 0
	Endif
	oSection2 :Finish()
EndDo

If mv_par09 == 1
	oReport:PrintText(STR0011)
	oSection2:Init()
	oSection2:Cell("E1_TIPO"   ):Hide()
	oSection2:Cell("E1_EMISSAO"):Hide()
	oSection2:Cell("E1_VENCREA"):Hide()
	oSection2:Cell("E1_EMISSAO"):Hide()
	oSection2:Cell("E1_NUM"    ):Hide()
	oSection2:Cell("DEBITO" ):SetBlock({|| nTotDeb})
	oSection2:Cell("CREDITO"):SetBlock({|| nTotCred})
	oSection2:Cell("SALDO"  ):SetBlock({|| nTotDeb - nTotCred})
	oSection2:Cell("A1_COD"   ):Hide()
	oSection2:Cell("A1_NOME"  ):Hide()
	
	oSection2:PrintLine()
	oReport:SkipLine()
	oReport:FatLine()
Endif
TRB->(DbCloseArea())
FErase(cDbfTmp)
FErase(cNtxTmp)
Return nil



// Grava, no arquivo de trabalho, as baixas manuais que houverem do titulo corrente.
Static Function LeBaixaMFatur(cChave)
Local nMoeda := mv_par13
Local cSeq, lEstornado := .F.
Local cSE5Key := "E5_FILIAL + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_CLIFOR + E5_LOJA"

SE5->(dbSetOrder(7))  // E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, E5_SEQ.
SE5->(dbSeek(xFilial("SE5") + cChave, .F.))
Do While SE5->(!eof() .and. xFilial("SE5") + cChave == &cSE5Key)
	If SE5->(E5_SITUACA <> "C" .and. E5_TIPODOC <> "ES")
		// If SE5->E5_TIPODOC $ "VL|CP" .Or. (SE5->E5_TIPODOC == "BA" .And. SE5->E5_MOTBX == 'CEC')  // Baixa manual e baixa por compensacao entre carteiras.
		If SE5->E5_TIPODOC $ "VL" .or. (SE5->E5_TIPODOC == "BA" .and. SE5->E5_MOTBX == 'CEC')  // Baixa manual entre carteiras.

			cSeq := SE5->E5_SEQ
			SE5->(DbSkip())
			lEstornado := SE5->(xFilial("SE5") + cChave + cSeq == &cSE5Key + E5_SEQ .and. E5_TIPODOC == "ES")
			SE5->(DbSkip(-1))

			If !lEstornado  // Faz somente se nao houver estorno da baixa.
				TRB->(DbAppend())
				TRB->CODCLI    := cCodCli
				TRB->CLIENTE   := cCliente
				TRB->TELEFONOS := cTelef
				TRB->CONTACTO  := cContact
				TRB->CREDITO   := Round(xMcMoeda(3), nDecs)
				TRB->TIPSAL    := "A"
				TRB->SALDO     -= TRB->CREDITO
				TRB->NRODOC    := SE5->E5_NUMERO
				TRB->TIPODOC   := SE5->E5_TIPODOC
				TRB->SERIE     := SE5->E5_PREFIXO
				TRB->FECHA     := SE5->E5_DATA
			Endif
		ElseIf SE5->E5_TIPODOC $ "JR/MT/IS" // "JR/MT/DC/IS" // Juros, Multa, Desconto, Imp. Subst. (Chile).
			TRB->( DbAppend() )
			TRB->CODCLI    := cCodCli
			TRB->CLIENTE   := cCliente
			TRB->TELEFONOS := cTelef
			TRB->CONTACTO  := cContact
			If SE5->E5_TIPODOC = "DC"
				TRB->TIPSAL  := "A"
				TRB->CREDITO := Round(xMcMoeda(3), nDecs)
				TRB->SALDO   := -TRB->CREDITO
			Else
				TRB->TIPSAL  := "D"
				TRB->DEBITO  := Round(xMcMoeda(3), nDecs)
				TRB->SALDO   := TRB->DEBITO
			Endif
			TRB->NRODOC  := SE5->E5_NUMERO
			TRB->TIPODOC := SE5->E5_TIPODOC
			TRB->SERIE   := SE5->E5_PREFIXO
			TRB->FECHA   := SE5->E5_DATA
		Endif
	Endif

	SE5->(DbSkip())
EndDo
Return nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � xMcMoeda �Autor  � Felipe Raposo      � Data �  16/09/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Convierte el valor del titulo en la moneda solicitada.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � McCain.                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xMcMoeda(nOpcP,nOpcT)

Local nValor  := 0
Local nMoedaO := 0
Local nMoedaD := MV_PAR13  // MV_PAR13 => Moneda => 1-Peso / 2-Dolar...
Local dData   := dDataBase
Local nTasaO  := 0  // Tasa de conversion moneda origen.
Local nTasaD  := 0  // Tasa de conversion moneda destino.
Local nDecs   := MsDecimais(1)
Local cMoedaD := ""

DEFAULT nOpcT := 1    // devuelve valor 

If nOpcP < 4
	// Verifica que es lo que hay que convertir.
	If nOpcP == 1
		nValor := SE1->E1_VALOR
	ElseIf nOpcP == 2
		nValor := SE1->E1_SALDO
	ElseIf nOpcP == 3
		nValor := SE5->E5_VALOR
	Endif
	nMoedaO := SE1->E1_MOEDA

	// Convierte utilizando las tasas especificas .
	// MV_PAR12 => 1-Tasa del Dia / 2-Tasa del movimiento.
	// nMoedaD  => 1-Peso / 2-Dolar.
	If MV_PAR12 == 2
		dData  := SE1->E1_EMIS1
		nTasaO := SE1->E1_TXMOEDA
		nTasaD := IIf(nMoedaD == 2, SE1->E1_TXMOEDA, 0)
	Endif
Else
	nValor  := SEL->EL_VALOR
	nMoedaO := Val(SEL->EL_MOEDA)
    cMoedaD:=STRZERO(nMoedaD,2)
	If MV_PAR12 == 2
		dData  := SEL->EL_DTDIGIT
		nTasaO := SEL->(IIf(VAL(EL_MOEDA) >= 2 .and. VAL(EL_MOEDA) <= 5, &("EL_TXMOE" + STRZERO(VAL(EL_MOEDA),2)), 0))
	    nTasaD := SEL->(IIf(nMoedaD >= 2 , &("EL_TXMOE" + cMoedaD) ,0) )
	    IF nTasaD == NIL .or. nTasaD == 0
		   nTasaD := Recmoeda(dData,nMoedaD)
	    ENDIF
	Endif
Endif

// Convierte.
nValor := Round(xMoeda(nValor, nMoedaO, nMoedaD, dData, 5, nTasaO, nTasaD), nDecs)

Return IIF(nOpcT==1,nValor,nTasaD)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � EsCheque �Autor  � Felipe Raposo      � Data �  11/11/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica si el recibo es referente a un cheque.            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � McCain.                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FecDisp(cTipo)

// Declaracion de variables.
Local dRet    := dDataBase
Local cRecibo := ""
Local aArea   := GetArea()
Local aAreaE5 := SE5->(GetArea())

If cTipo == "SE1"
	dRet    := SE1->E1_VENCREA
	cRecibo := SE1->(E1_RECIBO + E1_SERREC)
ElseIf cTipo == "SEL"
	dRet    := SEL->EL_DTDIGIT
	cRecibo := SEL->(EL_RECIBO + EL_SERIE)
	//issue 1453
	IF Alltrim(SEL->EL_TIPO)=="CH"
		dRet := SEL->EL_DTVCTO
	ENDIF
Endif

/*/
SE5->(dbSetOrder(8))  // E5_FILIAL, E5_ORDREC, E5_SERREC.
If !empty(cRecibo) .and. SE5->(dbSeek(xFilial("SE5") + cRecibo, .F.) .and. ALLTRIM(E5_TIPO) == "CH")
	dRet := SE5->E5_DTDISPO
Endif
/*/


RestArea(aAreaE5)
RestArea(aArea)

Return dRet                                              


User FuncTion McVerMoeda()
Local _lRet := .F.
Local aPar := {}
Local aRet := {}
Local _aCombo := {}
Local cPar1 := MV_PAR01
Local _cVar := ReadVar()
Local nM := 0  // Para tratar o nome da moeda a partir da moeda 1

For nInc:=1 to 5
	nM ++
	cNomeMoeda := If(nInc < 10,GetMv("MV_MOEDA"+Str(nM,1)),GetMv("MV_MOEDA"+Str(nM,2)) )
	aadd(_aCombo, cNomeMoeda )
Next
_cCadastro := "�Moneda en la cual emitir el informe?"

aadd(aPar, {2,"�Infome la Moneda?",1,_aCombo,50,"",.F. } )

//_lRet := Parambox(aPar,_cCadastro,aRet)
IF Parambox(aPar,_cCadastro,aRet)
	
	_nPos :=Ascan(_aCombo,aRet[1])
	&_cVar := If(_nPos == 0, 1, _nPos)
	_lRet:=.T.
	
ENDIF

MV_PAR01 := cPar1

Return(_lRet)               


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AjustaX1 � Autor � Felipe Raposo      � Data �  13/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Ajusta a tabela de perguntas (SX1) de acordo com os para-  ���
���          � metros passados.                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametro � cPerg     - grupo das perguntas passadas.                  ���
���          � aAjustaX1 - matriz com as perguntas de acordo com o layout ���
���          �             abaixo:                                        ���
���          �    1 - Ordem da pergunta (obrigatorio)                     ���
���          �    2 - Descricao da pergunta (obrigatorio)                 ���
���          �    3 - Objeto  =>   C=Combo / G=Get (obrigatorio)          ���
���          �    4 - Array com opcoes do parametro (obrigatorio)         ���
���          �      No caso de Get (texto):                               ���
���          �        4.1 - Tipo  =>  C=Caracter / N=Numerico / D=Data    ���
���          �        4.2 - Tamanho (obrigatorio, exceto em campo data)   ���
���          �        4.3 - Decimal (opcional)                            ���
���          �        4.4 - Consulta padrao F3 (opcional)                 ���
���          �      No caso de Combo:                                     ���
���          �        4.1 - Selecao padrao (opcional)                     ���
���          �        4.2 - Opcao 1 em portugues (obrigatorio)            ���
���          �        4.3 - Opcao 2 em portugues (obrigatorio)            ���
���          �        4.4 - Opcao 3 em portugues (opcional)               ���
���          �        4.5 - Opcao 4 em portugues (opcional)               ���
���          �        4.6 - Opcao 5 em portugues (opcional)               ���
���          �    5 - Help do parametro em portugues (opcional)           ���
���          �    6 - Help do parametro em ingles (opcional)              ���
���          �    7 - Help do parametro em espanhol (opcional)            ���
���          �        Esses tres parametros de help deverao ser matrizes  ���
���          �        contendo as linhas do help.                         ���
���          �        Ex: {"linha 1", "linha 2", "linha 3"}               ���
���          � lRefaz - sobrescreve as perguntas existentes (.T./.F.)?    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � Nenhum.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustaX1(cPerg, aAjustaX1, lRefaz)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local nAux1, lAchou
Local cKey, aHelpPor, aHelpEng, aHelpSpa

// Acerta os valores padroes dos parametros.
cPerg := PadR(cPerg, len(SX1->X1_GRUPO), " ")  // Completa espacos caso cPerg tenha menos que 6 caracteres.
Default lRefaz := .F.

// Acerta a tabela SX1.
SX1->(dbSetOrder(1))  // X1_GRUPO+X1_ORDEM.
For nAux1 := 1 to len(aAjustaX1)
	If !(lAchou := SX1->(dbSeek(cPerg + aAjustaX1[nAux1, 1], .F.))) .or. lRefaz
		RecLock("SX1", !lAchou)  // Abre registro para edicao ou cria novo registro.
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := aAjustaX1[nAux1, 1]
		SX1->X1_PERSPA  := aAjustaX1[nAux1, 2]
		SX1->X1_GSC     := aAjustaX1[nAux1, 3]
		If aAjustaX1[nAux1, 3] == "G"  // Get (texto).
			SX1->X1_TIPO    := aAjustaX1[nAux1, 4, 1]
			SX1->X1_TAMANHO := IIf(aAjustaX1[nAux1, 4, 1] == "D", 8, aAjustaX1[nAux1, 4, 2])
			SX1->X1_DECIMAL := IIf(len(aAjustaX1[nAux1, 4]) >= 3 .and. aAjustaX1[nAux1, 4, 1] == "N", aAjustaX1[nAux1, 4, 3], 0)
			SX1->X1_F3      := IIf(len(aAjustaX1[nAux1, 4]) >= 4, aAjustaX1[nAux1, 4, 4], "")
			SX1->X1_CNT01   := ""  // Cria com conteudo em branco.
		ElseIf aAjustaX1[nAux1, 3] == "C"  // Combo.
			SX1->X1_TIPO    := "N"  // Numerico.
			SX1->X1_TAMANHO := 01
			SX1->X1_DECIMAL := 00
			SX1->X1_PRESEL  := IIf(ValType(aAjustaX1[nAux1, 4, 1]) == "N", aAjustaX1[nAux1, 4, 1], 1)  // Nao obrigatorio.
			SX1->X1_DEFSPA1 := aAjustaX1[nAux1, 4, 2]  // Obrigatorio.
			SX1->X1_DEFSPA2 := aAjustaX1[nAux1, 4, 3]  // Obrigatorio.
			SX1->X1_DEFSPA3 := IIf(len(aAjustaX1[nAux1, 4]) >= 4, aAjustaX1[nAux1, 4, 4], "")  // Nao obrigatorio.
			SX1->X1_DEFSPA4 := IIf(len(aAjustaX1[nAux1, 4]) >= 5, aAjustaX1[nAux1, 4, 5], "")  // Nao obrigatorio.
			SX1->X1_DEFSPA5 := IIf(len(aAjustaX1[nAux1, 4]) >= 6, aAjustaX1[nAux1, 4, 6], "")  // Nao obrigatorio.
		Endif
		
		// Monta o help para o item.
		aHelpPor := IIf(len(aAjustaX1[nAux1]) >= 5, aClone(aAjustaX1[nAux1, 5]), {})
		aHelpEng := IIf(len(aAjustaX1[nAux1]) >= 6, aClone(aAjustaX1[nAux1, 6]), {})
		aHelpSpa := IIf(len(aAjustaX1[nAux1]) >= 7, aClone(aAjustaX1[nAux1, 7]), {})
		If !empty(aHelpPor) .or. !empty(aHelpEng) .or. !empty(aHelpSpa)
			cKey := "P." + AllTrim(cPerg) + AllTrim(aAjustaX1[nAux1, 1]) + "."
			PutSX1Help(cKey, aHelpPor, aHelpEng, aHelpSpa)
		Endif
		
		// Salva as alteracoes na tabela.
		SX1->(msUnLock())
	Endif
Next nAux1
Return
