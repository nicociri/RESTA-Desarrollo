#include "protheus.ch"
#include "CTACTEPAG.ch"
#DEFINE BOTTOMPAGE 60
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CTACTEPAG ³ Autor ³ MS			        ³ Data ³ 01.03.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cuenta corriente de proveedor.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  DATA    ³ BOPS ³                  ALTERACAO                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³09.05.00  ³Melhor³Bruno : Considerar data de digitacao no parametros.  ³±±
±±³07.03.01  ³Melhor³Rubens: Aumento dos campos numericos do arquivo temp.³±±
±±³          ³      ³        e da mascara na impressao dos valores        ³±±
±±³20/04/01  ³Melhor|Rubens: Considera tambem as baixas manuais, juros,   ³±±
±±³          |      |        multas e descontos.                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CTACTEPAG()

Local oReport
Private cMoed1  := Capital( SuperGetMV( 'MV_MOEDA1' ) )
Private cMoed2  := Capital( SuperGetMV( 'MV_MOEDA2' ) )
Private cMoed3  := Capital( SuperGetMV( 'MV_MOEDA3' ) )
Private cMoed4  := Capital( SuperGetMV( 'MV_MOEDA4' ) )
Private cMoed5  := Capital( SuperGetMV( 'MV_MOEDA5' ) )

Private aSimbMon:=MCTMOEDA()

If FindFunction("TRepInUse") .And. TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport	:= ReportDef()
	oReport:PrintDialog()
EndIf

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³Paulo Augusto       º Data ³  21/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tratamanto release 04                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()

Local oReport, oSection1, oSection2
Local cReport := "CTACTEPAG"
Local cTitulo := STR0003  // "Informe de Pagos"
Local cDescri := STR0003
Local cPerg   := "CTACTEPAG "
Local aAjustaX1[0], aHelpSX1[0]

// Hace primero la matriz de help.
// Cada linea de la matriz es el help de un campo diferente y cada
// colunma de la matriz es una linea del help en la pantalla para el usuario.
aAdd(aHelpSX1, {"Digite el código inicial del intervalo de", "códigos de proveedores que se desea", "imprimir (F3 disponible)."})
aAdd(aHelpSX1, {"Digite el código final del intervalo de", "códigos de proveedores que se desea", "imprimir (F3 disponible)."})
aAdd(aHelpSX1, {"Digite la fecha inicial del intervalo de", "fechas."})
aAdd(aHelpSX1, {"Digite la fecha final del intervalo de", "fechas."})
aAdd(aHelpSX1, {"Elija si desea imprimir el informa", "analitico o sintetico."})
aAdd(aHelpSX1, {"Informe cual fecha será considerada."})
aAdd(aHelpSX1, {"Informe la orden a ser considerada."})
aAdd(aHelpSX1, {"Informe si debe imprimir una página", "por proveedor."})
aAdd(aHelpSX1, {"Informe cual formato será considerado."})
aAdd(aHelpSX1, {"Informe si debe considerar los títulos", "sin saldo."})
aAdd(aHelpSX1, {"Informe la tasa de conversión a", "ser considerada."})
aAdd(aHelpSX1, {"Elija la moneda que se desea considerar", "en la generación del informe."})
aAdd(aHelpSX1, {"Informe si debe imprimir registros", "en otras monedas."})

// Hace la matriz de preguntas.
aAdd(aAjustaX1, {"01", "¿De proveedor?",          "G", {"C", 06,, "SA2"},,, aHelpSX1[1]})
aAdd(aAjustaX1, {"02", "¿A proveedor?",           "G", {"C", 06,, "SA2"},,, aHelpSX1[2]})
aAdd(aAjustaX1, {"03", "¿De fecha?",              "G", {"D"},,, aHelpSX1[3]})
aAdd(aAjustaX1, {"04", "¿A fecha?",               "G", {"D"},,, aHelpSX1[4]})
aAdd(aAjustaX1, {"05", "¿Imprime?",               "C", {1, "Analitico", "Sintetico"},,, aHelpSX1[5]})
aAdd(aAjustaX1, {"06", "¿Fecha de referencia?",   "C", {1, "Emision", "Vencimiento", "Registro"},,, aHelpSX1[6]})
aAdd(aAjustaX1, {"07", "¿Ordenado por?",          "C", {1, "Codigo", "R. social"},,, aHelpSX1[7]})
aAdd(aAjustaX1, {"08", "¿Pagina por proveedor?",  "C", {1, "No", "Si"},,, aHelpSX1[8]})
aAdd(aAjustaX1, {"09", "¿Formato?",               "C", {1, "Normal","Archivo"},,, aHelpSX1[9]})
aAdd(aAjustaX1, {"10", "¿Imprime saldo cero?",    "C", {2, "Si", "No"},,, aHelpSX1[10]})
aAdd(aAjustaX1, {"11", "¿Convierte valores por?", "C", {2, "Tasa del dia", "Tasa del mov."},,, aHelpSX1[11]})
aAdd(aAjustaX1, {"12", "¿Que moneda?",            "C", {1, "Pesos", "Dolar", "Euro", "Reales", "Dolar Can"},,, aHelpSX1[12]})
//aAdd(aAjustaX1, {"12", "¿Que moneda?",            "G", {"N", 02,, },,, aHelpSX1[12], {{'X1_VALID', 'U_McVerMoeda() .and. VerifMoeda(mv_par12)'}}})
aAdd(aAjustaX1, {"13", "¿Otras monedas?",         "C", {1, "Convertir", "No imprimir"},,, aHelpSX1[13]})
//aAdd(aAjustaX1, {"13", "¿Otras monedas?",         "C", {1, "Convertir"},,, aHelpSX1[13]})

DbSelectArea("SX1")
IF SX1->(DbSeek(cPerg+"12"))
	IF RecLock("SX1",.F.)
		Replace X1_TAMANHO   With 2
		Replace X1_GSC       With "G"
		Replace X1_TIPO      With "N"
		Replace X1_VALID     With "U_McVerMoeda() .and. VerifMoeda(mv_par12)"
		SX1->(MsUnlock())
	ENDIF
ENDIF
// Atualiza a tabela de perguntas (SX1).
U_AjustaX1(cPerg, aAjustaX1, .F.)
Pergunte(cPerg, .F.) 

oReport  := TReport():New(cReport, cTitulo, cPerg , {|oReport| ReportPrint(oReport, "SE2")}, cDescri)

// Aumenta el tamanho del fuente del reporte completo
oSection1 := TRSection():New( oReport, STR0043, {"SA2"},)//'Fornecedores'
TrPosition():New(oSection1, 'SA2', 1, {|| xFilial('SA2') + TRB->CODPRO + TRB->LOJA})
oSection2 := TRSection():New( oSection1, STR0044,) //'Movimentos'
TRCell():New( oSection2,"E2_TIPO",    "SE2", /*X3Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,)
TRCell():New( oSection2,"E2_PREFIXO", "SE2", "PREFIJO",/*Picture*/,TamSX3("E2_PREFIXO")[1] + 2 /*Tamanho*/, /*lPixel*/,)
TRCell():New( oSection2,"E2_NUM",     "SE2", /*X3Titulo*/, /*Picture*/, 23 /*Tamanho*/, /*lPixel*/,)
TRCell():New( oSection2,"E2_EMISSAO", "SE2", /*X3Titulo*/, /*Picture*/, 17 /*Tamanho*/, /*lPixel*/,)
TRCell():New( oSection2,"E2_EMIS1",   "SE2", STR0036 + CRLF + STR0037 /*X3Titulo*/, /*Picture*/, 15 /*Tamanho*/, /*lPixel*/,)
TRCell():New( oSection2,"E2_VENCREA", "SE2", STR0036 + CRLF + STR0038 /*X3Titulo*/, /*Picture*/, 15 /*Tamanho*/, /*lPixel*/,)
TRCell():New( oSection2,"DEBITO",     "   ", STR0039 /*X3Titulo*/, PesqPict("SE2","E2_VALOR") /*Picture*/, TamSx3("E2_VALOR")[1] + 3 /*Tamanho*/, /*lPixel*/,)
TRCell():New( oSection2,"CREDITO",    "   ", STR0040 /*X3Titulo*/, PesqPict("SE2","E2_VALOR") /*Picture*/, TamSx3("E2_VALOR")[1] + 3 /*Tamanho*/, /*lPixel*/,)
TRCell():New( oSection2,"SALDO",      "   ", STR0041 + CRLF + STR0042 /*X3Titulo*/, PesqPict("SE2","E2_VALOR") /*Picture*/, TamSx3("E2_VALOR")[1] + 3 /*Tamanho*/, /*lPixel*/,)
TRCell():New( oSection2,"MONEDA",     "   ", ". " + STR0045 + CRLF + "  " + STR0046 /*X3Titulo*/, /*Picture*/, 23 /*Tamanho*/, /*lPixel*/,)
TRCell():New( oSection2, "A2_COD" 	,"SA2", /*X3Titulo*/, /*Picture*/, TamSX3("A2_COD")[1]+TamSx3("A2_LOJA")[1] + 2, /*lPixel*/,)
TRCell():New( oSection2, "A2_NOME"	,"SA2", /*X3Titulo*/, /*Picture*/, /*Tamanho*/, /*lPixel*/,)

oSection2:Cell("E2_EMISSAO"):SetHeaderAlign("RIGHT")
oSection2:Cell("E2_EMIS1"  ):SetHeaderAlign("RIGHT")
oSection2:Cell("E2_VENCREA"):SetHeaderAlign("RIGHT")
oSection2:Cell("DEBITO"    ):SetHeaderAlign("RIGHT")
oSection2:Cell("CREDITO"   ):SetHeaderAlign("RIGHT")
oSection2:Cell("SALDO"     ):SetHeaderAlign("RIGHT")

Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrintºAutor  ³Paulo Augusto       º Data ³  21/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de impressao                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport )

Local oSection1 := oReport:Section(1)
Local oSection2 := oSection1:Section(1)
Local lAgregSEK := .F., cLoja := ""
Local cFiltro	:=	oSection1:GetAdvPlExp('SA2')
Local aOPMOn    := {{"",""}}
Private nDecs   := MsDecimais(1)

If !Empty(oReport:uParam)
	Pergunte(oReport:uParam, .F.)
EndIf

IF empty(MV_PAR12)
	MSGINFO("Debe informar la moneda del reporte!!")
	Return
ENDIF


oReport:SetTitle(STR0003 + "-" +&("cMoed"+ALLTRIM(STR(MV_PAR12))))

aTipDoc    := {{"FT ", "FT"}, {"NF ", "FT"}, {"NCP", "NC"},  {"NDP", "ND"},{"NCI", "CI"},  {"NDI", "DI"}}
cCodPro    := ""
cProveedor := ""
cTelef     := ""
cContact   := ""
nDebPro    := 0
nCredPro   := 0
nSalAC     := 0
nSalMO     := 0
nTotDeb    := 0
nTotCred   := 0
nTotMO     := 0
aFields    := {}

AAdd( aFields, { "CODPRO",    "C", TamSx3('E2_FORNECE')[1], 0 } )
AAdd( aFields, { "LOJA",      "C", TamSx3('E2_LOJA')[1],    0 } )
AAdd( aFields, { "PROVEEDOR", "C", 40, 0 } )
AAdd( aFields, { "TIPODOC",   "C", 02, 0 } )
AAdd( aFields, { "SERIE",     "C", 03, 0 } )
AAdd( aFields, { "NRODOC",    "C", 13, 0 } )
AAdd( aFields, { "FECHA",     "D", 08, 0 } )
AAdd( aFields, { "FECVTO",    "D", 08, 0 } )
AAdd( aFields, { "FECREG",    "D", 08, 0 } )
AAdd( aFields, { "DEBITO",    "N", 15, 2 } )
AAdd( aFields, { "CREDITO",   "N", 15, 2 } )
AAdd( aFields, { "SALDO",     "N", 15, 2 } )
AAdd( aFields, { "TIPSAL",    "C", 01, 2 } )
AAdd( aFields, { "TELEFONOS", "C", 40, 0 } )
AAdd( aFields, { "CONTACTO",  "C", 40, 0 } )
AAdd( aFields, { "HIST",      "C", 25, 0 } )
AAdd( aFields, { "MONEDA",    "C", 05, 0 } )

cDbfTmp := CriaTrab( aFields, .t. ) + GetDBExtension()
cNtxTmp := CriaTrab( , .f. ) + OrdBagExt()

IF !Empty( Select( "TRB" ) )
	DbSelectArea( "TRB" )
	DbCloseArea()
ENDIF
FErase( cNtxTmp )

DbUseArea( .T., __cRDDNTTS, cDbfTmp, "TRB", .f., .f. )
DbCreateIndex( cNtxTmp, "CODPRO+TIPODOC+SERIE+NRODOC", { || CODPRO+TIPODOC+SERIE+NRODOC }, .f. )

SE5->(DbSetOrder(7))
DbSelectArea( "SA2" )
DbSetOrder( 1 )

DbSelectArea( "SE2" )
DbSetOrder( 6 )

IF !Empty( mv_par01 )
	DbSeek( xFilial( "SE2" ) + mv_par01 , .t. )
ELSE
	DbSeek(xFilial())
ENDIF

WHILE !EoF() .AND. E2_FILIAL == xFilial() .AND. E2_FORNECE <= mv_par02

	DbSelectArea("SA2")
	DbSeek( xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA )
	If !Empty(cFiltro) .And. !(&(cFiltro))
		DbSelectArea("SE2")
		DbSkip()
		Loop
	Endif

	// Imprime otras monedas?
	If mv_par13 == 2 .and. SE2->E2_MOEDA <> mv_par12
		DbSelectArea("SE2")
		DbSkip()
		Loop
	Endif
	//Filtra diferencias de cambio
	IF SE2->E2_MOEDA <> mv_par12 .and.  ( SE2->E2_TIPO=="DCP" .or. SE2->E2_TIPO=="DDP")
		DbSelectArea("SE2")
		DbSkip()
		Loop
	ENDIF

	DbSelectArea( "SE2" )
	IF Alltrim( E2_TIPO) $ "TF^CH^PA".OR. E2_EMISSAO > dDataBase
		DbSkip()
		Loop
	Endif

	cCodPro		:= SA2->A2_COD
	cProveedor	:= SA2->A2_NOME
	cTelef		:= SA2->A2_TEL
	cContact		:= SA2->A2_CONTATO

	IF ( mv_par06 ==1  .AND. E2_EMISSAO < mv_par03 ) .OR.;
		( mv_par06 == 2 .AND. E2_VENCREA < mv_par03 ) .Or.;
		( mv_par06 == 3 .AND. E2_EMIS1   < mv_par03 )

		DbSelectArea( "TRB" )

		IF !DbSeek( SE2->E2_FORNECE+"SA")
			TRB->( DbAppend() )
			TRB->CODPRO    := cCodPro
			TRB->LOJA      := SA2->A2_LOJA
			TRB->PROVEEDOR := cProveedor
			TRB->TELEFONOS := cTelef
			TRB->CONTACTO  := cContact
			TRB->TIPODOC   := "SA"
			TRB->FECHA     := mv_par03 - 1
		ENDIF

		DbSelectArea( "SE2" )
		IF !(E2_TIPO $ MV_CPNEG .or. SubStr(E2_TIPO, 3, 1) == "-")
			TRB->CREDITO += xMcMoeda(1)
			TRB->SALDO   -= xMcMoeda(2)
		ELSE
			TRB->DEBITO += xMcMoeda(1)
			TRB->SALDO  += xMcMoeda(2)
		ENDIF
		LeBaixaMCompra(SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
		DbSelectArea( "SE2" )
	ELSE
		IF  ( mv_par06 == 1 .AND. E2_EMISSAO <= mv_par04 ) .OR. ;
			( mv_par06 == 2 .AND. E2_VENCREA <= mv_par04 ) .OR. ;
			( mv_par06 == 3 .AND. E2_EMIS1   <= mv_par04 )

			TRB->( DbAppend() )
			TRB->CODPRO    := cCodPro
			TRB->LOJA      := SA2->A2_LOJA
			TRB->PROVEEDOR := cProveedor
			TRB->TELEFONOS := cTelef
			TRB->CONTACTO  := cContact

			cTipo 	:= Space( 3 )
			cTipo   := E2_TIPO
			nPosTp	:=	AScan( aTipDoc, { |a| a[1] == E2_TIPO })
			cTipo	:=	IIf(nPosTp	>	0	, aTipDoc[nPosTp][2],cTipo)
			TRB->MONEDA  := "  " + alltrim(aSimbMon[E2_MOEDA,6]) //E2_MOEDA //
			TRB->SERIE   := AllTrim( E2_PREFIXO )
			TRB->NRODOC  := E2_NUM
			TRB->FECHA   := E2_EMISSAO
			TRB->FECVTO  := E2_VENCREA
			TRB->FECREG  := E2_EMIS1
			TRB->TIPODOC := cTipo
			TRB->TIPSAL  := IIf(!(E2_TIPO $ MV_CPNEG .or. subStr(E2_TIPO, 3, 1) == "-"), "A", "D")
			If TRB->TIPSAL == "A"
				TRB->CREDITO := +xMcMoeda(1)
				TRB->SALDO   := -xMcMoeda(2)
			Else
				TRB->DEBITO := +xMcMoeda(1)
				TRB->SALDO  := +xMcMoeda(2)
			Endif
			TRB->HIST  := E2_HIST
			LeBaixaMCompra(SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
			DbSelectArea( "SE2" )
		ENDIF
	ENDIF
	DbSkip()
ENDDO

DbSelectArea( "SE2" )
DbSetOrder( 8 )

DbSelectArea( "SEK" )
DbSetOrder( 3 )

If FieldPos("EK_FORNEPG")>0 .AND. FieldPos("EK_LOJAPG")>0
	lAgregSEK := .T.
EndIf
DbSeek(xFilial("SEK"))

WHILE !EoF() .AND. EK_FILIAL == xFilial("SEK") .AND. EK_DTDIGIT <= mv_par04

	If EK_DTDIGIT > dDataBase .OR. EK_CANCEL
		DbSkip()
		Loop
	Endif

	If lAgregSEK .and. !Empty(EK_FORNEPG)
		cCodPro	:= EK_FORNEPG
		cLoja	:= EK_LOJAPG
	Else
		cCodPro	:= EK_FORNECE
		cLoja	:= EK_LOJA
	EndIf

	If cCodPro < mv_par01 .or.cCodPro > mv_par02
		DbSkip()
		Loop
	EndIf

	DbSelectArea( "SA2" )
	DbSeek( xFilial( "SA2" ) + cCodPro + cLoja )
	If !Empty(cFiltro) .And. !(&(cFiltro))
		DbSelectArea( "SEK" )
		DbSkip()
		Loop
	Endif

	DbSelectArea( "TRB" )
	// Imprime otras monedas?
	IF (SEK->EK_TIPODOC <> "TB" .Or. SEK->EK_TIPODOC == "PA" )

		nPosOP	:= 0
		nPosOP	:= AScan( aOPMon, { |a| a[1] == SEK->EK_ORDPAGO })
		IF nPosOP == 0
			IF !empty(SEK->EK_BANCO) .and. SEK->EK_TIPODOC <> "CT"
				SA6->(DbSetOrder(1))
				SA6->(DbSeek(xFilial("SA6")+SEK->EK_BANCO+SEK->EK_AGENCIA+SEK->EK_CONTA))
				If mv_par13 == 2 .and. SA6->A6_MOEDA <> mv_par12
					DbSelectArea("SEK")
					DbSkip()
					Loop
				Endif
				aadd(aOPMOn,{SEK->EK_ORDPAGO,"  " + alltrim(aSimbMon[SA6->A6_MOEDA,6]) })
			ELSE
				aadd(aOPMOn,{SEK->EK_ORDPAGO,"  " + alltrim(aSimbMon[VAL(SEK->EK_MOEDA),6]) })
			ENDIF
		ENDIF
	ENDIF
	If mv_par13 == 2 .and. val(SEK->EK_MOEDA) <> mv_par12
		DbSelectArea("SEK")
		DbSkip()
		Loop
	Endif

	SE2->(DBSETORDER(1))
	If SE2->(DbSeek(xFilial()+SEK->(EK_PREFIXO+EK_NUM+EK_PARCELA+EK_TIPO+EK_FORNECE+EK_LOJA)))
		If mv_par13 == 2 .and. SE2->E2_MOEDA <> mv_par12
			DbSelectArea("SEK")
			DbSkip()
			Loop
		Endif
	Endif

	cProveedor := SA2->A2_NOME
	DbSelectArea( "SEK" )
	IF EK_DTDIGIT < mv_par03
		DbSelectArea( "TRB" )
		IF !DbSeek( cCodPro+"SA", .F. )
			TRB->( DbAppend() )
			TRB->CODPRO    := cCodPro
			TRB->LOJA      := SA2->A2_LOJA
			TRB->PROVEEDOR := cProveedor
			TRB->TIPODOC   := "SA"
			TRB->FECHA     := mv_par03 - 1
			TRB->TELEFONOS := SA2->A2_TEL
			TRB->CONTACTO  := SA2->A2_CONTATO
		ENDIF

		DbSelectArea( "SEK" )
		cOrdPag := EK_ORDPAGO
		WHILE !EoF() .AND. xFilial( "SEK" ) == EK_FILIAL .AND. EK_ORDPAGO == cOrdPag


			// Imprime otras monedas?
			If mv_par13 == 2 .and. val(SEK->EK_MOEDA) <> mv_par12
				DbSelectArea("SEK")
				DbSkip()
				Loop
			Endif

			IF EK_TIPODOC <> "TB" .and. EK_TIPODOC <> "PA"//(EK_TIPODOC == "TB" .Or. EK_TIPODOC == "PA" )
				If EK_TIPODOC <> "TB"//!(EK_TIPO $ "PA " + MV_CPNEG .and. EK_TIPODOC <> "PA")
					TRB->DEBITO  += xMcMoeda(4)
				Else
					TRB->CREDITO += xMcMoeda(4)
				Endif
				If SEK->EK_TIPODOC   == "PA"
					SE2->(DBSETORDER(1))
					If SE2->(DbSeek(xFilial()+SEK->(EK_PREFIXO+EK_NUM+EK_PARCELA+EK_TIPO+EK_FORNECE+EK_LOJA)))
						TRB->SALDO += xMcMoeda(2)
					Endif
				Endif
			ENDIF

			If TRB->CREDITO > TRB->DEBITO
				TRB->TIPSAL := "A"
			Else
				TRB->TIPSAL := "D"
			Endif

			DbSkip()
		ENDDO
	ELSE
		IF EK_DTDIGIT <= mv_par04

			DbSelectArea( "TRB" )

			TRB->( DbAppend() )
			TRB->CODPRO    := cCodPro
			TRB->LOJA      := SA2->A2_LOJA
			TRB->PROVEEDOR := cProveedor
			TRB->NRODOC    := If( !Empty( Val( SEK->EK_ORDPAGO ) ), ;
			StrZero( Val( SEK->EK_ORDPAGO ), 12 ), SEK->EK_ORDPAGO )
			TRB->FECHA     := SEK->EK_DTDIGIT
			TRB->FECVTO    := SEK->EK_EMISSAO
			TRB->FECREG    := SEK->EK_DTDIGIT
			TRB->TIPODOC   := "OP"
			TRB->TIPSAL    := "A"
			TRB->TELEFONOS := SA2->A2_TEL
			TRB->CONTACTO  := SA2->A2_CONTATO
			IF !Empty(SEK->EK_BANCO).and. SEK->EK_TIPODOC <> "CT"
				TRB->MONEDA    := "  " + alltrim(aSimbMon[POSICIONE("SA6",1,xFilial("SA6")+SEK->EK_BANCO+SEK->EK_AGENCIA+SEK->EK_CONTA,"A6_MOEDA"),6])
			ELSE
				TRB->MONEDA    := "  " + alltrim(aSimbMon[Val(SEK->EK_MOEDA),6])
			ENDIF
			DbSelectArea( "SEK" )
			cOrdPag := EK_ORDPAGO

			WHILE !EoF() .AND. xFilial( "SEK" ) == EK_FILIAL .AND. EK_ORDPAGO == cOrdPag

				// Imprime otras monedas?
				IF (EK_TIPODOC <> "TB" .Or. EK_TIPODOC == "PA" )
					TRB->MONEDA    := "  " + alltrim(aSimbMon[Val(SEK->EK_MOEDA),6])
					nPosOP	:= 0
					nPosOP	:= AScan( aOPMon, { |a| a[1] == SEK->EK_ORDPAGO })
					IF nPosOP > 0
						TRB->MONEDA    := aOPMOn[nPosOP,2]
					ELSE
						aadd(aOPMOn,{SEK->EK_ORDPAGO,"  " + alltrim(aSimbMon[Val(SEK->EK_MOEDA),6])})
					ENDIF
				ENDIF

				nPosOP	:= 0
				nPosOP	:= AScan( aOPMon, { |a| a[1] == SEK->EK_ORDPAGO })
				IF nPosOP > 0
					TRB->MONEDA    := aOPMOn[nPosOP,2]
				ENDIF


				SE2->(DBSETORDER(1))
				If SE2->(DbSeek(xFilial()+SEK->(EK_PREFIXO+EK_NUM+EK_PARCELA+EK_TIPO+EK_FORNECE+EK_LOJA)))
					If mv_par13 == 2 .and. SE2->E2_MOEDA <> mv_par12
						DbSelectArea("SEK")
						DbSkip()
						Loop
					Endif
				Endif

				If mv_par13 == 2 .and. val(SEK->EK_MOEDA) <> mv_par12
					DbSelectArea("SEK")
					DbSkip()
					Loop
				Endif

				IF EK_TIPODOC <> "TB" .and. EK_TIPODOC <> "PA"//(EK_TIPODOC == "TB".Or. EK_TIPODOC == "PA" )
					If EK_TIPODOC <> "TB"//!(EK_TIPO $ "PA " + MV_CPNEG .and. EK_TIPODOC <> "PA")
						TRB->DEBITO += xMcMoeda(4)
					Else
						TRB->CREDITO += xMcMoeda(4)
					Endif
					IF !Empty(SEK->EK_BANCO)  .AND. EK_TIPODOC <> "CT"
						TRB->MONEDA    := "  " + alltrim(aSimbMon[POSICIONE("SA6",1,xFilial("SA6")+SEK->EK_BANCO+SEK->EK_AGENCIA+SEK->EK_CONTA,"A6_MOEDA"),6])
					ENDIF
					If SEK->EK_TIPODOC   == "PA"
						SE2->(DBSETORDER(1))
						If SE2->(DbSeek(xFilial()+SEK->(EK_PREFIXO+EK_NUM+EK_PARCELA+EK_TIPO+EK_FORNECE+EK_LOJA)))
							TRB->SALDO += xMcMoeda(2)
						Endif
					Endif
				ENDIF
				DbSkip()
			ENDDO
		ELSE
			DbSkip()
		ENDIF
	ENDIF
ENDDO

DbSelectArea( "TRB" )
DbClearIndex()
FErase( cNtxTmp )

If TRB->( RecCount() ) == 0
	MsgAlert(STR0006, "ALERT" )  //"No se encontraron datos segun los parametros ingresados"
	RETURN .f.
EndIf

IF mv_par07 < 2
	IF mv_par06 < 2
		DbCreateIndex( cNtxTmp, "CODPRO+DTOS(FECHA)+TIPODOC+SERIE+NRODOC", ;
		{ || CODPRO+DTOS(FECHA)+TIPODOC+SERIE+NRODOC }, .f. )
	ELSE
		DbCreateIndex( cNtxTmp, "CODPRO+DTOS(FECVTO)+TIPODOC+SERIE+NRODOC", ;
		{ || CODPRO+DTOS(FECVTO)+TIPODOC+SERIE+NRODOC }, .f. )
	ENDIF
ELSE
	IF mv_par06 == 1
		DbCreateIndex( cNtxTmp, "PROVEEDOR+DTOS(FECHA)+TIPODOC+SERIE+NRODOC", ;
		{ || CODPRO+DTOS(FECHA)+TIPODOC+SERIE+NRODOC }, .f. )
	ELSEIf mv_par06 == 2
		DbCreateIndex( cNtxTmp, "PROVEEDOR+DTOS(FECVTO)+TIPODOC+SERIE+NRODOC", ;
		{ || CODPRO+DTOS(FECVTO)+TIPODOC+SERIE+NRODOC }, .f. )
	ELSEIf mv_par06 == 3
		DbCreateIndex( cNtxTmp, "PROVEEDOR+DTOS(FECREG)+TIPODOC+SERIE+NRODOC", ;
		{ || CODPRO+DTOS(FECREG)+TIPODOC+SERIE+NRODOC }, .f. )
	ENDIF
ENDIF


DbSelectArea("TRB")
DbGoTop()

oReport:SetMeter(TRB->( RecCount() ) + 1)


If MV_PAR05==2
	oSection2:Cell("E2_TIPO"):Disable()
	oSection2:Cell("E2_EMISSAO"):Disable()
	oSection2:Cell("E2_VENCREA"):Disable()
	oSection2:Cell("E2_EMIS1"):Disable()
	oSection2:Cell("E2_EMISSAO"):Disable()
	oSection2:Cell("E2_NUM"):SetTitle(" ")
	oSection2:Cell("E2_PREFIXO"):Disable()
	oSection2:Cell("MONEDA"):Disable()
EndIf
oSection1:SetHeaderPage(.T.)
oSection2:SetHeaderPage(.T.)
WHILE !EoF()

	cCodPro    := CODPRO
	cProveedor := AllTrim( PROVEEDOR )
	cTelef     := AllTrim( TELEFONOS )
	cContact   := AllTrim( CONTACTO )
	oSection2:Init()
	WHILE !EoF() .AND. CODPRO == cCodPro

		nCredPro := nCredPro + CREDITO
		nTotCred := nTotCred + CREDITO
		nDebPro  := nDebPro  + DEBITO
		nTotDeb  := nTotDeb  + DEBITO

		nSalMO   := nSalMO   + SALDO
		nSalAC   := nSalAC   + (DEBITO - CREDITO)
		nTotMO   := nTotMO   + SALDO

		IF mv_par05 == 1 // .AND. !Empty( VALOR )
			DbSelectArea("TRB")
			IF TIPODOC == "SA"
				oSection2:Cell("E2_NUM"):SetBlock({|| STR0012})
				oSection2:Cell("E2_EMISSAO"):SetBlock({||TRB->FECHA })
			ELSE
				oSection2:Cell("E2_TIPO"):SetBlock({||TRB->TIPODOC })
				oSection2:Cell("E2_PREFIXO"):SetBlock({||TRB->SERIE })
				IF ALLTRIM(TRB->SERIE) == "E"
					oSection2:Cell("E2_NUM"):SetBlock({||TRB->NRODOC })
				ELSE
					oSection2:Cell("E2_NUM"):SetBlock({||Left(TRB->NRODOC, 4) + "-" + Right(TRB->NRODOC, 9) })
				ENDIF
				oSection2:Cell("E2_EMISSAO"):SetBlock({|| STR0012})
				oSection2:Cell("E2_VENCREA"):SetBlock({||TRB->FECVTO })
				oSection2:Cell("E2_EMIS1"):SetBlock({||TRB->FECREG })
				oSection2:Cell("E2_EMISSAO"):SetBlock({|| TRB->FECHA})
			Endif

			IF DEBITO > 0
				oSection2:Cell("DEBITO"):SetBlock({||TRB->DEBITO })
			ENDIF

			IF CREDITO > 0
				oSection2:Cell("CREDITO"):SetBlock({||CREDITO})
			Endif
			oSection2:Cell("SALDO"):SetBlock({||nSalAC })
			oSection2:Cell("MONEDA"):SetBlock({||TRB->MONEDA })
			oSection2:PrintLine()
		ENDIF

		DbSkip()
		oReport:IncMeter()
	ENDDO

	IF ( mv_par10 == 1 .OR. cCodPro <> CodPro ) .AND. mv_par09 == 1
		cDisp := cTelef + " - " + cContact
		IF mv_par05 < 2
			//oReport:SkipLine()
			oReport:ThinLine()
			oReport:SkipLine()
			oReport:PrintText(STR0013 + cCodPro + " (" + Left( cDisp, 40 ) + ")" )
		ELSE
			oReport:PrintText( cCodPro  +  "  " + cProveedor + " (" +  Left( cDisp, 40 ) + ")"  )
		ENDIF
		oSection2:Cell("E2_TIPO"):Hide()
		oSection2:Cell("E2_NUM"):Hide()
		oSection2:Cell("E2_EMISSAO"):Hide()
		oSection2:Cell("E2_VENCREA"):Hide()
		oSection2:Cell("E2_EMIS1"):Hide()
		oSection2:Cell("E2_EMISSAO"):Hide()
		oSection2:Cell("E2_PREFIXO"):Hide()
		oSection2:Cell("DEBITO"):SetBlock({||nDebPro })
		oSection2:Cell("CREDITO"):SetBlock({||nCredPro})
		oSection2:Cell("SALDO"):SetBlock({||nSalAC })
		oSection2:Cell("MONEDA"):HIDE()
		oSection2:Cell("A2_COD"):HIDE()        
		oSection2:Cell("A2_NOME"):HIDE() 
		
		oSection2:PrintLine()
		oSection2:Cell("E2_TIPO"):Show()
		oSection2:Cell("E2_NUM"):Show()
		oSection2:Cell("E2_EMISSAO"):Show()
		oSection2:Cell("E2_VENCREA"):Show()
		oSection2:Cell("E2_EMIS1"):Show()
		oSection2:Cell("E2_EMISSAO"):Show()
		oSection2:Cell("E2_PREFIXO"):Show()
		oSection2:Cell("MONEDA"):Show()
		oSection2:Cell("A2_COD"):Show()        
		oSection2:Cell("A2_NOME"):Show() 
		        

		IF mv_par05 < 2
			//oReport:SkipLine()
			oReport:ThinLine()
			oReport:SkipLine()
		ENDIF
		nDebPro  := 0
		nCredPro := 0
		nSalAC   := 0
		nSalMo   := 0
	ENDIF
	oSection2 :Finish()
ENDDO

IF  mv_par09 == 1  // normal
	oReport:SkipLine()
	oSection2:Init()
	oSection2:Cell("E2_TIPO"):Hide()
	oSection2:Cell("E2_EMISSAO"):Hide()
	oSection2:Cell("E2_VENCREA"):Hide()
	oSection2:Cell("E2_EMIS1"):Hide()
	oSection2:Cell("E2_EMISSAO"):Hide()
	oSection2:Cell("E2_PREFIXO"):Hide()
	oSection2:Cell("E2_NUM"):SetBlock({|| STR0014})
	oSection2:Cell("DEBITO"):SetBlock({||nTotDeb})
	oSection2:Cell("CREDITO"):SetBlock({||nTotCred })
	oSection2:Cell("SALDO"):SetBlock({|| nTotDeb-nTotCred })
	oSection2:Cell("MONEDA"):SetBlock({|| TRB->MONEDA })
	oSection2:Cell("A2_COD"):HIDE()        
	oSection2:Cell("A2_NOME"):HIDE() 
		
	oSection2:PrintLine()
	oReport:SkipLine()
	oReport:FatLine()
EndIf
TRB->( DbCloseArea() )
FErase( cDbfTmp )
FErase( cNtxTmp )

RETURN NIL


// Grava as baixas manuais que houverem do titulo corrente no arquivo de trabalho.
Static Function LeBaixaMCompra(cChave)
Local cSeq, nReg
SE5->(DbSeek(xFilial("SE5") + cChave))
While cChave = SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) ;
	.AND. ! SE5->(EOF())
	cSeq := SE5->E5_SEQ
	nReg := SE5->(Recno())
	If SE5->E5_TIPODOC = "VL" .Or. (SE5->E5_TIPODOC == "BA" .And. SE5->E5_MOTBX== 'CEC')  // Baixa manual e baixa por compensacao entre carteiras
		SE5->(DbSkip())
		If ! (cChave+cSeq = SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) ;
			.And. SE5->E5_TIPODOC = "ES") // Nao faz nada se Houver Estorno da baixa
			SE5->(DbGoto(nReg))
			TRB->( DbAppend() )
			TRB->CODPRO    	:= cCodPro
			TRB->PROVEEDOR 	:= cProveedor
			TRB->TELEFONOS 	:= cTelef
			TRB->CONTACTO  	:= cContact
			TRB->CREDITO    := xMcMoeda(3)
			TRB->TIPSAL		:= "A"
			TRB->SALDO 		:= -TRB->CREDITO
			TRB->NRODOC		:= SE5->E5_NUMERO
			TRB->TIPODOC	:= SE5->E5_TIPODOC
			TRB->SERIE		:= SE5->E5_PREFIXO
			TRB->FECHA     	:= SE5->E5_DATA
			TRB->FECREG    	:= SE5->E5_DTDIGIT
		EndIf
	ElseIf SE5->E5_TIPODOC $ "JR/MT/DC/IS" .And. SE5->E5_SITUACA != "C" // Juros, Multa, Desconto, Impsubst(localiz"CHI")
		TRB->( DbAppend() )
		TRB->CODPRO    := cCodPro
		TRB->PROVEEDOR := cProveedor
		TRB->TELEFONOS := cTelef
		TRB->CONTACTO  := cContact
		If SE5->E5_TIPODOC = "DC"
			TRB->TIPSAL := "A"
			TRB->CREDITO := xMcMoeda(3)
			TRB->SALDO   := -TRB->CREDITO
		Else
			TRB->TIPSAL	:= "D"
			TRB->DEBITO := xMcMoeda(3)
			TRB->SALDO  := TRB->DEBITO
		EndIf
		TRB->NRODOC    := SE5->E5_NUMERO
		TRB->TIPODOC   := SE5->E5_TIPODOC
		TRB->SERIE     := SE5->E5_PREFIXO
		TRB->FECHA     := SE5->E5_DATA
		TRB->FECREG    := SE5->E5_DTDIGIT
	EndIf
	SE5->(DbSkip())
EndDo
Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ xMcMoeda ºAutor  ³ Felipe Raposo      º Data ³  07/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Convierte el valor del titulo en la moneda solicitada.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Etna.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xMcMoeda(nOpcP)

Local nValor  := 0
Local nMoedaO := 0
Local nMoedaD := MV_PAR12  // MV_PAR12 => Moneda => 1-Peso / 2-Dolar...
Local dData   := dDataBase
Local nTasaO  := 0  // Tasa de conversion moneda origen.
Local nTasaD  := 0  // Tasa de conversion moneda destino.
Local nDecs   := MsDecimais(1)
Local cMoeda  := ""
Local cMoedaD := ""

If nOpcP < 4
	// Verifica que es lo que hay que convertir.
	If nOpcP == 1
		nValor := SE2->E2_VALOR
	ElseIf nOpcP == 2
		nValor := SE2->E2_SALDO
	ElseIf nOpcP == 3
		nValor := SE5->E5_VALOR
	Endif
	nMoedaO := SE2->E2_MOEDA

	// Convierte utilizando las tasas especificas .
	// MV_PAR11 => 1-Tasa del Dia / 2-Tasa del movimiento.
	// nMoedaD  => 1-Peso / 2-Dolar.
	If MV_PAR11 == 2
		dData  := SE2->E2_EMIS1// issue 1372 SE2->E2_EMISSAO
		nTasaO := SE2->E2_TXMOEDA
		nTasaD := IIf(nMoedaD == 2, SE2->E2_TXMOEDA, 0)
	Endif
Else
	nValor  := SEK->EK_VALOR
	nMoedaO := Val(SEK->EK_MOEDA)
	If MV_PAR11 == 2
		dData  := SEK->EK_DTDIGIT
		cMoedaD:=STRZERO(nMoedaD,2)
		IF SEK->EK_TIPODOC <> "TB" .and. !empty(SEK->EK_BANCO).and. SEK->EK_TIPODOC <> "CT"
			nMoedaO :=POSICIONE("SA6",1,xFilial("SA6")+SEK->EK_BANCO+SEK->EK_AGENCIA+SEK->EK_CONTA,"A6_MOEDA")
			cMoeda:=STRZERO(nMoedaO,2)
			nTasaO := SEK->(IIf(nMoedaO >= 2 , &("EK_TXMOE" + cMoeda) ,0) )
			nTasaD := SEK->(IIf(nMoedaD >= 2 , &("EK_TXMOE" + cMoedaD) ,0) )
			IF nTasaO == NIL .or. nTasaO == 0
				nTasaO := Recmoeda(dData,val(cMoeda))
			ENDIF
			IF nTasaD == NIL .or. nTasaD == 0
				nTasaD := Recmoeda(dData,nMoedaD)
			ENDIF

		ELSE
			cMoeda:=STRZERO(VAL(SEK->EK_MOEDA),2)
			nTasaO := SEK->(IIf(nMoedaO >= 2 , &("EK_TXMOE" + cMoeda),0) )
			nTasaD := SEK->(IIf(nMoedaD >= 2 , &("EK_TXMOE" + cMoedaD) ,0) )
			IF nTasaO == NIL .or. nTasaO == 0
				nTasaO := Recmoeda(dData,val(cMoeda))
			ENDIF
			IF nTasaD == NIL .or. nTasaD == 0
				nTasaD := Recmoeda(dData,nMoedaD)
			ENDIF
		ENDIF
	Endif
Endif

// Convierte.
nValor := Round(xMoeda(nValor, nMoedaO, nMoedaD, dData, 5, nTasaO, nTasaD), nDecs)

Return nValor


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MCTMOEDA  ºAutor  ³Microsiga           ºFecha ³  03/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcion que devuelve array con descripcion de monedas      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MCTMOEDA

Local aMoneda   := {}
Local nMoeda    := 0
Local cDescMone := ""
Local cSimbMone := ""

DbSelectArea("CTO")
DbSetOrder(1)
CTO->(Dbgotop())
While !CTO->(eof())

	nMoeda  := VAL(CTO->CTO_MOEDA)
	cDescMone:=GetNewPar("MV_MOEDAP"+LTRIM(STR(nMoeda,2)),"")
	cSimbMone:=GetNewPar("MV_SIMB"+LTRIM(STR(nMoeda,1)),"")
	IF Empty(cDescMone)
		cDescMone:=GetNewPar("MV_MOEDP"+LTRIM(STR(nMoeda,2)),"")
		cSimbMone:=GetNewPar("MV_SIMB"+LTRIM(STR(nMoeda,2)),"")
	ENDIF

	cSimbMone:=CTO->CTO_SIMB //Trae simbolo de tabla de monedas contables
	aadd(aMoneda,{nMoeda,CTO->CTO_MOEDA,cDescMone,0,0,cSimbMone})
	CTO->(DbSkip())
END



Return aMoneda
