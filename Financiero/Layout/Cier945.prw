#include "rwmake.ch"
#define DETAILBOTTOM 60

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PRINTCHQ  ³ Autor ³   Alberto Badaui      ³ Data ³ 11/11/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cheques (Impresión)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Modif.‡…o ³ Luis :10/01/02 Cuando es por Pantall no carga 1° linea     ³±±
±±³       …o ³       que contiene CHR(27).. por dar error.                ³±±
±±³       …o ³ Luis :07/02/02 Se elimina el Saltp de Linea despues de     ³±±
±±³       …o ³       enviar los CHR() a la impresora por Ch con poco      ³±±
±±³       …o ³       espacio en el encabezado.                            ³±±
±±³       …o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
User Function Cier945()

PRIVATE  _CSOURCE,_CCBTXT,_CCBCONT,_LCOMP,_LFILTRO,_LDIC,;
         _CTITULO,_CDESC1,_CDESC2,_CDESC3,_CTAMANHO,_NLIMITE,;
         _AORDEM,_CFORMULAR,_NCOPIAS,_CDESTINO,_NFORMATO,_NMEDIO,;
         _NLPTPORT,_CFILTRO,_NORDEN,LEND,M_PAG,NLASTKEY,;
         _CNOMEPROG,_CPERG,_CNREL,ARETURN,LPROC,LPRINT,;
         AFIELDS,CFILE,AMESES,NCOMP,NLEN,AIMP,;
         CDBFTMP,CNTXTMP,NLINE,ALINES,CPRINT,NPOS,;
         N,UCOMMAND,NQTYLINES,NELEM,CTEXTO,CALIAS,;
         AREGS,I,J

SET PRINTER TO
SET PRINT OFF
SET DEVICE TO SCREEN

_cSource   := "SE2"
_cCbTxt    := ""
_cCbCont   := ""
_lComp     := .T.
_lFiltro   := .T.
_lDic      := .T.
_lFiltro   := .F.
_cTitulo   := PADC( OEMToAnsi( "Emision de los cheques de " + SM0->M0_NOMECOM ) , 74 )
_cDesc1    := PADC( OEMToAnsi( "Sera solicitado el intervalo para la emision de los" ), 74 )
_cDesc2    := PADC( "cheques generados", 74 )
_cDesc3    := ""
_cTamanho  := "P"
_nLimite   := 132
_aOrdem    := {}
_cFormular := "PreImpreso"      // [1] Reservado para Formulario
_nCopias   := 1                 // [2] Reservado para N§ de Vias
_cDestino  := "Administracion"  // [3] Destinatario
_nFormato  := 1                 // [4] Formato => 1-Comprimido 2-Normal
_nMedio    := 1                 // [5] Midia   => 1-Disco 2-Impressora
_nLPTPort  := 1                 // [6] Porta ou Arquivo 1-LPT1... 4-COM1...
_cFiltro   := ""                // [7] Expressao do Filtro
_nOrden    := 1                 // [8] Ordem a ser selecionada
                                // [9]..[10]..[n] Campos a Processar (se houver)
lEnd       := .F.
m_pag      := 1
nLastKey   := 0
_cNomeProg := "CIER945"        // nome do programa
_cPerg     := PADR( "CIR945", 10 )
_cNRel     := _cNomeProg
aReturn    := { _cFormular ,_nCopias, _cDestino, _nFormato, _nMedio, ;
                _nLPTPort, _cFiltro, _nOrden } //"Zebrado"###"Administracao"

	aDRIVER := READDRIVER()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
VldPerg()
Pergunte( _cPerg, .t. )

IF nLastKey == 27
  RETURN nil
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia control para funcion SETPRINT                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cNRel := SetPrint( _cSource, _cNRel, _cPerg, _cTitulo, _cDesc1, ;
                    _cDesc2, _cDesc3, _lDic, _aOrdem, _lComp, ;
                    _cTamanho, _lFiltro, .f. )

IF nLastKey == 27
  RETURN nil
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicion del Formulario en la Impresora             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault( aReturn, _cSource )

IF nLastKey == 27
   SET PRINTER TO
   SET PRINT OFF
   RETURN
ENDIF

SelectComp()

RETURN nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PRINTCHQ  ³ Autor ³   Alberto Badaui      ³ Data ³ 11/11/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cheques (Impresión)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Modif.‡…o ³ Luis :10/01/02 Cuando es por Pantall no carga 1° linea     ³±±
±±³       …o ³       que contiene CHR(27).. por dar error.                ³±±
±±³       …o ³ Luis :07/02/02 Se elimina el Saltp de Linea despues de     ³±±
±±³       …o ³       enviar los CHR() a la impresora por Ch con poco      ³±±
±±³       …o ³       espacio en el encabezado.                            ³±±
±±³       …o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
Static FUNCTION SelectComp()

   LOCAL lPrint  := .t., ;
         aFields := Array( 0 ), ;
         aMeses  := { "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", ;
                      "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", ;
                      "Diciembre" }, ;
         nComp   := 0, ;
         aImp    := Array( 0 ), ;
         _cImp := space( 0 )

   PRIVATE lProc   := .f.

   AAdd( aFields, { "BANCO",   "C",  3, 0 } )
   AAdd( aFields, { "AGENCIA", "C",  5, 0 } )
   AAdd( aFields, { "CUENTA",  "C", 10, 0 } )
   AAdd( aFields, { "NUMERO",  "C", 12, 0 } )
   AAdd( aFields, { "FECHA",   "D",  8, 0 } )
   AAdd( aFields, { "VENC",    "D",  8, 0 } )
   AAdd( aFields, { "TIPO",    "C",  1, 0 } )
   AAdd( aFields, { "VALOR",   "N", 15, 2 } )
   AAdd( aFields, { "DIAEMI",  "C",  2, 0 } )
   AAdd( aFields, { "MESEMI",  "C", 10, 0 } )
   AAdd( aFields, { "ANOEMI",  "C",  4, 0 } )
   AAdd( aFields, { "DIAVTO",  "C",  2, 0 } )
   AAdd( aFields, { "MESVTO",  "C", 10, 0 } )
   AAdd( aFields, { "ANOVTO",  "C",  4, 0 } )
   AAdd( aFields, { "ORDEN",   "C", 70, 0 } )
   AAdd( aFields, { "IMPORT1", "C", 70, 0 } )
   AAdd( aFields, { "IMPORT2", "C", 70, 0 } )

   cDbfTmp := CriaTrab( aFields, .t. ) + GetDBExtension()
   cNtxTmp := CriaTrab( , .f. ) + OrdBagExt()

   IF !Empty( Select( "TRB" ) )
      DbSelectArea( "TRB" )
      DbCloseArea()
   ENDIF

   FErase( cNtxTmp )

   DbUseArea( .T., __cRDDNTTS, cDbfTmp, "TRB", .f., .f. )
   DbCreateIndex( cNtxTmp, "BANCO+AGENCIA+CUENTA+NUMERO", { || BANCO+AGENCIA+CUENTA+NUMERO }, .f. )

   DbSelectArea( "SA2" )
   DbSetOrder( 1 )
   cFile:=''
   DbSelectArea( "SA6" )
   DbSetOrder( 1 )
   IF DbSeek( xFilial( "SA6" ) + mv_par01 + mv_par02 + mv_par03 )
      IF mv_par04 == 2
         cFile := AllTrim( A6_FORM1 )
      ELSE
         cFile := AllTrim( A6_FORM2 )
      ENDIF
   ELSe
     alert("No se encontro el banco selecionado")
     return
   ENDIF

   IF !File( cFile )
      MsgBox( "No se enconto la plantilla correspondiente al Banco seleccionado","STOP" )
      RETURN
   ENDIF

   DbSelectArea( "SE2" )
   DbSetOrder( 17 )

   //DbSeek( xFilial( "SE2" ) + "CH " + mv_par01 + mv_par02 + mv_par03 + mv_par05 )
   DbSeek( xFilial( "SE2" ) + "CH " + mv_par01 + mv_par02 + mv_par03 )

   WHILE !EoF() .AND. ( xFilial( "SE2" ) + E2_TIPO + E2_BCOCHQ + E2_AGECHQ + E2_CTACHQ ) == ;
      ( xFilial( "SE2" ) + "CH " + mv_par01 + mv_par02 + mv_par03 ) .AND. lPrint
      /*
      IF SE2->E2_MSEMP <> cEmpAnt
         DbSelectArea( "SE2" )
         DbSkip()
         Loop
      ENDIF
      */
      IF SE2->E2_IMPCHEQ = "S"
         DbSelectArea( "SE2" )
         DbSkip()
         Loop
      ENDIF

      IF E2_TIPO == "CH "

         If mv_par04 == 1
            If SE2->E2_EMISSAO == SE2->E2_VENCTO
               DbSelectArea( "SE2" )
               DbSkip()
               Loop
            EndIf
         EndIf

         If mv_par04 == 2
            If SE2->E2_EMISSAO != SE2->E2_VENCTO
               DbSelectArea( "SE2" )
               DbSkip()
               Loop
            EndIf
         EndIf

         If E2_NUM > mv_par06 .or. E2_NUM < mv_par05
            DbSelectArea( "SE2" )
            DbSkip()
            Loop
         EndIf

         DbSelectArea( "SA2" )
         DbSeek( xFilial( "SA2" ) + SE2->E2_FORNECE + SE2->E2_LOJA )

         DbSelectArea( "SE2" )

         _cImp := Extenso( E2_VALOR, , 1 )
//         aImp := U_NUMTOSTR( E2_VALOR, 70 )

         DbSelectArea( "TRB" )
         RecLock( "TRB", .T. )
         Replace BANCO   With SE2->E2_BCOCHQ
         Replace AGENCIA With SE2->E2_AGECHQ
         Replace CUENTA  With SE2->E2_CTACHQ
         Replace NUMERO  With SE2->E2_NUM
         Replace FECHA   With SE2->E2_EMISSAO
         Replace VENC    With SE2->E2_VENCTO
         Replace TIPO    With AllTrim( Str( mv_par04, 1 ) )
         Replace VALOR   With SE2->E2_VALOR

         //If !( SA2->A2_COD $ GetNewPar( 'MV_ARCHFOR', '' ) )
            //Replace ORDEN   With If(!NoALaOrden(),AllTrim(SA2->A2_ORDCHQ),AllTrim(SA2->A2_ORDCHQ) +" - "+"NO A LA ORDEN")
         //Else
            Replace ORDEN   With If(!NoALaOrden(),AllTrim(PegaOrden())   ,AllTrim(PegaOrden())    +" - "+"NO A LA ORDEN")
         //EndIf

         Replace DIAEMI  With Str( Day( SE2->E2_EMISSAO ), 2 )
         Replace MESEMI  With aMeses[Month( SE2->E2_EMISSAO )]
         Replace ANOEMI  With Str( Year( SE2->E2_EMISSAO ), 4 )
         Replace DIAVTO  With Str( Day( SE2->E2_VENCTO ), 2 )
         Replace MESVTO  With aMeses[Month( SE2->E2_VENCTO )]
         Replace ANOVTO  With Str( Year( SE2->E2_VENCTO ), 4 )
         Replace IMPORT1 With substr( _cImp, 1, 70 ) + replicate("-",(70-len(_cImp)))
//         Replace IMPORT1 With aImp[1] + replicate("-",(70-len(aImp[1])))
         Replace IMPORT2 With If( Len( _cImp ) > 70, substr( _cImp , 71 ) +replicate("-",(70-len( _cImp ))), replicate("-",70 ))
//         Replace IMPORT2 With If( Len( aImp ) > 1, aImp[2]+replicate("-",(70-len(aImp[2]))), replicate("-",70 ))

         IF TIPO == "0"
            lPrint := .f.
         ENDIF
         MsUnLock()

      ENDIF

      //Marca el cheque para no imprimirlo nuevamente
      IF SE2->E2_IMPCHEQ <> "S"
         Reclock("SE2",.F.)
         //   Replace SE2->E2_IMPCHEQ with "S"
         SE2->(MsUnlock())
      ENDIF

      DbSelectArea( "SE2" )
      DbSkip()

   ENDDO

   IF !lPrint
      MsgBox( "Existe un cheque que NO es del tipo informado por parametro","STOP" )
      TRB->( DbCloseArea() )
      FErase( cDbfTmp )
      FErase( cNtxTmp )
      RETURN
   EndIf
   IF Empty( TRB->( RecCount() ) )
      MsgBox( "No se encontro el cheque informado en parametro: Desde Cheque","STOP" )
      TRB->( DbCloseArea() )
      FErase( cDbfTmp )
      FErase( cNtxTmp )
      RETURN
   ENDIF

   DbSelectArea( "TRB" )
   DbGoTop()

   nComp := Val( NUMERO )

   WHILE !EoF() .AND. lPrint

      IF Val( NUMERO ) != nComp
         lPrint := .f.
      ELSE
         nComp++
         DbSkip()
      ENDIF

   ENDDO

   IF !lPrint
      MsgBox( "Existe un salto en la numeracion de los cheques seleccionados","STOP" )
      TRB->( DbCloseArea() )
      FErase( cDbfTmp )
      FErase( cNtxTmp )
      RETURN
   ELSE
      RptStatus( { || PrintCheques() } )
   ENDIF

   SET PRINTER TO

   IF aReturn[5] == 1 .AND. lProc
      OurSpool( _cNRel )
   ENDIF
   Ms_Flush()

   SET PRINTER TO
   SET PRINT OFF
   SET DEVICE TO SCREEN

   TRB->( DbCloseArea() )
   FErase( cDbfTmp )
   FErase( cNtxTmp )

RETURN lProc

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PRINTCHQ  ³ Autor ³   Alberto Badaui      ³ Data ³ 11/11/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cheques (Impresión)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Modif.‡…o ³ Luis :10/01/02 Cuando es por Pantall no carga 1° linea     ³±±
±±³       …o ³       que contiene CHR(27).. por dar error.                ³±±
±±³       …o ³ Luis :07/02/02 Se elimina el Saltp de Linea despues de     ³±±
±±³       …o ³       enviar los CHR() a la impresora por Ch con poco      ³±±
±±³       …o ³       espacio en el encabezado.                            ³±±
±±³       …o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
Static FUNCTION PrintCheques()
Private lFirst := .T.
Private nVeces := 0

SetRegua( RecCount() )
DbGoTop()
DbEval( { || PrintDoc(), IncRegua() } )

lProc := .t.

RETURN nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PRINTCHQ  ³ Autor ³   Alberto Badaui      ³ Data ³ 11/11/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cheques (Impresión)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Modif.‡…o ³ Luis :10/01/02 Cuando es por Pantall no carga 1° linea     ³±±
±±³       …o ³       que contiene CHR(27).. por dar error.                ³±±
±±³       …o ³ Luis :07/02/02 Se elimina el Saltp de Linea despues de     ³±±
±±³       …o ³       enviar los CHR() a la impresora por Ch con poco      ³±±
±±³       …o ³       espacio en el encabezado.                            ³±±
±±³       …o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
Static FUNCTION PrintDoc()

LOCAL aLines, ;
      cPrint   := Space( 0 ), ;
      nPos     := 0, ;
      n        := 0

lTercero := .T.
aLines   := FToA()

SetPrc( 0, 0 )
nLine := iif(lfirst,0,8) //Seryo 20120717
//nLine := 0

IF Empty( Len( aLines ) )
   MsgBox( "Error en la plantilla","STOP" )
   RETURN
ENDIF

nVeces++

nsuma := 0

FOR n := 1 TO Len( aLines )

   cPrint :=  Space( 0 )

   WHILE !Empty( aLines[n] )


      nPos := At( "[", aLines[n] )

      IF !Empty( nPos )
         cPrint    := cPrint + SubStr( aLines[n], 1, nPos - 1 )
         aLines[n] := SubStr( aLines[n], nPos + 1 )
         nPos      := At( "]", aLines[n] )
         uCommand  := "{ ||" + SubStr( aLines[n], 1, nPos - 1 ) + " }"
         aLines[n] := SubStr( aLines[n], nPos + 1 )
         uCommand  := Eval( &uCommand )
         cPrint    := cPrint + uCommand
      ELSE
         cPrint    := cPrint + aLines[n]
         aLines[n] := Space( 1 )
      ENDIF

   ENDDO

/*
   If lFirst .and. ;
      Alltrim( Upper( cFile ) ) == 'CHDIFE.TXT' .and. ;
      Int( Val( TRB->NUMERO ) / 2 ) == ( Val( TRB->NUMERO ) / 2 )

      @ nLine, 00 PSAY cPrint
      nLine++
      @ nLine, 00 PSAY cPrint
      nLine++
   EndIf
*/

   lFirst   := .F.

   @ nLine, 00 PSAY cPrint
/* Seryo 20120717
   nLine++
*/
   nLine:= nline +1 //Seryo 20120717

NEXT
   //nLine:= nline +8 //Seryo 20120717
RETURN nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PRINTCHQ  ³ Autor ³   Alberto Badaui      ³ Data ³ 11/11/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cheques (Impresión)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Modif.‡…o ³ Luis :10/01/02 Cuando es por Pantall no carga 1° linea     ³±±
±±³       …o ³       que contiene CHR(27).. por dar error.                ³±±
±±³       …o ³ Luis :07/02/02 Se elimina el Saltp de Linea despues de     ³±±
±±³       …o ³       enviar los CHR() a la impresora por Ch con poco      ³±±
±±³       …o ³       espacio en el encabezado.                            ³±±
±±³       …o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
Static FUNCTION FToA()
LOCAL nQtyLines := 0, ;
      nElem     := 0, ;
      nLen      := 254, ;
      cTexto    := Space( 0 ), ;
      aLines    := Array( 0 )

      cTexto    := MemoRead( cFile )
      nQtyLines := MLCount( cTexto, nLen )

IF Empty( nQtyLines )
   MsgBox( "El formato de la plantilla no es correcto","STOP" )
   RETURN
ENDIF

FOR nElem := 1 TO nQtyLines
   AAdd( aLines, RTrim( MemoLine( cTexto, nLen, nElem ) ) )
NEXT

RETURN aLines

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PRINTCHQ  ³ Autor ³   Alberto Badaui      ³ Data ³ 11/11/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cheques (Impresión)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Modif.‡…o ³ Luis :10/01/02 Cuando es por Pantall no carga 1° linea     ³±±
±±³       …o ³       que contiene CHR(27).. por dar error.                ³±±
±±³       …o ³ Luis :07/02/02 Se elimina el Saltp de Linea despues de     ³±±
±±³       …o ³       enviar los CHR() a la impresora por Ch con poco      ³±±
±±³       …o ³       espacio en el encabezado.                            ³±±
±±³       …o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
Static FUNCTION VldPerg()

   cAlias := Alias()
   aRegs  := Array( 0 )
   i      := 0
   j      := 0

   DbSelectArea( "SX1" )
   DbSetOrder( 1 )

   AAdd( aRegs, { _cPerg, "01", "Banco               ", "Banco               ", "Banco               ", "mv_ch1", "C", 03, 0, 1, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA6"  ,"","" } )
   AAdd( aRegs, { _cPerg, "02", "Agencia             ", "Agencia             ", "Agencia             ", "mv_ch2", "C", 05, 0, 1, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""  ,"","" } )
   AAdd( aRegs, { _cPerg, "03", "No. de Cuenta       ", "No. de Cuenta       ", "No. de Cuenta       ", "mv_ch3", "C", 10, 0, 1, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""  ,"","" } )
   AAdd( aRegs, { _cPerg, "04", "Tipo de Cheque      ", "Tipo de Cheque      ", "Tipo de Cheque      ", "mv_ch4", "N", 01, 0, 1, "C", "", "mv_par04", "Pago Diferido", "Pago Diferido", "Pago Diferido", "", "", "Normal", "Normal", "Normal", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""  ,"","" } )
   AAdd( aRegs, { _cPerg, "05", "Desde Cheque        ", "Desde Cheque        ", "Desde Cheque        ", "mv_ch5", "C", 12, 0, 1, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""  ,"","" } )
   AAdd( aRegs, { _cPerg, "06", "Hasta Cheque        ", "Hasta Cheque        ", "Hasta Cheque        ", "mv_ch6", "C", 12, 0, 1, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""  ,"","" } )

   FOR i := 1 TO Len( aRegs )
      IF !DbSeek( _cPerg + aRegs[i,2] )
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



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PRINTCHQ  ³ Autor ³   Alberto Badaui      ³ Data ³ 11/11/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cheques (Impresión)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Modif.‡…o ³ Luis :10/01/02 Cuando es por Pantall no carga 1° linea     ³±±
±±³       …o ³       que contiene CHR(27).. por dar error.                ³±±
±±³       …o ³ Luis :07/02/02 Se elimina el Saltp de Linea despues de     ³±±
±±³       …o ³       enviar los CHR() a la impresora por Ch con poco      ³±±
±±³       …o ³       espacio en el encabezado.                            ³±±
±±³       …o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
Static Function PegaOrden( )

Local cRet  := Space( 50 )
//CRET := SA2->A2_MCCHNO
CRET := SA2->A2_NOME
@ 089,127 To 232,566 Dialog oDlg Title OemToAnsi("Impresión de Cheques")
@ 005,005 To 55,205 Title OemToAnsi(" Datos del Cheque ")
@ 020,025 Say OemToAnsi("Cheque Nro: " + TRB->NUMERO + "  Valor: " + Alltrim( Str( TRB->VALOR ) ) ) Size 175,8
@ 030,015 Say OemToAnsi(SA2->A2_NOME)
@ 040,015 Say OemToAnsi("A la Orden") Size 0030,008
@ 040,050 Get cRet Size 150,010  Valid !Empty( cRet )
@ 057,170 BmpButton Type 1 Action If( !Empty( cRet ), oDlg:End(), MsgStop( 'Faltan Datos Requeridos!', 'Confirme' ) )
Activate Dialog oDlg Centered


Return( cRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PRINTCHQ  ³ Autor ³   Alberto Badaui      ³ Data ³ 11/11/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cheques (Impresión)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Modif.‡…o ³ Luis :10/01/02 Cuando es por Pantall no carga 1° linea     ³±±
±±³       …o ³       que contiene CHR(27).. por dar error.                ³±±
±±³       …o ³ Luis :07/02/02 Se elimina el Saltp de Linea despues de     ³±±
±±³       …o ³       enviar los CHR() a la impresora por Ch con poco      ³±±
±±³       …o ³       espacio en el encabezado.                            ³±±
±±³       …o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
Static Function NoALaOrden( )

lNALO := .T.

@ 089,127 To 232,400 Dialog oDlg Title OemToAnsi("Forma de liberacion del cheque")
@ 005,005 To 55,130 Title OemToAnsi(" Datos del Cheque ")
@ 020,015 Say OemToAnsi("Cheque Nro: " + TRB->NUMERO + "  Valor: " + Alltrim( Str( TRB->VALOR ) )  ) Size 175,8
@ 030,015 Say OemToAnsi(SA2->A2_NOME)
@ 040,050 CheckBox OemToAnsi("NO A LA ORDEN") Var lNALO
@ 057,060 BmpButton Type 1 Action oDlg:End()
Activate Dialog oDlg Centered
Return( lNALO )



   FOR i := 1 TO Len( aRegs )

      IF !DbSeek( _cPerg + aRegs[i,2] )

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
