#INCLUDE "PROTHEUS.CH"
#INCLUDE "ARG_CARF.CH"

#DEFINE CGETFILE_TYPE GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE
/*
Estrutura do registro do arquivo de contribuintes*/
#DEFINE PUBLICACAO		1		//Fecha de Publicacion
#DEFINE INICIOVIGENCIA	2		//Fecha Vigencia Desde
#DEFINE FIMVIGENCIA		3		//Fecha Vigencia Hasta
#DEFINE CUIT	   		4		//Numero de Cuit
#DEFINE TIPOCONTRINSC	5		//Tipo-Contr_Insc
#DEFINE MARCAALTASUJ	6		//Marca-alta-sujeto
#DEFINE MARCAALIQUOTA	7		//Marca-alicuota
#DEFINE ALIQPERCEPCION	8		//Alicuota- Percepcion
#DEFINE ALIQRETENCION	9		//Alicuota- Retencion
#DEFINE GRPPERCEPCION	10		//Nro-Grupo-Percepcion
#DEFINE GRPRETENCION	11		//Nro-Grupo-Retencion
#DEFINE RAZAOSOCIAL		12		//Razon Social
/*
Codigos para situacao dos clientes/fornecedores */
#DEFINE  SIT_NORMAL			"1"
#DEFINE  SIT_RISCO			"2"
#DEFINE  SIT_PERCEPCAO		"3"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณARGCARF   บAutor  ณMarcello Gabriel    บFecha ณ 26/11/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa os arquivo com contribuintes considerados de alto บฑฑ
ฑฑบ          ณ risco. Esse contribuintes terao aliquotas diferenciadas    บฑฑ
ฑฑบ          ณ para percepcao e retencao de impostos.                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Argentina                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ArgCARF()
Private cPerg	:= "ARCARF"
Private cItPerg	:= "01,02

AjustaSx1()
If CARFVerif()
	If Pergunte(cPerg,.T.)
		Arg_CARF()
	Endif
Endif
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCARFVERIF บAutor  ณMarcello Gabriel    บFecha ณ 11/12/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se o ambiente foi alterado para uso do CARF.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ARGCARF                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CARFVerif()
Local lRet	:= .T.
Local cItem	:= cItPerg
Local nPos	:= 0

//Verifica se os novos campos foram criados.
lRet := SA2->(FieldPos("A2_SITUACA")) > 0
lRet := lRet .And. SA1->(FieldPos("A1_SITUACA")) > 0
lRet := lRet .And. SFH->(FieldPos("FH_INIVIGE")) > 0
lRet := lRet .And. SFH->(FieldPos("FH_FIMVIGE")) > 0
If lRet
	SX1->(DbSetORder(1))
	SX1->(DbSeek(cPerg))
	While lRet  .And. !(SX1->(Eof())) .And. AllTrim(SX1->X1_GRUPO) == Alltrim(cPerg)
		nPos := At(SX1->X1_ORDEM,cItem)
		If nPos > 0
			cItem := AllTrim(Substr(cItem,nPos+3))
		Else
			lRet := .F.
		Endif
		SX1->(DbSkip())
	Enddo
	lRet := Empty(cItem)
Endif
If !lRet
	MsgStop(STR0002,STR0001)		//"Para usar a rotina de importa็ใo do arquivo de contribuintes, ้ necessแria a atualiza็ใo do ambiente pelo compatibilizador UPDARGCARF."###"Padrใo de contribuintes com alto risco fiscal"
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณARG_CARF  บAutor  ณMarcello Gabriel    บFecha ณ 26/11/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa os arquivo com contribuintes considerados de alto บฑฑ
ฑฑบ          ณ risco. Esses contribuintes terao aliquotas diferenciadas   บฑฑ
ฑฑบ          ณ para "percepcao" e retencao de impostos.                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Argentina                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Arg_CARF()
Local cArq	:= Space(200)
Local aArea	:= {}
Local oDlg
Local oPnlTopo
Local oPnlBase
Local oPnlCentro
Local oPnlArq
Local oPnl1
Local oPnl2
Local oPnl3
Local oPnl4
Local oPnl5
Local oPnl6
Local oPnlSepar
Local oPnlSepar1
Local oPnlBotao
Local oFonte
Local oArq

aArea := GetArea()
oFonte := TFont():New("Arial",,,,.T.,,,8,.F.,,,,,,,)
oDlg:=TDialog():New(0,0,300,500,STR0001 + " - " + STR0003,,,,,,,,,.T.,,,,,)		//"Padrao de contribuintes com alto risco fiscal"###"Importa็ใo"
	oPnl5:= TPanel():New(01,01,,oDlg,,,,,RGB(221,221,221),5,5,.F.,.F.)
		oPnl5:Align := CONTROL_ALIGN_LEFT
		oPnl5:nWidth := 5
	oPnl6:= TPanel():New(01,01,,oDlg,,,,,RGB(221,221,221),5,5,.F.,.F.)
		oPnl6:Align := CONTROL_ALIGN_RIGHT
		oPnl6:nWidth := 5
	oPnlTopo := TPanel():New(01,01,,oDlg,,,,,RGB(221,221,221),5,30,.F.,.F.)
		oPnlTopo:Align := CONTROL_ALIGN_TOP
		oPnlTopo:nHeight := 50
		oPnlArq := TPanel():New(01,01,,oPnlTopo,,,,,RGB(221,221,221),5,5,.F.,.F.)
			oPnlArq:Align := CONTROL_ALIGN_BOTTOM
			oPnlArq:nHeight := 20
			oPnl1:= TPanel():New(01,01,,oPnlArq,,,,,RGB(221,221,221),5,5,.F.,.F.)
				oPnl1:Align := CONTROL_ALIGN_LEFT
				oPnl1:nWidth := 5
			oPnlBotao:= TPanel():New(01,01,,oPnlArq,,,,,RGB(221,221,221),5,5,.F.,.F.)
				oPnlBotao:Align := CONTROL_ALIGN_RIGHT
				oPnlBotao:nWidth := 45
				oBtnArq := TBtnBmp2():New(003,091,25,28,"folder6","folder6" ,,,{|| CARFSelArq(oArq)},oPnlBotao,STR0004,,.T.)	//"Sele็ใo do arquivo"
					oBtnArq:Align := CONTROL_ALIGN_LEFT
				oBtnPar := TBtnBmp2():New(003,091,25,28,"parametros","parametros" ,,,{|| Pergunte(cPerg,.T.)},oPnlBotao,STR0005,,.T.)		//"Parโmetros"
					oBtnPar:Align := CONTROL_ALIGN_RIGHT
					oBtnParlVisible := .T.
   			@00,00 MSGET oArq VAR cArq SIZE 5,5 PIXEL OF oPnlArq
				oArq:Align := CONTROL_ALIGN_ALLCLIENT
		oPnlTit := TPanel():New(01,01,"  " + STR0006,oPnlTopo,oFonte,,,,RGB(221,221,221),5,30,.F.,.F.)		//"Arquivo de contribuintes"
			oPnlTit:Align := CONTROL_ALIGN_BOTTOM
			oPnlTit:nHeight := 15
	oPnl3:= TPanel():New(01,01,,oDlg,,,,,RGB(221,221,221),5,5,.F.,.F.)
		oPnl3:Align := CONTROL_ALIGN_TOP
		oPnl3:nHeight := 20
	oPnlBase := TPanel():New(01,01,,oDlg,,,,,RGB(221,221,221),5,30,.F.,.F.)
		oPnlBase:Align := CONTROL_ALIGN_BOTTOM
		oPnlBase:nHeight := 20
		DEFINE SBUTTON oBtnCan FROM 013,339 TYPE 2 ACTION (If(MsgYesNo(STR0007,STR0001),(lProcessar := .F.,oPnlTopo:lActive := .T.,oBtnSai:lVisible := .T.,oBtnProc:lVisible := .T.,oBtnCan:lVisible := .T.,oPnlSepar1:lVisible := .F.,oArq:SetFocus()),lProcessar := .T.)) ENABLE PIXEL OF oPnlBase		//"Deseja cancelar o processamento do arquivo de contribuintes ?"
			oBtnCan:cToolTip:=STR0008		//"Cancelar o processamento"
			oBtnCan:Align := CONTROL_ALIGN_RIGHT
		   //	oBtnCan:lVisible := .T.
		oPnlSepar1 := TPanel():New(01,01,,oPnlBase,,,,,RGB(221,221,221),5,30,.F.,.F.)
			oPnlSepar1:Align := CONTROL_ALIGN_RIGHT
			oPnlSepar1:lVisible := .T.
		DEFINE SBUTTON oBtnSai FROM 013,339 TYPE 2 ACTION (oDlg:End()) ENABLE PIXEL OF oPnlBase
			oBtnSai:cToolTip:=STR0009		//"Sair"
			oBtnSai:Align := CONTROL_ALIGN_RIGHT
		oPnlSepar := TPanel():New(01,01,,oPnlBase,,,,,RGB(221,221,221),5,30,.F.,.F.)
			oPnlSepar:Align := CONTROL_ALIGN_RIGHT
		DEFINE SBUTTON oBtnProc FROM 013,279 TYPE 1 ACTION If(CARFValArq(oArq),(oBtnSai:lVisible := .F.,oPnlTopo:lActive := .F.,oBtnProc:lVisible := .F.,oBtnCan:lVisible := .T.,oPnlSepar1:lVisible := .T.,If(CARFProArq(AllTrim(cArq),oPnlCentro),oDlg:End(),)),) ENABLE PIXEL OF oPnlBase
			oBtnProc:cToolTip:=STR0010		//"Processar arquivo informado"
			oBtnProc:Align := CONTROL_ALIGN_RIGHT
	oPnl4:= TPanel():New(01,01,,oDlg,,,,,RGB(221,221,221),5,5,.F.,.F.)
		oPnl4:Align := CONTROL_ALIGN_BOTTOM
		oPnl4:nHeight := 5
	oPnlCentro := TPanel():New(01,01,,oDlg,,,,,RGB(221,221,221),5,5,.F.,.F.)
		oPnlCentro:Align := CONTROL_ALIGN_ALLCLIENT
	oDlg:lCentered := .T.
oDlg:Activate()
RestArea(aArea)
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCARFSELARQบAutor  ณMarcello Gabriel    บFecha ณ 26/11/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ativa o seletor de arquivos                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CARFSelArq(oArq)
Local cArquivo := ""

cArquivo := cGetFile("Texto (*.txt) |*.TXT|Todos (*.*) |*.*|","Seleciona arquivo",0,"C:\",.T.,CGETFILE_TYPE)
If !Empty(cArquivo)
	oArq:cText := cArquivo
	oArq:Refresh()
Endif
oArq:SetFocus()
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCARFVALARQบAutor  ณMarcello Gabriel    บFecha ณ 26/11/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida o arquivo informado para processamento              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CARFValArq(oArq)
Local lRet	:= .T.
Local cArq	:= ""

cArq := AllTrim(oArq:cText)
If Empty(cArq)
	lRet := .F.
	MsgAlert(STR0011,STR0001)		//"Informe o arquivo de contribuintes"###"Padrใo de contribuintes com alto risco fiscal"
	oArq:SetFocus()
Else
	If !File(cArq)
		lRet := .F.
		MsgAlert(STR0012 + "  " + cArq + " " + STR0013,STR0001)		//arquivo###"nao encontrado###"Padrใo de contribuintes com alto risco fiscal"
		oArq:SetFocus()
	Endif
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCARFPROArqบAutor  ณMarcello Gabriel    บFecha ณ 26/11/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessa o arquivo de contribuintes atualizando os arquivos บฑฑ
ฑฑบDesc.     ณde fornecedores, clientes e aliquotas.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CARFProArq(cArq,oDlg)
Local cCUITEmp		:= ""
Local nReg			:= 0
Local nNrReg		:= 0
Local nContReg		:= 0
Local nAlqPerFor	:= 0
Local dIniVig		:= Ctod("//")
Local dFimVig		:= Ctod("//")
Local cContInsc     := ""
Local lRet			:= .T.
Local aReg			:= {}
Local aArea			:= {}
Local oMeter
Local oPnlCon
Local oPnlMtr
Local oFonte
Local oSay

Private lProcessar	:= .F.		//Controla o processamento
Private aEstrTxt	:= {}		//Estrutura do registro do arquivo de contribuintes
Private	cPercepcao	:= "IBP"	//Imposto "percepcao" que sera considerado no processo
Private	cRetencao	:= "IBR"	//Impostos "retencao" que sera considerado no processo
Private cZonaFis	:= "CF"		//Zona fiscal qu			e sera considerada no processo
Private cAliasFor	:= ""		//Alias para o arquivo com os fornecedores que estao em "risco fiscal"
Private cArqFor		:= ""		//Arquivo temporario com os fornecedores que estao em "risco fiscal"
Private cAliasCli	:= ""		//Alias para o arquivo com os clientes que estao em "risco fiscal"
Private cArqCli		:= ""		//Arquivo temporario com os clientes que estao em "risco fiscal"
Private cAliasSFH	:= ""		//Alias do arquivo temporario para verificar se ja existem registros processados do arquivo txt
Private cArqSFH		:= ""		//Arquivo temporario para verificar se ja existem registros processados do arquivo txt
Private lProcCli	:= .F.		//Indica se serao processados clientes
Private lProcFor	:= .F.		//Indica se serao processados fornecedores
Private lProcPer	:= .F.		//Indica se serao atualizadas as aliquotas para "percepcao"
Private lProcRet	:= .F.		//Indica se serao atualizadas as aliquotas para "retencao"
Private lProcSim    := .F.		//Indica se serแ processado o arquivo de Contribuintes de Regime Simplificado

Default cArq := ""

//Estrutura do registro do arquivo de contribuintes
Aadd(aEstrTxt,{"DTPUBLIC","D",8,0})					//Fecha de Publicacion
Aadd(aEstrTxt,{"DTINIVIG","D",8,0})					//Fecha Vigencia Desde
Aadd(aEstrTxt,{"DTFIMVIG","D",8,0})					//Fecha Vigencia Hasta
Aadd(aEstrTxt,{"NRCUIT","C",TamSX3("A1_CGC")[1],0})	//Numero de Cuit
Aadd(aEstrTxt,{"TIPCONTINS","C",1,0})					//Tipo-Contr_Insc
Aadd(aEstrTxt,{"MARCALTSUJ","C",1,0})					//Marca-alta-sujeto
Aadd(aEstrTxt,{"MARCAALIQ","C",1,0})					//Marca-alicuota
Aadd(aEstrTxt,{"ALIQPERC","N",5,2})					//Alicuota- Percepcion
Aadd(aEstrTxt,{"ALIQRETE","N",5,2})					//Alicuota- Retencion
Aadd(aEstrTxt,{"GRPPERCE","N",2,0})					//Nro-Grupo-Percepcion
Aadd(aEstrTxt,{"GRPRETEN","N",2,0})					//Nro-Grupo-Retencion
Aadd(aEstrTxt,{"RAZAOSOC","C",60,0})					//Razon Social

cArq := AllTrim(cArq)
If File(cArq)
	If MsgYesNo(STR0014  + " " + cArq + " ?",STR0001)		//"Confirma o processamento do arquivo de contribuintes"###"Padrใo de contribuintes com alto risco fiscal"
		//contribuinte a processar
		lProcCli := (MV_PAR01 == 2 .Or. MV_PAR01 == 3)		//processar clientes
		lProcFor := (MV_PAR01 == 1 .Or. MV_PAR01 == 3)		//processar fornecedores
		//aliquota a processar
		lProcRet := (MV_PAR02 == 1 .Or. MV_PAR02 == 3)		//processar retencoes
		lProcPer := (MV_PAR02 == 2 .Or. MV_PAR02 == 3)		//processar percepcoes
		//Tipo do Contribuinte de Regime Simplificado
		lProcSim := (MV_PAR03 == 2)               
		//
		cCUITEmp := AllTrim(SM0->M0_CGC)
		//
		aArea := GetArea()
		aReg := {} 
		
	   	If FT_FUse(cArq) > 0
			FT_FGotop()
			nNrReg := FT_FLastRec()
			If nNrReg > 0  .and. (";"$(FT_FREADLN()))			
				aReg := CARFLeReg()
				If CARFForCli(oDlg,aReg[INICIOVIGENCIA],aReg[FIMVIGENCIA],aReg[TIPOCONTRINSC])
					oFonte := TFont():New("Arial",,,,.T.,,,8,.F.,,,,,,,)
					oPnlCon := TPanel():New(01,01,STR0015 + ".",oDlg,oFonte,,,,RGB(221,221,221),5,30,.F.,.F.)		//"Processando o arquivo de contribuintes"
						oPnlCon:Align := CONTROL_ALIGN_TOP
						oPnlCon:nHeight := 15
			   		oSay := TSay():New(0,0,{|| ""},oDlg,,,,,,.T.,,,10,10)
						oSay:Align := CONTROL_ALIGN_TOP
						oSay:nHeight := 15
					oPnlMtr := TPanel():New(01,01,,oDlg,,,,,RGB(221,221,221),5,30,.F.,.F.)
						oPnlMtr:Align := CONTROL_ALIGN_TOP
						oPnlMtr:nHeight := 40
						oMeter:=TMeter():New(60,05,,100,oPnlMtr,150,10,,.T.,,STR0016,.T.,,,,,.F.)		//"Contribuintes"
							oMeter:Align := CONTROL_ALIGN_TOP
							oMeter:nHeight := 15
					oMeter:Set(0)
					nReg := 0
					nContReg := 0
					lProcessar := .T.
					oDlg:Refresh()
					ProcessMessages()
					While lProcessar .And. !(FT_FEof())
						aReg := CARFLeReg()
						oSay:cCaption := AllTrim(aReg[CUIT]) + " - " + Iif(Len(aReg)< RAZAOSOCIAL," ", Alltrim(aReg[RAZAOSOCIAL]))
						//Processamento de clientes
						If lProcCli
							If lProcPer		// Verifica/cria a aliquota de "percepcao" para o cliente
								CARFCliPer(aReg[CUIT],aReg[ALIQPERCEPCION],aReg[INICIOVIGENCIA],aReg[FIMVIGENCIA],aReg[TIPOCONTRINSC])
							Endif
						Endif
						//Processamento de fornecedores
						If lProcFor
							If lProcPer		// Verifica/cria a aliquota de "percepcao" para o cliente siga
								//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
								//ณCaso o cliente siga esteja no arquivo de contribuintes de ณ
								//ณalto risco, os dados sao guardados para a atualizacao da  ณ
								//ณaliquota de "percepcao" dos fornecedores.                 ณ
								//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
								If AllTrim(aReg[CUIT]) == cCUITEmp
									nAlqPerFor	:= aReg[ALIQPERCEPCION]
									dIniVig		:= aReg[INICIOVIGENCIA]
									dFimVig		:= aReg[FIMVIGENCIA]
									cContInsc   := aReg[TIPOCONTRINSC]
								Endif
							Endif
							If lProcRet		// Verifica/cria a aliquota de retencao para o fornecedor
								CARFForRet(aReg[CUIT],aReg[ALIQRETENCION],aReg[INICIOVIGENCIA],aReg[FIMVIGENCIA],aReg[TIPOCONTRINSC])
							Endif
						Endif
						nContReg++
						nReg := Int((100 * nContReg) / nNrReg)
						oMeter:Set(nReg)
						FT_FSkip()
						ProcessMessages()
					Enddo
					//Processamento de fornecedores
					If lProcFor
						If lProcPer
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณCaso o cliente siga esteja no arquivo de contribuintes de altoณ
							//ณrisco ou de Regime simplificado atualiza aliquota de 		 ณ
							//ณ"percepcao" dos fornecedores.     						     ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							If nAlqPerFor <> 0
								CARFForPer(cCUITEmp,nAlqPerFor,dIniVig,dFimVig,oDlg)
							Endif
						Endif
					Endif
				Endif 
	
			Endif 
									
			lRet := .F.  
			FT_FUse() 
			
			If lRet
            	oSay:Free() 
	
		   		ProcessMessages()
				If lProcessar
					CARFNormais(oDlg)
					MsgAlert(STR0017,STR0001)		//"Processo encerrado"###"Padrใo de contribuintes com alto risco fiscal"
		   		Else
			   		lRet := .F.
		   		Endif
		   
		    
		    
				MsUnLockAll()
				DbCommitAll()
				If lProcCli
					If Select(cAliasCli) > 0
						DbSelectArea(cAliasCli)
						DbCloseArea()
						If File(cArqCli + GetDBExtension())
						   Ferase(cArqCli + GetDBExtension())
						EndIf
						If File(cArqCli + OrdBagExt())
						   Ferase(cArqCli + OrdBagExt())
						EndIf
					Endif
				Endif
				If lProcFor
					If Select(cAliasFor) > 0
						DbSelectArea(cAliasFor)
						DbCloseArea()
						If File(cArqFor + GetDBExtension())
						   Ferase(cArqFor + GetDBExtension())
						EndIf
						If File(cArqFor + OrdBagExt())
						   Ferase(cArqFor + OrdBagExt())
						EndIf
					Endif
				Endif
				If Select(cAliasSFH) > 0
					DbSelectArea(cAliasSFH)
					DbCloseArea()
					If File(cArqSFH + GetDBExtension())
					   Ferase(cArqSFH + GetDBExtension())
					EndIf
					If File(cArqSFH + OrdBagExt())
					   Ferase(cArqSFH + OrdBagExt())
					EndIf
				Endif
				oPnlCon:Free()
				oMeter:Free()
		     	oPnlMtr:Free()
			 //Else  
			   //	lRet := .F.
               // MsgStop(STR0018,STR0001)		//"Nใo foi possํvel abrir o arquivo de contribuintes"###"Padrใo de contribuintes com alto risco fiscal"
			 Endif
			  
		Else
			MsgStop(STR0018,STR0001)		//"Nใo foi possํvel abrir o arquivo de contribuintes"###"Padrใo de contribuintes com alto risco fiscal"
		Endif
		RestArea(aArea)
	Endif
Else
	lRet := .F.
	MsgAlert(STR0012 + " " + cArq + " " + STR0013,STR0001)		//"Arquivo"###nใo encontrado###Padrใo de contribuintes com alto risco fiscal
Endif  

iF !(FT_FEof())
	lRet:=.T.
	MsgAlert(STR0017,STR0001)		
endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณARGCARFLEREGบAutor  ณMarcello Gabriel    บFecha ณ 26/11/2008  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLe uma linha do arquivo texto e separa os campos no array     บฑฑ
ฑฑบ          ณaReg, recebido como paramento. Este array deve possuir tantos บฑฑ
ฑฑบ          ณelementos quantos forem o numero de campos do registro no txt.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CARFLeReg(aReg)
Local cReg		:= ""
Local cAux		:= ""
Local cSepar	:= ";"
Local nPos		:= 0
Local nContCpo	:= 0
Local aRet		:= {}
Local nCountSep := 0

cReg := FT_FReadLn()
While !Empty(cReg) .And. nCountSep <= 11
	nCountSep++
	nContCpo++
	nPos := At(cSepar,cReg)
	If nPos == 0
		nPos := Len(cReg) + 1
	Endif
	cAux := Substr(cReg,1,nPos-1)
	cReg := Substr(cReg,nPos+1)
	Do Case
		Case aEstrTxt[nContCpo,2] == "D"
			Aadd(aRet,Ctod(Substr(cAux,1,2) + "/" + Substr(cAux,3,2) + "/" + Substr(cAux,5)))
		Case aEstrTxt[nContCpo,2] == "N"
			Aadd(aRet,Val(StrTran(cAux,",",".")))
		Case aEstrTxt[nContCpo,2] == "C"
			Aadd(aRet,AllTrim(cAux))
	EndCase
Enddo

If !lProcSim
	If aRet[TIPOCONTRINSC] == "D"
		aRet[TIPOCONTRINSC] := "I"
	ElseIf aRet[TIPOCONTRINSC] == "C"
		aRet[TIPOCONTRINSC] := "V"
	EndIf
Else
	aRet[TIPOCONTRINSC] := "I" //"M"
EndIf

Return(aClone(aRet))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCARFFORRET  บAutor  ณMarcello Gabriel    บFecha ณ 01/12/2008  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessa o registro atual do arquivo de contribuintes.        บฑฑ
ฑฑบ          ณVerifica se o contribuinte esta no cadastro de fornecedores e บฑฑ
ฑฑบ          ณse necessario, cria o registro na tabela SFH com a aliquota   บฑฑ
ฑฑบ          ณpara retencao.                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CARFForRet(cCuit,nAlqRet,dInicio,dFim,cContInsc)

SA2->(DbSetOrder(3))
//Verifica se o contribuinte esta no arquivo de fornecedores
cCuit := PadR(cCuit,TamSX3("A2_CGC")[1])
If SA2->(DbSeek(xFilial("SA2") + cCuit))
	//cria-se ou altera-se o registro no arquivo SFH para a "aliquota de risco" para retencao
	While  cCuit==SA2->A2_CGC  .And. !SA2->(EOF())
		/*
		If lProcSim .And. SA2->A2_SITUACA<>"3"
			SA2->(DbSkip())
			Loop
		EndIf
		*/
		If SA2->A2_RETIB == "S"
			If (cAliasSFH)->(DbSeek(SA2->A2_COD + Space(TamSX3("A1_COD")[1]) + SA2->A2_LOJA + cRetencao + cZonaFis + Dtos(dInicio) + Dtos(dFim)))
				SFH->(DbGoto((cAliasSFH)->REGISTRO))
				RecLock("SFH",.F.)
				Replace SFH->FH_PERCIBI	With "S"
				Replace SFH->FH_ISENTO	With "N"
				Replace SFH->FH_APERIB	With "S"
				Replace SFH->FH_INIVIGE	With dInicio
				Replace SFH->FH_FIMVIGE	With dFim
				Replace SFH->FH_TIPO    With cContInsc
			Else
				RecLock("SFH",.T.)
				Replace SFH->FH_FILIAL	With xFilial("SFH")
				Replace SFH->FH_AGENTE	With "S"
				Replace SFH->FH_ZONFIS	With cZonaFis
				Replace SFH->FH_FORNECE	With SA2->A2_COD
				Replace SFH->FH_LOJA	With SA2->A2_LOJA 
				Replace SFH->FH_NOME	With SA2->A2_NOME 
				Replace SFH->FH_IMPOSTO	With cRetencao
				Replace SFH->FH_PERCIBI	With "S"
				Replace SFH->FH_ISENTO	With If(nAlqRet <> 0, "N","S")
				Replace SFH->FH_APERIB	With "S"
				Replace SFH->FH_INIVIGE	With dInicio
				Replace SFH->FH_FIMVIGE	With dFim
				Replace SFH->FH_TIPO    With cContInsc
			Endif
			Replace SFH->FH_ALIQ With nAlqRet
			If SFH->(FieldPos("FH_SITUACA")) > 0
				If lProcSim                                               
					Replace SFH->FH_SITUACA	With "1"//"3"	//cliente de Monotributista   - Tipo do Contribuinte de Regime Simplificado
				Else
					Replace SFH->FH_SITUACA	With "2"	//cliente de risco fiscal
				EndIf        
	        EndIf
			SFH->(MsUnLock())
			
			RecLock("SA2",.F.)
			//Replace SA2->A2_SITUACA	With SIT_RISCO	//fornecedor de risco fiscal
			SA2->(MsUnLock())

			// Atualiza temporario
			If (cAliasFor)->(DbSeek(cCuit+SA2->A2_LOJA))
				RecLock(cAliasFor,.F.)
				If lProcSim
					Replace (cAliasFor)->ESTADO With SIT_PERCEPCAO				
				Else
					Replace (cAliasFor)->ESTADO With SIT_RISCO
				EndIf
				(cAliasFor)->(MsUnLock())
			Endif    
		
		Endif
		SA2->(DbSkip())

	EndDo
Endif
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCARFFORPER  บAutor  ณMarcello Gabriel    บFecha ณ 10/12/2008  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria a aliquota de risco para  "percepcao" dos fornecedores.  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CARFForPer(cCuit,nAlqPer,dInicio,dFim,oDlg)
Local cQuery	:= ""
Local cAliasSA2	:= ""
Local oFonte
Local oPnlCon

If lProcessar
	oFonte := TFont():New("Arial",,,,.T.,,,8,.F.,,,,,,,)
	oPnlCon := TPanel():New(01,01,STR0019 + ".",oDlg,oFonte,,,,RGB(221,221,221),5,30,.F.,.F.)		//"Atualizando a alํquota de percep็ใo dos fornecedores"
		oPnlCon:Align := CONTROL_ALIGN_TOP
		oPnlCon:nHeight := 40
	#IFDEF TOP
		cAliasSA2 := GetNextAlias()
		cQuery := "select A2_COD,A2_LOJA,A2_CGC from " + RetSqlName("SA2")
		cQuery += " where A2_FILIAL = '" + xFilial("SA2") + "'"
		cQuery += " and A2_PERCIB = 'S'"
		/*
		If lProcSim	                   
			cQuery += " and A2_SITUACA ='1'"// '3'"
		EndIf
		*/
		cQuery += " and D_E_L_E_T_=''"
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSA2,.T.,.T.)
	#ELSE
		cQuery += "A2_FILIAL = '" + xFilial("SA2") + "'"
		cQuery += " .And. A2_PERCIB == 'S'"
		/*
		If lProcSim	                   
			cQuery += " and A2_SITUACA = '1'"//'3'"
		EndIf
		*/
		SA2->(DbSetFilter({|| &cQuery},cQuery))
		cAliasSA2 := "SA2"
	#ENDIF
	(cAliasSA2)->(DbGoTop())
	While lProcessar .And. !((cAliasSA2)->(Eof()))
		//cria-se ou altera-se o registro no arquivo SFH para a "aliquota do arquivo" para percepcao
		If (cAliasSFH)->(DbSeek((cAliasSA2)->A2_COD + Space(TamSX3("A1_COD")[1]) + (cAliasSA2)->A2_LOJA + cPercepcao + cZonaFis + Dtos(dInicio) + Dtos(dFim)))
			SFH->(DbGoto((cAliasSFH)->REGISTRO))
			RecLock("SFH",.F.)
			Replace SFH->FH_PERCIBI	With "S"
			Replace SFH->FH_ISENTO	With "N"
			Replace SFH->FH_APERIB	With "S"
			Replace SFH->FH_INIVIGE	With dInicio
			Replace SFH->FH_FIMVIGE	With dFim
			Replace SFH->FH_TIPO    With cContInsc
		Else
			RecLock("SFH",.T.)
			Replace SFH->FH_FILIAL	With xFilial("SFH")
			Replace SFH->FH_AGENTE	With "S"
			Replace SFH->FH_ZONFIS	With cZonaFis
			Replace SFH->FH_FORNECE	With (cAliasSA2)->A2_COD
			Replace SFH->FH_LOJA	With (cAliasSA2)->A2_LOJA
			Replace SFH->FH_NOME	With SA2->A2_NOME
			Replace SFH->FH_IMPOSTO	With cPercepcao
			Replace SFH->FH_PERCIBI	With "S"
			Replace SFH->FH_ISENTO	With If (nAlqPer <> 0,"N","S")
			Replace SFH->FH_APERIB	With "S"
			Replace SFH->FH_INIVIGE	With dInicio
			Replace SFH->FH_FIMVIGE	With dFim
			Replace SFH->FH_TIPO    With cContInsc
		Endif
		If SFH->(FieldPos("FH_SITUACA")) > 0
			If lProcSim                                               
				Replace SFH->FH_SITUACA	With "1" //"3"	//cliente de Monotributista   - Tipo do Contribuinte de Regime Simplificado
			Else
				Replace SFH->FH_SITUACA	With "2"	//cliente de risco fiscal
			EndIf        
        EndIf
		Replace SFH->FH_ALIQ With nAlqPer
		SFH->(MsUnLock())
		If (cAliasFor)->(DbSeek((cAliasSA2)->A2_CGC+(cAliasSA2)->A2_LOJA))
			RecLock(cAliasFor,.F.)
			Replace (cAliasFor)->ESTADO With SIT_PERCEPCAO
			(cAliasFor)->(MsUnLock())
		Endif
		(cAliasSA2)->(DbSkip())
	Enddo
	oPnlCon:cCaption := STR0019 + ".  OK"
	#IFDEF TOP
		DbSelectArea(cAliasSA2)
		DbCloseArea()
	#ELSE
		SA2->(DbClearFilter())
	#ENDIF
Endif
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCARFCLIPER  บAutor  ณMarcello Gabriel    บFecha ณ 01/12/2008  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessa o registro atual do arquivo de contribuintes.        บฑฑ
ฑฑบ          ณVerifica se o contribuinte esta no cadastro de clientes e     บฑฑ
ฑฑบ          ณse necessario, cria o registro na tabela SFH com a aliquota   บฑฑ
ฑฑบ          ณpara "percepcao".                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CARFCliPer(cCuit,nAlqPer,dInicio,dFim,cContInsc)


SA1->(DbSetOrder(3))
//Verifica se o contribuinte esta no arquivo de clientes
cCuit := PadR(cCuit,TamSX3("A1_CGC")[1])
If SA1->(DbSeek(xFilial("SA1") + cCuit))
	While cCuit==SA1->A1_CGC .And. !SA1->(EOF())
		/*
		If lProcSim .And. SA1->A1_SITUACA <> "3"
			SA1->(DbSkip())	
			Loop
		EndIf
		*/
		//cria-se ou altera-se o registro no arquivo SFH para a "aliquota de risco" para percepcao
		If (cAliasSFH)->(DbSeek(Space(TamSX3("A2_COD")[1]) + SA1->A1_COD + SA1->A1_LOJA + cPercepcao + cZonaFis + Dtos(dInicio) + Dtos(dFim)))
			SFH->(DbGoto((cAliasSFH)->REGISTRO))
			RecLock("SFH",.F.)
			Replace SFH->FH_PERCIBI	With "S"
			Replace SFH->FH_ISENTO	With "N"
			Replace SFH->FH_APERIB	With "S"
			Replace SFH->FH_INIVIGE	With dInicio
			Replace SFH->FH_FIMVIGE	With dFim
			Replace SFH->FH_TIPO    With cContInsc
		Else
			RecLock("SFH",.T.)
			Replace SFH->FH_FILIAL	With xFilial("SFH")
			Replace SFH->FH_AGENTE	With "S"
			Replace SFH->FH_ZONFIS	With cZonaFis
			Replace SFH->FH_CLIENTE	With SA1->A1_COD
			Replace SFH->FH_LOJA	With SA1->A1_LOJA
			Replace SFH->FH_NOME	With SA1->A1_NOME
			Replace SFH->FH_IMPOSTO	With cPercepcao
			Replace SFH->FH_PERCIBI	With "S"
			Replace SFH->FH_ISENTO	With "N"
			Replace SFH->FH_APERIB	With "S"
			Replace SFH->FH_INIVIGE	With dInicio
			Replace SFH->FH_FIMVIGE	With dFim
			Replace SFH->FH_TIPO    With cContInsc
		Endif
		Replace SFH->FH_ALIQ With nAlqPer
		If SFH->(FieldPos("FH_SITUACA")) > 0
			If lProcSim                                               
				Replace SFH->FH_SITUACA	With "1"//"3"	//cliente de Monotributista   - Tipo do Contribuinte de Regime Simplificado
			Else
				Replace SFH->FH_SITUACA	With "2"	//cliente de risco fiscal
			EndIf        
        EndIf

		SFH->(MsUnLock())

	//Coloca o cliente como "alto risco" no cadastro de clientes        
		RecLock("SA1",.F.)
		If lProcSim                                               
			Replace SA1->A1_SITUACA	With "1"//"3"	//cliente de Monotributista   - Tipo do Contribuinte de Regime Simplificado
		Else
			Replace SA1->A1_SITUACA	With "2"	//cliente de risco fiscal
		EndIf
		SA1->(MsUnLock())
		
	//Atualiza TRB	
		
		If (cAliasCli)->(DbSeek(cCuit+SA1->A1_LOJA))
			RecLock(cAliasCli,.F.)
			If lProcSIM
				Replace (cAliasCli)->ESTADO With SIT_PERCEPCAO
			Else
				Replace (cAliasCli)->ESTADO With SIT_RISCO
                EndIF
			(cAliasCli)->(MsUnLock())
		Endif    
		
		SA1->(DbSkip())	          		
	
	EndDo
Endif    
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCARFFORCLI  บAutor  ณMarcello Gabriel    บFecha ณ 05/12/2008  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria um arquivo com os fornecedores/clientes que sao conside- บฑฑ
ฑฑบ          ณrados risco fiscal ou de regime simplificado.                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CARFForCli(oDlg,dInicio,dFim,cContInsc)
Local cQuery	:= ""
Local cAliasSA	:= ""
Local lRet		:= .F.
Local aEstr		:= {}
Local oPnlCli
Local oPnlFor
Local oPnlSFH
Local oFonte

Aadd(aEstr,{"NRCUIT","C",TamSX3("A1_CGC")[1]+TamSX3("A1_LOJA")[1],0})
Aadd(aEstr,{"ESTADO","C",1,0})
oFonte := TFont():New("Arial",,,,.T.,,,8,.F.,,,,,,,)
If lProcCli
	//Criacao do arquivo com clientes de risco
	oPnlCli := TPanel():New(01,01,STR0020 + ". " + STR0021 + "...",oDlg,oFonte,,,,RGB(221,221,221),5,5,.F.,.F.)		//"Verifica็ใo dos clientes considerados de alto risco fiscal"###"Aguarde"
		oPnlCli:Align := CONTROL_ALIGN_TOP
		oPnlCli:nHeight := 40
	cAliasCli:= GetNextAlias()
	cArqCli := CriaTrab(Nil,.F.)
	DbCreate(cArqCli,aEstr)
	dbUseArea(.T.,,cArqCli,cAliasCli,.F.,.F.)
	cQuery := ""
	#IFDEF TOP
		cQuery := "Select A1_CGC,A1_LOJA,R_E_C_N_O_ from " + RetSqlName("SA1")
		cQuery += " where A1_FILIAL ='" + xFilial("SA1") + "'"
		cQuery += " and D_E_L_E_T_='' "
		/*
		If lProcSim
			cQuery += " and A1_SITUACA = '" + SIT_PERCEPCAO + "'"	
		Else                                                
			cQuery += " and A1_SITUACA = '" + SIT_RISCO + "'"
		EndIf
		*/
		cAliasSA := GetNextAlias()
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSA,.T.,.T.)
	#ELSE
		cQuery := "A1_FILIAL == '" + xFilial("SA1") + "'"
		/*
		If lProcSim
			cQuery += " .And. A1_SITUACA == '" + SIT_PERCEPCAO + "'"		
		Else
			cQuery += " .And. A1_SITUACA == '" + SIT_RISCO + "'"
		EndIf
		*/
		cAliasSA := "SA1"
		SA1->(DbSetFilter({|| &cQuery},cQuery))
	#ENDIF
	(cAliasSA)->(DbGoTop())
	While !((cAliasSA)->(Eof()))
		RecLock(cAliasCli,.T.)
		Replace (cAliasCli)->NRCUIT	With (cAliasSA)->A1_CGC + (cAliasSA)-> A1_LOJA
		Replace (cAliasCli)->ESTADO	With SIT_NORMAL
		(cAliasCli)->(MsUnLock())
		(cAliasSA)->(DbSkip())
	Enddo
	(cAliasCli)->(DbCommit())
	(cAliasCli)->(DbCreateIndex(cArqCli + OrdBagExt(),"NRCUIT",{|| NRCUIT}))
	#IFDEF TOP
		DbSelectArea(cAliasSA)
		DbCloseArea()
	#ELSE
		SA1->(DbClearFilter())
	#ENDIF
	oPnlCli:cCaption := STR0020 + ".  OK"
Endif
//
//Criacao do arquivo com fornecedores de risco
If lProcFor
	oPnlFor := TPanel():New(01,01,STR0022 + ". " + STR0021 + "...",oDlg,oFonte,,,,RGB(221,221,221),5,5,.F.,.F.)		//"Verifica็ใo dos fornecedores considerados de alto risco fiscal"###Aguarde
		oPnlFor:Align := CONTROL_ALIGN_TOP
		oPnlFor:nHeight := 40
	cAliasFor:= GetNextAlias()
	cArqFor := CriaTrab(Nil,.F.)
	DbCreate(cArqFor,aEstr)
	dbUseArea(.T.,,cArqFor,cAliasFor,.F.,.F.)
	cQuery := ""
	#IFDEF TOP
		cQuery := "Select A2_CGC,A2_COD,A2_LOJA from " + RetSqlName("SA2")
		cQuery += " where A2_FILIAL ='" + xFilial("SA2") + "'"
		cQuery += " and D_E_L_E_T_=''"
		cQuery += " and "
		cQuery += " ("
		If lProcSim
			cQuery += "A2_SITUACA = '" + SIT_PERCEPCAO + "'"		
		Else	
			cQuery += "A2_SITUACA = '" + SIT_RISCO + "'"
		EndIf
		cQuery += " or"
		cQuery += " A2_PERCIB = 'S'"
		cQuery += ")"
		cAliasSA := GetNextAlias()
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSA,.T.,.T.)
	#ELSE
		cAliasSA := "SA2"
		cQuery := "A2_FILIAL == '" + xFilial("SA1") + "'"
		cQuery += " .And."
		cQuery += " ("
		If lProcSIm
			cQuery += "A2_SITUACA == '" + SIT_PERCEPCAO + "'"
		Else
			cQuery += "A2_SITUACA == '" + SIT_RISCO + "'"
		EndIf
		cQuery += " .Or."
		cQuery += " A2_PERCIB = 'S'"
		cQuery += ")"
		SA2->(DbSetFilter({|| &cQuery},cQuery))
	#ENDIF
	(cAliasSA)->(DbGoTop())
	While !((cAliasSA)->(Eof()))
		RecLock(cAliasFor,.T.)
		Replace (cAliasFor)->NRCUIT With (cAliasSA)->A2_CGC+(cAliasSA)->A2_LOJA
		Replace (cAliasFor)->ESTADO With SIT_NORMAL
		(cAliasFor)->(MsUnLock())
		(cAliasSA)->(DbSkip())
	Enddo
	(cAliasFor)->(DbCommit())
	(cAliasFor)->(DbCreateIndex(cArqFor + OrdBagExt(),"NRCUIT",{|| NRCUIT}))
	#IFDEF TOP
		DbSelectArea(cAliasSA)
		DbCloseArea()
	#ELSE
		SA2->(DbClearFilter())
	#ENDIF
	oPnlFor:cCaption := STR0022 + ".  OK"
Endif
//Criacao do arquivo temporario pra verificacao de aliquotas ja existentes
oPnlSFH := TPanel():New(01,01,STR0023 + ". " + STR0021 + "...",oDlg,oFonte,,,,RGB(221,221,221),5,5,.F.,.F.)			//"Preparando o arquivo de Empresas x Zonas fiscais"###Aguarde
	oPnlSFH:Align := CONTROL_ALIGN_TOP
	oPnlSFH:nHeight := 40	
aEstr := {}
Aadd(aEstr,{"FH_FORNECE","C",TamSX3("FH_FORNECE")[1],0})
Aadd(aEstr,{"FH_CLIENTE","C",TamSX3("FH_CLIENTE")[1],0})
Aadd(aEstr,{"FH_LOJA","C",TamSX3("FH_LOJA")[1],0})
Aadd(aEstr,{"FH_IMPOSTO","C",TamSX3("FH_IMPOSTO")[1],0})
Aadd(aEstr,{"FH_ZONFIS","C",TamSX3("FH_ZONFIS")[1],0})
Aadd(aEstr,{"FH_INIVIGE","D",8,0})
Aadd(aEstr,{"FH_FIMVIGE","D",8,0})
Aadd(aEstr,{"FH_TIPO","C",1,0})
Aadd(aEstr,{"FH_SITUACA","C",1,0})
Aadd(aEstr,{"REGISTRO","N",10,0})
cAliasSFH:= GetNextAlias()
cArqSFH := CriaTrab(Nil,.F.)
DbCreate(cArqSFH,aEstr)
dbUseArea(.T.,,cArqSFH,cAliasSFH,.F.,.F.)
cQuery := ""
#IFDEF TOP
	cQuery := "Select FH_FORNECE,FH_CLIENTE,FH_LOJA,FH_IMPOSTO,FH_ZONFIS,FH_INIVIGE,FH_FIMVIGE,FH_TIPO,FH_SITUACA,R_E_C_N_O_ from " + RetSqlName("SFH")
	cQuery += " where FH_FILIAL ='" + xFilial("SFH") + "'"
	cQuery += " and D_E_L_E_T_=''"
	cQuery += " and (FH_IMPOSTO = '" + cRetencao + "'" + " or FH_IMPOSTO = '" + cPercepcao + "')"
	cQuery += " and"
	cQuery += " ("
	cQuery += "("
	cQuery += "FH_INIVIGE = '" + Dtos(dInicio) + "'"
	cQuery += " and FH_FIMVIGE = '" + Dtos(dFim) + "'"
	cQuery += ")"
	cQuery += " or"
	cQuery += " ("
	cQuery += "FH_INIVIGE = ''"
	cQuery += " and FH_FIMVIGE = ''"
	cQuery += ")"
	cQuery += ")"
	cAliasSA := GetNextAlias()
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSA,.T.,.T.)
	TCSetField(cAliasSA,"FH_INIVIGE","D",8,0)
	TCSetField(cAliasSA,"FH_FIMVIGE","D",8,0)
#ELSE
	cAliasSA := "SFH"
	cQuery += "FH_FILIAL ='" + xFilial("SFH") + "'"
	cQuery += " .And. (FH_IMPOSTO = '" + cRetencao + "'" + " .Or. FH_IMPOSTO = '" + cPercepcao + "')"
	cQuery += " .And."
	cQuery += " ("
	cQuery += "("
	cQuery += "Dtos(FH_INIVIGE) = '" + Dtos(dInicio) + "'"
	cQuery += " .And. Dtos(FH_FIMVIGE) = '" + Dtos(dFim) + "'"
	cQuery += ")"
	cQuery += " .Or."
	cQuery += " ("
	cQuery += "Empty(FH_INIVIGE)"
	cQuery += " .And. Empty(FH_FIMVIGE)"
	cQuery += ")"
	cQuery += ")"
	SFH->(DbSetFilter({|| &cQuery},cQuery))
#ENDIF
(cAliasSA)->(DbGoTop())
While !((cAliasSA)->(Eof()))
	RecLock(cAliasSFH,.T.)
	Replace (cAliasSFH)->FH_FORNECE		With (cAliasSA)->FH_FORNECE
	Replace (cAliasSFH)->FH_CLIENTE		With (cAliasSA)->FH_CLIENTE
	Replace (cAliasSFH)->FH_LOJA		With (cAliasSA)->FH_LOJA
	Replace (cAliasSFH)->FH_IMPOSTO		With (cAliasSA)->FH_IMPOSTO
	Replace (cAliasSFH)->FH_ZONFIS		With (cAliasSA)->FH_ZONFIS
	Replace (cAliasSFH)->FH_INIVIGE		With (cAliasSA)->FH_INIVIGE
	Replace (cAliasSFH)->FH_FIMVIGE		With (cAliasSA)->FH_FIMVIGE
	Replace (cAliasSFH)->FH_TIPO        With (cAliasSA)->FH_TIPO
	If SFH->(FieldPos("FH_SITUACA")) > 0
		If lProcSim                                               
			Replace (cAliasSFH)->FH_SITUACA	With "1"//"3"	//cliente de Monotributista   - Tipo do Contribuinte de Regime Simplificado
		Else
			Replace (cAliasSFH)->FH_SITUACA	With "2"	//cliente de risco fiscal
		EndIf        
	EndIf
	#IFDEF TOP
		Replace (cAliasSFH)->REGISTRO	With (cAliasSA)->R_E_C_N_O_
	#ELSE
		Replace (cAliasSFH)->REGISTRO	With (cAliasSA)->(Recno())
	#ENDIF
	(cAliasSFH)->(MsUnLock())
	(cAliasSA)->(DbSkip())
Enddo
(cAliasSFH)->(DbCommit())
(cAliasSFH)->(DbCreateIndex(cArqSFH + OrdBagExt(),"FH_FORNECE+FH_CLIENTE+FH_LOJA+FH_IMPOSTO+FH_ZONFIS+Dtos(FH_INIVIGE)+Dtos(FH_FIMVIGE)",{|| FH_FORNECE+FH_CLIENTE+FH_LOJA+FH_IMPOSTO+FH_ZONFIS+Dtos(FH_INIVIGE)+Dtos(FH_FIMVIGE)}))
#IFDEF TOP
	DbSelectArea(cAliasSA)
	DbCloseArea()
#ELSE
	SFH->(DbClearFilter())
#ENDIF
oPnlSFH:cCaption := STR0023 + ".  OK"
lRet := .T.
If oPnlCli <> Nil
	oPnlCli:Free()
Endif
If oPnlFor <> Nil
	oPnlFor:Free()
Endif
If oPnlSFH <> Nil
	oPnlSFH:Free()
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCARFNORMAIS บAutor  ณMarcello Gabriel    บFecha ณ 08/12/2008  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica os clientes e fornecedores que sairam da condicao de บฑฑ
ฑฑบ          ณ"alto risco fiscal".                                          บฑฑ
ฑฑบ          ณPara esses fornecedores, o campo _SITUACA e alterado para "N".บฑฑ
ฑฑบ          ณA aliquota padrao passa a ser a que esta no arquivos SFF.     บฑฑ
ฑฑบ          ณPara fornecedores que "percebem" IB, e criado um registro no  บฑฑ
ฑฑบ          ณarquivo SFH para que lhe sejam calculado o IB.                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CARFNormais(oDlg)
Local nReg		:= 0
Local nContReg	:= 0
Local nNrReg	:= 0
Local cFilSA	:= ""
Local cFilSFH	:= xFilial("SFH")
Local oMtrCli
Local oMtrFor
Local oPnlCli
Local oPnlFor
Local oPnlMtrCli
Local oPnlMtrFor
Local oFonte

SA1->(DbSetOrder(3))
SA2->(DbSetOrder(3))
oFonte := TFont():New("Arial",,,,.T.,,,8,.F.,,,,,,,)
//Verificando clientes
If lProcCli
	oPnlCli := TPanel():New(01,01,STR0024 + ".",oDlg,oFonte,,,,RGB(221,221,221),5,30,.F.,.F.)	//"Verifica็ใo dos clientes que deixaram a condi็ใo de alto risco fiscal"
		oPnlCli:Align := CONTROL_ALIGN_TOP
		oPnlCli:nHeight := 15
		oPnlMtrClil := TPanel():New(01,01,,oDlg,,,,,RGB(221,221,221),5,30,.F.,.F.)
			oPnlMtrCli:Align := CONTROL_ALIGN_TOP
			oPnlMtrCli:nHeight := 40
			oMtrCli:=TMeter():New(60,05,,100,oPnlMtrCli,150,10,,.T.,,,.T.,,,,,.F.)
				oMtrCli:Align := CONTROL_ALIGN_TOP
				oMtrCli:nHeight := 15
	DbSelectArea(cAliasCli)
	(cAliasCli)->(DbGoTop())
	nNrReg := (cAliasCli)->(RecCount()) + 1
	nContReg := 0
	cFilSA := xFilial("SA1")
	While !((cAliasCli)->(Eof()))
		If (cAliasCli)->ESTADO == SIT_NORMAL
			If SA1->(DbSeek(cFilSA + (cAliasCli)->NRCUIT))
				While !(SA1->(EoF())) .And. (SA1->A1_CGC == (cAliasCli)->NRCUIT) .And. (SA1->A1_FILIAL == cFilSA)
					RecLock("SA1",.F.)
					Replace SA1->A1_SITUACA With SIT_NORMAL
					SA1->(MsUnLock())
					SA1->(DbSkip())
				Enddo
			Endif
		Endif
		nContReg++
		nReg := Int((100 * nContReg) / nNrReg)
		oMtrCli:Set(nReg)
		(cAliasCli)->(DbSkip())
	Enddo
	nContReg++
	nReg := Int((100 * nContReg) / nNrReg)
	oMtrCli:Set(nReg)
Endif
//Verificando fornecedores
If lProcFor
	oPnlFor := TPanel():New(01,01,STR0025 + ".",oDlg,oFonte,,,,RGB(221,221,221),5,30,.F.,.F.)		//"Verifica็ใo dos fornecedores que deixaram a condi็ใo de alto risco fiscal"
		oPnlFor:Align := CONTROL_ALIGN_TOP
		oPnlFor:nHeight := 15
		oPnlMtrFor := TPanel():New(01,01,,oDlg,,,,,RGB(221,221,221),5,30,.F.,.F.)
			oPnlMtrFor:Align := CONTROL_ALIGN_TOP
			oPnlMtrFor:nHeight := 40
			oMtrFor:=TMeter():New(60,05,,100,oPnlMtrFor,150,10,,.T.,,,.T.,,,,,.F.)
				oMtrFor:Align := CONTROL_ALIGN_TOP
				oMtrFor:nHeight := 15
	DbSelectArea(cAliasFor)
	(cAliasFor)->(DbGoTop())
	nNrReg := (cAliasFor)->(RecCount()) + 1
	nContReg := 0
	cFilSA := xFilial("SA2")
	While !((cAliasFor)->(Eof()))
		If (cAliasFor)->ESTADO == SIT_NORMAL
			If SA2->(DbSeek(cFilSA + (cAliasFor)->NRCUIT))
				While !(SA2->(Eof())) .And. (SA2->A2_CGC == (cAliasFor)->NRCUIT) .And. (SA2->A2_FILIAL == cFilSA)
					RecLock("SA2",.F.)
					Replace SA2->A2_SITUACA With SIT_NORMAL
					SA2->(MsUnLock())
					//Se o fornecedor "percebe" IB, cria o registro correspondente no SFH, com aliquota zero, para que seja
					//considerada a aliquota padrao que esta no arquivo SFF.
					If lProcPer
						If SA2->A2_PERCIB == 'S'"
							If (cAliasSFH)->(DbSeek(SA2->A2_COD + Space(TamSX3("A1_COD")[1]) + SA2->A2_LOJA + cPercepcao + cZonaFis + Space(8) + Space(8)))
								SFH->(DbGoto((cAliasSFH)->REGISTRO))
								RecLock("SFH",.F.)
							Else
								RecLock("SFH",.T.)
							Endif
							Replace SFH->FH_FILIAL	With cFilSFH
							Replace SFH->FH_AGENTE	With "S"
							Replace SFH->FH_ZONFIS	With cZonaFis
							Replace SFH->FH_FORNECE	With SA2->A2_COD
							Replace SFH->FH_LOJA	With SA2->A2_LOJA
							Replace SFH->FH_NOME	With SA2->A2_NOME
							Replace SFH->FH_IMPOSTO	With cPercepcao
							Replace SFH->FH_PERCIBI	With "S"
							Replace SFH->FH_ISENTO	With "N"
							Replace SFH->FH_APERIB	With "S"
							Replace SFH->FH_INIVIGE	With Ctod("//")
							Replace SFH->FH_FIMVIGE	With Ctod("//")
							Replace SFH->FH_TIPO    With ""
							Replace SFH->FH_ALIQ 	With 0
							SFH->(MsUnLock())
						Endif
					Endif
					SA2->(DbSkip())
				Enddo
			Endif
		Endif
		nContReg++
		nReg := Int((100 * nContReg) / nNrReg)
		oMtrFor:Set(nReg)
		(cAliasFor)->(DbSkip())
	Enddo
	nContReg++
	nReg := Int((100 * nContReg) / nNrReg)
	oMtrFor:Set(nReg)
Endif
ProcessMessages()
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณGuilherme Santos    บ Data ณ  28/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjuste das Perguntas no SX1                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MATA950                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1()

PutSx1( cPerg,                 ; //-- 01 - X1_GRUPO
	'03',                      ; //-- 02 - X1_ORDEM
	'Tipo Contribuinte',       ; //-- 03 - X1_PERGUNT
	'Tipo Contribuyente?', 	   ; //-- 04 - X1_PERSPA
	'Type Contributor?',  	   ; //-- 05 - X1_PERENG
	'mv_ch3',                  ; //-- 06 - X1_VARIAVL
	'N',                       ; //-- 07 - X1_TIPO
	1,                         ; //-- 08 - X1_TAMANHO
	0,                         ; //-- 09 - X1_DECIMAL
	0,                         ; //-- 10 - X1_PRESEL
	'C',                       ; //-- 11 - X1_GSC
	'',                        ; //-- 12 - X1_VALID
	'',                        ; //-- 13 - X1_F3
	'',                        ; //-- 14 - X1_GRPSXG
	'',                        ; //-- 15 - X1_PYME
	'mv_par03',                ; //-- 16 - X1_VAR01
	'Risco',                   ; //-- 17 - X1_DEF01
	'Riesgo',                  ; //-- 18 - X1_DEFSPA1
	'Risk',                    ; //-- 19 - X1_DEFENG1
	'',                        ; //-- 20 - X1_CNT01
	'Simplificado',            ; //-- 21 - X1_DEF02
	'Simplificado',            ; //-- 22 - X1_DEFSPA2
	'Simplified',              ; //-- 23 - X1_DEFENG2
	'',                        ; //-- 24 - X1_DEF03
	'',                        ; //-- 25 - X1_DEFSPA3
	'',                        ; //-- 26 - X1_DEFENG3
	'',                        ; //-- 27 - X1_DEF04
	'',                        ; //-- 28 - X1_DEFSPA4
	'',                        ; //-- 29 - X1_DEFENG4
	'',                        ; //-- 30 - X1_DEF05
	'',                        ; //-- 31 - X1_DEFSPA5
	'',                        ; //-- 32 - X1_DEFENG5
	'',                        ; //-- 33 - HelpPor
	'',                        ; //-- 34 - HelpSpa
	'',                        ; //-- 35 - HelpEng
	'')                         //-- 36 - X1_HELP
PutSX1Help("P."+cPerg+"03.",{"Define se se importarใo os dados","Contribuinte de Risco ou Simplificado"},{" "},{"Define si se importarแn los datos de","Contribuyentes del Riesco o Simplificado."},.T.)
Return
