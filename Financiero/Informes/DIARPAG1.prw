#include "rwmake.ch"
#IFNDEF WINDOWS
#DEFINE PSAY SAY
#ENDIF
#DEFINE BOTTOMPAGE 62
#DEFINE DETAILBOTTOM 2550 

User Function DIARPAG1()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaraci�n de variables utilizadas en el programa a trav�s de la funci�n �
//� SetPrvt, va a crear s�lo las variables definidas por el usuario,          �
//� identificando las variables p�blicas del sistema utilizadas en el c�digo  �
//� Incluido por el asistente de conversi�n del AP5 IDE                       �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
LOCAL aArea			:= GetArea()
LOCAL aAreaSE2		:= SE2->(GetArea())

SetPrvt("_CSOURCE,_CCBTXT,_CCBCONT,_LCOMP,_LFILTRO,_LDIC")
SetPrvt("_CTITULO,_CCABEC1,_CCABEC2,_CDESC1,_CDESC2,_CDESC3")
SetPrvt("_CTAMANHO,_NLIMITE,_AORDEM,_CFORMULAR,_NCOPIAS,_CDESTINO")
SetPrvt("_NFORMATO,_NMEDIO,_NLPTPORT,_CFILTRO,_NORDEN,LEND")
SetPrvt("M_PAG,NLASTKEY,_CNOMEPROG,_CPERG,_CNREL,ARETURN")
SetPrvt("ADRIVER,LPROC,NLINE,NLINE1,NLINE2,CORDPAGO,DFECHA,CCODPROV")
SetPrvt("NRECNOE5,NRECNOEK,NTOTNET,NTOTIVA,NTOTGAN,NTOTIBG,NTOTIBC,NTOTGRA")
SetPrvt("NNETO,NRETGAN,NRETIVA,NRETIBG,NRETIBG,NTOTAL,AFIELDS")
SetPrvt("CDBFTMP,CNTXTMP,LLASTPAGE,CALIAS,cTIPO1,cMovBan,nmovban")

Private lNaturez := .F.
PRIVATE cProvincia := Space( 0 ), ;
cProvCMS  := "", ;
cSitIVA   := "", ;
aDriver   := ReadDriver(), ;
nTotVal1  := 0, ;
nTotVal2  := 0, ;
nLine     := 0, ; 
nLine1    := 0, ;
nLine2    := 0, ;
nImpComp  := 0, ;
nSalComp1 := 0, ;
nSalComp2 := 0, ;
nPagoAnt1 := 0, ;
nPagoAnt2 := 0, ;
cMoneda   := Space( 0 ),;
lPrinted  := .F.	,;
nPesopal  := 0			,;
cMon      := Space( 0 )	,;
aExtenso1 := {}			,;
aExtenso2 := {}			,;
nCotiza   := 0			,;
nLineSer  := 0

PRIVATE aCHLis 		:= {} //Array con cheques para controlar desborde de cantidad de items - Ariel - 09/09/02
PRIVATE nCHAdLis 	:= 0 // Cantidad de items que no son cheques para decidir si genera lista o no - Ariel - 09/09/02
PRIVATE nCHValor1 	:= 0 // Importe de la lista de cheques en pesos.  - Ariel - 09/09/02
PRIVATE nCHValor2 	:= 0 // Importe de la lista de cheques en dolares. - Ariel - 09/09/02
SX3->( DbSetOrder(2) )
lNaturez := SX3->( DbSeek( 'EK_NATUREZ' ) )

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define Variaveis Ambientais                                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

SET PRINTER TO
SET PRINT OFF
SET DEVICE TO SCREEN

_cSource   := "SEK"
_cCbTxt    := ""
_cCbCont   := ""
_lComp     := .F. // Habilita/Deshabilita o Formato Comprimido/Expandido
_lFiltro   := .T. // Habilita/Deshabilita o Filtro
_lDic      := .F. // Habilita/Deshabilita Dicionario
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
_nCopias   := 1                 // [2] Reservado para N� de Vias
_cDestino  := "Administracion"  // [3] Destinatario
_nFormato  := 2                 // [4] Formato => 1-Comprimido 2-Normal
_nMedio    := 1                 // [5] Midia   => 1-Disco 2-Impressora
_nLPTPort  := 1                 // [6] Porta ou Arquivo 1-LPT1... 4-COM1...
_cFiltro   := ""                // [7] Expressao do Filtro
_nOrden    := 1                 // [8] Ordem a ser SEKecionada
                                // [9]..[10]..[n] Campos a Processar (se houver)
lEnd       := .T.// Controle de cancelamento do relatorio
m_pag      := 1
nLastKey   := 0  // Controla o cancelamento da SetPrint e SetDefault
_cNomeProg := "ARFINR04"        // nome do programa
_cPerg     := PADR( "ARFR04    ", 10 )
_cNRel     := _cNomeProg

aReturn    := { _cFormular ,_nCopias, _cDestino, _nFormato, _nMedio, ;
                _nLPTPort, _cFiltro, _nOrden } //"Zebrado"###"Administracao"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Verifica as perguntas SEKecionadas, busca o padrao da Nfiscal           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
VldPerg( _cPerg )

IF Pergunte( _cPerg, .T. )               // Pergunta no SX1

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Envia control para funcion SETPRINT                          �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   
   
   
   _cNRel := SetPrint( _cSource, _cNRel, _cPerg, _cTitulo, _cDesc1, ;
                       _cDesc2, _cDesc3, _lDic, _aOrdem, _lComp, ;
                       _cTamanho, _lFiltro, .f. )

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Verifica Posicion del Formulario en la Impresora             �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Determina los l�mites de impresi�n                                      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Static FUNCTION PrintComp()

   nLine    := BOTTOMPAGE 
   cOrdPago := Space( 0 )
   cMovBan	:= Space( 0 )
   cMoeda   := ""
   dFecha   := CToD( "" )
   cCodProv := Space( 0 )
   cNumDoc  := ""
   nRecNoE5 := 0 
   nRecNoEK := 0

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
   
   AAdd( aFields, { "TIPO",     "C",  1, 0 } ) // Determina si es orden de pago o movimiento de fondos
   AAdd( aFields, { "ORDPAGO",  "C", 12, 0 } ) // Numero de operacion 
   AAdd( aFields, { "MOVBAN",   "C", 20, 0 } ) // Numero de operacion
   AAdd( aFields, { "TIPODOC",  "C",  2, 0 } ) // Tipo de operacion
   AAdd( aFields, { "NRODOC",   "C", 12, 0 } ) // Numero de operacion
   AAdd( aFields, { "FECHA",    "D",  2, 0 } ) // Fecha de la operacion
   AAdd( aFields, { "CODPROV",  "C",  6, 0 } ) // Codigo del proveedor
   AAdd( aFields, { "VALOR",    "N", 10, 2 } ) // Valor
   AAdd( aFields, { "ANULADO",  "C",  1, 0 } ) // Anulado
   AAdd( aFields, { "MODELO",   "C", 10, 0 } ) //
   AAdd( aFields, { "RETIIBB",  "C",  1, 0 } ) //
   
   cDbfTmp := CriaTrab( aFields, .t. ) + GetDBExtension()
   cNtxTmp := CriaTrab( , .f. ) + OrdBagExt()

   IF !Empty( Select( "TRB" ) )
      DbSelectArea( "TRB" )
      DbCloseArea()
   ENDIF

   FErase( cNtxTmp )
   
   DbUseArea( .T.,, cDbfTmp, "TRB", .f., .f. )
   //DbCreateIndex( cNtxTmp, "ORDPAGO+TIPODOC+NRODOC", { || ORDPAGO+TIPODOC+NRODOC }, .f. )
   DbCreateIndex( cNtxTmp, "MOVBAN+NRODOC", { || MOVBAN+NRODOC }, .f. )   

   DbSelectArea( "SA2" )
   DbSetOrder( 1 )

   DbSelectArea( "SE5" )
   DbSetOrder( 6 )
   DbSeek( xFilial( "SE5" ) + DToS( mv_par01 ), .t. )


   WHILE !EoF() .AND. E5_FILIAL == xFilial() .AND. E5_DTDIGIT <= mv_par02

      If lNaturez
         IF SE5->E5_NATUREZ < mv_par05 .OR. SE5->E5_NATUREZ > mv_par06
            DbSkip()
            Loop
         Endif
      EndIf

      If Round( Val(SE5->E5_MOEDA), 0 ) <> Round( mv_par07, 0 ) .and. mv_par08 == 1
         DbSkip()
         Loop
      EndIf
      
      If Empty(SE5->E5_PROCTRA)  // Salta a los que no poseen SE5->E5_PROCTRA
         DbSkip()
         Loop
      EndIf

      DbSelectArea( "TRB" )

      IF !DbSeek( SE5->E5_PROCTRA )

         DbSelectArea( "SE5" )

         cMovBan  := E5_PROCTRA
         cmodelo  := If( lNaturez, E5_NATUREZ, Space(10) )
         dFecha   := E5_DTDIGIT
         nRecNoE5 := RecNo()             

		 
         DbSetOrder( 15 )
         DbSeek( xFilial( "SE5" ) + ALLTRIM(cMovBan) )

         WHILE !EoF() .AND. E5_FILIAL == xFilial( "SE5" ) .AND. ;
            E5_PROCTRA == ALLTRIM(cMovBan)
      
            IF SE5->E5_RECPAG == "P"
               TRB->( DbAppend() )                  
               TRB->TIPO  	 := "2"
               TRB->ORDPAGO  := "." 
               TRB->MOVBAN   := SE5->E5_PROCTRA
               TRB->TIPODOC  := If( SE5->E5_TIPODOC != 'RG', SE5->E5_TIPODOC, Left( SE5->E5_TIPO, 2 ) )
               TRB->NRODOC   := SE5->E5_RECPAG
               TRB->FECHA    := dFecha
               TRB->CODPROV  := SE5->E5_BANCO              
               TRB->VALOR 	 := SE5->E5_VALOR
	           TRB->ANULADO  := " "
               TRB->MODELO   := IIF(lNaturez, SE5->E5_NATUREZ, Space(10) )
               TRB->RETIIBB  := ""
            EndIF
  	        DbSelectArea( "SE5" )

            DbSkip()
         ENDDO

         DbSetOrder( 6 )
         DbGoTo( nRecNoE5 )
	  EndIf   
      DbSkip()
   ENDDO   

   DbSelectArea( "TRB" )
   DbClearIndex()
   FErase( cNtxTmp )
   DbCreateIndex( cNtxTmp, "ORDPAGO", { || ORDPAGO }, .f. )
   //DbCreateIndex( cNtxTmp, "ORDPAGO+TIPODOC+NRODOC", { || ORDPAGO+TIPODOC+NRODOC }, .f. )
   DbGoTop()   

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
         nRecNoEK   := RecNo()             
		 
         DbSetOrder( 1 )
         DbSeek( xFilial( "SEK" ) + ALLTRIM(cOrdPago) )

         WHILE !EoF() .AND. EK_FILIAL == xFilial( "SEK" ) .AND. ;
            EK_ORDPAGO == ALLTRIM(cOrdPago)
      
            IF EK_TIPODOC $ "EF-CP-CT-TF-RG-RI-RB" .AND. SEK->EK_TIPO <> 'SU-' //USEKAGREGO .AND. SEK->EK_TIPO <> 'SU-'
               TRB->( DbAppend() )       
               
               TRB->TIPO  	 := "1"
               TRB->ORDPAGO  := SEK->EK_ORDPAGO
               TRB->MOVBAN   := ""
               TRB->TIPODOC  := If( SEK->EK_TIPODOC != 'RG', SEK->EK_TIPODOC, Left( SEK->EK_TIPO, 2 ) )
               TRB->NRODOC   := SEK->EK_NUM
               TRB->FECHA    := dFecha
               TRB->CODPROV  := SEK->EK_FORNECE 
               Do Case
               		Case SEK->EK_TIPO == 'IB-'
   	    	   			TRB->VALOR 	 := xValor( xRetSFE(SEK->EK_ORDPAGO,"B"), SEK->EK_DTDIGIT, Val( EK_MOEDA ), Round( EK_VLMOED1 /xRetSFE(SEK->EK_ORDPAGO,"B"), 4 ) )
   	    	  		Case SEK->EK_TIPO == 'IV-'
   	    	   			TRB->VALOR 	 := xValor( xRetSFE(SEK->EK_ORDPAGO,"I"), SEK->EK_DTDIGIT, Val( EK_MOEDA ), Round( EK_VLMOED1 /xRetSFE(SEK->EK_ORDPAGO,"I"), 4 ) )
   	    	   		Case SEK->EK_TIPO == 'GN-'
   	    	   			TRB->VALOR 	 := xValor( xRetSFE(SEK->EK_ORDPAGO,"G"), SEK->EK_DTDIGIT, Val( EK_MOEDA ), Round( EK_VLMOED1 /xRetSFE(SEK->EK_ORDPAGO,"G"), 4 ) )
	   	    	   	Otherwise
   	    	   			TRB->VALOR 	 := xValor( EK_VALOR, SEK->EK_DTDIGIT, Val( EK_MOEDA ), Round( EK_VLMOED1 / EK_VALOR, 4 ) )
   	    	   EndCase  
	           TRB->ANULADO  := IIF(SEK->EK_CANCEL,"S"," ")
               TRB->MODELO   := IIF(lNaturez, SEK->EK_NATUREZ, Space(10) )
               TRB->RETIIBB  := "B"
            Else 
               IF SEK->EK_TIPO == 'SU-'
                  TRB->( DbAppend() )                   
                  TRB->TIPO  := '2'
                  TRB->ORDPAGO  := SEK->EK_ORDPAGO
                  TBR->MOVBAN	:=''
                  TRB->TIPODOC  := "SU"
                  TRB->NRODOC   := SEK->EK_NUM
                  TRB->FECHA    := dFecha
                  TRB->CODPROV  := SEK->EK_FORNECE 
   	    	      TRB->VALOR 	 := xValor( xRetSFE(SEK->EK_ORDPAGO,"S"), SEK->EK_DTDIGIT, Val( EK_MOEDA ), Round( EK_VLMOED1 /xRetSFE(SEK->EK_ORDPAGO,"S"), 4 ) )
	              TRB->ANULADO  := IIF(SEK->EK_CANCEL,"S"," ")
                  TRB->MODELO   := IIF(lNaturez, SEK->EK_NATUREZ, Space(10) )
                  TRB->RETIIBB  := "B"
               ENDiF
                             
            ENDIF
	        DbSelectArea( "SEK" )

            DbSkip()
         ENDDO

         DbSetOrder( 3 )
         DbGoTo( nRecNoEK )
      ELSE
         DbSelectArea( "SEK" )
		EndIF

      DbSkip()

   ENDDO                  
   

   DbSelectArea( "TRB" )
   DbClearIndex()
   FErase( cNtxTmp )
   DbCreateIndex( cNtxTmp, "ORDPAGO+TIPODOC+NRODOC", { || ORDPAGO+TIPODOC+NRODOC }, .f. )
   DbGoTop()

   nTope:=Getnewpar("MV_TOPPAGO",200)

   nORDPAGO := Val(ORDPAGO)
   cORDPAGO := ORDPAGO
   DbSkip()
   WHILE !EoF() 

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
         nRecNoEK:=recno()
         dFecha  := FECHA
         Reclock("TRB",.T.)
         TRB->ORDPAGO := StrZERO(nDesde,6)
         TRB->CODPROV := StrZERO(nHasta,6)
         TRB->FECHA   := dFecha
         TRB->ANULADO := "X"
         MsUnLock()
         DbGoTo( nRecNoEK )
         nORDPAGO := Val(ORDPAGO)
         cORDPAGO := ORDPAGO
      EndIf
      DbSkip()
   Enddo
   
   DbSelectArea( "TRB" )
   DbClearIndex()
   FErase( cNtxTmp )
   DbCreateIndex( cNtxTmp, "MOVBAN+NRODOC", { || MOVBAN+NRODOC }, .f. )
   DbGoTop()

   nTope:=Getnewpar("MV_TOPPAGO",200)

   nmovban := Val(MOVBAN)
   cmovban := MOVBAN
   DbSkip()
   WHILE !EoF() .AND. !Empty(MOVBAN)

      If Val(MOVBAN) == ( nmovban + 1 )
         nmovban := Val(MOVBAN)
         cmovban := MOVBAN
      Else
         nDesde := nORDPAGO+1
         nHasta := Val(MOVBAN) - 1
         If ( nHasta - nDesde ) > nTope
            nmovban := Val(MOVBAN)
            cmovban := MOVBAN
            DbSkip()
			Loop
         EndIf
         nRecNoE5:=recno()
         dFecha  := FECHA
         Reclock("TRB",.T.)
         TRB->MOVBAN  := StrZERO(nDesde,6)
         TRB->CODPROV := StrZERO(nHasta,6)
         TRB->FECHA   := dFecha
         TRB->ANULADO := "X"
         MsUnLock()
         DbGoTo( nRecNoE5 )
         nmovban := Val(MOVBAN)
         cmovban := MOVBAN
      EndIf
      DbSkip()
   Enddo


   DbClearIndex()
   FErase( cNtxTmp )
   DbCreateIndex( cNtxTmp, "DTOS(FECHA)+ORDPAGO+NRODOC", { || DTOS(FECHA)+ORDPAGO+NRODOC }, .f. )
   SetRegua( RecCount() + 1 )
   
   
   DbGoTop()

   WHILE !EoF() 
   If Empty(ORDPAGO) .Or. ALLTRIM(ORDPAGO)=="."
   		DbSkip()
   		Loop
   EndIf
      cOrdPago  := ORDPAGO
      cMovban   := MOVBAN
      dFecha    := FECHA
      cCodProv  := CODPROV
      cModelo   := MODELO
      cAnulado  := ANULADO
      cTIPO1	:= TIPO
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
      cNumDoc := " "
      
      WHILE !EoF() .AND. ORDPAGO == ALLTRIM(cOrdPago) .AND. TIPO=="1"
      
      	If cNumDoc == " " .Or. cNumDoc <> NRODOC
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
	               MsgStop( "La Orden de Pago: " + ALLTRIM(cOrdPago) + " tiene problemas", "ERROR" )
	            ENDIF
	         ENDIF                                 
    	     cNumDoc := NRODOC
        EndIf
      
        DbSkip()
        IncRegua()

      ENDDO 

      If ( mv_par04 == 1 .OR. ( mv_par04 == 2 .AND. cANULADO == " " ) .OR. ( mv_par04 == 3 .AND. cANULADO == "S" ) ;
         .OR. ( mv_par04 == 4 .AND. cANULADO == "X" ) )

         nTOTAL  := nCHQ + nEFE + nTRF + nRETGAN + nRETIVA + nRETIBG + nRETIBC + nRETSUS + nRETSLI + nRETSSI

         DbSelectArea( "SA2" )
         DbSeek( xFilial( "SA2") + cCodProv )

         IF mv_par03 < 2
            PrintHead()
            PrintItem()
         ENDIF
      EndIf
	  
	  DbSelectArea( "TRB" )
	  DbSkip()
      IncRegua()
      
ENDDO

   DbClearIndex()
   FErase( cNtxTmp )
   DbCreateIndex( cNtxTmp, "MOVBAN+NRODOC", { || MOVBAN+NRODOC }, .f. )
   SetRegua( RecCount() + 1 )
   
   DbGoTop()

WHILE !EoF()
   If Empty(MOVBAN)
   		DbSkip()
   		Loop
   EndIf 
      cOrdPago  := ORDPAGO
      cMovban   := MOVBAN
      dFecha    := FECHA
      cCodProv  := CODPROV
      cModelo   := MODELO
      cAnulado  := ANULADO
      cTIPO1	:= TIPO
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
      cNumDoc := " "

      WHILE !EoF() .AND. MOVBAN == ALLTRIM(MOVBAN) .AND. TIPO=="2"
      
      If TIPO=="2"             
      		IF NRODOC == "P"
    	       nCHQ    := nCHQ + VALOR
	        ENDIF
      EndIf
        DbSkip()
        IncRegua()

      ENDDO   
      
      If ( mv_par04 == 1 .OR. ( mv_par04 == 2 .AND. cANULADO == " " ) .OR. ( mv_par04 == 3 .AND. cANULADO == "S" ) ;
         .OR. ( mv_par04 == 4 .AND. cANULADO == "X" ) )

         nTOTAL  := nCHQ + nEFE + nTRF + nRETGAN + nRETIVA + nRETIBG + nRETIBC + nRETSUS + nRETSLI + nRETSSI

         DbSelectArea( "SA2" )
         DbSeek( xFilial( "SA2") + cCodProv )

         IF mv_par03 < 2
            PrintHead()
            PrintItem()
         ENDIF
      EndIf
      
      DbSelectArea( "TRB" )
      DbSkip()
	  IncRegua()

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

   IF nLine >= BOTTOMPAGE .OR. nLine1 >= BOTTOMPAGE .OR. nLine2 >= BOTTOMPAGE
   
     _cCabec1 := ""
     _cCabec2 := ""

    Cabec( _cTitulo + ' - ' + Capital(GetMv('MV_MOEDA'+Str(mv_par07,1,0)))+ " Desde "+DTOC(MV_PAR01)+ " Hasta " +DTOC (MV_PAR02), _cCabec1, _Ccabec2, _cNomeProg, _cTamanho, 18 )

      nLine  := 10

   ENDIF

RETURN NIL

Static FUNCTION PrintItem()  
LOCAL nRecSEK := RecNo(), ; 
nRecSE5      := RecNo(), ;
nLeftPanel   := nLine, ;
lHistSer     := .f., ;
nFactu       := 0, ;
cHistoryOp   := Space(0) //Sergio
cDescon  	 := Space(0)
ntipoc       := 1


DbSelectArea( "SA2" )
DbSetOrder( 1 )
DbSelectArea( "SA6" )
DbSetOrder( 1 )
DbSelectArea( "SED" )
DbSetOrder( 1 )
DbSelectArea( "SYA" )
DbSetOrder( 1 )

If cAnulado != "X" .AND. cTIPO1=='1'               
      @ nLine,  00 PSAY "Orden de pago: "+ALLTRIM(cOrdPago)    
      @ nLine,  30 PSAY "Proveedor: " + Left( AllTrim( SA2->A2_NOME ), 30 )+"("+cCodProv+")"
      @ nLine, 100 PSAY "Total: " 
      @ nLine, 150 PSAY nTOTAL   PICTURE "9999999.99" // 174
	  @ nLine, 180 PSAY "Fecha: " + DToC(dFecha)
      nLine1 := nLine + 1 
      nLine2 := nLine + 1
DbSelectArea( "SEK" )
DbSetOrder( 1 )
DbSeek( xFilial("SEK") + ALLTRIM(cOrdPago), .t. )

WHILE ( SEK->EK_FILIAL + SEK->EK_ORDPAGO ) == xFilial("SEK")+ALLTRIM(cOrdPago)

	If SEK->EK_TIPODOC $ "TB"
		SE2->(dbClearFilter())
		SE2->(dbSeek( xFilial("SE2") + SEK->EK_PREFIXO + SEK->EK_NUM + SEK->EK_PARCELA + SEK->EK_TIPO + SEK->EK_FORNECE + SEK->EK_LOJA, .F. ))
	
		If alltrim(SEK->EK_TIPO) == "NF" .and. SEK->EK_MOEDA == "2"
			ntipoc := EK_TXMOE02//(SEK->EK_VLMOED1/SEK->EK_VALOR)
		ElseIf alltrim(SEK->EK_TIPO) == "NF" .and. SEK->EK_MOEDA == "3"
			ntipoc := EK_TXMOE03
		ElseIf alltrim(SEK->EK_TIPO) == "NF" .and. SEK->EK_MOEDA == "4"
			ntipoc := EK_TXMOE04
		Endif
		
		//Sergio
		If SE2->E2_TIPO $ "NF -FT " .AND. ALLTRIM( SE2->E2_ORIGEM ) == "FINA050"
			If nFactu == 0 .AND. !EMPTY( SE2->E2_HIST )
				cHistoryOp := UPPER( ALLTRIM( SE2->E2_HIST ) )
				nFactu     := nFactu + 1
				lHistSer   := .t.
			Else
				lHistSer := .f.
			EndIf
		EndIf
		
		@ nLine1,  0 PSAY SEK->EK_TIPO + " " +Left( SEK->EK_NUM, 4 ) + "-" + Right( SEK->EK_NUM, 8 )
		@ nLine1,  30 PSAY PADL( Iif(SE2->E2_MOEDA == 1," $ "," U$S")+AllTrim( TransForm( (SEK->EK_VALOR*TraeSigno(SE2->E2_TIPO)),PesqPict("SEK","EK_VALOR"))),13," ")

		nLine1 := nLine1+1
		nImpComp := nImpComp + SE2->E2_VALOR
		If SE2->E2_MOEDA == 2
			nSalComp2 := nSalComp2 + (SEK->EK_VALOR*TraeSigno(SE2->E2_TIPO))
		Else
			nSalComp1 := nSalComp1 + (SEK->EK_VALOR*TraeSigno(SE2->E2_TIPO))
		EndIf
		DbSkip()
/*	ElseIf SEK->EK_TIPODOC == "CT" .AND. ALLTRIM(SEK->EK_TIPO) == "CH"
		If Val( SEK->EK_MOEDA ) = 1
			cMoneda := "$"
		ElseIf Val( SEK->EK_MOEDA ) = 2
			cMoneda := "U$S"
		EndIf
		SA6->( dbSeek( xFilial( "SA6" ) + SEK->EK_BANCO + SEK->EK_AGENCIA + SEK->EK_CONTA, .F. ) )
		cDescBco := Alltrim(SA6->A6_NREDUZ)+ "-"+ SEK->EK_TIPO
		cDescBco := cDescBco + Space( 20 - Len( cDescBco ) )
		cDescBco := Left( cDescBco, 20 )
		
			@ nLine2,  70  PSAY  "Ch. "+ALLTRIM(SEK->EK_NUM) +"- CUIT: "+ALLTRIM(posicione("SA2",1,xFilial("SA2")+SEK->EK_FORNECE+SEK->EK_LOJA,"A2_CGC"))
			@ nLine2,  100 PSAY  PADL( cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ), 15, " " )
			nLine2 := nLine2+1
			nCHAdLis += 1
			If Val( SEK->EK_MOEDA ) = 2
				nCHValor2 += SEK->EK_VALOR
			Else
				nCHValor1 += SEK->EK_VALOR
			EndIf			
			DbSkip()*/
	ElseIf SEK->EK_TIPODOC $ "CP-CT-RG-RI-RB"
		If Val( SEK->EK_MOEDA ) = 1
			cMoneda := "$"
		ElseIf Val( SEK->EK_MOEDA ) = 2
			cMoneda := "U$S"
		EndIf
		SA6->( dbSeek( xFilial( "SA6" ) + SEK->EK_BANCO + SEK->EK_AGENCIA + SEK->EK_CONTA, .F. ) )
		cDescBco := Alltrim(SA6->A6_NREDUZ)+ "-"+ SEK->EK_TIPO
		cDescBco := cDescBco + Space( 20 - Len( cDescBco ) )
		cDescBco := Left( cDescBco, 20 )
		
		If ALLTRIM(SEK->EK_TIPODOC) == "EF"
			@ nLine2,  70  PSAY "E F E C T I V O"
			@ nLine2,  100 PSAY PADL( cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ), 15, " " )
			nLine2 := nLine2+1
			nCHAdLis += 1
		ElseIf ALLTRIM(SEK->EK_TIPODOC) == "TF"
			@ nLine2,  70  PSAY "T R A N S F E R E N C I A"
			@ nLine2,  100 PSAY PADL( cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ), 15, " " )
			nLine2 := nLine2+1
			nCHAdLis += 1
		ElseIf ALLTRIM(SEK->EK_TIPODOC) == "RG"  .and. SEK->EK_TIPO = "IV-" .and.  (SEK->EK_VALOR > 0 .or. SEK->EK_VALOR< 0)   
			@ nLine2,  70  PSAY "RETENCION I.V.A."
			@ nLine2,  100 PSAY PADL( cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ), 15, " " )
			nLine2 := nLine2+1
			nCHAdLis += 1
		ElseIf ALLTRIM(SEK->EK_TIPODOC) == "RG" .and. SEK->EK_TIPO = "GN-" .and.  (SEK->EK_VALOR > 0 .or. SEK->EK_VALOR< 0)   // Se agreg�   "SEK->EK_VALOR< 0" para las retenciones de NCP.
			@ nLine2,  70  PSAY "RETENCION GANANCIAS"
			@ nLine2,  100 PSAY PADL( cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) )), 15, " " )
			nLine2 := nLine2+1
			nCHAdLis += 1
		ElseIf ALLTRIM(SEK->EK_TIPODOC) == "RG" .and. SEK->EK_TIPO = "IB-" .and. (SEK->EK_VALOR > 0 .or. SEK->EK_VALOR< 0)   // Se agreg�   "SEK->EK_VALOR< 0" para las retenciones de NCP.
			@ nLine2,  70  PSAY  "RETENCION I.I.B.B. "+SEK->EK_EST
			@ nLine2,  100 PSAY  PADL( cMoneda +" "+ AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) )), 15, " " )
			nLine2 := nLine2+1
			nCHAdLis += 1
		ElseIf ALLTRIM(SEK->EK_TIPODOC) == "RG"  .and. SEK->EK_TIPO = "SU-" .and.(SEK->EK_VALOR > 0 .or. SEK->EK_VALOR< 0)
			@ nLine2,  70  PSAY  "RETENCION S.U.S.S."
			@ nLine2,  100 PSAY  PADL( cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ), 15, " " )
			nLine2 := nLine2+1
			nCHAdLis += 1
		ElseIf ALLTRIM(SEK->EK_TIPODOC) == "RG"  .and. SEK->EK_TIPO = "SL-" .and.  (SEK->EK_VALOR > 0 .or. SEK->EK_VALOR< 0)   // Se agreg�   "SEK->EK_VALOR< 0" para las retenciones de NCP.
			@ nLine2,  70  PSAY  "RET. - RG 1556/2003"
			@ nLine2,  100 PSAY  PADL( cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ), 15, " " )
			nLine2 := nLine2+1
			nCHAdLis += 1 
		ElseIf ALLTRIM(SEK->EK_TIPODOC) == "CP"  .and. ALLTRIM(SEK->EK_TIPO) = "TF" .and.  (SEK->EK_VALOR > 0 .or. SEK->EK_VALOR< 0)   // Se agreg�   "SEK->EK_VALOR< 0" para las retenciones de NCP.
			@ nLine2,  70  PSAY  cDescBco
			@ nLine2,  100 PSAY  PADL( cMoneda +" "+AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ), 15, " " )
			nLine2 := nLine2+1
			nCHAdLis += 1

		EndIf
		If Val( SEK->EK_MOEDA ) = 2
			nTotVal2 := nTotVal2 + SEK->EK_VALOR
		Else
			nTotVal1 := nTotVal1 + SEK->EK_VALOR
		EndIf       
		DbSkip()
	Else
		DbSkip()
	EndIf
	DbSkip()
ENDDO           
DbSelectArea( "SEK" )
DbSetOrder( 1 )
DbGoTo( Recno() )
	If nLine1>=nLine2
		@ nLine1,  00 PSAY Replicate( '-', 220 )
		nLine := nLine1 + 1
	ElseIf nLine2>nLine1    
		@ nLine2,  00 PSAY Replicate( '-', 220 )
		nLine := nLine2 + 1
	EndIf

ElseIf cAnulado != "X" .AND. cTIPO1=='2'
      @ nLine,  00 PSAY "Movimiento: "+ALLTRIM(cMovBan)    
      @ nLine,  50 PSAY "Egresos Varios: Movimientos de Fondo"
      @ nLine, 100 PSAY "Total: " 
      @ nLine, 150 PSAY nTOTAL   PICTURE "9999999.99" // 174
      @ nLine, 180 PSAY "Fecha: " + DToC(dFecha)
	  nLine1 := nLine + 1 
      nLine2 := nLine + 1      

DbSelectArea( "SE5" )
DbSetOrder( 15 )
DbSeek( xFilial("SE5") + ALLTRIM(cMovBan), .t. )

WHILE ( SE5->E5_FILIAL + SE5->E5_PROCTRA ) == xFilial("SE5")+ALLTRIM(cMovBan)
	cMoneda := "$"
	If SE5->E5_RECPAG == "R"   
		@ nLine1,  0 PSAY SE5->E5_HISTOR //+ " " +Left( SE5->E5_NUM, 4 ) + "-" + Right( SE5->E5_NUM, 8 )
		@ nLine1,  30 PSAY PADL( cMoneda +" "+AllTrim( TransForm( SE5->E5_VALOR, PesqPict( "SE5", "E5_VALOR" ) ) ), 15, " " )
		nLine1 := nLine1+1
	ElseIf SE5->E5_RECPAG == "P"
		SA6->( dbSeek( xFilial( "SA6" ) + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA, .F. ) )
		cDescBco := Alltrim(SA6->A6_NREDUZ)+ "-"+ SE5->E5_TIPODOC                                 //SINTYA 1
		cDescBco := cDescBco + Space( 20 - Len( cDescBco ) )
		cDescBco := Left( cDescBco, 20 )
		If (SE5->E5_VALOR > 0 .or. SE5->E5_VALOR< 0)   // Se agreg�   "SEK->EK_VALOR< 0" para las retenciones de NCP.
			@ nLine2,  70  PSAY  cDescBco +"-"+SE5->E5_NATUREZ+"-"+SE5->E5_HISTOR
			@ nLine2,  150 PSAY  PADL( cMoneda +" "+AllTrim( TransForm( SE5->E5_VALOR, PesqPict( "SE5", "E5_VALOR" ) ) ), 15, " " )
			nLine2 := nLine2+1
		EndIf
	EndIf
	DbSkip()
ENDDO
		DbSelectArea( "SE5" )
		DbSetOrder( 15 )
		DbGoTo( Recno() )
		If nLine1>=nLine2
      		@ nLine1,  00 PSAY Replicate( '-', 220 )
   			nLine := nLine1 + 1
   		ElseIf nLine2>nLine1    
      		@ nLine2,  00 PSAY Replicate( '-', 220 )
   			nLine := nLine2 + 1
   		EndIf
Else
		DbSkip()
		DbSelectArea( "SEK" )
		DbSetOrder( 1 )
		DbGoTo( Recno() ) 
EndIf
  // nLine := nLine + 1

RETURN NIL

Static FUNCTION PrintTotal()
/*
   @ nLine,  00 PSAY Replicate( '-', 220 )
   nLine := nLine + 1

//   @ nLine,  00 PSAY "TOTALES GENERALES:"
   nLine := nLine + 1

   @ nLine,  00 PSAY Replicate( '-', 220 ) + Chr( 12 )
   nLine++
   @ nLine,  00 PSAY ' '
*/
RETURN NIL

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑unci줻     � xValor   � Autor � Diego F. Rivero     � Data � 16.12.99 낢�
굇쳐컴컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escripci줻 � Calcula el valor convertido segun los par쟭etros         낢�
굇쳐컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso        � FIND13X                                                  낢�
굇읕컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
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

If ValType( nMoeOri ) != 'N' .or. nMoeOri < 1 .or. nMoeOri > 5
   MsgAlert( 'Existen registros con la moneda informada erroneamente!', 'Verificar Datos' )
   Return( 0 )
EndIf

SM2->(DbSetOrder(1))

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Si la moneda del documento es la misma que la pedida en el   �
//� informe, o si el Tipo de Movimiento pedido es Solo Movi-     �
//� mientos en moneda...                                         �
//� Retorno el mismo valor del Documento                         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If ( Round( nMoeOri, 0 ) == Round( nMoneda, 0 ) ) .or. ( nTipoMov == 1 )
   RestArea( aSM2 )
   RestArea( aArea )
   Return( nValor )
EndIf

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Si la moneda del Documento es 1, dejo establezco que la tasa �
//� es 1, sino, busco la tasa teniendo en cuenta si es Hist줿ica �
//� o Actual                                                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Si la moneda del Informe es 1, dejo establezco que la tasa   �
//� es 1, sino, busco la tasa teniendo en cuenta si es Hist줿ica �
//� o Actual                                                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑unci줻     � VLDPERG  � Autor � Ariel A. Musumeci   � Data � 16.12.99 낢�
굇쳐컴컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escripci줻 � Validaci줻 de SX1 para KARDEX1                           낢�
굇쳐컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso        � KARDEX01                                                 낢�
굇읕컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
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
aAdD(aRegs,{cPerg,"09","Usar Tasa      ","Usar Tasa      ","Usar Tasa      ","mv_ch9","N", 1,0,0,"C","","mv_par09","Actual","Actual","Actual","" ,"","Hist줿ica","Hist줿ica","Hist줿ica","","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"","",""     ,""     ,""     ,"",""   ,'','' } )

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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑unci줻     � TIPO DE RETIIBB� Autor � EK            � Data � 18.11.05 낢�
굇쳐컴컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escripci줻 � TIPO DE RETIIBB GRAL Y CONSTRUCCION                      낢�
굇쳐컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso        � 				                                               낢�
굇읕컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇�3굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑unci줻     � Retencion de SUSS� Autor � EK           � Data � 20.06.06낢�
굇쳐컴컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escripci줻 � Para buscar en la tabla SFE retenciones de SUSS que no   낢�
굇�											grava en SFE                  낢�
굇쳐컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso        � 				                                          낢�
굇읕컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇�3굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
/*/
Static Function xRetSFE(cOrdPago,cTipo)
                       
Local nRet 	  := 0
Local aArea   := GetArea()

cQuery := "SELECT SUM(FE_RETENC) AS RETENC "
cQuery += " FROM " + RETSQLNAME('SFE') + " SFE "
cQuery +=" WHERE FE_ORDPAGO= '" + cOrdPago + "' AND FE_TIPO= '" + cTipo + "' "
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
                                                             

// Funcion para traer el signo de los documentos Cancelados

Static Function TraeSigno( cTipo )
Local aArea := GetArea(),;
nRet  := 1

DbSelectAreA( 'SES' )
DbSetOrder(1)
If DbSeek( xFilial( ) + cTipo )
	If ES_SINAL == '-'
		nRet  := -1
	EndIf
EndIf

RestArea( aArea )

Return( nRet )