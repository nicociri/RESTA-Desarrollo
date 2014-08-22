#include "rwmake.ch"
#include "ap5mail.ch"

#Define DETAILBOTTOM 1900
#define NMARGDERECHO 2300
#define NULTIMALINEA 2900
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PRESUP �Autor  � MS					 �Fecha �  03/09/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Layout de Presupuesto de Ventas.                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP Exclusivo de Microsiga.                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//Pendiente linea 273 Gustavo Elias
// MV_SCRORC

USER FUNCTION ljPresup()

PRIVATE lPrinted   := .f.

ValidPerg( "LJPRESUP" )

If FUNNAME()=='LOJA701'
	mv_par01 := SL1->L1_NUM
	mv_par02 := SL1->L1_NUM
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
	DbSeek( "LJPRESUP" + "04" )
	While !Eof() .and. X1_GRUPO = "LJPRESUP"
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
	IF Pergunte( "LJPRESUP", .t. )
		RptStatus( { || SelectComp() } )
	ENDIF
EndIf

RETURN nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SelectComp �Autor  � MS				 �Fecha �  03/09/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �  PROCESAMIENTO					                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP Exclusivo de Microsiga.                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
DbSelectArea( "SL1" )
DbSetOrder( 1 )

DbSeek( xFilial() + mv_par01, .t. )
SetRegua( ( Val( mv_par02 ) - Val( mv_par01 ) ) + 1 )

While !Eof() .and. SL1->L1_FILIAL = xFilial() .AND. SL1->L1_NUM <= mv_par02
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PrintComp �Autor  � MS				 �Fecha �  03/09/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �  IMPRESION COMPROBANTES			                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP Exclusivo de Microsiga.                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION PrintComp()

PRIVATE nLine   := 0, ;
cPresup    		:= xFilial('SL1') + SL1->L1_NUM,;
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

cMoneda := aDescMon[ If( Empty( SL1->L1_MOEDA ), 1, SL1->L1_MOEDA ) ]
cSigno  := aSimbMon[ If( Empty( SL1->L1_MOEDA ), 1, SL1->L1_MOEDA ) ]
cCot:=if(ALLTRIM(cMoneda)="1"," "," (Cot: "+transf(SL1->L1_TXMOEDA,"99.99")+")")
   
DbSelectArea( "SA1" )
DbSeek( xFilial( "SA1" ) + SL1->L1_CLIENTE + SL1->L1_LOJA )

DbSelectArea( "SYA" )
DbSeek( xFilial( 'SYA' ) + SA1->A1_PAIS  )
DbSelectArea( "SE4" )
DbSeek( xFilial( "SE4" ) + SL1->L1_CONDPG )

DbSelectArea( "SA3" )
DbSeek( xFilial() + SL1->L1_VEND )
 
DbSelectArea( "SL1" )

cProvincia := U_X5Des( "12", SA1->A1_EST )
cSitIVA    := U_X5Des( "SF", SA1->A1_TIPO )
cProvCMS   := U_X5Des( "12", SM0->M0_ESTCOB )

PrintHead( cPresup )
PrintItem( cPresup )
PrintFoot( .t., cPresup )
//PrintLeyen()// Imprime Leyendas

DbSelectArea( "SL1" )

RETURN nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PrintHead �Autor  � MS				 �Fecha �  03/09/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �  IMPRESION CABECERA				                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP Exclusivo de Microsiga.                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION PrintHead( cPresup )

IF !lPrinted
	lPrinted := .t.
ELSE
	oPrn:StartPage()
ENDIF
nPagina += 1
nLine := 50                       �


oPrn:Say( nLine, 0100, " ", oFont8, 100 )

IF !Empty( GetMV( "MV_DIRLOGO" ) )
	IF File( AllTrim( GetMV( "MV_DIRLOGO" ) ) ) .AND. MV_PAR09=1
		//oPrn:Box( nLine, 0050, nLine + 400, NMARGDERECHO ) //Cuadro de encabezado.
		nLine += 10
		//oPrn:SayBitmap( nLine + 20, 0100, AllTrim( GetMV( "MV_DIRLOGO" ) ) , 400, 150 )
		oPrn:SayBitmap( nLine + 20, 0100, AllTrim( GetMV( "MV_DIRLOGO" ) )   )
     	//oPrn:Say( nLine + 200, 0300, AllTrim( SM0->M0_NOMECOM ), oFont10a, 100 )
	ELSE
		nLine += 10
	ENDIF
endif
	// ***********************Datos de cabecera**********************************
	//cIngBrut = ""
	nLine += 10
	//oPrn:Box( nLine +  30, 1100, nLine + 140, 1250 )  //cuadro de X.
	oPrn:Say( nLine +  50, 1000, 'DOCUMENTO NO V�LIDO COMO FACTURA', oFont10, 100 )
	//oPrn:Say( nLine +  50, 1157, "X", oFont10, 100 )
	nline += 70      /// agrego 50
	//oPrn:Say( nLine + 160, 1030, "Documento no valido", oFont8, 100 )
	//oPrn:Say( nLine + 190, 1070, "como factura", oFont8, 100 )
	oPrn:Say( nLine + 220, 0100, AllTrim( SM0->M0_ENDCOB ) + " " + AllTrim( SM0->M0_CIDCOB ), oFont8, 100 )
	oPrn:Say( nLine + 260, 0100, "(" +  AllTrim( SM0->M0_CEPCOB ) + ") " + cProvCMS , oFont8, 100 )
	oPrn:Say( nLine + 300, 0100, "Tel.: (5411) 4568-9150" + SM0->M0_TEL + " - Fax.: (5411) 4568-9150" + SM0->M0_FAX , oFont8, 100 )
	oPrn:Say( nLine + 340, 0100, "C.U.I.T.: " + Alltrim(SM0->M0_CGC) , oFont8, 100 )
	//oPrn:Say( nLine + 300, 0100, "Ingresos Brutos: " + cIngBrut , oFont31, 100 )

//oPrn:Box( nLine +  40, 1900, nLine + 100, 2360 )  //Cuadro de numero de orden.
nLine += 40
oPrn:Say( nLine + 10, 1650, "Presupuesto Venta: " +SL1->L1_FILIAL+'-'+Right( cPresup, 6 ) , oFont10, 100 )
nLine += 125

oPrn:Say( nLine , 1650, "Fecha : "+DToC( SL1->L1_EMISSAO ), oFont10, 100 )
oPrn:Say( nLine + 110, 1850, "PAGINA: " + Transform( nPagina, "999" ), oFont8, 100 )

nLine += 310         ////////MODIFICAR ACA PARA BAJAR CLIENTE
// *******Datos de cliente***********
oPrn:Box( nLine - 20, 0050, nLine + 250, NMARGDERECHO )  
oPrn:Say( nLine, 0100, "Cliente: " + AllTrim( SA1->A1_NOME ) + ;
" (" + AllTrim( SA1->A1_COD ) + ") - Tel.: " + LEFT(AllTrim( SA1->A1_TEL ),15) + "  - Fax.: " + AllTrim( SA1->A1_FAX ), oFont8B, 100 )
nLine += 50
//oPrn:Say( nLine, 0100, "Domicilio: " + AllTrim( SA1->A1_END ) + if( !Empty(SL1->L1_XENDENT), "    Dir.Entrega/Obra: " + alltrim(SL1->L1_XENDENT), ""), oFont10, 100 )        
oPrn:Say( nLine, 0100, "Domicilio: " + AllTrim( SA1->A1_END ) , oFont8, 100 )        
If !Empty(SA1->A1_CONTATO)                                                                     
		oPrn:Say( nLine, 1550, "Contacto: " + Alltrim(SA1->A1_CONTATO), oFont8, 100 )
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
oPrn:Say( nLine, 1100, "Sucursal: " + SL1->L1_FILIAL, oFont8, 100 )
//oPrn:Say( nLine, 0100, "Atencion:  " + AllTrim( SL1->L1_XDIRCLI ) , ofont10, 100 )
//oPrn:Say( nLine, 1550, "V./REF. : " + AllTrim( SL1->L1_XREFCLI ), ofont10, 100 )
nLine += 90
//*******Observaciones*************
/*
If !Empty(SL1->L1_OBS)
	_oBserv := "OBSERVACIONES: " + Alltrim(SL1->L1_OBS)
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
                                                     
/*FOR II=1 TO 4
 cCAMPO:='SL1->L1_DESC'+ALLTRIM(STR(II))
 IF &CCAMPO >0
    CTEXTDESC:=CTEXTDESC+IF(LEN(ALLTRIM(CTEXTDESC))=0,'','/')+ALLTRIM(STR(&CCAMPO))
 ENDIF
NEXT
RETURN NIL*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PrintITEM �Autor  � MS				 �Fecha �  03/09/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �  IMPRESION ITEMS					                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP Exclusivo de Microsiga.                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION PrintItem( cPresup )
Private _cProdesc  := " ",;
_cCentcost := " ",;
_cSolicit  := " "

DbSelectArea( "SL2" )
DbSetOrder( 1 )
DbSeek( cPresup, .t. )
WHILE ( L2_FILIAL+L2_NUM ) == cPresup                

			IF nLine >= NULTIMALINEA - 300
				nLine   += 50
				PrintFoot( .f., cPresup )
				PrintHead( cPresup )
			ENDIF

			/*if !Empty( CK_OBS )
				If Len( Alltrim(CK_OBS) ) < 140
					nLinFin := nLine + 80
				Else
					nLinFin := nLine + 120
				EndIf
			Else
				nLinFin := nLine + 30
			EndIf*/
					
			//_cProdesc := CK_PRODUTO + " " + Alltrim(CK_DESCRI)
			_cProdesc := alltrim(L2_PRODUTO) + " - " +POSICIONE("SB1",1,XFILIAL("SB1")+SL2->L2_PRODUTO,"B1_DESC")
			//_cProdesc :=  alltrim(CK_PRODUTO) + " - " + Alltrim(CK_DESCRI)
			oPrn:Say( nLine, 0060, Transform(L2_ITEM,"99"), oFont8, 100 )
			oPrn:Say( nLine, 0150, TransForm( L2_QUANT ,  "@E 99999.99" ), oFont8, 100 )
			oPrn:Say( nLine, 0350, _cProdesc, oFont8, 100 )
 //			oPrn:Say( nLine, 1420, TransForm( CK_XPLAZOE,  "9999" ), oFont9, 100 )
//			oPrn:Say( nLine, 0110, TransForm( CK_QTDVEN ,  "@E 99999.99" ), oFont9, 100 )
//			oPrn:Say( nLine, 1600, TransForm( CK_QTDVEN ,  "@E 99999.99" )+" "+CK_UM, oFont9, 100 )
            
            if MV_PAR08 == 1                                                                                     
         	   oPrn:Say( nLine, 1700, TransForm( L2_PRCTAB ,  "@E 99,999.99" ), oFont8, 100 )// PRECIO DE LISTA
         	   oPrn:Say( nLine, 1860, TransForm( L2_DESC,  "@E 99.99" ), oFont8, 100 )//%descuento
 			   //QUE ANIMAL QUE SOY!! le mande precio de lista menos el descuento total y empezo a tirar numeros negativos
 			   //se cambia la linea para que use directamente L2_VRUNIT. Nicolas Cirigliano 14/04/14
 			   //oPrn:Say( nLine, 1970, TransForm( L2_PRCTAB-L2_VALDESC ,  "@E 99,999.99" ), oFont8, 100 )// PRECIO CON DESCUENTO
 			   oPrn:Say( nLine, 1970, TransForm( L2_VRUNIT ,  "@E 99,999.99" ), oFont8, 100 )// PRECIO CON DESCUENTO
			   //oPrn:Say( nLine, 2020, TransForm( CK_DESCONT,  "@E 99.99" ), oFont9, 100 )
			   //oPrn:Say( nLine, 2140, TransForm( CK_PRUNIT+CK_QTDVEN  ,  "@E 9999,999.99" ), oFont9, 100 )
			   //Repito la animalada aca. Nicolas Cirigliano 14/04/14
			   //oPrn:Say( nLine, 2140, TransForm( L2_QUANT*(L2_PRCTAB-L2_VALDESC),  "@E 9999,999.99" ), oFont8, 100 )
			   oPrn:Say( nLine, 2140, TransForm( L2_VLRITEM,  "@E 9999,999.99" ), oFont8, 100 )
			endif                                                                                                             
			
			nLine   += 30
			
	        
			//**********Totalizadores******************************
 			
   	           //nTotGRAL += L2_QUANT*(L2_PRCTAB-L2_VALDESC)
   	           nTotGRAL += L2_VLRITEM
   	   
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
*

	
RETURN NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PrintFOOT �Autor  � MS				 �Fecha �  03/09/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �  IMPRESION PIE					                          ���  

�������������������������������������������������������������������������͹��
���Uso       � AP Exclusivo de Microsiga.                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION PrintFoot( lEnd, cPresup )

lEnd := If( ValType( lEnd ) != "L", .t., lEnd )
nSumaImp := 0

//**********************************Impresion de totales, solo en pagina final*************************

IF lEnd      //Filtro solo pagina final
        //oPrn:Box( NULTIMALINEA, 0050, NULTIMALINEA+250, NMARGDERECHO ) //Cuadro de encabezado.
        
        //Impuestos: SL1 graba impuestos, pero como la SFB no tiene un indice por COLVPRO y no quiero hacer
        //query, se lo hardcodeo y se va a lpmqlp
        
        aImps := {}
		
		//IVA - REGIMEN GENERAL 21%
		if SL1->L1_VALIMP1 >0
			Aadd(aImps,{'IVA 21', SL1->L1_VALIMP1})	
		endif
  		
  		//IVA - R.G. 10.5%              
		if SL1->L1_VALIMP2 >0
			Aadd(aImps,{'IVA 10.5', SL1->L1_VALIMP2})	
		endif
		
		//IVA - SERVICIOS  27%          
		if SL1->L1_VALIMP3 >0
			Aadd(aImps,{'IVA 27', SL1->L1_VALIMP3})	
		endif
		
		//PERC. IVA RG.3337             
		if SL1->L1_VALIMP4 >0
			Aadd(aImps,{'Perc. IVA', SL1->L1_VALIMP4})	
		endif
		
		//PERC. INGR.BRUTOS RG.672/95 CF
		if SL1->L1_VALIMP5 >0
			Aadd(aImps,{'Perc. IIBB CF', SL1->L1_VALIMP5})	
		endif
		
		//PERC.INGR.BRUTOS RG. 38/95 BA 
		if SL1->L1_VALIMP6 >0
			Aadd(aImps,{'Perc. IIBB BA', SL1->L1_VALIMP6})	
		endif
		
		nLine	:= nLine - (50*(len(aImps)+1))
		oPrn:Say( nLine, 1200, "Subtotal sin desc. generales: ", oFont9, 100 )
   		oPrn:Say( nLine, 2140, TransForm( nTotGRAL,  "@E 9999,999.99" ), oFont9b, 100 )		
   		nLine   += 50
   		if SL1->L1_DESCNF <> 0
			oPrn:Say( nLine, 1200, "Descuento " +  str(SL1->L1_DESCNF) + "%:" , oFont8, 100 )
		    oPrn:Say( nLine, 2140, TransForm( SL1->L1_DESCONT,  "@E 9999,999.99" ), oFont8, 100)
			nLine   += 50
		endif
		for imps = 1 to len(aImps)
			oPrn:Say( nLine, 1200, aImps[imps][1] , oFont8, 100 )
			oPrn:Say( nLine, 2140, TransForm( aImps[imps][2],  "@E 9999,999.99" ), oFont8, 100)
			nSumaImp += aImps[imps][2]
			nLine   += 50
		next

		oPrn:Say( nLine, 1200, "Total: " , oFont8, 100 )
	    oPrn:Say( nLine, 2140, TransForm( nTotGRAL+nSumaImp-SL1->L1_DESCONT,  "@E 9999,999.99" ), oFont8, 100)
		nLine := NULTIMALINEA+50
        //oPrn:Say( nLine-50, 0080,  if( !Empty(SL1->L1_XENDENT), "Dir.Entrega/Obra: " + alltrim(SL1->L1_XENDENT), ""), oFont8, 100 )        

        oPrn:Say( nLine, 0080, "Validez de Oferta: " + dtoc(SL1->L1_DTLIM), oFont8, 100 )
		
		//oPrn:Say( nLine, 1200, "Condici�n de Pago: " + AllTrim( SE4->E4_DESCRI ), oFont8, 100 )
		nLine   += 50
		oPrn:Say( nLine, 0080, "Emitio: "+UsrFullName(retcodusr()), oFont8, 100 )
        //oPrn:Say( nLine, 1200, "Aprobo: " + Alltrim(mv_par05), oFont8, 100 )
		nLine   += 50
		oPrn:Say( nLine, 0080, "Vendedor: " + SA3->A3_NOME, oFont8, 100 )
        oPrn:Say( nLine, 0900, "*** Favor indicar numero de presupuesto en todo lo relacionado con el mismo. ***", oFont8, 100 )
		nLine   += 50
		//oPrn:Say( nLine, 0080, "Lugar de entrega: " + SL1->L1_XOBS, oFont8, 100 )
			
ELSE
		oPrn:Say( nLine, 1800, "CONTINUA EN PAGINA :" + Transform( (nPagina + 1), "@E 99" ), oFont8, 100 )
ENDIF
nLine += 350

oPrn:EndPage()

RETURN NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  � MS				 �Fecha �  03/09/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �  PREGUNTAS INICIALES				                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP Exclusivo de Microsiga.                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ENVIAEMAIL�Autor  �Microsiga           � Data �  12/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//����������������������������������������Ŀ
//� Tenta conexao com o servidor de E-Mail �
//������������������������������������������
CONNECT SMTP                         ;
SERVER    GetMV("MV_RELSERV");   // Nome do servidor de e-mail
ACCOUNT  GetMV("MV_RELACNT");    // Nome da conta a ser usada no e-mail
PASSWORD GetMV("MV_RELPSW") ;    // Senha
TIMEOUT 30 ;
RESULT   lResult              // Resultado da tentativa de conex�o

If !lResult

   //�����������������������������������������������������Ŀ
   //� Nao foi possivel estabelecer conexao com o servidor �
   //�������������������������������������������������������
   Help(" ",1,"ACAA170_01")   // _cErro := MailGetErr()

Else

   SEND MAIL;
   FROM     GetMV("MV_RELFROM");
   TO       cDestin;
   SUBJECT  cTitulo;
   BODY     cMensagem;
   RESULT   lResult

   //�������������������������������������������Ŀ
   //� Finaliza conexao com o servidor de E-Mail �
   //���������������������������������������������
   DISCONNECT SMTP SERVER

EndIf
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SendMail	�Autor  �Microsiga           � Data �  12/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SendMail(oPrinta,lDireto)
Private aUsuario    := "", oDlgMail, nOp:=0
Private aFiles      := {}, lDiret:=lDireto, oPrint:=oPrinta
Private cFrom       := GetMV("MV_RELFROM")
Private cServer     := AllTrim(GetNewPar("MV_RELSERV"," ")) // "mailhost.average.com.br" //Space(50)
Private cAccount    := AllTrim(GetNewPar("MV_RELACNT"," ")) //Space(50)
Private cPassword   := AllTrim(GetNewPar("MV_RELPSW" ," "))  //Space(50)
Private nTimeOut    := GetMv("MV_RELTIME",,120) //Tempo de Espera antes de abortar a Conex�o
Private lAutentica  := GetMv("MV_RELAUTH",,.F.) //Determina se o Servidor de Email necessita de Autentica��o
Private cUserAut    := Alltrim(GetMv("MV_RELAUSR",,cAccount)) //Usu�rio para Autentica��o no Servidor de Email
Private cPassAut    := Alltrim(GetMv("MV_RELAPSW",,cPassword)) //Senha para Autentica��o no Servidor de Email
Private cTo         := Alltrim(SA1->A1_EMAIL)
Private cCC         := space(200)
Private cSubject    := "Presupuesto de ventas: "+SL2->L2_NUM
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraMail	�Autor  �Microsiga           � Data �  12/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
      If ! oPrint:SaveAllAsJPEG( cDiretorio+Alltrim(Str(nSequencia)),870,840,140 ) // Passar o diret�rio abaixo do root path + as 3 primeiras letras do nome do arquivo a ser gerado
         Help("",1,"AVG0001055")
         Return .F.
      EndIf
   ELSE
      If ! oPrint:SaveAllAsJPEG( cDiretorio+Alltrim(Str(nSequencia)),880,990,140) // Passar o diret�rio abaixo do root path + as 3 primeiras letras do nome do arquivo a ser gerado
         Help("",1,"AVG0001055")
         Return .F.
      EndIf
   ENDIF
   If lDiret

      MsProcTxt("ENVIANDO E-MAIL...")
      cBody  := "Se adjunta layout de Orden de compra: "+SL2->L2_NUM

      // Varre o diret�rio e procura pelas p�ginas gravadas.
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AvLeGrupoEMail�Autor  �Microsiga       � Data �  12/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcion   � X5DES    � Autor � MS				    � Data � 12/07/99 ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  � Devuelve el Valor de una Clave de una Tabla en SX5.        ���
�������������������������������������������������������������������������Ĵ��
���Uso       �Al pedo ya hay una funcion padron que lo hace y BIEN        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/* Duplicada en el layout de presupuesto. Usamos el mismo asi que comento esta.


User Function X5des(cTabla,cClave)

SetPrvt("_ALIAS,CDESCRIPCION,")

_alias := alias()
dbSelectArea("SX5")
dbSetOrder(1)
dbSeek(xFilial("SX5")+cTabla+cClave)
cDescripcion   := RTRIM(SX5->X5_DESCSPA)

dbSelectArea(_alias)
Return(cDescripcion)
*/
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PrintLeyen �Autor  �MS				�Fecha �  16-11-07    ���
�������������������������������������������������������������������������͹��
���Desc.     � Resumen	 Leyendas			                              ���
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������    
�����������������������������������������������������������������������������
*/
/*
STATIC FUNCTION PrintLeyen()

oPrn:SetPortrait()
nLine := nX := 0
nLineas := 56
lImpre := .T.
nLine += 50

if nLineas > 55
   oPrn:StartPage()       		      
   TitLey( lImpre )
   lImpre := .F.
   nLineas:= 0
endif

oPrn:Say( nLine,0100,"GARANTIA", oFont9, 100 )
nLine += 50
oPrn:Say( nLine,0100,"Por cuanto los precios de nuestros productos y/o servicios no", oFont9, 100 )
nLine += 50
oPrn:Say( nLine,0100,"incluyen previsiones, y/o costos por la contrataci�n de seguros, que permitan hacer frente a eventuales da�os, de cualquier naturaleza que fueren,", oFont9, 100 )
nLine += 50
oPrn:Say( nLine,0100,"derivados de eventuales fallas de los mismos, independientemente de quien resultase ser responsable de la falla, el alcance de nuestra garant�a ", oFont9, 100 )
nLine += 50
oPrn:Say( nLine,0100,"quedar� limitado a lo que se detalla a continuaci�n:", oFont9, 100 )
nLine += 50
oPrn:Say( nLine,0100,"Nuestra empresa garantiza sus productos y servicios contra todo defecto de producci�n.", oFont9, 100 )
nLine += 50
oPrn:Say( nLine,0100,"Esta garant�a rige solo en el caso que nuestro suministro hubiese sido correctamente instalado y operado en los servicios para los cuales fue ", oFont9, 100 )
nLine += 50
oPrn:Say( nLine,0100,"dise�ado y manufacturado.", oFont9, 100 )
nLine += 50
oPrn:Say( nLine,0100,"La garant�a queda limitada �nica y exclusivamente a las eventuales reparaciones o los reemplazos de las partes defectuosas del producto suministrado,", oFont9, 100 )
nLine += 50
oPrn:Say( nLine,0100,"siempre que las partes supuestamente defectuosas hayan sido reintegradas a nuestra empresa.", oFont9, 100 )
nLine += 50
oPrn:Say( nLine,0100,"Nuestra empresa queda exonerada de toda otra responsabilidad, objetiva o subjetiva, en relaci�n con los productos  y/o servicios suministrados.", oFont9, 100 )
nLine += 50
oPrn:Say( nLine,0100,"ENSAYOS", oFont9, 100 )
nLine += 50
oPrn:Say( nLine,0100,"El precio de los materiales cotizados incluye el costo de los ensayos previstos en nuestro Sistema de Calidad. En el caso de ser solicitados otros", oFont9, 100 )
nLine += 50
oPrn:Say( nLine,0100,"ensayos o certificaciones, los mismos ser�n cotizados oportunamente.", oFont9, 100 )
nLineas:= 15

if len(aMemo1)+	len(aMemo2)+len(aMemo3)+len(aMemo4)+len(aMemo5)+len(aMemo6)+len(aMemo7)+;
				len(aMemo8)+len(aMemo9)+len(aMemo10) > 0 .and. 	mv_par07 == 1 // imprime anexo leyendas?
	
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
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TitLey 		�Autor  �MS				�Fecha �  16-11-07    ���
�������������������������������������������������������������������������͹��
���Desc.     � Titulo	 Leyendas			                              ���
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*STATIC FUNCTION TitLey( lFirstPage )

IF lFirstPage
   oPrn:StartPage()       
ENDIF
nPagina += 1

nLine := 50                       �

oPrn:Say( nLine, 0100, " ", oFont8, 100 )

IF !Empty( GetMV( "MV_DIRLOGO" ) )
	IF File( AllTrim( GetMV( "MV_DIRLOGO" ) ) ) .AND. MV_PAR09=1
		//oPrn:Box( nLine, 0050, nLine + 400, NMARGDERECHO ) //Cuadro de encabezado.
		nLine += 10
		oPrn:SayBitmap( nLine + 20, 0100, AllTrim( GetMV( "MV_DIRLOGO" ) ) , 600, 150 )
     	//oPrn:Say( nLine + 200, 0300, AllTrim( SM0->M0_NOMECOM ), oFont10a, 100 )
	ELSE
		nLine += 10
	ENDIF
endif


nLine := 300

oPrn:Say( nLine, 0100, " ", ofont10, 100 )
//oPrn:Box( nLine, 0050, 370, 2300 )
nLine += 50

//oPrn:Say( nLine, 0100, SM0->M0_NOME, oFont12a, 100 )
oPrn:Say( nLine, 1900, "Pagina: " + AllTrim( Str( nPagina ) ), ofont10, 100 )
nLine += 50

oPrn:Say( nLine, 0100, "MP10/Anexo Presupuesto de Ventas: "+Right( cPresup, 6 )  , oFont12a, 100 )
//oPrn:Say( nLine, 1900, "Emision: " + DToC( ddatabase ), ofont10, 100 )
oPrn:Say( nLine, 1600, "Fecha: "+DToC( SL1->L1_EMISSAO ), oFont10, 100 )
nLine += 90
RETURN NIL
*/
