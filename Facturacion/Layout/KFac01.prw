#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funci�n   �          � Autor � Carlos P              � Data � 06/02/14 ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  �Layout de facturas / nd / nc                                ���
�������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Kfac01 (cEspecie,cSerie,cRemito)
//        aReturn   := { "", 1,"", 1, 1, 1,"",1 },;//Zebrado Administracion
//        aReturn   := { "PreImpreso", 1,"Administracion", 1, 1, 1,"",1 },;//Zebrado Administracion
Private cPerg     := 'KREM01    ',;
        tamanho   := "P",;
        limite    := 80,;
        aReturn      := { "A Rayas", 1, "Administraci�n", 1, 2, 1, "", 1} ,;
        wnrel     := "REMITO",;
        titulo    := "Impresi�n de Remitos",;
        cDesc1    := " ",;
        cDesc2    := " ",;
        cDesc3    := " ",;
        nLin      := 90,;
        lSeteo    := .T.
Default cSerie    := space(03)
Default cEspecie  := "RFN  RTS  RCD  RFB  "

//ESPECIES A IMPRIMIR
//RFN=R. de venta                   [CLIENTES]
//RTS=R. de transferencia (salida)	[PROVEEDORES]
//RCD=R. de devolucion              [PROVEEDORES]
//RFB=R. de Beneficiamiento         [PROVEEDORES]

ValidPerg( cPerg )

//Se for chamada por rotinas atualiza as perguntas
If !Empty(cSerie)
	DbSelectArea( "SX1" )
	DbSetOrder( 1 )
	If DbSeek( cPerg  )
		While !eof()  .and. x1_grupo == cPerg
			RecLock( "SX1", .f. )
			Do 	Case
				Case x1_ordem == "01"
					 x1_cnt01 := cSerie
				Case x1_ordem $ "02_03"
					 x1_cnt01 := cRemito
				Otherwise
					x1_cnt01 := "1"
			End
			MsUnlock()
			dbskip()
		End
	End
Endif

Pergunte( cPerg, .F. )

cString:="SF2"

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,"P")

If nLastKey == 27
	Return
Endif

//��������������������������������������������������������������Ŀ
//� Verifica Posicao do Formulario na Impressora                 �
//����������������������������������������������������������������
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

#IFDEF WINDOWS
	RptStatus( { || SelectComp(cEspecie) } )
	Return
#ENDIF

Return

/*/
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
Static Function SelectComp(cEspecie)
Local   nCopies  := 0
Private cOcomp   := " "
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
DbSetOrder( 5 )
DbSelectArea( "SC5" )
DbSetOrder( 1 )
DbSelectArea( "SE1" )
DbSetOrder( 1 )
DbSelectArea( "SF2" )
DbSetOrder( 1 )
DbSelectArea( "SD2" )
DbSetOrder( 3 )

SetRegua( ( Val( mv_par03 ) - Val( mv_par02 ) ) + 1 )

If mv_par04 == 0
   mv_par04 := 1
EndIf

DbSelectArea( "SF2" )
DbSeek( xFilial("SF2") + mv_par02 + mv_par01 , .t. )

While !Eof() .and. F2_FILIAL+F2_DOC+F2_SERIE <= xFilial()+mv_par03+mv_par01
   If  F2_ESPECIE $ cEspecie   //$ "RFN  RTS  RCD  RFB  "
      If F2_SERIE != mv_par01
         DbSkip()
         Loop
      EndIf
      PrintComp( F2_ESPECIE )
   EndIf
   DbSkip()
EndDo

Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

Return

/*/
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
Static Function PrintComp( cEspecie )

Local nLenMemo := 0, ;
cMemo    := Space( 0 ), ;
nIdx     := 0, ;
nRecSD2  := 0, ;
nRecSD1  := 0

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

If cEspecie $ "RFN  RTS  RCD  RFB  "

/*
		*1 Desde aca Seryo Bloqueo de reimpresion de Remito
*/
//  If Empty(F2_IMPRESS) // *1 Seryo

	nMoeda   := F2_MOEDA
	cMoneda  := aDescMon[ If( Empty( F2_MOEDA ), 1, F2_MOEDA ) ]
	cSigno   := aSimbMon[ If( Empty( F2_MOEDA ), 1, F2_MOEDA ) ]

	DbSelectArea( "SE1" )                                  //ripley
	DbSeek( xFilial('SE1') + SF2->F2_SERIE + SF2->F2_DOC )
	While !Eof() .and. ( E1_FILIAL + E1_PREFIXO + E1_NUM ) == ;
		( xFilial('SF2') + SF2->F2_SERIE + SF2->F2_DOC )
		If E1_TIPO == Left( cEspecie, 3 )
			nCotiz := ( E1_VLCRUZ / E1_VALOR )
		EndIf
		dFecVto    := E1_VENCTO
		DbSkip()
	EndDo


	If cEspecie $ "RFN  "
		DbSelectArea( "SA1" )
		DbSeek( xFilial( "SA1" ) + SF2->F2_CLIENTE + SF2->F2_LOJA )
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
	Else
		DbSelectArea( "SA2" )
		DbSeek( xFilial( "SA2" ) + SF2->F2_CLIENTE + SF2->F2_LOJA )
		_CodClie	:=	SA2->A2_COD
		_NomClie	:=	SA2->A2_NOME
		_EndClie	:=	SA2->A2_END
		_MunClie	:=	SA2->A2_MUN
		_TipClie	:=	SA2->A2_TIPO
		_CepClie	:=	SA2->A2_CEP
		_CgcClie	:=	SA2->A2_CGC
		_EstClie	:=	SA2->A2_EST
		_PaiCLie	:=	SA2->A2_PAIS
      _CosProv := " "
	EndIf

	DbSelectArea( "SX5" )
	DbSeek( xFilial() + "12" + _EstClie )
	cProvincia := AllTrim( X5_DESCRI )

	DbSeek( xFilial() + "SF" + _TipClie )
	cSitIVA := AllTrim( X5_DESCSPA )

	DbSelectArea( "SYA" )
	DbSeek( xFilial() + _PaiCLie )

	DbSelectArea( "SE4" )
	DbSeek( xFilial() + SF2->F2_COND )

	DbSelectArea( "SA3" )
	DbSeek( xFilial() + SF2->F2_VEND1 )
	cVend    := SA3->A3_COD
	cNomVend := SA3->A3_NOME

	DbSelectArea( "SD2" )
	DbSeek( SF2->F2_FILIAL + SF2->F2_DOC+ SF2->F2_SERIE +SF2->F2_CLIENTE + SF2->F2_LOJA )
	nRecSD2  := Recno()

   While !Eof() .and. ( SF2->F2_FILIAL + SF2->F2_DOC+ SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ) == ;
                      ( D2_FILIAL + D2_DOC+ D2_SERIE +D2_CLIENTE + D2_LOJA )

		If SF2->F2_ESPECIE != D2_ESPECIE
			DbSkip()
			Loop
		EndIf

		_cFactura := TraeFactura()
		If Empty( AScan( aFactura, Alltrim(_cFactura) ) )
			AAdd( aFactura, Alltrim(_cFactura) )
		EndIf

		If !Empty( D2_PEDIDO )
			If Empty( AScan( aPedidos, D2_PEDIDO ) )
				AAdd( aPedidos, D2_PEDIDO )
			EndIf
		EndIf

		If !(D2_Local $ cDepProc)
			cDepProc += If( !Empty( cDepProc ), "/", "" ) + D2_Local
		EndIf

		DbSkip()
	EndDo

	DbGoTo( nRecSD2 )

   cOcomp   := " "
   AEval( aPedidos,  { |a| cOcomp  += If( !Empty( cOcomp ),  "/", "" ) + AllTrim( a ) } )
	// AEval( aPedidos, ;
	// { |a| DbSelectArea( "SC5" ), DbSeek( xFilial() + a ), ;
	//   cMemo    += AllTrim( SC5->C5_MEMOFAC ), ;
	//   cMenNota += If( !Empty( cMenNota ), " ", "" ) + AllTrim( C5_MENNOTA ), If( Empty( AScan( aOCompras, SC5->C5_OCOMPRA ) ), AAdd( aOCompras, SC5->C5_OCOMPRA ), ) } )

	DbSelectArea( "SF2" )

	nLenMemo := MLCount( cMemo, 125 )

	For nIdx := 1 TO nLenMemo
		AAdd( aMemo, MemoLine( cMemo, 125, nIdx ) )
	Next

   For nCopies := 1 TO mv_par04
		PrintHead( cEspecie, nCopies )
		PrintItem( cEspecie )
		PrintFoot( cEspecie, nCopies )
	Next
/*
   RecLock( "SF2", .f. ) // *1 Seryo
   SF2->F2_IMPRESS := "S" // *1 Seryo
   MsUnLock() // *1 Seryo
  Else // *1 Seryo
  	Msgstop("La reimpresion de remitos no esta permitida.","Remito ya Impreso...") // *1 Seryo
  EndIf // *1 Seryo
*/
EndIf

Return

/*/
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
Static Function PrintHead( cEspecie, nCopyNum )

Local cPedidos  := Space( 0 ), ;
      cFactura  := Space( 0 )

AEval( aPedidos,  { |a| cPedidos  += If( !Empty( cPedidos ),  "/", "" ) + AllTrim( a ) } )
AEval( aFactura,  { |a| cFactura  += If( !Empty( cFactura ),  "/", "" ) + AllTrim( a ) } )

nSeguro:=nBultos:=0
If Len(aPedidos) > 0
	For xI := 1 TO Len( aPedidos )
		SC5->(DbSeek( xFilial() + aPedidos[xI] ))
		If SC5->(found())
			If !empty(SC5->C5_TRANSP)
				SA4->(DbSeek( xFilial() + SC5->C5_TRANSP ))
			EndIf
//         If !empty(SC5->C5_USORDCO)
//            cOcomp := Alltrim(SC5->C5_USORDCO)
//         EndIf
		EndIf
	Next
EndIf

DO CASE                                                            //Antes
   CASE cEspecie == "RFN  "   ; _EspecieTXT := "VENTAS"			   //"NORMAL"
   CASE cEspecie == "RTS  "   ; _EspecieTXT := "INTERPLANTA"      //"TRANSFERENCIA"
   CASE cEspecie == "RCD  "   ; _EspecieTXT := "DEVOLUCION"
   CASE cEspecie == "RFB  "   ; _EspecieTXT := "TERCEROS"
ENDCASE
If lSeteo
   @ prow(),Pcol() PSAY CHR(27)+CHR(64)  // Inicializo impresora
   @ prow(),Pcol() PSAY CHR(27)+CHR(67)+CHR(72)  // Setea la cantidad de lineas por hoja
   @ prow(),Pcol() PSAY CHR(27)+CHR(77)+CHR(15)  // condensado
   lSeteo:=.F.
EndIf

nLin:=1
//@ nLin,065 PSAY "("+_EspecieTXT+")"
//@ prow(),Pcol() PSAY CHR(18)  // Normal
nLin  := nLin + 4
@ nLin,127 PSAY dtoc(SF2->F2_EMISSAO)
nLin  := nLin + 5
@ nLin,012 PSAY  AllTrim( _NomClie ) + '( '+ Alltrim(_CodClie) + ')'
@ nLin,120 PSAY IF(SF2->F2_ESPECIE $ 'RTS  ','TRANSFERENCIA','')
nLin++
@ nLin,000 PSAY "Domicilio: " + AllTrim( _EndClie )
@ nLin,120 PSAY "Acopio : " + SF2->F2_XNROACO
nLin++
@ nLin,000 PSAY "Localidad: " + Alltrim( _MunClie ) + If( _TipClie != "E",If(!Empty( cProvincia )," - "+ cProvincia,"" ),"   Pais: " + ;
                AllTrim( SYA->YA_DESCR ) )+"   C.P.: "+AllTrim( _CepClie )
nLin++
//@ nLin,120 PSAY "Acopio : " + SF2->F2_XNROACO
nLin++
//@ nLin,000 PSAY "Proveedor: " + _CosProv
@ nLin,018 PSAY  cSitIVA
@ nLin,095 PSAY Subst(_CgcClie,1,2)+'-'+Subst(_CgcClie,3,8)+'-'+Subst(_CgcClie,11,1)
@ nLin,120 PSAY "Control: " + Subst(SF2->F2_DOC,1,4)+'-'+Subst(SF2->F2_DOC,5,8)
nLin  := nLin + 2
/*
IF !empty(SC5->C5_TRANSP) .and. SA4->(found())
   @ nLin,000 PSAY "Identificacion Transportista: " + Alltrim(SA4->A4_NOME)
   nLin++
   @ nLin,000 PSAY "Domicilio: " + AllTrim( SA4->A4_END)
   @ nLin,115 PSAY "C.U.I.T.: " + Subst(SA4->A4_CGC,1,2)+'-'+Subst(SA4->A4_CGC,3,8)+'-'+Subst(SA4->A4_CGC,11,1)
   nLin++
EndIf
*/
//nLin  := nLin + 2
@ nLin,062 PSAY AllTrim(cOcomp)
@ nLin+2,050 PSAY Posicione('SE4',1,xFilial('SE4')+SF2->F2_COND,'E4_DESCRI')
//@ nLin,045 PSAY AllTrim(cPedidos)
nLin := 22

Return

/*/
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
Static Function PrintItem( cEspecie )

Local nElem      := 0, ;
      nIdx       := 0, ;
      nPos       := 0, ;
      cDespachos := Space( 0 ), ;
      aAux       := Array( 0 ), ;
      aOrigenes  := Array( 0 ), ;
      cOrigenes  := Space( 0 ), ;
      cDescrip   := Space( 0 ), ;
      cDescrip1  := Space( 0 ), ;
      cDescrip2  := Space( 0 ), ;
      lexedio    := .f., ;
      aResult    := {},;
      cNUMDESP   := Space( 0 ), ;
      nSubTot    := .f., ;
      aItems     := Array( 0 ), ;
      xI         := 0

DbSelectArea( "SD2" )
DbSeek( SF2->F2_FILIAL + SF2->F2_DOC+ SF2->F2_SERIE +SF2->F2_CLIENTE + SF2->F2_LOJA )

While ( cEspecie $ "RFN  RTS  RCD  RFB  " .AND. ;
	( xFilial() + SF2->F2_DOC+ SF2->F2_SERIE +SF2->F2_CLIENTE + SF2->F2_LOJA   ) == ;
	( D2_FILIAL + D2_DOC+ D2_SERIE + D2_CLIENTE + D2_LOJA  ) )

	DbSelectArea( "SB1" )
	DbSeek( xFilial() + SD2->D2_COD )
	If !Empty( SD2->D2_DESCRI )
        cDescrip := Alltrim(SD2->D2_DESCRI)
    Else
        cDescrip := Alltrim(SB1->B1_DESC)
 	EndIf
	
	cUm      := " ("+B1_UM+")"
	If B1_RASTRO == "L" .AND. !EMPTY(SD2->D2_LOTECTL)
		SB8->( DbSeek( xFilial( "SD2" ) + SD2->D2_COD + SD2->D2_LOTECTL ) )
		cNUMDESP := SB8->B8_NUMDESP
      SYA->( DbSeek( xFilial() + SB8->B8_ORIGEM ) )
      cOrigenes:=AllTrim( SYA->YA_DESCR )
	EndIf

	DbSelectArea( "SC6" )
	DbSeek( xFilial() + SD2->D2_PEDIDO + SD2->D2_ITEMPV + SD2->D2_COD )
	If Empty( cDescrip )
		cDescrip := AllTrim( C6_DESCRI )
	EndIf

	DbSelectArea( "SD2" )

	If LEN(cDescrip) > 40
		cDescrip1 := substr(cDescrip,1,40)
		cDescrip2 := substr(cDescrip,41)
		lexedio := .T.
	Else
		cDescrip1 := cDescrip
	EndIf

   //cOcom := posicione("SC5",1, xFilial("SC5") + D2_PEDIDO,"C5_USORDCO" )
   cOcom := 'orden de compra / obs'
   //cDtCl := posicione("SC6",1, xFilial("SC6") + D2_PEDIDO + D2_ITEMPV ,"C6_DETCLI" )
   cDtCl := ' '
   
	AAdd( aItems, ;
   { D2_COD , ;                            //  1
	D2_LOTECTL, ;                              //  2
	SB1->B1_ALTER, ;                           //  3
   cDescrip, ;                                //  4
	D2_QUANT, ;                                //  5
	D2_LOCAL, ;                                //  6
	SC6->C6_QTDVEN, ;                          //  7
   IIF(!EMPTY(SD2->D2_LOTECTL).and.SB8->(found()),SB8->B8_NUMDESP," "), ; //  8
   IIF(!EMPTY(SD2->D2_LOTECTL).and.SB8->(found()),cOrigenes      ," "), ; //  9
   IIF(!EMPTY(SD2->D2_LOTECTL).and.SB8->(found()),SB8->B8_ADUANA ," "), ; // 10
   IIF(!EMPTY(SD2->D2_LOTECTL).and.SB8->(found()),SB8->B8_DATA,   " "), ; // 11
   D2_PEDIDO, ;                               // 12
   D2_UM, ;                                   // 13
   D2_ITEM, ;                                 // 14
   D2_TOTAL,;                                 // 15
   cOcom,;                                    // 16
   cDtCl } )                                  // 17
	DbSkip()

EndDo
aResult := ASort( aItems,,, {|x,y| x[14] < y[14] } )
aItems  := aResult
@ prow(),Pcol() PSAY CHR(27)+CHR(15)  // condensado

nSeguro:=0
For xI := 1 TO Len( aItems )

/*/
Codigo          Descripcion                                        Origen     Nro.Desp.         Fecha   Aduana Detalle cliente           N.Pedido Cant.
123456789.123456123456789.123456789.123456789.123456789.123456789. 123456789. 123456789.123456 zz/zz/zz 123456 123456789.123456789.12345 12345678 12345
0               16                                                 67         78               95       104    111                       137      146

item  Codigo      Cantidad                   Descripcion                                 Deposito 
0000 12345678901 999999.99  123456789012345678901234567890123456789012345678901234567890  XX
0    5           17         28                                                            90
/*/
//   cAduana := U_X5Des( "ZA", aItems[xI][10])
   cAduana := ''
   @ nLin,000 PSAY Alltrim(aItems[xI][14])              // Item
   @ nLin,005 PSAY aItems[xI][1]                          // Producto
   @ nLin,020 PSAY TransForm( aItems[xI][5], "@E 999999.99" ) // Cantidad
   @ nLin,035 PSAY aItems[xI][4]                          // Descripcion
   @ nLin,110 PSAY aItems[xI][6]                         // LOCAL - DEPOSITO
   @ nLin,115 PSAY aItems[xI][12]                         // Pedido
   //@ nLin,067 PSAY Substr(Alltrim(aItems[xI][9]),1,10)    // Origen
   //@ nLin,078 PSAY Substr(Alltrim(aItems[xI][8]),1,16)    // Despacho
   If !Empty(aItems[xI][11])
   //   @ nLin,095 PSAY dtoc(aItems[xI][11])                   // Fecha
   EndIf
   //@ nLin,104 PSAY Substr(Alltrim( cAduana ),1,6)         // Aduana
   //@ nLin,111 PSAY aItems[xI][17]                         // Detalle cliente
   nBultos += aItems[xI][5]
   nLin++
//   If !Empty(Alltrim(aItems[xI][8]))
//      cAduana :=
//      @ nlin,005 PSAY "Origen: " +  + " " + "Despacho: " +  + " " + ;
//                      "Aduana: " + Alltrim(cAduana)       + " " + "Ingreso: "  +
//      nLin++
//   Else�
//      nLin++
//   Endif

Next

DbSelectArea( "SF2" )
Return

/*/
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
Static Function PrintFoot( cEspecie, nCopyNum )
@ prow(),Pcol() PSAY CHR(27)+CHR(18)  // normal
@ 055,015 PSAY POSICIONE('SA4',1,XFILIAL('SA4')+SF2->F2_TRANSP,"A4_NOME")
@ 057,015 PSAY SF2->F2_XENDENT
@ 058,040 PSAY "Cant.Total elementos: " + TransForm( nBultos, "@E 99999" )
@ 060,022 PSAY  TransForm( SF2->F2_VALMERC, "@E 99999999.99" )

//@ 060,040 PSAY "Cant.Total elementos: " + TransForm( nBultos, "@E 99999" )

Return                               

/*/
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
AAdd( aRegs, { cPerg, "01", "Serie ?      :   ", "Serie ?      :   ", "Serie ?      :   ", "mv_ch1", "C", 3 , 00, 1, "G", "", "mv_par01", "R", "R", "R", "R", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "01","","" } )
AAdd( aRegs, { cPerg, "02", "Desde Remito?:   ", "Desde Remito?:   ", "Desde Remito?:   ", "mv_ch2", "C", 12, 00, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "03", "Hasta Remito?:   ", "Hasta Remito?:   ", "Hasta Remito?:   ", "mv_ch3", "C", 12, 00, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "04", "Cantidad Copias?:", "Cantidad Copias?:", "Cantidad Copias?:", "mv_ch4", "N", 1 , 00, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","",""} )
AAdd( aRegs, { cPerg, "05", "Tipo Comprob.:   ", "Tipo Comprob.:   ", "Tipo Comprob.:   ", "mv_ch5", "N", 1 , 00, 0, "C", "", "mv_par05", "Facturas", "Facturas", "Facturas","", "", "N. Debito", "N. Debito", "N. Debito", "", "", "N. Credito", "N. Credito", "N. Credito", "", "", "", "", "", "", "", "", "", "", "", "","","" } )

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
���Funcion   �          � Autor � Diego Fernando Rivero � Data �   /  /   ���
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
