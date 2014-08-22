#INCLUDE "MOVBANC.CH"
#include "rwmake.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MOVBANC ³ Autor ³MS						 ³ Data ³ 31/05/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ComproBante de Pago (Movimiento Bancario COBRAR/PAGAR)      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³PROGRAMADOR³ DATA   ³          MOTIVO DA ALTERACAO                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄ     ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MOVBANC()

Local _cAlias	 := "SE5"
                                               

Private _cPergRela := "MOVBANC   "
Private _oCompFina                                                                                                     
Private oFont08
Private oCouNew08N
Private oCouNew08S
Private oCouNew10
Private oCouNew10N
Private oCouNew14
Private oCouNew16

Private oArial08N
Private oArial10
Private oArial10N
Private _cLogoRela := "LGRL" + SM0->m0_codigo + ".BMP"
Private lin  := 0
Private lFirstPage
Private _cTituRela := ""
Private _aAreaCTS  := {}
Private _cContSupe := ""
Private _nTotaAtiv := 0
Private _nTotaPass := 0

ValidPerg(_cPergRela)

Pergunte(_cPergRela,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                            ³
//³ mv_par01                            // De Comprobante           ³
//³ mv_par02                            // Hasta Comprobante        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cTituRela  := "Movimientos bancarios desde " + mv_par01 + " Hasta " + mv_par02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SE5")
RptStatus({|| AvaliaCompr()},_cTituRela)
Return


Static Function AvaliaCompr()
_aDadoComp := {}

BeginSql Alias 'TR1'
	%noparser%
	SELECT 
		SE5.E5_NUMMOV AS NUMMOV,SE5.E5_HISTOR AS HISTOR, SE5.E5_TXMOEDA AS TXMOEDA, SE5.E5_MOEDA AS MOEDA, SE5.E5_SITUACA AS SITUA, 
		CASE WHEN SE5.E5_RECPAG = 'P' THEN 'PAGAR' 
			 WHEN SE5.E5_RECPAG = 'R' THEN 'COBRAR' END AS TIPODOCT,			 
		SE5.E5_BANCO AS BANCO, SA6.A6_CONTA AS CTABANCO, SA6.A6_NOME AS NOMEBANC, SE5.E5_DEBITO AS DEBITO,CT1.CT1_DESC01 AS DESCCONT,
		SE5.E5_DTDISPO AS DATAMOVI,SE5.E5_NUMCHEQ AS NUMCHEQ, SE5.E5_VALOR AS VALOR 			 
	FROM %table:SE5% SE5, %table:SA6% SA6, %table:CT1% CT1  
	WHERE SE5.E5_NUMMOV    >= %exp:mv_par01% AND SE5.E5_NUMMOV  <= %exp:mv_par02% 
		AND SE5.E5_DTDISPO >= %exp:mv_par03% AND SE5.E5_DTDISPO <= %exp:mv_par04%
		AND SE5.E5_BANCO   >= %exp:mv_par05% AND SE5.E5_BANCO   <= %exp:mv_par06%
		AND SE5.E5_BANCO   = SA6.A6_COD
		AND SE5.E5_AGENCIA = SA6.A6_AGENCIA
		AND SE5.E5_CONTA   =  SA6.A6_NUMCON
		AND CT1.CT1_CONTA  = SE5.E5_DEBITO
		AND SE5.E5_FILIAL  = %xfilial:SE5%
		AND CT1.CT1_FILIAL = %xfilial:CT1%
		AND SA6.A6_FILIAL  = %xfilial:SA6%
		AND SE5.%notdel% AND SA6.%notdel% AND CT1.%notdel%  
	ORDER BY SE5.E5_NUMMOV
EndSql
_aQuryRece := GetLastQuery()
MemoWrite("cQuryRece.SQL",_aQuryRece[2])
		
dbSelectARea("TR1")
dbGoTop()
While .Not. TR1->(Eof())
	aAdd(_aDadoComp,{OemToAnsi("Mov. Num") + TR1->nummov,;
	OemToAnsi("Fecha") + DTOC(dDataBase),OemToAnsi("Historial") + TR1->histor,OemToAnsi("Moneda") + TR1->moeda,;
	OemToAnsi("Tasa") + Transform(TR1->txmoeda,"@E 99,999.9999"),;
	TR1->ctabanco + " " + TR1->nomebanc,TR1->debito + " "  + TR1->desccont,Transform(IIf(TR1->moeda == "02",TR1->valor,0),"@E 9,999,999.99"),;
	TR1->banco,DTOC(STOD(TR1->datamovi)),TR1->numcheq,;
	Transform(IIf(TR1->moeda == "02",0,TR1->valor),"@E 9,999,999.99"),Transform(IIf(TR1->moeda == "01",0,TR1->valor),"@E 9,999,999.99"),;
	Transform(TR1->valor,"@E 9,999,999.99"),OemToAnsi("Tipo doc") + TR1->tipodoct,Transform(IIf(TR1->moeda == "01",TR1->valor,0),"@E 9,999,999.99"),;
	TR1->situa})
	TR1->(dbSkip())
 
End	

ConfigImpr()
ImprimeCompr()

_oCompFina:Preview()  				// Visualiza antes de imprimir
TR1->(dbCloseArea())
Return

Static Function ValidPerg
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

Local _cAlias := Alias()
Local aRegs := {}
Local _nContItem,_nContCamp

dbSelectArea("SX1")
dbSetOrder(1)
_cPergRela := PADR(_cPergRela,10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                            ³
//³ mv_par01                            // De Comprobante           ³
//³ mv_par02                            // Hasta Comprobante        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Grupo/Ordem/Pergunta/PerSPA/PerEng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Defspa1/Defeng1/Cnt01/Var02/Def02/Defspa2/Defeng2/Cnt02/Var03/Def03/Defspa3/Defeng3/Cnt03/Var04/Def04/Defspa4/Defeng4/Cnt04/Var05/Def05/Defspa5/Defeng5/Cnt05/f3/grpsxg
aAdd(aRegs,{_cPergRela,"01","De Documento  ?" ,"Desde Documento  ? ","De Documento ? ","mv_ch1","C",10,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","",""})
aAdd(aRegs,{_cPergRela,"02","Até Documento  ?","Hasta Documento ? ","Hasta Documento ? ","mv_ch2","C",10,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","",""})
aAdd(aRegs,{_cPergRela,"03","De Data  ?" ,"Desde Fecha  ? ","Desde Fecha ? ","mv_ch3","D",8,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","",""})
aAdd(aRegs,{_cPergRela,"04","Até Data  ?","Hasta Fecha ? ","Hasta Fecha ? ","mv_ch4","D",8,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","",""})
aAdd(aRegs,{_cPergRela,"05","De Banco  ?" ,"Desde Banco  ? ","Desde Banco ? ","mv_ch5","C",3,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SA6_MB","","",""})
aAdd(aRegs,{_cPergRela,"06","Até Banco  ?","Hasta Banco ? ","Hasta Banco ? ","mv_ch6","C",3,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SA6_MBd","","",""})

For _nContItem :=1 to Len(aRegs)
	If ! dbSeek(_cPergRela+aRegs[_nContItem,2])
		RecLock("SX1",.T.)
		For _nContCamp :=1 to FCount()
			If _nContCamp <= Len(aRegs[_nContItem])
				FieldPut(_nContCamp,aRegs[_nContItem,_nContCamp])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_cAlias)
Return(.T.)

Static Function ConfigImpr()
Local i 	:= 1
Local x 	:= 0
Local lin 	:= 0

lLandScape := .T.

oFont08		:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
oCouNew08N	:= TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)		// Negrito
oCouNew08S	:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.T.)		// SubLinhado
oCouNew10	:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
oCouNew10N	:= TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)     // Negrito
oCouNew14	:= TFont():New("Courier New",14,14,,.T.,,,,.T.,.F.)
oCouNew16	:= TFont():New("Courier New",16,16,,.F.,,,,.T.,.F.)
oArial08N	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
oArial10	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oArial10N	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)

_oCompFina:= TMSPrinter():New(_cTituRela)
_oCompFina:SetPortrait()
Return

Static Function ImprimeCompr()
_oCompFina:Setup() // para configurar impressora

For _nContItem := 1 to Len(_aDadoComp)		
	_oCompFina:EndPage()
	aEmpresa 	:= { "", "" }
	nTamLin	:= 3000
	nFont14	:= 28
	nFont10 := 20
	cCGCTxt 	:= ""
		
	nTamLin := 2350

	_oCompFina:StartPage()
	_oCompFina:Box(075,030,250,nTamLin )
	lin := 85
	_oCompFina:Say(lin,050,_aDadoComp[_nContItem,1]+IIf(_aDadoComp[_nContItem,17] == "C"," ANULADO ",""),oCouNew10)
	_oCompFina:Say(lin,(nTamLin - 500),_aDadoComp[_nContItem,2],oCouNew10 )
	lin += 60
	_oCompFina:Say(lin,050,_aDadoComp[_nContItem,3],oCouNew10)
	_oCompFina:Say(lin,(nTamLin - 500),_aDadoComp[_nContItem,4],oCouNew10 )	
	lin += 60
	_oCompFina:Say(lin,050,_aDadoComp[_nContItem,15],oCouNew10)
// PS 01.08.06
	_oCompFina:Say(lin, 0400, AllTrim( SM0->M0_NOMECOM ), oCouNew10)
//	
	_oCompFina:Say(lin,(nTamLin - 500),_aDadoComp[_nContItem,5],oCouNew10)
	lin += 150  
	_oCompFina:Say(lin,0050,IIf(Substr(_aDadoComp[_nContItem,15],6,1) == "P","D ","H ") + OemToAnsi(STR0007),oCouNew10)
	_oCompFina:Say(lin,1680,OemToAnsi(STR0008),oCouNew10)
	_oCompFina:Say(lin,2080,OemToAnsi(STR0009),oCouNew10)	
	lin += 60	
	_oCompFina:Say(lin,050,_aDadoComp[_nContItem,6],oCouNew10)
	_oCompFina:Say(lin,1550,_aDadoComp[_nContItem,16],oCouNew10)	
	_oCompFina:Say(lin,2000,_aDadoComp[_nContItem,8],oCouNew10)	
	lin += 60
	_oCompFina:Line(lin,030,lin,nTamLin )   	// linha horizontal
	lin += 80                                    
	_oCompFina:Say(lin,050,IIf(Substr(_aDadoComp[_nContItem,15],6,1) == "P","H ","D ") + OemToAnsi(STR0010),oCouNew10)
	_oCompFina:Say(lin,1680,OemToAnsi(STR0008),oCouNew10)
	_oCompFina:Say(lin,2080,OemToAnsi(STR0009),oCouNew10)	
    lin += 60
	_oCompFina:Say(lin,050,_aDadoComp[_nContItem,7],oCouNew10)
	_oCompFina:Say(lin,1550,_aDadoComp[_nContItem,16],oCouNew10)	
	_oCompFina:Say(lin,2000,_aDadoComp[_nContItem,8],oCouNew10)	
	lin += 80		
	_oCompFina:Line(lin,030,lin,nTamLin )   	// linha horizontal
	lin += 100
	_oCompFina:Say(lin,0050,OemToAnsi(STR0011),oCouNew10)
	_oCompFina:Say(lin,250,OemToAnsi(STR0012),oCouNew10)
	_oCompFina:Say(lin,1500,OemToAnsi(STR0013),oCouNew10)
	_oCompFina:Say(lin,2080,OemToAnsi(STR0014),oCouNew10)	
	lin += 60 	
	_oCompFina:Say(lin,050,_aDadoComp[_nContItem,9],oCouNew10)
	_oCompFina:Say(lin,250,_aDadoComp[_nContItem,10],oCouNew10)	
	_oCompFina:Say(lin,1500,_aDadoComp[_nContItem,11],oCouNew10)	
	_oCompFina:Say(lin,2000,_aDadoComp[_nContItem,14],oCouNew10)	
	lin += 465	
	_oCompFina:Line(lin,030,lin,nTamLin )   	// linha horizontal
	lin +=  60	
	_oCompFina:Say(lin,1550,_aDadoComp[_nContItem,12],oCouNew10)
	_oCompFina:Say(lin,2000,_aDadoComp[_nContItem,13],oCouNew10)	
	lin += 60		
	_oCompFina:Line(lin,030,lin,nTamLin )   	// linha horizontal
	lin += 100
	_oCompFina:Say(lin,050,OemToAnsi(STR0015),oCouNew10N)
	_oCompFina:Say(lin,1250,OemToAnsi(STR0016),oCouNew10N)
	lin += 80
Next
Return