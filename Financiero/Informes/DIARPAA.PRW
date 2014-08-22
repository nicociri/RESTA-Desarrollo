#include "rwmake.ch"
#IFNDEF WINDOWS
 #DEFINE PSAY SAY
#ENDIF
#DEFINE BOTTOMPAGE 42

User Function DIARPAA()

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
SetPrvt("NRECNO,NTOTNET,NTOTIVA,NTOTGAN,NTOTIBG,NTOTIBC,NTOTGRA")
SetPrvt("NNETO,NRETGAN,NRETIVA,NRETIBG,NRETIBG,NTOTAL,AFIELDS")
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
_cNomeProg := "DIARPA04"        // nome do programa
_cPerg     := PADR( "ARFR04", 10 )
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

   nLine    := BOTTOMPAGE
   cOrdPago := Space( 0 )
   cMoeda   := ""
   dFecha   := CToD( "" )
   nrocert  := 0 //   Space( 0 )
   CERT     := 0
   cCodProv := Space( 0 )
   nRecNo   := 0

   nTotCHQ  := 0
   nTotEFE  := 0
   nTotTRF  := 0
   nTotIVA  := 0
   nTotGAN  := 0
   nTotIBG  := 0
   nTotIBC  := 0
   nTotSUS  := 0
   nTotSLI	:= 0
   nTotSSI	:= 0  
   nTotGRA  := 0

   nCHQ     := 0
   nEFE     := 0
   nTRF     := 0
   nRETGAN  := 0
   nRETIVA  := 0
   nRETIBG  := 0
   nRETIBC  := 0   
   nRETSUS  := 0
   nRETSLI	:= 0
   nRetSSI	:= 0
   nTOTAL   := 0

   aFields  := Array( 0 )

   AAdd( aFields, { "ORDPAGO",  "C",  6, 0 } )
   AAdd( aFields, { "TIPODOC",  "C",  2, 0 } )
   AAdd( aFields, { "NRODOC",   "C", 12, 0 } )
   AAdd( aFields, { "FECHA",    "D",  2, 0 } )
   AAdd( aFields, { "CODPROV",  "C",  6, 0 } ) 
   AAdd( aFields, { "VALOR",    "N", 10, 2 } )
   AAdd( aFields, { "ANULADO",  "C",  1, 0 } )
   AAdd( aFields, { "MODELO",   "C", 10, 0 } )
   AAdd( aFields, { "RETIIBB",  "C",  1, 0 } )
   
   cDbfTmp := CriaTrab( aFields, .t. ) + GetDBExtension()
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

      DbSelectArea( "TRB" )

      IF !DbSeek( SEK->EK_ORDPAGO )

         DbSelectArea( "SEK" )

         cOrdPago := EK_ORDPAGO
         cmodelo  := If( lNaturez, EK_NATUREZ, Space(10) )
         dFecha   := EK_DTDIGIT
         nRecNo   := RecNo()             
         nrocert  := EK_NUM

//USEK AGREGO			
             IF xRetSFE(cOrdPago) > 0
               TRB->( DbAppend() )                   
               TRB->ORDPAGO  := cOrdPago
               TRB->TIPODOC  := "SU"
               TRB->NRODOC   := SEK->EK_NUM
               TRB->FECHA    := dFecha
               TRB->CODPROV  := SEK->EK_FORNECE 
   	    	   TRB->VALOR 	 := xValor( xRetSFE(cOrdPago), SEK->EK_DTDIGIT, Val( EK_MOEDA ), Round( EK_VLMOED1 /xRetSFE(cOrdPago), 4 ) )
	           TRB->ANULADO  := IIF(SEK->EK_CANCEL,"S"," ")
               TRB->MODELO   := IIF(lNaturez, SEK->EK_NATUREZ, Space(10) )
               TRB->RETIIBB  := "B"
               
	         DbSelectArea( "SEK" )
	         EndIf
//USEK AGREGO                      

		 
         DbSetOrder( 1 )
         DbSeek( xFilial( "SEK" ) + cOrdPago )

         WHILE !EoF() .AND. EK_FILIAL == xFilial( "SEK" ) .AND. ;
            EK_ORDPAGO == cOrdPago

            IF EK_TIPODOC $ "EF-CP-CT-TF-RG" .AND. SEK->EK_TIPO <> 'SU-' //USEKAGREGO .AND. SEK->EK_TIPO <> 'SU-'
               TRB->( DbAppend() )       
               
               TRB->ORDPAGO  := SEK->EK_ORDPAGO
               TRB->TIPODOC  := If( SEK->EK_TIPODOC != 'RG', SEK->EK_TIPODOC, Left( SEK->EK_TIPO, 2 ) )
               TRB->NRODOC   := SEK->EK_NUM
               TRB->FECHA    := dFecha
               TRB->CODPROV  := SEK->EK_FORNECE 
   	    	   TRB->VALOR 	 := xValor( EK_VALOR, SEK->EK_DTDIGIT, Val( EK_MOEDA ), Round( EK_VLMOED1 / EK_VALOR, 4 ) )
	           TRB->ANULADO  := IIF(SEK->EK_CANCEL,"S"," ")
               TRB->MODELO   := IIF(lNaturez, SEK->EK_NATUREZ, Space(10) )
               TRB->RETIIBB  := "B"              
            ENDIF
	         DbSelectArea( "SEK" )

            DbSkip()
         ENDDO

         DbSetOrder( 3 )
         DbGoTo( nRecNo )
      ELSE
         DbSelectArea( "SEK" )
		EndIF

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
   DbCreateIndex( cNtxTmp, "DTOS(FECHA)+ORDPAGO", { || DTOS(FECHA)+ORDPAGO }, .f. )
   SetRegua( RecCount() + 1 )
   DbGoTop()
      
   CERT:= SPACE(0)
   WHILE !EoF()
      cOrdPago  := ORDPAGO
      dFecha    := FECHA
      cCodProv  := CODPROV
      cModelo   := MODELO
      cAnulado  := ANULADO
      nrocert   := NRODOC  
       
      nCHQ    := 0
      nEFE    := 0
      nTRF    := 0
      nNETO   := 0
      nRETGAN := 0
      nRETIVA := 0
      nRETIBG := 0
	  nRETIBC := 0      
      nRETSUS := 0
   	  nRETSLI := 0
	  nRetSSI := 0
      nTOTAL  := 0  
     CERTGAN :=SPACE(0)
     CERTIVA :=SPACE(0)
     CERTIB :=SPACE(0)
     CERTSUS :=SPACE(0)
     CERTSLI :=SPACE(0)   
      

      WHILE !EoF() .AND. ORDPAGO == cOrdPago

         IF ANULADO == " "
            IF TIPODOC $ "CP-CT"
               nCHQ    := nCHQ + VALOR
            ELSEIF TIPODOC $ "EF"
               nEFE    := nEFE + VALOR
            ELSEIF TIPODOC $ "TF-DN"        //USEK AGREGO -DN
               nTRF    := nTRF + VALOR
            ELSEIF TIPODOC $ "GN"
               nRETGAN := nRETGAN + VALOR  

            ELSEIF TIPODOC $ "IV"
               nRETIVA := nRETIVA + VALOR
            ELSEIF TIPODOC $ "IB"
				nRETIBG  := nRETIBG + VALOR
 		    ELSEIF TIPODOC $ "SU"
               nRETSUS := nRETSUS + VALOR
            ELSEIF TIPODOC $ "SL"
               nRETSLI := nRETSLI + VALOR
            ELSEIF TIPODOC $ "SI"
               nRETSSI := nRETSSI + VALOR                            
            ELSEIF !TIPODOC $ "TB-RA"
               MsgStop( "La Orden de Pago: " + cOrdPago + " tiene problemas", "ERROR" )
            ENDIF
         ENDIF
         
 // parte agregada para considerar datos de OP. anuladas y poner todos los datos
 
 IF ANULADO == "S"
            IF TIPODOC $ "CP-CT"
               nCHQ    := nCHQ + VALOR
            ELSEIF TIPODOC $ "EF"
               nEFE    := nEFE + VALOR
            ELSEIF TIPODOC $ "TF-DN"        //USEK AGREGO -DN
               nTRF    := nTRF + VALOR
            ELSEIF TIPODOC $ "GN"
               nRETGAN := nRETGAN + VALOR
               MSGALERT("GANANCIAS CERT.: ", NRODOC) 
               CERTGAN:=NRODOC
            ELSEIF TIPODOC $ "IV"
               nRETIVA := nRETIVA + VALOR            
               MSGALERT("IVA  CERT.: ", NRODOC)                
               CERTIVA:=NRODOC
            ELSEIF TIPODOC $ "IB"
				nRETIBG  := nRETIBG + VALOR
               MSGALERT("ING.BRUTOS CERT.: ", NRODOC) 				
				CERTIB :=NRODOC
 		    ELSEIF TIPODOC $ "SU"
               nRETSUS := nRETSUS + VALOR
               MSGALERT("SUS CERT.: ", NRODOC)                
               CERTSUS :=NRODOC
            ELSEIF TIPODOC $ "SL"
               nRETSLI := nRETSLI + VALOR
               MSGALERT("S.LIMP. CERT.: ", NRODOC)                
               CERTSLI :=NRODOC
            ELSEIF TIPODOC $ "SI"
               nRETSSI := nRETSSI + VALOR                            
            ELSEIF !TIPODOC $ "TB-RA"
               MsgStop( "La Orden de Pago: " + cOrdPago + " tiene problemas", "ERROR" )
            ENDIF          
                                 
        
    ENDIF
 
 
 
 
 // hasta aca es la logica de OP anuldas.        

         DbSkip()
         IncRegua()

      ENDDO
      If ( mv_par04 == 1 .OR. ( mv_par04 == 2 .AND. cANULADO == " " ) .OR. ( mv_par04 == 3 .AND. cANULADO == "S" ) ;
         .OR. ( mv_par04 == 4 .AND. cANULADO == "X" ) )

         nTOTAL  := nCHQ + nEFE + nTRF + nRETGAN + nRETIVA + nRETIBG + nRETIBC + nRETSUS + nRETSLI + nRETSSI

         nTotCHQ := nTotCHQ + nCHQ
         nTotEFE := nTotEFE + nEFE
         nTotTRF := nTotTRF + nTRF
         nTotGAN := nTotGAN + nRETGAN
         nTotIVA := nTotIVA + nRETIVA
         nTotIBG := nTotIBG  + nRETIBG
 		 nTotIBC := nTotIBC  + nRETIBC       
         nTotSUS := nTotSUS + nRETSUS
		 nTotSLI := nTotSLI + nRETSLI
   	     nTotSSI := nTotSSI + nRETSSI  
         nTotGRA := nTotGRA + nTOTAL

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

     _cCabec1 := "Numero                                                                                                                  Retencion         Retencion         Retencion        Retencion         Retencion            Total"
     _cCabec2 := "O.Pago  Fecha      Cod.    Nombre o Razon Social    Pcia        C.U.I.T.       Valores     Efectivo     Transf.     Cert.  Ganancias     Cert.   I.V.A.   Cert.  IIBB BA    Cert.  S.U.S.     Cert.   Limpieza      Comprob."
//                01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
    Cabec( _cTitulo + ' - ' + Capital(GetMv('MV_MOEDA'+Str(mv_par07,1,0)))+ " Desde "+DTOC(MV_PAR01);
       + " Hasta " +DTOC (MV_PAR02), _cCabec1, _Ccabec2, _cNomeProg, _cTamanho, 18 )

      nLine := 10

   ENDIF

RETURN NIL

Static FUNCTION PrintItem()

  If cAnulado != "X" 
      @ nLine,  00 PSAY cOrdPago    
      @ nLine,  08 PSAY dFecha
      @ nLine,  18 PSAY cCodProv
      @ nLine,  25 PSAY Left( AllTrim( SA2->A2_NOME ), 30 )
      @ nLine,  56 PSAY  AllTrim( SA2->A2_EST )  
      @ nLine,  59 PSAY cmodelo                  // 61
      @ nLine,  66 PSAY SA2->A2_CGC              // 72
   EndIf
   IF cAnulado == "S"     
      @ nLine,  80 PSAY "*AN*"

      @ nLine,  85 PSAY nCHQ         PICTURE "9999999.99" // 86
      @ nLine, 96  PSAY nEFE         PICTURE "9999999.99" //  97
      @ nLine, 106 PSAY nTRF         PICTURE "9999999.99" // 108 
      @ nLine, 118 PSAY CERTGAN       //    PICTURE "9999999.99" // 114 
     // msgalert ("numero certif:", CERT)     //ACA llega mal ya que trae el numero
      @ nLine, 126 PSAY nRETGAN      PICTURE "9999999.99" // 119        
        CERTGAN:=SPACE(0)   
      @ nLine, 138 PSAY CERTIVA       //    PICTURE "9999999.99" // 114       
        CERTIVA:=SPACE(0)
      @ nLine, 146 PSAY nRETIVA      PICTURE "9999999.99" // 130
      @ nLine, 158 PSAY CERTIB       //    PICTURE "9999999.99" // 114 
        CERTIB:= SPACE(0)
      @ nLine, 166 PSAY nRETIBG      PICTURE "9999999.99" // 141
      @ nLine, 178 PSAY CERTSUS       //    PICTURE "9999999.99" // 114 
      @ nLine, 188 PSAY nRETSUS      PICTURE "9999999.99" // 141




   ELSEIf cAnulado == "X"
      @ nLine,  00 PSAY "Desde O.Pago: " + cOrdPago + "**"
      @ nLine,  40 PSAY "Hasta O.Pago: " + cCodProv   + "**"
      @ nLine,  86 PSAY "** SALTEADO **"
   Else
      @ nLine,  89 PSAY nCHQ         PICTURE "9999999.99" // 86
      @ nLine, 100 PSAY nEFE         PICTURE "9999999.99" //  97
      @ nLine, 111 PSAY nTRF         PICTURE "9999999.99" // 108
      @ nLine, 122 PSAY nRETGAN      PICTURE "9999999.99" // 119 
      @ nLine, 133 PSAY nRETIVA      PICTURE "9999999.99" // 130
      @ nLine, 144 PSAY nRETIBG      PICTURE "9999999.99" // 141
      @ nLine, 166 PSAY nRETSUS      PICTURE "9999999.99" // 163
	@ nLine, 177 PSAY nRETSLI      PICTURE "9999999.99" // 163      
      @ nLine, 199 PSAY nTOTAL       PICTURE "9999999.99" // 174
   ENDIF
   nLine := nLine + 1  
 //  CERTGAN:=SPACE(0)
 //  CERTIVA :=SPACE(0)
 //  CERTIB :=SPACE(0)
 //  CERTSUS :=SPACE(0)
 //  CERTSLI :=SPACE(0)   
      

RETURN NIL

Static FUNCTION PrintTotal()

   @ nLine,  00 PSAY Replicate( '-', 220 )
   nLine := nLine + 1

   @ nLine,  00 PSAY "TOTALES GENERALES:"
   @ nLine,  89 PSAY nTotCHQ PICTURE "9999999.99"  //86
   @ nLine, 100 PSAY nTotEFE PICTURE "9999999.99"  //97 
   @ nLine, 111 PSAY nTotTRF PICTURE "9999999.99"  //108
   @ nLine, 122 PSAY nTotGAN PICTURE "9999999.99"  //119
   @ nLine, 133 PSAY nTotIVA PICTURE "9999999.99"  //130
   @ nLine, 144 PSAY nTotIBG PICTURE "9999999.99"  //141
   @ nLine, 166 PSAY nTotSUS PICTURE "9999999.99"  //163
   @ nLine, 177 PSAY nTotSLI PICTURE "9999999.99"  //163
   @ nLine, 199 PSAY nTotGRA PICTURE "9999999.99"  //174
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

If ValType( nMoeOri ) != 'N' .or. nMoeOri < 1 .or. nMoeOri > 9
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
aAdd(aRegs,{cPerg,"07","Moneda         ","Moneda         ","Moneda         ","mv_ch7","N", 1,0,0,"C","","mv_par07","Moneda 1","Moneda 1","Moneda 1","" ,"","Moneda 2","Moneda 2","Moneda 2","","","Moneda 3","Moneda 3","Moneda 3","","","Moneda 4","Moneda 4","Moneda 4","","","Moneda 5","Moneda 5","Moneda 5","",""   ,'','' } )
aAdd(aRegs,{cPerg,"08","Mostrar        ","Mostrar        ","Mostrar        ","mv_ch8","N", 1,0,0,"C","","mv_par08","Solo en Moneda","Solo en Moneda","Solo en Moneda","" ,"","Exp. en Moneda","Exp. en Moneda","Exp. en Moneda","","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"",""   ,'','' } )
aAdD(aRegs,{cPerg,"09","Usar Tasa      ","Usar Tasa      ","Usar Tasa      ","mv_ch9","N", 1,0,0,"C","","mv_par09","Actual","Actual","Actual","" ,"","Hist¢rica","Hist¢rica","Hist¢rica","","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"",""   ,'','' } )

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
±±³Funci¢n     ³ TIPO DE RETIIBB³ Autor ³ EK            ³ Data ³ 18.11.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ TIPO DE RETIIBB GRAL Y CONSTRUCCION                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ 				                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±3±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function xRETIIBTIPO(cFornece, cLoja)
Local tipo_retiibb := ""

		DbSelectArea("SFH")
		DbSetOrder(1)
		DbGoTop()
		IF !SFH->(DbSeek( xFilial("SFH") + cFornece + cLoja + "IBR" + "BA") )
		  tipo_retiibb = "G"
		else

		  tipo_retiibb = "C"
		endif      
		
//RestArea( aArea )
		SFH->( DbCloseArea() )
return (tipo_retiibb)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ Retencion de SUSS³ Autor ³ EK           ³ Data ³ 20.06.06³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Para buscar en la tabla SFE retenciones de SUSS que no   ³±±
±±³											grava en SFE                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ 				                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±3±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function xRetSFE(cOrdPago)
                       
Local nRet 	  := 0
Local aArea   := GetArea()

cQuery := "SELECT SUM(FE_RETENC) AS RETENC "
cQuery += " FROM " + RETSQLNAME('SFE') + " SFE "
cQuery +=" WHERE FE_ORDPAGO= '" + cOrdPago + "' AND FE_TIPO= 'S' "
cQuery +=" AND D_E_L_E_T_ <> '*'"

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TMSFE',.T.,.T.)
	
Dbselectarea("TMSFE")
Dbgotop()
While !EoF()	

	    nRet  :=TMSFE->RETENC

DbSkip()
EndDo
DbClosearea()

RestArea(aArea)   

return (nRet)