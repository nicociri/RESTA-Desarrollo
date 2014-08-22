#include "protheus.ch"                                                                                                          
#include "totvs.ch"
// #include "RWMAKE.ch"

#define nTop            50
#define nLef            0                                                                                                      
#define DETAILBOTTOM    2350                                                                                                                        
#define CURTEXTLINE     2700
#define TOTLINE         2800
#define TEXTBEGINLINE   2200                                                                                                   
#define CAILINE         2950
#define NUMCOPY         {"ORIGINAL","TRIPLICADO","AT.CLIENTES","QUINTUPLICADO","SEXTUPLICADO","COPIA 7","COPIA 8","COPIA 9","COPIA 10"}
#define NUMCOPY2        {"ORIGINAL","DUPLICADO","TRIPLICADO","CUADRUPLICADO","QUINTUPLICADO","SEXTUPLICADO","COPIA 7","COPIA 8","COPIA 9","COPIA 10"}
#define TXTCAMB1        "A fines fiscales el tipo de cambio utilizado es de: "
#define TXTCAMB2        " Siendo el neto "
#define TXTCAMB3        " , el I.V.A "
#define TXTCAMB4        " y PerIIBB. "

User Function DREMKL(CNUM,CSERIE)

Private lPrinted  	:= .F.,;
		esCopia     := .F.,;
      	nHoja       := 0,; 
		cRemNota    := Space( 0 ), ;
		cPerg       := 'ECREML',;
      	cPedidos    := '',;
      	cRemitos    := '',;
      	nD2Custo1   := 0,;
		cNroPedido  := '',; 
		NCOPIAS 	:= 1
              
Private cNumFact
Private cNumDoc 
Private cEspecie

Default cEspecie  := "RFD"

IF CSERIE == NIL
//!(FunName() $ "MATA462AN")

   ValidPerg( cPerg )
   
   If Pergunte( cPerg, .T. )
      RptStatus( { || SelectComp() } )
   EndIf

Else
   MV_PAR01:=CSERIE
   MV_PAR02:=CNUM
   MV_PAR03:=CNUM
   MV_PAR04:=1
   MV_PAR05:=1
   MV_PAR06:=1   
   RptStatus( { || SelectComp() } )
Endif


Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³  ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SelectComp()
Local   nCopies  := 0       
//Local cGrpReimpr := GetMV("MV_GRPRPRN")
Private nLine    := 0,;
        cDocum   := Space( 0 ),;
        oPrn     := TMSPrinter():New(),;
        oFontL   := TFont():New( "Courier New"      ,, 12,, .T.,,,,, .f. ),;
        oFont    := TFont():New( "Courier New"      ,, 10,, .f.,,,,, .f. ),;
        oFont1   := TFont():New( "Courier New"      ,, 14,, .f.,,,,, .f. ),;
        oFont2   := TFont():New( "Arial"		    ,, 22,, .t.,,,,, .f. ),;
        oFont3   := TFont():New( "Courier New"      ,, 08,, .f.,,,,, .f. ),;
		oFont4   := TFont():New( "Courier New"      ,, 14,, .t.,,,,, .f. ),;
		oFont5   := TFont():New( "Courier New"      ,, 8,, .f.,,,,,  .f. ),;
		oFontTit := TFont():New( "Arial"			,, 14,,	.F.,,,,,,.f. ),;
		oFont6	 := TFont():New( "Courier New"		,, 08,, .t.,,,,,,.f. ),;
		oFont7	 := TFont():New( "Arial"			,, 07,, .f.,,,,,,.f. ),;
		oFontN   := TFont():New( "Courier New"      ,, 10,, .T.,,,,, .f. ),;
		oFontF   := TFont():New( "Courier New"      ,, 08,, .T.,,,,, .f. ),;
        oFontB   := TFont():New( "Courier New"      ,, 12,, .t.,,,,, .f. )
		


oPrn:Setup()


DbSelectArea( "SA1" )
DbSetOrder( 1 )
DbSelectArea( "SA2" )
DbSetOrder( 1 )
DbSelectArea( "SC6" )
DbSetOrder( 1 )
DbSelectArea( "SE4" )
DbSetOrder( 1 )
DbSelectArea( "SA3" )
DbSetOrder( 1 )
DbSelectArea( "SA4" )
DbSetOrder( 1 )
DbSelectArea( "SB1" )
DbSetOrder( 1 )
DbSelectArea( "SYA" )
DbSetOrder( 1 )
DbSelectArea( "SB8" )
DbSetOrder( 3 )
DbSelectArea( "SC5" )
DbSetOrder( 1 )
DbSelectArea( "SE1" )
DbSetOrder( 1 )
DbSelectArea( "SF2" )
DbSetOrder( 1 )
DbSelectArea( "SF1" )
DbSetOrder( 1 )
DbSelectArea( "SF4" )
DbSetOrder( 1 )
DbSelectArea( "SD2" )
DbSetOrder( 3 )
DbSelectArea( "SD1" )
DbSetOrder( 1 )

If mv_par06 == 0
   mv_par06 := 1
EndIf

   DbSelectArea( "SF1" )
   DbSeek( xFilial() + mv_par02 + mv_par01 , .t. )

   While !Eof() .and. F1_FILIAL+F1_DOC+F1_SERIE <= xFilial()+mv_par03+mv_par01
      esCopia := .F.
      If  ALLTRIM(F1_ESPECIE) $ cEspecie
         If Alltrim(F1_SERIE) != Alltrim(mv_par01)
            DbSkip()
            Loop
         EndIf
     
         PrintComp( F1_ESPECIE )
      EndIf
	  DbSelectArea( "SF1" )
      DbSkip()
   EndDo
//EndIf

If mv_par05 == 1
	oPrn:PreView()
Else
	oPrn:Print()
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Diego Fernando Rivero ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PrintComp( cEspecie )

Local nLenMemo := 0, ;
cMemo    := Space( 0 ), ;
nIdx     := 0, ;
nRecSD1  := 0


cNumFact:=''
cNumDoc:=''

Private aDescMon   := { GetMV( "MV_MOEDA1" ), GetMV( "MV_MOEDA2" ), GetMV( "MV_MOEDA3" ), GetMV( "MV_MOEDA4" ), GetMV( "MV_MOEDA5" ) }, ;
        aSimbMon   := { GetMV( "MV_SIMB1" ), GetMV( "MV_SIMB2" ), GetMV( "MV_SIMB3" ), GetMV( "MV_SIMB4" ), GetMV( "MV_SIMB5" ) }, ;
        cMoneda    := Space( 0 ), ;
        cSigno     := Space( 0 ), ;
        aMemo      := Array( 0 ), ;
        aPedidos   := Array( 0 ), ;
        aFactura   := Array( 0 ), ;
        aOCompras  := Array( 0 ), ;
        aDespachos := Array( 0 ), ;
        cMenNota   := Space( 0 ), ;
        cProvincia := Space( 0 ), ;
        cSitIVA    := Space( 0 ), ;
        cDepProc   := Space( 0 ), ;
        cLugEnt    := Space( 0 ), ;
        nMoeda     := 0, ;
        nSeguro    := 0, ;
        nBultos    := 0, ;
        nValmerc   := 0, ;
        aDriver    := ReadDriver(), ;
        nCotiz     := 0 , ;
        cNomVend   := " ", ;
        cVend      := " ", ;
        dFecVto    := ctod('  /  /  ')
		cXOC :=  ""

    If ALLTRIM(cEspecie)=="RFD"
    	nMoeda   := SF1->F1_MOEDA	  
		cMoneda  := aDescMon[ If( Empty( SF1->F1_MOEDA ), 1, SF1->F1_MOEDA ) ]
		cSigno   := aSimbMon[ If( Empty( SF1->F1_MOEDA ), 1, SF1->F1_MOEDA ) ]

		DbSelectArea( "SE2" )                                  //ripley
		DbSeek( xFilial('SE2') + SF1->F1_SERIE + SF1->F1_DOC )
		While !Eof() .and. ( E2_FILIAL + E2_PREFIXO + E2_NUM ) == ;
			( xFilial('SF1') + SF1->F1_SERIE + SF1->F1_DOC )
			If E2_TIPO == Left( cEspecie, 3 )
				nCotiz := ( E2_VLCRUZ / E2_VALOR )
			EndIf
				dFecVto    := E2_VENCTO
			DbSkip()
		EndDo		
    
    	DbSelectArea( "SA1" )
		DbSeek( xFilial( "SA1" ) + SF1->F1_FORNECE + SF1->F1_LOJA )
		_CodClie	:=	SA1->A1_COD
		_NomClie	:=	SA1->A1_NOME
		_EndClie	:=	SA1->A1_END
		_MunClie	:=	SA1->A1_MUN
		_TipClie	:=	SA1->A1_TIPO
		_CepClie	:=	SA1->A1_CEP
		_CgcClie	:=	SA1->A1_CGC
		_EstClie	:=	SA1->A1_EST
		_PaiCLie	:=	SA1->A1_PAIS
    	_CosProv := SA1->A1_CODFOR
	
	
	DbSelectArea( "SX5" )
	DbSeek( xFilial() + "12" + _EstClie )
	cProvincia := AllTrim( X5_DESCRI )

	DbSeek( xFilial() + "SF" + _TipClie )
	cSitIVA := AllTrim( X5_DESCSPA )

	DbSelectArea( "SYA" )
	DbSeek( xFilial() + _PaiCLie )

	DbSelectArea( "SE4" )
	DbSeek( xFilial() + SF1->F1_COND )

	DbSelectArea( "SA3" )
	DbSeek( xFilial() + SF1->F1_VEND1 )
	cVend    := SA3->A3_COD
	cNomVend := SA3->A3_NOME
    
///////////////////////////////////////////////////////////
	DbSelectArea( "SD1" )
	DbSeek( SF1->F1_FILIAL + SF1->F1_DOC+ SF1->F1_SERIE +SF1->F1_FORNECE + SF1->F1_LOJA )
	nRecSD1  := Recno()
 //   cXOC := POSICIONE("SC5",1,xfilial("SC5")+SD1->D1_PEDIDO, "C5_XOC")

   While !Eof() .and. ( SF1->F1_FILIAL + SF1->F1_DOC+ SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ) == ;
                      ( D1_FILIAL + D1_DOC+ D1_SERIE +D1_FORNECE + D1_LOJA )

		If SF1->F1_ESPECIE != D1_ESPECIE
			DbSkip()
			Loop
		EndIf

//		_cFactura := TraeFactura()
//		If Empty( AScan( aFactura, Alltrim(_cFactura) ) )
//			AAdd( aFactura, Alltrim(_cFactura) )
//		EndIf
        /*
		If !Empty( D2_PEDIDO )
			If Empty( AScan( aPedidos, D2_PEDIDO ) )
				AAdd( aPedidos, D2_PEDIDO )
			EndIf
			cNumDoc := POSICIONE("SC5",1,xfilial("SC5")+SD2->D2_PEDIDO, "C5_XNFSER+C5_XNFDOC")
            if !empty(cNumDoc) .and. !(cNumdoc $ cNumFact)
            	cNumFact += cNumDoc + '/'
            endif
		EndIf
		*/
//		If Len( cNumFact ) > 0
//      		cNumFact := SubStr( cNumFact, 1, Len(cNumFact) - 1 )
//	    EndIf

		If !(D1_Local $ cDepProc)
			cDepProc += If( !Empty( cDepProc ), "/", "" ) + D1_Local
		EndIf

		DbSkip()
	EndDo

	DbGoTo( nRecSD1 )

   cOcomp   := " "
   AEval( aPedidos,  { |a| cOcomp  += If( !Empty( cOcomp ),  "/", "" ) + AllTrim( a ) } )

	DbSelectArea( "SF1" )

	nLenMemo := MLCount( cMemo, 125 )

	For nIdx := 1 TO nLenMemo
		AAdd( aMemo, MemoLine( cMemo, 125, nIdx ) )
	Next

   	For nCopies := 1 TO mv_par04
		PrintHead( cEspecie, nCopies )
		PrintItem( cEspecie )
		PrintFoot( cEspecie, nCopies )
	Next

EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Diego Fernando Rivero ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PrintHead( cEspecie, nCopyNum )
Local cFILIAL := Alltrim(SF1->F1_FILIAL)
Local nx := 0
If !lPrinted
   lPrinted := .t.
Else
   oPrn:StartPage()
EndIf                                                   

If nCopyNum > 6
	For n = 1 to nCopyNum - 6
		Aadd( NUMCOPY, "COPIA " + StrZero( nCopyNum, 2 ) )
	Next n
EndIf

oPrn:SayBitmap( 0250, 1822, "\logos\resta.bmp", 426, 148 )

// Impresion de Cuadros de Cabecera

//oPrn:Box( 850, 050, 2750, 2400 )  // Detalle

/*
oPrn:Say( nTop+0180, nLef+110, 'SUCESORES DE DOMINGO RESTA Y CIA S.A.'	         	, oFontL, 100 )
oPrn:Say( nTop+0260, nLef+110, 'DR. LUIS BELAUSTEGUI 3925'			         	, oFont , 100 )
oPrn:Say( nTop+0300, nLef+110, 'C.P.: (1407) C.A.B.A.'	         	, oFont , 100 )
oPrn:Say( nTop+0340, nLef+110, 'Tel.: (5411) 4568-9150'  			         	, oFont , 100 )
oPrn:Say( nTop+0380, nLef+110, 'Fax.: (5411) 4568-9150'			            	, oFont , 100 )
*/
DO CASE
   CASE CFILIAL == "01"
oPrn:Say( nTop+0180, nLef+110, 'SUCESORES DE DOMINGO RESTA Y CIA S.A.'	         		, oFontL, 200 )
oPrn:Say( nTop+0260, nLef+110, 'DR. LUIS BELAUSTEGUI 3925'			         	, oFont, 100 )
oPrn:Say( nTop+0300, nLef+110, 'C.P.: (1407) C.A.B.A.'	           			, oFont, 100 )
oPrn:Say( nTop+0340, nLef+110, 'Tel.: (5411) 4568-9150'			         	, oFont, 100 )
oPrn:Say( nTop+0380, nLef+110, 'Fax.: (5411) 4568-9150'			         	, oFont, 100 )
   CASE CFILIAL == "02"
oPrn:Say( nTop+0180, nLef+110, 'SUCESORES DE DOMINGO RESTA Y CIA S.A.'	         		, oFontL, 200 )
oPrn:Say( nTop+0260, nLef+110, 'GAONA 4292'			         	, oFont, 100 )
oPrn:Say( nTop+0300, nLef+110, 'C.P.: (1407) C.A.B.A.'	           			, oFont, 100 )
oPrn:Say( nTop+0340, nLef+110, 'Tel.: (5411) 4671-8681'			         	, oFont, 100 )
//oPrn:Say( nTop+0380, nLef+110, 'Fax.: (5411) 4568-9150'			         	, oFont, 100 )
   CASE CFILIAL == "03"
oPrn:Say( nTop+0180, nLef+110, 'SUCESORES DE DOMINGO RESTA Y CIA S.A.'	         		, oFontL, 200 )
oPrn:Say( nTop+0260, nLef+110, 'AV.LA PLATA 568'			         	, oFont, 100 )
oPrn:Say( nTop+0300, nLef+110, 'C.P.: (1235) C.A.B.A.'	           			, oFont, 100 )
oPrn:Say( nTop+0340, nLef+110, 'Tel.: (5411) 4983-4792'			         	, oFont, 100 )
   CASE CFILIAL == "04"
oPrn:Say( nTop+0180, nLef+110, 'SUCESORES DE DOMINGO RESTA Y CIA S.A.'	         		, oFontL, 200 )
oPrn:Say( nTop+0260, nLef+110, 'AV.CASTEX 642 - CANNING'			         	, oFont, 100 )
oPrn:Say( nTop+0300, nLef+110, 'C.P.: (1807) - BS.AS.'	           			, oFont, 100 )
oPrn:Say( nTop+0340, nLef+110, 'Tel.: (5411) 4232-9777'			         	, oFont, 100 )
ENDCASE

oPrn:Say( nTop+0420, nLef+110, 'E-mail: '		         	, oFont , 100 )
oPrn:Say( nTop+0460, nLef+110, 'Website: http://www.sanitariosresta.com.ar'			         	, oFont , 100 )
oPrn:Say( nTop+0510, nLef+110, 'IVA RESPONSABLE INSCRIPTO'			         	, oFont , 100 )
oPrn:Say( nTop+0460, nLef+1698, 'C.U.I.T.: 30-67608106-9'						, oFont3, 100 )
oPrn:Say( nTop+0490, nLef+1698, 'Ingresos Brutos: CM 901-157512-1'				, oFont3, 100 )
oPrn:Say( nTop+0520, nLef+1698, 'Inicio de Actividades: 01/04/1995'				, oFont3, 100 )	

oPrn:Say( nTop+0550, nLef+1250, 'N CLIENTE'										, oFontN, 100 )
oPrn:Say( nTop+0550, nLef+1500, 'N FACTURA'									, oFontN, 100 )
oPrn:Say( nTop+0550, nLef+1800, 'N REMITO '										, oFontN, 100 )
oPrn:Say( nTop+0550, nLef+2100, 'HOJAS'											, oFontn, 100 )	

oPrn:Say( nTop+0670, nLef+1250, 'ORDEN DE COMPRA'								, oFontn, 100 )
oPrn:Say( nTop+0670, nLef+1800, 'RESPONSABLE'									, oFontn, 100 )

oPrn:Say( nTop+0790, nLef+1250, 'PEDIDO'										, oFontn, 100 )
oPrn:Say( nTop+0900, nLef+1550, 'DIRECCION DE ENTREGA'							, oFontn, 100 )
oPrn:Say( nTop+0900, nLef+0400, 'DIRECCION DEL TRANSPORTE'						, oFontn, 100 )

oPrn:Say( nTop+0600, nLef+1280, Alltrim(SF1->F1_FORNECE)						, oFontF, 100 )
oPrn:Say( nTop+0600, nLef+1500, Alltrim(cNumFact)								, oFontF, 100 )
oPrn:Say( nTop+0600, nLef+1780, SF1->F1_DOC										, oFontF, 100 )
oPrn:Say( nTop+0600, nLef+2110, StrZero( nHoja, 3 ) 							, oFont, 100 )

//oPrn:Say( nTop+0720, nLef+1300, posicione("SC5",1,xFilial("SC5")+substr(cPedidos,1,6),"C5_XOC")	, oFont, 100 )



//oPrn:Say( nTop+0720, nLef+1250,posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CONTATO") , oFont, 100 )

cCon:=posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_CONTATO") 
nFin:=len(cCon)                                                                   
if nFin>31
  oPrn:Say( nTop+0700, nLef+1600, substr(cCon,1,31)	, oFont, 100 )   
  oPrn:Say( nTop+0732, nLef+1600,alltrim(substr(cCon,32,nFin))	, oFont, 100 )  
else                                                               
    Prn:Say( nTop+0720, nLef+1600, cCon	, oFont, 100 ) 
endif        


// Condicion de Pago
//If mv_pr04 < 3
	oPrn:Say( nTop+0820, nLef+1250/*nLef+1250*/, substr(cPedidos,1,6), oFont, 100 )
//EndIf

   oPrn:Say( nTop+180, nLef+1180, Substr(SF1->F1_SERIE,1,1)	, oFont2, 100 )

// Codigo Factura
If	ALLTRIM(cEspecie) $ cEspecie .and. Substr(SF1->F1_SERIE,1,1) == 'R'
//   oPrn:Say( nTop+290, nLef+1125, 'Codigo N°91'	, oFont3, 100 )
EndIf

		
 // Tipo Comprobante			 
If	ALLTRIM(cEspecie) $ "RFD"
		oPrn:Say( nTop+0180, nLef+1440/*nTop+320, nLef+850*/, 'DOCUMENTO NO VÁLIDO COMO FACTURA'	, oFont, 100 )
		oPrn:Say( nTop+350, nLef+1500, 'REM.DEV.'	, oFontB, 100 )
		oPrn:Say( nTop+350, nLef+1120, NUMCOPY2[nCopyNum]		, oFontN, 100 )                                                                                   
EndIf

oPrn:Say( nTop+350, nLef+1660, '  Nº:' + Left( SF1->F1_DOC, 4 ) + "-" + Right( SF1->F1_DOC, 8 )	, oFontB, 100 )
oPrn:Say( nTop+400, nLef+1660, '  FECHA: ' + DToC( SF1->F1_EMISSAO ), oFont, 100 )

// Datos Cliente
	oPrn:Say( nTop+580, nLef+0110, AllTrim( SA1->A1_NOME ) , oFontN, 100 )
	oPrn:Say( nTop+650, nLef+0110, AllTrim( SA1->A1_END ), oFont, 100 )
	oPrn:Say( nTop+700, nLef+0110, "C.P.: " + AllTrim( SA1->A1_CEP ) + " Tel.: " + Left(AllTrim( SA1->A1_TEL ),12), oFont, 100)
//	oPrn:Say( nTop+700, nLef+0110, Alltrim( SA1->A1_MUN ) + "    C.P.: " + AllTrim( SA1->A1_CEP ) + " Tel.: " + Left(AllTrim( SA1->A1_TEL ),12), oFont, 100)
	oPrn:Say( nTop+750, nLef+0110, If( SA1->A1_TIPO != "E",If(!Empty( cProvincia ),cProvincia,"" ),"   Pais: " + AllTrim( SYA->YA_DESCR ) ), oFont, 100 )
	oPrn:Say( nTop+800, nLef+0110, 'I.V.A.: ' + cSitIVA, oFont, 100 )
	oPrn:Say( nTop+850, nLef+0110, 'C.U.I.T.: ' + Subst(SA1->A1_CGC,1,2)+'-'+Subst(SA1->A1_CGC,3,8)+'-'+Subst(SA1->A1_CGC,11,1), oFont, 100 )
	// Direccion de Entrega
	
	//oPrn:Say( nTop+930, nLef+1250, AllTrim( SA1->A1_ENDENT)								, oFont, 100 )
	//oPrn:Say( nTop+930, nLef+1250, AllTrim( SF1->F1_XENDENT)								, oFont, 100 )
	oPrn:Say( nTop+970, nLef+1250, AllTrim( SA1->A1_MUNE)	+ ' ' + AllTrim( SA1->A1_MUNE)	, oFont, 100 )
	oPrn:Say( nTop+1010, nLef+1250, ''														, oFont, 100 )
	oPrn:Say( nTop+1050, nLef+1250, ''														, oFont, 100 )
	

// Direccion de Transporte
If AllTrim( cEspecie ) <> 'RFD'
	cTransp := posicione("SC5",1,xFilial("SC5")+substr(cPedidos,1,6),"C5_TRANSP")
	
	// oPrn:Say( nTop+930, nLef+0120, Posicione('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_NOME')	, oFont, 100 )
	oPrn:Say( nTop+930, nLef+0120, Posicione('SA4',1,xFilial('SA4')+CTRANSP,'A4_NOME')	, oFont, 100 )
	oPrn:Say( nTop+970, nLef+0120, Posicione('SA4',1,xFilial('SA4')+CTRANSP,'A4_END')	, oFont, 100 )
	oPrn:Say( nTop+1010, nLef+0120, Posicione('SA4',1,xFilial('SA4')+CTRANSP,'A4_MUN')	, oFont, 100 )
	// oPrn:Say( nTop+1050, nLef+0120, Posicione('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_PROV')	, oFont, 100 )
EndIf	

	nMasLine:= 1080


// Datos Cabecera Detalle

oPrn:Say( nTop+1300, nLef+130, 'CODIGO'										, oFontN, 100 )
oPrn:Say( nTop+1300, nLef+300, 'COD CLIENTE'								, oFontN, 100 )
oPrn:Say( nTop+1300, nLef+600, 'DESCRIPCION PRODUCTO'						, oFontN, 100 )
oPrn:Say( nTop+1300, nLef+1230, 'UM'										, oFontN, 100 )
oPrn:Say( nTop+1300, nLef+1380, 'LOTE'										, oFontN, 100 )
oPrn:Say( nTop+1300, nLef+1630, 'ENVASE'									, oFontN, 100 )
//oPrn:Say( nTop+1300, nLef+1880, 'PRECIO'									, oFont, 100 )
oPrn:Say( nTop+1300, nLef+2100, 'CANTIDAD'									, oFontN, 100 )


oPrn:Box( 200, 100, 600, 2300)		// Cuadro 1
oPrn:Box( 600, 100, 950, 2300)		// Cuadro 2
oPrn:Box( 950, 100, 1150, 2300)		// Cuadro 3
oPrn:Box( 1150, 100, 1320, 2300)	// Cuadro 4

oPrn:Box( 200, 1120, 320, 1280)		// Cuadro 1 Divisor de la letra de la factura
oPrn:Box( 600, 100, 1150, 1200)		// Cuadro 1 Divisor
oPrn:Box( 720, 1200, 840, 2300)		// Cuadro 2 Divisor
oPrn:Box( 1330, 100, 1400, 2300)	// Campos Detalle


Return NIL                                                                       


Static Function PrintItem( cEspecie )

Local nElem := 0, ;
nIdx        := 0, ;
nPos        := 0, ;
nPrecio	 	:=0, ;
nTotalBruto	:=0, ;
nTotalNeto	:=0, ;
cDespachos  := Space( 0 ), ;
aAux        := Array( 0 ), ;
aOrigenes   := Array( 0 ), ;
cOrigenes   := Space( 0 ), ;
cDescrip    := Space( 0 ), ;
cDescrip1   := Space( 0 ), ;
cDescrip2   := Space( 0 ), ;
lexedio     := .f., ;
cNUMDESP    := Space( 0 ), ;
cSerieSB8   := Space( 0 ), ;
cAduana     := Space( 0 ), ;
xDtValid    := Space( 0 ), ;
cStock      := Space( 0 ), ;
cOrigem     := Space( 0 ), ;
nSubTot     := .f., ;
aItems      := Array( 0 ), ;
xI          := 0,; 
xy			:=0,;
cCodCli		:= '',;
nQuant		:= 0,;
nPreco  	:= 0,;      
cEsserie    := Space( 0 )
                                 


//oPrn:Say( 1400, 110, 'CANT.', oFont, 100 )
//oPrn:Say( 1400, 260, 'CODIGO', oFont, 100 )
//oPrn:Say( 1400, 560, 'TITULO', oFont, 100 )
//oPrn:Say( 1400, 1260, 'PRECIO', oFont, 100 )

//oPrn:Say( 1400, 1510, 'TOTAL', oFont, 100 )
//oPrn:Say( 1430, 1510, 'BRUTO', oFont, 100 )

//oPrn:Say( 1400, 1760, 'DESCUENTO', oFont, 100 )
//oPrn:Say( 1430, 1760, '%', oFont, 100 )
//oPrn:Say( 1430, 1820, 'MONTO', oFont, 100 )

//oPrn:Say( 1400, 2090, 'TOTAL', oFont, 100 )
//oPrn:Say( 1430, 2090, 'NETO', oFont, 100 )

//If mv_par04 < 3

   DbSelectArea( "SD1" )
   DbSeek( SF1->F1_FILIAL + SF1->F1_DOC+ SF1->F1_SERIE +SF1->F1_FORNECE + SF1->F1_LOJA )

   While( ALLTRIM(cEspecie) $ "RFD" .AND. ;
         ( xFilial() + SF1->F1_DOC+ SF1->F1_SERIE +SF1->F1_FORNECE + SF1->F1_LOJA   ) == ;
         ( D1_FILIAL + D1_DOC+ D1_SERIE + D1_FORNECE + D1_LOJA  ) )

        
      DbSelectArea( "SB1" )
      DbSeek( xFilial() + SD1->D1_COD )
      If !Empty(SD1->D1_XDESCOD)
      	cDescrip := SD1->D1_XDESCOD
      Else
      	cDescrip := B1_DESC
      EndIF
      
      cEsserie := "R"
     
      DbSelectArea( "SD1" )
      
      nD2Custo1 := SD1->D1_CUSTO
      
      AAdd( aItems, ;
            { D1_COD , ;							//01 ** USADO
            D1_SEGUM,;                              //02
            D1_ITEM, ;								//03
            SB1->B1_DESC, ;							//04 ** USADO
            D1_QUANT, ;								//05 ** USADO
            D1_VUNIT, ;								//06
            D1_TOTAL, ;								//07 ** USADO
            0, ;							//08 ** USADO
            D1_DESC, ;								//09 ** USADO
            D1_VALIMP1, ;							//10
            D1_VUNIT, ;							//11
            Substr(SD1->D1_SERIE,1,1), ;			//12
            SB1->B1_CONV,;    						//13
            D1_LOTECTL,;						    //14
            0, ;									//15
            0 } )								      //16

      DbSkip()
   EndDo  
//EndIf

nLine := nTop + 1400   


For xy:= 1 to Len(aItems)
	aSort( aItems,,, { |x,y| x[3] < y[3] } )
Next

For xI := 1 TO Len( aItems )

	nQuant := aItems[xI][5]* aItems[xI][13] 
    nPreco := aItems[xI][6]/nQuant
    
   If nLine > ( CURTEXTLINE - 200 )
      // oPrn:EndPage()
      lPrinted := .F.
      PrintFoot( cEspecie, nCopies )
      nHoja++
      PrintHead( cEspecie, nCopies )
      nLine := nTop + 1400
   EndIf
    
	If	ALLTRIM(cEspecie) $ "RFN|RTS" // Factura - Nota de Debito    
	
		cCodCli := posicione("SA7",1,xFilial("SA7")+SF2->F2_CLIENTE+SF2->F2_LOJA + aItems[xI][1],"A7_CODCLI")
		
		nTotalBruto := aItems[xI][7]
		nTotalNeto  := aItems[xI][7]-aItems[xI][8]
		
	EndIf
	
		
	oPrn:Say( nLine, nLef+120, Alltrim(aItems[xI][1]), oFont3, 100 ) 							// Codigo Producto
	oPrn:Say( nLine, nLef+300, ALLTRIM(cCodCli), oFont3, 100 ) 									//  Cod CLiente
	oPrn:Say( nLine, nLef+600, alltrim(aItems[xI][4]), oFont3, 100 ) 						// Descripcion Producto
	oPrn:Say( nLine, nLef+1230, aItems[xI][2], oFont3, 100 ) 									// Unidad
	oPrn:Say( nLine, nLef+2040,cValToCHar( aItems[xI][5]), oFont3, 100 ) 		// Cantidad
	oPrn:Say( nLine, nLef+1530, TransForm( aItems[xI][5],  '@E 99999.99'  )+' X '+ALLTRIM(TransForm( aItems[xI][13], '@E 999,999.999' )), oFont3, 100 )       //envase
   	oPrn:Say( nLine, nLef+1380,  aItems[xI][14], oFont3, 100 )  								//LOTE
	//	oPrn:Say( nLine, nLef+1820, TransForm( nPreco, '@E 999,999.99' ), oFont, 100 ) 		// Precio
	//oPrn:Say( nLine, nLef+2040, TransForm( nTotalNeto, '@E 999,999.99' ), oFont, 100 ) 			// Total
	     
   IF Alltrim(SF1->F1_ESPECIE) == "RTS".OR. Alltrim(SF1->F1_SERIE) == "R1"
   		nLine += 40           
   		oPrn:Say( nLine, nLef+120,Alltrim(aItems[xI][1]), oFont3, 100 ) 
   		oPrn:Say( nLine, nLef+330, "Posición arancelaria: " + cPosIpi, oFont3, 100 )
   EndIf
   	 
   IF posicione("SB8",5,xFilial("SB8")+ aItems[xI][1]+aItems[xI][14],"B8_NUMDESP") <> ' ' 
	
//		If Alltrim(SF1->F1_ESPECIE) == "RTS".OR. Alltrim(SF1->F1_SERIE) == "R1"
//			cAna:= "ANA Despacho: " + posicione("SB8",5,xFilial("SB8")+ aItems[xI][1]+aItems[xI][14],"B8_NUMDESP")
//		Else
//		   	nLine +=40
//		   	oPrn:Say( nLine, nLef+120, aItems[xI][1], oFont3, 100 ) 
//		   	oPrn:Say( nLine, nLef+380, "ANA Despacho: " + posicione("SB8",5,xFilial("SB8")+ aItems[xI][1]+aItems[xI][14],"B8_NUMDESP"), oFont3, 100 )
//			oPrn:Say( nLine, nLef+1140, "Año:20"+substr(posicione("SB8",5,xFilial("SB8")+ aItems[xI][1]+aItems[xI][14],"B8_NUMDESP"),1,2), oFont3, 100 )    	 
//		EndIf
		
   EndIf	

nLine += 40
oPrn:Box( nLine, 100, nLine, 2300 )  // Detalle
nLine += 30
nQuant := 0  
Next

If nLine > ( CURTEXTLINE - 200 )
     
      oPrn:EndPage()
      lPrinted := .F.
      PrintHead( cEspecie, nCopies )
      nLine := nTop + 1400
EndIf

DbSelectArea( "SF2" )

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Marcelo F. Rodriguez  ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PrintFoot( cEspecie, nCopyNum )

Local xI := 0,aImp, ;
cTexto  := Space( 0 ), ;
cTipoREM  := "", ;
cLocalD2  := "", ;
nLenTxt := 0

//If Alltrim(SF1->F1_ESPECIE) == "RFD".OR. Alltrim(SF1->F1_SERIE) == "R1"
                                
//	oPrn:Say( 2860, 130, cAna, oFont, 100 )

//Endif

oPrn:Say( 2800 ,130, "Valor Declarado:", oFont, 100 )  

oPrn:Say( 2800, 1600, Replicate("_",40) ,oFont,100 )
oPrn:Say( 2800+50,1800, "Firma y Aclaración" ,oFont,100 )

If SF1->F1_MOEDA == 02
   oPrn:Say( 2800 ,nLef+480, "U$S", oFont, 100 )   
EndIf                                            

If SF1->F1_MOEDA == 03
   oPrn:Say( 2800 ,nLef+480, "€", oFont, 100 )   
EndIf

If SF1->F1_MOEDA == 01
   oPrn:Say( 2800 ,nLef+480, "$", oFont, 100 )   
EndIf


If AllTrim( cEspecie ) <> 'RFD'
	oPrn:Say( 2800 ,nLef+600, Transform( SF1->F1_VALBRUT, '@E 999,999,999.99'), oFont, 100 )			// Total
Else
	oPrn:Say( 2800 ,nLef+600, Transform( SF1->F1_VALBRUT, '@E 999,999,999.99'), oFont, 100 )			// MODIFICO EL 22-4
	//oPrn:Say( 2800 ,nLef+600, Transform( nD2Custo1, '@E 999,999,999.99'), oFont, 100 )			// Total
EndIf
/*
	oPrn:Say( 2995, 140, "En caso de abonar en CORREO ARGENTINO, use: Casilla de Correo Nro. 93 (1602) XXXXXXX - XXXXX ", oFont6, 100 )
	oPrn:Say( 3025, 140, 'Rogamos cancelar las facturas con cheques sobre plaza Buenos Aires a la orden de XXXXXX XXXXXXXXXXX XXXXXXXXX XXXX "no a la ', oFont3, 200 )
	oPrn:Say( 3055, 140, 'orden". No abonándose la factura en el plazo estipulado, nos reservamos el derecho de hacer el correspondiente', oFont3, 200 )
	oPrn:Say( 3085, 140, 'recargo por mora en el pago.', oFont3, 100 )
*/
//	oPrn:Say( 3130, 1680, "C.A.I.:" + aCAI[1], oFont5, 100 )
//	oPrn:Say( 3170, 1680, "VENCIMIENTO C.A.I.: " + DTOC(aCAI[2]), oFont5, 100 )
//	oPrn:Say( 3130, 140, 'SUCESORES DE DOMINGO RESTA Y CIA S.A.' , oFont5, 100 )
//	oPrn:Say( 3170, 140, 'C.U.I.T.: 30-67608106-9', oFont5, 100 )
	oPrn:Say( 3170, 140, '..........................................                                   ..........................................', oFont5, 100 )

nLine   := CURTEXTLINE // TEXTBEGINLINE

//oPrn:Box( 2990, 100, 3125, 2300)   // Cuadro Foot
oPrn:Box( 3125, 100, 3250, 2300)

oPrn:EndPage()

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Diego Fernando Rivero ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg( cPerg )
Local aArea := GetArea(),;
      aRegs := {},;
      i, j

DbSelectArea( "SX1" )
DbSetOrder( 1 )

cPerg := Padr( cPerg, 10 )
AAdd( aRegs, { cPerg, "01", "Serie ?      :   ", "Serie ?      :   ", "Serie ?      :   ", "mv_ch1", "C", 3 , 00, 1, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "02", "Desde Remito?:   ", "Desde Remito?:   ", "Desde Remito?:   ", "mv_ch2", "C", 12, 00, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "03", "Hasta Remito?:   ", "Hasta Remito?:   ", "Hasta Remito?:   ", "mv_ch3", "C", 12, 00, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "04", "Tipo Comprob.:   ", "Tipo Comprob.:   ", "Tipo Comprob.:   ", "mv_ch4", "N", 1 , 00, 0, "C", "", "mv_par04", "Remito", "Remito", "Remito","", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "05", "Previsualizacion:", "Previsualizacion:", "Previsualizacion:", "mv_ch5", "N", 1 , 00, 0, "C", "", "mv_par05", "Si", "Si", "Si", "", "", "No", "No", "No", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "","","" } )
AAdd( aRegs, { cPerg, "06", "Cantidad Copias?:", "Cantidad Copias?:", "Cantidad Copias?:", "mv_ch6", "N", 1 , 00, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","",""} )

For i := 1 TO Len( aRegs )
   If !DbSeek( cPerg + aRegs[i,2] )
      RecLock( "SX1", .T. )
      For j := 1 TO FCount()
         If j <= Len( aRegs[i] )
            FieldPut( j, aRegs[i,j] )
         EndIf
      Next
      MsUnlock()
   EndIf
Next

RestArea( aArea )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Diego Fernando Rivero ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TraeFactura()
Local aAreaSD1 := SD1->( GetArea() ),;
aArea	:= GetArea(),;
cFac  := Space(6)

DbSelectArea('SD1')
DbSetOrder(9)
DbSeek( xFilial()+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_SERIE+SD1->D1_DOC+SD1->D1_ITEM)

cFac  := substr(SD1->D1_SERIE,1,1)+SD1->D1_DOC

RestArea( aAreaSD1 )
RestArea( aArea )

Return( cFac )
