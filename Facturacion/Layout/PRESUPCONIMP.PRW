#include "rwmake.ch"
#include "ap5mail.ch"
#include "protheus.ch"

#define CRLF Chr(13)+Chr(10)
#Define DETAILBOTTOM 1900
#define NMARGDERECHO 2300
#define NULTIMALINEA 2900
#define csum 40
                                                                                                                                                                                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PRESUP บAutor  ณ MS					 บFecha ณ  03/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Layout de Presupuesto de Ventas.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP Exclusivo de Microsiga.                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION Presupimp()

PRIVATE lPrinted   := .f.
Private	aCols		:= {}
Private	aHeader		:= {}
Private aImposto	:= {}
Private	cText1		:= ""
Private	cText2		:= ""
Private	cText3		:= ""
Private	cText4		:= ""
Private	aText1		:= {}
Private	aText2		:= {}
Private	aText3		:= {}
Private	aText4		:= {}
Private aHeaderAux 	:= {}
Private aColsAux	:= {}
Private lEnd 		:= .F.
Private nSinimp		:= 0
Private nHandle		:= nErase := 0
Private nTotBruto := nTotDes :=nTotQT :=0

ValidPerg( "PRESUPVTAS" )

If FUNNAME()=='MATA415'
	mv_par01 := SCJ->CJ_NUM
	mv_par02 := SCJ->CJ_NUM
	mv_par03 := 1
	mv_par08 := 1
	mv_par09 := 1
	//If msgyesno("Envia al Cliente copia via e-mail?")
    	mv_par06 := 2 
  	    mv_par07 := 2 
  			mv_par10 := 2
	//EndIf
	DbSelectArea( "SX1" )
	DbSetOrder( 1 )
	DbSeek( "PRESUPVTAS" + "04" )
	While !Eof() .and. X1_GRUPO = "PRESUPVTAS"
		If X1_ORDEM == "04"
			mv_par04 := X1_CNT01
		EndIf
		If X1_ORDEM == "05"
			mv_par05 := X1_CNT01
		EndIf   
		/*
		If X1_ORDEM == "07"
			mv_par07 := val(X1_CNT01)
		EndIf
        If X1_ORDEM == "08"
           mv_par08 := val(X1_CNT01)
		EndIf
        If X1_ORDEM == "09"
           mv_par09 := val(X1_CNT01)
		EndIf		
		*/
		DbSkip()
	EndDo
	RptStatus( { || SelectComp() } )
Else
	IF Pergunte( "PRESUPVTAS", .t. )
		RptStatus( { || SelectComp() } )
	ENDIF
EndIf

RETURN nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SelectComp บAutor  ณ MS				 บFecha ณ  03/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  PROCESAMIENTO					                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP Exclusivo de Microsiga.                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION SelectComp()

PRIVATE nLine    := 0, lAutorizada := .F.

PRIVATE oPrn     := TMSPrinter():New(), ;
oFont2   := TFont():New( "Courier New"     ,, 18,, .f.,,,,, .f. ), ;
oFont7b  := TFont():New( "Courier New"     ,,  7,, .f.,,,,, .f. ), ;
oFont12  := TFont():New( "Times New Roman" ,, 12,, .f.,,,,, .f. ), ;
oFont12c := TFont():New( "Courier New"     ,,  9,, .f.,,,,, .f. ), ;
oFont12b := TFont():New( "Courier New"     ,, 12,, .f.,,,,, .f. ), ;
oFont30  := TFont():New( "Bauhaus Lt Bt"   ,, 10,, .f.,,,,, .f. ), ;
oFont8   := TFont():New( "Arial"            ,,  8,, .f.,,,,    , .f. ), ;
oFont6   := TFont():New( "Arial"            ,,  6,, .f.,,,,    , .f. ), ;
oFont7   := TFont():New( "Arial"            ,,  7,, .f.,,,,    , .f. ), ;
oFont10  := TFont():New( "Arial"            ,, 10,, .f.,,,,    , .f. ), ; 
oFont10N := TFont():New( "Arial"            ,, 10,, .t.,,,,    , .f. ), ;
oFont10a := TFont():New( "Arial"            ,,  8,, .f.,,,,    , .f. ), ;
oFont12a := TFont():New( "Arial"            ,, 12,, .f.,,,,    , .f. ), ;
oFont8b  := TFont():New( "Arial"            ,,  8,, .t.,,,, .t., .f. ), ;
oFont8   := TFont():New( "Arial"            ,,  8,, .f.,,,,, .f. )
oFont9   := TFont():New( "Arial"            ,,  9,, .f.,,,,, .f. )
oFont9b  := TFont():New( "Arial"            ,,  9,, .t.,,,,, .f. )

oPrn:Setup()

DbSelectArea( "SA1" )
DbSetOrder( 1 )
DbSelectArea( "SA3" )
DbSetOrder( 1 )
DbSelectArea( "SE4" )
DbSetOrder( 1 )
DbSelectArea( "SB1" )
DbSetOrder( 1 )
DbSelectArea( "SYA" )
DbSetOrder( 1 )
DbSelectArea( "SCJ" )
DbSetOrder( 1 )

DbSeek( xFilial() + mv_par01, .t. )
SetRegua( ( Val( mv_par02 ) - Val( mv_par01 ) ) + 1 )

While !Eof() .and. SCJ->CJ_FILIAL = xFilial() .AND. SCJ->CJ_NUM <= mv_par02
   	nPagina := 0
   	PrintComp()       // IMPRESION    	COMPROBANTES
   	mv_par06 := 2
	   IncRegua()
   	DbSkip()
EndDo
                                       
IF mv_par03 == 1
	oPrn:PreView()
ELSE
	oPrn:Print()
ENDIF

Ms_Flush()

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintComp บAutor  ณ MS				 บFecha ณ  03/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  IMPRESION COMPROBANTES			                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP Exclusivo de Microsiga.                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION PrintComp()

PRIVATE nLine   := 0, ;
cPresup    		:= xFilial('SCJ') + SCJ->CJ_NUM,;
nPagina    		:= 0, ;
nLineAux   		:= 0, ;
cMoneda    		:= Space( 0 ), ;
aMemo1      	:= Array( 0 ), ;
aMemo2 			:= Array( 0 ), ;
aMemo3 			:= Array( 0 ), ;
aMemo4 			:= Array( 0 ), ;
aMemo5 			:= Array( 0 ), ;
aMemo6 			:= Array( 0 ), ;
aMemo7 			:= Array( 0 ), ;
aMemo8 			:= Array( 0 ), ;
aMemo9 			:= Array( 0 ), ;
aMemo10 		:= Array( 0 ), ;
cProvincia		:= Space(0), ;
cIngBrut   		:= Space( 15 ), ;
cProvCMS   		:= Space( 0 ), ;
cSitIVA			:= Space( 0 ), ;
nTotGRAL   		:= 0, ;
aDriver    		:= ReadDriver(), ;
aDescMon   		:= { GetMV( "MV_MOEDA1" ), ;
GetMV( "MV_MOEDA2" ), ;
GetMV( "MV_MOEDA3" ), ;
GetMV( "MV_MOEDA4" ), ;
GetMV( "MV_MOEDA5" ) }, ;
aSimbMon   		:= { GetMV( "MV_SIMB1" ), ;
GetMV( "MV_SIMB2" ), ;
GetMV( "MV_SIMB3" ), ;
GetMV( "MV_SIMB4" ), ;
GetMV( "MV_SIMB5" ) }, ;
CTEXTDESC:='' ,;
cSigno     		:= Space( 0 )

cMoneda := aDescMon[ If( Empty( SCJ->CJ_MOEDA ), 1, SCJ->CJ_MOEDA ) ]
cSigno  := aSimbMon[ If( Empty( SCJ->CJ_MOEDA ), 1, SCJ->CJ_MOEDA ) ]
cCot:=if(ALLTRIM(cMoneda)="1"," "," (Cot: "+transf(SCJ->CJ_TXMOEDA,"99.99")+")")
   
DbSelectArea( "SA1" )
DbSeek( xFilial( "SA1" ) + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA )

DbSelectArea( "SYA" )
DbSeek( xFilial( 'SYA' ) + SA1->A1_PAIS  )
DbSelectArea( "SE4" )
DbSeek( xFilial( "SE4" ) + SCJ->CJ_CONDPAG )

DbSelectArea( "SA3" )
DbSeek( xFilial() + SA1->A1_VEND )
 
DbSelectArea( "SCJ" )

cProvincia := X5Des( "12", SA1->A1_EST )
cSitIVA    := X5Des( "SF", SA1->A1_TIPO )
cProvCMS   := X5Des( "12", SM0->M0_ESTCOB )
aText3 := {}
PrintHead( cPresup )
PrintItem( cPresup )
PrintFoot( .t., cPresup )
//PrintLeyen()// Imprime Leyendas

DbSelectArea( "SCJ" )

RETURN nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintHead บAutor  ณ MS				 บFecha ณ  03/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  IMPRESION CABECERA				                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP Exclusivo de Microsiga.                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION PrintHead( cPresup )

IF !lPrinted
	lPrinted := .t.
ELSE
	oPrn:StartPage()
ENDIF
nPagina += 1
nLine := 50                       ็


oPrn:Say( nLine, 0100, " ", oFont8, 100 )

IF !Empty( GetMV( "MV_DIRLOGO" ) ) .AND. CEMPANT=='01'
	IF File( AllTrim( GetMV( "MV_DIRLOGO" ) ) ) .AND. MV_PAR09=1
		//oPrn:Box( nLine, 0050, nLine + 400, NMARGDERECHO ) //Cuadro de encabezado.
		nLine += 10
		//oPrn:SayBitmap( nLine + 20, 0100, AllTrim( GetMV( "MV_DIRLOGO" ) ) , 400, 150 )
		oPrn:SayBitmap( nLine + 20, 0100, AllTrim( GetMV( "MV_DIRLOGO" ) ) , 250, 250  )
     	//oPrn:Say( nLine + 200, 0300, AllTrim( SM0->M0_NOMECOM ), oFont10a, 100 )
	ELSE
		nLine += 10
	ENDIF
endif
	// ***********************Datos de cabecera**********************************
	//cIngBrut = ""
	nLine += 10
	oPrn:Say( nLine +  50, 1000, 'DOCUMENTO NO VมLIDO COMO FACTURA', oFont10, 100 )
	nline += 70      /// agrego 50
	IF CEMPANT=='01'
 	oPrn:Say( nLine + 220, 0100, AllTrim( SM0->M0_ENDCOB ) + " " + AllTrim( SM0->M0_CIDCOB ), oFont8, 100 )
	oPrn:Say( nLine + 260, 0100, "(" +  AllTrim( SM0->M0_CEPCOB ) + ") " + cProvCMS , oFont8, 100 )
	oPrn:Say( nLine + 300, 0100, "Tel.: (5411) 4568-9150" + SM0->M0_TEL + " - Fax.: (5411) 4568-9150" + SM0->M0_FAX , oFont8, 100 )
	oPrn:Say( nLine + 340, 0100, "C.U.I.T.: " + Alltrim(SM0->M0_CGC) , oFont8, 100 )
	//oPrn:Say( nLine + 300, 0100, "Ingresos Brutos: " + cIngBrut , oFont31, 100 )  
	ENDIF

//oPrn:Box( nLine +  40, 1900, nLine + 100, 2360 )  //Cuadro de numero de orden.
nLine += 40
oPrn:Say( nLine + 10, 1650, "Presupuesto Venta: " +SCJ->CJ_FILIAL+'-'+Right( cPresup, 6 ) , oFont10, 100 )
nLine += 125

oPrn:Say( nLine , 1650, "Fecha : "+DToC( SCJ->CJ_EMISSAO ), oFont10, 100 )
oPrn:Say( nLine + 110, 1850, "PAGINA: " + Transform( nPagina, "999" ), oFont8, 100 )

nLine += 310         ////////MODIFICAR ACA PARA BAJAR CLIENTE
// *******Datos de cliente***********
oPrn:Box( nLine - 20, 0050, nLine + 250, NMARGDERECHO )  
oPrn:Say( nLine, 0100, "Cliente: " + AllTrim( SA1->A1_NOME ) + ;
" (" + AllTrim( SA1->A1_COD ) + ") - Tel.: " + LEFT(AllTrim( SA1->A1_TEL ),15) + "  - Fax.: " + AllTrim( SA1->A1_FAX ), oFont8B, 100 )
nLine += 50
//oPrn:Say( nLine, 0100, "Domicilio: " + AllTrim( SA1->A1_END ) + if( !Empty(SCJ->CJ_XENDENT), "    Dir.Entrega/Obra: " + alltrim(SCJ->CJ_XENDENT), ""), oFont10, 100 )        
oPrn:Say( nLine, 0100, "Domicilio: " + AllTrim( SA1->A1_END ) , oFont8, 100 )        
If !Empty(SCJ->CJ_XCONTAC)                                                                     
		oPrn:Say( nLine, 1550, "Contacto: " + Alltrim(posicione("SU5",1, xfilial("SU5")+SCJ->CJ_XCONTAC, "U5_CONTAT")), oFont8, 100 )
EndIf
nLine += 50
oPrn:Say( nLine, 0100, "Localidad: " + Alltrim( SA1->A1_MUN ) + ;
If( SA1->A1_TIPO != "E", If( !Empty( cProvincia ), " - " + cProvincia, "" ), "   Pais: " + AllTrim( SYA->YA_DESCR ) ) + ;
		"   C. Postal: " + AllTrim( SA1->A1_CEP ), oFont8, 100 )
nLine += 50
oPrn:Say( nLine, 0100, "C.U.I.T.: " + AllTrim( SA1->A1_CGC ) , ofont8, 100 )
//oPrn:Say( nLine, 1550, "Moneda: " + cMoneda + cCot, ofont10, 100 )
nLine += 50
oPrn:Say( nLine, 0100, "I.V.A.: " + cSitIVA, oFont8, 100 )
//oPrn:Say( nLine, 1100, "Sucursal: " + SCJ->CJ_FILIAL, oFont8, 100 )
oPrn:Say( nLine, 1100, "Sucursal : " + CEMPANT+'/'+CFILANT, ofont8, 100 )
//oPrn:Say( nLine, 0100, "Atencion:  " + AllTrim( SCJ->CJ_XDIRCLI ) , ofont10, 100 )
//oPrn:Say( nLine, 1550, "V./REF. : " + AllTrim( SCJ->CJ_XREFCLI ), ofont10, 100 )
nLine += 90
//*******Observaciones*************
/*
If !Empty(SCJ->CJ_OBS)
	_oBserv := "OBSERVACIONES: " + Alltrim(SCJ->CJ_OBS)
	oPrn:Box( nLine-10, 0050, nLine + 40, NMARGDERECHO )
	oPrn:Say( nLine, 0100,_oBserv, oFont8, 100 )
	nLine += 80
EndIf
*/
		
//*******Cuadros de detalle********
oPrn:Box( nLine, 0050, nLine + 50, 0100 )   
oPrn:Box( nLine, 0100, nLine + 50, 0330 )         // + 300 Cantidad

oPrn:Box( nLine, 0330, nLine + 50, 1640 )         // + 300 Codigo
//oPrn:Box( nLine, 1330, nLine + 50, 1560 )         // + 300 P.Ent.
//oPrn:Box( nLine, 1560, nLine + 50, 1740 )         // + 300 Cantidad
oPrn:Box( nLine, 1640, nLine + 50, 1800 )         // + 300 Precio
oPrn:Box( nLine, 1800, nLine + 50, 1950 )         // + 300 Precio
oPrn:Box( nLine, 1950, nLine + 50, 2100 )         // + 200 % Desc.
oPrn:Box( nLine, 2100, nLine + 50, NMARGDERECHO ) // + 300 Neto.
//oPrn:Box( nLine, 0050, NULTIMALINEA, NMARGDERECHO )

nLine += 10

oPrn:Say( nLine, 0060, "IT /", oFont8, 100 )
oPrn:Say( nLine, 0370, "CODIGO             DESCRIPCION", oFont8, 100 )
//oPrn:Say( nLine, 1340, "Plazo Entrega", oFont8, 100 )
oPrn:Say( nLine, 0120, "CANT.", oFont8, 100 )
oPrn:Say( nLine, 1660, "PR.Lista", oFont8, 100 )
oPrn:Say( nLine, 2000, "PR.c/Dto", oFont8, 100 )
oPrn:Say( nLine, 1840, "% DTO.", oFont8, 100 )
oPrn:Say( nLine, 2170, "IMP.TOTAL", oFont8, 100 )
nLine += 40
oPrn:Box( nLine, 0050, NULTIMALINEA-200, 0100 )   
oPrn:Box( nLine, 0100, NULTIMALINEA-200, 0330 )         // + 300 Cantidad
oPrn:Box( nLine, 0330, NULTIMALINEA-200, 1640 )         // + 300 Codigo
oPrn:Box( nLine, 1640, NULTIMALINEA-200, 1800 )         // + 300 Precio
oPrn:Box( nLine, 1800, NULTIMALINEA-200, 1950 )         // + 300 Precio
oPrn:Box( nLine, 1950, NULTIMALINEA-200, 2100 )         // + 200 % Desc.
oPrn:Box( nLine, 2100, NULTIMALINEA-200, NMARGDERECHO ) // + 300 Neto.
nLine += 10
                                                     
FOR II=1 TO 4
 cCAMPO:='SCJ->CJ_DESC'+ALLTRIM(STR(II))
 IF &CCAMPO >0
    CTEXTDESC:=CTEXTDESC+IF(LEN(ALLTRIM(CTEXTDESC))=0,'','/')+ALLTRIM(STR(&CCAMPO))
 ENDIF
NEXT
RETURN NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintITEM บAutor  ณ MS				 บFecha ณ  03/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  IMPRESION ITEMS					                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP Exclusivo de Microsiga.                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION PrintItem( cPresup )
Private _cProdesc  := " ",;
_cCentcost := " ",;
_cSolicit  := " ",;
nIva:=1,;
cIva:=""   


DbSelectArea( "SCK" )
DbSetOrder( 1 )
DbSeek( cPresup, .t. )
WHILE ( CK_FILIAL+CK_NUM ) == cPresup                
			
			IF nLine >= NULTIMALINEA - 300
				nLine   += 50
				PrintFoot( .f., cPresup )
				PrintHead( cPresup )
			ENDIF

			if !Empty( CK_OBS )
				If Len( Alltrim(CK_OBS) ) < 140
					nLinFin := nLine + 80
				Else
					nLinFin := nLine + 120
				EndIf
			Else
				nLinFin := nLine + 30
			EndIf
					
			//_cProdesc := CK_PRODUTO + " " + Alltrim(CK_DESCRI)
			//_cProdesc := alltrim(CK_PRODUTO) + " - " +POSICIONE("SB1",1,XFILIAL("SB1")+SCK->CK_PRODUTO,"B1_DESC")
			_cProdesc := alltrim(CK_PRODUTO) + " - " + Alltrim(CK_XDESCRI)
			oPrn:Say( nLine, 0060, Transform(CK_ITEM,"99"), oFont8, 100 )
			oPrn:Say( nLine, 0150, TransForm( CK_QTDVEN ,  "@E 99999.99" ), oFont8, 100 )
			oPrn:Say( nLine, 0350, _cProdesc, oFont8, 100 )
            
            If CK_TES $ '602 603'
            	nIva:=1.21
            ElseIf CK_TES $ '600 601'
            	nIva:=1.105
            EndIf
            If SA1->A1_TIPO $ 'M|E|F'
            	ndto:= 100 - round( (SCK->CK_PRCVEN * 100 ) /  SCK->CK_PRUNIT,2)
            	CTEXTD1:=CTEXTDESC
            	IF SCK->CK_DESCONT >0
               		CTEXTD1:=CTEXTDESC+IF(LEN(ALLTRIM(CTEXTDESC))=0,'','/')+ALLTRIM(STR(SCK->CK_DESCONT))
            	ENDIF
            	if MV_PAR08 == 1                                                                                     
         	   		oPrn:Say( nLine, 1650, TransForm( ROUND((SCK->CK_PRUNIT*niva),2) ,  "@E 99,999.99" ), oFont8, 100 )// PRECIO DE LISTA
         	   		oPrn:Say( nLine, 1970, TransForm( ROUND((SCK->CK_PRCVEN*niva),2) ,  "@E 99,999.99" ), oFont8, 100 )// PRECIO CON DESCUENTO
			   		oPrn:Say( nLine, 1860,  CTEXTD1, oFont7, 100 )
			   		oPrn:Say( nLine, 2140, TransForm( ROUND((SCK->CK_VALOR*niva),2),  "@E 9999,999.99" ), oFont8, 100 )
				endif              
					//**********Totalizadores******************************
 	           nTotGRAL += ROUND((SCK->CK_VALOR*nIva),2)
			Else   
				ndto:= 100 - round( (SCK->CK_PRCVEN * 100) /  SCK->CK_PRUNIT,2)
            	CTEXTD1:=CTEXTDESC
            	IF SCK->CK_DESCONT >0
               		CTEXTD1:=CTEXTDESC+IF(LEN(ALLTRIM(CTEXTDESC))=0,'','/')+ALLTRIM(STR(SCK->CK_DESCONT))
            	ENDIF
            	if MV_PAR08 == 1                                                                                     
         	   		oPrn:Say( nLine, 1650, TransForm( SCK->CK_PRUNIT ,  "@E 99,999.99" ), oFont8, 100 )// PRECIO DE LISTA
         	   		oPrn:Say( nLine, 1970, TransForm( SCK->CK_PRCVEN ,  "@E 99,999.99" ), oFont8, 100 )// PRECIO CON DESCUENTO
			   		oPrn:Say( nLine, 1860,  CTEXTD1, oFont7, 100 )
			   		oPrn:Say( nLine, 2140, TransForm( SCK->CK_VALOR,  "@E 9999,999.99" ), oFont8, 100 )
				endif                                                                             
					//**********Totalizadores******************************
 	           nTotGRAL += SCK->CK_VALOR
			EndIf
			                                                                                                             
			
			nLine   += 30
			nLine   += 30   
	           
   	   //ENDIF
			DbSkip()
ENDDO

IF nLine >= NULTIMALINEA - 300
			nLine   += 50
			PrintFoot( .f., cPresup )
			PrintHead( cPresup )
ENDIF    
IF MV_PAR08 == 1                                                                                     
   nLine += 40 
   if nLine < NULTIMALINEA - 350 
      nLine := NULTIMALINEA - 350
   endif
   //oPrn:Say( nLine+100, 0100, "Los precios NO incluyen impuestos", oFont8, 100 )
   //oPrn:Say( nLine, 1200, "Subtotal sin desc. generales: ", oFont9, 100 )
   //oPrn:Say( nLine, 2140, TransForm( nTotGRAL,  "@E 9999,999.99" ), oFont9b, 100 )
ENDIF

IF nLine >= NULTIMALINEA - 300
	nLine   += 50
	PrintFoot( .f., cPresup )
	PrintHead( cPresup )
ENDIF
nLine += 50     

	
RETURN NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintFOOT บAutor  ณ MS				 บFecha ณ  03/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  IMPRESION PIE					                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP Exclusivo de Microsiga.                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION PrintFoot( lEnd, cPresup )

lEnd := If( ValType( lEnd ) != "L", .t., lEnd )

//**********************************Impresion de totales, solo en pagina final*************************
IF lEnd      //Filtro solo pagina final

        //oPrn:Box( NULTIMALINEA, 0050, NULTIMALINEA+250, NMARGDERECHO ) //Cuadro de encabezado.
        ntotdesc:=0
		If SCJ->CJ_DESC1 > 0 .or. SCJ->CJ_DESC2 > 0 .or. SCJ->CJ_DESC3 > 0 .or. SCJ->CJ_DESC4 > 0
				nTotDesc := nTotGRAL - ((((nTotGRAL*(100-SCJ->CJ_DESC1)/100)*(100-SCJ->CJ_DESC2)/100)*(100-SCJ->CJ_DESC3)/100)*(100-SCJ->CJ_DESC4)/100)
				//oPrn:Say( nLine, 1200, "Descuento Gral: " , oFont8, 100 )
				//oPrn:Say( nLine, 2140, TransForm( nTotDesc,  "@E 9999,999.99" ), oFont9b, 100)
		EndIf

		aImposto:={}
		CalculoImpos()  
		nLine   	+= 100
		nLine1 		:= nLine
		nToto		:= 0
		
		If !empty(aImposto)
		For nX := 1 To Len(aImposto)   
			
			If SA1->A1_TIPO $ 'M|E|F'              
			
			Else
				oPrn:Say( nLine1, 1200, ALLTRIM(aImposto[nX][1])							   	, oFont10, 100 )
				oPrn:Say( nLine1, 1400, "%" +TransForm( aImposto[nX][3],  "@E 9999,999.99" )	, oFont10, 100 )
				oPrn:Say( nLine1, 1600, "$" +TransForm( aImposto[nX][2],  "@E 9999,999.99" )	, oFont10, 100 )
				oPrn:Say( nLine1, 2100, "$" +TransForm( aImposto[nX][4],  "@E 9999,999.99" )	, oFont10, 100 )
				//oPrn:Say( nLine1, 2100, "%" +TransForm( aImposto[nX][5],  "@E 9999,999.99" )	, oFont10, 100 )
				
			EndIf                   
				
				If nX==1
					nSinimp := aImposto[nX][2]
					If len (aimposto)> 1
					If aImposto[2][2]<>aImposto[nX][2] 
				    	nSinimp += aImposto[2][2] 	
					EndIf
					
					Endif
				EndIf
				If Len(aImposto)==nX                      	
					nToto   += aImposto[nX][4] + nSinimp
				Else 
					nToto   += aImposto[nX][4]
				EndIf
				nLine1  += csum                              
		Next
		EndIf	          
		If nToto>0
			oPrn:Say( nLine1, 1200, "T O T A L   " , oFont10N, 100 )
			oPrn:Say( nLine1, 2100, "$"+TransForm(nToto,  "@E 999,999,999,999.99" ) , oFont10N, 100 )
			nLine1 += csum
		EndIf		
		
		nLine := NULTIMALINEA+50
        oPrn:Say( nLine-50, 0080,  if( !Empty(SCJ->CJ_XENDENT), "Dir.Entrega/Obra: " + alltrim(SCJ->CJ_XENDENT), ""), oFont8, 100 )        

        oPrn:Say( nLine, 0080, "Validez de Oferta: " + dtoc(SCJ->CJ_VALIDA), oFont8, 100 )
		
		//oPrn:Say( nLine, 1200, "Condici๓n de Pago: " + AllTrim( SE4->E4_DESCRI ), oFont8, 100 )
		nLine   += 50
		oPrn:Say( nLine, 0080, "Emitio: "+UsrFullName(retcodusr()), oFont8, 100 )
        oPrn:Say( nLine1, 1200, "Aprobo: " + Alltrim(mv_par05), oFont8, 100 )
		nLine   += 50
		nLine1   += 50
		oPrn:Say( nLine, 0080, "Vendedor: " + SA3->A3_NOME, oFont8, 100 )
        oPrn:Say( nLine1, 0900, "*** Favor indicar numero de presupuesto en todo lo relacionado con el mismo. ***", oFont8, 100 )
		nLine   += 50
		//oPrn:Say( nLine, 0080, "Lugar de entrega: " + SCJ->CJ_XOBS, oFont8, 100 )
			
ELSE
		aText3 := {}
		CTEXTDESC:= ""
		oPrn:Say( nLine+50, 1800, "CONTINUA EN PAGINA :" + Transform( (nPagina + 1), "@E 99" ), oFont8, 100 )
ENDIF
nLine += 350

oPrn:EndPage()

RETURN NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณ MS				 บFecha ณ  03/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  PREGUNTAS INICIALES				                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP Exclusivo de Microsiga.                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION ValidPerg( cPerg )

LOCAL cAlias := Alias(), ;
aRegs  := {}, ;
i, ;
j

DbSelectArea( "SX1" )
DbSetOrder( 1 )

cPerg := PadR( cPerg, 10 )

AAdd( aRegs, { cPerg, "01", "Desde Presupuesto?", "Desde Presupuesto?", "Desde Presupuesto?", "mv_ch1", "C", 06, 00, 0, "G", "", "mv_par01",""  ,""  ,""  ,"","",""  ,""  ,""  ,"","","","","","","","","","","","","","","","","","","" } )
AAdd( aRegs, { cPerg, "02", "Hasta Presupuesto?", "Hasta Presupuesto?", "Hasta Presupuesto?", "mv_ch2", "C", 06, 00, 0, "G", "", "mv_par02",""  ,""  ,""  ,"","",""  ,""  ,""  ,"","","","","","","","","","","","","","","","","","","" } )
AAdd( aRegs, { cPerg, "03", "Previsualizacion ?", "Previsualizacion ?", "Previsualizacion ?", "mv_ch3", "N", 01, 00, 0, "C", "", "mv_par03","Si","Si","Si","","","No","No","No","","","","","","","","","","","","","","","","","","","" } )
AAdd( aRegs, { cPerg, "04", "Validez ?         ", "Validez ?         ", "Validez ?         ", "mv_ch4", "C", 15, 00, 0, "G", "", "mv_par04",""  ,""  ,""  ,"","",""  ,""  ,""  ,"","","","","","","","","","","","","","","","","","","" } )
AAdd( aRegs, { cPerg, "05", "Aprobo ?          ", "Aprobo ?          ", "Aprobo ?          ", "mv_ch5", "C", 20, 00, 0, "G", "", "mv_par05",""  ,""  ,""  ,"","",""  ,""  ,""  ,"","","","","","","","","","","","","","","","","","","" } )
AAdd( aRegs, { cPerg, "06", "Envia Mail ?      ", "Envia Mail ?      ", "Envia Mail ?      ", "mv_ch6", "N", 01,  0, 1, "C", "", "mv_par06","Si","Si","Si","","","No","No","No","","","","","","","","","","","","","","","","","","","" } )
AAdd( aRegs, { cPerg, "07", "Imprime Leyendas? ", "Imprime Leyendas? ", "Imprime Leyendas? ", "mv_ch7", "N", 01,  0, 1, "C", "", "mv_par07","Si","Si","Si","","","No","No","No","","","","","","","","","","","","","","","","","","","" } )
AAdd( aRegs, { cPerg, "08", "Imprime Precios?  ", "Imprime Precios?  ", "Imprime Precios?  ", "mv_ch8", "N", 01,  0, 1, "C", "", "mv_par08","Si","Si","Si","","","No","No","No","","","","","","","","","","","","","","","","","","","" } )
AAdd( aRegs, { cPerg, "09", "Imprime Logos?    ", "Imprime Logos?    ", "Imprime Logos?    ", "mv_ch9", "N", 01,  0, 1, "C", "", "mv_par08","Si","Si","Si","","","No","No","No","","","","","","","","","","","","","","","","","","","" } )

FOR i := 1 TO Len( aRegs )

   IF !DbSeek( cPerg + aRegs[i,2] )

      RecLock( "SX1", .t. )

      FOR j:=1 TO FCount()

         IF j <= Len( aRegs[i] )
            FieldPut( j, aRegs[i,j] )
         ENDIF

      NEXT

      MsUnlock()

   ENDIF

NEXT

DbSelectArea( cAlias )

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณENVIAEMAILบAutor  ณMicrosiga           บ Data ณ  12/12/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ENVIAEMAIL()

Local lResult   := .f.           // Resultado da tentativa de comunicacao com servidor de E-Mail
Local cTitulo

//cDestin   := "PLonardo@micro.com.ar"
//cDestin   := "gbermudez@microsiga.com"
//cTitulo   := "Prueba de informe grafico"
cDocument := oPrn:cDocument
cMensagem := cDocument
cAnexo    := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tenta conexao com o servidor de E-Mail ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CONNECT SMTP                         ;
SERVER    GetMV("MV_RELSERV");   // Nome do servidor de e-mail
ACCOUNT  GetMV("MV_RELACNT");    // Nome da conta a ser usada no e-mail
PASSWORD GetMV("MV_RELPSW") ;    // Senha
TIMEOUT 30 ;
RESULT   lResult              // Resultado da tentativa de conexใo

If !lResult

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Nao foi possivel estabelecer conexao com o servidor ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   Help(" ",1,"ACAA170_01")   // _cErro := MailGetErr()

Else

   SEND MAIL;
   FROM     GetMV("MV_RELFROM");
   TO       cDestin;
   SUBJECT  cTitulo;
   BODY     cMensagem;
   RESULT   lResult

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Finaliza conexao com o servidor de E-Mail ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   DISCONNECT SMTP SERVER

EndIf
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSendMail	บAutor  ณMicrosiga           บ Data ณ  12/12/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SendMail(oPrinta,lDireto)
Private aUsuario    := "", oDlgMail, nOp:=0
Private aFiles      := {}, lDiret:=lDireto, oPrint:=oPrinta
Private cFrom       := GetMV("MV_RELFROM")
Private cServer     := AllTrim(GetNewPar("MV_RELSERV"," ")) // "mailhost.average.com.br" //Space(50)
Private cAccount    := AllTrim(GetNewPar("MV_RELACNT"," ")) //Space(50)
Private cPassword   := AllTrim(GetNewPar("MV_RELPSW" ," "))  //Space(50)
Private nTimeOut    := GetMv("MV_RELTIME",,120) //Tempo de Espera antes de abortar a Conexใo
Private lAutentica  := GetMv("MV_RELAUTH",,.F.) //Determina se o Servidor de Email necessita de Autentica็ใo
Private cUserAut    := Alltrim(GetMv("MV_RELAUSR",,cAccount)) //Usuแrio para Autentica็ใo no Servidor de Email
Private cPassAut    := Alltrim(GetMv("MV_RELAPSW",,cPassword)) //Senha para Autentica็ใo no Servidor de Email
Private cTo         := Alltrim(SA1->A1_EMAIL)
Private cCC         := space(200)
Private cSubject    := "Presupuesto de ventas: "+SCK->CK_NUM
Private cDocument   := oPrint:cDocument, cDiretorio:="", x:=1

If !lDiret
   PswOrder(1)
   PswSeek(__CUSERID,.T.)
   aUsuario := PswRet(1)
   cCC := cFrom := AllTrim(aUsuario[1,14])
   cCC := cCC + SPACE(200)
   
Else
   nOp:=1
EndIf

If nOp = 1

   MsAguarde({||GeraMail()},"AGUARDE","GENERANDO ARCHIVOS...")

EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraMail	บAutor  ณMicrosiga           บ Data ณ  12/12/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraMail()
Local nSequencia:=0, X
Local cAnexos     := ""
Local lOk       := .T.
Private nPageHeight:=nPageWidth:=NIL
Private cBody:=""

cDiretorio := AllTrim(GetNewPar("MV_RELT"," "))
If EMPTY(cDiretorio)
   cDiretorio := "\"
EndIf

If GetMV("MV_SEQAVP",.T.)
   Do While .T.
      If RecLock("SX6",.F.)
         nSequencia := GetMV("MV_SEQAVP") + 1
         If nSequencia = 999
            nSequencia := 0
         EndIf
         Exit
      EndIf
   EndDo
Else
   If RecLock("SX6",.T.)
      SX6->X6_VAR     := "MV_SEQAVP"
      SX6->X6_TIPO    := "N"
      SX6->X6_DESCRIC := "Salva sequencia de arquivos JPG do AVPrint"
   EndIf
EndIf

SetMV("MV_SEQAVP",nSequencia)
IF(ExistBlock("AVPRINTE"),Execblock("AVPRINTE",.F.,.F.,"ORIENTACAO"),)

   IF nPageWidth # NIL .AND. nPageHeight # NIL
      //   oPrint:SaveAllAsJPEG(cStartPath+cJPEG,870,840,140)
      If ! oPrint:SaveAllAsJPEG( cDiretorio+Alltrim(Str(nSequencia)),870,840,140 ) // Passar o diret๓rio abaixo do root path + as 3 primeiras letras do nome do arquivo a ser gerado
         Help("",1,"AVG0001055")
         Return .F.
      EndIf
   ELSE
      If ! oPrint:SaveAllAsJPEG( cDiretorio+Alltrim(Str(nSequencia)),880,990,140) // Passar o diret๓rio abaixo do root path + as 3 primeiras letras do nome do arquivo a ser gerado
         Help("",1,"AVG0001055")
         Return .F.
      EndIf
   ENDIF
   If lDiret

      MsProcTxt("ENVIANDO E-MAIL...")
      cBody  := "Se adjunta layout de Orden de compra: "+SCK->CK_NUM

      // Varre o diret๓rio e procura pelas pแginas gravadas.
      aFiles := Directory( cDiretorio+Alltrim(Str(nSequencia))+"*.jpg" )

      For X:= 1 to Len(aFiles)
         cAnexos += cDiretorio+aFiles[X,1] + "; "
      Next X

      cTo := AvLeGrupoEMail(cTo)
      cCC := AvLeGrupoEMail(cCC)

      IF(ExistBlock("AVPRINTE"),Execblock("AVPRINTE",.F.,.F.,"EMAIL"),)
         CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword TIMEOUT nTimeOut Result lOk
         If lOk
            If lAutentica
               If !MailAuth(cUserAut,cPassAut)
                  MSGINFO("Falla de autentificacion de usuario","Atencion")
                  DISCONNECT SMTP SERVER RESULT lOk
                  IF !lOk
                     GET MAIL ERROR cErrorMsg
                     MSGINFO("Error de conexion: "+cErrorMsg,"Atencion")
                  ENDIF
                  Return .F.
               EndIf
            EndIf
            If !Empty(cCC)
               SEND MAIL FROM cFrom TO cTo CC cCC SUBJECT cSubject BODY cBody ATTACHMENT cAnexos Result lOk
            Else
               SEND MAIL FROM cFrom TO cTo SUBJECT cSubject BODY cBody ATTACHMENT cAnexos Result lOk
            EndIf
            If !lOk
               GET MAIL ERROR cErrorMsg
               Help("",1,"AVG0001056",,"Error: "+cErrorMsg,2,0)
            EndIf
         Else
            GET MAIL ERROR cErrorMsg
            Help("",1,"AVG0001057",,"Error: "+cErrorMsg,2,0)
         EndIf
         DISCONNECT SMTP SERVER RESULT lOk
         IF !lOk
            GET MAIL ERROR cErrorMsg
            MSGINFO("Error de conexion: "+cErrorMsg,"Atencion")
         ENDIF

         For X:= 1 to Len(aFiles)
            FErase(cDiretorio+aFiles[X,1])
         Next X

      EndIf

      Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAvLeGrupoEMailบAutor  ณMicrosiga       บ Data ณ  12/12/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AvLeGrupoEMail(cEmail)
LOCAL cPart,nAt,cSend:=""
IF EMPTY(cEmail)
   RETURN cEmail
ENDIF
cEmail := Alltrim(cEmail)
IF RIGHT(cEmail,1) # ";"
   cEmail += ";"
ENDIF
DO While (nAt := AT(";",cEmail)) > 0
   cPart := Subs(cEmail,1,nAT-1)
   If !Empty(cPart)
      If !Empty(cSend)
         cSend += ";"
      EndIf                 
      If !("@"$cPart)
         cSend += Lower(Alltrim(RetProfDef(Subs(cUsuario,7,15),"AP5WAB","GROUP",cPart)))
      Else
         cSend += Lower(cPart)
      EndIf
   Endif
   cEmail := Subs(cEmail,nAT+1)
EndDO
RETURN cSend

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncion   ณ X5DES    ณ Autor ณ MS				    ณ Data ณ 12/07/99 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrip.  ณ Devuelve el Valor de una Clave de una Tabla en SX5.        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณAl pedo ya hay una funcion padron que lo hace y BIEN        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function X5des(cTabla,cClave)

SetPrvt("_ALIAS,CDESCRIPCION,")

_alias := alias()
dbSelectArea("SX5")
dbSetOrder(1)
dbSeek(xFilial("SX5")+cTabla+cClave)
cDescripcion   := RTRIM(SX5->X5_DESCSPA)

dbSelectArea(_alias)
Return(cDescripcion)
                      
/*                                 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCImpArg           บAutor  ณFernando Bombardi   บ Data ณ  11/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo do Valor dos Impostos Argentina                            บฑฑ
ฑฑบ          ณ                                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RFAT001A                                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CalculoImpos()
Local cQuery:= ""
 			cQuery := "exec [IMPPRESUP_"+SM0->M0_CODIGO+"]'"+SCJ->CJ_NUM+"','"+xFilial("SCJ")+"','"+AllTrim(GetMV("MV_AGENTE"))+"'"
			cQuery := PLSAvaSQL(cQuery)
		    If Select("TODO01") <> 0
          		DBSelectArea("TODO01")
          		TODO01->(DBCloseArea())
    	 	EndIf
   		  	// Executa a Query
     		PLSQuery(cQuery,"TODO01")
   		  	// Vai para o inicio da area de trabalho
     		TODO01->(DBGoTop())
  		    While TODO01->(!Eof())
  		   		AADD( aImposto, {TODO01->DESCRIPCION,TODO01->NETO,TODO01->ALICUOTA,TODO01->VALOR} )
  		    	DbSkip()
			Enddo    
Return()                          