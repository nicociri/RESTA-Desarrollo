#include "protheus.ch"
#define NUMCOPY { "ORIGINAL", "DUPLICADO", "TRIPLICADO", "CUADRUPLICADO", "QUINTUPLICADO", "SEXTUPLICADO" }
#define TXTTF1  "El precio es FIJO EN PESOS si el pago se efectua en la fecha convenida."
#define TXTTF2  "Todo atraso en el pago podra generar actualizaciones de precios, mas las "
#define TXTTF3  "sumas que correspondieren por pago fuera de termino."
#define TXTTF4  "  * * *  PAGOS  FUERA  DE  TERMINO  * * *"
#define TXTTF5  "Vencida esta factura se recargara un interes"
#define TXTTF6  "de 7.5% mensual mas 5% en concepto de gastos"
#define TXTTF7  "administrativos."
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funci�n   �          � Autor � carlos petronacci    � Data � 06/02/14 ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  �     Layout de Facturas de Venta, Notas de Credito y Notas  ���
���          �     de Debito                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function KFatr01
Private lPrinted  := .F.,;
cPerg     := 'KFTR01    ',;
tamanho   := "P",;
limite    := 72,;
aReturn   := { "", 1,"", 1, 1, 1,"",1 },;//Zebrado Administracion
wnrel     := "FACTURA",;
titulo    := "Impresion de Facturas",;
cDesc1    := " ",;
cDesc2    := " ",;
cDesc3    := " ",;
nLin      := 72,;
lSeteo    := .T.

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private nLastKey     := 0
Private cbtxt        := Space(10)


ValidPerg( cPerg )

Pergunte( cPerg, .F. )

cString:="SF2"

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.)

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
	RptStatus( { || SelectComp() } )
	Return
#ENDIF

Return nil

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
Static Function SelectComp()
Local   nCopies  := 0
Private nLine    := 0,;
cDocum   := Space( 0 )

DbSelectArea( "SED" )
DbSetOrder( 1 )
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
DbSelectArea( "SE5" )
DbSetOrder( 7 )      // E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
DbSelectArea( "SF3" )
DbSetOrder( 4 )      // CLIENTE+LOJA+NOTA FISCAL+SERIE
DbSelectArea( "SF1" )
DbSetOrder( 1 )
DbSelectArea( "SD1" )
DbSetOrder( 1 )
DbSelectArea( "SF2" )
DbSetOrder( 1 )
DbSelectArea( "SD2" )
DbSetOrder( 3 )

SetRegua( ( Val( mv_par04 ) - Val( mv_par03 ) ) + 1 )

If mv_par05 == 0
   mv_par05 := 1
EndIf

If mv_par01 < 3       // Facturas y Notas de debito
	DbSelectArea( "SF2" )
	DbSeek( xFilial() + mv_par03 + mv_par02 , .t. )

	While !Eof() .and. F2_FILIAL+F2_DOC+F2_SERIE <= xFilial()+mv_par04+mv_par02
		If  ( mv_par01 == 1 .AND. F2_ESPECIE $ "NF   -FT   " ) .OR. ( mv_par01 == 2 .AND. F2_ESPECIE == "NDC  " )
			If F2_SERIE != mv_par02
				DbSkip()
				Loop
			EndIf
         If Dtos(F2_EMISSAO) < Dtos(mv_par06) .or.    Dtos(F2_EMISSAO) > Dtos(mv_par07)
				DbSkip()
				Loop
			EndIf
			SA1->( DbSeek( xFilial( "SA1" ) + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
//         If F2_PRINTED == "S"
//            If !MsgYesNo( "Desea reimprimir ?", AllTrim( F2_ESPECIE ) + " " + AllTrim( F2_SERIE )+ "-" + F2_DOC + " ya impreso" )
//               DbSkip()
//               Loop
//            EndIf
//         EndIf
			PrintComp( F2_ESPECIE )
		EndIf
		DbSkip()
	EndDo

Else

	DbSelectArea( "SF1" )
	DbSeek( xFilial() + mv_par03 + mv_par02 , .t. )
	While !Eof() .And.xFilial() + mv_par04 + mv_par02 >= F1_FILIAL+F1_DOC+F1_SERIE
		If F1_ESPECIE == "NCC  "
			If F1_SERIE != mv_par02
				DbSkip()
				Loop
			EndIf
         If Dtos(F1_EMISSAO) < Dtos(mv_par06) .or.    Dtos(F1_EMISSAO) > Dtos(mv_par07)
				DbSkip()
				Loop
			EndIf
			SA1->( DbSeek( xFilial( "SA1" ) + SF1->F1_ForNECE + SF1->F1_LOJA ) )
			//         If F1_PRINTED == "S"
			//            If !MsgYesNo( "Desea reimprimir ?", AllTrim( F1_ESPECIE ) + " " + AllTrim( F1_SERIE )+ "-" + F1_DOC + " ya impreso" )
			//               DbSkip()
			//               Loop
			//            EndIf
			//         EndIf
			PrintComp( F1_ESPECIE )
		EndIf
		DbSkip()
	EndDo

EndIf

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
        aRemitos   := Array( 0 ), ;
        aDeposito  := Array( 0 ), ;
        aOCompras  := Array( 0 ), ;
        aSenia     := Array( 0 ), ;
        aAE        := Array( 0 ), ;
        cMenNota   := Space( 0 ), ;
        cProvincia := Space( 0 ), ;
        cSitIVA    := Space( 0 ), ;
        cLugEnt    := Space( 0 ), ;
        nMoeda     := 0, ;
        nValmerc   := 0, ;
        nDesc      := 0, ;
        nTotUni    := 0, ;
        cNumRa     := " ",;
        dFecRa     := ctod('  /  /  '),;
        nImpRa     := 0,;
        aDriver    := ReadDriver(), ;
        nCotiz     := 0 , ;
        cNomVend   := " ", ;
        cVend      := " ", ;
        cOcomp     := " ", ;
        cNatdesc   := " ", ;
        nBultos    := 0,;
        nPesNet    := 0,;
        nPesBto    := 0,;
        cRefInt    := Space( 0 ), ;
        cIncoter   := Space( 0 ), ;
        cFecVto    := " "

If cEspecie $ "NF   -FT   -NDC  "

/*
		*1 Desde aca Seryo Bloqueo de reimpresion de Remito
*/
//  If Empty(F2_IMPRESS) // *1 Seryo
	nMoeda   := F2_MOEDA
	cMoneda  := aDescMon[ If( Empty( F2_MOEDA ), 1, F2_MOEDA ) ]
	cSigno   := aSimbMon[ If( Empty( F2_MOEDA ), 1, F2_MOEDA ) ]

	nCotiz := F2_TXMOEDA

	DbSelectArea( "SED" )
	DbSeek( xFilial() + SF2->F2_NATUREZ )
	cNatDesc:=SED->ED_DESCRIC
	DbSelectArea( "SA1" )
	DbSeek( xFilial() + SF2->F2_CLIENTE + SF2->F2_LOJA )
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
	DbSeek( xFilial() + "12" + SA1->A1_EST )
	cProvincia := AllTrim( X5_DESCRI )

	DbSeek( xFilial() + "SF" + SA1->A1_TIPO )
	cSitIVA := AllTrim( X5_DESCSPA )

	DbSelectArea( "SYA" )
	DbSeek( xFilial() + SA1->A1_PAIS )

	DbSelectArea( "SE4" )
	DbSeek( xFilial() + SF2->F2_COND )

	If !empty(SF2->F2_VEND1)
		DbSelectArea( "SA3" )
		DbSeek( xFilial() + SF2->F2_VEND1 )
		cVend    := Alltrim(SA3->A3_COD)
		cNomVend := Alltrim(SA3->A3_NREDUZ)
	EndIf

	If !empty(SF2->F2_VEND2)
		DbSelectArea( "SA3" )
		DbSeek( xFilial() + SF2->F2_VEND2 )
		cVend    := cVend + "/" + Alltrim(SA3->A3_COD)
		cNomVend := cNomVend + "/" + Alltrim(SA3->A3_NREDUZ)
	EndIf

	If !empty(SF2->F2_VEND3)
		DbSelectArea( "SA3" )
		DbSeek( xFilial() + SF2->F2_VEND3 )
		cVend    := cVend + "/" + Alltrim(SA3->A3_COD)
		cNomVend := cNomVend + "/" + Alltrim(SA3->A3_NREDUZ)
	EndIf

	If !empty(SF2->F2_VEND4)
		DbSelectArea( "SA3" )
		DbSeek( xFilial() + SF2->F2_VEND4 )
		cVend    := cVend + "/" + Alltrim(SA3->A3_COD)
		cNomVend := cNomVend + "/" + Alltrim(SA3->A3_NREDUZ)
	EndIf

	If !empty(SF2->F2_VEND5)
		DbSelectArea( "SA3" )
		DbSeek( xFilial() + SF2->F2_VEND5 )
		cVend    := cVend + "/" + Alltrim(SA3->A3_COD)
		cNomVend := cNomVend + "/" + Alltrim(SA3->A3_NREDUZ)
	EndIf
   DbSelectArea( "SE1" )
   DbSeek( SF2->F2_FILIAL + SF2->F2_SERIE + SF2->F2_DOC )
   While !Eof() .and. ( E1_FILIAL + E1_PREFIXO + E1_NUM ) == ( xFilial('SF2') + SF2->F2_SERIE + SF2->F2_DOC )
      If empty(cFecVto)
         cFecVto := dtoc(E1_VENCTO)
      Else
         cFecVto += " " + dtoc(E1_VENCTO)
      EndIf
      DbSkip()
   EndDo

	DbSelectArea( "SD2" )
	DbSeek( SF2->F2_FILIAL + SF2->F2_DOC+ SF2->F2_SERIE +SF2->F2_CLIENTE + SF2->F2_LOJA )
	nRecSD2  := Recno()

	While !Eof() .and. ( SF2->F2_FILIAL + SF2->F2_DOC+ SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA   ) == ;
		( D2_FILIAL + D2_DOC+ D2_SERIE +D2_CLIENTE + D2_LOJA   )

		If SF2->F2_ESPECIE != D2_ESPECIE
			DbSkip()
			Loop
		EndIf

		If !Empty( D2_REMITO )
			If Empty( AScan( aRemitos, Alltrim(Str(Val(D2_REMITO),12,0)) ) )
				AAdd( aRemitos, Alltrim(Str(Val(D2_REMITO),12,0)) )
			EndIf
			_cPedido := TraePedido()
			SC5->(DbSeek( xFilial() + _cPedido ))
			/*      If SC5->(found())
			nBultos := SC5->C5_USBULTO
			nPesNet := SC5->C5_PESOL
			nPesBto := SC5->C5_PBRUTO
			cRefInt := SC5->C5_FCOT
			cIncoter:= SC5->C5_INCOTER
			EndIf
			*/
			If Empty( AScan( aPedidos, Alltrim(Str(Val(_cPedido),6,0)) ) )
				AAdd( aPedidos, Alltrim(Str(Val(_cPedido),6,0)) )
			EndIf
         //If !empty(SC5->C5_USORDCO)
         //   cOcomp := Alltrim(SC5->C5_USORDCO)
         //EndIf
         If !empty(SC5->C5_MENNOTA)
            cMenNota := Alltrim(SC5->C5_MENNOTA)
         EndIf
		EndIf

		If !Empty( D2_PEDIDO )
			If Empty( AScan( aPedidos, Alltrim(Str(Val(D2_PEDIDO),6,0)) ) )
				AAdd( aPedidos, Alltrim(Str(Val(D2_PEDIDO),6,0)) )
			EndIf
         SC5->(DbSeek( xFilial() + SD2->D2_PEDIDO )) 
         /*  no usan campo especifico orden de compra 16/06/2010
         If !empty(SC5->C5_USORDCO)
            cOcomp := Alltrim(SC5->C5_USORDCO)
         EndIf
         
         DbSelectArea( "SC6" )
         DbSeek( xFilial() + SD2->D2_PEDIDO + SD2->D2_ITEMPV + SD2->D2_COD )
         If !Empty( C6_E_NUMAE )
            AAdd( aAE, Alltrim(C6_E_NUMAE) )
         EndIf
         */
         DbSelectArea( "SD2" )
		EndIf

		If !Empty( D2_LOCAL )
			If Empty( AScan( aDeposito, D2_LOCAL ) )
				AAdd( aDeposito,D2_LOCAL )
			EndIf
		EndIf

		DbSkip()
	EndDo

	DbGoTo( nRecSD2 )

//   AEval(aPedidos, { |a| DbSelectArea( "SC5" ), DbSeek( xFilial() + a ), cOcomp += AllTrim( SC5->C5_USORDCO ) })

	DbSelectArea( "SF2" )

	nLenMemo := MLCount( cMemo, 125 )

	For nIdx := 1 TO nLenMemo
		AAdd( aMemo, MemoLine( cMemo, 125, nIdx ) )
	Next

   For nCopies := 1 TO mv_par05 // SA1->A1_NCOPIfT
		PrintHead( cEspecie, nCopies )
		PrintItem( cEspecie )
		PrintFoot( cEspecie, nCopies )
	Next

	//   RecLock( "SF2", .f. )
	//   FIELD->F2_PRINTED := "S"
	//   MsUnLock()

	//   DbSelectArea( "SF3" )
	//   DbSeek( SF2->F2_FILIAL + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_DOC+ SF2->F2_SERIE )
	//   If Found() .and. SF2->F2_ESPECIE == SF3->F3_ESPECIE
	//      RecLock( "SF3", .f. )
	//      replace F3_PRINTED with "S"
	//      MsUnLock()
	//   EndIf       

	/*   carlos 16/06/2010
	DbSelectArea( "SF2" )
   RecLock( "SF2", .f. ) // *1 Seryo
   SF2->F2_IMPRESS := "S" // *1 Seryo
   MsUnLock() // *1 Seryo 

  Else // *1 Seryo
  	Msgstop("La reimpresion de Documentos no esta permitida.","Documento ya Impreso...") // *1 Seryo
  EndIf // *1 Seryo
*/  
  
ElseIf AllTrim( cEspecie ) $ "NCC  "

  If Empty(F1_IMPRESS)
	nMoeda   := F1_MOEDA
	cMoneda  := aDescMon[ If( Empty( F1_MOEDA ), 1, F1_MOEDA ) ]
	cSigno   := aSimbMon[ If( Empty( F1_MOEDA ), 1, F1_MOEDA ) ]
	nCotiz := F1_TXMOEDA
	//   DbSelectArea( "SE1" )
	//   DbSeek( SF1->F1_FILIAL + SF1->F1_SERIE + SF1->F1_DOC )
	//   While !Eof() .and. ( E1_FILIAL + E1_PREFIXO + E1_NUM ) == ;
	//      ( xFilial('SF1') + SF1->F1_SERIE + SF1->F1_DOC )
	//      dFecVto    := E1_VENCTO
	//      DbSkip()
	//   EndDo
	//   DbEval( { || nCotiz := ( E1_VLCRUZ / E1_VALOR ) }, ;
	//   { || E1_TIPO == Left( cEspecie, 3 ) }, ;
	//   { || ( E1_FILIAL + E1_PREFIXO + E1_NUM ) == ;
	//   ( SF1->F1_FILIAL + SF1->F1_SERIE + SF1->F1_DOC ) } )

	DbSelectArea( "SA1" )
    DbSeek( xFilial() + SF1->F1_FORNECE + SF1->F1_LOJA )
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
	DbSeek( xFilial() + "12" + SA1->A1_EST )
	cProvincia := AllTrim( X5_DESCRI )
	DbSeek( xFilial() + "SF" + SA1->A1_TIPO )
	cSitIVA := AllTrim( X5_DESCSPA )

	DbSelectArea( "SYA" )
	DbSeek( xFilial() + SA1->A1_PAIS )

	DbSelectArea( "SE4" )
	DbSeek( xFilial() + SF1->F1_COND )

	DbSelectArea( "SD1" )
	DbSeek( xFilial() + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_ForNECE + SF1->F1_LOJA )

	DbSelectArea( "SF1" )

   For nCopies := 1 TO mv_par05
		PrintHead( cEspecie, nCopies )
		PrintItem( cEspecie )
		PrintFoot( cEspecie, nCopies )
	Next

	//   RecLock( "SF1", .f. )
	//   FIELD->F1_PRINTED := "S"
	//   MsUnLock()

	//   DbSelectArea( "SF3" )
	//   DbSeek( SF1->F1_FILIAL + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_DOC+ SF1->F1_SERIE )
	//   If Found() .and. SF2->F2_ESPECIE == SF3->F3_ESPECIE
	//      RecLock( "SF3", .f. )
	//      replace F3_PRINTED with "S"
	//      MsUnLock()
	//   EndIf
	DbSelectArea( "SF1" )
   RecLock( "SF1", .f. ) // *1 Seryo
   SF1->F1_IMPRESS := "S" // *1 Seryo
   MsUnLock() // *1 Seryo
  Else // *1 Seryo
  	Msgstop("La reimpresion de Documentos no esta permitida.","Documento ya Impreso...") // *1 Seryo
  EndIf // *1 Seryo

EndIf

Return nil

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

Local cOCompras := " ",;
      cPedidos  := " ",;
      cDepProc  := " ",;
      cRemitos  := " ",;
      cAE       := " "

AEval( aOCompras, { |a| cOCompras += If( !Empty( cOCompras ), "/", "" ) + AllTrim( a ) } )
AEval( aPedidos,  { |a| cPedidos  += If( !Empty( cPedidos ),  "/", "" ) + AllTrim( a ) } )
AEval( aRemitos,  { |a| cRemitos  += If( !Empty( cRemitos ),  "/", "" ) + AllTrim( a ) } )
AEval( aDeposito, { |a| cDepProc  += If( !Empty( cDepProc ),  "/", "" ) + AllTrim( a ) } )
AEval( aAE,       { |a| cAE       += If( !Empty( cAE ),       "/", "" ) + AllTrim( a ) } )

If lSeteo
	@ 000,000 PSAY CHR(27)+CHR(67)+CHR(72)  // Setea la cantidad de lineas por hoja 
	@ 000,000 PSAY CHR(15)
	//   @ 000,000 PSAY CHR(27)+CHR(67)+CHR(48)+CHR(8.5)  // Setea la cantidad de lineas por hoja
	lSeteo:=.F.
EndIf
 
If cEspecie == "NCC  "
	cSerie := Left( AllTrim( SF1->F1_SERIE ), 1 )
Else
	cSerie := Left( AllTrim( SF2->F2_SERIE ), 1 )
EndIf
If cEspecie == "NCC  "
	cDoc:= Left( SF1->F1_DOC, 4 ) + "-" + Right( SF1->F1_DOC, 8 )
Else
	cDoc:= Left( SF2->F2_DOC, 4 ) + "-" + Right( SF2->F2_DOC, 8 )
EndIf
/*
If cEspecie $ "NDC  "
	@ nLin,047 PSAY "NOTA DE DEBITO "+cSerie+" "+cDoc
	nLin++
ElseIf cEspecie $ "NCC  "
	@ nLin,047 PSAY "NOTA DE CREDITO "+cSerie+" "+cDoc
	nLin++
Else
//   @ nLin,047 PSAY "FACTURA " +cSerie+" "+cDoc
	nLin++
EndIf     
*/
nLin:=1

nLin  := nLin + 4
@ nLin,127 PSAY IIF(cEspecie $ "NCC  ",DToC( SF1->F1_EMISSAO ),dtoc(SF2->F2_EMISSAO))
nLin  := nLin + 5

//nLin  := 13
@ nLin,020 PSAY   Alltrim(SA1->A1_NOME)+ '( '+ AllTrim( SA1->A1_COD ) + ')'
nLin++
@ nLin,000 PSAY  AllTrim( SA1->A1_END )
@ nLin,120 PSAY "Acopio : " + IIF(cEspecie $ "NCC  ",SF1->F1_XNROACO,SF2->F2_XNROACO)
nLin++
@ nLin,000 PSAY "Localidad: " + Alltrim( _MunClie ) + If( _TipClie != "E",If(!Empty( cProvincia )," - "+ cProvincia,"" ),"   Pais: " + ;
                AllTrim( SYA->YA_DESCR ) )+"   C.P.: "+AllTrim( _CepClie )
nLin++
nLin++
@ nLin,018 PSAY  cSitIVA
@ nLin,095 PSAY  Subst(SA1->A1_CGC,1,2)+'-'+Subst(SA1->A1_CGC,3,8)+'-'+Subst(SA1->A1_CGC,11,1)
@ nLin,120 PSAY "Control: " + IIF(cEspecie $ "NCC  ",Subst(SF1->F1_DOC,1,4)+'-'+Subst(SF1->F1_DOC,5,8),Subst(SF2->F2_DOC,1,4)+'-'+Subst(SF2->F2_DOC,5,8))

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


Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcion   �          � Autor � Hugo Gebriel Bermudez � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function PrintItem( cEspecie )

Local nElem      := 0,;
      nIdx       := 0,;
      nPos       := 0,;
      cDespachos := " ",;
      cOrigenes  := " ",;
      cDescrip   := " ",;
      cNUMDESP   := " ",;
      aItems     := {},;
      aDesc      := {},;
      aAux       := {},;
      aOrigenes  := {},;
      xI         := 0,;
      cDtCl      := space(25)

If cEspecie $ "NF   -FT   -NDC  "
	DbSelectArea( "SD2" )
	DbSeek( SF2->F2_FILIAL + SF2->F2_DOC+ SF2->F2_SERIE +SF2->F2_CLIENTE + SF2->F2_LOJA )
Else
	DbSelectArea( "SD1" )
	DbSeek( xFilial() + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_ForNECE + SF1->F1_LOJA )
EndIf

nDesc      := 0
nTotUni    := 0

While ( cEspecie $ "NF   -FT   -NDC  " .AND. ;
	( xFilial() + SF2->F2_DOC+ SF2->F2_SERIE +SF2->F2_CLIENTE + SF2->F2_LOJA   ) == ;
	( D2_FILIAL + D2_DOC+ D2_SERIE + D2_CLIENTE + D2_LOJA  ) ) .OR. ;
	( cEspecie $ "NCC  " .AND. ;
	( SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_ForNECE + SF1->F1_LOJA ) == ;
	( D1_FILIAL + D1_DOC + D1_SERIE + D1_ForNECE + D1_LOJA ) )

   aDesc := {}
	If cEspecie $ "NF   -FT   -NDC  "

		DbSelectArea( "SB1" )
		DbSeek( xFilial() + SD2->D2_COD )

		If B1_RASTRO == "L" .AND. !EMPTY(SD2->D2_LOTECTL)
         SB8->( DbSeek( xFilial( "SD2" ) + SD2->D2_COD + SD2->D2_LOTECTL ) )
         cNUMDESP := SB8->B8_NUMDESP
         SYA->( DbSeek( xFilial() + SB8->B8_ORIGEM ) )
         cOrigenes := AllTrim( SYA->YA_DESCR )
			//         cNUMDESP := SB8->B8_NUMDESP
			//         SYA->( DbSeek( xFilial() + SB8->B8_ORIGEM ) )
		EndIf

		DbSelectArea( "SC6" )
		DbSeek( xFilial() + SD2->D2_PEDIDO + SD2->D2_ITEMPV + SD2->D2_COD )
      aDesc := {}
      If SA1->A1_TIPO = "E"
         cDescrip := " "
         If !Empty( C6_E_CODIT )
            cDescrip := C6_E_CODIT
            nLenMemo := MLCount( cDescrip, 50 )
            For nIdx := 1 TO nLenMemo
               AAdd( aDesc, MemoLine( cDescrip, 50, nIdx ) )
            Next
         Else
            DbSelectArea( "PA5" )
            DbSetOrder( 1 )   // PA5_FILIAL + PA5_COD + PA5_CLI + PA5_LOJA
            DbSeek( xFilial() + SD2->D2_COD + SF2->F2_CLIENTE + SF2->F2_LOJA )
            If !empty(PA5->PA5_DESC) // Descripcion del maestro de exportaciones
               cDescrip := PA5->PA5_DESC
               nLenMemo := MLCount( cDescrip, 50 )
               For nIdx := 1 TO nLenMemo
                  AAdd( aDesc, MemoLine( cDescrip, 50, nIdx ) )
               Next
            Else
               AAdd( aDesc, Alltrim(SB1->B1_DESC) )
            EndIf
         EndIf
      Else
         If !Empty( C6_DESCRI )
            AAdd( aDesc, Alltrim(C6_DESCRI) )
         Else
            AAdd( aDesc, Alltrim(SB1->B1_DESC) )
         EndIf
		EndIf

		DbSelectArea( "SD2" )

      If !empty(D2_PEDIDO)    // ver DETCLI
         // cDtCl := posicione("SC6",1, xFilial("SC6") + D2_PEDIDO + D2_ITEMPV ,"C6_DETCLI" )
      EndIf
      If empty(cDtCl) .and. !empty(D2_REMITO)
         aAreaSD2 := SD2->( GetArea() )
         cClaRem  := xFilial("SD2") + D2_REMITO + D2_SERIREM + D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEMREM
         cPedNum := posicione("SD2",3, cClaRem ,"D2_PEDIDO" )
         cPedIte := posicione("SD2",3, cClaRem ,"D2_ITEMPV" )
         // cDtCl   := posicione("SC6",1, xFilial("SC6") + cPedNum + cPedIte ,"C6_DETCLI" ) 
         cDtCl   := " " //AGREGADO
         RestArea( aAreaSD2 )
      EndIf


      // { D2_MC_COD , ;                                       // 1 NO EXIXTE EL CAMPO EN PENTA KA 16/06/10
      AAdd( aItems, ;
      { " " , ;                                             // 1      
      D2_LOTECTL, ;                                         // 2
      SB1->B1_ALTER, ;                                      // 3
      aDesc, ;                                              // 4
      D2_QUANT, ;                                           // 5
      0, ;                                                  // 6
      0, ;                                                  // 7
      IIF(SB8->(found()),SB8->B8_NUMDESP," "), ;            // 8
      IIF(SB8->(found()),cOrigenes      ," "), ;            // 9
      IIF(SB8->(found()),SB8->B8_ADUANA ," "), ;            // 10
      D2_REMITO, ;                                          // 11
      D2_UM, ;                                              // 12
      IIF(SB8->(found()),SB8->B8_DATA,   " "), ;            // 13
      D2_DESCON, ;                                          // 14
      cDtCl ,;                                              //  15
       D2_SEGUM,;                                              // 16
       D2_ITEM,;                                              //  17
       D2_PRCVEN} )                                             // 18
//      D2_DESC, ;                                            // 14

      If Left(  SF2->F2_SERIE , 1 ) $ "A    -E    -X    "
         aItems[Len( aItems )][6]  := IIF(D2_PRUNIT > 0,D2_PRUNIT,D2_PRCVEN)
         aItems[Len( aItems )][7]  := D2_TOTAL   // + D2_DESCON
      ElseIf Left(  SF2->F2_SERIE , 1 ) == "B"
         aItems[Len( aItems )][6]  := D2_PRUNIT + ( D2_VALIMP1 / D2_QUANT ) + ( D2_VALIMP2 / D2_QUANT ) + ( D2_VALIMP3 / D2_QUANT ) + ;
                                                 ( D2_VALIMP4 / D2_QUANT ) + ( D2_VALIMP5 / D2_QUANT ) + ( D2_VALIMP7 / D2_QUANT ) + ;
                                                 ( D2_VALIMP8 / D2_QUANT ) + ( D2_VALIMP9 / D2_QUANT )   // + ( D2_VALIMP6 / D2_QUANT )
         aItems[Len( aItems )][7]  := D2_TOTAL + D2_VALIMP1 + D2_VALIMP2 + D2_VALIMP3 + D2_VALIMP4 + D2_VALIMP5 + D2_VALIMP7 + D2_VALIMP8 + D2_VALIMP9// + D2_VALIMP6
         aItems[Len( aItems )][14] := ( D2_QUANT * round(aItems[Len( aItems )][6],2) ) - aItems[Len( aItems )][7]
      EndIf
      nDesc   += aItems[Len( aItems )][14]//D2_DESCON
      nTotUni += D2_PRUNIT * D2_QUANT

	Else

		DbSelectArea( "SD1" )

		DbSelectArea( "SB1" )
		DbSeek( xFilial() + SD1->D1_COD )

		If B1_RASTRO == "L" .AND. !EMPTY(SD1->D1_LOTECTL)
			SB8->( DbSeek( xFilial( "SD1" ) + SD1->D1_COD + SD1->D1_LOTECTL + SD1->D1_NUMLOTE ) )
			cNUMDESP := SB8->B8_NUMDESP
		EndIf

		If EMPTY( cDescrip )
			cDescrip := AllTrim( B1_DESC )
		EndIf
      AAdd( aDesc, Alltrim(B1_DESC) )
		DbSelectArea( "SD1" )

		AAdd( aItems, ;
		{ D1_COD , ;                                                 // 1
		D1_LOTECTL, ;                                                // 2
		SB1->B1_ALTER, ;                                             // 3
      aDesc, ;                                                     // 4
		D1_QUANT, ;                                                  // 5
		0, ;                                                         // 6
		0, ;                                                         // 7
		IIF(SB8->(found()),SB8->B8_NUMDESP," "), ;                   // 8
		" ", ;                                                       // 9    IIF(SB8->(found()),SB8->B8_ORIGEM ," ")
		IIF(SB8->(found()),SB8->B8_SERIE  ," "), ;                   // 10
		" ", ;                                                       // 11
		D1_UM, ;                                                     // 12
		IIF(SB8->(found()),SB8->B8_DTVALID,SD1->D1_DTVALID), ;       // 13
      0,;                                                          // 14
      " " ,;                                                          // 15
       D1_SEGUM,;                                                          //16
       D1_ITEM,;                                                          // 17
       0} )                                                      // 18
      
		If Left(  SF1->F1_SERIE , 1 ) $ "A    -E    -X    "
			aItems[Len( aItems )][6] := D1_VUNIT
			aItems[Len( aItems )][7] := D1_TOTAL
		ElseIf Left(  SF1->F1_SERIE , 1 ) == "B"
			aItems[Len( aItems )][6] := D1_VUNIT + ( D1_VALIMP1 / D1_QUANT ) + ( D1_VALIMP2 / D1_QUANT ) + ( D1_VALIMP3 / D1_QUANT ) + ( D1_VALIMP4 / D1_QUANT ) + ( D1_VALIMP5 / D1_QUANT ) + ( D1_VALIMP6 / D1_QUANT ) + ( D1_VALIMP7 / D1_QUANT ) + ( D1_VALIMP8 / D1_QUANT ) + ( D1_VALIMP9 / D1_QUANT ) + ( D1_VALIMP2 / D1_QUANT ) + ( D1_VALIMP2 / D1_QUANT )
			aItems[Len( aItems )][7] := D1_TOTAL + D1_VALIMP1 + D1_VALIMP2 + D1_VALIMP3 + D1_VALIMP4 + D1_VALIMP5 + D1_VALIMP6 + D1_VALIMP7 + D1_VALIMP8 + D1_VALIMP9
		EndIf

	EndIf

	DbSkip()

EndDo

/*/
Codigo           Descripcion                                        Detalle cliente           Remito       Cant. Precio     Descto.       Total
123456789.123456 123456789.123456789.123456789.123456789.123456789. 123456789.123456789.12345 123456789.12 12345 1234567.99 123456.99 1234567.99
0                17                                                 68                        94           107   113        124       134
/*/
nLin := 30
@ nLin,000 PSAY CHR(15)
For xI := 1 TO Len( aItems )                                

   @ nLin,000 PSAY Alltrim(aItems[xI][17])              // Item
   @ nLin,005 PSAY aItems[xI][1]                            // Producto
   @ nLin,020 PSAY TransForm( aItems[xI][5], "@E 999999.99" ) // Cantidad
   @ nLin,035 PSAY aItems[xI][4][1]                         // Descripcion
   @ nLin,095 PSAY aItems[xI][6]  PICTURE "9999,999.99"   // Precio unitario
   @ nLin,105 PSAY aItems[xI][18]  PICTURE "9999,999.99"   // Precio unitario
   @ nLin,125 PSAY aItems[xI][7]  PICTURE "9999,999.99"   // Total
   nLin++
   If SA1->A1_TIPO = "E"
//      @ nLin,017 PSAY aItems[xI][12]                        // UM
   Else
      //@ nLin,068 PSAY aItems[xI][15]                        // Detalle cliente
      //@ nLin,094 PSAY aItems[xI][11]                        // Remito
//      If !Empty(Alltrim(aItems[xI][8]))
//         cAduana := U_X5Des( "ZA", aItems[xI][10] )
//         @ nlin,017 PSAY "Origen: " + Alltrim(aItems[xI][9]) + " " + "Despacho: " + Alltrim(aItems[xI][8]) + " " + ;
//                        "Aduana: " + Alltrim(cAduana)       + " " + "Ingreso: "  + dtoc(aItems[xI][13])
//         nLin++
//      Endif
   EndIf
   If len(aItems[xI][4]) > 1
      For xZ := 2 TO Len( aItems[xI][4] )
         @ nLin,017 PSAY aItems[xI][4][xZ]                         // Descripcion
         nLin++
      Next xZ
   EndIf
Next
nLin++

Return NIL

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

Local xI       := 0, ;
      aImp, ;
      cTexto   := Space( 0 ), ;
      nLenTxt  := 0,;
      aDescMon := { GetMV( "MV_MOEDA1" ), GetMV( "MV_MOEDA2" ), GetMV( "MV_MOEDA3" ), GetMV( "MV_MOEDA4" ), GetMV( "MV_MOEDA5" ) }

If   cEspecie $ "NF   -FT   -NDC  "
   nNeto  := SF2->F2_BASIMP1 + SF2->F2_BASIMP2 + SF2->F2_BASIMP3 + SF2->F2_BASIMP7 + SF2->F2_BASIMP8
   nIva   := SF2->F2_VALIMP1 + SF2->F2_VALIMP2 + SF2->F2_VALIMP3 + SF2->F2_VALIMP7 + SF2->F2_VALIMP8
	nPerIB := SF2->F2_VALIMP6
Else
   nNeto  := SF1->F1_BASIMP1 + SF1->F1_BASIMP2 + SF1->F1_BASIMP3 + SF1->F1_BASIMP7 + SF1->F1_BASIMP8
   nIva   := SF1->F1_VALIMP1 + SF1->F1_VALIMP2 + SF1->F1_VALIMP3 + SF1->F1_VALIMP7 + SF1->F1_VALIMP8
	nPerIB := SF1->F1_VALIMP6
EndIf

nLin   := 37
/*
nImpRa   := 0
If Len(aSenia) > 0
   nLin := nLin - ( Len(aSenia) + 2 )
   For nX := 1 TO Len(aSenia)
      @ nLin,003 PSAY "Anticipo en Factura: "+aSenia[nX][2]+" "+aSenia[nX][1]//" de Fecha: "+dtoc(aSenia[nX][2])
      @ nLin,068 PSAY aSenia[nX][3] PICTURE "999,999.99"
      nImpRa+=aSenia[nX][3]
      nLin++
	Next
   nLin := 37
EndIf
*/

If nDesc != 0
   @ nLin-2,017 PSAY "Descuento total: "
   @ nLin-2,045 PSAY nDesc PICTURE "999,999.99"
   @ nLin-2,068 PSAY "% Prom.: "
   @ nLin-2,078 PSAY (nDesc/nTotUni)*100 PICTURE "999,999.99"
EndIf

If cEspecie $ "NF   -FT   -NDC  "
	DbSelectArea( "SF2" )
   aImp := U_NumToStr( F2_VALBRUT, 90 )//F2_VALFAT
Else
	DbSelectArea( "SF1" )
   aImp := U_NumToStr( F1_VALBRUT, 90 )
EndIf

If cEspecie $ "NF   -FT   -NDC  "

	DbSelectArea( "SF2" )

   If Left( AllTrim( F2_SERIE ), 1 ) == "A" .or. Left( AllTrim( F2_SERIE ), 1 ) == "B" .or. Left( AllTrim( F2_SERIE ), 1 ) == "E"
      nLin := 55
      @ Prow(),Pcol() PSAY CHR(15)
      //@ nLin,025 PSAY "21%"
      //@ nLin,055 PSAY OemToAnsi( "Perc.Ing.Br.BA" )   
      nLin := 56   
      /*
      @ nLin,008 PSAY aSimbMon[nMoeda]      
      @ nLin,028 PSAY aSimbMon[nMoeda]
      @ nLin,059 PSAY aSimbMon[nMoeda]
      @ nLin,078 PSAY aSimbMon[nMoeda]   
      */
      nLin := 57
      //@ nLin,107 PSAY OemToAnsi( "Sub-Total" )
      If Left( AllTrim( F2_SERIE ), 1 ) == "A" .or. Left( AllTrim( F2_SERIE ), 1 ) == "E"
         @ nLin,125 PSAY F2_VALMERC PICTURE "99999,999.99"
  	  EndIf
	  If Left( AllTrim( F2_SERIE ), 1 ) == "B" // revisar!
         @ nLin,125 PSAY F2_VALBRUT PICTURE "999,999.99"
         //@ nLin,006 PSAY F2_VALMERC + nIva PICTURE "999,999.99"
	  EndIf
      //@ nLin,000 PSAY cMenNota
	  if Left( AllTrim( F2_SERIE ), 1 ) != "B"
         @ 058,110 PSAY "I.V.A. 21%"
         @ 058,125 PSAY F2_VALIMP1 PICTURE "9999,999.99"
         @ 059,110 PSAY "I.V.A. 10.5%"
         @ 059,125 PSAY F2_VALIMP2 PICTURE "9999,999.99"
	  EndIf
	  @ 060,100 PSAY "Perc.IIBB CF" 
      @ 060,125 PSAY F2_VALIMP5 PICTURE "9999,999.99"
	  @ 061,100 PSAY "Perc.IIBB BA" 
      @ 061,125 PSAY F2_VALIMP6 PICTURE "9999,999.99"
	  //nLin:=nLin+2
      //@ nLin,005 PSAY OemToAnsi( "***  Gracias por ser nuestro cliente ***" )
      //@ nLin,107 PSAY OemToAnsi( "Total" )
      @ 063,125 PSAY F2_VALBRUT PICTURE "99999,999.99"
	EndIf

Else
   DbSelectArea( "SF1" )
   /* no hace falta carlos 17/06/10
   IF nMoeda == 1
      @ nLin,000 PSAY "Son Pesos: " + aImp[1]
   Else
      @ nLin,000 PSAY "Son Dolares: " + aImp[1]
   EndIf
   */
	If Left( AllTrim( F1_SERIE ), 1 ) == "A"
       @ nLin,107 PSAY OemToAnsi( "Sub-Total" )
       If Left( AllTrim( F1_SERIE ), 1 ) == "A"
          @ nLin,134 PSAY F1_VALMERC PICTURE "999,999.99"
	   ElseIf Left( AllTrim( F1_SERIE ), 1 ) == "B"
          @ nLin,134 PSAY F1_VALBRUT PICTURE "999,999.99"
	   EndIf
	   nLin:=nLin+3
	   //      @ nLin,000 PSAY( nLine, nPosLey, "N. Grav. I.V.A. 21%", oFont, 100 )
	   //      @ nLin,000 PSAY( nLine, nPosImp, TransForm( F1_BASIMP1, PesqPict( "SD2", "D2_TOTAL" ) ), oFont, 100 )
	   //      nLine +=50
       @ nLin,107 PSAY "I.V.A. 21%"
       @ nLin,134 PSAY F1_VALIMP1 PICTURE "999,999.99"
	   nLin++
	   //      @ nLin,000 PSAY( nLine, nPosLey, "N. Grav. I.V.A. 10,5%", oFont, 100 )
	   //      @ nLin,000 PSAY( nLine, nPosImp, TransForm( F1_BASIMP2, PesqPict( "SD2", "D2_TOTAL" ) ), oFont, 100 )
	   //      nLine +=50
       @ nLin,107 PSAY "I.V.A. 10,5%"
       @ nLin,134 PSAY F1_VALIMP2 PICTURE "999,999.99"
	   nLin++
	   //      @ nLin,000 PSAY( nLine, nPosLey, "Percepcion IIBB", oFont, 100 )
	   //      @ nLin,000 PSAY( nLine, nPosImp, TransForm( F1_VALIMP6, PesqPict( "SD2", "D2_TOTAL" ) ), oFont, 100 )
	   //      nLine +=50
	Else
		nLin:=nLin+5
	EndIf
	//   @ nLin,000 PSAY( nLine, nPosLey, "Total: ", oFont, 100 )
    // @ nLin,107 PSAY OemToAnsi( "Total" )
    @ nLin,115 PSAY F1_VALBRUT PICTURE "999999,999.99"
EndIf

nLin :=64
IF nMoeda == 1
   @ nLin,010 PSAY "Son Pesos: " + aImp[1]
Else
   @ nLin,010 PSAY "Son Dolares: " + aImp[1]
EndIf
//xI := 0
//For xI := 1 TO Len( aImp )
//   IF nMoeda == 1
//         @ nLin,000 PSAY( nLine,1000, If( xI < 2, "Son Pesos: " , "" ) + aImp[xI], oFont, 2500 )
//         nLine += 30
//   ELSE
//         @ nLin,000 PSAY( nLine,1000, If( xI < 2, "Son Dolares: " , "" ) + aImp[xI], oFont, 2500 )
//         nLine += 30
//         @ nLin,000 PSAY( nLine,1000, "Cotizacion : " + TransForm( nCotiz, PesqPict( "SD2", "D2_TOTAL" ) ), oFont, 2500 )
//         nLine += 30
//   ENDIF
//Next

cCode:=If( cEspecie == "NCC  ", Left( SF1->F1_DOC, 4 ) + Right( SF1->F1_DOC, 8 ), Left( SF2->F2_DOC, 4 ) + Right( SF2->F2_DOC, 8 ) )
//         1  2   3   4     5   6   7   8   9   10  11  12  13  14
//MSBAR("EAN13",2.1 ,7,cCode,oPrn,.f.,Nil,Nil,Nil,0.3,.t.,Nil,Nil,.F.)

Return NIL

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
AAdd( aRegs, { cPerg, "01", "Tipo Comprob.:   ", "Tipo Comprob.:   ", "Tipo Comprob.:   ", "mv_ch1", "N", 1 , 00, 0, "C", "", "mv_par01", "Facturas", "Facturas", "Facturas","", "", "N. Debito", "N. Debito", "N. Debito", "", "", "N. Credito", "N. Credito", "N. Credito", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "02", "Serie (A/B):     ", "Serie (A/B):     ", "Serie (A/B):     ", "mv_ch2", "C", 3 , 00, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "03", "Desde Documento: ", "Desde Documento: ", "Desde Documento: ", "mv_ch3", "C", 12, 00, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "04", "Hasta Documento: ", "Hasta Documento: ", "Hasta Documento: ", "mv_ch4", "C", 12, 00, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "05", "Cantidad Copias?:", "Cantidad Copias?:", "Cantidad Copias?:", "mv_ch5", "N", 1 , 00, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","",""} )
aAdd( aRegs, { cPerg, "06", "Desde Fecha?      ","Desde Fecha?      ","Desde Fecha?      ","mv_ch6", "D", 14, 00, 0, "G", "", "mv_par06", "","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
aAdd( aRegs, { cPerg, "07", "Hasta Fecha?      ","Hasta Fecha?      ","Hasta Fecha?      ","mv_ch7", "D", 14, 00, 0, "G", "", "mv_par07", "","","","","","","","","","","","","","","","","","","","","","","","","","","" } )

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
Static Function TraePedido()
Local aAreaSD2 := SD2->( GetArea() ),;
      aArea    := GetArea(),;
      cRet     := Space(6),;
      cRem     := SD2->D2_REMITO,;
      cItem    := SD2->D2_ITEMREM,;
      cCli     := SD2->D2_CLIENTE,;
      cLoja    := SD2->D2_LOJA,;
      cCod     := SD2->D2_COD,;
      cSeri    := SD2->D2_SERIREM

DbSelectArea('SD2')
DbSetOrder(3)
DbSeek( xFilial()+cRem+cSeri+cCli+cLoja+cCod+cItem)

cRet	:= SD2->D2_PEDIDO

RestArea( aAreaSD2 )
RestArea( aArea )
Return( cRet )
