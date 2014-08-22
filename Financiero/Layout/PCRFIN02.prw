#include "rwmake.ch"
#DEFINE DETAILBOTTOM 2550 //2050

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCRFIN02  �Autor  �Microsiga           �Fecha �  03/18/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Layout de ordenes de pago.                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION PCRFIN02(cDesde,cHasta)

LOCAL cPerg			:= PadR("PCRFIN02",10)
LOCAL aArea			:= GetArea()
LOCAL aAreaSE2		:= SE2->(GetArea())

PRIVATE lPrinted   	:= .F.	,;
nPesopal   	:= 0			,;
cMon       	:= Space( 0 )	,;
aExtenso1	:= {}			,;
aExtenso2   := {}			,;
nCotiza    	:= 0			,;
nLineSer   	:= 0

PRIVATE aCHLis 		:= {} //Array con cheques para controlar desborde de cantidad de items - Ariel - 09/09/02
PRIVATE nCHAdLis 	:= 0 // Cantidad de items que no son cheques para decidir si genera lista o no - Ariel - 09/09/02
PRIVATE nCHValor1 	:= 0 // Importe de la lista de cheques en pesos.  - Ariel - 09/09/02
PRIVATE nCHValor2 	:= 0 // Importe de la lista de cheques en dolares. - Ariel - 09/09/02

If !Empty(cDesde)
	mv_par01	:= cDesde
	mv_par02	:= cHasta
	RptStatus( { || SelectComp() } )
Else
	ValidPerg(cPerg)
	
	If Pergunte( cPerg, .t. )
		RptStatus( { || SelectComp() } )
	EndIf
EndIf

RestArea(aAreaSE2)
RestArea(aArea)

Return nil

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION SelectComp()

PRIVATE nLine   := 0			, ;
aPedBloq 		:= Array( 0 )

PRIVATE oPrn  := TMSPrinter():New(), ;
oFont    := TFont():New( "Arial"            ,, 10,, .f.,,,,    , .f. ), ;
oFont3   := TFont():New( "Arial"            ,, 12,, .t.,,,,    , .f. ), ;
oFont5   := TFont():New( "Arial"            ,, 10,, .t.,,,,    , .f. ), ;
oFont8   := TFont():New( "Arial"            ,,  8,, .f.,,,,    , .f. ), ;
oFont8b  := TFont():New( "Arial"            ,,  8,, .t.,,,, .t., .f. ), ;
oFont8s  := TFont():New( "Courier New"      ,,  8,, .f.,,,,    , .f. ), ;   //SERGIO -> PARA IMPRIMIR CORRECTAMENTE LAS COLUMNAS
oFont12b := TFont():New( "Times New Roman"  ,, 12,, .t.,,,,    , .f. ), ;
oFont12  := TFont():New( "Times New Roman"  ,, 12,, .f.,,,,    , .f. ), ;
oFont14b := TFont():New( "Times New Roman"  ,, 14,, .t.,,,,    , .f. ), ;
oFont14  := TFont():New( "Times New Roman"  ,, 14,, .f.,,,,    , .f. ), ;
oFont20  := TFont():New( "Times New Roman"  ,, 20,, .t.,,,,    , .f. ), ;
oFont18b := TFont():New( "Times New Roman"  ,, 18,, .t.,,,,    , .f. ), ;
oFont18  := TFont():New( "Times New Roman"  ,, 18,, .f.,,,,    , .f. ), ;
oFont18i := TFont():New( "Times New Roman"  ,, 18,, .f.,,,, .t., .f. ), ;
oFont11  := TFont():New( "Times New Roman"  ,, 18,, .t.,,,,    , .t. ), ;
oFont6   := TFont():New( "HAETTENSCHWEILLER",, 10,, .t.,,,,    , .f. ), ;
oFont30  := TFont():New( "Arial	"		    ,, 12,, .t.,,,,    , .f. ), ;
oFont31  := TFont():New( "Arial"            ,,  8,, .t.,,,,    , .f. )

DbSelectArea( "SA2" )
DbSetOrder( 1 )
DbSelectArea( "SE2" )
DbSetOrder( 1 )
DbSelectArea( "SA6" )
DbSetOrder( 1 )
DbSelectArea( "SED" )
DbSetOrder( 1 )
DbSelectArea( "SYA" )
DbSetOrder( 1 )
DbSelectArea( "SEK" )
DbSetOrder( 1 )

DbSeek( xFilial("SEK") + mv_par01, .t. )

SetRegua( ( Val( mv_par02 ) - Val( mv_par01 ) ) + 1 )

DbEval( { || PrintComp(), IncRegua() },, { || SEK->EK_FILIAL == xFilial("SEK") .AND. SEK->EK_ORDPAGO <= mv_par02 } )

//If mv_par04 = 1
oPrn:Setup()
oPrn:PreView()
//Else
//	oPrn:Print()
//EndIf

Ms_Flush()

Return

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PrintComp()

PRIVATE cProvincia := Space( 0 ), ;
cProvCMS  := "", ;
cSitIVA   := "", ;
aDriver   := ReadDriver(), ;
nTotVal1  := 0, ;
nTotVal2  := 0, ;
nLine     := 0, ;
nImpComp  := 0, ;
nSalComp1 := 0, ;
nSalComp2 := 0, ;
nPagoAnt1 := 0, ;
nPagoAnt2 := 0, ;
cMoneda   := Space( 0 )

DbSelectArea( "SA2" )
DbSeek( xFilial( "SA2" ) + SEK->EK_FORNECE + SEK->EK_LOJA )

DbSelectArea( "SYA" )
DbSeek( xFilial( "SYA" ) + SA2->A2_PAIS )

DbSelectArea( "SEK" )

If !EMPTY( Tabela( "12", SA2->A2_EST )  )
	cProvincia := Tabela( "12", SA2->A2_EST )
Else
	MsgStop( "En el Proveedor " + SA2->A2_COD + " " + SA2->A2_LOJA +",  se encuentra vacio el campo PROVINCIA", "Verifique" )
EndIf

cProvCMS   := "Buenos Aires"

If !EMPTY( SA2->A2_TIPO )
	cSitIVA    := Tabela( "SF", SA2->A2_TIPO )
Else // If SA2->A2_COD <> "000463"
	MsgStop( "En el Proveedor " + SA2->A2_COD + " " + SA2->A2_LOJA +",  se encuentra vacio el campo TIPO", "Verifique" )
EndIf


aCHLis := {} //Array con cheques para controlar desborde de cantidad de items - Ariel - 09/09/02
nCHAdLis := 0 // Cantidad de items que no son cheques para decidir si genera lista o no - Ariel - 09/09/02
nCHValor1 := 0 // Importe de la lista de cheques en pesos.  - Ariel - 09/09/02
nCHValor2 := 0 // Importe de la lista de cheques en dolares. - Ariel - 09/09/02

PrintHead("R")
PrintItem()
PrintFoot("R")

Return nil

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PrintHead(cPagTipo)

If !lPrinted
	lPrinted := .t.
Else
	oPrn:StartPage()
EndIf

nLine := 50

oPrn:Say( nLine, 0100, " ", oFont, 100 )

If !Empty( GetNewPar( "MV_DIRLOGO" , "" ) )
	If File( AllTrim( GetMV( "MV_DIRLOGO" ) ) )
		oPrn:Box( nLine, 0050, nLine + 470, 2300 )
		nLine += 10
		oPrn:SayBitmap( nLine, 0100, AllTrim( GetMV( "MV_DIRLOGO" ) ) , 350, 200 )
		nLine += 10
		oPrn:Box( nLine, 1100, nLine + 120, 1250 )
		oPrn:Say( nLine +  20, 1155, "X", oFont20, 100 )
		
		nLine += 240
		oPrn:Say( nLine , 0100, "SUCESORES DE DOMINGO RESTA Y CIA S.A.", oFont30, 100 )
		oPrn:Say( nLine + 060, 0100, AllTrim( SM0->M0_ENDCOB )  + " - " +  AllTrim( SM0->M0_CIDCOB ), oFont31, 100 )
		oPrn:Say( nLine + 100, 0100, "(" + AllTrim( SM0->M0_CEPCOB )+ ") " + " - Buenos Aires -  " + "Tel " + SM0->M0_TEL, oFont31, 100 )
		oPrn:Say( nLine + 140, 0100, "C.U.I.T.: " + SUBSTR(AllTrim( SM0->M0_CGC ),1,2)+"-"+ SUBSTR(AllTrim( SM0->M0_CGC ),3,8)+"-"+SUBSTR(AllTrim( SM0->M0_CGC ),11,8) + "-" + "Responsable Inscripto" , oFont31, 100 )
		nLine -= 240
	Else
		nLine += 10
	EndIf
Else
	/*oPrn:Box( nLine, 0050, nLine + 470, 2300 )
	nLine += 10
	oPrn:Box( nLine, 1100, nLine + 120, 1250 )
	oPrn:Say( nLine +  20, 1160, "X", oFont20, 100 )
	oPrn:Say( nLine +  20, 0100, AllTrim( SM0->M0_NOMECOM ), oFont30, 100 )
	oPrn:Say( nLine + 060, 0100, AllTrim( "Av. Cordoba 1345 7mo. Piso" ) + " - " + AllTrim( "Capital Federal" ), oFont31, 100 )
	oPrn:Say( nLine + 100, 0100, "(" +  AllTrim("C1055AAD") + ") " + "Buenos Aires" + " - Tel.: 4815-2122", oFont31, 100 )
	oPrn:Say( nLine + 140, 0100, "C.U.I.T.: " + AllTrim( SM0->M0_CGC ), oFont31, 100 )*/
EndIf
nLine += 40

//oPrn:Say( nLine, 1650,  SEK->EK_ORDPAGO, oFont12b, 100 )
nLine += 100

oPrn:Say( nLine, 1650, "COMPROBANTE", oFont8B, 100 )
oPrn:Say( nLine, 2100, "FECHA", oFont8B, 100 )
nLine += 30

oPrn:Box( nLine, 1550, nLine + 100, 1950 )
oPrn:Box( nLine, 2050, nLine + 100, 2270 )
//nLine += 30

oPrn:Say( nLine, 1600, "ORDEN DE PAGO", oFont30, 100 )
oPrn:Say( nLine+50, 1650,  SEK->EK_ORDPAGO, oFont12b, 100 )
oPrn:Say( nLine+30, 2080, DToC( SEK->EK_DTDIGIT ), oFont12b, 100 )
nLine += 100

If SEK->EK_CANCEL
	oPrn:Say( nLine, 1600, "*** A N U L A D O *** ", oFont14b, 100 )
EndIf

If cPagTipo = "L"
	nLine += 60
	oPrn:Say( nLine, 1590, "DETALLE DE CHEQUES", oFont14b, 100 )
	nLine += 130
Else
	nLine += 190
EndIf

oPrn:Say( nLine, 0100, "Beneficiario:   ", oFont, 100 )
oPrn:Say( nLine, 0330, AllTrim( SA2->A2_NOME ) + " (" + AllTrim( SA2->A2_COD ) + ")", oFont, 100 )
nLine += 50

oPrn:Say( nLine, 0330, "Domicilio: " + AllTrim( SA2->A2_END ), oFont, 100 )
nLine += 50

If SA2->A2_TIPO != "E"
	If !Empty( cProvincia )
		oPrn:Say( nLine, 0330, "Localidad: " + Alltrim( SA2->A2_MUN ) + " - " + cProvincia, oFont, 100 )
	Else
		oPrn:Say( nLine, 0330, "Localidad: " + Alltrim( SA2->A2_MUN ), oFont, 100 )
	EndIf
Else
	oPrn:Say( nLine, 0330, "   Pais: " + AllTrim( SYA->YA_DESCR ) + "   C. Postal: " + AllTrim( SA2->A2_CEP ), oFont, 100 )
EndIf

nLine += 50

oPrn:Say( nLine, 0330, "C.U.I.T.:  " + AllTrim( SA2->A2_CGC ) + " - I.V.A.: " + cSitIVA, oFont, 100 )

nLine += 50
nPesopal := nLine
nLine += 20
nLineSer := nLine
nLine += 50

If cPagTipo != "L"
	oPrn:Box( nLine, 0050, nLine + 50, 1125 )
	oPrn:Box( nLine, 1125, nLine + 50, 2300 )
	nLine += 5
	oPrn:Say( nLine, 0100, "Aplicado al pago de los comprobantes", oFont5, 100 )
	oPrn:Say( nLine, 1175, "Valores Entregados", oFont5, 100 )
Else
	oPrn:Box( nLine, 0050, nLine + 50, 2300 )
	nLine += 5
	oPrn:Say( nLine, 0100, "Detalle de Cheques de la Orden de Pago " + SEK->EK_ORDPAGO, oFont5, 100 )
EndIf

nLine += 50

If cPagTipo != "L"
	oPrn:Box( nLine, 0050, nLine + 50, 0275 ) //COMPROBANTE
	oPrn:Box( nLine, 0275, nLine + 50, 0450 ) //EMISION
	oPrn:Box( nLine, 0450, nLine + 50, 0625 ) //VENCIMIENTO
	oPrn:Box( nLine, 0625, nLine + 50, 0875 ) //IMPORTE ORIGINAL
	oPrn:Box( nLine, 0875, nLine + 50, 1125 ) //IMPORTE APLICADO
	oPrn:Box( nLine, 1125, nLine + 50, 1475 ) //BANCO
	oPrn:Box( nLine, 1475, nLine + 50, 1650 ) //VENCIMIENTO
	oPrn:Box( nLine, 1650, nLine + 50, 1850 ) //CUENTA
	oPrn:Box( nLine, 1850, nLine + 50, 2050 ) //CHEQUE
	oPrn:Box( nLine, 2050, nLine + 50, 2300 ) //IMPORTE
	nLine += 5
	
	oPrn:Say( nLine, 0055, "Comprobante", oFont8b, 100 )
	oPrn:Say( nLine, 0280, "Emision", oFont8b, 100 )
	oPrn:Say( nLine, 0455, "Vencto.", oFont8b, 100 )
	oPrn:Say( nLine, 0630, "Importe Orig.", oFont8b, 100 )
	oPrn:Say( nLine, 0880, "Importe Aplic.", oFont8b, 100 )
	oPrn:Say( nLine, 1130, "Banco", oFont8b, 100 )
	oPrn:Say( nLine, 1480, "Vencto.", oFont8b, 100 )
	oPrn:Say( nLine, 1655, "Cuenta", oFont8b, 100 )
	oPrn:Say( nLine, 1855, "Cheque", oFont8b, 100 )
	oPrn:Say( nLine, 2055, "Importe", oFont8b, 100 )
Else
	oPrn:Box( nLine, 0050, nLine + 50, 0400 ) //BANCO
	oPrn:Box( nLine, 0380, nLine + 50, 0555 ) //VENCIMIENTO
	oPrn:Box( nLine, 0555, nLine + 50, 0755 ) //CUENTA
	oPrn:Box( nLine, 0745, nLine + 50, 0945 ) //CHEQUE
	oPrn:Box( nLine, 0945, nLine + 50, 1150 ) //IMPORTE
	oPrn:Box( nLine, 1150, nLine + 50, 1475 ) //BANCO
	oPrn:Box( nLine, 1475, nLine + 50, 1650 ) //VENCIMIENTO
	oPrn:Box( nLine, 1650, nLine + 50, 1850 ) //CUENTA
	oPrn:Box( nLine, 1850, nLine + 50, 2050 ) //CHEQUE
	oPrn:Box( nLine, 2050, nLine + 50, 2300 ) //IMPORTE
	nLine += 5
	
	oPrn:Say( nLine, 0055, "Banco", oFont8b, 100 )
	oPrn:Say( nLine, 0395, "Vencto.", oFont8b, 100 )
	oPrn:Say( nLine, 0570, "Cuenta", oFont8b, 100 )
	oPrn:Say( nLine, 0750, "Cheque", oFont8b, 100 )
	oPrn:Say( nLine, 0960, "Importe", oFont8b, 100 )
	oPrn:Say( nLine, 1155, "Banco", oFont8b, 100 )
	oPrn:Say( nLine, 1480, "Vencto.", oFont8b, 100 )
	oPrn:Say( nLine, 1655, "Cuenta", oFont8b, 100 )
	oPrn:Say( nLine, 1855, "Cheque", oFont8b, 100 )
	oPrn:Say( nLine, 2055, "Importe", oFont8b, 100 )
EndIf

nLine += 100

Return NIL

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PrintItem( cPagTipo )

LOCAL cNroRec    := SEK->EK_FILIAL + SEK->EK_ORDPAGO, ;
nRecSEK      := RecNo(), ;
nLeftPanel    := nLine, ;
lHistSer         := .f., ;
nFactu           := 0, ;
cHistoryOp   := Space(0) //Sergio
cDescon  := Space(0)
ntipoc := 1

oPrn:Box( nLine, 0050, nLine + 1500, 1125 ) //900
oPrn:Box( nLine, 1125, nLine + 1500, 2300 ) //900

WHILE ( SEK->EK_FILIAL + SEK->EK_ORDPAGO ) == cNroRec
	
	If SEK->EK_TIPODOC == "TB"
		
		SE2->(dbClearFilter())
		SE2->(dbSeek( xFilial("SE2") + SEK->EK_PREFIXO + SEK->EK_NUM + SEK->EK_PARCELA + SEK->EK_TIPO + SEK->EK_FORNECE + SEK->EK_LOJA, .F. ))
		
		If alltrim(SEK->EK_TIPO) == "NF" .and. SEK->EK_MOEDA == "2"
			ntipoc := EK_TXMOE02//(SEK->EK_VLMOED1/SEK->EK_VALOR)
		ElseIf alltrim(SEK->EK_TIPO) == "NF" .and. SEK->EK_MOEDA == "3"
			ntipoc := EK_TXMOE03
		ElseIf alltrim(SEK->EK_TIPO) == "NF" .and. SEK->EK_MOEDA == "4"
			ntipoc := EK_TXMOE04
		Endif
		
		//Sergio
		If SE2->E2_TIPO $ "NF -FT " .AND. ALLTRIM( SE2->E2_ORIGEM ) == "FINA050"
			If nFactu == 0 .AND. !EMPTY( SE2->E2_HIST )
				cHistoryOp := UPPER( ALLTRIM( SE2->E2_HIST ) )
				nFactu     := nFactu + 1
				lHistSer   := .t.
			Else
				lHistSer := .f.
			EndIf
		EndIf
		
		oPrn:Say(nLeftPanel, 0055, Left( SEK->EK_NUM, 4 ) + "-" + Right( SEK->EK_NUM, 8 ), oFont8, 100 )
		oPrn:Say(nLeftPanel, 0285, DToC( SE2->E2_EMISSAO ), oFont8, 100 )
		oPrn:Say(nLeftPanel, 0455, DToC( SEK->EK_VENCTO ), oFont8, 100 )
		oPrn:Say(nLeftPanel, 0610, PADL( AllTrim( TransForm( (SE2->E2_VALOR*TraeSigno(SE2->E2_TIPO)),PesqPict("SEK","EK_VALOR"))),15," "),oFont8s,100)		
		oPrn:Say(nLeftPanel, 0830, PADL( Iif(SE2->E2_MOEDA == 1," $ "," U$S")+AllTrim( TransForm( (SEK->EK_VALOR*TraeSigno(SE2->E2_TIPO)),PesqPict("SEK","EK_VALOR"))),13," "),oFont8s,100)
		
		If lHistser
			SED->( dbSeek( xFilial( "SED" ) + SE2->E2_NATUREZ , .F. ) )
			cDescon := ALLTRIM(SED->ED_CONTA)
			oPrn:Say(nLineSer,0100, "Historial: " + cHistoryOp+" Cuenta Contable "+cDescon,oFont8,100)
		EndIf
		
		nLeftPanel += 50
		
		nImpComp := nImpComp + SE2->E2_VALOR
		
		If SE2->E2_MOEDA == 2
			nSalComp2 := nSalComp2 + (SEK->EK_VALOR*TraeSigno(SE2->E2_TIPO))
		Else
			nSalComp1 := nSalComp1 + (SEK->EK_VALOR*TraeSigno(SE2->E2_TIPO))
		EndIf
		
	EndIf
	
	DbSkip()
	
ENDDO

DbGoTo( nRecSEK )

WHILE ( SEK->EK_FILIAL + SEK->EK_ORDPAGO ) == cNroRec
	If SEK->EK_TIPODOC $ "CP-CT-RG-RI-RB"
		
		If Val( SEK->EK_MOEDA ) = 1
			cMoneda := "$"
		ElseIf Val( SEK->EK_MOEDA ) = 2
			cMoneda := "U$S"
		EndIf
		
		SA6->( dbSeek( xFilial( "SA6" ) + SEK->EK_BANCO + SEK->EK_AGENCIA + SEK->EK_CONTA, .F. ) )
		cDescBco := Alltrim(SA6->A6_NREDUZ)+ "-"+ SEK->EK_TIPO                                 //SINTYA 1
		cDescBco := cDescBco + Space( 20 - Len( cDescBco ) )
		cDescBco := Left( cDescBco, 20 )
		
		If SEK->EK_TIPODOC == "CP" .or. SEK->EK_TIPODOC == "CT"
			
			If SEK->EK_TIPODOC == "CP" 
				dbSelectArea( "SEF" )
				dbSetOrder( 3 )
				dbSeek( xFilial( "SEF" ) + SEK->EK_PREFIXO + SEK->EK_NUM + SEK->EK_PARCELA, .F. )
				
				dbSelectArea( "SEK" )
			EndIf
			
			If AllTrim(SEK->EK_TIPO) $ 'EF/EF2'
				AADD( aCHLis, { cDescBco, DToC( SEK->EK_VENCTO ), AllTrim(SEK->EK_CONTA)+"/"+AllTrim(SEK->EK_AGENCIA),"" , cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ) } )
			ElseIf SEF->( Found() )
				AADD( aCHLis, { cDescBco, DToC( SEK->EK_VENCTO ), SEK->EK_CONTA, SEF->EF_NUM, cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ) } )
			Elseif SEK->EK_TIPODOC == "CT"
			 	cCuit := Posicione("SEL",1,xFilial("SEL")+Posicione("SE1",2,xFilial("SE1")+SEK->EK_ENTRCLI+SEK->EK_LOJCLI+SEK->EK_PREFIXO+SEK->EK_NUM,"E1_SERREC")+SE1->E1_RECIBO+SE1->E1_TIPO+SE1->E1_PREFIXO+SE1->E1_NUM,"EL_CGC")    // Posicione("SE1",2,xFilial("SE1")+SEK->EK_ENTRCLI+SEK->EK_LOJCLI+SEK->EK_PREFIXO+SEK->EK_NUM,"E1_SERREC")
				If Empty(cCuit)
					cCuit := POSICIONE("SA1",1,XFILIAL("SA1")+SEK->EK_ENTRCLI+SEK->EK_LOJCLI,"A1_CGC")        
				EndIf
				
				cDescBco = POSICIONE("FJO",1,XFILIAL("FJO")+SEK->EK_BANCO,"FJO_NOME")
				cDescBco := cDescBco + Space( 20 - Len( cDescBco ) )
				cDescBco := Left( cDescBco, 20 )   
				AADD( aCHLis, { cDescBco, DToC( SEK->EK_VENCTO ), Alltrim(cCuit), Alltrim(SEK->EK_NUM), cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ) } )
			Else
				AADD( aCHLis, { cDescBco, DToC( SEK->EK_VENCTO ), SEK->EK_CONTA, SEK->EK_NUM, cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ) } )
			EndIf
			
			If Val( SEK->EK_MOEDA ) = 2
				nCHValor2 += SEK->EK_VALOR
			Else
				nCHValor1 += SEK->EK_VALOR
			EndIf
			
		ElseIf SEK->EK_TIPODOC == "EF"
			
			oPrn:Say( nLine, 1130, "E F E C T I V O", oFont8, 100 )
			oPrn:Say( nLine, 2000, PADL( cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ), 15, " " ), oFont8s, 100 )
			
			
			nLine += 50
			nCHAdLis += 1
			
		ElseIf SEK->EK_TIPODOC == "TF"
			
			oPrn:Say( nLine, 1130, "T R A N S F E R E N C I A", oFont8, 100 )
			oPrn:Say( nLine, 2000, PADL( cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ), 15, " " ), oFont8s, 100 )
			
			nLine += 50
			nCHAdLis += 1
			
		ElseIf SEK->EK_TIPODOC == "RG"  .and. SEK->EK_TIPO = "IV-" .and.  (SEK->EK_VALOR > 0 .or. SEK->EK_VALOR< 0)   // Se agreg�   "SEK->EK_VALOR< 0" para las retenciones de NCP.
			
			oPrn:Say( nLine, 1130, "RETENCION I.V.A.", oFont8, 100 )
			oPrn:Say( nLine, 2000, PADL( cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ), 15, " " ), oFont8s, 100 )
			
			nLine += 50
			nCHAdLis += 1
			
		ElseIf SEK->EK_TIPODOC == "RG" .and. SEK->EK_TIPO = "GN-" .and.  (SEK->EK_VALOR > 0 .or. SEK->EK_VALOR< 0)   // Se agreg�   "SEK->EK_VALOR< 0" para las retenciones de NCP.
			
			oPrn:Say( nLine, 1130, "RETENCION GANANCIAS", oFont8, 100 )
			oPrn:Say( nLine, 2000, PADL( cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) )), 15, " " ), oFont8s, 100 )
			
			nLine += 50
			nCHAdLis += 1
			
		ElseIf SEK->EK_TIPODOC == "RG" .and. SEK->EK_TIPO = "IB-" .and. (SEK->EK_VALOR > 0 .or. SEK->EK_VALOR< 0)   // Se agreg�   "SEK->EK_VALOR< 0" para las retenciones de NCP.
			
			oPrn:Say( nLine, 1130, "RETENCION I.I.B.B. "+SEK->EK_EST, oFont8, 100 )
			oPrn:Say( nLine, 2000, PADL( cMoneda +" "+ AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) )), 15, " " ), oFont8s, 100 )
			
			nLine += 50
			nCHAdLis += 1
			
		ElseIf SEK->EK_TIPODOC == "RG"  .and. SEK->EK_TIPO = "SU-" .and.(SEK->EK_VALOR > 0 .or. SEK->EK_VALOR< 0)   // Se agreg�   "SEK->EK_VALOR< 0" para las retenciones de NCP.
			
			oPrn:Say( nLine, 1130, "RETENCION S.U.S.S.", oFont8, 100 )
			oPrn:Say( nLine, 2000, PADL( cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ), 15, " " ), oFont8s, 100 )
			
			nLine += 50
			nCHAdLis += 1
			
		ElseIf SEK->EK_TIPODOC == "RG"  .and. SEK->EK_TIPO = "SL-" .and.  (SEK->EK_VALOR > 0 .or. SEK->EK_VALOR< 0)   // Se agreg�   "SEK->EK_VALOR< 0" para las retenciones de NCP.
			
			oPrn:Say( nLine, 1130, "RET. - RG 1556/2003", oFont8, 100 )
			oPrn:Say( nLine, 2000, PADL( cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ), 15, " " ), oFont8s, 100 )
			
			nLine += 50
			nCHAdLis += 1
			
		EndIf
		
		If Val( SEK->EK_MOEDA ) = 2
			nTotVal2 := nTotVal2 + SEK->EK_VALOR
		Else
			nTotVal1 := nTotVal1 + SEK->EK_VALOR
		EndIf
		
	ElseIf SEK->EK_TIPODOC == "PA"
		
		If Val( SEK->EK_MOEDA ) = 2
			nPagoAnt2 += SEK->EK_VALOR
		Else
			nPagoAnt1 += SEK->EK_VALOR
		EndIf
		
	EndIf
	
	DbSkip()
	
ENDDO

DbSkip( -1 )

If Len( aCHLis ) + nCHAdLis <= 18
	For z := 1 To Len( aCHLis )
		oPrn:Say( nLine, 1130, aCHLis[z][1], oFont8, 100 )
		oPrn:Say( nLine, 1480, aCHLis[z][2], oFont8, 100 )
		oPrn:Say( nLine, 1655, aCHLis[z][3], oFont8, 100 )
		oPrn:Say( nLine, 1855, aCHLis[z][4], oFont8, 100 )
		oPrn:Say( nLine, 2035, PADL( aCHLis[z][5], 15, " " ), oFont8s, 100 )
		nLine += 50
	Next z
Else
	If nChValor1 > 0
		oPrn:Say( nLine, 1130, AllTrim( Str( Len( aCHLis ), 3, 0 ) ) + " CHEQUES EN PESOS, SEGUN DETALLE ADJUNTO", oFont8, 100 )
		oPrn:Say( nLine, 2000, PADL( " $ "+AllTrim( TransForm( nChValor1, PesqPict( "SEK", "EK_VALOR" ) ) ), 15, " " ), oFont8s, 100 )
		nLine += 50
	EndIf
	
	If nChValor2 > 0
		oPrn:Say( nLine, 1130, AllTrim( Str( Len( aCHLis ), 3, 0 ) ) + " CHEQUES EN DOLARES, SEGUN DETALLE ADJUNTO", oFont8, 100 )
		oPrn:Say( nLine, 2000, PADL( " $ "+AllTrim( TransForm( nChValor2, PesqPict( "SEK", "EK_VALOR" ) ) ), 15, " " ), oFont8s, 100 )
		nLine += 50
	EndIf	
EndIf

nLine := DETAILBOTTOM

oPrn:Box( nLine, 0050, nLine + 100, 1125 )
oPrn:Box( nLine, 0455, nLine + 100, 0790 ) //PESOS
oPrn:Box( nLine, 0790, nLine + 100, 1125 ) //DOLARES
oPrn:Box( nLine, 1125, nLine + 100, 2300 )
oPrn:Box( nLine, 1590, nLine + 100, 1950 ) //PESOS
oPrn:Box( nLine, 1950, nLine + 100, 2300 ) //DOLARES   //1950

nLine += 30

oPrn:Say( nLine, 0080, "COMPROB. APLICADOS", oFont8b, 100 )
oPrn:Say( nLine, 0458, " $ " + PADR( AllTrim( TransForm( nSalComp1, PesqPict( "SEK", "EK_VALOR" ) ) ), 18, " " ), oFont8s, 100 )
oPrn:Say( nLine, 0793, " U$S " + PADR( AllTrim( TransForm( nSalComp2, PesqPict( "SEK", "EK_VALOR" ) ) ), 16, " " ), oFont8s, 100 )
oPrn:Say( nLine, 1155, "TOTAL VAL. ENTREGADOS", oFont8b, 100 )
oPrn:Say( nLine, 1593, " $ " + PADR( AllTrim( TransForm( nTotVal1, PesqPict( "SEK", "EK_VALOR" ) ) ), 20, " " ), oFont8s, 100 )
oPrn:Say( nLine, 1953, " U$S " + PADR( AllTrim( TransForm( nTotVal2, PesqPict( "SEK", "EK_VALOR" ) ) ), 17, " " ), oFont8s, 100 )

nLine += 50

oPrn:Box( nLine, 0050, nLine + 100, 1125 )
oPrn:Box( nLine, 0455, nLine + 100, 0790 ) //PESOS
oPrn:Box( nLine, 0790, nLine + 100, 1125 ) //DOLARES
oPrn:Box( nLine, 1125, nLine + 100, 2300 )
oPrn:Box( nLine, 1590, nLine + 100, 1950 ) //PESOS
oPrn:Box( nLine, 1950, nLine + 100, 2300 ) //DOLARES

nLine += 30

oPrn:Say( nLine, 0080, "PAGOS ANTICIPADOS", oFont8b, 100 )
oPrn:Say( nLine, 0458, " $ " + PADR( AllTrim( TransForm( nPagoAnt1, PesqPict( "SEK", "EK_VALOR" ) ) ), 18, " " ), oFont8s, 100 )
oPrn:Say( nLine, 0793, " U$S " + PADR( AllTrim( TransForm( nPagoAnt2, PesqPict( "SEK", "EK_VALOR" ) ) ), 16, " " ), oFont8s, 100 )
oPrn:Say( nLine, 1146, "TOTAL ORDEN DE PAGO", oFont5, 100 )
oPrn:Say( nLine, 1593, " $ " + PADR( AllTrim( TransForm( nTotVal1, PesqPict( "SEK", "EK_VALOR" ) ) ), 20, " " ), oFont5, 100 )
oPrn:Say( nLine, 1953, " U$S " + PADR( AllTrim( TransForm( nTotVal2, PesqPict( "SEK", "EK_VALOR" ) ) ), 17, " " ), oFont5, 100 )

nLine += 50

oPrn:Box( nLine, 0050, nLine + 100, 1125 )
oPrn:Box( nLine, 0455, nLine + 100, 0790 ) //PESOS
oPrn:Box( nLine, 0790, nLine + 100, 2300 ) //DOLARES

nLine += 30

oPrn:Say( nLine, 0080, "TIPO DE CAMBIO", oFont8b, 100 )
oPrn:Say( nLine, 0550,  TransForm( ntipoc, "9.9999" )/*PADL( AllTrim( TransForm( ntipoc, "@ 9,9999" ) ), 18, " " )*/, oFont8s, 100 )

nLine += 70

oPrn:Box( nLine, 0050, nLine + 350, 2300 )//1000
nLine += 250

If cMoneda == "$"
	cMon := "A"
ElseIf cMoneda == "U$S"
	cMon := "D"
EndIf

Return NIL

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PrintFoot()

oPrn:Say( nLine, 0195, Replicate( "-", 25 ), oFont8b, 100 )
oPrn:Say( nLine, 0650, Replicate( "-", 25 ), oFont8b, 100 )
oPrn:Say( nLine, 1295, Replicate( "-", 25 ), oFont8b, 100 )
oPrn:Say( nLine, 1850, Replicate( "-", 25 ), oFont8b, 100 )

nLine += 40

oPrn:Say( nLine, 0153, PadC( "CONFECCION"  , 25, " " ), oFont8b, 100 )
oPrn:Say( nLine, 0625, PadC( "CONTROL"     , 25, " " ), oFont8b, 100 )
oPrn:Say( nLine, 1255, PadC( "AUTORIZACION", 25, " " ), oFont8b, 100 )
oPrn:Say( nLine, 1825, PadC( "AUDITORIA"   , 25, " " ), oFont8b, 100 )

oPrn:EndPage()

If Len( aCHLis ) + nCHAdLis > 18 //Si imprime la lista
	PrintHead("L")
	PrintList()
	oPrn:EndPage()
EndIf


Return NIL

/*-------------------------------------------------------------------------------------------------------*/

STATIC FUNCTION PrintList()

oPrn:Box( nLine, 0050, nLine + 1750, 1150 )
oPrn:Box( nLine, 1150, nLine + 1750, 2300 )

For z := 1 To Len( aCHLis )
	oPrn:Say( nLine, 0055, aCHLis[z][1], oFont8, 100 )
	oPrn:Say( nLine, 0395, aCHLis[z][2], oFont8, 100 )
	oPrn:Say( nLine, 0560, aCHLis[z][3], oFont8, 100 )
	oPrn:Say( nLine, 0740, aCHLis[z][4], oFont8, 100 )
	oPrn:Say( nLine, 0925, aCHLis[z][5], oFont8s, 100 )
	If Len( aCHLis ) >= ( z + 35 )
		oPrn:Say( nLine, 1130, aCHLis[z+35][1], oFont8, 100 )
		oPrn:Say( nLine, 1480, aCHLis[z+35][2], oFont8, 100 )
		oPrn:Say( nLine, 1655, aCHLis[z+35][3], oFont8, 100 )
		oPrn:Say( nLine, 1855, aCHLis[z+35][4], oFont8, 100 )
		oPrn:Say( nLine, 2050, aCHLis[z+35][5], oFont8s, 100 )
	EndIf
	nLine += 50
Next z

nLine += 600

oPrn:Box( nLine, 0050, nLine + 100, 1150 )
oPrn:Box( nLine, 1150, nLine + 100, 2300 )
nLine += 30
oPrn:Say( nLine, 0100, "CHEQUES ENTREGADOS: ", oFont8b, 100 )
oPrn:Say( nLine, 0880, Str( Len( aCHLis ), 3, 0 ), oFont8s, 100 )
oPrn:Say( nLine, 1195, "IMPORTE: ", oFont8b, 100 )
oPrn:Say( nLine, 2050, TransForm( nCHValor1+nCHValor2, PesqPict( "SEK", "EK_VALOR" ) ), oFont8s, 100 )

nLine += 100

oPrn:Say( nLine, 0055, "EL PRESENTE DETALLE DE CHEQUES CARECE DE VALOR SI NO POSEE EL CUERPO PRINCIPAL DE LA ORDEN DE PAGO CON EL MISMO NUMERO.", oFont8s, 100 )

nLine += 200

oPrn:Say( nLine, 1800, Replicate( "-", 25 ), oFont8b, 100 )

nLine += 50

oPrn:Say( nLine, 1970, "Firma",  oFont, 100 )


aCHLis := {}

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCRFIN02  �Autor  �Microsiga           �Fecha �  03/18/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidPerg(cPerg)

LOCAL aVldSX1  := GetArea()
LOCAL aCposSX1 := {}
LOCAL aPergs   := {}

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL	",;
"X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1",;
"X1_CNT01","X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02" ,"X1_VAR03",;
"X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03","X1_VAR04","X1_DEF04","X1_DEFSPA4",;
"X1_DEFENG4","X1_CNT04","X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
"X1_F3","X1_GRPSXG"}

aAdd(aPergs,{'Desde Ord.Pag.','Desde Ord.Pag.','Desde Ord.Pag.','mv_ch1','C', 12, 0, 1, 'G', '', 'mv_par01','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
aAdd(aPergs,{'Hasta Ord.Pag.','Hasta Ord.Pag.','Hasta Ord.Pag.','mv_ch2','C', 12, 0, 1, 'G', '', 'mv_par02','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
//aAdd(aPergs,{'Imprimir      ','Imprimir      ','Imprimir      ','mv_ch3','N', 01, 0, 1, 'G', '', 'mv_par03','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
//aAdd(aPergs,{'Previsualizacion','Previsualizacion','Previsualizacion','mv_ch3','N', 01, 0, 1, 'G', '', 'mv_par03','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	If !(dbSeek(cPerg+StrZero(nx,2)))
		RecLock("SX1",.T.)
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with StrZero(nx,2)
		for nj:=1 to Len(aCposSX1)
			FieldPut(FieldPos(ALLTRIM(aCposSX1[nJ])),aPergs[nx][nj])
		next nj
		MsUnlock()
	Endif
Next

RestArea( aVldSX1 )

Return

// Funcion para traer el signo de los documentos Cancelados

Static Function TraeSigno( cTipo )
Local aArea := GetArea(),;
nRet  := 1

DbSelectAreA( 'SES' )
DbSetOrder(1)
If DbSeek( xFilial( ) + cTipo )
	If ES_SINAL == '-'
		nRet  := -1
	EndIf
EndIf

RestArea( aArea )

Return( nRet )
