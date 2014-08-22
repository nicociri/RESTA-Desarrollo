#include "rwmake.ch"
#DEFINE DETAILBOTTOM 2800
#DEFINE LASTLINE 3200

                                                   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PVENTA  ºAutor  ³MS					ºFecha ³  16-11-10    º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Layout Pedido de Venta		                              º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION PVENTA()

PRIVATE _NumPag    := 0
PRIVATE _TotPag    := 0
PRIVATE LPrinted   := .F.

ValidPerg( "PEDVEN" )

If alltrim(FUNNAME())=="#AUTO" .or. alltrim(FUNNAME())$"MATA410" 
   mv_par01:=SC5->C5_NUM
   mv_par02:=SC5->C5_NUM
   mv_par06:=SC5->C5_CLIENTE
   mv_par07:=SC5->C5_CLIENTE      
   Pergunte( "PEDVEN    ", .t. )
   mv_par01:=SC5->C5_NUM
   mv_par02:=SC5->C5_NUM
  // mv_par03:=1
  // mv_par04:=2
 //  mv_par05:=1
   mv_par06:=SC5->C5_CLIENTE
   mv_par07:=SC5->C5_CLIENTE
 //  mv_par08:="      "
 //  mv_par09:="ZZZZZZ"
 //  mv_par10:="               "
 //  mv_par11:="ZZZZZZZZZZZZZZZ"
 //  mv_par12:=1
Else
   IF !Pergunte( "PEDVEN    ", .t. )
      Return
   ENDIF
ENDIF

RptStatus( { || SelectComp() } )

RETURN nil

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION SelectComp()

PRIVATE nLine    := 0, ;
aPedBloq := Array( 0 )

PRIVATE oPrn  := TMSPrinter():New(), ;
oFont    := TFont():New( "Arial"            ,, 10,, .f.,,,,    , .f. ), ;
oFont8   := TFont():New( "Arial"            ,,  8,, .f.,,,,    , .f. ), ;
oFont9   := TFont():New( "Arial"            ,,  9,, .f.,,,,    , .f. ), ;
oFont6   := TFont():New( "Arial"            ,,  6,, .f.,,,,    , .f. ), ;
oFont8b  := TFont():New( "Arial"            ,,  8,, .t.,,,, .t., .f. ), ;
oFont10a := TFont():New( "Arial"            ,,  8,, .f.,,,,    , .f. ), ;
oFont12a := TFont():New( "Arial"            ,,  12,, .f.,,,,    , .f. ), ;
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
oFont30  := TFont():New( "Bauhaus Lt Bt"    ,, 10,, .t.,,,,    , .f. ), ;
oFontCB  := TFont():New( "Bar Code"         ,, 14,, .t.,,,,    , .f. ), ;
oFont31  := TFont():New( "Arial"            ,,  8,, .t.,,,,    , .f. )

IF mv_par12 == 2
	oPrn:Setup()
ENDIF

oPrn:SetPortrait()

DbSelectArea( "SA1" )
DbSetOrder( 1 )
DbSelectArea( "SED" )
DbSetOrder( 1 )
DbSelectArea( "SC6" )
DbSetOrder( 1 )
DbSelectArea( "SC9" )
DbSetOrder( 1 )
DbSelectArea( "SE4" )
DbSetOrder( 1 )
DbSelectArea( "SA3" )
DbSetOrder( 1 )
DbSelectArea( "SB1" )
DbSetOrder( 1 )
//DbSelectArea( "ZZ7" )//
//DbSetOrder( 1 )//
DbSelectArea( "SC5" )
DbSetOrder( 1 )

DbSeek( xFilial() + mv_par01, .t. )
SetRegua( ( Val( mv_par02 ) - Val( mv_par01 ) ) + 1 )

DbEval( { || PrintComp(), IncRegua() }, ;
{ || SC5->C5_CLIENTE >= mv_par06 .AND. SC5->C5_CLIENTE <= mv_par07 .AND. ;
SC5->C5_VEND1 >= mv_par08 .AND. SC5->C5_VEND1 <= mv_par09 }, ;
{ || SC5->C5_NUM <= mv_par02 } )

IF mv_par12 == 1
	oPrn:PreView()
ELSE
	oPrn:Print()
ENDIF

Ms_Flush()

RETURN

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PrintComp()

LOCAL nRecSC6    := 0, ;
aRet       := Array( 0 ), ;
lProcess   := .t., ;
nLenMemo   := 0, ;
nIdx       := 0

PRIVATE aDescMon    := { GetMV( "MV_MOEDA1" ), ;
GetMV( "MV_MOEDA2" ), ;
GetMV( "MV_MOEDA3" ), ;
GetMV( "MV_MOEDA4" ), ;
GetMV( "MV_MOEDA5" ) }, ;
aSimbMon    := { GetMV( "MV_SIMB1" ), ;
GetMV( "MV_SIMB2" ), ;
GetMV( "MV_SIMB3" ), ;
GetMV( "MV_SIMB4" ), ;                                                                      
GetMV( "MV_SIMB5" ) }, ;
cMoneda     := Space( 0 ), ;
cSigno      := Space( 0 ), ;
cProvincia  := Space( 0 ), ;
cSitIVA     := Space( 0 ), ;
nSubTot     := 0, ;
cProvincia  := Space( 0 ), ;
cProvCMS    := Space( 0 ), ;
cSitIVA     := Space( 0 ), ;
lExterior 	:= .F., ;
cProvEnt	:= space( 0 ), ;
cCPEnt		:= space( 0 ), ;
cDireEnt	:= space( 0 ), ;
aMemo1      := Array( 0 ), ;
aMemo2 		:= Array( 0 ), ;
aMemo3 		:= Array( 0 ), ;
aMemo4 		:= Array( 0 ), ;
aMemo5 		:= Array( 0 ), ;
aMemo6 		:= Array( 0 ), ;
aMemo7 		:= Array( 0 ), ;
aMemo8 		:= Array( 0 ), ;
aMemo9 		:= Array( 0 ), ;
aMemo10 	:= Array( 0 ), ;
aDriver     := ReadDriver()

cMoneda  := aDescMon[ iif (SC5->C5_MOEDA <=1,1,SC5->C5_MOEDA)]
cSigno   := aSimbMon[ iif (SC5->C5_MOEDA <=1,1,SC5->C5_MOEDA)]

DbSelectArea( "SA1" )
DbSeek( xFilial() + SC5->C5_CLIENTE + SC5->C5_LOJACLI )
If Alltrim(A1_TIPO) == "E"
	// lExterior 	:= .T.
Else // lugar entrega
	cdireEnt:= alltrim(SA1->A1_ENDENT) 
	cCPEnt 	:= SA1->A1_CEPE
	cProvEnt:= SA1->A1_BAIRROENT
EndIf

DbSelectARea("SYD")
DbSetOrder(1)     

DbSelectArea( "SED" )   
DbSeek( xFilial() + SC5->C5_NATUREZ )
_cModalidad := AllTrim(SED ->ED_DESCRIC)

DbSelectArea( "SC6" )
DbSeek( xFilial() + SC5->C5_NUM )
_nPresup:=SC6->C6_NUMORC
DbSelectArea( "SE4" )
DbSeek( xFilial() + SC5->C5_CONDPAG )
_descCond :=  AllTrim(SE4->E4_DESCRI)

DbSelectArea( "SA3" )
DbSeek( xFilial() + SC5->C5_VEND1 )

DbSelectArea( "SYA" )
DbSeek( xFilial() + SA1->A1_PAIS )

DbSelectArea( "AGR" )
DbSeek( xFilial() + SC5->C5_CATPV )
cCatPV := AGR_DESCRI

DbSelectArea( "SX5" )
DbSeek( xFilial() + "12" + SA1->A1_EST )
cProvincia := AllTrim( X5_DESCSPA )

DbSeek( xFilial() + "12" + SM0->M0_ESTCOB )
cProvCMS := AllTrim( X5_DESCSPA )

DbSeek( xFilial() + "SF" + SA1->A1_TIPO )
cSitIVA := AllTrim( X5_DESCSPA )

// LEYENDAS 
/*DbSelectArea( "ZZ7" )
FOR nx := 1 TO 10 
	dbgotop()
	IF !empty(&("SC5->C5_XLEYE" + AllTrim(str(nX))))
		If DbSeek( xFilial() + &("SC5->C5_XLEYE" + AllTrim(str(nX))))
			AAdd( &("Amemo" + AllTrim(str(nX))), ZZ7->ZZ7_NOMBRE )
			nLenMemo := MLCount( ZZ7->ZZ7_LEYE, 125 )
			FOR nIdx := 1 TO nLenMemo
   				AAdd( &("Amemo" + AllTrim(str(nX))), MemoLine( ZZ7->ZZ7_LEYE, 125, nIdx ) )
			NEXT
		Endif	
	endif	
NEXT */                 

IF mv_par05 != 1      // seleccion pedidos liberados

	DbSelectArea( "SC6" )

	lProcess := .f.
	nRecSC6  := RecNo()

	DbEval( { || AAdd( aRet, PVtaAprob( .t. ) ) }, ;
	{ || C6_PRODUTO >= mv_par10 .AND. C6_PRODUTO <= mv_par11 }, ;
	{ || ( C6_FILIAL + C6_NUM ) == ( SC5->C5_FILIAL + SC5->C5_NUM ) } )

	DbGoTo( nRecSC6 )

	FOR nElem := 1 TO Len( aRet )
		//mv_par[1]¨=todos,mv_par[2]=pendientes,mv_par[3]=Aprob.,mv_par[4]= bloq.,mv_par[5]=facturado
		IF aRet[nElem][1] .AND. (mv_par05 == 3 .or. mv_par05 == 5)	// ya facturados y remitidos
			lProcess := .t.
		ELSEIF aRet[nElem][2] .AND. (mv_par05 == 3 .or. mv_par05 == 5) // ya facturados s/remitos
			lProcess := .t.
		ELSEIF aRet[nElem][3] .AND. mv_par05 == 4// bloqueado cred
			lProcess := .t.
		ELSEIF aRet[nElem][4] .AND. mv_par05 == 4// bloqueado stk
			lProcess := .t.
		ELSEIF !Empty( aRet[nElem][6] ) .AND. mv_par05 == 3// cant. aprobada
			lProcess := .t.
		ELSEIF !aRet[nElem][1] .AND. !aRet[nElem][2] .AND. !aRet[nElem][3] .AND. !aRet[nElem][4] .AND. ;
			Empty( aRet[nElem][6] ) .AND. mv_par05 == 2
			lProcess := .t.
		ENDIF

	NEXT

	DbSelectArea( "SC5" )

ENDIF

_NumPag := 0

IF lProcess
	PrintHead()
	PrintItem()
	PrintFoot( .t. )
	PrintLeyen()// Imprime Leyendas 
ENDIF

RETURN nil

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PrintHead()

_NumPag := _NumPag + 1

IF !lPrinted
	lPrinted := .t.
ELSE
	oPrn:StartPage()
ENDIF

nLine := 50

oPrn:Say( nLine, 0100, " ", ofont10a, 100 )

IF !Empty( GetMV( "MV_DIRLOGO" ) ).AND.CEMPANT=='01'.AND. SC5->C5_XENVIO <> '2'
	IF File( AllTrim( GetMV( "MV_DIRLOGO" ) ) )
		oPrn:Box( nLine, 0050, nLine + 470, 1150)
		oPrn:Box( nLine, 1150, nLine + 470, 2300 )
		nLine += 10
		oPrn:SayBitmap( nLine, 0100, AllTrim( GetMV( "MV_DIRLOGO" ) ) , 250, 250 )
	ELSE
		nLine += 10
	ENDIF
ENDIF
	nLine += 10
	nline += 20 
	IF CEMPANT=='01'.AND. SC5->C5_XENVIO <> '2'
	oPrn:Say( nLine + 260, 0100, AllTrim( SM0->M0_NOMECOM ), oFont10a, 100 )
	oPrn:Say( nLine + 300, 0100, "Domicilio Legal: " + AllTrim( SM0->M0_ENDENT ) + " - " + ALLTRIM(SM0->M0_CIDENT) + " - " + ALLTRIM(SM0->M0_ESTENT), ofont10a, 100 )
	oPrn:Say( nLine + 340, 0100, "(" +  AllTrim(  SM0->M0_CEPENT  ) + ") " + " - " + cProvCMS + " - Tel.: (5411) 4568-9150" , ofont10a, 100 )
	oPrn:Say( nLine + 380, 0100, "Fax.: (5411) 4568-9150" , ofont10a, 100 )
//	oPrn:Say( nLine + 340, 0100, "email: " + Alltrim(GetMV("MV_X_MAILP")), ofont10a, 100 )
    ENDIF

If lExterior
	oPrn:Say( 0100, 1400, "FACTURA PRO FORMA", oFont10a, 100 )
	oPrn:Say( 0150, 1400, "PRO FORMA INVOICE", oFont10a, 100 )
Else
	oPrn:Say( 0100, 1800, "PEDIDO DE VENTA", oFont10a, 100 )
EndIf
oPrn:Say( 0200, 1800, "Nro: " +SC5->C5_FILIAL+'-'+ SC5->C5_NUM + "     " + cCatPV, oFont10a, 100 )

oPrn:Say( 0300, 1800, "Fecha: "+DToC( SC5->C5_EMISSAO ), oFont10a, 100 )
IF CEMPANT=='01'.AND. SC5->C5_XENVIO <> '2'
oPrn:Say( 0400, 1200, "C.U.I.T.: " + substr(SM0->M0_CGC,1, 2) + '-' + substr(SM0->M0_CGC,4,8) + '-' + substr(SM0->M0_CGC, 13, 1), ofont10a, 100 )
oPrn:Say( 0450, 1200, "I.V.A.: RESPONSABLE INSCRIPTO", ofont10a, 100 )
ENDIF
nLine := 520

oPrn:Box( nLine, 0050, 0800, 2300 )

oPrn:Say( nLine, 0100, If(lExterior,"Sold to: ","Cliente: ") + "(" + AllTrim( SA1->A1_COD ) + ") " + ;
		  AllTrim( SA1->A1_NOME ), ofont8B, 100 )
nLine += 50

oPrn:Say( nLine, 0100, AllTrim( SA1->A1_END ), ofont10a, 100 ) //"Domicilio: "
nLine += 50

oPrn:Say( nLine, 0100, Alltrim( SA1->A1_MUN ) + If( SA1->A1_TIPO != "E", If( !Empty( cProvincia ), ;
" - " + cProvincia, "" ), AllTrim( SYA->YA_DESCR ) ) + "   C.P.: " + AllTrim( SA1->A1_CEP ), ofont10a, 100 )
nLine += 50

cCuit := substr(SA1->A1_CGC,1, 2) + '-' + substr(SA1->A1_CGC,3,8) + '-' + substr(SA1->A1_CGC, 11, 1)
oPrn:Say( nLine, 0100, "C.U.I.T.: " + AllTrim(cCuit) + If(lExterior," "," - I.V.A.: " + cSitIVA), ofont10a, 100 )
// oPrn:Say( nLine, 0850, "(%) Desc.: " + If(SA1->A1_DESC ==0,"-",TransForm(SA1->A1_DESC,PesqPict("SA1","A1_DESC" ))), ofont10a, 100 )
//oPrn:Say( nLine, 1000, "Dir.Entrega: " + SC5->C5_XENDENT, ofont10a, 100 )
oPrn:Say( nLine, 2000, "Moneda: " + cMoneda, ofont10a, 100 )
nLine += 50
// c5_XNFSER C5_XNFDOC                                                                                     

cMoneda := aDescMon[ If( Empty( SC5->C5_MOEDA ), 1, SC5->C5_MOEDA ) ]
//oPrn:Say( nLine, 0100, IIF(lExterior,"CLIENT ORDER: ","Orden de Compra: ")+SC5->C5_XPEDCLI, ofont10a, 100 )
oPrn:Say( nLine, 0850, "Vendedor: " + If(Empty( SC5->C5_VEND1 )," ", + "(" + Alltrim(SC5->C5_VEND1) + ") " + AllTrim( SA3->A3_NOME )), ofont10a, 100 )
//oPrn:Say( nLine, 2000, "Cotiz. Ped.: " + csigno + If(SC5->C5_MOEDA <=1,"1.00",TransForm(SC5->C5_TXMOEDA,PesqPict("SC5","C5_TXMOEDA" ))), ofont10a, 100 )
//oPrn:Say( nLine, 2000, "Sucursal : " + SC5->C5_FILIAL, ofont10a, 100 )
nLine += 30
//oPrn:Say( nLine, 0100, "Presup: " + alltrim(SC6->C6__cPresup) + "      O.Compra: "+ SC5->C5_XOC," ", + "(" + Alltrim(SC5->C5_VEND1) + ") " + AllTrim( SA3->A3_NOME ), ofont10a, 100 )
oPrn:Say( nLine, 0100, "Presup: " + SC6->C6_NUMORC + "    O.Compra: "+ SC5->C5_XOC,ofont10a, 100 ) 

//Imprimir siempre la linea, tenga datos o no, para docger<>2
//oPrn:Say( nLine, 0800, IF(SC5->C5_DOCGER=1 .and. LEN(ALLTRIM( SC5->C5_XNFSER))>0,"E/FUT-FAC: " + SC5->C5_XNFSER+"-"+SC5->C5_XNFDOC,''),ofont10a, 100 ) 
oPrn:Say( nLine, 0800, IF(SC5->C5_DOCGER<>'2',"E/FUT-FAC: " + if(LEN(ALLTRIM( SC5->C5_XNFSER))>0, SC5->C5_XNFSER+"-"+SC5->C5_XNFDOC,''),''),ofont10a, 100 ) 
IF SC5->C5_XESACO=='S'
   oPrn:Say( nLine, 1500, "Acopio: " + SC5->C5_XNROACO+ "    T.acopio: "+ IF(SC5->C5_XTPACO='I','INDEFINIDO','DEFINIDO' ), ofont10a, 100 )
ENDIF
oPrn:Say( nLine, 2000, "Sucursal : " + CEMPANT+'/'+CFILANT, ofont10a, 100 )
nLine := 800                
oPrn:Box( nLine, 0050, nLine + 100, 0320 )
oPrn:Box( nLine, 0320, nLine + 100, 0520 )
oPrn:Box( nLine, 0520, nLine + 100, 1750 )                                
//oPrn:Box( nLine, 1600, nLine + 100, 1750 ) --FECHA DE ENTREGA                                
oPrn:Box( nLine, 1750, nLine + 100, 2000 )
oPrn:Box( nLine, 2000, nLine + 100, 2300 )
nLine += 30

If lExterior
	oPrn:Say( nLine, 0070, "QTY.", 		  oFont8b, 100 )
	oPrn:Say( nLine, 0270, "CODES", 	  oFont8b, 100 )
	oPrn:Say( nLine, 0800, "DESCRIPTION", oFont8b, 100 )
	//oPrn:Say( nLine, 1620, "DATE"		, oFont8b, 100 ) --FECHA DE ENTREGA
	oPrn:Say( nLine, 1800, "UNIT PRICE",  oFont8b, 100 )
	oPrn:Say( nLine, 2125, "NET PRICE",   oFont8b, 100 )
Else
	oPrn:Say( nLine, 0070, "IT / CANT.",  oFont8b, 100 )
	oPrn:Say( nLine, 0340, "CODIGO", 	  oFont8b, 100 )
	oPrn:Say( nLine, 0560, "DESCRIPCION", oFont8b, 100 )
	oPrn:Say( nLine, 1400, "DEP", oFont8b, 100 )
	oPrn:Say( nLine, 1560, "Fec.Ent.", oFont8b, 100 )
	//oPrn:Say( nLine, 1620, "ENTREGA"	, 	  oFont8b, 100 ) --FECHA DE ENTREGA
    IF MV_PAR04 = 1
	   oPrn:Say( nLine, 1770, "UNITARIO",	  oFont8b, 100 )
	   oPrn:Say( nLine, 2020, "TOTAL",		  oFont8b, 100 )
    EndIf
EndIf
oPrn:Box( 0900, 0050, DETAILBOTTOM, 0320 )    // CANT
oPrn:Box( 0900, 0320, DETAILBOTTOM, 0520 )    // COD.
oPrn:Box( 0900, 0520, DETAILBOTTOM, 1750 )    // DESC
//oPrn:Box( 0900, 1600, DETAILBOTTOM, 1750 )  --FECHA DE ENTREGA
oPrn:Box( 0900, 1750, DETAILBOTTOM, 2000 )
oPrn:Box( 0900, 2000, DETAILBOTTOM, 2300 )
nLine += 80

RETURN NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrintItem  ºAutor  ³MS				ºFecha ³  16-11-07    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Items Pedido de Venta.		                              º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION PrintItem()

LOCAL nIdx     := 0, ;
aRet     := Array( 0 ), ;
lProcess := .t.
Local cProd		:= "" 
Local nRecSC6	:= SC6->(Recno())
Local aDistri 	:= {}   
Local nPosDist	:= 0 
Local nTotBrut	:= 0    
Local aDescon 	:= {}
Local nPosDesc	:= 0
Local lDesc 	:= .F.    
Local cNomeDes 	:= ""
Local aAreaSC6 	:= {}
Local nSaldoAux := 0
DbSelectArea("SC5")

WHILE ( SC6->C6_FILIAL + SC6->C6_NUM ) == ( SC5->C5_FILIAL + SC5->C5_NUM )
    IF 'ACOPIO' $ SC6->C6_PRODUTO
       	SC6->( DbSkip() )
       LOOP
    ENDIF

	IF SC6->C6_PRODUTO >= mv_par10 .AND. SC6->C6_PRODUTO <= mv_par11  
	
		lProcess := .f.
		aRet     := PVtaAprob( If( mv_par05 == 1, .t., .f. ) )
		//mv_par[1]¨=todos,mv_par[2]=pendientes,mv_par[3]=Aprob.,mv_par[4]= bloq.,mv_par[5]=facturado
		IF aRet[1] .AND. ( mv_par05 == 5 .OR. mv_par05 == 3 )// aret[1] con factura y remito
			lProcess := .t.
		ELSEIF aRet[2] .AND. ( mv_par05 == 5 .OR. mv_par05 == 3 ) // aret[2] con fact y s/remito
			lProcess := .t.
		ELSEIF aRet[3] .AND. ( mv_par05 == 4 .OR. mv_par05 == 1 )// aret[3] bloqueado credito
			lProcess := .t.
		ELSEIF aRet[4] .AND. ( mv_par05 == 4 .OR. mv_par05 == 1 )// aret[4] bloqueo stock
			lProcess := .t.
		ELSEIF !Empty( aRet[6] ) .AND. ( mv_par05 == 3 .OR. mv_par05 == 1 )// aret[6] cant. aprobada
			lProcess := .t.
		ELSEIF !aRet[1] .AND. !aRet[2] .AND. !aRet[3] .AND. !aRet[4] .AND. ;
			Empty( aRet[6] ) .AND. ( mv_par05 == 2 .OR. mv_par05 == 1 )
			lProcess := .t.    
		ELSEIF  aRet[7]  .AND. ( mv_par05 == 3 .OR. mv_par05 == 1 )//Pendientes liberados
			lProcess := .t.	
	   	ELseIf 	mv_par05 == 1
	   		lProcess := .t. 
		ENDIF
       
		IF lProcess
	        aAreaSC6:= SC6->(GetArea())
	        
			DbSelectArea( "SB1" )
			DbSeek( xFilial() + SC6->C6_PRODUTO )
		    DbSelectArea( "SC5" )
			oPrn:Say( nLine, 0060,  SC6->C6_ITEM, oFont8, 100 )
			oPrn:Say( nLine, 0140, TransForm( SC6->C6_QTDVEN, PesqPict( "SC6", "C6_QTDVEN" ) ) + " " + SB1->B1_UM, oFont8, 100 )
	        oPrn:Say( nLine, 0340, AllTrim( SC6->C6_PRODUTO ), oFont8, 100 )
	        
	        cProdSal:=SC6->C6_PRODUTO//* lagonegro donde cProdSal es el producto y cLocalSal es el deposito
	        cLocalSal:=SC6->C6_LOCAL
	        DbSelectArea( "SB2" )
	        SB2->(DbSetOrder(1))
  			If SB2->(dbSeek(xFilial('SB2') + cProdSal + cLocalSal))
   			nSaldoAux := SaldoMov(NIL,NIL,NIL,Nil)
			EndIF
			
			RestArea(aAreaSC6)
			
			
			if nSaldoAux < 1
			   _cProdesc := POSICIONE("SB1",1,XFILIAL("SB1")+SC6->C6_PRODUTO,"B1_DESC")
			   _cProdesc := AllTrim( SC6->C6_DESCRI )+"    ( * )" //* Marca de stock. Lagonegro
			else 
			   _cProdesc := AllTrim( SC6->C6_DESCRI )
			endif
			
	        oPrn:Say( nLine, 0550, _cProdesc, oFont8, 100 )
			//oPrn:Say( nLine, 1620, DTOC(SC6->C6_ENTREG), oFont8, 100 ) --FECHA DE ENTREGA    
	        oPrn:Say( nLine, 1420, SC6->C6_LOCAL, oFont8, 100 )
	        oPrn:Say( nLine, 1560, DTOC(SC6->C6_ENTREG), oFont8, 100 )
			IF MV_PAR04 = 1
				oPrn:Say( nLine, 1780, TransForm( SC6->C6_PRCVEN, PesqPict( "SC6", "C6_PRUNIT" ) ), oFont8, 100 )
			    oPrn:Say( nLine, 2050, cSigno+TransForm( SC6->C6_PRCVEN * SC6->C6_QTDVEN , PesqPict( "SC6", "C6_VALOR" ) ), oFont8, 100 )
			ENDIF
			nLine   += 30
			// OBSERVACIONES
		   //	cTexto := alltrim(SC6->C6_XOBS)
			/*
			If !Empty(cTexto) 
				If Len(cTexto) <= 60
					oPrn:Say( nLine, 0520,substr(cTexto,1,60), oFont8, 100 )
					nLine   += 30
					IF nLine >= DETAILBOTTOM - 120
						PrintFoot(.F.)
						PrintHead()
					ENDIF
				else
					oPrn:Say( nLine, 0520,substr(cTexto,1,60), oFont8, 100 )
					nLine += 30
   					IF nLine >= DETAILBOTTOM - 120
						PrintFoot(.F.)
						PrintHead()
					ENDIF
   					oPrn:Say( nLine, 0520,substr(cTexto,61,60), oFont8, 100 )
					nLine += 30
   					IF nLine >= DETAILBOTTOM - 120
						PrintFoot(.F.)
						PrintHead()
					ENDIF
   					oPrn:Say( nLine, 0520,substr(cTexto,121,60), oFont8, 100 )
					nLine += 30
   					IF nLine >= DETAILBOTTOM - 120
						PrintFoot(.F.)
						PrintHead()
					ENDIF
   				endif
   			EndIf 
   			*/
   			/*
		   	IF !Empty( SC6->C6_XOBSMEM )         //OBSERVACIONES  EN CAMPO MEMO A NIVEL PRODUCTO
               aObs := {}
       		   nLenObs := MLCount( SC6->C6_XOBSMEM, 125 )
			   FOR nIob := 1 TO nLenobs
   			       AAdd( aObs , MemoLine( SC6->C6_XOBSMEM, 125, nIob ) )
			   NEXT
			   FOR nIob := 1 TO nLenobs
					IF nLine >= DETAILBOTTOM - 120
						PrintFoot(.F.)
						PrintHead()
					ENDIF
					oPrn:Say( nLine, 0520,aObs[nIob], oFont8, 100 )
					nLine   += 30
			   NEXT
			ENDIF
			*/
			// FIN OBSERV.        
			nSubTot += SC6->C6_VALOR
            nLine   += 30                       
			IF nLine >= DETAILBOTTOM - 120
				PrintFoot(.F.)
				PrintHead()
			ENDIF

		ENDIF

	ENDIF

	SC6->( DbSkip() )

ENDDO

nLine   += 30

DbSelectArea("SC5")
nLine := DETAILBOTTOM

RETURN NIL

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PrintFoot( lEnd )

lEnd := If( ValType( lEnd ) != "L", .t., lEnd )

oPrn:Box( nLine, 1750, nLine + 75, 2300 )   // box total
oPrn:Box( nLine, 0050, LASTLINE, 1200 )
oPrn:Box( nLine, 1200, LASTLINE, 1750 )
oPrn:Box( nLine, 1750, LASTLINE, 2300 )
nLine += 20
oPrn:Say( nLine, 0100, IF(lExterior,"COMMENTS: ","OBSERVACIONES:"), ofont10a, 100 )
oPrn:Say( nLine, 1250, "Contaduria", ofont10a, 100 )
oPrn:Say( nLine, 1600, "Ventas", ofont10a, 100 )
If lExterior
	oPrn:Say( nLine, 1000, "Pais Origen: "+AllTrim(Posicione("SYA",1,xFilial("SYA")+SC5->C5_XPORIG,"YA_DESCR")), ofont10a, 100 )//* esto va al lado de observaciones
endif

oPrn:Say( nLine, 1800, If( lEnd, IF(lExterior,"SALE AMOUNT:","TOTAL: "), "TRANSPORTE:  " ), ofont10a/*oFont8*/, 100 )     
/*se agrego valor de impuestos
 DbSelectArea( "SF2" )
 DbSeek( xFilial() + cliente + loja + doc + serie )                      
 oPrn:Say( nLine+50 ,1800,Transform( SF2->F2_VALIMP1, '@E 999,999.99'), oFont, 100 )	// IVA   10.50%
 oPrn:Say( nLine+150 ,1800,Transform( SF2->F2_VALIMP2, '@E 999,999.99'), oFont, 100 )	// IVA   21.00%

 oPrn:Say( nLine+200 ,1800,Transform( SF2->F2_VALIMP5, '@E 999,999.99'), oFont, 100 )	// Perc IIBB  CF
 oPrn:Say( nLine+250,1800,Transform( SF2->F2_VALIMP6, '@E 999,999.99'), oFont, 100 )	// Perc IIBB  BS AS
*/ 
	
oPrn:Say( nLine, 2050, cSigno + TransForm( nSubTot, PesqPict( "SC6", "C6_VALOR" ) ), oFont8, 100 )
nLine += 50

If lExterior
	oPrn:Say( nLine, 0100, "Cond. de Venta: " + SC5->C5_TPFRETE, ofont10a, 100 )
	nLine += 50
   
   //	oPrn:Say( nLine, 1000, "Pais Adquisicion: "+AllTrim(Posicione("SYA",1,xFilial("SYA")+SC5->C5_XPADQ,"YA_DESCR")), ofont10a, 100 )
   //	nLine += 50*/
   // EndIf


   //oPrn:Say( nLine, 0100, "Forma de Pago: "+_descCond, ofont10a, 100 )
   //If lExterior
   
   	oPrn:Say( nLine, 1000, "Pais Procedencia: "+AllTrim(Posicione("SYA",1,xFilial("SYA")+SC5->C5_XPPRO,"YA_DESCR")), ofont10a, 100 )
EndIf
nLine += 50

cTransp :=  POSICIONE("SA4",1,XFILIAL("SA4")+SC5->C5_TRANSP,"A4_NOME")

//* lagonegro inicio
oPrn:Say( nLine, 0100, "Transporte:   "+cTransp+"              (*) ARTICULOS SIN STOCK     ", ofont10a, 100 )
//* lagonegro fin
If lExterior
	oPrn:Say( nLine, 1000, "PESO NETO: "+TransForm(SC5->C5_PESOL, PesqPict("SC5","C5_PESOL")), ofont10a, 100 )
EndIf

nLine += 50

If lExterior
   //	oPrn:Say( nLine, 0100, "Fecha Embarque: "+DTOC(SC5->C5_XFEMB), ofont10a, 100 )
	oPrn:Say( nLine, 1000, "PESO BRUTO: "+TransForm(SC5->C5_PBRUTO, PesqPict("SC5","C5_PBRUTO")), ofont10a, 100 )
	//oPrn:Say( nLine, 1550, "Pallets: "+TransForm(SC5->C5_XPALET, PesqPict("SC5","C5_XPALET")), ofont10a, 100 )
	nLine += 50
	//oPrn:Say( nLine, 0100, "Puerto Embarque: "+Posicione("ZZF",1,xFIlial("ZZF")+SC5->C5_XPEMB,"ZZF_DESCRI"), ofont10a, 100 )
	//oPrn:Say( nLine, 1000, "Puerto Desembarque: "+Posicione("ZZF",1,xFIlial("ZZF")+SC5->C5_XPDES,"ZZF_DESCRI"), ofont10a, 100 )
else
	//oPrn:Say( nLine, 0100, "LUGAR DE ENTREGA: " + alltrim(cDireEnt) + " (" +  AllTrim(cCPEnt) + ") " + Alltrim(cProvEnt), ofont10a, 100 )
    oPrn:Say( nLine, 0100, "LUGAR DE ENTREGA: " + SC5->C5_XENDENT, ofont10a, 100 ) 
    nLine += 30
    oPrn:Say( nLine, 0100, "HORA PEDIDO     : " + SC5->C5_XHORA, ofont10a, 100 )
    nLine += 30
	oPrn:Say( nLine, 0100, "FRANJA HORARIA  : " + IF(SC5->C5_XFRANJA=='1','MAÑANA',IF(SC5->C5_XFRANJA=='2','TARDE','INDISTINTA')), ofont10a, 100 )
    nLine += 30
	oPrn:Say( nLine, 0100, "NOTA            : " + SC5->C5_MENNOTA, ofont10a, 100 )
    nLine += 30
	oPrn:Say( nLine, 0100, "EMITIO          : " +UsrFullName(retcodusr()), oFont8, 100 )
EndIf
oPrn:Say( LASTLINE - 50, 0100, "DOCUMENTO SIN VALOR COMERCIAL", oFont8b, 100 )
oPrn:EndPage()

RETURN NIL

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PVtaAprob( lGenBlock )

LOCAL cAlias   := Alias(), ;
nOrder   := IndexOrd(), ;
nRecNo   := RecNo(), ;
lFact    := .f., ;
lEntr    := .f., ;
lBlqC    := .f., ;
lBlqS    := .f., ;
lLib	 := .f.,;
nQEnt    := 0, ;
nQApr    := 0, ;
cTipoBlq := Space( 0 )

DbSelectArea( "SC9" )
DbSetOrder( 1 )
IF !DbSeek( xFilial() + SC6->C6_NUM + SC6->C6_ITEM )
	IF lGenBlock
		AAdd( aPedBloq , { SC6->C6_NUM, SC6->C6_ITEM, ;
		SA1->A1_COD + "-" + Left( AllTrim( SA1->A1_NOME ), 25 ), SA1->A1_LC, ;
		DToC( SC5->C5_EMISSAO ), "Sin Aprob.", SC6->C6_PRODUTO, SC6->C6_QTDVEN, 0, ;
		0, SC6->C6_VALOR } )
	ENDIF
ENDIF

WHILE !EoF() .AND. ;
	( SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_ITEM ) == ( C9_FILIAL + C9_PEDIDO + C9_ITEM )

	IF !Empty( C9_REMITO ) .AND. Empty( C9_NFISCAL )      // Ent. s/Fc.
		cTipoBlq   := "Ent. s/Fc."
		lEntr      := .t.
		nQEnt      += C9_QTDLIB
	ELSEIF !Empty( C9_REMITO ) .AND. !Empty( C9_NFISCAL ) // Ent.y Fact.
		cTipoBlq   := "Ent.y Fact."
		lFact := .t.
		lEntr := .t.
		nQEnt += C9_QTDLIB
	ELSEIF Empty( C9_REMITO ) .AND. !Empty( C9_NFISCAL )  // Fact.
		cTipoBlq   := "Fact. s/Ent."
		lFact := .t.
		lEntr := .t.
		nQEnt += C9_QTDLIB
	ELSEIF !Empty( C9_BLCRED ) .AND. !Empty( C9_BLEST )   // Créd./Stk.
		cTipoBlq   := "Créd./Stk."
		lBlqC := .t.
		lBlqS := .t.
	ELSEIF !Empty( C9_BLCRED ) .AND. Empty( C9_BLEST )    // Crédito
		cTipoBlq   := "Crédito"
		lBlqC := .t.
	ELSEIF Empty( C9_BLCRED ) .AND. !Empty( C9_BLEST )    // Stock
		cTipoBlq   := "Stock"
		lBlqS := .t.
		nQApr += C9_QTDLIB
	ELSEIF Empty( C9_BLCRED ) .AND. Empty( C9_BLEST ) .and. Empty( C9_REMITO ) .AND. Empty( C9_NFISCAL )  //liberados por entregar  
		lLib := .T.
	ELSE
		nQApr += C9_QTDLIB
	ENDIF

	IF lGenBlock .AND. !Empty( cTipoBlq )
		AAdd( aPedBloq , { SC6->C6_NUM, SC6->C6_ITEM, ;
		SA1->A1_COD + "-" + Left( AllTrim( SA1->A1_NOME ), 25 ), SA1->A1_LC, ;
		DToC( SC5->C5_EMISSAO ), cTipoBlq, SC6->C6_PRODUTO, SC6->C6_QTDVEN, ;
		nQEnt, nQApr, SC6->C6_VALOR } )
	ENDIF

	DbSkip()

ENDDO

DbSelectArea( cAlias )
DbSetOrder( nOrder )
DbGoTo( nRecNo )

RETURN { lFact, lEntr, lBlqC, lBlqS, nQEnt, nQApr, lLib }


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrintLeyen ºAutor  ³MS				ºFecha ³  16-11-07    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Resumen	 Leyendas			                              º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION PrintLeyen()

oPrn:SetPortrait()
nLine := nX := 0
nLineas := 56
lImpre := .T.
if len(aMemo1)+	len(aMemo2)+len(aMemo3)+len(aMemo4)+len(aMemo5)+len(aMemo6)+len(aMemo7)+;
				len(aMemo8)+len(aMemo9)+len(aMemo10) > 0 .and. 	mv_par04 == 1 // imprime anexo leyendas?
	
	FOR nx := 1 TO 10
  	
    	// LEYENDAS
		IF LEN (&("Amemo"+AllTrim(str(nX)))) > 0
			nLine += 50
			FOR nIdx := 1 TO Len(&("Amemo"+AllTrim(str(nX))))
                if nLineas > 55
                	oPrn:StartPage()       		      
	                TitLey( lImpre )
	                lImpre := .F.
	                nLineas:= 0
	            endif
      			IF !Empty( &("Amemo"+AllTrim(str(nX)))[nIdx] )
        			oPrn:Say( nLine,0100,&("Amemo"+AllTrim(str(nX)))[nIdx], oFont9, 100 )
      				nLine += 50
      				nLineas += 1
      			ENDIF
      			if nLineas > 55
                	oPrn:EndPage()       		      
                endif   
			NEXT
		ENDIF	
	NEXT
	oPrn:EndPage()       		      
endif

RETURN NIL

/*-------------------------------------------------------------------------------------------------------*/

STATIC FUNCTION TitLey( lFirstPage )

IF lFirstPage
   oPrn:StartPage()       
ENDIF
nPagina := 0
nPagina += 1

nLine := 50    

oPrn:Say( nLine, 0100, " ", oFont8, 100 )

IF !Empty( GetMV( "MV_DIRLOGO" ) )
	IF File( AllTrim( GetMV( "MV_DIRLOGO" ) ) ) 
	    //.AND. MV_PAR09=1
		//oPrn:Box( nLine, 0050, nLine + 400, NMARGDERECHO ) //Cuadro de encabezado.
		nLine += 10
		oPrn:SayBitmap( nLine + 20, 0100, AllTrim( GetMV( "MV_DIRLOGO" ) ) , 600, 150 )
     	//oPrn:Say( nLine + 200, 0300, AllTrim( SM0->M0_NOMECOM ), oFont10a, 100 )
	ELSE
		nLine += 10
	ENDIF
endif


nLine := 300

oPrn:Say( nLine, 0100, " ", ofont10a, 100 )
//oPrn:Box( nLine, 0050, 370, 2300 )
nLine += 50

//oPrn:Say( nLine, 0100, SM0->M0_NOME, oFont12a, 100 )
//oPrn:Say( nLine, 1900, "Pagina: " + AllTrim( Str( nPagina ) ), ofont10, 100 )
nLine += 50

oPrn:Say( nLine, 0100, "MP10/Anexo Pedido de Ventas: "+Right( SC5->C5_NUM, 6 )  , oFont12a, 100 )
//oPrn:Say( nLine, 1900, "Emision: " + DToC( ddatabase ), ofont10, 100 )
oPrn:Say( nLine, 1600, "Fecha: "+DToC( SC5->C5_EMISSAO ), oFont10a, 100 )
nLine += 90
RETURN NIL




/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION ValidPerg( cPerg )

LOCAL cAlias := Alias(), ;
aRegs  := {}, ;
i, ;
j

DbSelectArea( "SX1" )
DbSetOrder( 1 )

cPerg := PadR( cPerg, 10 )

AAdd( aRegs, { cPerg, "01", "Desde Pedido ?     ", "Desde Pedido ?     ", "Desde Pedido ?     ", "mv_ch1", "C", 6, 00, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC5","","" } )
AAdd( aRegs, { cPerg, "02", "Hasta Pedido ?     ", "Hasta Pedido ?     ", "Hasta Pedido ?     ", "mv_ch2", "C", 6, 00, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC5","","" } )
AAdd( aRegs, { cPerg, "03", "No. copias?        ", "No. copias?        ", "No. copias?        ", "mv_ch3", "N", 3, 00, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "04", "Anexo de Leyendas? ", "Anexo de Leyendas? ", "Anexo de Leyendas? ", "mv_ch4", "N", 1, 00, 0, "C", "", "mv_par04", "Si", "Si", "Si", "", "", "No", "No", "No", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "05", "Imprimir         ? ", "Imprimir         ? ", "Imprimir         ? ", "mv_ch5", "N", 1, 00, 0, "C", "", "mv_par05", "Todos", "Todos", "Todos", "", "", "Pendientes", "Pendientes", "Pendientes", "", "", "Aprobados", "Aprobados", "Aprobados", "", "", "Bloqueados", "Bloqueados", "Bloqueados", "", "", "Entreg. o Fact.", "Entreg. o Fact.", "Entreg. o Fact.", ""  ,"","","" } )
AAdd( aRegs, { cPerg, "06", "Desde Cliente ?    ", "Desde Cliente ?    ", "Desde Cliente ?    ", "mv_ch6", "C", 11, 00, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA1","","" } )
AAdd( aRegs, { cPerg, "07", "Hasta Cliente ?    ", "Hasta Cliente ?    ", "Hasta Cliente ?    ", "mv_ch7", "C", 11, 00, 0, "G", "", "mv_par07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA1","","" } )
AAdd( aRegs, { cPerg, "08", "Desde Vendedor ?   ", "Desde Vendedor ?   ", "Desde Vendedor ?   ", "mv_ch8", "C", 6, 00, 0, "G", "", "mv_par08", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA3","","" } )
AAdd( aRegs, { cPerg, "09", "Hasta Vendedor ?   ", "Hasta Vendedor ?   ", "Hasta Vendedor ?   ", "mv_ch9", "C", 6, 00, 0, "G", "", "mv_par09", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA3","","" } )
AAdd( aRegs, { cPerg, "10", "Desde Producto ?   ", "Desde Producto ?   ", "Desde Producto ?   ", "mv_ch0", "C",20, 00, 0, "G", "", "mv_par10", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1","","" } )
AAdd( aRegs, { cPerg, "11", "Hasta Producto ?   ", "Hasta Producto ?   ", "Hasta Producto ?   ", "mv_chA", "C",20, 00, 0, "G", "", "mv_par11", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1","","" } )
AAdd( aRegs, { cPerg, "12", "Previsualizacion?  ", "Previsualizacion?  ", "Previsualizacion?  ", "mv_chB", "N", 1, 00, 0, "C", "", "mv_par12", "Si", "Si", "Si", "", "", "No", "No", "No", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
FOR i := 1 TO Len( aRegs )

	IF !DbSeek( cPerg + aRegs[i,2] )

		RecLock( "SX1", .t. )

		FOR j := 1 TO FCount()

			IF j <= Len( aRegs[i] )
				FieldPut( j, aRegs[i,j] )
			ENDIF

		NEXT

		MsUnlock()

	ENDIF

NEXT

DbSelectArea( cAlias )

RETURN