#include "rwmake.ch"
#IFNDEF WINDOWS
 #DEFINE PSAY SAY
#ENDIF
#DEFINE BOTTOMPAGE 62


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DIARCOBR  ³ Autor ³ MS	   				³ Data ³11/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Diario Cobranza		 				                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DIARCOBR(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Diarcobr()

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
SetPrvt("ADRIVER,LPROC,NLINE,CRECIBO,DFECHA,CCODCLI")
SetPrvt("NRECNO,NTOTNET,NTOTIVA,NTOTGAN,NTOTIB,NTOTGRA")
SetPrvt("NNETO,NRETGAN,NRETIVA,NRETIB,NTOTAL,AFIELDS")
SetPrvt("CDBFTMP,CNTXTMP,LLASTPAGE,CALIAS,cModelo,cNroCompRet")
SetPrvt("NRETDIV,NTOTDIV")
SetPrvt("NMULTA,NTOTMUL")
SetPrvt("NSUS,NTOTSUS") //TYCO


#IFNDEF WINDOWS

#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET PRINTER TO
SET PRINT OFF
SET DEVICE TO SCREEN

_cSource   := "SEL"
_cCbTxt    := ""
_cCbCont   := ""
_lComp     := .T. // Habilita/Deshabilita o Formato Comprimido/Expandido
_lFiltro   := .T. // Habilita/Deshabilita o Filtro
_lDic      := .T. // Habilita/Deshabilita Dicionario
_lFiltro   := .F.
_cTitulo   := "Diario de Cobranzas"
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
_cNomeProg := "DIARCOBRO"        // nome do programa
_cPerg     := PADR( "DIARICOBRO", 10 )
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

   nLine      := BOTTOMPAGE
   cRecibo  := Space( 0 )
   dFecha   := CToD( "" )
   cCodCli  := Space( 0 )
   cmodelo  := Space( 0 )
   nRecNo   := 0

   nTotCHQ  := 0
   nTotEFE  := 0
   nTotTRF  := 0
   nTotIVA  := 0
   nTotGAN  := 0
   nTotIB   := 0
   nTotGRA  := 0
   nTotDIV  := 0
   nTotMUL  := 0
   nTotSUS  := 0 //tyco 

   nCHQ     := 0
   nEFE     := 0
   nTRF     := 0
   nRETGAN  := 0
   nRETIVA  := 0
   nRETIB   := 0
   nRETDIV  := 0
   nMULTA   := 0
   nSUS :=0//tyco
   nTOTAL   := 0

   aFields  := Array( 0 )

   AAdd( aFields, { "RECIBO",   "C",  12, 0 } )
   AAdd( aFields, { "TIPODOC",  "C",  2, 0 } )
   AAdd( aFields, { "NRODOC",   "C", 12, 0 } )
   AAdd( aFields, { "FECHA",    "D",  2, 0 } )
   AAdd( aFields, { "CODCLI",   "C",  11, 0 } )
   AAdd( aFields, { "VALOR",    "N", 10, 2 } )
   AAdd( aFields, { "ANULADO",  "C",  1, 0 } )
   AAdd( aFields, { "MODELO",   "C", 10, 0 } )
   
   cDbfTmp := CriaTrab( aFields, .t. )
   cNtxTmp := CriaTrab( , .f. ) + OrdBagExt()

   IF !Empty( Select( "TRB" ) )
      DbSelectArea( "TRB" )
      DbCloseArea()
   ENDIF

   FErase( cNtxTmp )

   DbUseArea( .T., __cRDDNTTS, cDbfTmp, "TRB", .f., .f. )
   DbCreateIndex( cNtxTmp, "RECIBO+TIPODOC+NRODOC", { || RECIBO+TIPODOC+NRODOC }, .f. )

   DbSelectArea( "SM2" )
   DbSetOrder( 1 )

   DbSelectArea( "SA1" )
   DbSetOrder( 1 )

   DbSelectArea( "SEL" )
   DbSetOrder( 4 )
   dbgotop()

   WHILE !EoF() 
   IF  EL_DTDIGIT <= mv_par02

      IF SEL->EL_NATUREZ < mv_par05 .OR. SEL->EL_NATUREZ > mv_par06  .OR. SEL->EL_COBRAD <MV_PAR10 .OR. SEL->EL_COBRAD>MV_PAR11 .OR.  EL_DTDIGIT < MV_PAR01
         DbSkip()
         Loop
      Endif

      DbSelectArea( "TRB" )

      IF !DbSeek( SEL->EL_RECIBO )

         DbSelectArea( "SEL" )

         cRecibo := EL_RECIBO
         cmodelo := EL_NATUREZ
         dFecha  := EL_DTDIGIT
         nRecNo  := RecNo()
		   

//         DbSetOrder( 1 )
//         DbSeek( cRecibo )

         WHILE !EoF() .AND. EL_RECIBO == cRecibo

            If Round( Val(SEL->EL_MOEDA), 0 ) <> Round( mv_par07, 0 ) .and. mv_par08 == 1
               DbSkip()
               Loop
            EndIf

            IF SEL->EL_TIPODOC $ "EF-CH-TF-RI-RB-RG-MU-RS-IM"//TYCO
               TRB->( DbAppend() )
               TRB->RECIBO  := SEL->EL_RECIBO
               TRB->TIPODOC := SEL->EL_TIPODOC
               TRB->NRODOC  := SEL->EL_NUMERO
               TRB->FECHA   := dFecha
               TRB->CODCLI  := SEL->EL_CLIENTE
               //TRB->VALOR   := xValor( EL_VALOR, EL_DTDIGIT, Val( EL_MOEDA ), Round( EL_VLMOED1 / EL_VALOR, 4 ), EL_TASA )
               TRB->VALOR   := xValor( EL_VALOR, EL_DTDIGIT, Val( EL_MOEDA ), Round( EL_VLMOED1 / EL_VALOR, 4 ) )
               TRB->ANULADO := IIF(SEL->EL_CANCEL,"S"," ")
               TRB->MODELO  := SEL->EL_NATUREZ
               
            ENDIF

            DbSkip()

         ENDDO

         DbSetOrder( 4 )
         DbGoTo( nRecNo )

      ELSE

         DbSelectArea( "SEL" )

      ENDIF
      ENDIF
      DbSkip()

   ENDDO

   DbSelectArea( "TRB" )
   // Genera saltos de numeraci¢n para impresi¢n
/*   If mv_par04 == 5 .OR. ( mv_par04 == 4 .AND. cANULADO == "X" )
      DbClearIndex()
      FErase( cNtxTmp )
      DbCreateIndex( cNtxTmp, "RECIBO", { || RECIBO }, .f. )
      DbGoTop()

      nTope:=Getnewpar("MV_TOPRECI",200)

      nRecibo := Val(RECIBO)
      cRecibo := RECIBO
      DbSkip()
      WHILE !EoF()           
         IF TRB->ANULADO=='X'
            DbSkip()
				LOOP
			Endif	         
         
         If RECIBO == cRecibo 
            DbSkip()
         EndIf                
         If Val(RECIBO) == ( nRecibo + 1 ) .and. (recibo <> cRecibo)
            nRecibo := Val(RECIBO)
            cRecibo := RECIBO
         Else
            nDesde := nRecibo+1
            nHasta := Val(RECIBO) - 1
            If ( nHasta - nDesde ) > nTope
               nRecibo := Val(RECIBO)
               cRecibo := RECIBO
               DbSkip()
            	Loop
            EndIf
            nRecNo:=recno()
            dFecha  := FECHA
            Reclock("TRB",.T.)
            TRB->RECIBO  := ALLTRIM(Str(nDesde,12))
            TRB->CODCLI  := Alltrim(Str(nHasta,12))
            TRB->FECHA   := dFecha
            TRB->ANULADO := "X"
         For nx:=nDesde to nHasta
               Reclock("TRB",.T.)
               TRB->RECIBO  := StrZERO(nx,6)
               TRB->FECHA   := dFecha
               TRB->ANULADO := "X"
               dbUnLock()
            Next
            DbGoTo( nRecNo )
            nRecibo := Val(RECIBO)
            cRecibo := RECIBO
         EndIf
         DbSkip()
      Enddo
   Endif*/

   DbClearIndex()
   FErase( cNtxTmp )
   DbCreateIndex( cNtxTmp, "DTOS(FECHA)+RECIBO", { || DTOS(FECHA)+RECIBO }, .f. )
   SetRegua( RecCount() + 1 )
   DbGoTop()

   WHILE !EoF()
      cRecibo := RECIBO
      dFecha  := FECHA
      cCodCli := CODCLI
      cModelo := MODELO
      cAnulado:= ANULADO
	  aNroRet :={ ".....", ".....", ".....", "....." }	      

      nCHQ    := 0
      nEFE    := 0
      nTRF    := 0
      nRETGAN := 0
      nRETIVA := 0
      nRETIB  := 0
      nRETDIV := 0
      nMULTA  := 0
      nSUS :=0 
      nTOTAL  := 0

      WHILE !EoF() .AND. RECIBO == cRecibo

         IF ANULADO == " "
            IF TIPODOC $ "CH"
               nCHQ    := nCHQ + VALOR
            ELSEIF TIPODOC $ "EF"
               nEFE    := nEFE + VALOR
            ELSEIF TIPODOC $ "TF"
               nTRF    := nTRF + VALOR
            ELSEIF TIPODOC $ "RG"
               nRETGAN := nRETGAN + VALOR
               aNroRet [1]:= NRODOC	
            ELSEIF TIPODOC $ "RI"
            	nRETIVA := nRETIVA + VALOR
            	aNroRet [2]:= NRODOC
            ELSEIF TIPODOC $ "RB"
               nRETIB  := nRETIB + VALOR 
               aNroRet [3]:= NRODOC
            ELSEIF TIPODOC $ "IM"
               nRETDIV  := nRETDIV + VALOR
            ELSEIF TIPODOC $ "MU"
               nMULTA  := nMULTA + VALOR
            ELSEIF TIPODOC $ "RS" //TYCO
               nSUS  := nSUS + VALOR    //TYCO
               aNroRet [4]:= NRODOC
            ELSEIF !TIPODOC $ "TB-RA"
               MsgStop( "El recibo: " + cRecibo + " tiene problemas", "ERROR" )
            ENDIF
         ENDIF

         DbSkip()
         IncRegua()

      ENDDO
      If ( mv_par04 == 5 .OR. ( mv_par04 == 2 .AND. cANULADO == " " ) .OR. ( mv_par04 == 3 .AND. cANULADO == "S" ) ;
         .OR. ( mv_par04 == 4 .AND. cANULADO == "X" ) .OR. ( mv_par04 == 1 .and. cANULADO # "X" ) )

         nTOTAL  := nCHQ + nEFE + nTRF + nRETGAN + nRETIVA + nRETIB + nRETDIV + nMULTA + nSUS //TYCO

         nTotCHQ := nTotCHQ + nCHQ
         nTotEFE := nTotEFE + nEFE
         nTotTRF := nTotTRF + nTRF
         nTotGAN := nTotGAN + nRETGAN
         nTotIVA := nTotIVA + nRETIVA
         nTotIB  := nTotIB  + nRETIB
         nTotDIV := nTotDIV + nRETDIV
         nTotMUL := nTotMUL + nMULTA
         nTotSUS := nTotSUS + nSUS//TYCO
         nTotGRA := nTotGRA + nTOTAL

         DbSelectArea( "SA1" )
         DbSeek( xFilial( "SA1") + cCodCli )

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

      _cCabec1 := "Numero        Fecha    Cod.        Nombre o Razon Social                C.U.I.T.       Valores   Efectivo     Transf.    Retencion   Retencion  Retencion    Otras    Multas   Retencion   Total      Nros Comprob Ret  " //TYCO
      _cCabec2 := "Comprobante                                                                                                              Ganancias   I.V.A.     Ing. Brut.   Ret.              SUS         Comprob.   Gananc/Iva/Ib/Sus "   //TYCO
/*
Numero        Fecha    Cod.            Razon Social          Natural.     C.U.I.T.      Valores    Efectivo   Transf.  Retencion  Retencion  Retencion  Otras      Multas     Retencion  Total
Comprobante                                                                                                            Ganancias  I.V.A.     Ing. Brut. Ret.                  SUS        Comprob.
1234567890123 12345678 123456 123456789012345678901234567890 123456789. 1234567890123 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890
*/
		Cabec( _cTitulo + ' - ' + Capital(GetMv('MV_MOEDA'+Str(mv_par07,1,0)))+ " Desde "+DTOC(MV_PAR01);
		+ " Hasta " +DTOC (MV_PAR02), _cCabec1, _Ccabec2, _cNomeProg, _cTamanho, 18 )
	
      
      nLine := 10

   ENDIF

RETURN NIL

Static FUNCTION PrintItem()

   If cAnulado != "X"
      @ nLine,  00 PSAY cRecibo
      @ nLine,  14 PSAY dFecha
      @ nLine,  23 PSAY cCodCli
      @ nLine,  35 PSAY Left( AllTrim( SA1->A1_NOME ), 30 )
      //@ nLine,  64 PSAY cmodelo
      @ nLine,  72 PSAY SA1->A1_CGC
   EndIf

   IF cAnulado == "S"
      @ nLine,  86 PSAY "*** ANULADO ***"
   ELSEIf cAnulado == "X"
      @ nLine,  00 PSAY "Desde Recibo: " + cRecibo
      @ nLine,  40 PSAY "Hasta Recibo: " + cCodCli
      @ nLine,  86 PSAY "** SALTEADO **"
   Else
      @ nLine,  85 PSAY nCHQ         PICTURE "9999999.99"
      @ nLine,  96 PSAY nEFE         PICTURE "9999999.99"
      @ nLine, 107 PSAY nTRF         PICTURE "9999999.99"
      @ nLine, 118 PSAY nRETGAN      PICTURE "9999999.99"
      @ nLine, 129 PSAY nRETIVA      PICTURE "9999999.99"
      @ nLine, 140 PSAY nRETIB       PICTURE "9999999.99"
      @ nLine, 151 PSAY nRETDIV       PICTURE "9999999.99"      
      @ nLine, 162 PSAY nMULTA       PICTURE "9999999.99"
      @ nLine, 173 PSAY nSUS       PICTURE "9999999.99" //TYCO
      @ nLine, 184 PSAY nTOTAL       PICTURE "9999999.99"      //TYCO ANTES LINEA 163
   	  @ nLine, 195 PSAY right(alltrim(aNroRet[1]),5)+"/"+right(alltrim(aNroRet[2]),5)+"/"+right(alltrim(aNroRet[3]),5)+"/"+right(alltrim(aNroRet[4]),5) 
   ENDIF
   nLine := nLine + 1

RETURN NIL

Static FUNCTION PrintTotal()

   @ nLine,  00 PSAY Replicate( ".", 195 )
   nLine := nLine + 1

   @ nLine,  00 PSAY "TOTALES GENERALES:"
   @ nLine,  85 PSAY nTotCHQ PICTURE "9999999.99"
   @ nLine,  96 PSAY nTotEFE PICTURE "9999999.99"
   @ nLine, 107 PSAY nTotTRF PICTURE "9999999.99"
   @ nLine, 118 PSAY nTotGAN PICTURE "9999999.99"
   @ nLine, 129 PSAY nTotIVA PICTURE "9999999.99"
   @ nLine, 140 PSAY nTotIB  PICTURE "9999999.99"
   @ nLine, 151 PSAY nTotDiv PICTURE "9999999.99"
   @ nLine, 162 PSAY nTotMUL PICTURE "9999999.99"
   @ nLine, 173 PSAY nTotSUS PICTURE "9999999.99" //TYCO
   @ nLine, 185 PSAY nTotGRA PICTURE "9999999.99"           //TYCO
   nLine := nLine + 1

   @ nLine,  00 PSAY Replicate( ".", 195 )

RETURN NIL

Static Function VldPerg(cPerg)
Local _sAlias := Alias()
Local aRegs:={},i,j
dbSelectArea("SX1")
dbSetOrder(1)

aAdd(aRegs,{cPerg,"01","Desde Fecha"    ,"Desde Fecha"    ,"Desde Fecha"    ,"mv_ch1","D",08,0,0,"G","","mv_par01",""                ,""                ,""                ,"","",""       ,""       ,""       ,"","",""        ,""        ,""        ,"","","","","","","","","","","","",'','' } )
aAdd(aRegs,{cPerg,"02","Hasta Fecha"    ,"Hasta Fecha"    ,"Hasta Fecha"    ,"mv_ch2","D",08,0,0,"G","","mv_par02",""                ,""                ,""                ,"","",""       ,""       ,""       ,"","",""        ,""        ,""        ,"","","","","","","","","","","","",'','' } )
aAdd(aRegs,{cPerg,"03","Imprimir"       ,"Imprimir"       ,"Imprimir"       ,"mv_ch3","N",01,0,0,"C","","mv_par03","Analisis y Tot.","Analisis y Tot.","Analisis y Tot.","","","Totales","Totales","Totales","","",""        ,""        ,""        ,"","","","","","","","","","","","",'','' } )
aAdd(aRegs,{cPerg,"04","Estado"         ,"Estado"         ,"Estado"         ,"mv_ch4","N",01,0,0,"C","","mv_par04","Activos y Anul."  ,"Activos y Anul."  ,"Activos y Anul."  ,"","","Activos","Activos","Activos","","","Anulados","Anulados","Anulados","","","Salteados","Salteados","Salteados","","","Todos","Todos","Todos","","",'','' } )
aAdd(aRegs,{cPerg,"05","Desde Modalidad","Desde Modalidad","Desde Modalidad","mv_ch5","C",10,0,0,"G","","mv_par05",""                ,""                ,""                ,"","",""       ,""       ,""       ,"","",""        ,""        ,""        ,"","","","","","","","","","","","SED",'','' } )
aAdd(aRegs,{cPerg,"06","Hasta Modalidad","Hasta Modalidad","Hasta Modalidad","mv_ch6","C",10,0,0,"G","","mv_par06",""                ,""                ,""                ,"","",""       ,""       ,""       ,"","",""        ,""        ,""        ,"","","","","","","","","","","","SED",'','' } )
aAdd(aRegs,{cPerg,"07","Moneda         ","Moneda         ","Moneda         ","mv_ch7","N", 1,0,0,"C","","mv_par07","Moneda 1","Moneda 1","Moneda 1","" ,"","Moneda 2","Moneda 2","Moneda 2","","","Moneda 3","Moneda 3","Moneda 3","","","Moneda 4","Moneda 4","Moneda 4","","","Moneda 5","Moneda 5","Moneda 5","",""   ,'','' } )
aAdd(aRegs,{cPerg,"08","Mostrar        ","Mostrar        ","Mostrar        ","mv_ch8","N", 1,0,0,"C","","mv_par08","Solo en Moneda","Solo en Moneda","Solo en Moneda","" ,"","Exp. en Moneda","Exp. en Moneda","Exp. en Moneda","","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"",""   ,'','' } )
aAdD(aRegs,{cPerg,"09","Usar Tasa      ","Usar Tasa      ","Usar Tasa      ","mv_ch9","N", 1,0,0,"C","","mv_par09","Actual","Actual","Actual","" ,"","Hist¢rica","Hist¢rica","Hist¢rica","","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"",""   ,'','' } )
aAdD(aRegs,{cPerg,"10","Desde Cobrador?      ","Desde Cobrador?      ","Desde Cobrador   ","mv_chA","C", 6,0,0,"C","","mv_par10","","","","" ,"","","","","","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"","SAQ"   ,'','' } )
aAdD(aRegs,{cPerg,"11","Hasta Cobrador?      ","Hasta Cobrador?      ","Hasta Cobrador   ","mv_chB","C", 6,0,0,"C","","mv_par11","","","","" ,"","","","","","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"","SAQ"   ,'','' } )

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
Static Function xValor( nValor, dDataOri, nMoeOri, nTxMoeda1, nTxMoeda2 )
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

If ValType( nTxMoeda1 ) != 'N'
   nTxMoeda1 := 0
EndIf

If ValType( nTxMoeda2 ) != 'N'
   nTxMoeda2 := 0
EndIf

If ValType( nMoeOri ) != 'N' .or. nMoeOri < 1 .or. nMoeOri > 5
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
   If !Empty( nTxMoeda1 ) .and. nVerTasa == 2
      nTasaOri := nTxMoeda1
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
   If !Empty( nTxMoeda2 ) .and. nVerTasa == 2
      nTasaDes := nTxMoeda2
   Else
      SM2->(DbSeek( Iif( nVerTasa == 1, dDataBase, dDataOri ), .T. ))
      If !SM2->(Found())
         SM2->(DbSkip(-1))
      EndIf
      nTasaDes := SM2->( FieldGet( FieldPos( cCampoDes ) ) )
   EndIf
EndIf

If nTasaDes != 0
   nValRet  := Round( nTasaOri * nValor / nTasaDes, 2 )
EndIf

RestArea( aSM2 )
RestArea( aArea )

Return( nValRet )
