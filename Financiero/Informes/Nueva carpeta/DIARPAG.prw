#include "rwmake.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF
#DEFINE BOTTOMPAGE 42



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DIARPAG  ³ Autor ³ MS	   				³ Data ³11/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Diario Cobranza		 				                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DIARPAG(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DIARPAG()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaración de variables utilizadas en el programa a través de la función ³
//³ SetPrvt, va a crear sólo las variables definidas por el usuario,          ³
//³ identificando las variables públicas del sistema utilizadas en el código  ³
//³ Incluido por el asistente de conversión del AP5 IDE                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CSOURCE,_CCBTXT,_CCBCONT,_LCOMP,_LFILTRO,_LDIC")
SetPrvt("_CTITULO,_CCABEC1,_CCABEC2,_CDESC1,_CDESC2,_CDESC3")
SetPrvt("_CTAMANHO,_NLIMITE,_AORDEM,_CFORMULAR,_NCOPIAS,_CDESTINO")
SetPrvt("_NFORMATO,_NMEDIO,_NLPTPORT,_CFILTRO,_NORDEN,LEND")
SetPrvt("M_PAG,NLASTKEY,_CNOMEPROG,_CPERG,_CNREL,ARETURN")
SetPrvt("ADRIVER,LPROC,NLINE,CORDPAGO,DFECHA,CCODPROV")
SetPrvt("NRECNO,NTOTNET,NTOTIVA,NTOTGAN,NTOTIB,NTOTGRA")
SetPrvt("NNETO,NRETGAN,NRETIVA,NRETIB,NTOTAL,AFIELDS")
SetPrvt("CDBFTMP,CNTXTMP,LLASTPAGE,CALIAS,")

Private lNaturez := .F.

SX3->( DbSetOrder(2) )
lNaturez := SX3->( DbSeek( 'EK_NATUREZ' ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET PRINTER TO
SET PRINT OFF
SET DEVICE TO SCREEN

_cSource   := "SEK"
_cCbTxt    := ""
_cCbCont   := ""
_lComp     := .T. // Habilita/Deshabilita o Formato Comprimido/Expandido
_lFiltro   := .T. // Habilita/Deshabilita o Filtro
_lDic      := .T. // Habilita/Deshabilita Dicionario
_lFiltro   := .F.
_cTitulo   := "Diario de Pagos"
_cCabec1   := Space( 0 )
_cCabec2   := Space( 0 )
_cDesc1    := Space( 0 )
_cDesc2    := Space( 0 )
_cDesc3    := Space( 0 )
_cTamanho  := "G"               // P/M/G
_nLimite   := 220               // 80/132/220
_aOrdem    := {}                // Ordem do Relatorio
_cFormular := "PreImpreso"      // [1] Reservado para Formulario
_nCopias   := 1                 // [2] Reservado para N§ de Vias
_cDestino  := "Administracion"  // [3] Destinatario
_nFormato  := 1                 // [4] Formato => 1-Comprimido 2-Normal
_nMedio    := 1                 // [5] Midia   => 1-Disco 2-Impressora
_nLPTPort  := 1                 // [6] Porta ou Arquivo 1-LPT1... 4-COM1...
_cFiltro   := ""                // [7] Expressao do Filtro
_nOrden    := 1                 // [8] Ordem a ser SEKecionada
// [9]..[10]..[n] Campos a Processar (se houver)
lEnd       := .T.// Controle de cancelamento do relatorio
m_pag      := 1
nLastKey   := 0  // Controla o cancelamento da SetPrint e SetDefault
_cNomeProg := "DIARIOPAGO"        // nome do programa
_cPerg     := PADR( "DIARIOPAGO", 10 )
_cNRel     := _cNomeProg

aReturn    := { _cFormular ,_nCopias, _cDestino, _nFormato, _nMedio, ;
_nLPTPort, _cFiltro, _nOrden } //"Zebrado"###"Administracao"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas SEKecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
VldPerg( _cPerg )

IF Pergunte( _cPerg, .T. )               // Pergunta no SX1
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia control para funcion SETPRINT                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	
	_cNRel := SetPrint( _cSource, _cNRel, _cPerg, _cTitulo, _cDesc1, ;
	_cDesc2, _cDesc3, _lDic, _aOrdem, _lComp, ;
	_cTamanho, _lFiltro, .f. )
	
	IF nLastKey == 27
		SET PRINTER TO
		SET PRINT OFF
		RETURN
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
	
	RptStatus( {|| SelectComp() } )
	
ENDIF

RETURN

Static FUNCTION SelectComp()

aDriver:= ReadDriver()
lProc  := .f.

PrintComp()

SET PRINTER TO

IF aReturn[5] == 1
	OurSpool(_cNRel)
ENDIF

Ms_Flush()

SET PRINTER TO
SET PRINT OFF
SET DEVICE TO SCREEN

IF !lProc
	MsgBox( "No se encontraron comprobantes segun los parametros ingresados", "ALERT" )
	RETURN .f.
ENDIF

RETURN NIL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Determina los límites de impresión                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static FUNCTION PrintComp()

nLine    := BOTTOMPAGE
cOrdPago := Space( 0 )
dFecha   := CToD( "" )
cCodProv := Space( 0 )
nRecNo   := 0

nTotCHQ  := 0
nTotCHQt  := 0
nTotEFE  := 0
nTotTRF  := 0
nTotIVA  := 0
nTotGAN  := 0
nTotIB   := 0
nTotSUS  := 0
nTotGRA  := 0

nCHQ     := 0
nEFE     := 0
nTRF     := 0
nRETGAN  := 0
nRETIVA  := 0
nRETIB   := 0
nRETSUS  := 0
nTOTAL   := 0
// DESDE ACA AGREGO SERYO - 20041012
IF mv_par10 == 2
	__lCanje := .f.
ELSE
	__lCanje  := .t.
ENDIF
__lOP := .t.
__cNumOP := Space( 0 )
__cOPBad := Space( 0 )
__nRecno := 0
// HASTA ACA AGREGO SERYO - 20041012

aFields  := Array( 0 )

AAdd( aFields, { "ORDPAGO",  "C",  12, 0 } )
AAdd( aFields, { "TIPODOC",  "C",  2, 0 } )
AAdd( aFields, { "TIPO"   ,  "C",  3, 0 } )
AAdd( aFields, { "NRODOC",   "C", 12, 0 } )
AAdd( aFields, { "FECHA",    "D",  2, 0 } )
AAdd( aFields, { "CODPROV",  "C",  11, 0 } )
AAdd( aFields, { "VALOR",    "N", 10, 2 } )
AAdd( aFields, { "ANULADO",  "C",  1, 0 } )
AAdd( aFields, { "MODELO",   "C", 10, 0 } )

 cDbfTmp := CriaTrab( aFields, .t. ) //+ ".DTC"
 cNtxTmp := CriaTrab( , .f. ) + OrdBagExt()

IF !Empty( Select( "TRB" ) )
	DbSelectArea( "TRB" )
	DbCloseArea()
ENDIF

FErase( cNtxTmp )

DbUseArea( .T.,, cDbfTmp, "TRB", .f., .f. )
DbCreateIndex( cNtxTmp, "ORDPAGO+TIPODOC+NRODOC", { || ORDPAGO+TIPODOC+NRODOC }, .f. )

DbSelectArea( "SA2" )
DbSetOrder( 1 )

DbSelectArea( "SEK" )
DbSetOrder( 3 )
DbSeek( xFilial( "SEK" ) + DToS( mv_par01 ), .t. )

WHILE !EoF() .AND. EK_FILIAL == xFilial() .AND. EK_DTDIGIT <= mv_par02
	
	// DESDE ACA AGREGO SERYO - 20041012
	__lOP := .T.
	// HASTA ACA AGREGO SERYO - 20041012
	
	If lNaturez
		IF SEK->EK_NATUREZ < mv_par05 .OR. SEK->EK_NATUREZ > mv_par06
			DbSkip()
			Loop
		Endif
	EndIf
	
	If Round( Val(SEK->EK_MOEDA), 0 ) <> Round( mv_par07, 0 ) .and. mv_par08 == 1
		DbSkip()
		Loop
	EndIf
	
	// DESDE ACA AGREGO SERYO - 20041012
	
	IF !( __lCanje )
		__cNumOP := EK_ORDPAGO
		__nRecno := SEK->( RECNO() )
		
		WHILE !EOF() .AND. __cNumOP == EK_ORDPAGO
			IF ALLTRIM( EK_TIPODOC ) == 'TB' .AND. ALLTRIM( EK_TIPO ) == 'CH'
				__lOP := .f.
				__cOPBad := EK_ORDPAGO
			ENDIF
			DbSkip()
		ENDDO
		
		DbGoTo( __nRecno )
		
		IF !( __lOP ) .or. __cOPBad == EK_ORDPAGO
			DbSkip()
			Loop
		ENDIF
		
	ENDIF
	
	// HASTA ACA AGREGO SERYO - 20041012
	
	DbSelectArea( "TRB" )
	
	IF !DbSeek( SEK->EK_ORDPAGO )
		
		DbSelectArea( "SEK" )
		
		cOrdPago := EK_ORDPAGO
		cmodelo  := If( lNaturez, EK_NATUREZ, Space(10) )
		dFecha   := EK_DTDIGIT
		nRecNo   := RecNo()
		
		DbSetOrder( 1 )
		DbSeek( xFilial( "SEK" ) + cOrdPago )
		
		WHILE !EoF() .AND. EK_FILIAL == xFilial( "SEK" ) .AND. ;
			EK_ORDPAGO == cOrdPago
			
			IF EK_TIPODOC $ "EF-CP-CT-TF-RG"
				TRB->( DbAppend() )
				TRB->ORDPAGO  := SEK->EK_ORDPAGO
				TRB->TIPODOC  := If( SEK->EK_TIPODOC != 'RG', SEK->EK_TIPODOC, Left( SEK->EK_TIPO, 2 ) )
				TRB->TIPO     := SEK->EK_TIPO
				TRB->NRODOC   := SEK->EK_NUM
				TRB->FECHA    := dFecha
				TRB->CODPROV  := SEK->EK_FORNECE
				TRB->VALOR    := xValor( EK_VALOR, SEK->EK_DTDIGIT, Val( EK_MOEDA ), Round( EK_VLMOED1 / EK_VALOR, 4 ) )
				TRB->ANULADO  := IIF(SEK->EK_CANCEL,"S"," ")
				TRB->MODELO   := IIF(lNaturez, SEK->EK_NATUREZ, Space(10) )
			ENDIF
			
			DbSkip()
			
		ENDDO
		
		DbSetOrder( 3 )
		DbGoTo( nRecNo )
		
	ELSE
		
		DbSelectArea( "SEK" )
		
	ENDIF
	
	DbSkip()
	
ENDDO

DbSelectArea( "TRB" )
DbClearIndex()
FErase( cNtxTmp )
DbCreateIndex( cNtxTmp, "ORDPAGO", { || ORDPAGO }, .f. )
DbGoTop()

nTope:=Getnewpar("MV_TOPPAGO",200)

nORDPAGO := Val(ORDPAGO)
cORDPAGO := ORDPAGO
DbSkip()
WHILE !EoF()
	If ORDPAGO == cORDPAGO
		DbSkip()
		Loop
	EndIf
	If Val(ORDPAGO) == ( nORDPAGO + 1 )
		nORDPAGO := Val(ORDPAGO)
		cORDPAGO := ORDPAGO
	Else
		nDesde := nORDPAGO+1
		nHasta := Val(ORDPAGO) - 1
		If ( nHasta - nDesde ) > nTope
			nORDPAGO := Val(ORDPAGO)
			cORDPAGO := ORDPAGO
			DbSkip()
			Loop
		EndIf
		nRecNo:=recno()
		dFecha  := FECHA
		Reclock("TRB",.T.)
		TRB->ORDPAGO := StrZERO(nDesde,6)
		TRB->CODPROV := StrZERO(nHasta,6)
		TRB->FECHA   := dFecha
		TRB->ANULADO := "X"
		MsUnLock()
		DbGoTo( nRecNo )
		nORDPAGO := Val(ORDPAGO)
		cORDPAGO := ORDPAGO
	EndIf
	DbSkip()
Enddo

DbClearIndex()
FErase( cNtxTmp )
SetRegua( RecCount() + 1 )
DbGoTop()

WHILE !EoF()
	cOrdPago  := ORDPAGO
	dFecha    := FECHA
	cCodProv  := CODPROV
	cModelo   := MODELO
	cAnulado  := ANULADO
	aNroRet :={ ".....", ".....", ".....", "....." }
	
	nCHQ    := 0
	nCHQT    := 0
	nEFE    := 0
	nTRF    := 0
	nNETO   := 0
	nRETGAN := 0
	nRETIVA := 0
	nRETIB  := 0
	nRETSUS := 0
	nTOTAL  := 0
	
	WHILE !EoF() .AND. ORDPAGO == cOrdPago
		
		IF ANULADO == " " .or. ANULADO == "S"
			IF TIPODOC $ "CP-CT"
				IF TIPO == "EF "
					nEFE    := nEFE + VALOR
				ELSEIF TIPO == "TF "
					nTRF    := nTRF + VALOR
				ElseIF ALLTRIM(TIPODOC) =="CP"
					nCHQ    := nCHQ + VALOR
					ELSEIF ALLTRIM(TIPODOC) =="CT"
					nCHQt    := nCHQt + VALOR
					
				Endif
			ELSEIF TIPODOC $ "GN"
				nRETGAN := nRETGAN + VALOR
				aNroRet [1]:= NRODOC
			ELSEIF TIPODOC $ "IV"
				nRETIVA := nRETIVA + VALOR
				aNroRet [2]:= NRODOC
			ELSEIF TIPODOC $ "IB"
				nRETIB  := nRETIB + VALOR
				aNroRet [3]:= NRODOC
			ELSEIF TIPODOC $ "SU-SL"
				nRETSUS := nRETSUS + VALOR
				aNroRet [4]:= NRODOC
			ELSEIF !TIPODOC $ "TB-PA"
				MsgStop( "La Orden de Pago: " + cOrdPago + " tiene problemas", "ERROR" )
			ENDIF
		ENDIF
		
		DbSkip()
		IncRegua()
		
	ENDDO
	If ( mv_par04 == 1 .OR. ( mv_par04 == 2 .AND. cANULADO == " " ) .OR. ( mv_par04 == 3 .AND. cANULADO == "S" ) ;
		.OR. ( mv_par04 == 4 .AND. cANULADO == "X" ) )
		  if cANULADO<>'S'
		nTOTAL  := nCHQ + nEFE + nTRF + nRETGAN + nRETIVA + nRETIB + nRETSUS
		
		nTotCHQ := nTotCHQ + nCHQ
		nTotCHQt := nTotCHQt + nCHQt
		nTotEFE := nTotEFE + nEFE
		nTotTRF := nTotTRF + nTRF
		nTotGAN := nTotGAN + nRETGAN
		nTotIVA := nTotIVA + nRETIVA
		nTotIB  := nTotIB  + nRETIB
		nTotSUS := nTotSUS + nRETSUS
		nTotGRA := nTotGRA + nTOTAL
		endif
		DbSelectArea( "SA2" )
		DbSeek( xFilial( "SA2") + cCodProv )
		
		IF mv_par03 < 2
			PrintHead()
			PrintItem()
		ENDIF
	EndIf
	
	DbSelectArea( "TRB" )
	
ENDDO

lLastPage := .t.
PrintHead()
PrintTotal()

TRB->( DbCloseArea() )
FErase( cDbfTmp )
FErase( cNtxTmp )

RETURN NIL

Static FUNCTION PrintHead()

IF !lProc
	lProc := .t.
ENDIF

IF nLine >= BOTTOMPAGE
	
	_cCabec1 := "Numero                                                                                                                                 Retencion Retencion   Retencion  Retencion   Total    Nros Comprob Ret "
	_cCabec2 := "Comprobante   Fecha    Cod.            Razon Social            Prov        C.U.I.T.        CH. PROPIOS CH.TERC   Efectivo    Transf.   Ganancias   I.V.A.    Ing. Brut.    SUSS    Comprob.  Ganancias/IVA/IIBB/SUSS"
//	_cCabec2 := "Comprobante   Fecha    Cod.   Nombre o Razon Social   Prov     Modelo     C.U.I.T.         CH. PROPIOS CH.TERC   Efectivo    Transf.   Ganancias   I.V.A.    Ing. Brut.    Comprob.  Gananc/Iva/Ib"
	
	Cabec( _cTitulo + ' - ' + Capital(GetMv('MV_MOEDA'+Str(mv_par07,1,0)))+ " Desde "+DTOC(MV_PAR01);
	+ " Hasta " +DTOC (MV_PAR02), _cCabec1, _Ccabec2, _cNomeProg, _cTamanho, 18 )
	
	nLine := 10
	
ENDIF

RETURN NIL

Static FUNCTION PrintItem()

If cAnulado != "X"
	@ nLine,  00 PSAY cOrdPago
	@ nLine,  14 PSAY dFecha
	@ nLine,  23 PSAY cCodProv
	@ nLine,  35 PSAY substr( SA2->A2_NOME, 1, 29 )
	@ nLine,  64 PSAY SA2->A2_EST
	//@ nLine,  64 PSAY cmodelo                  // 61
	@ nLine,  75 PSAY SA2->A2_CGC              // 72
EndIf
IF cAnulado == "S"
	@ nLine,  95 PSAY "*** ANULADO ***"
	@ nLine, 190 PSAY alltrim(aNroRet[1])+"/"+alltrim(aNroRet[2])+"/"+alltrim(aNroRet[3])+"/"+alltrim(aNroRet[4])
ELSEIf cAnulado == "X"
	@ nLine,  00 PSAY "Desde O.Pago: " + cOrdPago
	@ nLine,  40 PSAY "Hasta O.Pago: " + cCodProv
	@ nLine,  86 PSAY "** SALTEADO **"
Else
	@ nLine,  89 PSAY nCHQ         PICTURE "9999999.99"
	@ nLine, 100 PSAY nCHQt        PICTURE "9999999.99"	
	@ nLine, 111 PSAY nEFE         PICTURE "9999999.99"
	@ nLine, 122 PSAY nTRF         PICTURE "9999999.99"
	@ nLine, 133 PSAY nRETGAN      PICTURE "9999999.99"
	@ nLine, 144 PSAY nRETIVA      PICTURE "9999999.99" 
	@ nLine, 155 PSAY nRETIB       PICTURE "9999999.99" 
	@ nLine, 166 PSAY nRETSUS      PICTURE "9999999.99" 
	@ nLine, 177 PSAY nTOTAL       PICTURE "9999999.99" 
	@ nLine, 190 PSAY right(alltrim(aNroRet[1]),5)+"/"+right(alltrim(aNroRet[2]),5)+"/"+right(alltrim(aNroRet[3]),5)+"/"+right(alltrim(aNroRet[4]),5)
ENDIF
nLine := nLine + 1

RETURN NIL

Static FUNCTION PrintTotal()

@ nLine,  00 PSAY Replicate( '-', 220 )
nLine := nLine + 1

@ nLine,  00 PSAY "TOTALES GENERALES:"
@ nLine,  89 PSAY nTotCHQ PICTURE "9999999.99"  
@ nLine, 100 PSAY nTotCHQT PICTURE "9999999.99"  
@ nLine, 111 PSAY nTotEFE PICTURE "9999999.99"  
@ nLine, 122 PSAY nTotTRF PICTURE "9999999.99"  
@ nLine, 133 PSAY nTotGAN PICTURE "9999999.99"  
@ nLine, 144 PSAY nTotIVA PICTURE "9999999.99"  
@ nLine, 155 PSAY nTotIB  PICTURE "9999999.99"  
//@ nLine, 166 PSAY nTotSUS PICTURE "9999999.99"  
@ nLine, 166 PSAY nTotGRA PICTURE "9999999.99"  
nLine := nLine + 1

@ nLine,  00 PSAY Replicate( '-', 220 ) + Chr( 12 )
nLine++
@ nLine,  00 PSAY ' '

RETURN NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ xValor   ³ Autor ³ Diego F. Rivero     ³ Data ³ 16.12.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Calcula el valor convertido segun los par metros         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ FIND13X                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function xValor( nValor, dDataOri, nMoeOri, nTxMoeda )
Local aArea    := GetArea(),;
aSM2     := SM2->(GetArea()) ,;
nTipoMov := mv_par08 ,;
nMoneda  := mv_par07 ,;
nVerTasa := mv_par09 ,;
nTasaOri := 0.00 ,;
nTasaDes := 0.00 ,;
cCampoOri:= 'M2_MOEDA' + Alltrim( Str( nMoeOri, 1, 0 ) ) ,;
cCampoDes:= 'M2_MOEDA' + Alltrim( Str( nMoneda, 1, 0 ) ) ,;
nValRet  := 0.00

If ValType( nMoeOri ) != 'N' .or. nMoeOri < 1 .or. nMoeOri > MoedFin()
	MsgAlert( 'Existen registros con la moneda informada erroneamente!', 'Verificar Datos' )
	Return( 0 )
EndIf

SM2->(DbSetOrder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Si la moneda del documento es la misma que la pedida en el   ³
//³ informe, o si el Tipo de Movimiento pedido es Solo Movi-     ³
//³ mientos en moneda...                                         ³
//³ Retorno el mismo valor del Documento                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Round( nMoeOri, 0 ) == Round( nMoneda, 0 ) ) .or. ( nTipoMov == 1 )
	RestArea( aSM2 )
	RestArea( aArea )
	Return( nValor )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Si la moneda del Documento es 1, dejo establezco que la tasa ³
//³ es 1, sino, busco la tasa teniendo en cuenta si es Hist¢rica ³
//³ o Actual                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Round( nMoeOri, 0 ) == 1
	nTasaOri := 1
Else
	If !Empty( nTxMoeda ) .and. nVerTasa == 2
		nTasaOri := nTxMoeda
	Else
		SM2->(DbSeek( Iif( nVerTasa == 1, dDataBase, dDataOri ), .T. ))
		If !SM2->(Found())
			SM2->(DbSkip(-1))
		EndIf
		nTasaOri := SM2->( FieldGet( FieldPos( cCampoOri ) ) )
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Si la moneda del Informe es 1, dejo establezco que la tasa   ³
//³ es 1, sino, busco la tasa teniendo en cuenta si es Hist¢rica ³
//³ o Actual                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Round( nMoneda, 0 ) == 1
	nTasaDes := 1
Else
	SM2->(DbSeek( Iif( nVerTasa == 1, dDataBase, dDataOri ), .T. ))
	If !SM2->(Found())
		SM2->(DbSkip(-1))
	EndIf
	nTasaDes := SM2->( FieldGet( FieldPos( cCampoDes ) ) )
EndIf

If nTasaDes != 0
	nValRet  := Round( nTasaOri * nValor / nTasaDes, 2 )
EndIf

RestArea( aSM2 )
RestArea( aArea )

Return( nValRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ VLDPERG  ³ Autor ³ Ariel A. Musumeci   ³ Data ³ 16.12.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Validaci¢n de SX1 para KARDEX1                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ KARDEX01                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function VldPerg(cPerg)
Local _sAlias := Alias()
Local aRegs:={},i,j
dbSelectArea("SX1")
dbSetOrder(1)

aAdd(aRegs,{cPerg,"01","Desde Fecha"    ,"Desde Fecha"    ,"Desde Fecha"    ,"mv_ch1","D",08,0,0,"G","","mv_par01",""                ,""                ,""                ,"","",""       ,""       ,""       ,"","",""        ,""        ,""        ,"","","","","","","","","","","","",'','' } )
aAdd(aRegs,{cPerg,"02","Desde Fecha"    ,"Desde Fecha"    ,"Desde Fecha"    ,"mv_ch2","D",08,0,0,"G","","mv_par02",""                ,""                ,""                ,"","",""       ,""       ,""       ,"","",""        ,""        ,""        ,"","","","","","","","","","","","",'','' } )
aAdd(aRegs,{cPerg,"03","Imprimir"       ,"Imprimir"       ,"Imprimir"       ,"mv_ch3","N",01,0,0,"C","","mv_par03","Analisis y Total","Analisis y Total","Analisis y Total","","","Totales","Totales","Totales","","",""        ,""        ,""        ,"","","","","","","","","","","","",'','' } )
aAdd(aRegs,{cPerg,"04","Estado"         ,"Estado"         ,"Estado"         ,"mv_ch4","N",01,0,0,"C","","mv_par04","Todos"           ,"Todos"           ,"Todos"           ,"","","Activos","Activos","Activos","","","Anulados","Anulados","Anulados","","","Salteados","Salteados","Salteados","","","","","","","",'','' } )
aAdd(aRegs,{cPerg,"05","Desde Modalidad","Desde Modalidad","Desde Modalidad","mv_ch5","C",10,0,0,"G","","mv_par05",""                ,""                ,""                ,"","",""       ,""       ,""       ,"","",""        ,""        ,""        ,"","","","","","","","","","","","SED",'','' } )
aAdd(aRegs,{cPerg,"06","Hasta Modalidad","Hasta Modalidad","Hasta Modalidad","mv_ch6","C",10,0,0,"G","","mv_par06",""                ,""                ,""                ,"","",""       ,""       ,""       ,"","",""        ,""        ,""        ,"","","","","","","","","","","","SED",'','' } )
//aAdd(aRegs,{cPerg,"07","Moneda         ","Moneda         ","Moneda         ","mv_ch7","N", 1,0,0,"G","(mv_par07>0.and.mv_par07>=MoedFin())","mv_par07","Moneda 1","Moneda 1","Moneda 1","1" ,"","Moneda 2","Moneda 2","Moneda 2","","","Moneda 3","Moneda 3","Moneda 3","","","Moneda 4","Moneda 4","Moneda 4","","","Moneda 5","Moneda 5","Moneda 5","",""   ,'','' } )
aAdd(aRegs,{cPerg,"07","Moneda         ","Moneda         ","Moneda         ","mv_ch7","N", 1,0,0,"C","","mv_par07","Moneda 1","Moneda 1","Moneda 1","" ,"","Moneda 2","Moneda 2","Moneda 2","","","Moneda 3","Moneda 3","Moneda 3","","","Moneda 4","Moneda 4","Moneda 4","","","Moneda 5","Moneda 5","Moneda 5","",""   ,'','' } )
aAdd(aRegs,{cPerg,"08","Mostrar        ","Mostrar        ","Mostrar        ","mv_ch8","N", 1,0,0,"C","","mv_par08","Solo en Moneda","Solo en Moneda","Solo en Moneda","" ,"","Exp. en Moneda","Exp. en Moneda","Exp. en Moneda","","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"",""   ,'','' } )
aAdD(aRegs,{cPerg,"09","Usar Tasa      ","Usar Tasa      ","Usar Tasa      ","mv_ch9","N", 1,0,0,"C","","mv_par09","Actual","Actual","Actual","" ,"","Hist¢rica","Hist¢rica","Hist¢rica","","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"",""   ,'','' } )
aAdd(aRegs,{cPerg,"10","OP's Generadas por Canje?","OP's Generadas por Canje?","OP's Generadas por Canje?","mv_cha","N", 1,0,0,"C","","mv_par10","Si","Si","Si","" ,"","No","No","No","","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"",""   ,'','' } )

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
RETURN
