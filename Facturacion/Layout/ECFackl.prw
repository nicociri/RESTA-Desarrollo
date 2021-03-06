#include "protheus.ch"                                                                                                          
#define nTop            50
#define nLef            0                                                                                                      
#define DETAILBOTTOM    2350
#define CURTEXTLINE     2700
#define TOTLINE         2800
#define TEXTBEGINLINE   2200                                                                                                   
#define CAILINE         2950
#define NUMCOPY         {"ORIGINAL","DUPLICADO","COBRANZAS","AT.CLIENTES","QUINTUPLICADO","SEXTUPLICADO","COPIA 7","COPIA 8","COPIA 9","COPIA 10"}
#define TXTCAMB1        "A fines fiscales el tipo de cambio utilizado es de: "
#define TXTCAMB2        " Siendo el neto "
#define TXTCAMB3        " , el I.V.A "
#define TXTCAMB4        " y PerIIBB. "

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcion   � KFac01   � Autor � Marcelo F. Rodriguez   �Fecha �30/06/13 ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  � Layout de Factura de Venta                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Layout de Factura de Venta                                 ���
�������������������������������������������������������������������������Ĵ��
���         ACTUALIZACIONES EFECTUADAS DESDE LA CODIFICACION INICIAL      ���
�������������������������������������������������������������������������Ĵ��
���Programador � Fecha  �         Motivo de la Alteracion                 ���
�������������������������������������������������������������������������Ĵ��
���            �  /  /  � Http://www.e-cuantica.com.ar                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ECFackl ()
Private lPrinted  := .F.,;
		esCopia     := .F.,;
      nHoja       := 0,; 
		cRemNota    := Space( 0 ), ;
		cPerg       := 'ECFAOU',;
      cPedidos    := '',;
      cRemitos    := '',;
		cNroPedido  := ''

	ValidPerg( cPerg )

	If Pergunte( cPerg, .T. )
		RptStatus( { || SelectComp() } )
	EndIf

Return nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcion   �          � Autor � Marcelo F. Rodriguez  � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function SelectComp()
Local   nCopies  := 0       
//Local cGrpReimpr := GetMV("MV_GRPRPRN")
Private nLine    := 0,;
        cDocum   := Space( 0 ),;
        oPrn     := TMSPrinter():New(),;
        oFont    := TFont():New( "Courier New"      ,, 10,, .f.,,,,, .f. ), ; 
        oFontL   := TFont():New( "Courier New"      		,, 12,, .t.,,,,, .f. ), ;
        oFont1   := TFont():New( "Arial"		    ,, 12,, .T.,,,,, .f. ), ;
        oFont2   := TFont():New( "Arial"      		,, 22,, .t.,,,,, .f. ), ;
        oFont3   := TFont():New( "Courier New"      ,, 08,, .f.,,,,, .f. ), ;
	    oFont4   := TFont():New( "Courier New"      ,, 12,, .T.,,,,, .f. ), ;
		oFont5   := TFont():New( "Courier New"      ,, 8,, .f.,,,,, .f. ),;
		oFontN   := TFont():New( "Courier New"      ,, 10,, .T.,,,,, .f. )
	
		        
oPrn:Setup()

DbSelectArea( "SA1" )
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

If mv_par04 < 3 // Factura - Nota de Debito
   DbSelectArea( "SF2" )
   DbSeek( xFilial() + mv_par02 + mv_par01 , .t. )

   While !Eof() .and. F2_FILIAL+F2_DOC+F2_SERIE <= xFilial()+mv_par03+mv_par01
      esCopia := .F.
      If  F2_ESPECIE $ "NF   -NDC  "
         If F2_SERIE != mv_par01
            DbSkip()
            Loop
         EndIf
     
         PrintComp( F2_ESPECIE )
      EndIf
      
	  DbSelectArea( "SF2" )
      DbSkip()
   EndDo
Else
   DbSelectArea( "SF1" )
   DbSeek( xFilial() + mv_par02 + mv_par01 , .t. )

   While !Eof() .and. F1_FILIAL+F1_DOC+F1_SERIE <= xFilial('SF1')+mv_par03+mv_par01
      esCopia := .F.
      If AllTrim( F1_ESPECIE ) == 'NCC' .and. F1_SERIE != mv_par01
         DbSkip()
         Loop
      EndIf
     
      PrintComp( F1_ESPECIE )
      DbSelectArea( "SF1" )
      DbSkip()
   EndDo
EndIf

If mv_par05 == 1
	oPrn:PreView()
Else
	oPrn:Print()
EndIf

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcion   �          � Autor � Marcelo F. Rodriguez  � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function PrintComp( cEspecie )

Local nLenMemo := 0, ;
      cMemo    := Space( 0 ), ;
      nIdx     := 0, ;
      nRecSD2  := 0, ;   
      nCop:=1,;
      nRecSD1  := 0

Private aDescMon   := { GetMV( "MV_MOEDA1" ), ;
        GetMV( "MV_MOEDA2" ), ;
        GetMV( "MV_MOEDA3" ), ;
        GetMV( "MV_MOEDA4" ), ;
        GetMV( "MV_MOEDA5" ) }, ;
        aSimbMon   := { GetMV( "MV_SIMB1" ), ;
        GetMV( "MV_SIMB2" ), ;
        GetMV( "MV_SIMB3" ), ;
        GetMV( "MV_SIMB4" ), ;
        GetMV( "MV_SIMB5" ) }, ;
        cMoneda    := Space( 0 ),;
        cSerOri    := Space( 0 ),;
        cDocOri    := Space( 0 ),;
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
        nNumLin		:= "",;
        nLinesObs 	:= 0,;
        dFecVto    := ctod('  /  /  ')
        
cPedidos    := ''
cRemitos    := ''
      
If cEspecie $ "NF   -NDC  "

	
	DbSelectArea( "SA1" )
   If cEspecie $ "NF   -NDC  "
      DbSeek( xFilial() + SF2->F2_CLIENTE + SF2->F2_LOJA )
   Else
      DbSeek( xFilial( "SA1" ) + SF2->F2_CLITRA + SF2->F2_LOJTRA )                                
   EndIf
    nCop:= MV_PAR06
	DbSelectArea( "SX5" )
	DbSeek( xFilial() + "12" + SA1->A1_EST )
	cProvincia := AllTrim( X5_DESCRI )

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
         EndIf
      EndIf

		DbSkip()
   EndDo
   
   If Len( cPedidos ) > 0
      cPedidos := SubStr( cPedidos, 1, Len(cPedidos) - 1 )
   EndIf
   
   If Len( cRemitos ) > 0
      cRemitos := SubStR( cRemitos, 1, Len(cRemitos) - 1 )
   EndIf

   DbSelectArea( "SF2" )
   
ElseIf AllTrim( cEspecie ) == "NCC"
	
	
	DbSelectArea( "SA1" )
   DbSeek( xFilial() + SF1->F1_FORNECE + SF1->F1_LOJA )
    nCop:= MV_PAR06

	DbSelectArea( "SX5" )
	DbSeek( xFilial() + "12" + SA1->A1_EST )
	cProvincia := AllTrim( X5_DESCRI )

	DbSeek( xFilial() + "SF" + SA1->A1_TIPO )
   cSitIVA := AllTrim( X5_DESCSPA )

	DbSelectArea( "SYA" )
	DbSeek( xFilial() + SA1->A1_PAIS )

	DbSelectArea( "SA3" )
	DbSeek( xFilial() + SF1->F1_VEND1 )
	cVend    := SA3->A3_COD
	cNomVend := SA3->A3_NOME

	DbSelectArea( "SD1" )
   DbSeek( SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA )
	nRecSD1  := Recno()

   While !Eof() .and. ( SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA   ) == ;
		( D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA   )

      If SF1->F1_ESPECIE != D1_ESPECIE
			DbSkip()
			Loop
      EndIf


      If !Empty( SD1->D1_NFORI )
		cSerOri := AllTrim(SD1->D1_SERIORI)
		cDocOri := AllTrim(SD1->D1_NFORI)
      EndIf

		DbSkip()
   EndDo

	DbGoTo( nRecSD1 )

   DbSelectArea( "SF1" )
   
EndIf

For nCopies := 1 TO nCop//mv_par06 
     nHoja := 1
   PrintHead( cEspecie, nCopies )
   PrintItem( cEspecie )
   PrintFoot( cEspecie, nCopies )
  
   //nHoja := 1
   //PrintHead( cEspecie, nCopies )
   //PrintItem( cEspecie )
   //PrintFoot( cEspecie, nCopies )
Next

Return nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcion   �          � Autor � Marcelo F. Rodriguez  � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  �  Cabecera                                                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function PrintHead( cEspecie, nCopyNum )
Local cCliente := IIF(AllTrim(cEspecie) == 'NCC',Alltrim(SF1->F1_FORNECE)+"/"+Alltrim(SF1->F1_LOJA),Alltrim(SF2->F2_CLIENTE)+"/"+Alltrim(SF2->F2_LOJA))
Local cFILIAL := IIF(AllTrim(cEspecie) == 'NCC',Alltrim(SF1->F1_FILIAL),Alltrim(SF2->F2_FILIAL))
Local nFin:=0
Local nCodObra:=""
If !lPrinted                                                                           
   lPrinted := .t.
Else
   oPrn:StartPage()
EndIf

oPrn:SayBitmap( 0250, 1822, "\logos\resta.bmp", 426, 148 )

// Impresion de Cuadros de Cabecera

//oPrn:Box( 850, 050, 2750, 2400 )  // Detalle
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

oPrn:Say( nTop+0420, nLef+110, 'E-mail: '		         					, oFont, 100 )
oPrn:Say( nTop+0460, nLef+110, 'Website: http://www.sanitariosresta.com.ar'    	, oFont, 100 )
oPrn:Say( nTop+0500, nLef+110, 'IVA RESPONSABLE INSCRIPTO'			         	, oFont, 100 )
oPrn:Say( nTop+0450, nLef+1710, 'C.U.I.T.: 30-67608106-9'						, oFont5, 100 )
oPrn:Say( nTop+0480, nLef+1710, 'Ingresos Brutos: CM 901-157512-1'				, oFont5, 100 )
oPrn:Say( nTop+0510, nLef+1710, 'Inicio de Actividades: 01/04/1995'				, oFont5, 100 )	
oPrn:Say( nTop+0550, nLef+1250, 'N CLIENTE'									, oFontN, 100 )
oPrn:Say( nTop+0550, nLef+1500, 'N PEDIDO'									, oFontN, 100 )
oPrn:Say( nTop+0550, nLef+1800, If( AllTrim(cEspecie)=='NCC','DOC. ORIG.', 'N REMITO' ), oFontN, 100 )
oPrn:Say( nTop+0550, nLef+2100, 'HOJAS'										, oFontN, 100 )	
oPrn:Say( nTop+0670, nLef+1250, 'ORDEN DE COMPRA'							, oFontN, 100 )
oPrn:Say( nTop+0670, nLef+1850, 'RESPONSABLE'								, oFontN, 100 )
oPrn:Say( nTop+0790, nLef+1550, 'CONDICION DE VENTA'						, oFontN, 100 )
oPrn:Say( nTop+0900, nLef+1550, 'DIRECCION DE ENTREGA'						, oFontN, 100 )
oPrn:Say( nTop+0900, nLef+0400, 'DIRECCION DEL TRANSPORTE'					, oFontN, 100 )
oPrn:Say( nTop+0600, nLef+1270, cCliente									, oFont, 100 )
oPrn:Say( nTop+0600, nLef+1520, Alltrim(cPedidos)							, oFont, 100 )
oPrn:Say( nTop+0600, nLef+1780, If( AllTrim(cEspecie)=='NCC', cSerOri + ' ' + cDocOri, Alltrim(cRemitos)), oFont, 100 )
oPrn:Say( nTop+0600, nLef+2110, StrZero( nHoja, 3 ) 						, oFont, 100 )
oPrn:Say( nTop+0720, nLef+1270, posicione("SC5",1,xFilial("SC5")+substr(cPedidos,1,6),"C5_XOC")	, oFont, 100 )
//Prn:Say( nTop+0720, nLef+1600, SA1->A1_CONTATO	, oFont, 100 ) 



// Datos de la Obra                     
//* lagonegro If !Empty(substr(cPedidos,1,6))
	nCodObra := posicione("SC5",1,xFilial("SC5")+substr(cPedidos,1,6),"C5_XCONTAC")
	cObra	 := posicione("SU5",1,xFilial("SU5")+nCodObra,"U5_CONTAT")
//* lagonegro EndIf

//* lagonegro if !empty(nCodObra)
//* lagonegro  oPrn:Say( nTop+0670, nLef+1600, 'OBRA'							, oFontN, 100 )
//* lagonegro  oPrn:Say( nTop+0705, nLef+1600, nCodObra	, oFont, 100 )   
//* lagonegro  oPrn:Say( nTop+0732, nLef+1600,alltrim(cObra)	, oFont, 100 )       
//* lagonegro endif                                                                                

//* lagonegro inicio; ESTE CODIGO YA EXISTIA, lo unico que se hizo fue es que aparezca siempre. Datos de la Obra
		oPrn:Say( nTop+1000, nLef+1250, 'OBRA :     ', oFontN, 100)
		oPrn:Say( nTop+1000, nLef+1350, ' '+nCodObra+" ; "+cObra, oFont, 100)		
//* lagonegro fin
   
  

// Condicion de Pago
If mv_par04 < 3
	oPrn:Say( nTop+0840, nLef+1250, Posicione('SE4',1,xFilial('SE4')+SF2->F2_COND,'E4_DESCRI'), oFont, 100 )
Else
	oPrn:Say( nTop+0840, nLef+1250, Posicione('SE4',1,xFilial('SE4')+SF1->F1_COND,'E4_DESCRI'), oFont, 100 )
EndIf

// Letra Factura
If mv_par04 < 3
   oPrn:Say( nTop+180, nLef+1180, Substr(SF2->F2_SERIE,1,1)	, oFont2, 100 )
Else
   oPrn:Say( nTop+180, nLef+1180, Substr(SF1->F1_SERIE,1,1)	, oFont2, 100 )
EndIf

// Codigo Factura
If		cEspecie $ "NF   " .and. Substr(SF2->F2_SERIE,1,1) == 'A'
   oPrn:Say( nTop+290, nLef+1140, 'C�digo 01'	, oFont3, 100 )
ElseIf   cEspecie $ "NF   " .and. Substr(SF2->F2_SERIE,1,1) == 'B'          
   oPrn:Say( nTop+290, nLef+1140, 'C�digo 06'	, oFont3, 100 )
ElseIf   cEspecie $ "NF   " .and. Substr(SF2->F2_SERIE,1,1) == 'E'          
   oPrn:Say( nTop+290, nLef+1140, 'C�digo 19'	, oFont3, 100 )   
ElseIf 	cEspecie $ "NDC  " .and. Substr(SF2->F2_SERIE,1,1) == 'A'	
	oPrn:Say( nTop+290, nLef+1140, 'C�digo 02'	, oFont3, 100 )
ElseIf 	cEspecie $ "NDC  " .and. Substr(SF2->F2_SERIE,1,1) == 'B'	
	oPrn:Say( nTop+290, nLef+1140, 'C�digo 07'	, oFont3, 100 )
ElseIf 	cEspecie $ "NDC  " .and. Substr(SF2->F2_SERIE,1,1) == 'E'	
	oPrn:Say( nTop+290, nLef+1140, 'C�digo 04'	, oFont3, 100 )	
ElseIf 	cEspecie $ "NCC  " .and. Substr(SF1->F1_SERIE,1,1) == 'A'	
	oPrn:Say( nTop+290, nLef+1140, 'C�digo 03'	, oFont3, 100 )
ElseIf 	cEspecie $ "NCC  " .and. Substr(SF1->F1_SERIE,1,1) == 'B'	
	oPrn:Say( nTop+290, nLef+1140, 'C�digo 08'	, oFont3, 100 ) 
ElseIf 	cEspecie $ "NDC  " .and. Substr(SF2->F2_SERIE,1,1) == 'E'	
	oPrn:Say( nTop+290, nLef+1140, 'C�digo 04'	, oFont3, 100 )		
EndIf

// Copia del comprobante

oPrn:Say( nTop+340, nLef+1140, NUMCOPY[nCopyNum] , oFontN, 100 )		
 // Tipo Comprobante			 
If	cEspecie $ "NF   "
		oPrn:Say( nTop+350, nLef+1480, 'FACTURA'	, oFont4, 100 )
ElseIf	cEspecie $ "NDC  "
		oPrn:Say( nTop+350+10, nLef+1050, 'NOTA DE DEBITO'	, oFont4, 100 )
ElseIf	cEspecie $ "NCC  "
		oPrn:Say( nTop+350+10, nLef+1050, 'NOTA DE CREDITO'	, oFont4, 100 )	
EndIf

 // Numero y Fecha 
If mv_par04 < 3
	oPrn:Say( nTop+350, nLef+1672, '  N�: ' + Left( SF2->F2_DOC, 4 ) + "-" + Right( SF2->F2_DOC, 8 )	, oFont4, 100 )
	oPrn:Say( nTop+400, nLef+1680, '  FECHA: ' + DToC( SF2->F2_EMISSAO ), oFontN, 100 )
Else
	oPrn:Say( nTop+350, nLef+1672, '  N�: ' + Left( SF1->F1_DOC, 4 ) + "-" + Right( SF1->F1_DOC, 8 )	, oFont4, 100 )
	oPrn:Say( nTop+400, nLef+1680, '  FECHA: ' + DToC( SF1->F1_EMISSAO ), oFont, 100 )
EndIf

// Datos Cliente

oPrn:Say( nTop+0580, nLef+0110, AllTrim( SA1->A1_NOME ) , oFontn, 100 )
oPrn:Say( nTop+0650, nLef+0110, AllTrim( SA1->A1_END ), oFont, 100 )
oPrn:Say( nTop+0700, nLef+0110, Alltrim( SA1->A1_MUN ) + " C.P.: "+AllTrim( SA1->A1_CEP ), oFont, 100 )
oPrn:Say( nTop+0750, nLef+0110, If( SA1->A1_TIPO != "E",If(!Empty( cProvincia ),cProvincia,"" ),"   Pais: " + AllTrim( SYA->YA_DESCR ) ), oFont, 100 )
                                                              
oPrn:Say( nTop+0800, nLef+0110, 'I.V.A.: ' + cSitIVA, oFont, 100 )
oPrn:Say( nTop+0850, nLef+0110, 'C.U.I.T.: ' + Subst(SA1->A1_CGC,1,2)+'-'+Subst(SA1->A1_CGC,3,8)+'-'+Subst(SA1->A1_CGC,11,1), oFont, 100 )


// Direccion de Entrega

oPrn:Say( nTop+0930, nLef+1250, AllTrim( SA1->A1_ENDENT)								, oFont, 100 )
oPrn:Say( nTop+0970, nLef+1250, AllTrim( SA1->A1_MUNE)	+ ' ' + AllTrim( SA1->A1_MUNE)		, oFont, 100 )
oPrn:Say( nTop+1010, nLef+1250, ''													, oFont, 100 )
oPrn:Say( nTop+1050, nLef+1250, ''													, oFont, 100 )

// Direccion de Transporte

oPrn:Say( nTop+930, nLef+0120, Posicione('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_NOME')	, oFont, 100 )
oPrn:Say( nTop+970, nLef+0120, Posicione('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_END')	, oFont, 100 )
oPrn:Say( nTop+1010, nLef+0120, Posicione('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_MUN')	, oFont, 100 )
//oPrn:Say( nTop+1050, nLef+0120, Posicione('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_PROV')	, oFont, 100 )

nNumLin := posicione("SC5",1,xFilial("SC5")+substr(cPedidos,1,6),"C5_XOBS1")
nLinesObs   := MLCount( Alltrim( nNumLin ), 90)
For nX := 1 To nLinesObs
	oPrn:Say( nTop+nTop+1080 +((nX-1)*50), nLef+0120, MemoLine( Alltrim( nNumLin ), 90, nX )	, oFont, 100 )
	nTop += 50
Next

oPrn:Say( nTop+1170, nLef+0120, "COTIZACION: " + getMV("MV_MOEDA" + alltrim(Str(SF2->F2_MOEDA))) + TransForm(SF2->F2_TXMOEDA, '@E 99.99'), oFont, 100 ) //OBSERVACIONES  

// Datos Cabecera Detalle

oPrn:Say( nTop+1300, nLef+0130, 'ITEM'										, oFontN, 100 )
oPrn:Say( nTop+1300, nLef+0230, 'CODIGO'									, oFontN, 100 )
oPrn:Say( nTop+1300, nLef+0520, 'DESCRIPCION PRODUCTO'						, oFontN, 100 )
//oPrn:Say( nTop+1300, nLef+1230, 'UM'										, oFontN, 100 )
oPrn:Say( nTop+1300, nLef+1420, 'CANT.'										, oFontN, 100 )
//oPrn:Say( nTop+1300, nLef+1630, 'ENVASE'									, oFontN, 100 )
oPrn:Say( nTop+1300, nLef+1750, 'P. LISTA'									, oFontN, 100,,,1 )
//rn:Say( nTop+1300, nLef+1900, 'DESC.'									    , oFontN, 100,,,1 ) 
oPrn:Say( nTop+1300, nLef+2000, 'P. VENTA'								    , oFontN, 100,,,1 )
oPrn:Say( nTop+1300, nLef+2200, 'TOTAL'										, oFontN, 100,,,1 )



Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcion   �          � Autor � Marcelo F. Rodriguez  � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function PrintItem( cEspecie )

Local nElem := 0, ;
nIdx        := 0, ;
nPos        := 0, ;
nPrecio	 	:=0, ;
nTotalBruto	:=0, ;
nTotalNeto	:=0, ;
CTEXTD1:="",;
CTEXTDESC:="",;
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
cEsserie    := Space( 0 ),;
nCuota:=0                                 

oPrn:Box( 200, 100, 600, 2300)		// Cuadro 1
oPrn:Box( 600, 100, 950, 2300)		// Cuadro 2
oPrn:Box( 950, 100, 1150, 2300)		// Cuadro 3
oPrn:Box( 1150, 100, 1320, 2300)	// Cuadro 4

oPrn:Box( 200, 1120, 320, 1280)		// Cuadro 1 Divisor de la letra de la factura

oPrn:Box( 600, 100, 1150, 1200)		// Cuadro 1 Divisor

oPrn:Box( 720, 1200, 840, 2300)		// Cuadro 2 Divisor

oPrn:Box( 1330, 100, 1400, 2300)	// Campos Detalle

oPrn:Box( 3000, 100, 3100, 2300)
oPrn:Box( 3100, 100, 3250, 2300)	// Cuadro Foot



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

If mv_par04 < 3

   DbSelectArea( "SD2" )
   DbSeek( SF2->F2_FILIAL + SF2->F2_DOC+ SF2->F2_SERIE +SF2->F2_CLIENTE + SF2->F2_LOJA )

   While ( cEspecie $ "NF   -NDC  " .AND. ;
         ( xFilial() + SF2->F2_DOC+ SF2->F2_SERIE +SF2->F2_CLIENTE + SF2->F2_LOJA   ) == ;
         ( D2_FILIAL + D2_DOC+ D2_SERIE + D2_CLIENTE + D2_LOJA  ) )

      DbSelectArea( "SB1" )
      DbSeek( xFilial() + SD2->D2_COD )
      If !Empty(SD2->D2_DESCRI)
      	cDescrip := SD2->D2_DESCRI
      Else
      	cDescrip := SB1->B1_DESC
      EndIF
      cEsserie := "R"
     
      DbSelectArea( "SD2" )


      AAdd( aItems, ;
            { D2_COD , ;								//01 ** USADO
            D2_SEGUM,;									//02
            D2_ITEM, ;								//03
            cDescrip, ;								//04 ** USADO
            D2_QUANT, ;								//05 ** USADO
            D2_PRCVEN	, ;							//06
            D2_TOTAL, ;								//07 ** USADO
            D2_DESCON, ;							//08 ** USADO
            D2_DESC, ;								//09 ** USADO
            D2_VALIMP1, ;								//10
            D2_PRUNIT, ;								//11
            Substr(SD2->D2_SERIE,1,1), ;				//12
            SB1->B1_CONV,;   							//13
            0, ;										//14
            0,;                                        //15
            D2_ALQIMP1,;                               //16
            D2_ALQIMP2,;                               // 17
            IF(EMPTY(D2_ITEMREM),D2_ITEMPV,D2_ITEMREM) })  								//18 
            

      DbSkip()
   EndDo

Else

   DbSelectArea( "SD1" )
   DbSeek( SF1->F1_FILIAL + SF1->F1_DOC+ SF1->F1_SERIE +SF1->F1_FORNECE + SF1->F1_LOJA )

   While ( cEspecie $ "NCC  " .AND. ;
         ( xFilial() + SF1->F1_DOC+ SF1->F1_SERIE +SF1->F1_FORNECE + SF1->F1_LOJA   ) == ;
         ( D1_FILIAL + D1_DOC+ D1_SERIE + D1_FORNECE + D1_LOJA  ) )

        
      DbSelectArea( "SB1" )
      DbSeek( xFilial() + SD1->D1_COD )
      If !Empty(SD1->D1_XDESCOD)
      	cDescrip := SD1->D1_XDESCOD //* Descripcion de producto
      Else
      	cDescrip := SB1->B1_DESC
      EndIF
      cEsserie := "R"
     
      DbSelectArea( "SD1" )


      AAdd( aItems, ;
            { D1_COD , ;						// 01 ** USADO
            D1_SEGUM,;							// 02
            D1_ITEM, ;							// 03
            cDescrip, ;						    // 04 ** USADO
            D1_QUANT, ;							// 05 ** USADO
            D1_VUNIT, ;							// 06
            D1_TOTAL, ;							// 07 ** USADO
            D1_VALDESC, ;						// 08 ** USADO
            D1_DESC, ;							// 09 ** USADO
            D1_VALIMP1, ;						// 10
            D1_VUNIT, ;							// 11
            Substr(SD1->D1_SERIE,1,1), ;		// 12
            SB1->B1_CONV,;						// 13
            0, ;								// 14
            0,;                                 // 15
            D1_ALQIMP1,; 						// 16 10.50%
            D1_ALQIMP2,;                        // 17 21.00%
            '' } )								// 18 ITEM

      DbSkip()
   EndDo

   
EndIf

nLine := nTop + 1400   


For xy:= 1 to Len(aItems)
   aSort( aItems,,, { |x,y| x[18] < y[18] } )
next
For xI := 1 TO Len( aItems )
	CTEXTD1:=""
	CTEXTDESC:=""
	nQuant := aItems[xI][5]* aItems[xI][13] 
    nPreco := aItems[xI][6]   ///nQuant
   If nLine > ( CURTEXTLINE - 40 )
      oPrn:EndPage()
      lPrinted := .F.
      nHoja++
      PrintHead( cEspecie, nCopies )
      nLine := nTop + 1400
   EndIf
    
	If	cEspecie $ "NF   -NDC  " // Factura - Nota de Debito    
	
	//cCodCli := Iif( aItems[xI][12] == 'E' .or. (aItems[xI][12] == 'B' .and. SA1->A1_TIPO == 'E'),Posicione("SX5",1,xFilial("SX5")+"97"+SB1->B1_PAISORI,"X5_DESCSPA"),"")
	If aItems[xI][12] == 'B' // Serie B
		
		nTotalBruto := aItems[xI][7]+aItems[xI][8]+aItems[xI][10]
		nTotalNeto  := aItems[xI][7]+ aItems[xI][10]
		
		Else					  // Serie A
		
		nTotalBruto := aItems[xI][7]+aItems[xI][8]
		nTotalNeto  := aItems[xI][7]
		
		EndIf
	
	IF aItems[xI][8] >0
    	CTEXTD1:=ALLTRIM(STR(100 - ROUND(aItems[xI][6]/aItems[xI][11],2)*100))
    ENDIF
	
	Else 					 // Nota de Credito
	nDescont	:= ""
	nTotalBruto := aItems[xI][7]
	nTotalNeto  := aItems[xI][7]-aItems[xI][8]
	nPreco 		:= ROUND(nTotalNeto/aItems[xI][5],2) //nQuant
	
//	IF aItems[xI][8] >0
//    	CTEXTD1:=ALLTRIM(STR(100 - ROUND(nPreco/aItems[xI][11],2)*100))
//  ENDIF
	
	EndIf
	
	if aItems[xI][16]!=0
	   nCuota:= aItems[xI][16] 
	elseif aItems[xI][17]!=0 
	  nCuota:= aItems[xI][17]
	endif                    
	
//	oPrn:Say( nLine, nLef+0130, Alltrim(aItems[xI][3]), oFont3, 100 )			// IT
	oPrn:Say( nLine, nLef+0130,	IF(EMPTY(aItems[xI][18]),ALLTRIM(aItems[xI][3]),Alltrim(aItems[xI][18])), oFont3, 100 )			// IT
	oPrn:Say( nLine, nLef+0230, Alltrim(aItems[xI][1]), oFont3, 100 ) 			// Codigo Producto

	oPrn:Say( nLine, nLef+0520, Alltrim(aItems[xI][4]), oFont3, 100 ) 			// Descripcion Producto

	
	//oPrn:Say( nLine, nLef+1230, Alltrim(aItems[xI][2]), oFont3, 100 ) 			// Unidad
	oPrn:Say( nLine, nLef+1400, TransForm(aItems[xI][5], '@E 99999.99'  ), oFont3, 100 ) 		// Cantidad
	//oPrn:Say( nLine, nLef+1600, alltrim(TransForm( aItems[xI][5], '@E 99999.99'  ))+' X '+ALLTRIM(TransForm( aItems[xI][13], '@E 999,999.99' )), oFont3, 100 )       //envase
	
	// Imprime precio de lista con IVA para las B - Nicolas Cirigliano 14/07/14
	If aItems[xI][12] == 'B' // Serie B
		oPrn:Say( nLine, nLef+1650, alltrim(TransForm( aItems[xI][11]+(aItems[xI][10]/aItems[xI][5])  , '@E 999,999.99' )), oFont3, 100 )			// Precio  de lista
	else
		oPrn:Say( nLine, nLef+1650, alltrim(TransForm( aItems[xI][11]   , '@E 999,999.99' )), oFont3, 100 )			// Precio  de lista
	endif
   //25/10/2013 Se agrego cuota de IVA por item  
 //   oPrn:Say( nLine, nLef+1850, ALLTRIM(CTEXTD1)						  , oFont3, 100 )		//valor cuotaIva	
    //oPrn:Say( nLine, nLef+1900, alltrim(TransForm( nPreco	  , '@E 999,999.99')), oFont3, 100 )

//* Lagonegro; Cirigliano    oPrn:Say( nLine, nLef+1900, alltrim(TransForm( nTotalBruto/aItems[xI][5]	  , '@E 999,999.99')), oFont3, 100 )
oPrn:Say( nLine, nLef+1900, alltrim(TransForm( nTotalNeto/aItems[xI][5]	  , '@E 999,999.99')), oFont3, 100 ) //* Lagonegro; Cirigliano

    oPrn:Say( nLine, nLef+2100, alltrim(TransForm( nTotalNeto		  , '@E 999,999.99' )), oFont3, 100 )			// Total
	If ALLTRIM(cCodCli) <> ''                                              
		nLine += 40
   		oPrn:Say( nLine, nLef+520, "CODIGO CLIENTE: " + cCodCli, oFontN, 100 )
   		
  	EndIf
	//oPrn:Say( nLine, nLef+2040, IIF(Substr(SF2->F2_SERIE,1,1) == 'B',TransForm( aItems[xI][7]+ aItems[xI][10], '@E 999,999.99' ),TransForm( aItems[xI][7], '@E 999,999.99' )), oFont, 100 ) // Total Neto
	//oPrn:Say( nLine, nLef+1210,  IIF(Substr(SF2->F2_SERIE,1,1) == 'B',TransForm( (aItems[xI][7]+aItems[xI][8]+aItems[xI][10])/aItems[xI][5], '@E 999,999.99'  ),TransForm( aItems[xI][11], '@E 999,999.99'  )), oFont, 100 ) // Precio
	//oPrn:Say( nLine, nLef+1460, IIF(Substr(SF2->F2_SERIE,1,1) == 'B',TransForm( aItems[xI][7]+aItems[xI][8]+aItems[xI][10], '@E 999,999.99' ),TransForm( aItems[xI][7]+aItems[xI][8], '@E 999,999.99' )), oFont, 100 ) // Total Bruto
	//oPrn:Say( nLine, nLef+1460, TransForm( nTotalBruto, '@E 999,999.99' ), oFont, 100 ) // Total Bruto
	//oPrn:Say( nLine, nLef+1710, IIF(aItems[xI][8]<>0,TransForm( (aItems[xI][8]/(aItems[xI][7]+aItems[xI][8]))*100, '@E 999.99' ), TransForm( 0, '@E 999.99' ) ),oFont, 100 ) // % Descuento
   nLine += 40

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcion   �          � Autor � Marcelo F. Rodriguez  � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function PrintFoot( cEspecie, nCopyNum )

Local xI      := 0, ;
aImp, ;
cTexto  := Space( 0 ), ;
cTipoREM  := "", ;
cLocalD2  := "", ;
nLenTxt := 0,;
aCAI :={}

//oPrn:Say( 2650 ,1550, "DESC. GRAL.:", oFont, 100 )
    IF LEFT(ALLTRIM(MV_PAR01),1)== 'A'
oPrn:Say( 2700 ,1550, "SUBTOTAL:", oFont, 100 )
oPrn:Say( 2750 ,1550, "IVA 21.00%:", oFont, 100 )
oPrn:Say( 2800 ,1550, "IVA 10.50%:", oFont, 100 )
oPrn:Say( 2850 ,1550, "Perc.IB. CF.:", oFont, 100 )
oPrn:Say( 2900 ,1550, "Perc.IB. BS.AS.:", oFont, 100 )
ENDIF
oPrn:Say( 2950 ,1550, "TOTAL:", oFont, 100 )

If mv_par04 < 3                                                                                        
//	oPrn:Say( 2650 ,nLef+2040,Transform(ROUND(((SF2->F2_DESCONT/SF2->F2_VALMERC)*100),2) , '@E 999,999.99'), oFont, 100 )	//Descuento
    IF LEFT(ALLTRIM(MV_PAR01),1)== 'A'
	oPrn:Say( 2700 ,nLef+2040,Transform(SF2->F2_VALMERC , '@E 999,999.99'), oFont, 100 )	// Subtotal
    oPrn:Say( 2750 ,nLef+2040,Transform(SF2->F2_VALIMP1 , '@E 999,999.99'), oFont, 100 )	// IVA   10.50%
	oPrn:Say( 2800 ,nLef+2040,Transform(SF2->F2_VALIMP2 , '@E 999,999.99'), oFont, 100 )	// IVA   21.00%

	oPrn:Say( 2850 ,nLef+2040,Transform(SF2->F2_VALIMP5 , '@E 999,999.99'), oFont, 100 )	// Perc IIBB  CF
	oPrn:Say( 2900 ,nLef+2040,Transform(SF2->F2_VALIMP6 , '@E 999,999.99'), oFont, 100 )	// Perc IIBB  BS AS
	ENDIF
	oPrn:Say( 2950 ,nLef+2040,Transform(SF2->F2_VALBRUT , '@E 999,999.99'), oFont, 100 )	// Total

	// Moneda
	
	/*If SF2->F2_MOEDA = 1
		oPrn:Say( 2900 ,1750, "PESOS", oFont, 100 )
	ElseIf SF2->F2_MOEDA = 2
		oPrn:Say( 2900 ,1750, "USD", oFont, 100 )
	ElseIf SF2->F2_MOEDA = 3
		oPrn:Say( 2900 ,1750, "EURO", oFont, 100 )
	EndIf*/
	
	cPDV_CB  := SubStr( SF2->F2_DOC, 1, 4 )
	cCAE_CB  := SF2->F2_CAEE
	cVtc_CB  := DtoS( SF2->F2_VCTOCAE )

	If !Empty(SF2->F2_CAEE)  
		oPrn:Say( 3105, 1680, "C.A.E.:" + SF2->F2_CAEE, oFont5, 100 )
		oPrn:Say( 3155, 1680, "VENCIMIENTO C.A.E.: " + DtoC( SF2->F2_EMCAEE ), oFont5, 100 )
	Else
		aCAI := Cai()
		oPrn:Say( 3105, 1680, "C.A.I.:" + aCAI[1], oFont5, 100 )
		oPrn:Say( 3155, 1680, "VENCIMIENTO C.A.I.: " + DTOC(aCAI[2]), oFont5, 100 )
	EndIf
	oPrn:Say( 3105, 140,'SUCESORES DE DOMINGO RESTA Y CIA S.A.' , oFont5, 100 )
	oPrn:Say( 3155, 140, 'C.U.I.T.: 30-67608106-9', oFont5, 100 )

	If Alltrim(SF2->F2_SERIE) == 'E' .OR. ( SA1->A1_TIPO == 'E' .AND. SF2->F2_SERIE == "B  " )
		oPrn:Say( 2900, 140, "TIPO DE CAMBIO: " + Transform(SF2->F2_TXMOEDA, "@E 999.9999" ), oFontN, 100 )
	EndIf

Else                                                
 
	//oPrn:Say( 2650 ,nLef+2040,Transform(ROUND(((SF1->F1_DESCONT/SF1->F1_VALMERC)*100),2) , '@E 999,999.99'), oFont, 100 )	//Descuento
    IF LEFT(ALLTRIM(MV_PAR01),1)== 'A'
	oPrn:Say( 2700 ,nLef+2040,Transform( SF1->F1_VALMERC - SF1->F1_DESCONT , '@E 999,999.99'), oFont, 100 )		// Subtotal
	oPrn:Say( 2750 ,nLef+2040,Transform( SF1->F1_VALIMP1, '@E 999,999.99'), oFont, 100 )						// IVA  10.50
	oPrn:Say( 2800 ,nLef+2040,Transform( SF1->F1_VALIMP2, '@E 999,999.99'), oFont, 100 )						// IVA   21.00
	oPrn:Say( 2850 ,nLef+2040,Transform( SF1->F1_VALIMP5, '@E 999,999.99'), oFont, 100 )						// Perc CF
	oPrn:Say( 2900 ,nLef+2040,Transform( SF1->F1_VALIMP6, '@E 999,999.99'), oFont, 100 )						// Perc bsas
	ENDIF
	oPrn:Say( 2950 ,nLef+2040,Transform( SF1->F1_VALBRUT, '@E 999,999.99'), oFont, 100 )						// Total

	// Moneda
	
//	If SF1->F1_MOEDA = 1
//		oPrn:Say( 2900 ,1750, "PESOS", oFont, 100 )
//	ElseIf SF1->F1_MOEDA = 2
//		oPrn:Say( 2900 ,1750, "USD", oFont, 100 )
//	ElseIf SF1->F1_MOEDA = 3
//		oPrn:Say( 2900 ,1750, "EURO", oFont, 100 )
//	EndIf
	
	If Alltrim(SF1->F1_SERIE) == 'E' .OR. ( SA1->A1_TIPO == 'E' .AND. SF1->F1_SERIE == "B  " )
		oPrn:Say( 2900, 140, "TIPO DE CAMBIO: " + Transform(SF1->F1_TXMOEDA, "@E 999.9999" ), oFontN, 100 )
	EndIf
	
	oPrn:Say( 3105, 1680, "C.A.E: " + SF1->F1_CAEE, oFont5, 100 )
	oPrn:Say( 3155, 1680, "VENCIMIENTO C.A.E: " + DtoC( SF1->F1_EMCAEE ), oFont5, 100 )
	oPrn:Say( 3105, 140,'SUCESORES DE DOMINGO RESTA Y CIA S.A.' , oFont5, 100 )
	oPrn:Say( 3155, 140, 'C.U.I.T.: 30-67608106-9', oFont5, 100 )

	cPDV_CB  := SubStr( SF1->F1_DOC, 1, 4 )
	cCAE_CB  := SF1->F1_CAEE
	cVtc_CB  := DtoS( SF1->F1_VCTOCAE )
EndIf

cCUIT_CB := AllTrim( SM0->M0_CGC )
cTipo_CB := '01'

cCodBar  := cCUIT_CB + cTipo_CB + cPDV_CB + cCAE_CB + cVtc_CB
nSuma    := 0

For nD := 1 To Len( cCodBar )
   nSuma += If( Mod( Val( SubStr( cCodBar, nD, 1 ) ), 2 ) == 0, Val( SubStr( cCodBar, nD, 1 ) ), Val( SubStr( cCodBar, nD, 1 ) ) * 3 )
Next nD

   cCodBar  := cCodBar + StrZero( Mod(nSuma, 10), 1 )

MSBAR( "INT25", 26.7, 7, cCodBar, oPrn, .F., Nil, Nil, 0.02, 0.7, .T., Nil, Nil, .F. ) 
 

// Texto Pie
/*       
oPrn:Say( 3000, 140, "Cheque a la orden de XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 'No a la Orden'. Deposito o transferencia bancaria a nombre de XXXXXX ", oFont5, 100 )
oPrn:Say( 3030, 140, "XXXXXXXXXXXXXXXXXXXXXXXXXX, CC Standard Bank CBU XXXXXXXXXXXXXXXXXXXXXX. Vencido el plazo estipulado nos reservamos el derecho ", oFont5, 100 )
oPrn:Say( 3060, 140, "de recargo por mora de pago EXCLUSION DE RETENCION DE IVA, VIGENCIA DESDE EL XX/XX/XXXX AL XX/XX/XXXX RG XXXX AFIP", oFont5, 100 ) 
*/
nLine   := CURTEXTLINE // TEXTBEGINLINE

oPrn:EndPage()

Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcion   �          � Autor � Marcelo F. Rodriguez  � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcion   �          � Autor � Diego Fernando Rivero � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg( cPerg )
Local aArea := GetArea(),;
      aRegs := {},;
      i, j

DbSelectArea( "SX1" )
DbSetOrder( 1 )

cPerg := Padr( cPerg, 10 )
AAdd( aRegs, { cPerg, "01", "Serie ?      :   ", "Serie ?      :   ", "Serie ?      :   ", "mv_ch1", "C", 3 , 00, 1, "G", "", "mv_par01", "A", "A", "A", "A", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "02", "Desde Factura?:   ", "Desde Factura?:   ", "Desde Factura?:   ", "mv_ch2", "C", 12, 00, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "03", "Hasta Factura?:   ", "Hasta Factura?:   ", "Hasta Factura?:   ", "mv_ch3", "C", 12, 00, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "04", "Tipo Comprob.:   ", "Tipo Comprob.:   ", "Tipo Comprob.:   ", "mv_ch4", "N", 1 , 00, 0, "C", "", "mv_par01", "Facturas", "Facturas", "Facturas","", "", "N. Debito", "N. Debito", "N. Debito", "", "", "N. Credito", "N. Credito", "N. Credito", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcion   �          � Autor � Marcelo F. Rodriguez  � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcion   �          � Autor � Alexei Bykovski       � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  �  Trae el Numero de CAI para los remitos de Venta           ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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