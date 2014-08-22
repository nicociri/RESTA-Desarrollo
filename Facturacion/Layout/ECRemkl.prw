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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ KFac01   ³ Autor ³ Marcelo F. Rodriguez   ³Fecha ³30/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Layout de Factura de Venta                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Layout de Factura de Venta                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ACTUALIZACIONES EFECTUADAS DESDE LA CODIFICACION INICIAL      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Fecha  ³         Motivo de la Alteracion                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³  /  /  ³ Http://www.e-cuantica.com.ar                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ECREMKL(CNUM,CSERIE)

Private lPrinted  := .F.,;
		esCopia     := .F.,;
      nHoja       := 0,; 
		cRemNota    := Space( 0 ), ;
		cPerg       := 'ECREML',;
      cPedidos    := '',;
      cRemitos    := '',;
      nD2Custo1   := 0,;
		cNroPedido  := '',; 
		NCOPIAS := 1
              
Private cNumFact
Private cNumDoc

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

//If mv_par04 < 3 // Factura - Nota de Debito
   DbSelectArea( "SF2" )
   DbSeek( xFilial() + mv_par02 + mv_par01 , .t. )

   While !Eof() .and. F2_FILIAL+F2_DOC+F2_SERIE <= xFilial()+mv_par03+mv_par01
      esCopia := .F.
      If  ALLTRIM(F2_ESPECIE) $ "RFN|RTS|RCD"
         If Alltrim(F2_SERIE) != Alltrim(mv_par01)
            DbSkip()
            Loop
         EndIf
     
         PrintComp( F2_ESPECIE )
      EndIf
	  DbSelectArea( "SF2" )
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
±±³Funcion   ³          ³ Autor ³   ³ Data ³   /  /   ³±±
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
      nRecSD2  := 0, ;
      nRecSD1  := 0



Private cMoneda    := Space( 0 ), ;
        cSigno     := Space( 0 ), ;
        aMemo      := Array( 0 ), ;
        aPedidos   := Array( 0 ), ;
        aFactura   := Array( 0 ), ;
        aOCompras  := Array( 0 ), ;
        aDespachos := Array( 0 ), ;
        cProvincia := Space( 0 ), ;
        cSitIVA    := Space( 0 ), ;
        cDepProc   := Space( 0 ), ;
        cLugEnt    := Space( 0 ), ;
        nMoeda     := 0, ;
        nValmerc   := 0, ;
        aDriver    := ReadDriver(), ;
        nCotiz     := 0 , ;
        cNomVend   := " ", ;
        cVend      := " ", ;
        nLinesObs   := 0,;
        nNumLin		:= "",;
        dFecVto    := ctod('  /  /  '),;
        lConsign	:= .f.,;
        cAna		:= ''
        
        
cPedidos    := ''
cRemitos    := ''
cNumFact	:= ''
cxoc 	:= ''      
If ALLTRIM(cEspecie) $ "RFN"

	
	DbSelectArea( "SA1" )
    If ALLTRIM(cEspecie) $ "RFN"
       DbSeek( xFilial() + SF2->F2_CLIENTE + SF2->F2_LOJA )
    Else
       DbSeek( xFilial( "SA1" ) + SF2->F2_CLITRA + SF2->F2_LOJTRA )
    EndIf
        
    NCOPIAS := MV_PAR06
	DbSelectArea( "SX5" )
	DbSeek( xFilial() + "12" + SA1->A1_EST )
	cProvincia := AllTrim( X5_DESCRI )

	DbSelectArea( "SX5" )
	DbSeek( xFilial() + "SF" + SA1->A1_TIPO )
    cSitIVA := AllTrim( X5_DESCSPA )

	DbSelectArea( "SYA" )
	DbSeek( xFilial() + SA1->A1_PAIS )

	DbSelectArea( "SA3" )
	DbSeek( xFilial() + SF2->F2_VEND1 )
	cVend    := SA3->A3_COD
	cNomVend := SA3->A3_NOME

	DbSelectArea( "SD2" )
    DbSeek( SF2->F2_FILIAL + SF2->F2_DOC+ SF2->F2_SERIE +SF2->F2_CLIENTE + SF2->F2_LOJA )
	nRecSD2  := Recno()   
    cXOC := POSICIONE("SC5",1,xfilial("SC5")+SD2->D2_PEDIDO, "C5_XOC")
	//lConsign := !Empty( D2_IDENTB6 )
	lConsign := if(SF2->F2_TIPOREM=="A",.T.,.F.)

   While !Eof() .and. ( SF2->F2_FILIAL + SF2->F2_DOC+ SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA   ) == ;
		( D2_FILIAL + D2_DOC+ D2_SERIE +D2_CLIENTE + D2_LOJA   )

      If SF2->F2_ESPECIE != D2_ESPECIE
			DbSkip()
			Loop
      EndIf
      
      If !Empty( SD2->D2_REMITO ) .and. !( SD2->D2_REMITO $ cRemitos )
         cRemitos += SD2->D2_REMITO + '/'
         nRecSD2  := SD2->(Recno())
         If SD2->(DbSeek( SF2->F2_FILIAL + SD2->D2_REMITO + SD2->D2_SERIREM + SD2->D2_CLIENTE + SD2->D2_LOJA ))
            If !Empty( SD2->D2_PEDIDO ) .and. !( SD2->D2_PEDIDO $ cPedidos )
               cPedidos += SD2->D2_PEDIDO + '/'
            EndIf
         EndIf
         SD2->(DbGoTo(nRecSD2))
      Else
         If !Empty( SD2->D2_PEDIDO ) .and. !( SD2->D2_PEDIDO $ cPedidos )
            cPedidos += SD2->D2_PEDIDO + '/'
            cNumDoc := POSICIONE("SC5",1,xfilial("SC5")+SD2->D2_PEDIDO, "C5_XNFSER+C5_XNFDOC")
            if !empty(cNumDoc) .and. !(cNumdoc $ cNumFact)
            	cNumFact += cNumDoc + '/'
            endif
         EndIf
      EndIf

		DbSkip()
   EndDo
   

   If Len( cPedidos ) > 0
      cPedidos := SubStr( cPedidos, 1, Len(cPedidos) - 1 )
   EndIf
   
   If Len( cNumFact ) > 0
      cNumFact := SubStr( cNumFact, 1, Len(cNumFact) - 1 )
   EndIf
   
   If Len( cRemitos ) > 0
      cRemitos := SubStR( cRemitos, 1, Len(cRemitos) - 1 )
   EndIf

   DbSelectArea( "SF2" )
   
ElseIf ALLTRIM(cEspecie) $ "RTS|RCD"   
   

	DbSelectArea( "SA2" )
	DbSetOrder(1)
    DbSeek( xFilial() + SF2->F2_CLIENTE + SF2->F2_LOJA )

	DbSelectArea( "SX5" )
	DbSeek( xFilial() + "12" + SA2->A2_EST )
	cProvincia := AllTrim( X5_DESCRI )

	DbSelectArea( "SX5" )
	DbSeek( xFilial() + "SF" + SA2->A2_TIPO )
    cSitIVA := AllTrim( X5_DESCSPA )

	DbSelectArea( "SYA" )
	DbSeek( xFilial() + SA2->A2_PAIS )

	DbSelectArea( "SA3" )
	DbSeek( xFilial() + SF2->F2_VEND1 )
	cVend    := SA3->A3_COD
	cNomVend := SA3->A3_NOME

	DbSelectArea( "SD2" )
    DbSeek( SF2->F2_FILIAL + SF2->F2_DOC+ SF2->F2_SERIE +SF2->F2_CLIENTE + SF2->F2_LOJA )
	nRecSD2  := Recno()
	//lConsign := !Empty( D2_IDENTB6 )
	lConsign := if(SF2->F2_TIPOREM=="A",.T.,.F.)
	nCopias	:= mv_par06
	


EndIf

For nCopies := 1 TO NCOPIAS 
   nHoja := 1
   nD2Custo1	:= 0
   PrintHead( cEspecie, ncopies )
   PrintItem( cEspecie )
   PrintFoot( cEspecie, ncopies )
Next

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³   ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³  Cabecera                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PrintHead( cEspecie, nCopyNum )
Local cFILIAL := Alltrim(SF2->F2_FILIAL)
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
oPrn:Say( nTop+0550, nLef+1800, 'N REMITO'										, oFontN, 100 )
oPrn:Say( nTop+0550, nLef+2100, 'HOJAS'											, oFontn, 100 )	

oPrn:Say( nTop+0670, nLef+1250, 'ORDEN DE COMPRA'								, oFontn, 100 )
oPrn:Say( nTop+0670, nLef+1800, 'RESPONSABLE'									, oFontn, 100 )

oPrn:Say( nTop+0790, nLef+1250, 'PEDIDO'										, oFontn, 100 )
oPrn:Say( nTop+0900, nLef+1550, 'DIRECCION DE ENTREGA'							, oFontn, 100 )
oPrn:Say( nTop+0900, nLef+0400, 'DIRECCION DEL TRANSPORTE'						, oFontn, 100 )

oPrn:Say( nTop+0600, nLef+1280, Alltrim(SF2->F2_CLIENTE)						, oFontF, 100 )
oPrn:Say( nTop+0600, nLef+1500, Alltrim(cNumFact)								, oFontF, 100 )
oPrn:Say( nTop+0600, nLef+1780, SF2->F2_DOC								, oFontF, 100 )
oPrn:Say( nTop+0600, nLef+2110, StrZero( nHoja, 3 ) 							, oFont, 100 )

oPrn:Say( nTop+0720, nLef+1300, posicione("SC5",1,xFilial("SC5")+substr(cPedidos,1,6),"C5_XOC")	, oFont, 100 )



//oPrn:Say( nTop+0720, nLef+1250,posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CONTATO") , oFont, 100 )

cCon:=posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CONTATO") 
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

   oPrn:Say( nTop+180, nLef+1180, Substr(SF2->F2_SERIE,1,1)	, oFont2, 100 )

// Codigo Factura
If	ALLTRIM(cEspecie) $ "RFN|RTS|RCD" .and. Substr(SF2->F2_SERIE,1,1) == 'R'
   oPrn:Say( nTop+290, nLef+1125, 'Codigo N°91'	, oFont3, 100 )
EndIf

		
 // Tipo Comprobante			 
If	ALLTRIM(cEspecie) $ "RFN|RTS|RCD"
		oPrn:Say( nTop+0180, nLef+1440/*nTop+320, nLef+850*/, 'DOCUMENTO NO VÁLIDO COMO FACTURA'	, oFont, 100 )
		oPrn:Say( nTop+350, nLef+1500, 'REMITO'	, oFontB, 100 )
		oPrn:Say( nTop+350, nLef+1120, NUMCOPY2[nCopyNum]		, oFontN, 100 )                                                                                   
EndIf

oPrn:Say( nTop+350, nLef+1660, '  Nº:' + Left( SF2->F2_DOC, 4 ) + "-" + Right( SF2->F2_DOC, 8 )	, oFontB, 100 )
oPrn:Say( nTop+400, nLef+1660, '  FECHA: ' + DToC( SF2->F2_EMISSAO ), oFont, 100 )

// Datos Cliente
If AllTrim( cEspecie ) <> 'RTS' .And. AllTrim( cEspecie ) <> 'RCD'
	oPrn:Say( nTop+580, nLef+0110, AllTrim( SA1->A1_NOME ) , oFontN, 100 )
	oPrn:Say( nTop+650, nLef+0110, AllTrim( SA1->A1_END ), oFont, 100 )
	oPrn:Say( nTop+700, nLef+0110, "C.P.: " + AllTrim( SA1->A1_CEP ) + " Tel.: " + Left(AllTrim( SA1->A1_TEL ),12), oFont, 100)
//	oPrn:Say( nTop+700, nLef+0110, Alltrim( SA1->A1_MUN ) + "    C.P.: " + AllTrim( SA1->A1_CEP ) + " Tel.: " + Left(AllTrim( SA1->A1_TEL ),12), oFont, 100)
	oPrn:Say( nTop+750, nLef+0110, If( SA1->A1_TIPO != "E",If(!Empty( cProvincia ),cProvincia,"" ),"   Pais: " + AllTrim( SYA->YA_DESCR ) ), oFont, 100 )
	oPrn:Say( nTop+800, nLef+0110, 'I.V.A.: ' + cSitIVA, oFont, 100 )
	oPrn:Say( nTop+850, nLef+0110, 'C.U.I.T.: ' + Subst(SA1->A1_CGC,1,2)+'-'+Subst(SA1->A1_CGC,3,8)+'-'+Subst(SA1->A1_CGC,11,1), oFont, 100 )
	// Direccion de Entrega
	
	//oPrn:Say( nTop+930, nLef+1250, AllTrim( SA1->A1_ENDENT)								, oFont, 100 )
	oPrn:Say( nTop+930, nLef+1250, AllTrim( SF2->F2_XENDENT)								, oFont, 100 )
	oPrn:Say( nTop+970, nLef+1250, AllTrim( SA1->A1_MUNE)	+ ' ' + AllTrim( SA1->A1_MUNE)		, oFont, 100 )
	oPrn:Say( nTop+1010, nLef+1250, ''													, oFont, 100 )
	oPrn:Say( nTop+1050, nLef+1250, ''													, oFont, 100 )
	
Else
	oPrn:Say( nTop+0580, nLef+0110, AllTrim( SA2->A2_NOME ) , oFontN, 100 )
	oPrn:Say( nTop+650, nLef+0110, AllTrim( SA2->A2_END ), oFont, 100 )
	oPrn:Say( nTop+700, nLef+0110, Alltrim( SA2->A2_MUN ) + "   C.P.: "+AllTrim( SA2->A2_CEP ), oFont, 100 )
	oPrn:Say( nTop+750, nLef+0110, If( SA2->A2_TIPO != "E",If(!Empty( cProvincia ),cProvincia,"" ),"   Pais: " + AllTrim( SYA->YA_DESCR ) ), oFont, 100 )
	oPrn:Say( nTop+800, nLef+0110, 'I.V.A.: ' + cSitIVA, oFont, 100 )
	oPrn:Say( nTop+850, nLef+0110, 'C.U.I.T.: ' + Subst(SA2->A2_CGC,1,2)+'-'+Subst(SA2->A2_CGC,3,8)+'-'+Subst(SA2->A2_CGC,11,1), oFont, 100 )

	DbSelectArea( "SD2" )
    DbSeek( SF2->F2_FILIAL + SF2->F2_DOC+ SF2->F2_SERIE +SF2->F2_CLIENTE + SF2->F2_LOJA )    

EndIf	


// Direccion de Transporte
If AllTrim( cEspecie ) <> 'RTS|RCD'
	cTransp := posicione("SC5",1,xFilial("SC5")+substr(cPedidos,1,6),"C5_TRANSP")
	
	// oPrn:Say( nTop+930, nLef+0120, Posicione('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_NOME')	, oFont, 100 )
	oPrn:Say( nTop+930, nLef+0120, Posicione('SA4',1,xFilial('SA4')+CTRANSP,'A4_NOME')	, oFont, 100 )
	oPrn:Say( nTop+970, nLef+0120, Posicione('SA4',1,xFilial('SA4')+CTRANSP,'A4_END')	, oFont, 100 )
	oPrn:Say( nTop+1010, nLef+0120, Posicione('SA4',1,xFilial('SA4')+CTRANSP,'A4_MUN')	, oFont, 100 )
	// oPrn:Say( nTop+1050, nLef+0120, Posicione('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_PROV')	, oFont, 100 )
EndIf	

If lConsign
	oPrn:Say( nTop+nTop+1130+((nx-1)*50), nLef+0850, OemToAnsi( "REMITO DE CONSIGNACION" ), oFontTit, 150 )
	nMasLine:= 1180
ElseIf Alltrim(SF2->F2_ESPECIE) == "RTS" .OR. Alltrim(SF2->F2_SERIE) == "R1"
	oPrn:Say( nTop+nTop+1130+((nx-1)*50), nLef+0850, OemToAnsi( "TRANSPORTE ENTRE DEPOSITOS" ), oFontTit, 150 )
	nMasLine:= 1180             
Else
	nMasLine:= 1080
EndIf

//nNumLin := posicione("SC5",1,xFilial("SC5")+substr(cPedidos,1,6),"C5_OBS2")
nNumLin := posicione("SC5",1,xFilial("SC5")+substr(cPedidos,1,6),"C5_XOBS2")
nLinesObs   := MLCount( Alltrim( nNumLin ), 90)
For nX := 1 To nLinesObs
	oPrn:Say( nTop+nTop+nMasLine +((nX-1)*50), nLef+0120, MemoLine( Alltrim( nNumLin ), 90, nX )	, oFont, 100 )
	nTop += 50
Next
	
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

   DbSelectArea( "SD2" )
   DbSeek( SF2->F2_FILIAL + SF2->F2_DOC+ SF2->F2_SERIE +SF2->F2_CLIENTE + SF2->F2_LOJA )

   While( ALLTRIM(cEspecie) $ "RFN|RTS|RCD" .AND. ;
         ( xFilial() + SF2->F2_DOC+ SF2->F2_SERIE +SF2->F2_CLIENTE + SF2->F2_LOJA   ) == ;
         ( D2_FILIAL + D2_DOC+ D2_SERIE + D2_CLIENTE + D2_LOJA  ) )

        
      DbSelectArea( "SB1" )
      DbSeek( xFilial() + SD2->D2_COD )
      If !Empty(SD2->D2_DESCRI)
      	cDescrip := SD2->D2_DESCRI
      Else
      	cDescrip := B1_DESC
      EndIF
      
      If Alltrim(SF2->F2_ESPECIE) == 'RTS'.OR. Alltrim(SF2->F2_SERIE) == "R1"     
      		cPosipi:= B1_POSIPI + " " + B1_EX_NCM + " " + B1_EX_NBM
      EndIf
      
      cEsserie := "R"
     
      DbSelectArea( "SD2" )
      
      nD2Custo1 := SD2->D2_CUSTO1
      
      AAdd( aItems, ;
            { D2_COD , ;							//01 ** USADO
            D2_SEGUM,;                              //02
            D2_ITEM, ;								//03
            SB1->B1_DESC, ;							//04 ** USADO
            D2_QUANT, ;								//05 ** USADO
            D2_PRCVEN	, ;							//06
            D2_TOTAL, ;								//07 ** USADO
            D2_DESCON, ;							//08 ** USADO
            D2_DESC, ;								//09 ** USADO
            D2_VALIMP1, ;							//10
            D2_PRUNIT, ;							//11
            Substr(SD2->D2_SERIE,1,1), ;			//12
            SB1->B1_CONV,;    						//13
            D2_LOTECTL,;						    //14
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
    
	If	ALLTRIM(cEspecie) $ "RFN|RTS"     
	
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
	     
   IF Alltrim(SF2->F2_ESPECIE) == "RTS".OR. Alltrim(SF2->F2_SERIE) == "R1"
   		nLine += 40           
   		oPrn:Say( nLine, nLef+120,Alltrim(aItems[xI][1]), oFont3, 100 ) 
   		oPrn:Say( nLine, nLef+330, "Posición arancelaria: " + cPosIpi, oFont3, 100 )
   EndIf
   	 
   IF posicione("SB8",5,xFilial("SB8")+ aItems[xI][1]+aItems[xI][14],"B8_NUMDESP") <> ' ' 
	
		If Alltrim(SF2->F2_ESPECIE) == "RTS".OR. Alltrim(SF2->F2_SERIE) == "R1"
			cAna:= "ANA Despacho: " + posicione("SB8",5,xFilial("SB8")+ aItems[xI][1]+aItems[xI][14],"B8_NUMDESP")
		Else
		   	nLine +=40
		   	oPrn:Say( nLine, nLef+120, aItems[xI][1], oFont3, 100 ) 
		   	oPrn:Say( nLine, nLef+380, "ANA Despacho: " + posicione("SB8",5,xFilial("SB8")+ aItems[xI][1]+aItems[xI][14],"B8_NUMDESP"), oFont3, 100 )
			oPrn:Say( nLine, nLef+1140, "Año:20"+substr(posicione("SB8",5,xFilial("SB8")+ aItems[xI][1]+aItems[xI][14],"B8_NUMDESP"),1,2), oFont3, 100 )    	 
		EndIf
		
   EndIf	
   	
   	
	//oPrn:Say( nLine, nLef+2040, IIF(Substr(SF2->F2_SERIE,1,1) == 'B',TransForm( aItems[xI][7]+ aItems[xI][10], '@E 999,999.99' ),TransForm( aItems[xI][7], '@E 999,999.99' )), oFont, 100 ) // Total Neto
	//oPrn:Say( nLine, nLef+1210,  IIF(Substr(SF2->F2_SERIE,1,1) == 'B',TransForm( (aItems[xI][7]+aItems[xI][8]+aItems[xI][10])/aItems[xI][5], '@E 999,999.99'  ),TransForm( aItems[xI][11], '@E 999,999.99'  )), oFont, 100 ) // Precio
	//oPrn:Say( nLine, nLef+1460, IIF(Substr(SF2->F2_SERIE,1,1) == 'B',TransForm( aItems[xI][7]+aItems[xI][8]+aItems[xI][10], '@E 999,999.99' ),TransForm( aItems[xI][7]+aItems[xI][8], '@E 999,999.99' )), oFont, 100 ) // Total Bruto
	//oPrn:Say( nLine, nLef+1460, TransForm( nTotalBruto, '@E 999,999.99' ), oFont, 100 ) // Total Bruto
	//oPrn:Say( nLine, nLef+1710, IIF(aItems[xI][8]<>0,TransForm( (aItems[xI][8]/(aItems[xI][7]+aItems[xI][8]))*100, '@E 999.99' ), TransForm( 0, '@E 999.99' ) ),oFont, 100 ) // % Descuento
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
nLenTxt := 0, aCAI := {}

If Alltrim(SF2->F2_ESPECIE) == "RTS".OR. Alltrim(SF2->F2_SERIE) == "R1"
                                
	oPrn:Say( 2860, 130, cAna, oFont, 100 )

Endif

If MV_PAR07==1
	oPrn:Say( 2800 ,130, "Valor Declarado:", oFont, 100 )  
EndIf

oPrn:Say( 2800, 1600, Replicate("_",40) ,oFont,100 )
oPrn:Say( 2800+50,1800, "Firma y Aclaración" ,oFont,100 )

If MV_PAR07==1
	If SF2->F2_MOEDA == 02
   		oPrn:Say( 2800 ,nLef+480, "U$S", oFont, 100 )   
	EndIf                                            
	If SF2->F2_MOEDA == 03
   		oPrn:Say( 2800 ,nLef+480, "€", oFont, 100 )   
	EndIf
	If SF2->F2_MOEDA == 01
   		oPrn:Say( 2800 ,nLef+480, "$", oFont, 100 )   
	EndIf
EndIf

If AllTrim( cEspecie ) <> 'RTS'
	If MV_PAR07==1
		oPrn:Say( 2800 ,nLef+600, Transform( SF2->F2_VALBRUT, '@E 999,999,999.99'), oFont, 100 )			// Total
	EndIf
Else
	oPrn:Say( 2800 ,nLef+600, Transform( nD2Custo1, '@E 999,999,999.99'), oFont, 100 )			// Total
EndIf

/*
cCUIT_CB := AllTrim( SM0->M0_CGC )
cTipo_CB := '01'

cCodBar  := cCUIT_CB + cTipo_CB + cPDV_CB + cCAE_CB + cVtc_CB
nSuma    := 0

For nD := 1 To Len( cCodBar )
   nSuma += If( Mod( Val( SubStr( cCodBar, nD, 1 ) ), 2 ) == 0, Val( SubStr( cCodBar, nD, 1 ) ), Val( SubStr( cCodBar, nD, 1 ) ) * 3 )
Next nD

   cCodBar  := cCodBar + StrZero( Mod(nSuma, 10), 1 )
                      b
MSBAR( "INT25", 26.7, 7, cCodBar, oPrn, .F., Nil, Nil, 0.02, 0.7, .T., Nil, Nil, .F. ) 
*/
	aCAI := Cai()                                                                                                      
	oPrn:Say( 2995, 140, "En caso de abonar en CORREO ARGENTINO, use: Casilla de Correo Nro. 93 (1602) XXXXXXX - XXXXX ", oFont6, 100 )
	oPrn:Say( 3025, 140, 'Rogamos cancelar las facturas con cheques sobre plaza Buenos Aires a la orden de XXXXXX XXXXXXXXXXX XXXXXXXXX XXXX "no a la ', oFont3, 200 )
	oPrn:Say( 3055, 140, 'orden". No abonándose la factura en el plazo estipulado, nos reservamos el derecho de hacer el correspondiente', oFont3, 200 )
	oPrn:Say( 3085, 140, 'recargo por mora en el pago.', oFont3, 100 )

	//oPrn:Say( 3130, 1680, "C.A.I:" + SF2->F2_CAI, oFont5, 100 )
	oPrn:Say( 3130, 1680, "C.A.I.:" + aCAI[1], oFont5, 100 )
	oPrn:Say( 3170, 1680, "VENCIMIENTO C.A.I.: " + DTOC(aCAI[2]), oFont5, 100 )
	oPrn:Say( 3130, 140, 'SUCESORES DE DOMINGO RESTA Y CIA S.A.' , oFont5, 100 )
	oPrn:Say( 3170, 140, 'C.U.I.T.: 30-67608106-9', oFont5, 100 )

nLine   := CURTEXTLINE // TEXTBEGINLINE

oPrn:Box( 2990, 100, 3125, 2300)   // Cuadro Foot
oPrn:Box( 3125, 100, 3250, 2300)


oPrn:EndPage()

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
Static Function PrintCAI( cEspecie, nCopyNum )

/*
Local  cCaiVto := ''
Local  cCaiNro := ''

cCaiVto := "FECHA DE VTO.: "
cCaiNro := "C.A.I.: " 

nLine := CAILINE

If Left( AllTrim( SF2->F2_SERIE ), 1 ) $ "R" 
 //  oPrn:Say( nLine, 1750, cCainro , oFont, 100 )
  // nLine +=60
  // oPrn:Say( nLine, 1750, cCaivto , oFont, 100 )
EndIf
nLine +=60
//If SF2->F2_PRINTED == "S" //.AND. esCopia
 //  oPrn:Say( nLine, 1750, "COPIA", oFont, 100 )
//	oPrn:SayBitmap( 1000, 0500, "\sigaadv\copia.bmp", 1400, 1200 )
//EndIf

//Else
  // oPrn:Say( nLine, 1750, NUMCOPY[nCopyNum] , oFont, 100 )
//EndIf

Return NIL

/*
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
AAdd( aRegs, { cPerg, "07", "Imprime precios?:", "Imprime precios?:", "Imprime precios?:", "mv_ch7", "N", 1 , 00, 0, "C", "", "mv_par07", "Si", "Si", "Si", "", "", "No", "No", "No", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "","","" } )

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
±±³Funcion   ³          ³ Autor ³ Marcelo F. Rodriguez  ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TraeFactura()
Local aAreaSD2 := SD2->( GetArea() ),;
		aArea	:= GetArea(),;
      cFac  := Space(6)

DbSelectArea('SD2')
DbSetOrder(9)
DbSeek( xFilial()+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_ITEM)

cFac  := substr(SD2->D2_SERIE,1,1)+SD2->D2_DOC

RestArea( aAreaSD2 )
RestArea( aArea )

Return( cFac )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Alexei Bykovski       ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³  Trae el Numero de CAI para los remitos de Venta           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Cai()
Local aCai := {}
Local cQuery := ''
	//Seleciona el registro de la tabla segun el numero y la serie de Remito y la fecha de la Vigencia de CAI
	cQuery := "SELECT FP_SERIE,FP_DTAVAL,FP_CAI FROM " + RetSqlName("SFP") + " "
	cQuery += "WHERE D_E_L_E_T_ = '' AND FP_SERIE = '" + SF2->F2_SERIE + "' AND FP_NUMINI <= '" + SF2->F2_DOC + "' "
	cquery += "AND FP_NUMFIM >= '" + SF2->F2_DOC + "' AND FP_ATIVO = '1' AND FP_DTAVAL >= '" + DToS(SF2->F2_EMISSAO) + "'" 
	cQuery := PLSAvaSQL(cQuery)
	
	PLSQuery(cQuery,"TAB")
	TAB->(DBGoTop())
	
	Aadd(aCai,TAB->FP_CAI)
	Aadd(aCai,TAB->FP_DTAVAL)
	                   
	DBSelectArea("TAB")
	TAB->(DBCloseArea())
Return(aCai)