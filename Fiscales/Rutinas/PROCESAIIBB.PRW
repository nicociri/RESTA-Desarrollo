#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ProcesaIIBB บAutor  ณMC               บFecha ณ  30/03/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Procesa a partir de un archivo TXT generado por la AFIP   บฑฑ
ฑฑบ          ณ  actualizando las alicuotas de percep. / retenciones en 	  บฑฑ
ฑฑบ				la tabla SFH                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP Exclusivo PWA                                      	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION ProcesaIIBB()
Local aArea    := GetArea()

PRIVATE oDlg	:= Nil ,;  // objeto de dialogo
        oFld 	:= Nil ,;  // objeto folder 1   
        oCombo	:= NIL ,;   // objeto combo
        ochk  	:= Nil ,;   // objeto ckeck-up
        oProcess:= NIL ,;   // objeto procesando..
        cCombo  := space(13),;
        cImpos	:= space(20),;
        lChk    := .T.,;
        lChk1   := .T.,;
        cPath	:= "C:\",;
        cPathNom:= "LOGIB.TXT",;
        cFileLog:= cPath + cPathNom,;
        lEnd 	:= .F.,;
		lBtn1	:= .F.,;
		lBtn2	:= .F.,;
		nOpc	:= 0
		      

RptStatus( { || SelectOpt() } )

Ms_Flush()

RestArea( aArea )
RETURN nil

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION SelectOpt()

local nOpca		:= 0
Local aCombo  	:= {} 
Local cAtencao:= "Atencion"

//+---------------------------
//| Matriz Maestro a Procesar
//+---------------------------
aAdd( aCombo, "Proveedores" )
aAdd( aCombo, "Clientes" )
aAdd( aCombo, "Ambos" )

//+----------------
//| Objeto Dialogo
//+----------------
DEFINE MSDIALOG oDlg TITLE "Nueva Resolucion para IIBB - Prov. Buenos Aires (BA)" FROM 0,0 TO 250,420 OF oDlg PIXEL
 
@ 06,06 TO 40,168 LABEL "Info. Preliminar" OF oDlg PIXEL

@ 11,10  SAY "Maestro :"     									SIZE  65,8 	PIXEL OF oFld
@ 11,38  COMBOBOX oCombo VAR cCombo ITEMS aCombo 				SIZE  65,8 	PIXEL OF oFld   ON CHANGE ValidChk()

//+----------------------
//| Campos Check-Up
//+----------------------
@ 10,115 SAY "Impuesto: "										SIZE  65,8 	PIXEL OF oFld
@ 20,115 CHECKBOX oChk VAR lChk PROMPT "Percepcion" 			SIZE 40,8 PIXEL OF oFld ;
         ON CHANGE ValidChk()
@ 30,115 CHECKBOX oChk VAR lChk1 PROMPT "Retencion" 			SIZE 40,8 PIXEL OF oFld ;
         ON CHANGE ValidChk()

@ 41,06 FOLDER oFld OF oDlg PROMPT "&Actualiza Empresa Vs Zona Fiscal","&Actualiza Alicuota" PIXEL SIZE 160,078

//+---------------
//| Campos Folder 1
//+---------------
@ 10,05 SAY "Esta Opcion actualizara la Tabla Empresa Vs  "		SIZE 150,8	PIXEL OF oFld:aDialogs[1]
@ 20,05 SAY "Zona Fiscal, agregando aquellos Proved/Clie  "		SIZE 150,8 	PIXEL OF oFld:aDialogs[1]
@ 30,05 SAY "no cadastrados."     								SIZE 150,8 	PIXEL OF oFld:aDialogs[1]
 
//+----------------------------------------------------------------------------
//| Boton de aDialog[1]
//+----------------------------------------------------------------------------
DEFINE SBUTTON FROM  24, 120 TYPE  1 ACTION (nOpc:=1,Proces1()) ENABLE OF oFld:aDialogs[1]

//+----------------
//| Campos Folder 2
//+----------------
@ 10, 05 SAY "Esta Opcion actualizara las alicuotas Prov "	SIZE  150, 8 PIXEL OF oFld:aDialogs[2]
@ 20, 05 SAY "y/o Clien que se encuentren cadastrados en "	SIZE  150, 8 PIXEL OF oFld:aDialogs[2]
@ 30, 05 SAY "la tabla Empresa Vs Z. Fiscal considerando "	SIZE  150, 8 PIXEL OF oFld:aDialogs[2]
@ 40, 05 SAY "archivo generado por la AFIP"					SIZE  150, 8 PIXEL OF oFld:aDialogs[2]

//+----------------------------------------------------------------------------
//| Boton de aDialog[2]
//+----------------------------------------------------------------------------
DEFINE SBUTTON FROM  24, 120 TYPE  1 ACTION (nOpc:=2,LeeArTxt()) ENABLE OF oFld:aDialogs[2]

//+-------------------
//| Boton de MSDialog
//+-------------------
@ 60,170 BUTTON "&Salir" SIZE 36,16 PIXEL ACTION oDlg:End()
@ 80,170 BUTTON "&Resumen" SIZE 36,16 PIXEL ACTION IIF(nOpc==1.OR.nOpc==2,verResu(),nOpc:=0)
                         

ACTIVATE MSDIALOG oDlg CENTER

RETURN


///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | SelectOpt()  		 | AUTOR | MC		    | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Proces1()                                              |//
//|           | Actualiza la Tabla SFH segun Maestro Cliente/proveedor          |//
//|           | 											                    |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function Proces1()

lBtn1:=.T.
lBtn2:=.F.

MsAguarde({|lEnd| RunProc1(@lEnd)},"Aguarde...","Processando " + cCombo,.T.)
Return Nil

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Proces1()    | AUTOR | MC		  | DATA 		   | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - RunProc1()                                             |//
//|           | Funcao de processamento							                |//
//|           |                                          						|//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function RunProc1(lEnd,oObj)
                   
Local nCnt	:= 0
Local cNome:=space(30)


// borro resumen anterior
IF File(cFileLog)
	Ferase(cFileLog)
Endif


IF cCombo=="Clientes" .or. cCombo=="Ambos"

	
	IF lChk	// Check percepcion
	
		DbSelectArea ("SA1")
		DbSetOrder (1)
		DbGoTop ()

		DbSelectArea ("SFH")
		DbSetOrder (3)
				
		While SA1->(!Eof()) 
			
			If lEnd
      			MsgInfo(cCancel,"Fin")
      			Exit
   			Endif
   		   			
   			cNome:=SA1->A1_NOME
   			MsProcTxt("Cliente: "+Left(SA1->A1_NOME,1,30))
						
			If !SFH->(DbSeek (xFilial("SFH")+SA1->A1_COD+SA1->A1_LOJA+"IB2"+"BA"))
				RecLock("SFH", .T. )
				SFH->FH_FILIAL	:=  xFilial("SFH")
				SFH->FH_AGENTE	:= "S"
				SFH->FH_ZONFIS	:= "BA"
				SFH->FH_CLIENTE	:= SA1->A1_COD
				SFH->FH_LOJA	:= SA1->A1_LOJA
				SFH->FH_NOME	:= SA1->A1_NOME
				SFH->FH_IMPOSTO	:= "IB2"	
				SFH->FH_PERCIBI	:= "S"	
				SFH->FH_ISENTO	:= "S"
				SFH->FH_PERCENT	:= 0
				SFH->FH_APERIB	:= "S"
				SFH->FH_ALIQ	:= 0
				SFH->FH_COEFMUL	:= 0
				MsUnlock()		
				nCnt +=1
				AddArchResu(IIF(lBtn1,"AGREGA CLIENTE","MODIF.ALICUOTA"),+;
						SFH->FH_IMPOSTO,SFH->FH_ZONFIS,STR(SFH->FH_ALIQ,5,2),Substr(cNome,1,20))
			EndIf
			
			SA1->(DbSkip())
	
		EndDo
		
	Endif

Endif


IF cCombo=="Proveedores" .or. cCombo=="Ambos"
		
	DbSelectArea ("SA2")
	DbSetOrder (1)
	
	DbSelectArea ("SFH")
	DbSetOrder (1) // FILIAL + PROVEED + LOJA + IMPOSTO + ZONA FISCAL
				
	IF lChk1	// Check Retencion
	
		DbSelectArea ("SFH")
		Set Filter To
		Set Filter To FH_IMPOSTO=="IBR"
					
		SA2->(DbGoTop ())
    		
		While SA2->(!Eof())  
		
			IF SA2->A2_RETIB=='N'
		 	  SA2->(DbSkip())
		 	  loop
			ENDIF
		
			If lEnd
      			MsgInfo(cCancel,"Fin")
      			Exit
   			Endif                                         
   		
   			cNome:=SA2->A2_NOME
   		
   			MsProcTxt("Proveedor: "+Left(cNome,1,30))
   			
   			
   			If !SFH->(DbSeek(xFilial("SFH")+SA2->A2_COD+SA2->A2_LOJA+"IBR"+"BA"))
				
				RecLock("SFH", .T. )
				SFH->FH_FILIAL		:= xFilial("SFH")
				SFH->FH_AGENTE		:= "N"
				SFH->FH_ZONFIS		:= "BA"
				SFH->FH_FORNECE		:= SA2->A2_COD
				SFH->FH_LOJA		:= SA2->A2_LOJA
				SFH->FH_NOME		:= SA2->A2_NOME
				SFH->FH_IMPOSTO		:= "IBR"	
				SFH->FH_PERCIBI		:= "N"	
				SFH->FH_ISENTO		:= "S"
				SFH->FH_PERCENT		:= 0
				SFH->FH_APERIB		:= "N"
				SFH->FH_ALIQ		:= 0
				SFH->FH_COEFMUL		:= 0
				MsUnlock()		
				nCnt +=1
				AddArchResu	(IIF(lBtn1,"AGREGA PROVEED","MODIF.ALICUOTA"),+;
							SFH->FH_IMPOSTO,SFH->FH_ZONFIS,STR(SFH->FH_ALIQ,5,2),Substr(cNome,1,20))
			EndIf
		    			
			SA2->(DbSkip())
	
		EndDo
					
	Endif
		
	IF lChk	// Check percepcion
	    
		DbSelectArea ("SFH")
		Set Filter To
		Set Filter To FH_IMPOSTO=="IB2"
		
		SA2->(DbGoTop()) 
					
		While SA2->(!Eof()) 
			
			If lEnd
      			MsgInfo(cCancel,"Fin")
      			Exit
   			Endif
   		
   			If SA2->A2_PERCIB=='N'       // AGENTE PERCEPCION
   				SA2->(DbSkip())
   				Loop
   			endif
   		
   			cNome:=SA2->A2_NOME
   			MsProcTxt("Proveed: "+Left(SA2->A2_NOME,1,30))
									
			If !SFH->(DbSeek (xFilial("SFH")+SA2->A2_COD+SA2->A2_LOJA+"IB2"+"BA"))
				
				RecLock("SFH", .T. )
				SFH->FH_FILIAL	:=  xFilial("SFH")
				SFH->FH_AGENTE	:= "S"
				SFH->FH_ZONFIS	:= "BA"
				SFH->FH_FORNECE	:= SA2->A2_COD
				SFH->FH_LOJA	:= SA2->A2_LOJA
				SFH->FH_NOME	:= SA2->A2_NOME
				SFH->FH_IMPOSTO	:= "IB2"	
				SFH->FH_PERCIBI	:= "S"	
				SFH->FH_ISENTO	:= "S"
				SFH->FH_PERCENT	:= 0
				SFH->FH_APERIB	:= "S"
				SFH->FH_ALIQ	:= 0
				SFH->FH_COEFMUL	:= 0
				MsUnlock()		
				nCnt +=1
				AddArchResu(IIF(lBtn1,"AGREGA PROVEED","MODIF.ALICUOTA"),+;
							SFH->FH_IMPOSTO,SFH->FH_ZONFIS,STR(SFH->FH_ALIQ,5,2),Substr(cNome,1,20))
			EndIf
			
			SA2->(DbSkip())
	
		EndDo
				
	Endif

Endif

MsgInfo("Fueron adicionados: " + AllTrim(Str(nCnt))+ " registros",FunName())

SA2->( DbCloseArea() )
SFH->( DbCloseArea() )
	
Return
 
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ProcesaIIBB.prw  | AUTOR | MC	  | DATA 		   | 18/03/2008 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - VerResu()                                              |//
//|           | Muestra archivo Resumen del procesamiento realizado             |//
//|           | 						                                        |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function VerResu()
Local oDlg
Local cMemo
Local cFile    :=""
Local cMask    := "Arquivos Texto (*.TXT) |*.txt|"
Local oFont 

If Empty(cFileLog)
	DEFAULT cFileLog := Criatrab(,.f.)+".LOG"
Endif

DEFINE FONT oFont NAME "Courier New" SIZE 5,0   

cMemo :=MemoRead(cFileLog)
	
DEFINE MSDIALOG oDlg TITLE "Resumen" From 3,0 to 340,417 PIXEL

@ 5,5 GET oMemo  VAR cMemo MEMO SIZE 200,145 OF oDlg PIXEL 
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont

DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Salir
DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,OemToAnsi("Salvar Como...")),If(cFile="",.t.,MemoWrite(cFile,cMemo)),oDlg:End()) ENABLE OF oDlg PIXEL //Salva e Apaga //
	
ACTIVATE MSDIALOG oDlg CENTER



Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ProcesaIIBB.prw  | AUTOR | MC	  | DATA 		   | 18/03/2008 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - VerResu()                                              |//
//|           | Muestra archivo Resumen del procesamiento realizado             |//
//|           | 						                                        |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function AddArchResu(cMotivo,cImposto,cZonaFis,cAlic,cCliFor)

If ! File(cFileLog)
	If (nHandle2 := MSFCreate(cFileLog,0)) == -1
		Return
	EndIf
Else
	If (nHandle2 := FOpen(cFileLog,2)) == -1
		Return
	EndIf
EndIf

FSeek(nHandle2,0,2)
FWrite(nHandle2,cMotivo+space(4)+cImposto+space(4)+cZonaFis+space(4)+cAlic+space(4)+cCliFor+chr(13)+chr(10),85)
FClose(nHandle2)

Return
                               
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ProcesaIIBB.prw     | AUTOR | MC            | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_LeeArTxt()                                          |//
//|           | Fuente usado para importar datos de archivo TXT de la AFIP      |//
//|           | a fin de actualizar alicuota de IB2/IBR                         |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function LeeArTxt()

Local cTitulo1  := "Seleccione Archivo"
Local cExtens   := "Archivo AFIP | *.TXT"
Local cFile 	:= ""

lBtn1:=.F.
lBtn2:=.T.

/***
 * _________________________________________________________
 * cGetFile(<ExpC1>,<ExpC2>,<ExpN1>,<ExpC3>,<ExpL1>,<ExpN2>)
 * ฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏ
 * <ExpC1> - Expressao de filtro
 * <ExpC2> - Titulo da janela
 * <ExpN1> - Numero de mascara default 1 para *.Exe
 * <ExpC3> - Diret๓rio inicial se necessแrio
 * <ExpL1> - .F. botใo salvar - .T. botใo abrir
 * <ExpN2> - Mascara de bits para escolher as op็๕es de visualiza็ใo do objeto (prconst.ch)
 */

cFiles := cGetFile(cExtens,cTitulo1,,,.T.)
 
if (cFiles == "")
  Return
endif  
                        
MsgRun("Leyendo Archivo, Aguarde...","Actualizacion de alicuotas",{|| Import(cFiles)})

Return(nil)              

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | LeeArTxt.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Import()                                               |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao de importacao de dados                                   |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static function Import(cFiles)

Local cFilSFH := xFilial('SFH'),;
      nRec    := 60 + 2,;
      cLine   := Space(nRec),;
      nLen    := 0,;
      nByte   := 0,;
 	  aFields := Array( 0 ),;	     
      aTam 	  := Array( 0 ),;	     
      cNome	  := space(30),;
      cCGC	  := space(11),;
      nCnt	  := 0,;
      nHnd
      
// borro resumen anterior
IF File(cFileLog)
	Ferase(cFileLog)
Endif

aTam := TamSX3("A2_CGC")
AAdd( aFields, { "CGC",aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("FH_ALIQ")
AAdd( aFields, { "PER",aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("FH_ALIQ")
AAdd( aFields, { "RET",aTam[3],aTam[1],aTam[2]})
   
cDbfTmp := CriaTrab( aFields, .t. ) + GetDBExtension()
cNtxTmp := CriaTrab( , .f. ) + OrdBagExt()

IF !Empty( Select( "TRB" ) )
	DbSelectArea( "TRB" )
	DbCloseArea()
ENDIF

FErase( cNtxTmp )

DbUseArea( .T., __cRDDNTTS, cDbfTmp, "TRB", .f., .f. )
DbCreateIndex( cNtxTmp, "CGC", { || CGC }, .f. )
 
/**********************
Estructura Archivo AFIP
-----------------------
0        1         2         3         4         5         6         7         8         9         100
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

21022008;01032008;31032008;20000000028;D;N;S;5,00;1,50;14;09

12345678;  -> FECHA PUBLICACION PADRON
         12345678;  -> FECHA VIGENCIA DESDE      
                  12345678; -> FECHA VIGENCIA HASTA
                           12345678901;  -> CUIT CONTRIBUYENTE
                                       1;  	 -> MARCA TIPO CONTRIB. ("D" o "C")
                                         1; 	  -> MARCA ALTA SUJETOS ("S" o "N")
                                           1;	     -> MARCA CAMBIO ALICUOTA ("S" o "N")
                                             1234;  	    -> ALICUOTA PERCEP EN %
                                                  1234;  	    -> ALICUOTA RETENCION EN %
*/                                                               

DbSelectArea ("TRB")

nHnd := FOpen( cFiles )
nLen := FSeek( nHnd, 0, 2 )
FSeek( nHnd, 0, 0 )

ProcRegua( Int( nLen / Len( cLine ) ) )

While nByte < nLen
   IncProc()

	nRead := FRead( nHnd, @cLine, nRec )
	nByte += nRead

	If nRead == nRec
	
		TRB->( DbAppend() )
	    TRB->CGC	:= SubStr(cLine, 28,11)
	    TRB->PER	:= Val(Replace(SubStr(cLine, 46,4),",","."))
	    TRB->RET	:= Val(Replace(SubStr(cLine, 51,4),",","."))	    
	    
   EndIf

EndDo

FClose( nHnd )

IF cCombo=="Clientes" .or. cCombo=="Ambos"

	DbSelectArea ("SFH")
	DbSetOrder(4)     // FILIAL + IMPOSTO + ZONA FISCAL + CLIENTE + LOJA
	Set Filter to
	Set Filter to FH_CLIENTE!=space(6)	
			
	IF lChk	// Check percepcion
			 
		SFH->(DbSeek(cFilSFH+"IB2"+"BA"))
		While (SFH->(!EOF()) .and. SFH->FH_IMPOSTO == "IB2" .and. SFH->FH_ZONFIS == "BA")
			DbSelectArea("TRB")
			DbSetOrder(1)
			cCGC := Posicione("SA1", 1, xFilial("SA1")+SFH->FH_CLIENTE+SFH->FH_LOJA,"A1_CGC")
			cNome:= Posicione("SA1", 1, xFilial("SA1")+SFH->FH_CLIENTE+SFH->FH_LOJA,"A1_NOME")
			If (TRB->(DbSeek(cCGC)))
				RecLock("SFH", .F. )
				SFH->FH_ALIQ	:= TRB->PER
				If (TRB->PER == 0)
					SFH->FH_ISENTO		:= "S"
				Else
					SFH->FH_ISENTO		:= "N"
				EndIf
				MsUnlock()
				AddArchResu	(IIF(lBtn1,"AGREGA PROVEED","MODIF.ALICUOTA"),+;
						SFH->FH_IMPOSTO,SFH->FH_ZONFIS,STR(SFH->FH_ALIQ,5,2),Substr(cNome,1,20))
				nCnt+=1
			EndIf
			SFH->(DbSkip())
		EndDo
    
    Endif

Endif    

IF cCombo=="Proveedores" .or. cCombo=="Ambos"

	DbSelectArea("TRB")
	DbSetOrder(1)
	
	DbSelectArea ("SFH")
	DbSetOrder(2)     // XFILIAL + IMPOSTO + ZONA FISCAL + FORNECE + LOJA 
	Set Filter to
	Set Filter to FH_FORNECE!=space(6)	
		
	IF lChk1   // Check retencion
				
		SFH->(DbSeek(cFilSFH+"IBR"+"BA"))
		While (SFH->(!EOF()) .and. SFH->FH_IMPOSTO == "IBR" .and. SFH->FH_ZONFIS == "BA")
			
			cCGC := Posicione("SA2", 1, xFilial("SA2")+SFH->FH_FORNECE+SFH->FH_LOJA,"A2_CGC")
			cNome:= ALLTRIM(Posicione("SA2", 1, xFilial("SA2")+SFH->FH_FORNECE+SFH->FH_LOJA,"A2_NOME"))
			
			If (TRB->(DbSeek(cCGC)))
				RecLock("SFH", .F. )
				SFH->FH_ALIQ	:= TRB->RET
				If (TRB->RET == 0)
					SFH->FH_ISENTO		:= "S"
				Else
					SFH->FH_ISENTO		:= "N"
				EndIf
				MsUnlock()
				AddArchResu	(IIF(lBtn1,"AGREGA PROVEED","MODIF.ALICUOTA"),+;
						SFH->FH_IMPOSTO,SFH->FH_ZONFIS,STR(SFH->FH_ALIQ,5,2),Substr(cNome,1,20))
				nCnt+=1
			EndIf
			SFH->(DbSkip())
		
		EndDo
    
    Endif
         
    IF lChk   // Check percepcion
	                             
		SFH->(dbGotop())
		SFH->(DbSeek(cFilSFH+"IB2"+"BA"))
		While (SFH->(!EOF()) .and. SFH->FH_IMPOSTO == "IB2" .and. SFH->FH_ZONFIS == "BA")
			
//			cCGC := Posicione("SA2", 1, xFilial("SA2")+SFH->FH_FORNECE+SFH->FH_LOJA,"A2_CGC")
			CcGC	:= Alltrim(SM0->M0_CGC)
			cNome:= ALLTRIM(Posicione("SA2", 1, xFilial("SA2")+SFH->FH_FORNECE+SFH->FH_LOJA,"A2_NOME"))
			
			If (TRB->(DbSeek(cCGC)))
				RecLock("SFH", .F. )
				SFH->FH_ALIQ	:= TRB->PER
				If (TRB->PER == 0)
					SFH->FH_ISENTO		:= "S"
				Else
					SFH->FH_ISENTO		:= "N"
				EndIf
				MsUnlock()
				AddArchResu	(IIF(lBtn1,"AGREGA PROVEED","MODIF.ALICUOTA"),+;
						SFH->FH_IMPOSTO,SFH->FH_ZONFIS,STR(SFH->FH_ALIQ,5,2),Substr(cNome,1,20))
				nCnt+=1
			EndIf
			SFH->(DbSkip())
		EndDo
    
    Endif
        
Endif

MsgInfo("Fueron Modificados: " + AllTrim(Str(nCnt))+ " registros",FunName())

TRB->(DbCloseArea())
SFH->(DbCloseArea())

Return( nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidChkบAutor  ณMS				     บ Data ณ  12/03/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao p/ Validar Check-up							      บฑฑ
ฑฑบ          ณ 										                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static function ValidChk()

Local lRet:=.T.
	
If lChk1 == .T. .and. cCombo=="Clientes"    // RETENCION
	lChk1 :=.F.
	lRet:=.F.
EndIf

oChk:Refresh()

Return (Lret)


