#include "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ARWISP04 ³ Autor ³Microsiga Argentina    ³ Data ³ 14/08/2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Generaci¢n de Archivo para Retenciones Varias                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Ninguno                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACIONES SUFRUDAS DESDE EL DESARROLLO INICIAL.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DE LA ALTERACION                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³E.H.Caputto   ³15/12/05³      ³Se agragaron condiciones a los while,     ³±±
±±³              ³        ³      ³para evitar la acumulación de bases       ³±±
±±³              ³        ³      ³imponibles cuando el nro de certificado de³±±
±±³              ³        ³      ³retenciones se duplica para distintas ret.³±±
±±³Luis          ³23/02/01³      ³Cambio de Lugar el Close del Archivo ASCII³±±
±±³              ³        ³      ³Agrego cantidad de Caracteres a grabar en ³±±
±±³              ³        ³      ³Function FWRITE                           ³±±
±±³              ³        ³      ³Control de FE_TIPO en Sicore              ³±±
±±³Luis          ³13/07/01³      ³Agrego Rango de Certificados en las pre-  ³±±
±±³              ³        ³      ³guntas.                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
 /*/
User Function ARWISP04

PRIVATE CPATH,CMESANO,CFILE,CGENERA,AGENERA,LOK
PRIVATE LWHEN,LSIGUE,CCUIT,NPUNTERO,NPUNTERO2,CNROCERT,CFORNECE
PRIVATE CLOJA,CFECHA,NRET,CCUITFOR,CRET,CSTRING,CRAZSOC,CDOMIC
PRIVATE LRETGAN,LRETIVA,CNROOP,CCONCEPTO,CTIPORET,ANFS
PRIVATE NULTIMA,DULTFECHA,NX,NULTFECHA,CTIPO,CCODCOMP
PRIVATE CFECHADOC,CDOC,CNETO,CCODIMP,CCODREG,CCODOP
PRIVATE CBASE,CFECHRET,CCODCON,CIMPRET,CPORCEXC,CFECHBOL
PRIVATE CTIPODOC,CNROCUIT,CNROCORI,CDENORD,CACRECEN,CCUITPAIS
PRIVATE CCUITORD,CALIAS,CRETCOD,_SALIAS,CPERG,AREGS
PRIVATE I,J
PRIVATE aerror := {}
PRIVATE cPerg    := 'ARFISP0004'
PRIVATE oDlg
PRIVATE aCFOSIAP := TraeCFO()//Busca Codigos fiscales para exportar a SIAP
Private aDetalle := {}
Private cArchivo := ""
Private aGenOpc  := {}
Private cTipGen  := ""
Private aTipGen  := {}
Private nOpcion  := 0

ValidPerg()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaraci¢n de las variables                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPath    := GetNewPar( "MV_RETDIRP", "G:\MP11" )
//cPath    := "C:\TXT" 
cPath    := Padr( cPath, 255 )
cMesAno  :=  SubStr( DtoS(dDataBase), 1, 4 ) +SubStr( DtoS(dDataBase), 5, 2 ) + ".TXT "

aTipGen := {"Generar Archivo ","Generar informe","Ambos (Archivo e informe )"}
cTipGen := aTipGen[1]


aGenera  := {{"Percepciones/Retenciones IIBB CF"       ,PADR("P_R_IB_CF_"+cMesAno,50,"")  ,"ProcIBCF()" },; //01   
             {"Retenciones    IIBB BA (Buenos Aires)"  ,PADR("RETENCION_IIBB_BA_"+cMesAno,50,""),"ProcIBR()"  },; //02
             {"Percepciones   IIBB BA (Buenos Aires)"  ,PADR("PERCEPC_IIBB_BA_"+cMesAno,50,"")  ,"ProcIB2()"  },; //03
             {"Percepciones   IIBB FO (Formosa)"       ,PADR("PERCEPC_IIBB_FO_"+cMesAno,50,"")  ,"ProcIBB()"  },; //04
             {"SICORE"                                 ,PADR("SICORE_"+cMesAno,50,"")           ,"ProcSIC()"  },; //05
             {"Si.Fe.Re."                              ,PADR("SIFERE_"+cMesAno,50,"")           ,"ProcPER()"  },; //07
             {"IVA Percepciones Compras"               ,PADR("IVA_PERC_COMPRA_"+cMesAno,50,"")  ,"IVAPERC()"  },; //08
             {"Retenciones IVA Cobranza"               ,PADR("RET_IVA_COBRANZA_"+cMesAno,50,"") ,"RETIVAC()"  },; //09
             {"Retenciones Ganancias Cobranza"         ,PADR("RET_GAN_COBRANZA_"+cMesAno,50,"") ,"RETGANC()"  },; //11
             {"Retenciones SUSS  "                     ,PADR("RETENCION_SUSS_"+cMesAno,50,"")   ,"ProcSUSS()" },;  //12
             {"Percepciones IIBB NCC       CF"         ,PADR("PIB_CF_NC_"+cMesAno,50,"")  ,"ProcIBNC()" }}  //13

             /*{"Percepcion IVA Clientes "               ,PADR("PER_IVA_CLIENTE_"+cMesAno,50,"")  ,"ProcIVA()"  },;*/ //06
             /*{"Retenciones IIBB Cobranza"              ,PADR("RET_IIBB_COBRANZA_"+cMesAno,50,""),"RETIIBB()"  },;*/ //10

For f:=1 to len(aGenera)
     aadd(aGenOpc,aGenera[f,1])
Next f

cFile    := aGenera[1,1]
CFILE2   := 'SICONC.TXT'
cGenera  := aGenera[1,1]

lOk      := .F.
lWhen    := IIF( GetNewPar("MV_RETDIRV","N") == "S", .T., .F. )
                       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg Title OemToAnsi("Retenciones") FROM 120,111 To 400,725 OF oDlg PIXEL
@ 005,005 To 80,270 LABEL OemToAnsi("Generaci¢n de Archivos") OF oDlg PIXEL
@ 015,010 Say OemToAnsi("Ruta de Archivo") Size 45,8 PIXEL OF oDlg
@ 030,010 Say OemToAnsi("Archivo") Size 30,8 PIXEL OF oDlg
@ 045,010 Say OemToAnsi("Generar") Size 30,8 PIXEL OF oDlg
@ 015,070 Get cPath Picture "@!" Size 160,10 PIXEL OF oDlg When lWhen
//@ 15,240 BUTTON OemToAnsi("...") SIZE 15,10 PIXEL OF oDlg ACTION cPath := Padr( cGetFile(,"Seleccione la Carpeta Destino",0,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ), 255 )
@ 015,240 BUTTON OemToAnsi("...") SIZE 15,10 PIXEL OF oDlg ACTION cPath := Padr( cGetFile(,"Seleccione la Carpeta Destino",0,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_RETDIRECTORY), 255 )
@ 030,070 Get cFile Picture "@!" Size 160,10 PIXEL OF oDlg //Object oFile
@ 045,070 ComboBox cGenera Items aGenOpc Size 160,60 PIXEL OF oDlg ON CHANGE nomarch()
@ 060,010 Say OemToAnsi("Formato ") Size 30,8 PIXEL OF oDlg
@ 060,070 ComboBox cTipGen Items aTipGen Size 080,60 PIXEL OF oDlg 

@ 090,004 To 130,270 LABEL OemToAnsi("Descripci¢n") OF oDlg PIXEL
@ 100,010 Say OemToAnsi("Este programa generar  un archivo de texto para la importaci¢n a los programas de AFIP") Size 240,8 PIXEL OF oDlg
@ 110,010 Say OemToAnsi("( SIAP   )  o para IIBB.         ") Size 240,8 PIXEL OF oDlg

DEFINE SBUTTON FROM 07,280 Type 1 Action ( lOk := .T., oDlg:End() ) ENABLE OF oDlg
DEFINE SBUTTON FROM 30,280 Type 2 Action oDlg:End() ENABLE OF oDlg
Activate Dialog oDlg Centered

  
nPuntero := 0

If lOk
   cPath   := alltrim(cPath)
   cPath   := iif(right(cPath,1) != "\",cPath+"\",cPath)
   nOpcion := AsCan(aTipGen,{|x| x==cTipGen})
   
   If Pergunte('ARFISP0004',.T.)
      nArchivo := AsCan(aGenera,{|x| Alltrim( Upper( x[1] ) )==Alltrim( Upper(cGenera) )})
//      cEjecuta := "Processa({|| STATICCALL(U_ARWISP04,"+aGenera[nArchivo,3]+") },'Espere Por Favor...','"+aGenera[nArchivo,1] +" ') "
//      &(cEjecuta)
      Processa({|| &(aGenera[nArchivo,3])},"Espere Por Favor...",aGenera[nArchivo,1])
   EndIf

   //Genera archivo o ambos
   IF nOpcion == 1 .or. nOpcion== 3
	   If FCLOSE( nPuntero )
	      MsgInfo( "Archivo Generado Con Exito","Confirmaci¢n")
	   Else
	      MsgAlert( "Hubo Un Problema Con el Cierre del Archivo", "Problema" )
	   EndIf
   ENDIF
                                                                
EndIf

Return





/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ PROCIBNC ³ Autor ³   Carlos              ³ Data ³30/06/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Gen Arch percepciones NCC en base a NF que esta en SF1     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RETF010                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcIBNC()

Local aDet           := {}
Local cpase    	     := ''
Local cFecper	     := ''
Local cLetra   	     := ' '
Local cNro_comp      := ''
Local cFechacomp     := ''
Local cMonto 	     := SPACE(12)
Local cNrocert 	     := ''
Local cNro_doc 	     := ''
Local cSit_ib 		 := ' '
Local cNro_ins 	     := ''
Local cSit_iva 	     := ''
Local cRaz_ret 	     := ''
Local cOt_conoc 	 := ''
Local cIVA     	     := ''
Local cMon_neto 	 := ''
Local cAlicuota 	 := ''
Local cRet_prac 	 := ''
Local cRet_tot  	 := ''
local cQuery		 := ""
Local lSigue   	     := .T.
local nvalor  		 := 0

//Genera archivo o ambos
IF nOpcion == 1 .or. nOpcion== 3

	While ( nPuntero := FCreate( Alltrim(cPath) + Alltrim(cFile) ) ) == -1
	   If !MsgYesNo("No se puede Crear el Archivo "+Alltrim(cPath)+Alltrim(cFile)+Chr(13)+Chr(10)+"Continua?")
	      lSigue   := .F.
	      Exit
	   EndIf
	EndDo
                           
ENDIF

If lSigue

   //levanta la seleccion de sfe totalizada      
   /*
   if cFilAnt == '01'  // financiero compartido, levanto las retenciones para la sucursal 01
	cQuery  := "SELECT SFE_1.FE_NROCERT CERTIF, SFE_1.FE_EMISSAO EMISSAO, SFE_1.FE_FORNECE FORCLI, SFE_1.FE_LOJA LOJA, SA2.A2_CGC CGC, SA2.A2_ISICM CONVENIO, SFE_1.FE_TIPO TIPO, SFE_1.FE_ALIQ ALIC, "
	cQuery  += "SFE_1.FE_ORDPAGO COMPROB, 'RET' IMPOSTO, '1' TIPOPER, '008' CODNOR, '03' TIPOCOM, '2' TIPODOC, ' ' SERIE, SUM(FE_RETENC) AS RETENC, SUM(FE_VALBASE) AS BASE "
    cQuery	+=	"FROM " + RETSQLNAME ('SFE') + " SFE_1 "
    cQuery	+= "LEFT JOIN " + RETSQLNAME ('SA2') + " SA2 ON SFE_1.FE_FORNECE = SA2.A2_COD AND SFE_1.FE_LOJA = SA2.A2_LOJA "
    cQuery  += "WHERE "
    cQuery	+= "SFE_1.FE_FILIAL = '" 	+ xFilial("SFE") +	"' AND "
	cQuery	+= "SA2.A2_FILIAL = '" 	+ xFilial("SA2") +  	"' AND "
	cQuery  += "SFE_1.FE_TIPO='B' AND "
	cQuery  += "SFE_1.FE_EST='CF' AND "
	cQuery	+= "SFE_1.FE_NROCERT <> 'NORET' AND "
	cQuery	+= "SFE_1.FE_EMISSAO >= '" + DTOS(mv_par01)+ "' AND "
	cQuery	+= "SFE_1.FE_EMISSAO <= '" + DTOS(mv_par02)+ "' AND "
	cQuery  += "SFE_1.D_E_L_E_T_ <> '*' "
	cQuery	+= "GROUP BY SFE_1.FE_NROCERT, SFE_1.FE_EMISSAO, SFE_1.FE_FORNECE, SFE_1.FE_LOJA, SA2.A2_CGC, SA2.A2_ISICM, SFE_1.FE_TIPO, SFE_1.FE_ORDPAGO, SFE_1.FE_ALIQ "
	cQuery	+= "UNION ALL "
	endif
	//<<<<<< percepcion NF-NDC >>>>>>>>
   // cQuery  += "SELECT ' ' CERTIF, SF2.F2_EMISSAO EMISSAO, SF2.F2_CLIENTE FORCLI, SF2.F2_LOJA LOJA, SA1.A1_CGC CGC,  SA1.A1_ISICM CONVENIO, SF2.F2_ESPECIE TIPO, 1.50 AS ALIC, " 
    
    cQuery  += "SELECT ' ' CERTIF, SF2.F2_EMISSAO EMISSAO, SF2.F2_CLIENTE FORCLI, SF2.F2_LOJA LOJA, SA1.A1_CGC CGC, '2' CONVENIO,SF2.F2_ESPECIE TIPO, 1.50 AS ALIC, "
    
	cQuery  += "SF2.F2_DOC COMPROB, 'PER' IMPOSTO, '2' TIPOPER, '014' CODNOR, '01' TIPOCOM, '2' TIPODOC, SF2.F2_SERIE SERIE, SF2.F2_VALIMP5 AS RETENC, SF2.F2_BASIMP5 AS BASE "
    cQuery	+=	"FROM " + RETSQLNAME ('SF2') + " SF2 "
    cQuery	+= "LEFT JOIN " + RETSQLNAME ('SA1') + " SA1 ON SF2.F2_CLIENTE = SA1.A1_COD AND SF2.F2_LOJA = SA1.A1_LOJA "
    cQuery  += "WHERE "
    cQuery	+= "SF2.F2_FILIAL = '" + xFilial("SF2") +	"' AND "
	cQuery	+= "SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "
	cQuery  += "SF2.F2_VALIMP5 > 0 AND "
	cQuery	+= "(SF2.F2_ESPECIE = 'NF' OR  SF2.F2_ESPECIE = 'NDC' OR  SF2.F2_ESPECIE = 'CF') AND "
	cQuery	+= "SF2.F2_EMISSAO >= '" + DTOS(mv_par01)+ "' AND "
	cQuery	+= "SF2.F2_EMISSAO <= '" + DTOS(mv_par02)+ "' AND "
	cQuery  += "SF2.D_E_L_E_T_ <> '*' "
    */
	//<<<<<< percepcion NCC >>>>>>>>

//Comentó Seryo - Las NC son enviadas en otro archivo con otro formato	
	//cQuery	+= "UNION ALL "
    //cQuery  += "SELECT ' ' CERTIF, SF1.F1_EMISSAO EMISSAO, SF1.F1_FORNECE FORCLI, SF1.F1_LOJA LOJA, SA1.A1_CGC CGC, SA1.A1_ISICM CONVENIO, SF1.F1_ESPECIE TIPO, 1.50 AS ALIC, " 
    cQuery :=''
    cQuery  += "SELECT ' ' CERTIF, SF1.F1_EMISSAO EMISSAO, SF1.F1_FORNECE FORCLI, SF1.F1_LOJA LOJA, SA1.A1_CGC CGC,'2'  CONVENIO, SF1.F1_ESPECIE TIPO, 1.50 AS ALIC, "
	cQuery  += "SF1.F1_DOC COMPROB, 'PER' IMPOSTO, '2' TIPOPER, '014' CODNOR, '01' TIPOCOM, '2' TIPODOC, SF1.F1_SERIE SERIE, SF1.F1_VALIMP5 AS RETENC, SF1.F1_BASIMP5 AS BASE, "
    cQuery  += "SF1.F1_XNF XNF,SF1.F1_XSERNF XSERNF,SF1.F1_XESPNF XESPNF"	
    cQuery	+=	"FROM " + RETSQLNAME ('SF1') + " SF1 "
    cQuery	+= "LEFT JOIN " + RETSQLNAME ('SA1') + " SA1 ON SF1.F1_FORNECE = SA1.A1_COD AND SF1.F1_LOJA = SA1.A1_LOJA "
    cQuery  += "WHERE "
    cQuery	+= "SF1.F1_FILIAL = '" + xFilial("SF1") +	"' AND "
	cQuery	+= "SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "
	cQuery  += "SF1.F1_VALIMP5 > 0 AND "
	cQuery	+= "SF1.F1_ESPECIE = 'NCC' AND "
	cQuery	+= "SF1.F1_EMISSAO >= '" + DTOS(mv_par01)+ "' AND "
	cQuery	+= "SF1.F1_EMISSAO <= '" + DTOS(mv_par02)+ "' AND "
	cQuery  += "SF1.D_E_L_E_T_ <> '*' "

//Comentó Seryo - Las NC son enviadas en otro archivo con otro formato	

    cQuery  := ChangeQuery(cQuery)

	//+-----------------------
	//| Cria uma view no banco
	//+-----------------------
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .F. )
//   TCSetField( 'TRB', 'EMISSAO'    , 'D',8, 0 )
    TCSetField( 'TRB', 'ALIC'       , 'N',15, 2 )
    TCSetField( 'TRB', 'RETENC'     , 'N',15, 2 )
    TCSetField( 'TRB', 'BASE'       , 'N',15, 2 )
	dbSelectArea("TRB")
	dbGoTop()
	ProcRegua( LastRec() )
	While !Eof()

      /*                                               VALORES FIJOS
      <<<<<Estructura a pasar>>>>>>>>>>>>>  ---------RETENCION------------PERCEP.
      Tipo de Operacion     1 - 1   Numerico            1					2
      Codigo de Norma       2 - 4   Numerico      		008 				014
      F. de Retencion       5 - 14  Fecha
      T. de Comprobante     15 - 16  Numerico           03					01(NF)-09(ND)-08(NC)
      Letra de Comprobante  17 - 17  Texto
      Fecha de Comprobante  33 - 42  Fecha
      Monto                 43 - 54  Numérico 9-2
      Nro certificado       55 - 70  Texto
      Tip. Doc.             71 - 71  Numerico           2					2
      Número de Doc.        72 - 82  Texto              1-2                 1-2
      Sit  IB               83 - 83  Numerico
      Nro. Ind. IIBB        84 - 93  Numerico
      Sit  IVA              94 - 94  Numerico
      Razon Social          95 - 124 TEXTO
      Otras Compras        125 - 134 Numerico 7-2
      Iva                  135 - 144 Numerico 7-2
      Monto sujeto a Ret.  145 - 156 Numerico 9-2
      Alicuota             157 - 161 Numerico 2-2
      Ret. / Perc. Prac    162 - 173 Numerico 9-2
      Total Ret.           174 - 185 Numerico 9-2
      >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/

      ctipo_op 	:= 	TRB->TIPOPER
      cCod_nor 	:= 	TRB->CODNOR
      cFecper  	:= 	SubStr(TRB->EMISSAO,7,2) + '/' + SubStr(TRB->EMISSAO,5,2) + '/' +  SubStr(TRB->EMISSAO,1,4)
      cTipocom 	:= 	IIF ( TRB->IMPOSTO='RET',TRB->TIPOCOM,IIF(TRB->TIPO='NDC','09',IIF(TRB->TIPO='NF ' .OR. TRB->TIPO='CF ','01','08')))
      cLetra   	:= 	LEFT(TRB->SERIE,1,1)
      cNro_comp := 	IIF(TRB->IMPOSTO='RET',StrZero(val(TRB->COMPROB),15),StrZero(val(TRB->COMPROB),12)+SPACE(3))
      cFEchacomp:= 	cFecPer
      // VALOR BASE
      cpase 	:= 	str(TRB->BASE,12,2)
      cMonto	:=	RIGHT(StrTran( cpase, ".", "," ),12)
      cNrocert 	:= 	IIF (TRB->IMPOSTO='RET',StrZero(val(TRB->CERTIF),16),SPACE(16))
      cTip_doc 	:= 	TRB->TIPODOC
      cNro_doc 	:= 	left(TRB->CGC,11)
/*
//SERYO
      IF (TRB->CONVENIO =='1') //SI
      		cSit_ib 	:= 	"2"
      ELSE
      		cSit_ib 	:= 	"1"
      ENDIF
*/
      cNro_ins 	:= 	Nro_ins(TRB->FORCLI, TRB->LOJA, TRB->IMPOSTO)
		IF cNro_ins == '0000000000'
				cSit_ib 	:= 	"4"
		ELSE
	      IF (TRB->CONVENIO =='1') //SI
    	  		cSit_ib 	:= 	"2"
	      ELSE
    	  		cSit_ib 	:= 	"1"
	      ENDIF
	 	ENDIF
      cSit_iva 	:= 	sitiva(TRB->FORCLI, TRB->LOJA,TRB->IMPOSTO)
      cRaz_ret 	:= 	PADL(RAZ_SOC(TRB->FORCLI, TRB->LOJA, TRB->IMPOSTO),30)
      cOt_conoc := 	"0000000,00"
      cIVA  	:= 	"0000000,00"
      cMon_neto := 	cMonto

      // ALICUOTA PARA PERCEPCION
      // BUSCO EN SD1-SD2 LA ALICUOTA PARA PERCEPCION
      cAlicuota :=""
      IF TRB->IMPOSTO='PER'
          IF ALLTRIM(TRB->TIPO)=="NCC"
          		DbSelectArea( "SD1" )
          		DbSetOrder( 1 )
      			cChave:= xFilial() + TRB->COMPROB + TRB->SERIE + TRB->FORCLI + TRB->LOJA
      			DbSeek( cChave  )
            	While !Eof() .and. cChave == D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA
                	IF D1_VALIMP5 > 0
                   		cAlicuota := 	STR(D1_ALQIMP5,5,2)
      					cAlicuota := 	RIGHT(StrTran( calicuota, ".", "," ),5)
                    	EXIT
                    ENDIF
                    DBSKIP()
           		Enddo
           		dbCloseArea ()
          ENDIF
          dbSelectArea("TRB")
      ENDIF

      //RETENCION PRACTICADA
      cpase 	:= 	Str(TRB->RETENC,12,2)
      cRet_prac	:=	RIGHT(StrTran( cpase, ".", "," ),12)
      // MONTO RETENIDO
      cpase 	:= 	Str(TRB-> RETENC,12,2)
      cRet_tot	:=	Right(StrTran( cpase, ".", "," ),12)
      // alicuota retencion
      IF empty(cAlicuota)
        	cAlicuota := 	STR(TRB->ALIC,5,2)
      		cAlicuota := 	RIGHT(StrTran( calicuota, ".", "," ),5)
      ENDIF

      If cAlicuota == " 2,50" .and. TRB->IMPOSTO == 'RET'
         cCod_nor  := "008"
      ElseIF cAlicuota == " 4,50" .and. TRB->IMPOSTO == 'RET' //SERYO
				cSit_ib 	:= 	"4"//SERYO
         cCod_nor  := "016"
      ElseIF cAlicuota == " 3,00" .and. TRB->IMPOSTO == 'PER' //SERYO
         cCod_nor  := "014"
      ElseIF cAlicuota == " 6,00" .and. TRB->IMPOSTO == 'PER' //SERYO
         cCod_nor  := "016"
	 	ENDIF//SERYO
      /*
      cstring 	:= ctipo_op 	+ 	cCod_nor 	+  ;
                 cFecper 		+	ctipocom 	+ 	cLetra   	+ cNro_comp + ;
                 cFechacomp  	+ 	cMonto 		+ 	cNrocert 	+ ;
                 cTip_doc 		+  	cNro_doc 	+ 	cSit_ib 	+ ;
                 cNro_ins 		+ 	cSit_iva 	+ 	cRaz_ret 	+ cOt_conoc + ;
                 cIVA     		+  	cMon_neto 	+ 	cAlicuota 	+ ;
                 cRet_prac		+  	cRet_tot  	+  Chr(13) 		+ Chr(10)

      //Genera archivo o ambos
      IF nOpcion == 1 .or. nOpcion== 3
         FWrite(  nPuntero,  cString, Len( cString )  )
      ENDIF
           
      //datos para impresion      
      IF Len(aDet) == 0      
	      AADD(aDet,{ "Tipo Operacion" 	, 	"Codigo de Norma" 	, ;
	                 "Fecha Retencion"	,	"Tipo Comprob" 	, "Letra"   	, "Nro Comprobante" , "Fecha Compr" , ;
	                 "Importe Compr" 	, 	"Nro Certificado" 	,   "Tipo Doc" 	, "Nro documento" 	, "Situacion IB" 	 , ;
	                 "Nro Incripcion" 	, 	"Sit. IVA" 	, 	"Razon social" 	, "Otras Compras" , "IVA"     	 , ;
	                 "Monto Neto" 	, 	"Alicuota" 	,   "Retencion"	, "Total Retencion"  	})
      
      ENDIF          
      
      //Genera archivo o ambos
      IF nOpcion == 2 .or. nOpcion== 3
         AADD(aDet,{ ctipo_op 	, 	cCod_nor 	, ;
                     cFecper	,	ctipocom 	, 	cLetra   	, cNro_comp , cFechacomp , ;
                     cMonto 	, 	cNrocert 	,   cTip_doc 	, cNro_doc 	, cSit_ib 	 , ;
                     cNro_ins 	, 	cSit_iva 	, 	cRaz_ret 	, cOt_conoc , cIVA     	 , ;
                     cMon_neto 	, 	cAlicuota 	,   cRet_prac	, cRet_tot  	})
      ENDIF
      */
   	DbSkip()

   EndDo
   dbSelectArea ('TRB')
   dbCloseArea ()

///// NOTAS DE CREDITO ARCIBA 
    cQuery  := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .F. )
    TCSetField( 'TRB', 'ALIC'       , 'N',15, 2 )
    TCSetField( 'TRB', 'RETENC'     , 'N',15, 2 )
    TCSetField( 'TRB', 'BASE'       , 'N',15, 2 )
	dbSelectArea("TRB")
	dbGoTop()
	ProcRegua( LastRec() )
	While !Eof()
      /*                                               VALORES FIJOS
      <<<<<Estructura a pasar>>>>>>>>>>>>>  ---------RETENCION------------PERCEP.
	Aadd(aStruRETC,{"TIPOPER"  ,"C",01,0}) //Tipo de Operación
	Aadd(aStruRETC,{"NRONFC"   ,"C",12,0}) //Numero da NF de credito
	Aadd(aStruRETC,{"EMISSAO"  ,"C",10,0}) //Fecha de NF credito    
	Aadd(aStruRETC,{"MONTO"    ,"N",14,2}) //monto
	Aadd(aStruRETC,{"NROCERT"  ,"C",16,0}) //Nro Certificado Proprio
	Aadd(aStruRETC,{"TIPOCOM"  ,"C",02,0}) //Tipo de Comprobante
	Aadd(aStruRETC,{"LETRA"    ,"C",01,0}) //Letra de Comprobante
	Aadd(aStruRETC,{"COMPROB"  ,"C",15,0}) //Numero de Comprobante
	Aadd(aStruRETC,{"EMIOP"    ,"C",10,0}) //Fecha de Retención Orden de pago original
	Aadd(aStruRETC,{"COMOP"    ,"C",15,0}) //Numero de Comprobante Orden de pago original
	Aadd(aStruRETC,{"ALIQ"     ,"N",09,2}) //Alícuota OP original
	Aadd(aStruRETC,{"RETPRA"   ,"N",14,2}) //Ret./Percep. Practicadas original
	
      >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
      ctipo_op 	:= 	TRB->TIPOPER
      cCod_nor 	:= 	TRB->CODNOR
      cFecper  	:= 	SubStr(TRB->EMISSAO,7,2) + '/' + SubStr(TRB->EMISSAO,5,2) + '/' +  SubStr(TRB->EMISSAO,1,4)
      cTipocom 	:= 	IIF ( TRB->IMPOSTO='RET',TRB->TIPOCOM,IIF(TRB->TIPO='NDC','09',IIF(TRB->TIPO='NF ','01','08')))
      cLetra   	:= 	LEFT(TRB->SERIE,1,1)
      cNro_comp := 	IIF(TRB->IMPOSTO='RET',StrZero(val(TRB->COMPROB),15),StrZero(val(TRB->COMPROB),12))
      cFEchacomp:= 	cFecPer
      cpase 	:= 	str(TRB->BASE,12,2)
      cMonto	:=	RIGHT(StrTran( cpase, ".", "," ),12)
      cNrocert 	:= 	IIF (TRB->IMPOSTO='RET',StrZero(val(TRB->CERTIF),16),SPACE(16))
      cTip_doc 	:= 	TRB->TIPODOC
      cNro_doc 	:= 	left(TRB->CGC,11)
	  cLetraNF  := 	LEFT(TRB->XSERNF,1,1)
      cNro_NF   := 	TRB->XNF

      cNro_ins 	:= 	Nro_ins(TRB->FORCLI, TRB->LOJA, TRB->IMPOSTO)
		IF cNro_ins == '0000000000'
				cSit_ib 	:= 	"4"
		ELSE
	      IF (TRB->CONVENIO =='1') //SI
    	  		cSit_ib 	:= 	"2"
	      ELSE
    	  		cSit_ib 	:= 	"1"
	      ENDIF
	 	ENDIF
      cSit_iva 	:= 	sitiva(TRB->FORCLI, TRB->LOJA,TRB->IMPOSTO)
      cRaz_ret 	:= 	PADL(RAZ_SOC(TRB->FORCLI, TRB->LOJA, TRB->IMPOSTO),30)
      cOt_conoc := 	"0000000,00"
      cIVA  	:= 	"0000000,00"
      cMon_neto := 	cMonto

      cAlicuota :=""
      IF TRB->IMPOSTO='PER'
          IF ALLTRIM(TRB->TIPO)=="NCC"
          		DbSelectArea( "SD1" )
          		DbSetOrder( 1 )
      			cChave:= xFilial() + TRB->COMPROB + TRB->SERIE + TRB->FORCLI + TRB->LOJA
      			DbSeek( cChave  )
            	While !Eof() .and. cChave == D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA
                	IF D1_VALIMP5 > 0
                   		cAlicuota := 	STR(D1_ALQIMP5,5,2)
      					cAlicuota := 	RIGHT(StrTran( calicuota, ".", "," ),5)
                    	EXIT
                    ENDIF
                    DBSKIP()
           		Enddo
           		dbCloseArea ()
          ENDIF
          dbSelectArea("TRB")
      ENDIF

      //RETENCION PRACTICADA
      cpase 	:= 	Str(TRB->RETENC,12,2)
      cRet_prac	:=	RIGHT(StrTran( cpase, ".", "," ),12)
      // MONTO RETENIDO
      cpase 	:= 	Str(TRB-> RETENC,12,2)
      ///tiene que ir el NETO no la percepcion en el archivo de NCC
      cpase 	:= 	Str(TRB->BASE,12,2)
      cRet_tot	:=	Right(StrTran( cpase, ".", "," ),12)
      cRet_tot	:=  right('0000000000000'+alltrim(cret_tot),12)
      // alicuota retencion
      IF empty(cAlicuota)
        	cAlicuota := 	STR(TRB->ALIC,5,2)
      		cAlicuota := 	RIGHT(StrTran( calicuota, ".", "," ),5)
      ENDIF

      If cAlicuota == " 2,50" .and. TRB->IMPOSTO == 'RET'
         cCod_nor  := "008"
      ElseIF cAlicuota == " 4,50" .and. TRB->IMPOSTO == 'RET' //SERYO
				cSit_ib 	:= 	"4"//SERYO
         cCod_nor  := "016"
      ElseIF cAlicuota == " 3,00" .and. TRB->IMPOSTO == 'PER' //SERYO
         cCod_nor  := "014"
      ElseIF cAlicuota == " 6,00" .and. TRB->IMPOSTO == 'PER' //SERYO
         cCod_nor  := "016"
	 	ENDIF//SERYO


      //cstring 	:= ctipo_op 	+ 	cNro_comp +;
      //           cFecper 		+	cRet_tot  + cNrocert + '01'	+ 	cLetra   	+ cNro_comp + SPACE(3) 	+  Chr(13) 		+ Chr(10)
      cstring 	:= ctipo_op 	+ 	cNro_comp +;
                 cFecper 		+	cRet_tot  + cNrocert + '01'	+ 	cLetraNF   	+ cNro_NF + SPACE(3) 	+  Chr(13) 		+ Chr(10)

      //Genera archivo o ambos
      IF nOpcion == 1 .or. nOpcion== 3
         FWrite(  nPuntero,  cString, Len( cString )  )
      ENDIF
           
      //datos para impresion      
      IF Len(aDet) == 0      
	      AADD(aDet,{ "Tipo Operacion" 	, 	"Codigo de Norma" 	, ;
	                 "Fecha Retencion"	,	"Tipo Comprob" 	, "Letra"   	, "Nro Comprobante" , "Fecha Compr" , ;
	                 "Importe Compr" 	, 	"Nro Certificado" 	,   "Tipo Doc" 	, "Nro documento" 	, "Situacion IB" 	 , ;
	                 "Nro Incripcion" 	, 	"Sit. IVA" 	, 	"Razon social" 	, "Otras Compras" , "IVA"     	 , ;
	                 "Monto Neto" 	, 	"Alicuota" 	,   "Retencion"	, "Total Retencion"  	})
      
      ENDIF          
      
      //Genera archivo o ambos
      IF nOpcion == 2 .or. nOpcion== 3
         AADD(aDet,{ ctipo_op 	, 	cCod_nor 	, ;
                     cFecper	,	ctipocom 	, 	cLetra   	, cNro_comp , cFechacomp , ;
                     cMonto 	, 	cNrocert 	,   cTip_doc 	, cNro_doc 	, cSit_ib 	 , ;
                     cNro_ins 	, 	cSit_iva 	, 	cRaz_ret 	, cOt_conoc , cIVA     	 , ;
                     cMon_neto 	, 	cAlicuota 	,   cRet_prac	, cRet_tot  	})
      ENDIF

   	DbSkip()

   EndDo
   dbSelectArea ('TRB')
   dbCloseArea ()

   
   //Genera archivo o ambos
   IF nOpcion == 2 .or. nOpcion== 3
	   If len(aDet) > 0
	      If !MsgYesNo("Genera informe? ")
	         Return
	      EndIf      
	      ARFISR01(aDet,cFile)
	      
	   EndIf
   ENDIF

EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ sitiva   ³ Autor ³ MS                    ³ Data ³14/08/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ FUNCION OBTIENE SITUACION IVA                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RETF010                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FUNCTION sitiva(FORCLI, LOJA, IMPOSTO)

local csitu := ''
local carea := getarea()
Local cTipo := ''

IF IMPOSTO == "RET"
    dbselectarea("SA2")
    dbsetorder(1)
    If dbseek(xfilial()+FORCLI+LOJA)
    	cTipo := alltrim(A2_TIPO)
    Endif
elseIF IMPOSTO == "PER"
	dbselectarea("SA1")
   dbsetorder(1)
   If dbseek(xfilial()+FORCLI+LOJA)
    	cTipo := alltrim(A1_TIPO)
   Endif

Endif

If empty(cTipo)
    csitu := '0'
elseif cTipo = 'I'
    csitu := '1'
elseif cTipo = 'N'
    csitu := '2'
elseIf cTipo= 'X'
    csitu := '3'
elseif cTipo = 'M'
    csitu := '4'
else
    csitu := '5'
Endif

restarea(carea)

RETURN CSITU

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³  situa   ³ Autor ³MS                     ³ Data ³14/08/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ FUNCION OBTIENE SITUACION IB                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RETF010                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static function situa(FORNECE, LOJA)
    local csitu := '0'
    local carea := getarea()
    dbselectarea("SA2")
    dbsetorder(1)
    dbseek(xfilial()+FORNECE+LOJA)
    if fieldpos("A2_SITUAIB") > 0
    	IF empty(A2_SITUAIB)
       		csitu := A2_SITUAIB
    	endif
    Endif
    restarea(carea)
return csitu

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ Nro_ins  ³ Autor ³ MS                    ³ Data ³14/08/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ FUNCION OBTIENE NRO IB                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RETF010                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static function Nro_ins(FORCLI, LOJA, IMPOSTO)
local cNRO := ''
local carea := getarea()

IF IMPOSTO == "RET"
    dbselectarea("SA2")
    dbsetorder(1)
    If dbseek(xfilial()+FORCLI+LOJA)
    	cNro := SACAGUION(A2_NROIB)
    	cNro := PADL(alltrim(cNro), 10,'0')
    Endif
elseIF IMPOSTO == "PER"
	dbselectarea("SA1")
   dbsetorder(1)
   If dbseek(xfilial()+FORCLI+LOJA)
    	cNro := SACAGUION(A1_NROIB)
    	cNro := PADL(alltrim(cNro), 10,'0')
   Endif
Endif

Restarea(carea)

return cNro

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ RAZ_SOC  ³ Autor ³ MS                    ³ Data ³14/08/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ FUNCION RAZON SOCIAL PROVEED.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RETF010                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static function RAZ_SOC(FORCLI, LOJA, IMPOSTO)
    local craz := ''
    local carea := getarea()

IF IMPOSTO == "RET"
    dbselectarea("SA2")
    dbsetorder(1)
    If dbseek(xfilial()+FORCLI+LOJA)
    	craz := A2_NOME
    Endif
elseIF IMPOSTO == "PER"
	dbselectarea("SA1")
   dbsetorder(1)
   If dbseek(xfilial()+FORCLI+LOJA)
    	craz := A1_NOME
   Endif
Endif

restarea(cArea)

return craz

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ SACAPUNTO³ Autor ³MS                     ³ Data ³14/08/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ FUNCION PARA SACAR PUNTO                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RETF010                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION SACAPUNTO(NUMERO)
   LOCAL CNUMERO:= ''
   LOCAL I:= 0
   LOCAL DECIMAL := .F.
   LOCAL REDONDEO := 0
   FOR I = 1 TO LEN(NUMERO)
      IF SUBSTR(NUMERO,I,1) = '.'
        CNUMERO := CNUMERO + ','
      ELSE
        CNUMERO +=SUBSTR(NUMERO,I,1)
      ENDIF
   NEXT I

RETURN CNUMERO

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ SACAGUION³ Autor ³ MS                    ³ Data ³14/08/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ FUNCION PARA SACAR GUION                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RETF010                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION SACAGUION(NUMERO)
   LOCAL CNUMERO:= ''
   LOCAL I:= 0
   LOCAL DECIMAL := .F.
   LOCAL REDONDEO := 0
   FOR I = 1 TO LEN(NUMERO)
         IF SUBSTR(NUMERO,I,1) <>  '-'
              CNUMERO +=SUBSTR(NUMERO,I,1)
         ENDIF
   NEXT I

RETURN CNUMERO

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ PROCSUSS ³ Autor ³Diego Fernando Rivero  ³ Data ³14/08/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Genera Archivo de SUSS  (Regimen 1784 /1769/4052)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static function ProcSUSS()
Local aDet     := {}
Local cQuery  	:= ""
Local lSigue   := .T.

//Genera archivo o ambos
IF nOpcion == 1 .or. nOpcion== 3
	While ( nPuntero := FCreate( Alltrim(cPath) + Alltrim(cFile) ,0 )  ) == -1
		If !MsgYesNo("No se puede Crear el Archivo "+Alltrim(cPath)+Alltrim(cFile)+Chr(13)+Chr(10)+"Continua?")
			lSigue   := .F.
			Exit
		EndIf
	EndDo
ENDIF

If lSigue

	//levanta la seleccion de sfe totalizada
	//cQuery    := "SELECT SFF.FF_CODREG CODREG, SFE_1.FE_NROCERT CERTIF, SFE_1.FE_EMISSAO EMISSAO, SFE_1.FE_FORNECE FORNECE, SFE_1.FE_LOJA LOJA, SA2.A2_CGC CGC, SFE_1.FE_TIPO TIPO, SFE_1.FE_ORDPAGO OPAGO, "
	
  //	cQuery    := "SFE_1.FE_NROCERT CERTIF, SFE_1.FE_EMISSAO EMISSAO, SFE_1.FE_FORNECE FORNECE, SFE_1.FE_LOJA LOJA, SA2.A2_CGC CGC, SFE_1.FE_TIPO TIPO, SFE_1.FE_ORDPAGO OPAGO, "
	
/* cQuery    := "SELECT SFF.FF_CODREG CODREG, SFE_1.FE_NROCERT CERTIF, SFE_1.FE_EMISSAO EMISSAO, SFE_1.FE_FORNECE FORNECE, SFE_1.FE_LOJA LOJA, SA2.A2_CGC CGC, SFE_1.FE_TIPO TIPO, SFE_1.FE_ORDPAGO OPAGO, "
	
	cQuery    := "SELECT SFF.FF_CFO CODREG, SFE_1.FE_NROCERT CERTIF, SFE_1.FE_EMISSAO EMISSAO, SFE_1.FE_FORNECE FORNECE, SFE_1.FE_LOJA LOJA, SA2.A2_CGC CGC, SFE_1.FE_TIPO TIPO, SFE_1.FE_ORDPAGO OPAGO, "

	
	cQuery    += "(SELECT SUM(FE_RETENC) FROM " + RETSQLNAME ('SFE') + " SFE_2 "
	cQuery    += "WHERE "
	cQuery    += "SFE_2.FE_TIPO='S' 		AND "
	cQuery    += "SFE_2.FE_NROCERT<>'NORET'	AND "
	cQuery    += "SFE_2.D_E_L_E_T_ <> '*' 	AND "
	cQuery	 += "SFE_2.FE_ORDPAGO = SFE_1.FE_ORDPAGO ) AS RETENC FROM " + RETSQLNAME ('SFE') + " SFE_1 "
   cQuery	 += "LEFT JOIN " + RETSQLNAME ('SFF') + " SFF ON SFE_1.FE_CONCEPT = SFF.FF_ITEM "
   cQuery	 += "LEFT JOIN " + RETSQLNAME ('SA2') + " SA2 ON SFE_1.FE_FORNECE = SA2.A2_COD AND SFE_1.FE_LOJA = SA2.A2_LOJA "
   cQuery    += "WHERE "
   cQuery	 += "SFE_1.FE_FILIAL = '" 	+ xFilial("SFE") +		"' AND "
	cQuery	 += "SFF.FF_FILIAL = '" 	+ xFilial("SFF") +  	"' AND "
	cQuery	 += "SA2.A2_FILIAL = '" 	+ xFilial("SA2") +  	"' AND "
	cQuery    += "SFE_1.FE_TIPO='S' AND "
	cQuery	 += "SFE_1.FE_NROCERT <> 'NORET' AND "
	cQuery	 += "SFE_1.FE_EMISSAO >= '" + DTOS(mv_par01)+ "' AND "
	cQuery	 += "SFE_1.FE_EMISSAO <= '" + DTOS(mv_par02)+ "' AND "
   cQuery    += "SFF.D_E_L_E_T_ <> '*' AND "
   cQuery    += "SA2.D_E_L_E_T_ <> '*' AND "
	cQuery    += "SFE_1.D_E_L_E_T_ <> '*' "
	cQuery	 += "SFE_1.FE_NROCERT, SFE_1.FE_EMISSAO, SFE_1.FE_FORNECE, SFE_1.FE_LOJA, SA2.A2_CGC, SFE_1.FE_TIPO, SFE_1.FE_ORDPAGO "
    

  */
  //ser
  	cQuery    := "SELECT SFF.FF_CODREG CODREG, SFE_1.FE_NROCERT CERTIF, SFE_1.FE_EMISSAO EMISSAO, SFE_1.FE_FORNECE FORNECE, SFE_1.FE_LOJA LOJA, SA2.A2_CGC CGC, SA2.A2_NOME NOME, SFE_1.FE_TIPO TIPO, SFE_1.FE_ORDPAGO OPAGO, "
	cQuery    += "(SELECT SUM(FE_RETENC) FROM " + RETSQLNAME ('SFE') + " SFE_2 "
	cQuery    += "WHERE "
	cQuery    += "SFE_2.FE_TIPO='S' 		AND "
	cQuery    += "SFE_2.FE_NROCERT<>'NORET'	AND "
	cQuery    += "SFE_2.D_E_L_E_T_ <> '*' 	AND "
	cQuery 	  += "SFE_2.FE_ORDPAGO = SFE_1.FE_ORDPAGO ) AS RETENC FROM " + RETSQLNAME ('SFE') + " SFE_1 "
    cQuery 	  += "LEFT JOIN " + RETSQLNAME ('SFF') + " SFF ON SFE_1.FE_CONCEPT = SFF.FF_ITEM AND SFE_1.FE_ALIQ = SFF.FF_ALIQ "
    cQuery	  += "LEFT JOIN " + RETSQLNAME ('SA2') + " SA2 ON SFE_1.FE_FORNECE = SA2.A2_COD AND SFE_1.FE_LOJA = SA2.A2_LOJA "
    cQuery    += "WHERE "
    cQuery	  += "SFE_1.FE_FILIAL = '" + xFilial("SFE") +	"' AND "
	cQuery	  += "SFF.FF_FILIAL = '" + xFilial("SFF") + "' AND "
	cQuery	  += "SA2.A2_FILIAL = '" + xFilial("SA2") + "' AND "
	cQuery    += "SFE_1.FE_TIPO='S' AND "
	cQuery	  += "SFE_1.FE_NROCERT <> 'NORET' AND "
	cQuery	  += "SFE_1.FE_EMISSAO >= '" + DTOS(mv_par01)+ "' AND "
	cQuery	  += "SFE_1.FE_EMISSAO <= '" + DTOS(mv_par02)+ "' AND "
    cQuery	  += "SFF.FF_IMPOSTO = 'SUS' AND "
    cQuery    += "SFF.D_E_L_E_T_ <> '*' AND "
    cQuery    += "SA2.D_E_L_E_T_ <> '*' AND "
	cQuery    += "SFE_1.D_E_L_E_T_ <> '*' "
	cQuery	  += "GROUP BY SFF.FF_CODREG , SFE_1.FE_NROCERT, SFE_1.FE_EMISSAO, SFE_1.FE_FORNECE, SFE_1.FE_LOJA, SA2.A2_NOME,SA2.A2_CGC, SFE_1.FE_TIPO, SFE_1.FE_ORDPAGO "

    
		//+-----------------------
	//| Cria uma view no banco
	//+-----------------------
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .F. )
	dbSelectArea("TRB")
	dbGoTop()
	//SetRegua( RecCount() )

	While !Eof()

	  //	IncRegua()

      cTipComp   	:= Alltrim(TRB->CODREG)
      cProvee   	:= Alltrim(TRB->NOME)
      If empty(cTipComp)
         cTipComp    := "000" // Para que no modifique las posiciones del archivo.
      EndIf
		cNroCUIT 	:= PADL(TRB->CGC,11)
		cExed		:= "000000,00"
		cFechRet 	:= substr(TRB->EMISSAO,7,2)+"/"+substr(TRB->EMISSAO,5,2)+"/"+substr(TRB->EMISSAO,1,4)
		cImpRet  	:= StrZero(TRB->RETENC, 8, 2)
		cImpRet  	:= StrTran( cImpRet, ".", "," )
		cNroCOri 	:= StrZero(Val(TRB->CERTIF),14)
//		cNroCOri 	:= RIGHT ("00000000000000" + Alltrim(TRB->CERTIF),14)

		/*/------------Estructura a pasar-----------------------------------//
                                            DESDE HASTA  TIPO     LONGITUD
         Codigo de Regimen  cregim := '755'  1       3    Entero         3
         Cuit del Retenido  cCuit  := ''     4      14    Texto         11
         Importe Exedente   cexed  := 0     15      25    Decimal       11
         Fecha de retencion dFeret := ''    26      35    Fecha         10
         Importe Retenido   cImpor := ''    36      46    Decimal       11
         Nro de Certificado cNrocer := ''   47      60    Texto         14
      */


		cString  := cTipComp + cNroCUIT + cExed + cFechRet + cImpRet + cNroCOri + Chr(13)   + Chr(10)

        //Genera archivo o ambos
        IF nOpcion == 1 .or. nOpcion== 3
		   FWrite(  nPuntero,  cString, Len(cString)  )
		ENDIF

        //Genera archivo o ambos
        IF nOpcion == 2 .or. nOpcion== 3
		    IF Len(aDet) == 0      
			      AADD(aDet,{ {"Cuit Proveedor","C"} ,{"Codigo / Tienda","C"},{PADR("Razon Social",50),"C"}	, 	{"Fecha retencion","C"} 	, ;
			                  {"Numero comprobante","C"} 	, {"Importe retencion","N"},{"Tipo Compr","C"}} )
	      
	        ENDIF      
           AADD(aDet,{ cNroCUIT,TRB->FORNECE+"-"+TRB->LOJA,TRB->NOME,cFechRet,TRB->CERTIF,StrTran( cImpRet, ",", "." ),cTipComp})
//           AADD(aDet,{ cNroCUIT,cFechRet,TRB->CERTIF,TRB->RETENC,cTipComp,cProvee })
        ENDIF
		DbSkip()

	EndDo

	DbSelectArea("TRB")
	dbCloseArea()

// aGREGAR SEGUNDA QUERY QUE EJECUTE LAS RETENCIONES DE SUSS SIN EL CONCEPTO INFORMADO
/*
AGREGO SERYO
*/          
  	cQuery   := "SELECT SFE_1.FE_NROCERT CERTIF, SFE_1.FE_EMISSAO EMISSAO, SFE_1.FE_FORNECE FORNECE, SFE_1.FE_LOJA LOJA, SA2.A2_CGC CGC,SA2.A2_NOME NOME, SFE_1.FE_TIPO TIPO, SFE_1.FE_ORDPAGO OPAGO, "
	cQuery   += "(SELECT SUM(FE_RETENC) FROM " + RETSQLNAME ('SFE') + " SFE_2 "
	cQuery   += "WHERE "
	cQuery   += "SFE_2.FE_TIPO='S' 		AND "
	cQuery   += "SFE_2.FE_NROCERT<>'NORET'	AND "
	cQuery   += "SFE_2.D_E_L_E_T_ <> '*' 	AND "
	cQuery	 += "SFE_2.FE_ORDPAGO = SFE_1.FE_ORDPAGO ) AS RETENC FROM " + RETSQLNAME ('SFE') + " SFE_1 "
    cQuery	 += "LEFT JOIN " + RETSQLNAME ('SA2') + " SA2 ON SFE_1.FE_FORNECE = SA2.A2_COD AND SFE_1.FE_LOJA = SA2.A2_LOJA "
    cQuery   += "WHERE "
    cQuery	 += "SFE_1.FE_FILIAL = '" + xFilial("SFE") +	"' AND "
	cQuery	 += "SA2.A2_FILIAL = '" + xFilial("SA2") + "' AND "
	cQuery   += "SFE_1.FE_TIPO='S' AND "
	cQuery	 += "SFE_1.FE_NROCERT <> 'NORET' AND "
	cQuery	 += "SFE_1.FE_EMISSAO >= '" + DTOS(mv_par01)+ "' AND "
	cQuery	 += "SFE_1.FE_EMISSAO <= '" + DTOS(mv_par02)+ "' AND "
	cQuery	 += "SFE_1.FE_CONCEPT = '' AND "
    cQuery   += "SA2.D_E_L_E_T_ <> '*' AND "
	cQuery   += "SFE_1.D_E_L_E_T_ <> '*' "
	cQuery	 += "GROUP BY SFE_1.FE_NROCERT, SFE_1.FE_EMISSAO, SFE_1.FE_FORNECE, SFE_1.FE_LOJA, SA2.A2_CGC,SA2.A2_NOME, SFE_1.FE_TIPO, SFE_1.FE_ORDPAGO "

    
		//+-----------------------
	//| Cria uma view no banco
	//+-----------------------
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .F. )
	dbSelectArea("TRB")
	dbGoTop()
	//SetRegua( RecCount() )

	While !Eof()

	  //	IncRegua()

		cTipComp   	:= '742'
		cNroCUIT 	:= PADL(TRB->CGC,11)
        cProvee  	:= Alltrim(TRB->NOME)
		cExed		:= "000000,00"
		cFechRet 	:= substr(TRB->EMISSAO,7,2)+"/"+substr(TRB->EMISSAO,5,2)+"/"+substr(TRB->EMISSAO,1,4)
		cImpRet  	:= StrZero( TRB->RETENC, 8, 2 )
		cImpRet  	:= StrTran( cImpRet, ".", "," )
		cNroCOri 	:= StrZero(Val(TRB->CERTIF),14)
//		cNroCOri 	:= RIGHT ("00000000000000" + Alltrim(TRB->CERTIF),14)

		/*/------------Estructura a pasar--------------------------------//
                                            DESDE HASTA  TIPO     LONGITUD
         Codigo de Regimen  cregim := '755'  1       3    Entero         3
         Cuit del Retenido  cCuit  := ''     4      14    Texto         11
         Importe Exedente   cexed  := 0     15      25    Decimal       11
         Fecha de retencion dFeret := ''    26      35    Fecha         10
         Importe Retenido   cImpor := ''    36      46    Decimal       11
         Nro de Certificado cNrocer := ''   47      60    Texto         14
      */


		cString  := cTipComp + cNroCUIT + cExed + cFechRet + cImpRet + cNroCOri + Chr(13)   + Chr(10)

        //Genera archivo o ambos
        IF nOpcion == 1 .or. nOpcion== 3
		   FWrite(  nPuntero,  cString, Len(cString)  )
        ENDIF          
        
        //Genera archivo o ambos
        IF nOpcion == 2 .or. nOpcion== 3
		    IF Len(aDet) == 0      
			      AADD(aDet,{ {"Cuit Proveedor","C"} ,{"Codigo / Tienda","C"},{PADR("Razon Social",50),"C"}	, 	{"Fecha retencion","C"} 	, ;
			                  {"Numero comprobante","C"} 	, {"Importe retencion","N"},{"Tipo Compr","C"}})
	      
	        ENDIF      
           AADD(aDet,{ cNroCUIT,TRB->FORNECE+"-"+TRB->LOJA,TRB->NOME,cFechRet,TRB->CERTIF,StrTran( cImpRet, ",", "." ),cTipComp})
		ENDIF
		DbSkip()

	EndDo

	DbSelectArea("TRB")
	dbCloseArea()


/*
AGREGO SERYO
*/
   If len(aDet) > 0
//      If !MsgYesNo("Genera informe? ")
//         Return
//      EndIf
      //ImpreSUSS(aDet, mv_par01, mv_par02)
      ARFISR01(aDet,cFile)
   EndIf

EndIf

return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ PROCIBR  ³ Autor ³Diego Fernando Rivero  ³ Data ³14/08/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Genera Archivo de Retenciones de IIBB -BA                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RETF010                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcIBR()

Local aDet     := {}
lSigue   := .T.
cCUIT    := SubStr(SM0->M0_CGC,1,11)
cLetra   := "A"

//Genera archivo o ambos
IF nOpcion == 1 .or. nOpcion== 3
	While ( nPuntero := FCreate( Alltrim(cPath) + Alltrim(cFile) ) ) == -1
	   If !MsgYesNo("No se puede Crear el Archivo "+Alltrim(cPath)+Alltrim(cFile)+Chr(13)+Chr(10)+"Continua?")
	      lSigue   := .F.
	      Exit
	   EndIf
	EndDo
ENDIF

If lSigue

   DbSelectArea("SFE")
   DbSetOrder(1)
   DbGoTop()

   ProcRegua( LastRec() )


   While !eof()

      IncProc()

      If ALLTRIM(FE_TIPO) <> "B"   .or. ( ALLTRIM(FE_TIPO) = "B" .and.  AllTrim(FE_EST)!="BA")
         DbSkip()
         Loop
      EndIf

	  If ALLTRIM(FE_NROCERT) == "NORET"
         DbSkip()
         Loop
      EndIf

      If FE_EMISSAO < mv_par01 .OR. FE_EMISSAO > mv_par02
         DbSkip()
         Loop
      EndIf
      
      If !Empty(FE_DTESTOR)
      	IF Month(FE_DTESTOR)==Month(FE_EMISSAO)
	      	DbSkip()
    	    Loop
	    EndIf
	  Endif

      cNroCert := FE_NROCERT
      cFornece := FE_FORNECE
      cLoja    := FE_LOJA
      cFecha   := DTOS(FE_EMISSAO)
      cFecha   := SubStr(cFecha,7,2) + '/' +  SubStr(cFecha,5,2) + '/' + SubStr(cFecha,1,4)
//      cNroSuc  := "0000"      //Left( FE_NFISCAL, 4 )
      cNroSuc  := ""      //Left( FE_NFISCAL, 4 )
      cNroEmis := RIGHT(FE_NROCERT,12)  //Right( FE_NFISCAL, 8 )
      //NUMERO DE OP EN TXT RETENCION BA
      IF GetNewPar("AL_REBANUME","N")=="S"
         cNroEmis := PADL(FE_ORDPAGO,12,"0")
      ENDIF
      nRet     := 0

      SA2->(DbSetOrder(1))
      SA2->(DbSeek( xFilial("SA2") + cFornece + cLoja ) )

     cCUITFor := SubStr(SA2->A2_CGC,1,2)   +"-"+ SubStr(SA2->A2_CGC,3,8)+"-" +SubStr(SA2->A2_CGC,11,1)
     //Cuit para retencion BA sin guiones
     /*IF GetNewPar("AL_REBACUIT","S")=="S"
        cCUITFor := PADR(SA2->A2_CGC,13," ")
     ENDIF*/
	If !Empty(FE_DTESTOR)
      	IF Month(FE_DTESTOR)<>Month(FE_EMISSAO)
      		cLetra:="B"
    	endif
    endif
    If cLetra<>"B"
    	cLetra:="A"
    endif     
     While !eof() .and. FE_NROCERT == cNroCert .and. FE_EMISSAO>= mv_par01 .AND. FE_EMISSAO <= mv_par02  .and. FE_TIPO = "B" .and.  AllTrim(FE_EST)=="BA"
         nRet  := nRet + FE_RETENC
         DbSkip()
     End

      cRet  := Str( nRet, 11, 2 )
      cRet  := StrTran( cRet, ".", ","  )
      cRet  := StrTran( cRet, " ", "0" )
      //IMPORTE CON punto DECIMAL en TXT RETENCIONES BA
      IF GetNewPar("AL_REBAIMPO","S")=="S"
         cRet  := StrTran( cRet, ",", "."  )
      ENDIF
      /*/------------Estructura a pasar-----------------------------------//
                                            DESDE HASTA  TIPO     LONGITUD
         Cuit del Retenido  cCuit  	:= ''     1      13    Texto         13
         Fecha de retencion 	   	:= ''    14      23    Fecha         10
         Numero de Sucursal			:= ''    24      27    decimal		 04
         Numero Emision				:= 0     28      35    Decimal       08
         Importe Retenido   		:= ''    36      45    Decimal       10

      */

      cString  := cCUITFor + cFecha + cNroSuc + cNroEmis + cRet + cLetra + Chr(13) + Chr(10)

      //Genera archivo o ambos
      IF nOpcion == 1 .or. nOpcion== 3
         FWrite(  nPuntero,  cString, Len( cString )  )
      ENDIF
      
      //datos para impresion      
      //Genera archivo o ambos
      IF nOpcion == 2 .or. nOpcion== 3
	      IF Len(aDet) == 0      
		      AADD(aDet,{ {"Cuit Proveedor","C"} ,{"Codigo / Tienda","C"},{PADR("Razon Social",50),"C"}	, 	{"Fecha retencion","C"} 	, ;
		                 {"Nro Sucursal","C"}	,	{"Numero comprobante","C"} 	, {"Importe retencion","N"},{"Alta o Baja","C"}})
	      
	      ENDIF      
	      AADD(aDet,{ cCUITFor ,SA2->A2_COD+"-"+SA2->A2_LOJA, UPPER(SA2->A2_NOME),cFecha , cNroSuc , cNroEmis , cRet , cLetra })
      ENDIF
   EndDo

EndIf
   If len(aDet) > 0
//      If !MsgYesNo("Genera informe? ")
//         Return
//      EndIf
      ARFISR01(aDet, cFile)
   EndIf


Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ PROCSIC  ³ Autor ³Microsiga Argentina    ³ Data ³14/08/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Genera Archivo de Retenciones SICORE ( IVA / GAN )         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcSIC()
Local   aDetRet := {}

lSigue   := .T.

//Genera archivo o ambos
IF nOpcion == 1 .or. nOpcion== 3
	While ( nPuntero := FCreate( Alltrim(cPath) + Alltrim(cFile) ,0 )  ) == -1
	   If !MsgYesNo("No se puede Crear el Archivo "+Alltrim(cPath)+Alltrim(cFile)+Chr(13)+Chr(10)+"Continua?")
	      lSigue   := .F.
	      Exit
	   EndIf
	EndDo
ENDIF

lRetGan  := ( SubStr( GetMv("MV_AGENTE"), 1, 1 ) == "S" )
lRetIVA  := ( SubStr( GetMv("MV_AGENTE"), 2, 1 ) == "S" )

If lSigue

   DbSelectArea("SFE")
   DbSetOrder(1)
   DbGoTop()

   ProcRegua( LastRec() )

   While !Eof()

      IncProc()

      If  Alltrim( FE_TIPO ) <> "G" .AND.  Alltrim( FE_TIPO ) <> "I"
         DbSkip()
         Loop
      EndIf

      If FE_NROCERT == "NORET "   .OR. LEN(ALLTRIM(FE_CLIENTE))>0
         DbSkip()
         Loop
      EndIf

      If FE_VALBASE <= 0
         DbSkip()
         Loop
      EndIf
      
      If !Empty(FE_DTESTOR)
         DbSkip()
         Loop
      EndIf

      If FE_EMISSAO < mv_par01 .OR. FE_EMISSAO > mv_par02 .or. FE_RETENC == 0
         DbSkip()
         Loop
      EndIf

      cTipComp   := '6'  // retencion sobre OP
      cNroComp   := StrZero(val(FE_ORDPAGO),16)
      nImporte   := 0
      DbSelectArea( 'SEK' )
      DbSetOrder( 1 )
      DbSeek( xFilial( 'SEK' ) + SFE->FE_ORDPAGO )
      While !EOF() .and. EK_ORDPAGO == SFE->FE_ORDPAGO
         If EK_TIPODOC $ 'TB/PA'
            nImporte   += EK_VALOR
         EndIf
         DbSkip( )
      EndDo
      cFechaDoc  := SubStr( DtoC( SFE->FE_EMISSAO ), 1, 6 ) + Str( Year( SFE->FE_EMISSAO ), 4 )
      DbSelectArea( 'SFE' )

      //Trae valores y datos del contribuyente
      cFornece   := FE_FORNECE
      cLoja      := FE_LOJA
      cNeto      := StrZero( nImporte, 16, 2 )
      cNeto      := StrTran( cNeto, ".", "," )
      cBase    := StrZero(  FE_VALBASE , 14, 2 )
      cBase    := StrTran( cBase, ".", "," )
      SA2->(DbSetOrder(1))
      SA2->(DbSeek(xFilial("SA2") + cFornece + cLoja) )
                      
      //Define datos de regimen e impuesto ( codigos fiscales de AFIP )
      DbSelectArea("SFE")

      cTipoRet   := FE_TIPO
      IF Alltrim( cTipoRet ) == "G"//RETENCION DE GANANCIAS
      
      	 cConcepto  := FE_CONCEPT    // 07/06
         //Codigo de impuesto para proveedores del exterior
//         IF SA2->A2_TIPO=="E"
//            cCodImp    := "218"
//         ELSE//codigo de impuesto para proveedores nacionales
            cCodImp    := "217"
//         ENDIF
         cCodReg    := ExecBlock("ARFISP03",.F.,.F., { cTipoRet, cConcepto } )
         cCodReg := '078'
      
      ELSEIF Alltrim( cTipoRet ) == "I"//RETENCION DE IVA
      
      	 cConcepto  := FINDCFOIVA(FE_NFISCAL,FE_SERIE,cFornece,cLoja,FE_VALBASE)
         cCodImp    := "767"
         nPosCF     := 0
         //1- Impuesto, 2- Codigo fiscal, 3- Codigo fiscal compras , 4- Codigo fiscal ventas, 5- Serie Nota fiscal, 
         //6- Tipo responsable, 7- Descripcion 
         //Busca concepto por CF+Serie,  sino encuentra, busca por CF del comprobante
         nPosCF := Ascan(aCFOSIAP,{|x| alltrim(x[3])==alltrim(cConcepto) .and. alltrim(x[5])==Alltrim(SFE->FE_SERIE) })
         If nPosCF <> 0           
            cCodReg := SUBSTR(aCFOSIAP[nPosCF][2],1,3)
         Else    
            cCodReg := ExecBlock("ARFISP03",.F.,.F., { cTipoRet, cConcepto } )
         Endif
      ENDIF
      cCodOp   := "1"
      cFechRet := SubStr( DtoC( SFE->FE_EMISSAO ), 1, 6 ) + Str( Year( SFE->FE_EMISSAO ), 4 )
      If SA2->A2_TIPO == 'I'
		cCodCon := '01'
      Else
    	cCodCon := '02'
	  EndIf
      
      //Forma linea de archivo txt para exportacion
      cImpRet  := StrZero( SFE->FE_RETENC, 14, 2 )
      cImpRet  := StrTran( cImpRet, ".", "," )
      cPorcExc := "000,00"
      cFechBol := "01/12/1998"
      cTipoDoc := "80"
      cNroCUIT := PadR( Alltrim( SA2->A2_CGC ), 20 )
      cNroCOri := StrZero(val(SFE->FE_NROCERT),14)
 /*     
      If SA2->A2_TIPO=="E"
	      cString  := SubStr( Alltrim( cTipComp ) + Space( 2 ), 1, 2 ) + cFechaDoc + cNroComp + ;
	                  cNeto + "218" + "163" + cCodOp + cBase + cFechRet + cCodCon + "0" +;
	                  cImpRet  + cPorcExc  + cFechBol  + cTipoDoc  + cNroCUIT  + cNroCOri +;
	                  Replicate("A", 30) + "1" + "55000002126" + RTrim(cNroCUIT) + Chr(13) + Chr(10)
      Else
	      cString  := SubStr( Alltrim( cTipComp ) + Space( 2 ), 1, 2 ) + cFechaDoc + cNroComp +;
	                  cNeto + cCodImp + cCodReg + cCodOp + cBase + cFechRet + cCodCon + "0" +;
	                  cImpRet  + cPorcExc  + cFechBol  + cTipoDoc  + cNroCUIT  + cNroCOri +;
	                  space(53) + Chr(13)   + Chr(10)
      EndIf
  */
      If SA2->A2_TIPO=="E"
	      cString  := RIGHT( '00'+Alltrim( cTipComp ), 2 ) + cFechaDoc + cNroComp + ;
	                  cNeto + "218" + "163" + cCodOp + cBase + cFechRet + cCodCon + "0" +;
	                  cImpRet  + cPorcExc  + cFechBol  + cTipoDoc  + cNroCUIT  + cNroCOri +;
	                  Replicate("A", 30) + "1" + "55000002126" + RTrim(cNroCUIT) + Chr(13) + Chr(10)
      Else
	      cString  := RIGHT( '00'+Alltrim( cTipComp ), 2 ) + cFechaDoc + cNroComp +;
	                  cNeto + cCodImp + cCodReg + cCodOp + cBase + cFechRet + cCodCon + "0" +;
	                  cImpRet  + cPorcExc  + cFechBol  + cTipoDoc  + cNroCUIT  + cNroCOri +;
	                  space(53) + Chr(13)   + Chr(10)
      EndIf
      //Genera archivo o ambos
      IF nOpcion == 1 .or. nOpcion== 3
         FWrite(  nPuntero,  cString, Len(cString)  )
      ENDIF
      
      //Genera archivo o ambos
      IF nOpcion == 2 .or. nOpcion== 3
		    IF Len(aDetRet) == 0      
			      AADD(aDetRet,{ {"Emision  ","D"},{"Orden de Pago","C"},{"Importe Neto","N"},{"Importe  Base ","N"},{"Fecha Emision","D"},;
			                  {"Importe Retencion","N"},{"Cuit Proveedor","C"},{"Nro Certificado","C"} ,{"Codigo / Tienda","C"},{PADR("Razon Social",50),"C"},;
			                  {"Provincia","C"},{"Codigo Postal","C"},{"Tipo Retencion","C"},{"Impuesto","C"},{"Regimen","C"}} )
	      
	        ENDIF      
         AADD(aDetRet,{ DTOC(SFE->FE_EMISSAO),FE_ORDPAGO,StrTran( cNeto, ",", "." ),StrTran( cBase, ",", "." ),DTOC(SFE->FE_EMISSAO),;
              StrTran( cImpRet, ",", "." ),;
             SA2->A2_CGC,SFE->FE_NROCERT,SA2->A2_COD+"-"+SA2->A2_LOJA,SA2->A2_NOME,SA2->A2_EST,SA2->A2_CEP,FE_TIPO,cCodImp, cCodReg})
      ENDIF      

      DbSelectArea("SFE")
      DbSkip()

   EndDo


EndIf

SujRet( )
If len(aDetRet) > 0
//   If !MsgYesNo("Genera informe? ")
//      Return
//   EndIf
//   ImpSICORE(aDetRet,mv_par01,mv_par02)
      ARFISR01(aDetRet, cFile)
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³          ³ Autor ³Diego Fernando Rivero  ³ Data ³      2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function xCodReg()

cAlias   := Alias()

cRetCod := "   "

If cTipo == "G"
   DbSelectArea("SFF")
   DbSetOrder(5)
   DbSeek( xFilial() + "GAN" )

   While FF_IMPOSTO == "GAN" .and. !EOF()
      If FF_ITEM == cConcepto
         cRetCod := FF_CONSIC
         Exit
      EndIf
      DbSkip()
   EndDo
Else
   DbSelectArea("SFF")
   DbSetOrder(5)
   DbSeek( xFilial() + "IVR" )


EndIf

DbSelectArea( cAlias )


Return( cRetCod )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ PROCIB2  ³ Autor ³MS                     ³ Data ³14/02/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Genera Archivo de Percepciones de IIBB  BA                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RETF010                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³14/02/2006³ FAS ARG041    ³Creacion                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcIB2 ()

Local aDet     := {}
LOCAL cFilSA1 := xFilial ("SA1")
LOCAL cFilSA2 := xFilial ("SA2")
LOCAL lSigue := .T.
LOCAL cCuit:=cImp:=cMonto:=cTipo:=cSuc:=cLetra:=cConst:=cFecha:=""

//Genera archivo o ambos
IF nOpcion == 1 .or. nOpcion== 3
	While ( nPuntero := FCreate( Alltrim(cPath) + Alltrim(cFile) ) ) == -1
		If !MsgYesNo("No se puede Crear el Archivo "+Alltrim(cPath)+Alltrim(cFile)+Chr(13)+Chr(10)+"Continua?")
			lSigue   := .F.
			Exit
		EndIf
	EndDo
ENDIF

DbSelectArea("SL1")
DbSetOrder(2)


If lSigue
   
	cQuery := " SELECT SF1.F1_FORNECE, SF1.F1_LOJA, SF1.F1_EMISSAO, SF1.F1_DTDIGIT, SF1.F1_DOC, SF1.F1_ESPECIE, SF1.F1_SERIE, SF1.F1_TXMOEDA,  "
    cQuery += " SF1.F1_VALIMP6, SF1.F1_BASIMP6, SA1.A1_NOME  "
	cQuery += " FROM " + RetSQLName ("SF1")+ " SF1 " 
    cQuery += "    INNER JOIN "+ RetSQLName ("SA1") + " SA1 "
    cQuery += "       ON SA1.A1_COD=SF1.F1_FORNECE AND SA1.A1_LOJA=SF1.F1_LOJA AND SA1.D_E_L_E_T_='' " 
	cQuery += " WHERE"
    cQuery += " (SF1.F1_EMISSAO >= '" + DTOS(mv_par01) + "' AND SF1.F1_EMISSAO <='" + DTOS(mv_par02)+"')"
	cQuery += " AND (SF1.F1_VALIMP6 <> 0 ) AND (SF1.D_E_L_E_T_ <> '*') AND (SF1.F1_ESPECIE = 'NCC')"
	cQuery += " ORDER BY SF1.F1_DTDIGIT"

   	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), 'TMP' ,.T.,.T.)

	dbSelectArea ('TMP')
	dbGoTop ()
	ProcRegua( LastRec() )
	While !('TMP')->(EOF())
		IncProc()
		If TMP->F1_VALIMP6 != 0

 	        nFactor := -1
            cCUIT    := Alltrim(posicione("SA1",1,cFilSA1+TMP->(F1_FORNECE+F1_LOJA),"A1_CGC"))
            cCUIT    := substr(cCUIT,1,2)+"-"+substr(cCUIT,3,8)+"-"+substr(cCUIT,11,1)
//          cCUIT    := SubStr(posicione("SA2",1,cFilSA2+TMP->(F1_FORNECE+F1_LOJA),"A2_CGC"),1,13)
		    //Cuit para retencion BA sin guiones
		    /*IF GetNewPar("AL_PEBACUIT","S")=="S"
		       cCUIT := PADR(StrTran(cCUIT,"-",""),13," ")
		    ENDIF*/

			cImp	:= Str( TMP->F1_VALIMP6*TMP->F1_TXMOEDA, 11 )
			cImp 	:= Transform(TMP->F1_VALIMP6*TMP->F1_TXMOEDA,'@E 99999999.99')
/*
			cImp	:= Str( TMP->F1_VALIMP6*nFactor*TMP->F1_TXMOEDA, 11 )
			cImp 	:= Transform(TMP->F1_VALIMP6*nFactor*TMP->F1_TXMOEDA,'@E 99999999.99')
*/
			cImp 	:= StrTran( cImp, ".", "," )
			cImp    := StrTran( cImp, " ", "0" )
			cImp    := '-'+Substr(cImp,2)//Seryo
	        //IMPORTE CON punto DECIMAL en TXT PERCEPCIONES BA
	        IF GetNewPar("AL_PEBAIMPO","S")=="S"
//	           cImp  := StrTran( cImp, ",", "." ) //Seryo - No debe ser generado con punto
	        ENDIF

			cMonto	:= Str( TMP->F1_BASIMP6*TMP->F1_TXMOEDA, 12 )
			cMonto 	:= Transform(TMP->F1_BASIMP6*TMP->F1_TXMOEDA,'@E 999999999.99')
/*
			cMonto	:= Str( TMP->F1_BASIMP6*nFactor*TMP->F1_TXMOEDA, 12 )
			cMonto 	:= Transform(TMP->F1_BASIMP6*nFactor*TMP->F1_TXMOEDA,'@E 999999999.99')
*/
			cMonto  := StrTran( cMonto, ".", "," )
			cMonto  := StrTran( cMonto, " ", "0" )
			cMonto  := '-'+SUbstr(cMonto,2)
	        //IMPORTE CON punto DECIMAL en TXT PERCEPCIONES BA
	        IF GetNewPar("AL_PEBAIMPO","S")=="S"
//	           cMonto  := StrTran( cMonto, ",", "." ) //Seryo - No debe ser generado con punto
	        ENDIF

			If TMP->F1_ESPECIE = 'NF'
					cTipo := 'F'
			ElseIf TMP->F1_ESPECIE = 'NDP'
					cTipo := 'D'
			ElseIf TMP->F1_ESPECIE = 'NCC'
					cTipo := 'C'
			EndIf

			cSuc 	:= SubStr(TMP->F1_DOC,1,4)
			cConst 	:= SubStr(TMP->F1_DOC,5,12)
			cLetra 	:= SubStr(TMP->F1_SERIE,1,1)
            cFecha   := SUBSTR(TMP->F1_EMISSAO,7,2)+"/"+SUBSTR(TMP->F1_EMISSAO,5,2)+"/"+SUBSTR(TMP->F1_EMISSAO,1,4) // Cambiado por nicolas el 18/05/09

			/*/------------Estructura a pasar-----------------------------------//
                                            	DESDE HASTA  TIPO     LONGITUD
         	Cuit del Percibido 		  	:= ''     1      13    Texto         13
         	Fecha de Percep. 	   		:= ''    14      23    Fecha         10
         	Tipo Comprobante(F-R-C-D)	:= ''    24      24    Texto         01
         	Letra Comprobante(A-B-C-D-M):= ''    25      25    Texto         01
         	Numero de Sucursal			:= ''    26      29    decimal		 04
         	Numero Emision				:= ''    30      37    Decimal       08
         	monto Imponible  			:= ''    38      49    Decimal       12
           	Importe Percibido  			:= ''    50      60    Decimal       11

      		*/

			cString := cCUIT + cFecha + cTipo + cLetra + cSuc + cConst  +  cMonto + cImp + "A" +Chr(13) + Chr(10)
            
            //Genera archivo o ambos
            IF nOpcion == 1 .or. nOpcion== 3
			   FWrite(  nPuntero,  cString, Len( cString )  )
            ENDIF
            
            //datos para impresion      
            //Genera archivo o ambos
            IF nOpcion == 2 .or. nOpcion== 3
	            IF Len(aDet) = 0      
	               AADD(aDet,{ {"Numero de CUIT","C"} ,{"Codigo / Tienda","C"},{PADR("Razon Social",50),"C"}, {"Fecha comprobante","D"} , {"Tipo Comprob","C"} ,;
	                           {"Letra comprob","C"} , {"Sucursal","C"} , {"Comprobante","C"}  ,  {"Importe base","N"} , {"Importe percepcion","N"}  })
	            ENDIF
	            AADD(aDet,{ cCUIT , TMP->F1_FORNECE+"-"+TMP->F1_LOJA, UPPER(TMP->A1_NOME), cFecha , ;
	                       cTipo , cLetra , cSuc , cConst  ,  StrTran(  cMonto, ",", "." ) , StrTran(  cImp, ",", "." )  })
            ENDIF

			dbSelectArea ('TMP')
			DbSkip ()

		EndIf
	EndDo
	dbSelectArea ('TMP')
	dbCloseArea ()

	cQuery := " SELECT SF2.F2_FILIAL, SF2.F2_CLIENTE, SF2.F2_LOJA, SF2.F2_EMISSAO, SF2.F2_DTDIGIT, SF2.F2_DOC, " 
	cQuery += " SF2.F2_ESPECIE, SF2.F2_SERIE, SF2.F2_TXMOEDA,  "
    cQuery += " SF2.F2_VALIMP6, SF2.F2_BASIMP6, SA1.A1_NOME  "
	cQuery += " FROM " + RetSQLName ("SF2") + " SF2 "
    cQuery += "    INNER JOIN "+ RetSQLName ("SA1") + " SA1 "
    cQuery += "       ON SA1.A1_COD=SF2.F2_CLIENTE AND SA1.A1_LOJA=SF2.F2_LOJA AND SA1.D_E_L_E_T_='' " 
	cQuery += " WHERE (SF2.D_E_L_E_T_ <> '*') "
    cQuery += "  AND (SF2.F2_EMISSAO >= '" + DTOS(mv_par01) + "' AND SF2.F2_EMISSAO <='" + DTOS(mv_par02)+"')"
	cQuery += "  AND (SF2.F2_ESPECIE = 'NF ' OR SF2.F2_ESPECIE = 'NDC' OR SF2.F2_ESPECIE = 'CF ') "
	cQuery += "  AND (SF2.F2_VALIMP6 <> 0 )"
	cQuery += " ORDER BY SF2.F2_DTDIGIT"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), 'TMP' ,.T.,.T.)

	dbSelectArea ('TMP')
	dbGoTop ()
	ProcRegua( LastRec() )
	While !('TMP')->(EOF())
		IncProc()
		If TMP->F2_VALIMP6 != 0
//         cCUIT    := SubStr(posicione("SA2",1,cFilSA2+TMP->(F2_CLIENTE+F2_LOJA),"A2_CGC"),1,13)
            cCUIT    := Alltrim(posicione("SA1",1,cFilSA1+TMP->(F2_CLIENTE+F2_LOJA),"A1_CGC"))
            cCUIT    := substr(cCUIT,1,2)+"-"+substr(cCUIT,3,8)+"-"+substr(cCUIT,11,1)

            //------------------------------------------------------------   
            //busca cupon fiscal para ver los datos de interes tarjeta
			nValSL1IB  := 0
			nBasSL1IB  := 0
		    If Alltrim(TMP->F2_ESPECIE) =="CF"
				SL1->( dbSetOrder(2) )
				SL1->( dbSeek( TMP->F2_FILIAL+TMP->F2_SERIE+TMP->F2_DOC ) )
				nBasSL1IB   := 0 //SL1->L1_XBASINT
				nValSL1IB   := 0 //SL1->L1_XIBINT
			ENDIF
            //---------------------------------------------------
			cImp	:=	Str( TMP->F2_VALIMP6+nValSL1IB, 11 )
			cImp 	:= 	Transform(TMP->F2_VALIMP6+nValSL1IB,'@E 99999999.99')
			StrTran( cImp, ".", "," )
			cImp  := StrTran( cImp, " ", "0" )
			cMonto	:=	Str( TMP->F2_BASIMP6+nBasSL1IB, 12 )
			cMonto 	:= 	Transform(TMP->F2_BASIMP6+nBasSL1IB,'@E 999999999.99')
			StrTran( cMonto, ".", "," )
			cMonto  := StrTran( cMonto, " ", "0" )

			If TMP->F2_ESPECIE = 'NF' .or. Alltrim(TMP->F2_ESPECIE) = 'CF'
				cTipo := 'F'
			ElseIf TMP->F2_ESPECIE = 'NDC'
				cTipo := 'D'
			ElseIf TMP->F2_ESPECIE = 'NCP'
				cTipo := 'C'
			Else
				cTipo := 'O'
			EndIf
			cSuc := SubStr(TMP->F2_DOC,1,4)
			cConst := SubStr(TMP->F2_DOC,5,12)
			cLetra := SubStr(TMP->F2_SERIE,1,1)
            cFecha := SUBSTR(TMP->F2_EMISSAO,7,2)+"/"+SUBSTR(TMP->F2_EMISSAO,5,2)+"/"+SUBSTR(TMP->F2_EMISSAO,1,4)  //Modificado por Nicolas el 18/05/09

			/*/------------Estructura a pasar-----------------------------------//
                                            	DESDE HASTA  TIPO     LONGITUD
         	Cuit del Percibido 		  	:= ''     1      13    Texto         13
         	Fecha de Percep. 	   		:= ''    14      23    Fecha         10
         	Tipo Comprobante(F-R-C-D)	:= ''    24      24    Texto         01
         	Letra Comprobante(A-B-C-D-M):= ''    25      25    Texto         01
         	Numero de Sucursal			:= ''    26      29    decimal		 04
         	Numero Emision				:= ''    30      37    Decimal       08
         	monto Imponible  			:= ''    38      49    Decimal       12
           	Importe Percibido  			:= ''    50      60    Decimal       11

      		*/

			cString := cCUIT + cFecha + cTipo + cLetra + cSuc + cConst  +  cMonto + cImp + "A"+Chr(13) + Chr(10)
            //Genera archivo o ambos
            IF nOpcion == 1 .or. nOpcion== 3
			   FWrite(  nPuntero,  cString, Len( cString )  )
            ENDIF
            //datos para impresion      
            //Genera archivo o ambos
            IF nOpcion == 2 .or. nOpcion== 3
	            IF Len(aDet) == 0      
	               AADD(aDet,{ {"Numero de CUIT","C"} ,{"Codigo / Tienda","C"},{PADR("Razon Social",50),"C"}, {"Fecha comprobante","D"} , {"Tipo Comprob","C"} ,;
	                           {"Letra comprob","C"} , {"Sucursal","C"} , {"Comprobante","C"}  ,  {"Importe base","N"} , {"Importe percepcion","N"}  })
	            ENDIF
	            AADD(aDet,{ cCUIT ,TMP->F2_CLIENTE+"-"+TMP->F2_LOJA,UPPER(TMP->A1_NOME), cFecha ,;
	                       cTipo , cLetra , cSuc , cConst  ,  StrTran(  cMonto, ",", "." ) , StrTran(  cImp, ",", "." )  })
            ENDIF
            
			dbSelectArea ('TMP')
			dbSkip ()
		EndIf
	EndDo
	dbSelectArea ('TMP')
	dbCloseArea ()

EndIf
                     

   If len(aDet) > 0
//      If !MsgYesNo("Genera informe? ")
//         Return
//      EndIf
      ARFISR01(aDet,cFile)
   EndIf
  

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ PROCIVA  ³ Autor ³MS                     ³ Data ³14/02/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Genera Archivo de Percepciones de IVA Clientes             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RETF010                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³14/02/2006³ FAS ARG041    ³Creacion                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcIVA ()
LOCAL cFilSA1 := xFilial ("SA1")
LOCAL cFilSA2 := xFilial ("SA2")
LOCAL lSigue := .T.
LOCAL cPorcExc 	:= "000,00"
LOCAL cFechBol 	:= "01/12/1998"
LOCAL cTipoDoc 	:= "80"
LOCAL cCodImp  	:= "767"
LOCAL cCodReg	:= "493"
LOCAL cCodOp	:= "1"
LOCAL cCodCon 	:= "00"
Local aDet     := {}

LOCAL cFechaDoc:=cNroCUIT:=cImpRet:=cBase:=cNeto:=cMonto:=cTipComp:=cNroComp:=cFechaDoc:=cFechRet:=cNroCOri:=""

//Genera archivo o ambos
IF nOpcion == 1 .or. nOpcion== 3
	While ( nPuntero := FCreate( Alltrim(cPath) + Alltrim(cFile) ) ) == -1
		If !MsgYesNo("No se puede Crear el Archivo "+Alltrim(cPath)+Alltrim(cFile)+Chr(13)+Chr(10)+"Continua?")
			lSigue   := .F.
			Exit
		EndIf
	EndDo
ENDIF

If lSigue

	cQuery := "SELECT F1_FORNECE, F1_LOJA, F1_EMISSAO, F1_DTDIGIT, F1_DOC, F1_ESPECIE, F1_SERIE, F1_VALIMP4, F1_BASIMP4 , F1_VALBRUT "
	cQuery += "FROM " + RetSQLName ("SF1") +" WHERE"
   cQuery += " (F1_EMISSAO >= '" + DTOS(mv_par01) + "' AND F1_EMISSAO <='" + DTOS(mv_par02)+"')"
	cQuery += " AND (F1_VALIMP4 <> 0 ) AND (D_E_L_E_T_ <> '*') AND (F1_ESPECIE = 'NCC')"
	cQuery += " ORDER BY F1_DTDIGIT"

   	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), 'TMP' ,.T.,.T.)

	dbSelectArea ('TMP')
	dbGoTop ()
	ProcRegua( LastRec() )
	While !('TMP')->(EOF())
		IncProc()
		If TMP->F1_VALIMP4 != 0
			cNroCUIT  	:= PadR(Alltrim(posicione("SA1",1,cFilSA1+TMP->(F1_FORNECE+F1_LOJA),"A1_CGC")),20)
			// valor percep.
			cImpRet	:=Str( TMP->F1_VALIMP4, 14 )
			cImpRet := Transform(TMP->F1_VALIMP4,'@E 99999999999.99')
			StrTran( cImpRet, ".", "," )
			// monto Base
			cBase	:=Str( TMP->F1_BASIMP4, 14 )
			cBase 	:= Transform(TMP->F1_BASIMP4,'@E 99999999999.99')
			StrTran( cBase, ".", "," )
			// monto Bruto
			cNeto	:=Str( TMP->F1_VALBRUT, 16 )
			cNeto 	:= Transform(TMP->F1_VALBRUT,'@E 9999999999999.99')
			StrTran( cNeto, ".", "," )
			// Tipo Comprobante
			If TMP->F1_ESPECIE = 'NF'
					cTipComp := '01'
			ElseIf TMP->F1_ESPECIE = 'NDC'
					cTipComp := '04'
			ElseIf TMP->F1_ESPECIE = 'NCC'
					cTipComp := '03'
			EndIf
			// Fecha
         cFechaDoc   := SUBSTR(TMP->F1_EMISSAO,7,2)+"/"+SUBSTR(TMP->F1_EMISSAO,5,2)+"/"+SUBSTR(TMP->F1_EMISSAO,1,4)
			//Nro Comprobante
			cNroComp 	:= StrZero(val(TMP->F1_DOC),16)
			// cFecha Ret
			cFechRet	:= cFechaDoc
			// Comprob. Original
			cNroCOri	:= "00000000000000"

			/*/------------Estructura a pasar-----------------------------------//
                                            	DESDE HASTA  TIPO     LONGITUD
         	Tipo Comprob	 		  				1      1    Texto         1
         	Fecha de Percep. 	   				    2      11   Fecha         10
         	Nro Comprob.                			12     27   texto         16
         	Monto Neto					    		28     43  decimal        16
         	Codigo Impuesto (767)                   44     46   texto		  03
         	Codigo regimen (493)                    47	   49   texto		  03
         	Codigo Operacion(1)			    		50     50   Texto         1
         	Base Percepcion (14)			    	51     64   decimal		  14
         	Fecha Perc					    		65     74   fecha         08
         	Codigo con		  			    		75     76   texto	      2
           	Importe Percibido  			    		77     90   Decimal       14
            Porc exencion (000,00)                  91     96   texto		  6
            Fecha bol                               97    106   fecha		  10
            Tipo Documento                         107    108   texto		  2
            Nro Cuit                               109    128   texto		  20
            Nro certif. orig.                      129    142   text0		  14
      		*/

			cString  := cTipComp  + cFechaDoc + cNroComp + ;
                  		cNeto + cCodImp + cCodReg + cCodOp + cBase + cFechRet + cCodCon + "0" +;
                  		cImpRet  + cPorcExc  + cFechBol  + cTipoDoc  + cNroCUIT  + cNroCOri + ;
                 		space(14) + Chr(13)   + Chr(10)

            //Genera archivo o ambos
            IF nOpcion == 1 .or. nOpcion== 3
			   FWrite(  nPuntero,  cString, Len( cString )  )
            ENDIF
            //Genera archivo o ambos
            IF nOpcion == 2 .or. nOpcion== 3
               AADD(aDet,{ TMP->F1_ESPECIE,cFechaDoc,TMP->F1_DOC,TMP->F1_VALBRUT,TMP->F1_BASIMP4,TMP->F1_VALIMP4,cNroCUIT })
            ENDIF
            
			dbSelectArea ('TMP')
			DbSkip ()

		EndIf
	EndDo
	dbSelectArea ('TMP')
	dbCloseArea ()

	cQuery := "SELECT F2_CLIENTE, F2_LOJA, F2_EMISSAO, F2_DTDIGIT, F2_DOC, F2_ESPECIE, F2_SERIE, F2_VALIMP4, F2_BASIMP4 , F2_VALBRUT "
	cQuery += "FROM " + RetSQLName ("SF2") +" WHERE"
   cQuery += " (F2_EMISSAO >= '" + DTOS(mv_par01) + "' AND F2_EMISSAO <='" + DTOS(mv_par02)+"')"
	cQuery += " AND (F2_VALIMP4 <> 0 ) AND (D_E_L_E_T_ <> '*') AND (F2_ESPECIE = 'NF ' OR F2_ESPECIE = 'NDC') "
	cQuery += " ORDER BY F2_DTDIGIT"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), 'TMP' ,.T.,.T.)

	dbSelectArea ('TMP')
	dbGoTop ()
	ProcRegua( LastRec() )
	While !('TMP')->(EOF())
		IncProc()
		If TMP->F2_VALIMP4 != 0
			cNroCUIT  	:= PadR(Alltrim(posicione("SA1",1,cFilSA1+TMP->(F2_CLIENTE+F2_LOJA),"A1_CGC")),20)
			// valor percep.
			cImpRet	:=Str( TMP->F2_VALIMP4, 14 )
			cImpRet := Transform(TMP->F2_VALIMP4,'@E 99999999999.99')
			StrTran( cImpRet, ".", "," )
			// monto Base
			cBase	:=Str( TMP->F2_BASIMP4, 14 )
			cBase 	:= Transform(TMP->F2_BASIMP4,'@E 99999999999.99')
			StrTran( cBase, ".", "," )
			// monto Bruto
			cNeto	:=Str( TMP->F2_VALBRUT, 16 )
			cNeto 	:= Transform(TMP->F2_VALBRUT,'@E 9999999999999.99')
			StrTran( cNeto, ".", "," )
			// Tipo Comprobante
			If TMP->F2_ESPECIE = 'NF'
					cTipComp := '01'
			ElseIf TMP->F2_ESPECIE = 'NDC'
					cTipComp := '04'
			ElseIf TMP->F2_ESPECIE = 'NCC'
					cTipComp := '03'
			EndIf
			// Fecha
         cFechaDoc   := SUBSTR(TMP->F2_EMISSAO,7,2)+"/"+SUBSTR(TMP->F2_EMISSAO,5,2)+"/"+SUBSTR(TMP->F2_EMISSAO,1,4)
			//Nro Comprobante
			cNroComp 	:= StrZero(val(TMP->F2_DOC),16)
			// cFecha Ret
			cFechRet	:= cFechaDoc
			// Comprob. Original
			cNroCOri	:= "00000000000000"

			CString  := cTipComp + cFechaDoc + cNroComp + ;
                  		cNeto + cCodImp + cCodReg + cCodOp + cBase + cFechRet + cCodCon + "0" +;
                  		cImpRet  + cPorcExc  + cFechBol  + cTipoDoc  + cNroCUIT  + cNroCOri + ;
                  		space(14) + Chr(13)   + Chr(10)

            //Genera archivo o ambos
            IF nOpcion == 1 .or. nOpcion== 3
			   FWrite(  nPuntero,  cString, Len( cString )  )
            ENDIF
            //Genera archivo o ambos
            IF nOpcion == 2 .or. nOpcion== 3
               AADD(aDet,{ TMP->F2_ESPECIE,cFechaDoc,TMP->F2_DOC,TMP->F2_VALBRUT,TMP->F2_BASIMP4,TMP->F2_VALIMP4,cNroCUIT })
			ENDIF
			
			dbSelectArea ('TMP')
			dbSkip ()
		EndIf
	EndDo
   If len(aDet) > 0
//      If !MsgYesNo("Genera informe? ")
//         Return
//      EndIf
      ImpProIVA(aDet,mv_par01,mv_par02)
   EndIf
	dbSelectArea ('TMP')
	dbCloseArea ()
endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³          ³ Autor ³Microsiga Argentina    ³ Data ³14/08/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidPerg()

LOCAL aVldSX1  := GetArea()
LOCAL aCposSX1 := {}
LOCAL aPergs   := {}


aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL	",;
"X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1",;
"X1_CNT01","X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02" ,"X1_VAR03",;
"X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03","X1_VAR04","X1_DEF04","X1_DEFSPA4",;
"X1_DEFENG4","X1_CNT04","X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
"X1_F3","X1_GRPSXG"}


aAdd(aPergs,{'Desde Fecha ?','Desde Fecha ?','Desde Fecha ?','mv_ch1','D', 08, 0, 0, 'G', '', 'mv_par01','','','','','','','','','','','','','','','','','','','','','','','','','',''})
aAdd(aPergs,{'Hasta Fecha ?','Hasta Fecha ?','Hasta Fecha ?','mv_ch2','D', 08, 0, 0, 'G', '', 'mv_par02','','','','','','','','','','','','','','','','','','','','','','','','','',''})
aAdd(aPergs,{'De Certificado ?','De Certificado ?','De Certificado ?','mv_ch3','C', 06, 0, 0, 'G', '', 'mv_par03','','','','','','','','','','','','','','','','','','','','','','','','','',''})
aAdd(aPergs,{'A  Certificado ?','A  Certificado ?','A  Certificado ?','mv_ch4','C', 06, 0, 0, 'G', '', 'mv_par04','','','','','','','','','','','','','','','','','','','','','','','','','',''})

dbSelectArea( "SX1" )
dbSetOrder( 1 )
For nX:=1 to Len( aPergs )
	If !( dbSeek( cPerg  + StrZero( nx, 2 ) ) )
		RecLock( "SX1", .T. )
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with StrZero( nx, 2 )
		for nj:=1 to Len( aCposSX1 )
			FieldPut( FieldPos( ALLTRIM( aCposSX1[nJ] ) ), aPergs[nx][nj] )
		next nj
		MsUnlock()
	Endif
Next

RestArea( aVldSX1 )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ ProcPER ³ Autor ³Totvs Argentina        ³ Data ³14/02/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Genera Archivo de Percepciones de IIBB                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RETF010 Si.Fe.Re.                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³14/02/2006³               ³Creacion                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcPER ()

Local aDetPer   := {}
Local aDetRet   := {}
Local nPuntExtr 
Local nPuntAdu 
Local cArSifRB  := ""
Local cArSifR   := ""
Local lXISADU   := SA2->(FieldPos("A2_XISADU")) > 0//campo que indica si el proveedor es aduana
Local MVXISADU  := GETNEWPAR("MV_XISADU","000826/")//parametro para determinar los codigos de proveedores de aduana
Local aJuris:= {{"5","901",""},;
                     {"6","902",""},;
                     {"7","924",""},;
                     {"B","919",""},;
                     {"C","903","CA"},;
                     {"D","907","CHUBUT"},;
                     {"E","906","CHACO"},;
                     {"F","904","CORDOBA"},;
                     {"G","908","ENTRE RIOS"},;
                     {"J","909","FORMOSA"},;
                     {"W","905","CORRIENTES"},;
                     {"K","911","LA PAMPA"},;
                     {"L","912","LA RIOJA"},;
                     {"M","913","MENDOZA"},;
                     {"N","914","MISIONES"},;
                     {"O","915","NEUQUEN"},;
                     {"P","917",""},;
                     {"Q","920",""},;
                     {"R","921","SANTA FE"},;
                     {"S","916","RIO NEGRO"},;
                     {"T","922",""},;
                     {"U","918","SAN JUAN"},;
                     {"V","923","TIERRA DEL FUEGO"}}				

cFilSA1 := xFilial ("SA1")
cFilSA2 := xFilial ("SA2")
lAmbos := .F.
lSigue := .T.

//Genera archivo o ambos
IF nOpcion == 1 .or. nOpcion== 3
	While ( nPuntero := FCreate( Alltrim(cPath) + Alltrim(cFile) ) ) == -1
		If !MsgYesNo("No se puede Crear el Archivo "+Alltrim(cPath)+Alltrim(cFile)+Chr(13)+Chr(10)+"Continua?")
			lSigue   := .F.
			Exit
		EndIf
	EndDo                                                 
	cArSifR:=Alltrim(cPath)  + SUBSTR(Alltrim(cFile),1,len(Alltrim(cFile))-4)+ "_RET.txt" 
	While ( nPuntRet := FCreate(cArSifR ) ) == -1
	   If !MsgYesNo("No se puede Crear el Archivo "+cArSifR+Chr(13)+Chr(10)+"Continua?")
			lSigue   := .F.
			Exit
		EndIf
	EndDo 
	cArSifRB:=Alltrim(cPath)  + SUBSTR(Alltrim(cFile),1,len(Alltrim(cFile))-4)+ "_Bancario.txt" 
	While ( nPuntExtr := FCreate( cArSifRB ) ) == -1
	   If !MsgYesNo("No se puede Crear el Archivo "+cArSifRB + Chr(13)+Chr(10)+"Continua?")
			lSigue   := .F.
			Exit
		EndIf
	EndDo
	cArSifAD:=Alltrim(cPath)  + SUBSTR(Alltrim(cFile),1,len(Alltrim(cFile))-4)+ "_Aduana.txt" 
	While ( nPuntAdu := FCreate( cArSifAD ) ) == -1
	   If !MsgYesNo("No se puede Crear el Archivo "+cArSifAD + Chr(13)+Chr(10)+"Continua?")
			lSigue   := .F.
			Exit
		EndIf
	EndDo
ENDIF

If lSigue

	cQuery := "SELECT F1_FORNECE, F1_LOJA, F1_EMISSAO, F1_DTDIGIT, F1_DOC, F1_ESPECIE, F1_SERIE, F1_VALIMP5, F1_VALIMP6, "
	cQuery += " F1_VALIMP7, F1_VALIMPB, F1_VALIMPC, F1_VALIMPD, F1_VALIMPE, F1_VALIMPF, F1_VALIMPG, F1_VALIMPJ, F1_VALIMPW, "
	cQuery += " F1_VALIMPK, F1_VALIMPL, F1_VALIMPM, F1_VALIMPN, F1_VALIMPO, F1_VALIMPP, F1_VALIMPQ, F1_VALIMPR, F1_VALIMPS, "
	cQuery += " F1_VALIMPT, F1_VALIMPU, F1_VALIMPV, "
	cQuery += " F1_MOEDA, F1_TXMOEDA, F1_PROVENT , F1_NUMDES "
	cQuery += "FROM " + RetSQLName ("SF1") +" WHERE"
	cQuery += " (F1_DTDIGIT >= '" + DTOS(mv_par01) + "' AND F1_DTDIGIT <='" + DTOS(mv_par02)+"')"
	cQuery += " AND (F1_VALIMP5 <> 0 OR F1_VALIMP6 <> 0 OR F1_VALIMP7 <> 0 OR F1_VALIMPB <> 0 OR F1_VALIMPC <> 0 OR F1_VALIMPD <> 0 OR F1_VALIMPE <> 0 OR F1_VALIMPF <> 0 OR F1_VALIMPG <> 0 OR F1_VALIMPJ <> 0 OR F1_VALIMPW <> 0 OR F1_VALIMPK <> 0 OR F1_VALIMPL <> 0 OR F1_VALIMPM <> 0 OR F1_VALIMPN <> 0 OR F1_VALIMPO <> 0 OR F1_VALIMPP <> 0 OR F1_VALIMPQ <> 0 OR F1_VALIMPR <> 0 OR F1_VALIMPS <> 0 OR F1_VALIMPT <> 0 OR F1_VALIMPU <> 0 OR F1_VALIMPV <> 0) AND (D_E_L_E_T_ <> '*')"
	cQuery += " AND F1_ESPECIE IN ('NF','NDP') "      
	cQuery += " ORDER BY F1_DTDIGIT"
	//cQuery += " AND F1_XEXTRAC <> '1' AND F1_ESPECIE IN ('NF','NDP') "      

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), 'TMP' ,.T.,.T.)

	dbSelectArea ('TMP')
	dbGoTop ()
	ProcRegua( LastRec() )
	While !('TMP')->(EOF())
		IncProc()
		If TMP->F1_VALIMP5 != 0 .OR. TMP->F1_VALIMP6 != 0 .OR. TMP->F1_VALIMP7 != 0 .OR. TMP->F1_VALIMPB != 0 .OR. TMP->F1_VALIMPC != 0 .OR. TMP->F1_VALIMPD != 0 .OR. TMP->F1_VALIMPE != 0 .OR. TMP->F1_VALIMPF != 0 .OR. TMP->F1_VALIMPG != 0 .OR. TMP->F1_VALIMPJ != 0 .OR. TMP->F1_VALIMPW != 0 .OR. TMP->F1_VALIMPK != 0 .OR. TMP->F1_VALIMPL != 0 .OR. TMP->F1_VALIMPM != 0 .OR. TMP->F1_VALIMPN != 0 .OR. TMP->F1_VALIMPO != 0 .OR. TMP->F1_VALIMPP != 0 .OR. TMP->F1_VALIMPQ != 0 .OR. TMP->F1_VALIMPR != 0 .OR. TMP->F1_VALIMPS != 0 .OR. TMP->F1_VALIMPT != 0 .OR. TMP->F1_VALIMPU != 0 .OR. TMP->F1_VALIMPV != 0
		
		    SA2->(DbSeek(cFilSA2+TMP->(F1_FORNECE+F1_LOJA)))
			cCUIT := alltrim(posicione("SA2",1,cFilSA2+TMP->(F1_FORNECE+F1_LOJA),"A2_CGC"))
			cCUIT := left(ccuit,2)+'-'+substr(ccuit,3,8)+'-'+right(ccuit,1)
			If TMP->F1_ESPECIE = 'NF'
				cTipo := 'F'
			ElseIf TMP->F1_ESPECIE = 'NDP'
				cTipo := 'D'
			Else
				cTipo := 'C'
			EndIf
			cSuc     := SubStr(TMP->F1_DOC,1,4)
			cConst   := SubStr(TMP->F1_DOC,5,12)
			cLetra   := SubStr(TMP->F1_SERIE,1,1)
			cFecha   := SUBSTR(TMP->F1_DTDIGIT,7,2)+"/"+SUBSTR(TMP->F1_DTDIGIT,5,2)+"/"+SUBSTR(TMP->F1_DTDIGIT,1,4)
            cRazon   := Posicione( 'SA2', 1, xFilial('SA2')+TMP->F1_FORNECE+TMP->F1_LOJA, 'A2_NOME' )
            cDespacho:= PADL(TMP->F1_NUMDES,20," ")
            
            For k:=1 to len(aJuris)
                cCampo:="TMP->F1_VALIMP"+aJuris[k,1]
				If &(cCampo) != 0
					nImporte := &(cCampo) * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
					nImp     := Str( nImporte, 14 )
					nImp     := Transform(nImporte,'@E 99999999.99') 
					nImpAdu  := Transform(nImporte,'@E 9999999.99')
					StrTran( nImp, ".", "," )
					nimp:= '+'+right('00000000'+alltrim(nimp),10)
					nimpAdu:= '+'+right('0000000'+alltrim(nimp),9)
					cCod     := aJuris[k,2]//codigo jurisdiccion "901"
	                                      
	                 //formato aduana
					IF (lXISADU .and. SA2->A2_XISADU=="S") .or. SA2->A2_COD $ MVXISADU
					   
					    cString := cCod + cCUIT + cFecha + cDespacho +  nImpAdu + Chr(13) + Chr(10) 
		                //Genera archivo o ambos
		                IF nOpcion == 1 .or. nOpcion== 3
						   FWrite(  nPuntAdu,  cString, Len( cString )  )
						ENDIF
		                //Genera archivo o ambos
		                IF nOpcion == 2 .or. nOpcion== 3
				           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
				        ENDIF
					   
					ELSE// formato general
					    cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
		                //Genera archivo o ambos
		                IF nOpcion == 1 .or. nOpcion== 3
						   FWrite(  nPuntero,  cString, Len( cString )  )
						ENDIF
		                //Genera archivo o ambos
		                IF nOpcion == 2 .or. nOpcion== 3
				           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
				        ENDIF
					
					ENDIF
				EndIf                  
			Next k

			dbSelectArea ('TMP')
			DbSkip ()
		EndIf
	EndDo

	dbSelectArea ('TMP')
	dbCloseArea ()

//---------- Notas de Credito
	cQuery := "SELECT F2_CLIENTE, F2_LOJA, F2_EMISSAO, F2_DTDIGIT, F2_DOC, F2_ESPECIE, F2_SERIE, F2_VALIMP5, F2_VALIMP6, F2_VALIMP7, F2_VALIMPB, F2_VALIMPC, F2_VALIMPD, F2_VALIMPE, F2_VALIMPF, F2_VALIMPG, F2_VALIMPJ, F2_VALIMPW, F2_VALIMPK, F2_VALIMPL, F2_VALIMPM, F2_VALIMPN, F2_VALIMPO, F2_VALIMPP, F2_VALIMPQ, F2_VALIMPR, F2_VALIMPS, F2_VALIMPT, F2_VALIMPU, F2_VALIMPV, "
	cQuery += "F2_MOEDA, F2_TXMOEDA, F2_PROVENT "
	cQuery += "FROM " + RetSQLName ("SF2") +" WHERE"
	cQuery += " (F2_DTDIGIT >= '" + DTOS(mv_par01) + "' AND F2_DTDIGIT <='" + DTOS(mv_par02)+"')"
	cQuery += " AND (F2_VALIMP5 <> 0 OR F2_VALIMP6 <> 0 OR F2_VALIMP7 <> 0 OR F2_VALIMPB <> 0 OR F2_VALIMPC <> 0 OR F2_VALIMPD <> 0 OR F2_VALIMPE <> 0 OR F2_VALIMPF <> 0 OR F2_VALIMPG <> 0 OR F2_VALIMPJ <> 0 OR F2_VALIMPW <> 0 OR F2_VALIMPK <> 0 OR F2_VALIMPL <> 0 OR F2_VALIMPM <> 0 OR F2_VALIMPN <> 0 OR F2_VALIMPO <> 0 OR F2_VALIMPP <> 0 OR F2_VALIMPQ <> 0 OR F2_VALIMPR <> 0 OR F2_VALIMPS <> 0 OR F2_VALIMPT <> 0 OR F2_VALIMPU <> 0 OR F2_VALIMPV <> 0) AND (D_E_L_E_T_ <> '*')"
	cQuery += " AND F2_ESPECIE = 'NCP' "
	cQuery += " ORDER BY F2_DTDIGIT"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), 'TMP' ,.T.,.T.)

	dbSelectArea ('TMP')
	dbGoTop ()
	ProcRegua( LastRec() )
	While !('TMP')->(EOF())
		IncProc()
		If TMP->F2_VALIMP5 != 0 .OR. TMP->F2_VALIMP6 != 0 .OR. TMP->F2_VALIMP7 != 0 .OR. TMP->F2_VALIMPB != 0 .OR. TMP->F2_VALIMPC != 0 .OR. TMP->F2_VALIMPD != 0 .OR. TMP->F2_VALIMPE != 0 .OR. TMP->F2_VALIMPF != 0 .OR. TMP->F2_VALIMPG != 0 .OR. TMP->F2_VALIMPJ != 0 .OR. TMP->F2_VALIMPW != 0 .OR. TMP->F2_VALIMPK != 0 .OR. TMP->F2_VALIMPL != 0 .OR. TMP->F2_VALIMPM != 0 .OR. TMP->F2_VALIMPN != 0 .OR. TMP->F2_VALIMPO != 0 .OR. TMP->F2_VALIMPP != 0 .OR. TMP->F2_VALIMPQ != 0 .OR. TMP->F2_VALIMPR != 0 .OR. TMP->F2_VALIMPS != 0 .OR. TMP->F2_VALIMPT != 0 .OR. TMP->F2_VALIMPU != 0 .OR. TMP->F2_VALIMPV != 0
			cCUIT := alltrim(posicione("SA2",1,cFilSA2+TMP->(F2_CLIENTE+F2_LOJA),"A2_CGC"))
			cTipo := 'C'
			cSuc   := SubStr(TMP->F2_DOC,1,4)
			cConst := SubStr(TMP->F2_DOC,5,12)
			cLetra := SubStr(TMP->F2_SERIE,1,1)
			cFecha := SUBSTR(TMP->F2_DTDIGIT,7,2)+"/"+SUBSTR(TMP->F2_DTDIGIT,5,2)+"/"+SUBSTR(TMP->F2_DTDIGIT,1,4)
	        cRazon := Posicione( 'SA2', 1, xFilial('SA2')+TMP->F2_CLIENTE+TMP->F2_LOJA, 'A2_NOME' )
			cCUIT := left(ccuit,2)+'-'+substr(ccuit,3,8)+'-'+right(ccuit,1)
           	nFactor := -1
         
			If TMP->F2_VALIMP5 != 0// .AND. lAmbos == .F.
				nImporte := TMP->F2_VALIMP5 * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 )
				nImp:=Str( nImporte, 14 )
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," ) 
 			     nimp:= if(nfactor<0,'-','+')+right('00000000'+alltrim(nimp),10)

				cCod := "901"
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMP6 != 0
				nImporte := TMP->F2_VALIMP6 * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 )
				nImp:=Str( nImporte, 14 )
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," ) 
			     nimp:= if(nfactor<0,'-','+')+right('00000000'+alltrim(nimp),10)

				cCod := "902"
				lAmbos := .F.
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMP7 != 0
				nImporte := TMP->F2_VALIMP7 * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 )
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
 			     nimp:= if(nfactor<0,'-','+')+right('00000000'+alltrim(nimp),10)

				cCod := "924" // TUCUMAN
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPB != 0
				nImporte := TMP->F2_VALIMPB * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 )
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
			     nimp:= if(nfactor<0,'-','+')+right('00000000'+alltrim(nimp),10)
				cCod := "919" // SL
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPC != 0
				nImporte := TMP->F2_VALIMPC * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "903" // CA
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPD != 0
				nImporte := TMP->F2_VALIMPD * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "907" // CHUBUT
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPE != 0
				nImporte := TMP->F2_VALIMPE * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "906" // CHACO
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPF != 0
				nImporte := TMP->F2_VALIMPF * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "904" // CO
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPG != 0
				nImporte := TMP->F2_VALIMPG * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "908" // ER
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPJ != 0
				nImporte := TMP->F2_VALIMPJ * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "909" // FO
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPW != 0
				nImporte := TMP->F2_VALIMPW * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "905" // CORRIENTES
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPK != 0
				nImporte := TMP->F2_VALIMPK * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "911" // LP
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPL != 0
				nImporte := TMP->F2_VALIMPL * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "912" // LR
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPM != 0
				nImporte := TMP->F2_VALIMPM * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "913" // ME
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPN != 0
				nImporte := TMP->F2_VALIMPN * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "914" // MI
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPO != 0
				nImporte := TMP->F2_VALIMPO * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "915" // NE
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPP != 0
				nImporte := TMP->F2_VALIMPP * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "917" // SA
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPQ != 0
				nImporte := TMP->F2_VALIMPQ * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "920" // SC
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPR != 0
				nImporte := TMP->F2_VALIMPR * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "921" // SANTA FE
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPS != 0
				nImporte := TMP->F2_VALIMPS * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "916" // RN
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPT != 0
				nImporte := TMP->F2_VALIMPT * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "922" // SE
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPU != 0
				nImporte := TMP->F2_VALIMPU * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "918" // SJ
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
			If TMP->F2_VALIMPV != 0
				nImporte := TMP->F2_VALIMPV * IIF(TMP->F2_MOEDA > 1, TMP->F2_TXMOEDA, 1 ) * nFactor
				nImp := Transform(nImporte,'@E 99999999.99')
				StrTran( nImp, ".", "," )
				cCod := "923" // TF
				cString := cCod + cCUIT + cFecha + cSuc + cConst + cTipo + cLetra + nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntero,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })
		        ENDIF
			EndIf
//		         AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F2_DOC,TMP->F2_ESPECIE,cLetra,nImporte*-1,cRazon })

			dbSelectArea ('TMP')
			DbSkip ()
		EndIf
	EndDo

	dbSelectArea ('TMP')
	dbCloseArea ()
//--------------------

/*
Extracto Bancario
*/
	cQuery := "SELECT F1_FORNECE, F1_LOJA, F1_EMISSAO, F1_DTDIGIT, F1_DOC, F1_ESPECIE, F1_SERIE, F1_VALIMP5, F1_VALIMP6, F1_VALIMP7, F1_VALIMPB, F1_VALIMPC, F1_VALIMPD, F1_VALIMPE, F1_VALIMPF, F1_VALIMPG, F1_VALIMPJ, F1_VALIMPW, F1_VALIMPK, F1_VALIMPL, F1_VALIMPM, F1_VALIMPN, F1_VALIMPO, F1_VALIMPP, F1_VALIMPQ, F1_VALIMPR, F1_VALIMPS, F1_VALIMPT, F1_VALIMPU, F1_VALIMPV, "
	cQuery += "F1_MOEDA, F1_TXMOEDA, F1_PROVENT "
	cQuery += "FROM " + RetSQLName ("SF1") +" WHERE"
	cQuery += " (F1_DTDIGIT >= '" + DTOS(mv_par01) + "' AND F1_DTDIGIT <='" + DTOS(mv_par02)+"')"
	cQuery += " AND (F1_VALIMP5 <> 0 OR F1_VALIMP6 <> 0 OR F1_VALIMP7 <> 0 OR F1_VALIMPB <> 0 OR F1_VALIMPC <> 0 OR F1_VALIMPD <> 0 OR F1_VALIMPE <> 0 OR F1_VALIMPF <> 0 OR F1_VALIMPG <> 0 OR F1_VALIMPJ <> 0 OR F1_VALIMPW <> 0 OR F1_VALIMPK <> 0 OR F1_VALIMPL <> 0 OR F1_VALIMPM <> 0 OR F1_VALIMPN <> 0 OR F1_VALIMPO <> 0 OR F1_VALIMPP <> 0 OR F1_VALIMPQ <> 0 OR F1_VALIMPR <> 0 OR F1_VALIMPS <> 0 OR F1_VALIMPT <> 0 OR F1_VALIMPU <> 0 OR F1_VALIMPV <> 0) AND (D_E_L_E_T_ <> '*')"
	cQuery += " AND F1_ESPECIE IN ('NF','NDP') "
	cQuery += " ORDER BY F1_DTDIGIT"
//	cQuery += " AND F1_XEXTRAC = '1' AND F1_ESPECIE IN ('NF','NDP') "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), 'TMP' ,.T.,.T.)

	dbSelectArea ('TMP')
	dbGoTop ()
	ProcRegua( LastRec() )
	While !('TMP')->(EOF())
		IncProc()
		If TMP->F1_VALIMP5 != 0 .OR. TMP->F1_VALIMP6 != 0 .OR. TMP->F1_VALIMP7 != 0 .OR. TMP->F1_VALIMPB != 0 .OR. TMP->F1_VALIMPC != 0 .OR. TMP->F1_VALIMPD != 0 .OR. TMP->F1_VALIMPE != 0 .OR. TMP->F1_VALIMPF != 0 .OR. TMP->F1_VALIMPG != 0 .OR. TMP->F1_VALIMPJ != 0 .OR. TMP->F1_VALIMPW != 0 .OR. TMP->F1_VALIMPK != 0 .OR. TMP->F1_VALIMPL != 0 .OR. TMP->F1_VALIMPM != 0 .OR. TMP->F1_VALIMPN != 0 .OR. TMP->F1_VALIMPO != 0 .OR. TMP->F1_VALIMPP != 0 .OR. TMP->F1_VALIMPQ != 0 .OR. TMP->F1_VALIMPR != 0 .OR. TMP->F1_VALIMPS != 0 .OR. TMP->F1_VALIMPT != 0 .OR. TMP->F1_VALIMPU != 0 .OR. TMP->F1_VALIMPV != 0
			cCUIT := SubStr(posicione("SA2",1,cFilSA2+TMP->(F1_FORNECE+F1_LOJA),"A2_CGC"),1,13)
			cCuit := Substr(cCuit,1,2)+'-'+Substr(cCuit,3,8)+'-'+Substr(cCuit,11,1)
			If TMP->F1_ESPECIE = 'NF'
				cTipo := 'F'
			ElseIf TMP->F1_ESPECIE = 'NDP'
				cTipo := 'D'
			Else
				cTipo := 'C'
			EndIf
			cSuc   := SubStr(TMP->F1_DOC,1,4)
			cConst := SubStr(TMP->F1_DOC,5,12)
			cLetra := SubStr(TMP->F1_SERIE,1,1)
			cFecha := SUBSTR(TMP->F1_DTDIGIT,1,4)+"/"+SUBSTR(TMP->F1_DTDIGIT,5,2)
         	cRazon := Posicione( 'SA2', 1, xFilial('SA2')+TMP->F1_FORNECE+TMP->F1_LOJA, 'A2_NOME' )
         
			If TMP->F1_VALIMP5 != 0// .AND. lAmbos == .F.
				nImporte := TMP->F1_VALIMP5 * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )				
				cCod := "901"
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMP6 != 0
				nImporte := TMP->F1_VALIMP6 * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )							
				cCod := "902"
				lAmbos := .F.
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMP7 != 0
				nImporte := TMP->F1_VALIMP7 * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "924" // TUCUMAN
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		            AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPB != 0
				nImporte := TMP->F1_VALIMPB * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "919" // SL
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPC != 0
				nImporte := TMP->F1_VALIMPC * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "903" // CA
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPD != 0
				nImporte := TMP->F1_VALIMPD * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "907" // CHUBUT
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPE != 0
				nImporte := TMP->F1_VALIMPE * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "906" // CHACO
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPF != 0
				nImporte := TMP->F1_VALIMPF * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "904" // CO
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPG != 0
				nImporte := TMP->F1_VALIMPG * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "908" // ER
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPJ != 0
				nImporte := TMP->F1_VALIMPJ * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "909" // FO
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPW != 0
				nImporte := TMP->F1_VALIMPW * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "905" // CORRIENTES
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPK != 0
				nImporte := TMP->F1_VALIMPK * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "911" // LP
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPL != 0
				nImporte := TMP->F1_VALIMPL * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "912" // LR
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPM != 0
				nImporte := TMP->F1_VALIMPM * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "913" // ME
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPN != 0
				nImporte := TMP->F1_VALIMPN * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "914" // MI
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPO != 0
				nImporte := TMP->F1_VALIMPO * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "915" // NE
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPP != 0
				nImporte := TMP->F1_VALIMPP * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "917" // SA
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPQ != 0
				nImporte := TMP->F1_VALIMPQ * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "920" // SC
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPR != 0
				nImporte := TMP->F1_VALIMPR * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "921" // SANTA FE
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPS != 0
				nImporte := TMP->F1_VALIMPS * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "916" // RN
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPT != 0
				nImporte := TMP->F1_VALIMPT * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "922" // SE
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPU != 0
				nImporte := TMP->F1_VALIMPU * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "918" // SJ
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
			If TMP->F1_VALIMPV != 0
				nImporte := TMP->F1_VALIMPV * IIF(TMP->F1_MOEDA > 1, TMP->F1_TXMOEDA, 1 )
				nImp := StrZero(nImporte, 10, 2)//Str( nImporte, 14 )
//				nImp := Transform(nImporte,'@E 999999.99')
			    nImp := StrTran( nImp, ".", "," )					
				cCod := "923" // TF
				cString := cCod + cCUIT + cFecha + Substr(SA2->A2_NOME,1,22) + cTipo + IIF(TMP->F1_MOEDA > 1, 'E', 'P' ) +nImp + Chr(13) + Chr(10)
                //Genera archivo o ambos
                IF nOpcion == 1 .or. nOpcion== 3
				   FWrite(  nPuntExtr,  cString, Len( cString )  )
				ENDIF
                //Genera archivo o ambos
                IF nOpcion == 2 .or. nOpcion== 3
		           AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })
		        ENDIF
			EndIf
//		         AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte,cRazon })

			dbSelectArea ('TMP')
			DbSkip ()
		EndIf
	EndDo

	dbSelectArea ('TMP')
	dbCloseArea ()

//------ Seryo Hasta aca Extracto

   cQuery := "SELECT EL_CLIORIG, EL_LOJORIG, EL_EMISSAO, EL_DTDIGIT, EL_RECIBO, EL_TIPO, EL_ZONFIS, EL_VLMOED1, EL_SERIE, EL_NUMERO "
   cQuery += "FROM " + RETSQLNAME ('SEL') + " WHERE "
   cQuery += "EL_DTDIGIT BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' AND "
   cQuery += "EL_FILIAL = '"  + xFilial("SEL") + "' AND "
   cQuery += "EL_CANCEL = 'F' AND EL_TIPO = 'RB' AND "
   cQuery += "D_E_L_E_T_ <> '*' "
	cQuery += "ORDER BY EL_DTDIGIT"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), 'TMP' ,.T.,.T.)

	dbSelectArea ('TMP')
	dbGoTop ()
	ProcRegua( LastRec() )
	While !('TMP')->(EOF())
		IncProc()
      If TMP->EL_VLMOED1 != 0
			cCUIT  := SubStr(posicione("SA1",1,cFilSA1+TMP->(EL_CLIORIG+EL_LOJORIG),"A1_CGC"),1,13)
			cSuc   := SubStr(TMP->EL_RECIBO,1,4)
			cConst := SubStr(TMP->EL_RECIBO,5,12)
			cFecha := SUBSTR(TMP->EL_DTDIGIT,7,2)+"/"+SUBSTR(TMP->EL_DTDIGIT,5,2)+"/"+SUBSTR(TMP->EL_DTDIGIT,1,4)
			nSigno := 1
			cTipo := 'R'
			If TMP->EL_ZONFIS = 'CF'
				cCod := "901"
			ELSEIF TMP->EL_ZONFIS = 'BA'
				cCod := "902"           
			ELSEIF TMP->EL_ZONFIS = 'CR'
				cCod := "905"
			ELSEIF TMP->EL_ZONFIS = 'CH'
				cCod := "906"				
			ELSEIF TMP->EL_ZONFIS = 'TU'
				cCod := "924"
			ELSEIF TMP->EL_ZONFIS = 'SF'
				cCod := "921"
			ELSEIF TMP->EL_ZONFIS = 'SL'
				cCod := "919"
			ELSEIF TMP->EL_ZONFIS = 'CO'
				cCod := "904"
			ELSEIF TMP->EL_ZONFIS = 'ME'
				cCod := "913"
			ELSEIF TMP->EL_ZONFIS = 'LR'
				cCod := "912"
         Else
            cCod := "000"
         ENDIF
// MOD. PS ya que el docu no es la factura sino el numero que ingresaron en la Linea de la Retencion
/*         DbSelectArea( 'SFE' )
         DbSetOrder( 1 )
         DbSeek( xFilial( 'SFE' ) + TMP->EL_NUMERO )
         While !EOF() .and. Alltrim(SFE->FE_NROCERT) == Alltrim(TMP->EL_NUMERO)*/

            nImporte := TMP->EL_VLMOED1
            nImp := Transform(nImporte,'@E 99999999.99')
            StrTran( nImp, ".", "," )
            cLetra := SubStr(TMP->EL_SERIE,1,1)
            cDocu  := Strzero(val(TMP->EL_NUMERO),12)

//          cString := cCod + cCUIT + cFecha + cSuc + cConst + space(16-len(cConst)) + cTipo + cLetra + cDocu + nImp + Chr(13) + Chr(10)
            cString := cCod + cCUIT + cFecha + cDocu + space(20-len(cDocu)) + cTipo + cLetra + cSuc + cConst + space(16-len(cConst)) + nImp + Chr(13) + Chr(10)
            //Genera archivo o ambos
            IF nOpcion == 1 .or. nOpcion== 3
               FWrite(  nPuntRet,  cString, Len( cString )  )
            ENDIF
            cRazon := Posicione( 'SA1', 1, xFilial('SA1')+TMP->EL_CLIORIG+TMP->EL_LOJORIG, 'A1_NOME' )
            //Genera archivo o ambos
            IF nOpcion == 2 .or. nOpcion== 3
               AADD(aDetRet,{ cCod,cCUIT,cFecha,TMP->EL_NUMERO,cLetra,TMP->EL_RECIBO,nImporte,cRazon })
            ENDIF

//            DbSkip( )
//         EndDo
			dbSelectArea ('TMP')
			DbSkip ()
		EndIf
	EndDo
	dbSelectArea ('TMP')
	dbCloseArea ()
EndIf            

//Cierra archivos de texto
IF nOpcion == 1 .or. nOpcion== 3
   FCLOSE( nPuntRet )
   FCLOSE( nPuntExtr )
   FCLOSE( nPuntAdu )
ENDIF
//Genera reporte 
If len(aDetPer) > 0 .or. len(aDetRet) > 0
//   If !MsgYesNo("Genera informe? ")
//      Return
//   EndIf
   ImpSIFERE(aDetPer,aDetRet,mv_par01,mv_par02)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IVAPERC  ºAutor  ³Nelson Achaval      º Data ³  03/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exportacion de impuestos de IVA                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Red Link                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IVAPERC()
Local aArea := GetArea()
Local cQLin      := Chr(13)+Chr(10)
Local cQuery     := ""
Local nHandle
Local cArqTXT    := ""
Local cDiret     := Alltrim(MV_PAR03)
Local cTimeStamp := DTOS(dDataBase)+SubStr(Time(),1,2)+SubStr(Time(),4,2)+SubStr(Time(),7,2)
Local cCUIT      := ""
Local i          := 0
Local aDet       := {}
Local cFecha
Local cNumDpc
Local cSerie
Local nImporte
Local cCuit
Local CIMPORTE        
Local lXISADU   := SA2->(FieldPos("A2_XISADU")) > 0//campo que indica si el proveedor es aduana
Local MVXISADU  := GETNEWPAR("MV_XISADU","000826/")//parametro para determinar los codigos de proveedores de aduana
lSigue          := .T.

//Genera archivo o ambos
IF nOpcion == 1 .or. nOpcion== 3
	While ( nPuntero := FCreate( Alltrim(cPath) + Alltrim(cFile) ,0 )  ) == -1
		If !MsgYesNo("No se puede Crear el Archivo "+Alltrim(cPath)+Alltrim(cFile)+Chr(13)+Chr(10)+"Continua?")
			lSigue   := .F.
			Exit
		EndIf
	EndDo
ENDIF

If lSigue

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Monta Query filtrando todos os itens de Pre-Predido a processar     ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   #IFDEF TOP
      cQuery := " SELECT F1_DOC, F1_SERIE, F1_DTDIGIT, F1_EMISSAO, F1_VALIMP4 AS TOTAL, F1_PROVENT, F1_FORNECE, "
      cQuery += " F1_LOJA, F1_ESPECIE, F1_MOEDA, F1_TXMOEDA "
      cQuery += " FROM " + RetSqlName("SF1") + " SF1 "
      cQuery += " WHERE SF1.D_E_L_E_T_ <> '*' "
      cQuery += " AND F1_FILIAL = '"+xFilial("SF1")+"' "
//      cQuery += " AND F1_EMISSAO BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' "
      cQuery += " AND F1_DTDIGIT BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' "
      cQuery += " AND F1_VALIMP4 <> 0 "
      cQuery += " AND ( F1_ESPECIE = 'NF' OR F1_ESPECIE = 'NDP' ) "
      dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
   #ENDIF


   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Lee las facturas generando el archivo TXT                    ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   TRB->(DbGoTop())
   While !TRB->(EOF())                    
   
            //Se posiciona en el proveedor
            SA2->(DbSeek(XFILIAL("SA2")+TRB->F1_FORNECE+TRB->F1_LOJA))
            
            cCodJur  := '493'
            
            //percepciones de aduana
            IF lXISADU                   
               IF SA2->A2_XISADU == "S" 
                  cCodJur  := '267'
               ENDIF
            ELSEIF SA2->A2_COD $ MVXISADU
                  cCodJur  := '267'
            ENDIF 
            
            cFecha   := SUBSTR(TRB->F1_EMISSAO,7,2)+"/"+SUBSTR(TRB->F1_EMISSAO,5,2)+"/"+SUBSTR(TRB->F1_EMISSAO,1,4)
//            cFecha   := SUBSTR(TRB->F1_DTDIGIT,7,2)+"/"+SUBSTR(TRB->F1_DTDIGIT,5,2)+"/"+SUBSTR(TRB->F1_DTDIGIT,1,4)
            cNumDpc  := '0000'+TRB->F1_DOC
            nImporte := TRB->TOTAL * IIF(TRB->F1_MOEDA > 1, TRB->F1_TXMOEDA, 1 )
            cCuit    := posicione( "SA2", 1, XFILIAL("SA2")+TRB->F1_FORNECE+TRB->F1_LOJA, "A2_CGC" )
            CIMPORTE := StrTran( Transform(nImporte,'9999999999999.99'), ' ', '0' )
            StrTran( CIMPORTE, '.', ',' )

            cLinha   := cCodJur + Transform( cCUIT, "@R 99-99999999-9" ) + cFecha + cNumDpc + CIMPORTE + Chr(13) + Chr(10)

            IF NIMPORTE <> 0
               //Genera archivo o ambos
               IF nOpcion == 1 .or. nOpcion== 3
                  FWrite(  nPuntero,  cLinha, Len( cLinha )  )
               ENDIF
               //Genera archivo o ambos
               IF nOpcion == 2 .or. nOpcion== 3
		           IF Len(aDet) = 0      
		              AADD(aDet,{ {"REGIMEN","C"},{"NUMERO DE CUIT","C"} ,{"CODIGO / TIENDA","C"},{PADR("RAZON SOCIAL",50),"C"}, {"FECHA COMPROBANTE","D"}  ,;
		                          {"ESPECIE","C"},{"LETRA COMPR.","C"} ,  {"COMPROBANTE","C"}  ,  {"IMPORTE PERCEPCION","N"}  })
		          ENDIF
                  AADD(aDet,{cCodJur, Transform( cCUIT, "@R 99-99999999-9" ),TRB->F1_FORNECE+"-"+TRB->F1_LOJA,SA2->A2_NOME,;
                       cFecha,TRB->F1_ESPECIE,TRB->F1_SERIE,TRB->F1_DOC,STRTRAN(Transform(nImporte,'9999999999999.99'),',','.') })
               ENDIF
            ENDIF

      TRB->(dbSkip())

   Enddo

   dbSelectArea("TRB")
   dbCloseArea()


   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³        LAS NOTAS DE CREDITOS NO VAN !!!!!!                          ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Gabriel ÄÄÄÄÄÄÙ
   // se muestran solo en reporte, no se incluyen en el TXT

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Monta Query filtrando todos os itens de Pre-Predido a processar     ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   #IFDEF TOP
      cQuery := " SELECT F2_DOC, F2_SERIE, F2_DTDIGIT, F2_EMISSAO, F2_VALIMP4 AS TOTAL, F2_PROVENT, F2_CLIENTE, "
      cQuery += " F2_LOJA, F2_ESPECIE, F2_MOEDA, F2_TXMOEDA "  //VER SERYO
      cQuery += " FROM " + RetSqlName("SF2") + " SF2 "
      cQuery += " WHERE SF2.D_E_L_E_T_ <> '*' "
      cQuery += " AND F2_FILIAL = '"+xFilial("SF2")+"' "
      //cQuery += " AND F2_EMISSAO BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' "
      cQuery += " AND F2_DTDIGIT BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' "
      cQuery += " AND F2_ESPECIE = 'NCP' "
      cQuery += " AND F2_VALIMP4 <> 0 "
      dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB1",.T.,.T.)
   #ENDIF

   TRB1->(DbGoTop())
   While !TRB1->(EOF())

            //Se posiciona en el proveedor
            SA2->(DbSeek(XFILIAL("SA2")+TRB1->F2_CLIENTE+TRB1->F2_LOJA))  //se puso trb1 por que tiraba palitroqui
            
            cCodJur  := '493'
            
            //percepciones de aduana
            IF lXISADU                   
               IF SA2->A2_XISADU == "S" 
                  cCodJur  := '267'
               ENDIF
            ELSEIF SA2->A2_COD $ MVXISADU
                  cCodJur  := '267'
            ENDIF 
            cFecha   := SUBSTR(TRB1->F2_EMISSAO,7,2)+"/"+SUBSTR(TRB1->F2_EMISSAO,5,2)+"/"+SUBSTR(TRB1->F2_EMISSAO,1,4)
            cNumDpc  := '0000' + TRB1->F2_DOC
            nImporte := TRB1->TOTAL * IIF(TRB1->F2_MOEDA > 1, TRB1->F2_TXMOEDA, 1 )
            cCuit    := posicione( "SA2", 1, XFILIAL("SA2")+TRB1->F2_CLIENTE+TRB1->F2_LOJA, "A2_CGC" )
            CIMPORTE := StrTran( Transform(nImporte,'9999999999999.99'), ' ', '0' )
            StrTran( CIMPORTE, '.', ',' )

            cLinha   := cCodJur + Transform( cCUIT, "@R 99-99999999-9" ) + cFecha + cNumDpc + CIMPORTE + Chr(13) + Chr(10)

            //Genera archivo o ambos
            IF NIMPORTE <> 0
               IF nOpcion == 2 .or. nOpcion== 3
		           IF Len(aDet) = 0      
		              AADD(aDet,{ {"REGIMEN","C"},{"NUMERO DE CUIT","C"} ,{"CODIGO / TIENDA","C"},{PADR("RAZON SOCIAL",50),"C"}, {"FECHA COMPROBANTE","D"}  ,;
		                          {"ESPECIE","C"},{"LETRA COMPR.","C"} ,  {"COMPROBANTE","C"}  ,  {"IMPORTE PERCEPCION","N"}  })
		          ENDIF
                  AADD(aDet,{cCodJur, Transform( cCUIT, "@R 99-99999999-9" ),TRB1->F2_CLIENTE+"-"+TRB1->F2_LOJA,SA2->A2_NOME,;
                       cFecha,TRB1->F2_ESPECIE,TRB1->F2_SERIE,TRB1->F2_DOC,STRTRAN(Transform(nImporte*-1,'9999999999999.99'),',','.') })
               ENDIF
            ENDIF

      TRB1->(dbSkip())

   Enddo

   dbSelectArea("TRB1")
   dbCloseArea()
   

   //----------------

   //Genera archivo o ambos
   IF nOpcion == 1 .or. nOpcion== 3
      FClose(nPuntero)  // fecha o TXT
   ENDIF
   If len(aDet) > 0
//      If !MsgYesNo("Genera informe? ")
//         Return
//      EndIf
     ARFISR01(aDet,cFile) 
//      ImpIVAPERC(aDet,mv_par01,mv_par02)
   EndIf

Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ SujRet   ³ Autor ³Enrique H. Caputto     ³ Data ³13/01/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Genera Archivo de Sujetos Retenidos                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Arfisp02                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function SujRet()

lSigue := .T.

cFile2 := "SUJRET" + ".TXT"

//Genera archivo o ambos
IF nOpcion == 1 .or. nOpcion== 3
	While ( nPuntero2 := FCreate( Alltrim( cPath ) + Alltrim( cFile2 ) ) ) == -1
	   If !MsgStop( "No se puede Crear el Archivo " + Alltrim( cPath ) + Alltrim( cFile2 ) + Chr( 13 ) + Chr( 10 ) + "Continua?" )
	      lSigue := .F.
	      Exit
	   EndIf
	EndDo
ENDIF

If lSigue

   DbSelectArea( "SFE" )
   DbSetOrder( 1 )
   DbGoTop()

   ProcRegua( LastRec() )


   While !eof()

      IncProc()

      If (FE_TIPO <> "G" .AND.  FE_TIPO <> "I") .OR. FE_RETENC == 0
         DbSkip()
         Loop
      EndIf

      If FE_EMISSAO < mv_par01 .OR. FE_EMISSAO > mv_par02
         DbSkip()
         Loop
      EndIf

      SA2->( DbSetOrder( 1 ) )
      SA2->( DbSeek( xFilial( "SA2" ) + SFE->FE_FORNECE + SFE->FE_LOJA ) )

      cCUITFor := SubStr( SA2->A2_CGC, 1, 11 )
      cRazSoc  := SubStr( SA2->A2_NOME + space( 20 ), 1, 20)
      cDomic   := SubStr( SA2->A2_END + space( 20 ), 1, 15 ) + space( 1 ) + SubStr( SA2->A2_NR_END, 1, 4 )
      cCiudad  := SubStr( SA2->A2_MUN + space( 20 ), 1, 20 )
      If SA2->A2_TIPO == "E"
        cProv := "99"
      Else
      	cProv := "99"//subStr( Alltrim( Tabela( '12', SA2->A2_EST ) ) + Space( 2 ), 1, 2 )
      EndIf
      cCP      := SubStr(SA2->A2_CEP + space( 8 ),1,8)

      cString  := cCUITFor + cRazSoc + cDomic + cCiudad + cProv + cCP + "80" + Chr(13) + Chr(10)

      //Genera archivo o ambos
      IF nOpcion == 1 .or. nOpcion== 3
         FWrite( nPuntero2,  cString, Len( cString )  )
      ENDIF

      DbSelectArea( "SFE" )
      DbSkip()

   EndDo

EndIf

//Genera archivo o ambos
IF nOpcion == 1 .or. nOpcion== 3
	If FCLOSE( nPuntero2 )
	      MsgInfo( "Archivo SUJRET.TXT  generado con Exito","Confirmaci¢n" )
	Else
	      MsgAlert( "Hubo Un Problema Con el Cierre del archivo SUJRET.TXT", "Problema" )
	EndIf
ENDIF

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³FINDCFOIVA³ Autor ³MS                     ³ Data ³13/01/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Busca en SD1 el CFO para SICORE                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PROCSIC()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION FINDCFOIVA(cFiscal,cSerie,cFornece,cLoja,nValbase)
local cCFO :=""
local cArea  := getarea()
local cAlias := "QRYSD1"
local cquery := ""

cQuery := "SELECT D1_CF CFO, SUM(D1_TOTAL) AS VALOR FROM " + RetSQLName ("SD1") +" SD1 "
cQuery += "WHERE"
cQuery += " D1_FORNECE 		= '" + cfornece 	+ "' 	AND D1_LOJA  ='" + cLoja 	+"'"
cQuery += " AND D1_DOC 		= '" + cFiscal 		+ "'	AND D1_SERIE ='" + cSerie 	+"'"
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " GROUP BY D1_CF "

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), calias, .F., .T.)
dbgotop()
Do While !Eof()
//	IF VALOR == nValbase
		if !empty(CFO) .and. CFO#'000'
			cCFO:= CFO
			EXIT
		Endif
//	ENDIF
	DBSKIP()
ENDDO
DbcloseArea(calias)
Restarea(cArea)

return  cCFO

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³  RETIVAC ³ Autor ³ Microsiga Argentina   ³ Data ³09/04/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Genera Archivo de retenciones de IVA en la cobranza.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static function RETIVAC()
Local aDet     := {}
Local cQuery  	:= ""
Local lSigue   := .T.

//Genera archivo o ambos
IF nOpcion == 1 .or. nOpcion== 3
	While ( nPuntero := FCreate( Alltrim(cPath) + Alltrim(cFile) ,0 )  ) == -1
		If !MsgYesNo("No se puede Crear el Archivo "+Alltrim(cPath)+Alltrim(cFile)+Chr(13)+Chr(10)+"Continua?")
			lSigue   := .F.
			Exit
		EndIf
	EndDo
ENDIF

If lSigue

   cQuery := "SELECT EL_NUMERO CERTIF, EL_EMISSAO EMISSAO, EL_VALOR VALOR, EL_CANCEL, SA1.A1_CGC CGC FROM " + RETSQLNAME ('SEL') + " SEL "
//   cQuery := "SELECT EL_NUMERO CERTIF, EL_DTDIGIT EMISSAO, EL_VALOR VALOR, EL_CANCEL, SA1.A1_CGC CGC FROM " + RETSQLNAME ('SEL') + " SEL "
   cQuery += "LEFT JOIN " + RETSQLNAME ('SA1') + " SA1 ON EL_CLIORIG = SA1.A1_COD AND EL_LOJORIG = SA1.A1_LOJA "
   cQuery += "WHERE EL_TIPODOC = 'RI' AND " // Retencion de IVA
//   cQuery += "EL_EMISSAO BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' AND "
   cQuery += "EL_DTDIGIT BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' AND "
   cQuery += "EL_FILIAL = '"  + xFilial("SEL") + "' AND "
   cQuery += "A1_FILIAL = '"  + xFilial("SA1") + "' AND "
   cQuery += "SA1.D_E_L_E_T_ <> '*' AND "
   cQuery += "SEL.D_E_L_E_T_ <> '*' "
   cQuery += "UNION ALL "
   cQuery += "SELECT E2_NUM CERTIF, E2_EMISSAO EMISSAO, E2_VALOR VALOR, 'F', SA2.A2_CGC CGC FROM " + RETSQLNAME ('SE2') + " SE2 "
//   cQuery += "SELECT E2_NUM CERTIF, E2_EMIS1 EMISSAO, E2_VALOR VALOR, 'F', SA2.A2_CGC CGC FROM " + RETSQLNAME ('SE2') + " SE2 "
   cQuery += "LEFT JOIN " + RETSQLNAME ('SA2') + " SA2 ON E2_FORNECE = SA2.A2_COD AND E2_LOJA = SA2.A2_LOJA "
   cQuery += "WHERE E2_TIPO = 'RTV' AND " // Retencion de IVA
//   cQuery += "E2_EMISSAO BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' AND "
   cQuery += "E2_EMIS1 BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' AND "
   cQuery += "E2_FILIAL = '"  + xFilial("SE2") + "' AND "
   cQuery += "A2_FILIAL = '"  + xFilial("SA2") + "' AND "
   cQuery += "SA2.D_E_L_E_T_ <> '*' AND "
   cQuery += "SE2.D_E_L_E_T_ <> '*' "
   cQuery += "ORDER BY CERTIF"

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .F. )
	dbSelectArea("TRB")
	dbGoTop()
	//SetRegua( RecCount() )

	While !Eof()

      //  IncRegua()
		/*/------------Estructura a pasar-----------------------------------//
                                            DESDE HASTA  TIPO     LONGITUD
         Codigo de Regimen  cregim := '242'  1       3    Entero         3
         Cuit del Retenido  cCuit  := ''     4      16    Texto         13
         Fecha de retencion dFeret := ''    17      26    Fecha         10
         Nro de Certificado cNrocer := ''   27      42    Texto         16
         Importe Retenido   cImpor := ''    43      58    Decimal       16
      */

      IF EL_CANCEL == "F" // No esta cancelado
         cTipComp := "242"
         cNroCUIT := Transform( TRB->CGC, "@R 99-99999999-9" )
         cFechRet := substr(TRB->EMISSAO,7,2)+"/"+substr(TRB->EMISSAO,5,2)+"/"+substr(TRB->EMISSAO,1,4)
         cNroCOri := Replicate( "0", 16-len(Alltrim(TRB->CERTIF)) ) + Alltrim(TRB->CERTIF)
         cValor   := Str( TRB->VALOR,16,2 )
         cValor   := RIGHT(StrTran( cValor, ".", "," ),16)

         cString  := cTipComp + cNroCUIT + cFechRet + cNroCOri + cValor + Chr(13)   + Chr(10)

         //Genera archivo o ambos
         IF nOpcion == 1 .or. nOpcion== 3
            FWrite(  nPuntero,  cString, Len(cString)  )
         ENDIF
         //Genera archivo o ambos
         IF nOpcion == 2 .or. nOpcion== 3
            AADD(aDet,{ cNroCUIT,cFechRet,TRB->CERTIF,TRB->VALOR })
         ENDIF
      EndIf

		DbSkip()

	EndDo

	DbSelectArea("TRB")
	dbCloseArea()
   If len(aDet) > 0
//      If !MsgYesNo("Genera informe? ")
//         Return
//      EndIf
      ImpRETIVAC(aDet,mv_par01,mv_par02)
   EndIf

EndIf

return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³  RETIIBB ³ Autor ³ Hugo Gabriel Bermudez ³ Data ³09/04/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Genera Archivo de retenciones de IIBB en la cobranza.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static function RETIIBB()

Local cQuery  	:= ""
Local lSigue   := .T.

//Genera archivo o ambos
IF nOpcion == 1 .or. nOpcion== 3
	While ( nPuntero := FCreate( Alltrim(cPath) + Alltrim(cFile) ,0 )  ) == -1
		If !MsgYesNo("No se puede Crear el Archivo "+Alltrim(cPath)+Alltrim(cFile)+Chr(13)+Chr(10)+"Continua?")
			lSigue   := .F.
			Exit
		EndIf
	EndDo
ENDIF

If lSigue

   cQuery := "SELECT EL_RECIBO RECIBO, EL_NUMERO CERTIF, EL_EMISSAO EMISSAO, EL_VALOR VALOR, EL_EST PROVI, EL_CANCEL, SA1.A1_CGC CGC FROM " + RETSQLNAME ('SEL') + " SEL "
   cQuery += "LEFT JOIN " + RETSQLNAME ('SA1') + " SA1 ON EL_CLIORIG = SA1.A1_COD AND EL_LOJORIG = SA1.A1_LOJA "
   cQuery += "WHERE EL_TIPODOC = 'RB' AND " // Retencion de IIBB
   cQuery += "EL_EMISSAO BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' AND "
   cQuery += "EL_FILIAL = '"  + xFilial("SEL") + "' AND "
   cQuery += "A1_FILIAL = '"  + xFilial("SA1") + "' AND "
   cQuery += "SA1.D_E_L_E_T_ <> '*' AND "
   cQuery += "SEL.D_E_L_E_T_ <> '*' "
   cQuery += "UNION ALL "
   cQuery += "SELECT E2_RECFAT RECIBO, E2_NUM CERTIF, E2_EMISSAO EMISSAO, E2_VALOR VALOR, E2_EST PROVI, 'F', SA2.A2_CGC CGC FROM " + RETSQLNAME ('SE2') + " SE2 "
   cQuery += "LEFT JOIN " + RETSQLNAME ('SA2') + " SA2 ON E2_FORNECE = SA2.A2_COD AND E2_LOJA = SA2.A2_LOJA "
   cQuery += "WHERE E2_TIPO = 'RTB' AND " // Retencion de IIBB
   cQuery += "E2_EMISSAO BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' AND "
   cQuery += "E2_FILIAL = '"  + xFilial("SE2") + "' AND "
   cQuery += "A2_FILIAL = '"  + xFilial("SA2") + "' AND "
   cQuery += "SA2.D_E_L_E_T_ <> '*' AND "
   cQuery += "SE2.D_E_L_E_T_ <> '*' "
   cQuery += "ORDER BY CERTIF"

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .F. )
	dbSelectArea("TRB")
	dbGoTop()
	//SetRegua( RecCount() )

	While !Eof()

      //  IncRegua()
		/*/------------Estructura a pasar-----------------------------------//
                                            DESDE HASTA  TIPO     LONGITUD
         Codigo de Regimen  cregim := '242'  1       3    Entero         3
         Cuit del Retenido  cCuit  := ''     4      16    Texto         13
         Fecha de retencion dFeret := ''    17      26    Fecha         10
         Nro de Certificado cNrocer := ''   27      42    Texto         16
         Importe Retenido   cImpor := ''    43      58    Decimal       16
      */

      IF EL_CANCEL == "F" // No esta cancelado
         If PROVI == "CF"        // Ciudad de Buenos Aires
            cTipComp := "901"
         ElseIf PROVI == "BA"    // Provincia de Buenos Aires
            cTipComp := "902"
         ElseIf PROVI == "CA"    // Catamarca
            cTipComp := "903"
         ElseIf PROVI == "CO"    // Cordoba
            cTipComp := "904"
         ElseIf PROVI == "CR"    // Corrientes
            cTipComp := "905"
         ElseIf PROVI == "CH"    // Chaco
            cTipComp := "906"
         ElseIf PROVI == "CB"    // Chubut
            cTipComp := "907"
         ElseIf PROVI == "ER"    // Entre Rios
            cTipComp := "908"
         ElseIf PROVI == "FO"    // Formosa
            cTipComp := "909"
         ElseIf PROVI == "JU"    // Jujuy
            cTipComp := "910"
         ElseIf PROVI == "LP"    // La Pampa
            cTipComp := "911"
         ElseIf PROVI == "LR"    // La Rioja
            cTipComp := "912"
         ElseIf PROVI == "ME"    // Mendoza
            cTipComp := "913"
         ElseIf PROVI == "MI"    // Misiones
            cTipComp := "914"
         ElseIf PROVI == "NE"    // Neuquen
            cTipComp := "915"
         ElseIf PROVI == "RN"    // Rio Negro
            cTipComp := "916"
         ElseIf PROVI == "SA"    // Salta
            cTipComp := "917"
         ElseIf PROVI == "SJ"    // San Juan
            cTipComp := "918"
         ElseIf PROVI == "SL"    // San Luis
            cTipComp := "919"
         ElseIf PROVI == "SC"    // Santa Cruz
            cTipComp := "920"
         ElseIf PROVI == "SF"    // Santa Fe
            cTipComp := "921"
         ElseIf PROVI == "SE"    // Santiago del Estero
            cTipComp := "922"
         ElseIf PROVI == "TF"    // Tierra del Fuego
            cTipComp := "923"
         ElseIf PROVI == "TU"    // Tucuman
            cTipComp := "924"
         Else
            cTipComp := "000" // Codigo erroneo. Solo para que no se alteren las posiciones
         EndIf
         cNroCUIT := Transform( TRB->CGC, "@R 99-99999999-9" )
         cFechRet := substr(TRB->EMISSAO,7,2)+"/"+substr(TRB->EMISSAO,5,2)+"/"+substr(TRB->EMISSAO,1,4)
         cNroCOri := Replicate( "0", 20-len(Alltrim(TRB->CERTIF)) ) + Alltrim(TRB->CERTIF)
	       	 If empty(cNroCOri)
         cNroCOri := Replicate( "0", 20-len(Alltrim(TRB->CERTIF)) ) + Alltrim(TRB->CERTIF)
             EndIf
         cTipCbte := "R" // Recibo
         cLtaCbte := "C" // Recibo
		 cRec     := Replicate( "0", 20-len(Alltrim(TRB->RECIBO)) ) + Alltrim(TRB->RECIBO)
         /*cRec     := Replicate( "0", 20-len(Alltrim(TRB->RECIBO)) ) + Alltrim(TRB->RECIBO)
         If empty(cRec)
            cRec     := Replicate( "0", 20-len(Alltrim(TRB->CERTIF)) ) + Alltrim(TRB->CERTIF)
         EndIf
         cTipCbte := "R" // Recibo
         cLtaCbte := "C" // Recibo
         cNroCOri := Replicate( "0", 20-len(Alltrim(TRB->CERTIF)) ) + Alltrim(TRB->CERTIF)
         */
         cValor   := Str( TRB->VALOR,11,2 )
         cValor   := RIGHT(StrTran( cValor, ".", "," ),11)

         cString  := cTipComp + cNroCUIT + cFechRet + cNroCOri + cTipCbte + cLtaCbte + cRec + cValor + Chr(13)   + Chr(10)

         //Genera archivo o ambos
         IF nOpcion == 1 .or. nOpcion== 3
            FWrite(  nPuntero,  cString, Len(cString)  )
         ENDIF
      EndIf

		DbSkip()

	EndDo

	DbSelectArea("TRB")
	dbCloseArea()

EndIf

return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³  RETGANC ³ Autor ³ Hugo Gabriel Bermudez ³ Data ³21/04/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Genera Archivo de retenciones de Ganancias en la cobranza. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RETGANC()
Local cQuery  	:= ""
Local lSigue   := .T.
Local aDet     := {}

//Genera archivo o ambos
IF nOpcion == 1 .or. nOpcion== 3
	While ( nPuntero := FCreate( Alltrim(cPath) + Alltrim(cFile) ,0 )  ) == -1
		If !MsgYesNo("No se puede Crear el Archivo "+Alltrim(cPath)+Alltrim(cFile)+Chr(13)+Chr(10)+"Continua?")
			lSigue   := .F.
			Exit
		EndIf
	EndDo
ENDIF

If lSigue

   cQuery := "SELECT EL_NUMERO CERTIF, EL_EMISSAO EMISSAO, EL_VALOR VALOR, EL_CANCEL, SA1.A1_CGC CGC, SA1.A1_NOME AS NOME, "
   cQuery += " EL_CLIENTE AS CODIGO, EL_LOJA AS LOJA, EL_DTDIGIT AS DTDIGIT "
   cQuery += "  FROM " + RETSQLNAME ('SEL') + " SEL "
   cQuery += "LEFT JOIN " + RETSQLNAME ('SA1') + " SA1 ON EL_CLIORIG = SA1.A1_COD AND EL_LOJORIG = SA1.A1_LOJA "
   cQuery += "WHERE EL_TIPODOC = 'RG' AND " // Retencion de Ganancias
//   cQuery += "EL_EMISSAO BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' AND "
   cQuery += "EL_DTDIGIT BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' AND "
   cQuery += "EL_FILIAL = '"  + xFilial("SEL") + "' AND "
   cQuery += "A1_FILIAL = '"  + xFilial("SA1") + "' AND "
   cQuery += "SA1.D_E_L_E_T_ <> '*' AND "
   cQuery += "SEL.D_E_L_E_T_ <> '*' "
   cQuery += "UNION ALL "
   cQuery += "SELECT E2_NUM CERTIF, E2_EMISSAO EMISSAO, E2_VALOR VALOR, 'F', SA2.A2_CGC CGC, SA2.A2_NOME AS NOME, "
   cQuery += " E2_FORNECE AS CODIGO, E2_LOJA AS LOJA, E2_EMIS1 AS DTDIGIT "
   cQuery += " FROM " + RETSQLNAME ('SE2') + " SE2 "
   cQuery += "LEFT JOIN " + RETSQLNAME ('SA2') + " SA2 ON E2_FORNECE = SA2.A2_COD AND E2_LOJA = SA2.A2_LOJA "
   cQuery += "WHERE E2_TIPO = 'RTG' AND " // Retencion de Ganancias
//   cQuery += "E2_EMISSAO BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' AND "
   cQuery += "E2_EMIS1 BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' AND "
   cQuery += "E2_FILIAL = '"  + xFilial("SE2") + "' AND "
   cQuery += "A2_FILIAL = '"  + xFilial("SA2") + "' AND "
   cQuery += "SA2.D_E_L_E_T_ <> '*' AND "
   cQuery += "SE2.D_E_L_E_T_ <> '*' "
   cQuery += "ORDER BY CERTIF"

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .F. )
	dbSelectArea("TRB")
	dbGoTop()
	//SetRegua( RecCount() )

	While !Eof()

      //  IncRegua()
		/*/------------Estructura a pasar-----------------------------------//
                                            DESDE HASTA  TIPO     LONGITUD
         Cuit del Retenido  cCuit            1      13    Texto         11
         Nro de Certificado cNrocer         14      24    Texto         10
         Fecha de retencion dFeret          25      33    Fecha          8
         Regimen                            34      37    Texto          3
         Importe Retenido   cImpor          38      52    Decimal       15
      */

      IF EL_CANCEL == "F" // No esta cancelado
         cNroCUIT := Transform( TRB->CGC, "@R 99999999999" )
         cFechRet := substr(TRB->EMISSAO,7,2)+substr(TRB->EMISSAO,5,2)+substr(TRB->EMISSAO,1,4)
         dFechRet := substr(TRB->EMISSAO,7,2)+"/"+substr(TRB->EMISSAO,5,2)+"/"+substr(TRB->EMISSAO,1,4)
         cFechReg := substr(TRB->DTDIGIT,7,2)+substr(TRB->DTDIGIT,5,2)+substr(TRB->DTDIGIT,1,4)
         dFechReg := substr(TRB->DTDIGIT,7,2)+"/"+substr(TRB->DTDIGIT,5,2)+"/"+substr(TRB->DTDIGIT,1,4)
         cNroCOri := Replicate( "0", 10-len(Alltrim(TRB->CERTIF)) ) + Alltrim(TRB->CERTIF)
         cValor   := Str( TRB->VALOR,13,2 )
         cValor   := RIGHT(StrTran( cValor, ".", "," ),13)
         cRegimen := "094"

         cString  := " " + cNroCUIT + " " + cNroCOri + " " + cFechRet + " " + cRegimen + " " + cValor + Chr(13)   + Chr(10)

         //Genera archivo o ambos
         IF nOpcion == 1 .or. nOpcion== 3
            FWrite(  nPuntero,  cString, Len(cString)  )
         ENDIF
         
         //Genera archivo o ambos
         IF nOpcion == 2 .or. nOpcion== 3
            IF Len(aDet) = 0      
	              AADD(aDet,{ {"NUMERO DE CUIT","C"} ,{"CODIGO / TIENDA","C"},{PADR("RAZON SOCIAL",50),"C"},{"NUMERO COMPROBANTE","C"}, ;
	                          {"FECHA COMPROBANTE","D"},{"REGIMEN","C"},{"IMPORTE RETENCION","N"}, {"FECHA REGISTRO","D"}  })
	        ENDIF
            Aadd( aDet, { cNroCUIT, TRB->CODIGO+"-"+TRB->LOJA,TRB->NOME, cNroCOri, dFechRet, cRegimen, StrTran(cValor,',','.'), dFechReg } )
         ENDIF
      EndIf

		DbSkip()

	EndDo

	DbSelectArea("TRB")
	dbCloseArea()
   If len(aDet) > 0
//      If !MsgYesNo("Genera informe? ")
//         Return
//      EndIf
//      ImpGANC(aDet,mv_par01,mv_par02)
      ARFISR01(aDet, cFile)
   EndIf


EndIf

return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³          ³ Autor ³                       ³ Data ³  /  /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpGANC(aDetRet,dFechaInicial,dFechaFinal)
Local cDesc1      := OemToAnsi( "Este programa tiene como objetivo imprimir informe " ) ,;
      cDesc2      := OemToAnsi( "de acuerdo con los parámetros informados por el usuario." ) ,;
      cDesc3      := OemToAnsi( "Informe de Retencion Ganancias en Cobranzas" ) ,;
      titulo      := OemToAnsi( "Informe de Retencion Ganancias en Cobranzas" ) ,;
      nLin        := 80 ,;
      Cabec1      := padc("Desde el: " + dtoc(dFechaInicial) + " hasta el: " + dtoc(dFechaFinal),132),;
      Cabec2      := "CUIT          Nombre o Razon Social                              Certif.    Fecha            Regimen                  Valor"
Private lEnd         := .F. ,;
        lAbortPrint  := .F. ,;
        tamanho      := "M" ,;
        nomeprog     := "GANCOB" ,;
        nTipo        := 18 ,;
        aReturn      := { "A Rayas", 1, "Administraci¢n", 1, 2, 1, "", 1} ,;
        nLastKey     := 0 ,;
        cPerg        := 'ARFISP0004' ,;
        m_pag        := 01 ,;
        wnrel        := "GANCOB" ,;
        cString      := "SC6"
		
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

nLin   := 99
nTotal := 0

For i:=1 to Len(aDetRet)
   If nLin > 60
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin ++
   EndIf
   @ nLin, 000 PSay SubStr(aDetRet[i][1],1,2) + '-' + SubStr(aDetRet[i][1],3,8) + '-' + SubStr(aDetRet[i][1],11,1)
   @ nLin, 014 PSay SubStr(aDetRet[i][6],1,50)
   @ nLin, 065 PSay SubStr(aDetRet[i][2],1,20)
   @ nLin, 076 PSay SubStr(aDetRet[i][3],1,2) + '/' + SubStr(aDetRet[i][3],3,2) + '/' + SubStr(aDetRet[i][3],5,4)
   @ nLin, 097 PSay Alltrim(aDetRet[i][4])
   @ nLin, 108 PSay Transform(Val(StrTran(aDetRet[i][5],',','.')), '@E 9999,999,999.99')

   nTotal += Val(StrTran(aDetRet[i][5],',','.'))
   nLin ++
Next
@ nLin,  00 PSAY __PrtThinLine()
nLin ++
@ nLin, 000 PSay "Total General: "
@ nLin, 108 PSay Transform(nTotal, '@E 9999,999,999.99')

If aReturn[5] = 1
   Set Printer TO
   Commit
   OurSpool(wnrel)
Endif
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³          ³ Autor ³                       ³ Data ³  /  /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpSICORE(aDetRet,dFechaInicial,dFechaFinal)
Local cDesc1      := OemToAnsi( "Este programa tiene como objetivo imprimir informe " ) ,;
      cDesc2      := OemToAnsi( "de acuerdo con los parámetros informados por el usuario." ) ,;
      cDesc3      := OemToAnsi( "Informe de SICORE" ) ,;
      titulo      := OemToAnsi( "Informe de SICORE" ) ,;
      nLin        := 80 ,;
      Cabec1      := padc("Desde el: " + dtoc(dFechaInicial) + " hasta el: " + dtoc(dFechaFinal),132),;
      Cabec2      := "   CUIT     Nombre o Razon Social           Fecha   Ord.Pago         Valor Base       Retencion Certificado"
Private lEnd         := .F. ,;
        lAbortPrint  := .F. ,;
        tamanho      := "M" ,;
        nomeprog     := "SICORE" ,;
        nTipo        := 18 ,;
        aReturn      := { "A Rayas", 1, "Administraci¢n", 1, 2, 1, "", 1} ,;
        nLastKey     := 0 ,;
        cPerg        := 'ARFISP0004' ,;
        m_pag        := 01 ,;
        wnrel        := "IMPSICORE" ,;
        cString      := "SC6"
		
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

nLin   := 99
nTotal := 0
/*/
      AADD(aDetRet,{ SFE->FE_EMISSAO,FE_ORDPAGO,nImporte,FE_VALBASE,SFE->FE_EMISSAO,SFE->FE_RETENC,SA2->A2_CGC,SFE->FE_NROCERT,SA2->A2_NOME,SA2->A2_END,SA2->A2_MUN,SA2->A2_EST,SA2->A2_CEP,FE_TIPO })
                                  1        2        3        4              5                 6           7              8               9         10       11          12             13       14
   CUIT     Nombre o Razon Social           Fecha    Ord.Pago       Valor Base       Retencion Certificado
123456789.1 123456789.123456789.123456789. xx/xx/xx 123456789. 9999,999,999.99 9999,999,999.99
            12                             43       52         63              79              95
/*/

For i:=1 to Len(aDetRet)
   If nLin > 60
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin ++
   EndIf
   @ nLin, 000 PSay Alltrim(aDetRet[i][7])
   @ nLin, 012 PSay Substr(aDetRet[i][9],1,30)
   @ nLin, 043 PSay dtoc(aDetRet[i][1])
   @ nLin, 052 PSay Alltrim(aDetRet[i][2])
   @ nLin, 064 PSay Transform(aDetRet[i][4], '@E 9999,999,999.99')
   @ nLin, 080 PSay Transform(aDetRet[i][6], '@E 9999,999,999.99')
   @ nLin, 096 PSay aDetRet[i][8] + " " + aDetRet[i][14]

   nTotal += aDetRet[i][6]
   nLin ++
Next
@ nLin,  00 PSAY __PrtThinLine()
nLin ++
@ nLin, 000 PSay "Total General: "
@ nLin, 080 PSay Transform(nTotal, '@E 9999,999,999.99')

If aReturn[5] = 1
   Set Printer TO
   Commit
   OurSpool(wnrel)
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³          ³ Autor ³                       ³ Data ³  /  /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpSIFERE(aDetPer,aDetRet,dFechaInicial,dFechaFinal)
Local cDesc1      := OemToAnsi( "Este programa tiene como objetivo imprimir informe " ) ,;
      cDesc2      := OemToAnsi( "de acuerdo con los parámetros informados por el usuario." ) ,;
      cDesc3      := OemToAnsi( "Informe de SIFERE" ) ,;
      titulo      := OemToAnsi( "Informe de Percepciones SIFERE" ) ,;
      nLin        := 80 ,;
      Cabec1      := padc("Desde el: " + dtoc(dFechaInicial) + " hasta el: " + dtoc(dFechaFinal),80),;
      Cabec2      := "Cod    CUIT        Fecha   Tipo    Documento           Importe  Razon Social"
Private lEnd         := .F. ,;
        lAbortPrint  := .F. ,;
        tamanho      := "M" ,;
        nomeprog     := "SIFERE" ,;
        nTipo        := 18 ,;
        aReturn      := { "A Rayas", 1, "Administraci¢n", 1, 2, 1, "", 1} ,;
        nLastKey     := 0 ,;
        cPerg        := 'ARFISP0004' ,;
        m_pag        := 01 ,;
        wnrel        := "IMPSIFERE" ,;
        cString      := "SC6"

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

nLin   := 99
nTotal := 0
/*/
   AADD(aDetPer,{ cCod,cCUIT,cFecha,TMP->F1_DOC,TMP->F1_ESPECIE,cLetra,nImporte })
                    1     2      3        4                 5      6         7
Cod    CUIT        Fecha   Tipo    Documento           Importe
123 123456789.1 xx/xx/xxxx xxxx x 123456789.12 9999,999,999.99
    4           16         27  32 34           47
/*/

aSub  := {}

If len(aDetPer) > 0
   For i:=1 to Len(aDetPer)
      If nLin > 60
         nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
         nLin ++
      EndIf
      @ nLin, 000 PSay Alltrim(aDetPer[i][1])
      @ nLin, 004 PSay Alltrim(aDetPer[i][2])
      @ nLin, 016 PSay aDetPer[i][3]
      @ nLin, 027 PSay Alltrim(aDetPer[i][5])
      @ nLin, 032 PSay aDetPer[i][6]
      @ nLin, 034 PSay aDetPer[i][4]
      @ nLin, 047 PSay Transform(aDetPer[i][7], '@E 9999,999,999.99')
      @ nLin, 063 PSay Alltrim(aDetPer[i][8])
      
      nPos  := Ascan( aSub, { |x| x[1] == Alltrim(aDetPer[i][1]) } )
      If nPos == 0
         Aadd( aSub, { Alltrim(aDetPer[i][1]), aDetPer[i][7] } )
      Else
         aSub[nPos][2] += aDetPer[i][7]
      EndIf

      If alltrim(Alltrim(aDetPer[i][5]))=="NCP"
		  nTotal -= aDetPer[i][7]	  
	  else
	      nTotal += aDetPer[i][7]
	  endif
      nLin ++
   Next
   @ nLin,  00 PSAY __PrtThinLine()
   nLin ++
   @ nLin, 000 PSay "Total General: "
   @ nLin, 047 PSay Transform(nTotal, '@E 9999,999,999.99')
   nLin += 2  
   
   aSub := ASORT(aSub,,, { |x, y| x[1] < y[1] })
   For nS := 1 To Len( aSub )
      If nLin > 60
         nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
         nLin ++
      EndIf 
      
      @ nLin, 000 PSay "Total del Codigo " + aSub[nS][1]
      @ nLin, 030 PSay Transform( aSub[nS][2], '@E 9999,999,999.99')
      nLin ++
   Next
EndIf

nLin   := 99
nTotal := 0
m_Pag  := 1
titulo := OemToAnsi( "Informe de Retenciones SIFERE" )
Cabec2 := "Cod    CUIT        Fecha       Documento   Recibo               Importe  Razon Social"
/*/
   AADD(aDetRet,{ cCod,cCUIT,cFecha,TMP->EL_NUMERO,cLetra,TMP->EL_RECIBO,nImporte })
                    1     2      3        4            5           6         7
Cod    CUIT        Fecha      Documento   Recibo               Importe
123 123456789.1 xx/xx/xxxx x 123456789.12 123456789.12 9999,999,999.99
    4           16        27 30           42           55
/*/

aSub  := {}

If len(aDetRet) > 0
   For i:=1 to Len(aDetRet)
      If nLin > 60
         nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
         nLin ++
      EndIf
      @ nLin, 000 PSay Alltrim(aDetRet[i][1])
      @ nLin, 004 PSay Alltrim(aDetRet[i][2])
      @ nLin, 016 PSay aDetRet[i][3]
      @ nLin, 027 PSay Alltrim(aDetRet[i][5])
      @ nLin, 030 PSay aDetRet[i][4]
      @ nLin, 042 PSay aDetRet[i][6]
      @ nLin, 055 PSay Transform(aDetRet[i][7], '@E 9999,999,999.99')
      @ nLin, 072 PSay Alltrim(aDetRet[i][8])

      nPos  := Ascan( aSub, { |x| x[1] == Alltrim(aDetRet[i][1]) } )
      If nPos == 0
         Aadd( aSub, { Alltrim(aDetRet[i][1]), aDetRet[i][7] } )
      Else
         aSub[nPos][2] += aDetRet[i][7]
      EndIf
      
      nTotal += aDetRet[i][7]
      nLin ++
   Next
   @ nLin,  00 PSAY __PrtThinLine()
   nLin ++
   @ nLin, 000 PSay "Total General: "
   @ nLin, 056 PSay Transform(nTotal, '@E 9999,999,999.99')
   nLin += 2  
   
   
   For nS := 1 To Len( aSub )
      If nLin > 60
         nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
         nLin ++
      EndIf 
      
      @ nLin, 000 PSay "Total del Codigo " + aSub[nS][1]
      @ nLin, 030 PSay Transform( aSub[nS][2], '@E 9999,999,999.99')
      nLin ++
   Next
EndIF

If aReturn[5] = 1
   Set Printer TO
   Commit
   OurSpool(wnrel)
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³          ³ Autor ³                       ³ Data ³  /  /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpProIVA(aDet,dFechaInicial,dFechaFinal)
Local cDesc1      := OemToAnsi( "Este programa tiene como objetivo imprimir informe " ) ,;
      cDesc2      := OemToAnsi( "de acuerdo con los parámetros informados por el usuario." ) ,;
      cDesc3      := OemToAnsi( "Perc.iva Clientes" ) ,;
      titulo      := OemToAnsi( "Perc.iva Clientes" ) ,;
      nLin        := 80 ,;
      Cabec1 := padc("Desde el: " + dtoc(dFechaInicial) + " hasta el: " + dtoc(dFechaFinal),80),;
      Cabec2      := "Tp.  Comprobante    Fecha      CUIT       Tot.Factura    Valor Base   Valor Perc."
Private lEnd         := .F. ,;
        lAbortPrint  := .F. ,;
        tamanho      := "P" ,;
        nomeprog     := "IMPPROIVA" ,;
        nTipo        := 18 ,;
        aReturn      := { "A Rayas", 1, "Administraci¢n", 1, 2, 1, "", 1} ,;
        nLastKey     := 0 ,;
        cPerg        := 'ARFISP0004' ,;
        m_pag        := 01 ,;
        wnrel        := "IMPPROIVA" ,;
        cString      := "SC6"

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

nLin   := 99
nTota1 := 0
nTota2 := 0
nTota3 := 0
//                                   1               2           3               4              5                6        7
//         AADD(aDet,{ TMP->F2_ESPECIE,TMP->F2_EMISSAO,TMP->F2_DOC,TMP->F2_VALBRUT,TMP->F2_BASIMP4,TMP->F2_VALIMP4,cNroCUIT })
/*/
Tp.   Comprobante    Fecha     CUIT       Tot.Factura    Valor Base   Valor Perc."
123 123456789.12   xx/xx/xx 123456789.1 99,999,999.99 99,999,999.99 99,999,999.99
0   4              19       28          40            54            68
/*/

For i:=1 to Len(aDet)
   If nLin > 60
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
      nLin ++
   EndIf
   @ nLin, 000 PSay Alltrim(aDet[i][1])
   @ nLin, 004 PSay Alltrim(aDet[i][3])
   @ nLin, 017 PSay aDet[i][2]
   @ nLin, 028 PSay Alltrim(aDet[i][7])
   @ nLin, 040 PSay Transform(aDet[i][4], '@E 99,999,999.99')
   @ nLin, 054 PSay Transform(aDet[i][5], '@E 99,999,999.99')
   @ nLin, 068 PSay Transform(aDet[i][6], '@E 99,999,999.99')
   nTota1 += aDet[i][4]
   nTota2 += aDet[i][5]
   nTota3 += aDet[i][6]
   nLin ++
Next
@ nLin,  00 PSAY __PrtThinLine()
nLin ++
@ nLin, 000 PSay "Total General: "
@ nLin, 040 PSay Transform(nTota1, '@E 99,999,999.99')
@ nLin, 054 PSay Transform(nTota2, '@E 99,999,999.99')
@ nLin, 068 PSay Transform(nTota3, '@E 99,999,999.99')

If aReturn[5] = 1
   Set Printer TO
   Commit
   OurSpool(wnrel)
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³          ³ Autor ³                       ³ Data ³  /  /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IMPIVAPERC(aDet,dFechaInicial,dFechaFinal)
Local cDesc1      := OemToAnsi( "Este programa tiene como objetivo imprimir informe " ) ,;
      cDesc2      := OemToAnsi( "de acuerdo con los parámetros informados por el usuario." ) ,;
      cDesc3      := OemToAnsi( "IVA Percepciones Compras" ) ,;
      titulo      := OemToAnsi( "IVA Percepciones Compras" ) ,;
      nLin        := 80 ,;
      Cabec1 := padc("Desde el: " + dtoc(dFechaInicial) + " hasta el: " + dtoc(dFechaFinal),80),;
      Cabec2      := " Comprobante    Fecha        CUIT         Valor Perc."
Private lEnd         := .F. ,;
        lAbortPrint  := .F. ,;
        tamanho      := "P" ,;
        nomeprog     := "IMPIVAPERC" ,;
        nTipo        := 18 ,;
        aReturn      := { "A Rayas", 1, "Administraci¢n", 1, 2, 1, "", 1} ,;
        nLastKey     := 0 ,;
        cPerg        := 'ARFISP0004' ,;
        m_pag        := 01 ,;
        wnrel        := "IMPIVAPERC" ,;
        cString      := "SC6"

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

nLin   := 99
nTota1 := 0
/*/
AADD(aDet,{ Transform( cCUIT, "@R 99-99999999-9" ),cFecha,TRB->F1_DOC,nImporte })
 Comprobante    Fecha        CUIT         Valor Perc.
123456789.12 xx/xx/xxxx 99-99999999-9 9999,999,999.99
0            13         24            38
/*/

For i:=1 to Len(aDet)
   If nLin > 60
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
      nLin ++
   EndIf
   @ nLin, 000 PSay Alltrim(aDet[i][3])
   @ nLin, 013 PSay aDet[i][2]
   @ nLin, 024 PSay Alltrim(aDet[i][1])
   @ nLin, 038 PSay Transform(aDet[i][4], '@E 9999,999,999.99')
   nTota1 += aDet[i][4]
   nLin ++
Next
@ nLin,  00 PSAY __PrtThinLine()
nLin ++
@ nLin, 000 PSay "Total General: "
@ nLin, 038 PSay Transform(nTota1, '@E 9999,999,999.99')

If aReturn[5] = 1
   Set Printer TO
   Commit
   OurSpool(wnrel)
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³          ³ Autor ³                       ³ Data ³  /  /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IMPRETIVAC(aDet,dFechaInicial,dFechaFinal)
Local cDesc1      := OemToAnsi( "Este programa tiene como objetivo imprimir informe " ) ,;
      cDesc2      := OemToAnsi( "de acuerdo con los parámetros informados por el usuario." ) ,;
      cDesc3      := OemToAnsi( "Retenciones de IVA en cobranzas" ) ,;
      titulo      := OemToAnsi( "Retenciones de IVA en cobranzas" ) ,;
      nLin        := 80 ,;
      Cabec1 := padc("Desde el: " + dtoc(dFechaInicial) + " hasta el: " + dtoc(dFechaFinal),80),;
      Cabec2      := " Comprobante    Fecha        CUIT         Valor Retenc."
Private lEnd         := .F. ,;
        lAbortPrint  := .F. ,;
        tamanho      := "P" ,;
        nomeprog     := "IMPRETIVAC" ,;
        nTipo        := 18 ,;
        aReturn      := { "A Rayas", 1, "Administraci¢n", 1, 2, 1, "", 1} ,;
        nLastKey     := 0 ,;
        cPerg        := 'ARFISP0004' ,;
        m_pag        := 01 ,;
        wnrel        := "IMPRETIVAC" ,;
        cString      := "SC6"

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

nLin   := 99
nTota1 := 0
/*/
AADD(aDet,{ cNroCUIT,cFechRet,TRB->CERTIF,TRB->VALOR })
Comprobante    Fecha        CUIT         Valor Perc.
123456789.12 xx/xx/xxxx 99-99999999-9 9999,999,999.99

/*/

For i:=1 to Len(aDet)
   If nLin > 60
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
      nLin ++
   EndIf
   @ nLin, 000 PSay Alltrim(aDet[i][3])
   @ nLin, 013 PSay aDet[i][2]
   @ nLin, 024 PSay Alltrim(aDet[i][1])
   @ nLin, 038 PSay Transform(aDet[i][4], '@E 9999,999,999.99')
   nTota1 += aDet[i][4]
   nLin ++
Next
@ nLin,  00 PSAY __PrtThinLine()
nLin ++
@ nLin, 000 PSay "Total General: "
@ nLin, 038 PSay Transform(nTota1, '@E 9999,999,999.99')

If aReturn[5] = 1
   Set Printer TO
   Commit
   OurSpool(wnrel)
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³          ³ Autor ³                       ³ Data ³  /  /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IMPRESUSS(aDet,dFechaInicial,dFechaFinal)
Local cDesc1      := OemToAnsi( "Este programa tiene como objetivo imprimir informe " ) ,;
      cDesc2      := OemToAnsi( "de acuerdo con los parámetros informados por el usuario." ) ,;
      cDesc3      := OemToAnsi( "SUSS(Resol.1784/4052/1769)" ) ,;
      titulo      := OemToAnsi( "SUSS(Resol.1784/4052/1769)" ) ,;
      nLin        := 80 ,;
      Cabec1 := padc("Desde el: " + dtoc(dFechaInicial) + " hasta el: " + dtoc(dFechaFinal),80),;
      Cabec2      := " Comprob.    Fecha        CUIT         Valor Retenc.  Cod Ret. Proveedor"
Private lEnd         := .F. ,;
        lAbortPrint  := .F. ,;
        tamanho      := "P" ,;
        nomeprog     := "IMPRESUSS" ,;
        nTipo        := 18 ,;
        aReturn      := { "A Rayas", 1, "Administraci¢n", 1, 2, 1, "", 1} ,;
        nLastKey     := 0 ,;
        cPerg        := 'ARFISP0004' ,;
        m_pag        := 01 ,;
        wnrel        := "IMPRESUSS" ,;
        cString      := "SC6"

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

nLin   := 99
nTota1 := 0
/*/
AADD(aDet,{ cNroCUIT,cFechRet,TRB->CERTIF,TRB->RETENC })
Comprobante    Fecha        CUIT         Valor Perc.
123456789.12 xx/xx/xxxx 99-99999999-9 9999,999,999.99

/*/

For i:=1 to Len(aDet)
   If nLin > 60
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
      nLin ++
   EndIf
   @ nLin, 000 PSay Alltrim(aDet[i][3])
   @ nLin, 013 PSay aDet[i][2]
   @ nLin, 024 PSay Alltrim(aDet[i][1])
   @ nLin, 038 PSay Transform(aDet[i][4], '@E 9999,999,999.99')
   @ nLin, 054 PSay Alltrim(aDet[i][5])
   @ nLin, 064 PSay Alltrim(aDet[i][6])
   nTota1 += aDet[i][4]
   nLin ++
Next
@ nLin,  00 PSAY __PrtThinLine()
nLin ++
@ nLin, 000 PSay "Total General: "
@ nLin, 038 PSay Transform(nTota1, '@E 9999,999,999.99')

If aReturn[5] = 1
   Set Printer TO
   Commit
   OurSpool(wnrel)
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ CodPrv   ³ Autor ³ F.Guerrero          ³ Data ³ 20.08.09 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
//  Devuelve codigos fiscales para aplicativo SIAP / SICORE ( IVA y GANANCIAS)
//
//		Aadd(aCFO,//1- Impuesto, 2- Codigo fiscal, 3- Codigo fiscal compras , 4- Codigo fiscal ventas 
//		          //5- Serie Nota fiscal, 6- Tipo responsable, 7- Descripcion 
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
Static Function TraeCFO()

Local cQry1 	:= ""
Local cQryTrb 	:= "Arf02"
Local aCFO  	:= {}

cQry1 := " SELECT * "
cQry1 += " FROM " + RetSqlName("SFF") + " "
cQry1 += " WHERE FF_IMPOSTO ='IVR' "
cQry1 += " AND FF_FILIAL = '" + xFilial("SFF") + "' "
cQry1 += " AND D_E_L_E_T_ <> '*' "

cQry1 := ChangeQuery(cQry1)
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry1), cQryTrb, .F., .T.)

DbSelectArea(cQryTrb)
DbGoTop()
While !Eof()
	If Ascan(aCFO,{|x| ( SUBSTR((cQryTrb)->FF_CFO,1,3)+(cQryTrb)->FF_CFO_C+(cQryTrb)->FF_CFO_V+(cQryTrb)->FF_SERIENF )== ;
	                         (x[2]+x[3]+x[4]+x[5] )}) == 0
		Aadd(aCFO,{(cQryTrb)->FF_IMPOSTO        ,; //1- Impuesto
		           SUBSTR((cQryTrb)->FF_CFO,1,3),; //2- Codigo fiscal
		           (cQryTrb)->FF_CFO_C          ,; //3- Codigo fiscal compras 
		           (cQryTrb)->FF_CFO_V          ,; //4- Codigo fiscal ventas 
		           (cQryTrb)->FF_SERIENF        ,; //5- Serie Nota fiscal
		           (cQryTrb)->FF_TIPO           ,; //6- Tipo responsable
		           (cQryTrb)->FF_CONCEPT        }) //7- Descripcion 
	EndIf
	DbSkip()
EndDo

(cQryTrb)->(DbCloseArea())	



Return(aCFO)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ PROCIBB  ³ Autor ³Francisco Guerrero     ³ Data ³03/11/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Genera Archivo de Percepciones de IIBB  FO (Formosa)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RETF010                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Fecha   ³ Programador   ³ Alteraci¢n Efectuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³14/02/2006³               ³Creacion                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcIBB ()

Local aDet     := {}
LOCAL cFilSA1 := xFilial ("SA1")
LOCAL cFilSA2 := xFilial ("SA2")
LOCAL lSigue := .T.
LOCAL cCuit:=cImp:=cMonto:=cTipo:=cSuc:=cLetra:=cConst:=cFecha:=""

//Genera archivo o ambos
IF nOpcion == 1 .or. nOpcion== 3
	While ( nPuntero := FCreate( Alltrim(cPath) + Alltrim(cFile) ) ) == -1
		If !MsgYesNo("No se puede Crear el Archivo "+Alltrim(cPath)+Alltrim(cFile)+Chr(13)+Chr(10)+"Continua?")
			lSigue   := .F.
			Exit
		EndIf
	EndDo
ENDIF

DbSelectArea("SL1")
DbSetOrder(2)


If lSigue
   
	cQuery := " SELECT SF1.F1_FORNECE, SF1.F1_LOJA, SF1.F1_EMISSAO, SF1.F1_DTDIGIT, SF1.F1_DOC, SF1.F1_ESPECIE, SF1.F1_SERIE, SF1.F1_TXMOEDA,  "
    cQuery += " SF1.F1_VALIMPJ, SF1.F1_BASIMPJ, SA1.A1_NOME  "
	cQuery += " FROM " + RetSQLName ("SF1")+ " SF1 " 
    cQuery += "    INNER JOIN "+ RetSQLName ("SA1") + " SA1 "
    cQuery += "       ON SA1.A1_COD=SF1.F1_FORNECE AND SA1.A1_LOJA=SF1.F1_LOJA AND SA1.D_E_L_E_T_='' " 
	cQuery += " WHERE"
    cQuery += " (SF1.F1_EMISSAO >= '" + DTOS(mv_par01) + "' AND SF1.F1_EMISSAO <='" + DTOS(mv_par02)+"')"
	cQuery += " AND (SF1.F1_VALIMPJ <> 0 ) AND (SF1.D_E_L_E_T_ <> '*') AND (SF1.F1_ESPECIE = 'NCC')"
	cQuery += " ORDER BY SF1.F1_DTDIGIT"

   	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), 'TMP' ,.T.,.T.)

	dbSelectArea ('TMP')
	dbGoTop ()
	ProcRegua( LastRec() )
	While !('TMP')->(EOF())
		IncProc()
		If TMP->F1_VALIMPJ != 0

 	        nFactor := -1
            cCUIT    := Alltrim(posicione("SA1",1,cFilSA1+TMP->(F1_FORNECE+F1_LOJA),"A1_CGC"))
            cCUIT    := substr(cCUIT,1,2)+"-"+substr(cCUIT,3,8)+"-"+substr(cCUIT,11,1)
//          cCUIT    := SubStr(posicione("SA2",1,cFilSA2+TMP->(F1_FORNECE+F1_LOJA),"A2_CGC"),1,13)
		    //Cuit para retencion BA sin guiones
		    IF GetNewPar("AL_PEFOCUIT","S")=="S"
		       cCUIT := PADR(StrTran(cCUIT,"-",""),13," ")
		    ENDIF

			cImp	:= Str( TMP->F1_VALIMPJ*nFactor*TMP->F1_TXMOEDA, 11 )
			cImp 	:= Transform(TMP->F1_VALIMPJ*nFactor*TMP->F1_TXMOEDA,'@E 99999999.99')
			cImp 	:= StrTran( cImp, ".", "," )
	        //IMPORTE CON punto DECIMAL en TXT PERCEPCIONES BA
	        IF GetNewPar("AL_PEFOIMPO","S")=="S"
	           cImp  := StrTran( cImp, ",", "." )
	        ENDIF

			cMonto	:= Str( TMP->F1_BASIMPJ*nFactor*TMP->F1_TXMOEDA, 12 )
			cMonto 	:= Transform(TMP->F1_BASIMPJ*nFactor*TMP->F1_TXMOEDA,'@E 999999999.99')
			cMonto  := StrTran( cMonto, ".", "," )
	        //IMPORTE CON punto DECIMAL en TXT PERCEPCIONES BA
	        IF GetNewPar("AL_PEFOIMPO","S")=="S"
	           cMonto  := StrTran( cMonto, ",", "." )
	        ENDIF

			If TMP->F1_ESPECIE = 'NF'
					cTipo := 'F'
			ElseIf TMP->F1_ESPECIE = 'NDP'
					cTipo := 'D'
			ElseIf TMP->F1_ESPECIE = 'NCC'
					cTipo := 'C'
			EndIf

			cSuc 	:= SubStr(TMP->F1_DOC,1,4)
			cConst 	:= SubStr(TMP->F1_DOC,5,12)
			cLetra 	:= SubStr(TMP->F1_SERIE,1,1)
            cFecha   := SUBSTR(TMP->F1_EMISSAO,7,2)+"/"+SUBSTR(TMP->F1_EMISSAO,5,2)+"/"+SUBSTR(TMP->F1_EMISSAO,1,4) // Cambiado por nicolas el 18/05/09

			/*/------------Estructura a pasar-----------------------------------//
                                            	DESDE HASTA  TIPO     LONGITUD
         	Cuit del Percibido 		  	:= ''     1      13    Texto         13
         	Fecha de Percep. 	   		:= ''    14      23    Fecha         10
         	Tipo Comprobante(F-R-C-D)	:= ''    24      24    Texto         01
         	Letra Comprobante(A-B-C-D-M):= ''    25      25    Texto         01
         	Numero de Sucursal			:= ''    26      29    decimal		 04
         	Numero Emision				:= ''    30      37    Decimal       08
         	monto Imponible  			:= ''    38      49    Decimal       12
           	Importe Percibido  			:= ''    50      60    Decimal       11

      		*/

			cString := cCUIT + cFecha + cTipo + cLetra + cSuc + cConst  +  cMonto + cImp + Chr(13) + Chr(10)
            
            //Genera archivo o ambos
            IF nOpcion == 1 .or. nOpcion== 3
			   FWrite(  nPuntero,  cString, Len( cString )  )
            ENDIF
            
            //datos para impresion      
            //Genera archivo o ambos
            IF nOpcion == 2 .or. nOpcion== 3
	            IF Len(aDet) = 0      
	               AADD(aDet,{ {"Numero de CUIT","C"} ,{"Codigo / Tienda","C"},{PADR("Razon Social",50),"C"}, {"Fecha comprobante","D"} , {"Tipo Comprob","C"} ,;
	                           {"Letra comprob","C"} , {"Sucursal","C"} , {"Comprobante","C"}  ,  {"Importe base","N"} , {"Importe percepcion","N"}  })
	            ENDIF
	            AADD(aDet,{ cCUIT , TMP->F1_FORNECE+"-"+TMP->F1_LOJA, UPPER(TMP->A1_NOME), cFecha , ;
	                       cTipo , cLetra , cSuc , cConst  ,  StrTran(  cMonto, ",", "." ) , StrTran(  cImp, ",", "." )  })
            ENDIF

			dbSelectArea ('TMP')
			DbSkip ()

		EndIf
	EndDo
	dbSelectArea ('TMP')
	dbCloseArea ()

	cQuery := " SELECT SF2.F2_FILIAL, SF2.F2_CLIENTE, SF2.F2_LOJA, SF2.F2_EMISSAO, SF2.F2_DTDIGIT, SF2.F2_DOC, " 
	cQuery += " SF2.F2_ESPECIE, SF2.F2_SERIE, SF2.F2_TXMOEDA,  "
    cQuery += " SF2.F2_VALIMPJ, SF2.F2_BASIMPJ, SA1.A1_NOME  "
	cQuery += " FROM " + RetSQLName ("SF2") + " SF2 "
    cQuery += "    INNER JOIN "+ RetSQLName ("SA1") + " SA1 "
    cQuery += "       ON SA1.A1_COD=SF2.F2_CLIENTE AND SA1.A1_LOJA=SF2.F2_LOJA AND SA1.D_E_L_E_T_='' " 
	cQuery += " WHERE (SF2.D_E_L_E_T_ <> '*') "
    cQuery += "  AND (SF2.F2_EMISSAO >= '" + DTOS(mv_par01) + "' AND SF2.F2_EMISSAO <='" + DTOS(mv_par02)+"')"
	cQuery += "  AND (SF2.F2_ESPECIE = 'NF ' OR SF2.F2_ESPECIE = 'NDC' OR SF2.F2_ESPECIE = 'CF') "
	cQuery += "  AND (SF2.F2_VALIMPJ <> 0 )"
	cQuery += " ORDER BY SF2.F2_DTDIGIT"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), 'TMP' ,.T.,.T.)

	dbSelectArea ('TMP')
	dbGoTop ()
	ProcRegua( LastRec() )
	While !('TMP')->(EOF())
		IncProc()
		If TMP->F2_VALIMPJ != 0
//         cCUIT    := SubStr(posicione("SA2",1,cFilSA2+TMP->(F2_CLIENTE+F2_LOJA),"A2_CGC"),1,13)
            cCUIT    := Alltrim(posicione("SA1",1,cFilSA1+TMP->(F2_CLIENTE+F2_LOJA),"A1_CGC"))
            cCUIT    := substr(cCUIT,1,2)+"-"+substr(cCUIT,3,8)+"-"+substr(cCUIT,11,1)

            //------------------------------------------------------------   
            //busca cupon fiscal para ver los datos de interes tarjeta
			nValSL1IB  := 0
			nBasSL1IB  := 0
		    If Alltrim(TMP->F2_ESPECIE) =="CF"
				SL1->( dbSetOrder(2) )
				SL1->( dbSeek( TMP->F2_FILIAL+TMP->F2_SERIE+TMP->F2_DOC ) )
				nBasSL1IB   := 0 //SL1->L1_XBASINT
				nValSL1IB   := 0 //SL1->L1_XIBINT
			ENDIF
            //---------------------------------------------------
			cImp	:=	Str( TMP->F2_VALIMPJ+nValSL1IB, 11 )
			cImp 	:= 	Transform(TMP->F2_VALIMPJ+nValSL1IB,'@E 99999999.99')
			StrTran( cImp, ".", "," )
			cMonto	:=	Str( TMP->F2_BASIMPJ+nBasSL1IB, 12 )
			cMonto 	:= 	Transform(TMP->F2_BASIMPJ+nBasSL1IB,'@E 999999999.99')
			StrTran( cMonto, ".", "," )

			If TMP->F2_ESPECIE = 'NF' .or. Alltrim(TMP->F2_ESPECIE) = 'CF'
				cTipo := 'F'
			ElseIf TMP->F2_ESPECIE = 'NDC'
				cTipo := 'D'
			ElseIf TMP->F2_ESPECIE = 'NCP'
				cTipo := 'C'
			Else
				cTipo := 'O'
			EndIf
			cSuc := SubStr(TMP->F2_DOC,1,4)
			cConst := SubStr(TMP->F2_DOC,5,12)
			cLetra := SubStr(TMP->F2_SERIE,1,1)
            cFecha := SUBSTR(TMP->F2_EMISSAO,7,2)+"/"+SUBSTR(TMP->F2_EMISSAO,5,2)+"/"+SUBSTR(TMP->F2_EMISSAO,1,4)  //Modificado por Nicolas el 18/05/09

			/*/------------Estructura a pasar-----------------------------------//
                                            	DESDE HASTA  TIPO     LONGITUD
         	Cuit del Percibido 		  	:= ''     1      13    Texto         13
         	Fecha de Percep. 	   		:= ''    14      23    Fecha         10
         	Tipo Comprobante(F-R-C-D)	:= ''    24      24    Texto         01
         	Letra Comprobante(A-B-C-D-M):= ''    25      25    Texto         01
         	Numero de Sucursal			:= ''    26      29    decimal		 04
         	Numero Emision				:= ''    30      37    Decimal       08
         	monto Imponible  			:= ''    38      49    Decimal       12
           	Importe Percibido  			:= ''    50      60    Decimal       11

      		*/

			cString := cCUIT + cFecha + cTipo + cLetra + cSuc + cConst  +  cMonto + cImp + Chr(13) + Chr(10)
            //Genera archivo o ambos
            IF nOpcion == 1 .or. nOpcion== 3
			   FWrite(  nPuntero,  cString, Len( cString )  )
            ENDIF
            //datos para impresion      
            //Genera archivo o ambos
            IF nOpcion == 2 .or. nOpcion== 3
	            IF Len(aDet) == 0      
	               AADD(aDet,{ {"Numero de CUIT","C"} ,{"Codigo / Tienda","C"},{PADR("Razon Social",50),"C"}, {"Fecha comprobante","D"} , {"Tipo Comprob","C"} ,;
	                           {"Letra comprob","C"} , {"Sucursal","C"} , {"Comprobante","C"}  ,  {"Importe base","N"} , {"Importe percepcion","N"}  })
	            ENDIF
	            AADD(aDet,{ cCUIT ,TMP->F2_CLIENTE+"-"+TMP->F2_LOJA,UPPER(TMP->A1_NOME), cFecha ,;
	                       cTipo , cLetra , cSuc , cConst  ,  StrTran(  cMonto, ",", "." ) , StrTran(  cImp, ",", "." )  })
            ENDIF
            
			dbSelectArea ('TMP')
			dbSkip ()
		EndIf
	EndDo
	dbSelectArea ('TMP')
	dbCloseArea ()

EndIf
                     

   If len(aDet) > 0
//      If !MsgYesNo("Genera informe? ")
//         Return
//      EndIf
      ARFISR01(aDet,cFile)
   EndIf
  

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³nomarch   ºAutor  ³Microsiga           ºFecha ³  10/31/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cambia nombre de archivo al seleccionar opcion de txt a    º±±
±±º          ³ generar                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//--------------------------------------------------------------------------

Static Function nomarch()

Local lRet:=.T.        
Local nPosOpc := AsCan(aGenera,{|x| Alltrim(Upper(x[1])) == Alltrim( Upper(cGenera) ) })                                                                                                 

IF nPosOpc > 0
   cFile:= aGenera[nPosOpc,2]
ENDIF  
     


Return lRet   





/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ ARFISR01 ³ Autor ³ Francisco Guerrero    ³ Data ³ 11/05/10  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripc  ³ Informe de generico para los diversos archivos txt a        ³±±
±±³          ³ generar                                                     ³±±
±±³          ³                                                             ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Libros fiscales                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ARFISR01(aDet,cFile)
Local oReport
aDetalle := aDet
cArchivo := cFile

If FindFunction("TRepInUse") .And. TRepInUse()
      oReport := ReportDef()
      oReport :PrintDialog()                 
Else
   MsgInfo( 'Informe Solo Para R4!', 'Imposible Continuar' )
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ ReportDef³ Autor ³                       ³ Data ³ 05/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
Local oReport
Local oSection1
Local oCell
Local cAliasTRB	:= ""//GetNextAlias()
Local cTitSec1	:= cArchivo //"Listados de TXT "	
Local oBreak	
Private cTit	:= OemToAnsi('Listados de archivos txt impuestos') 
Private lArchExcel  := .F.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Creaci¢n del componente de impresion                                    ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nombre del Informe                                              ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pregunta                                                        ³
//³ExpB4 : Bloque de codigo que ser  ejecutado al confirmar la impresion   ³
//³ExpC5 : Descripcion                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:= TReport():New(cArchivo,OemToAnsi('Listados de TXT '),, ;
                        {|oReport| ReportPrint(oReport,cAliasTRB)}, cTit)

oReport:SetLandScape()
//oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

//---------------------------------------------------
//Aumenta el tamanho del fuente del reporte completo
//---------------------------------------------------
//oReport:CFONTBODY:="vendana"
oReport:CFONTBODY:="TAHOMA"
oReport:nFontBody:=6
//---------------------------------------------------


oSection1 := TRSection():New(oReport,OemToAnsi(cTitSec1),,)
oSection1:SetTotalInLine(.F.)
                                           
For g:=1 to len(aDetalle[1])
    TRCell():New(oSection1,aDetalle[1,g,1]   	,,aDetalle[1,g,1]	 		, /*Picture */       	, Len(aDetalle[1,g,1]), /*lPixel */,   )
    IF aDetalle[1,g,2]=="N"
       oSection1:Cell(aDetalle[1,g,1]):SetPicture(PesqPict("SE2","E2_VALOR",17))
       oSection1:Cell(aDetalle[1,g,1]):SetAlign("RIGHT")
       TRFunction():New(oSection1:Cell(aDetalle[1,g,1]),NIL,"SUM")
    ENDIF
Next g



Return( oReport )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ ReportDef³ Autor ³     ³ Data ³ 05/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasTRB)
Local oSection1	:= oReport:Section(1)
Local oBreak
Local lFirst   	:= .F.
Local cTipoMov 	:= 'C'
Local cFilPar18	:= ""	
Local nOrdem 	:= oSection1:GetOrder()
Local cOrden	:= ""
Local nTotReg	:= 0
Local cCorte	:= ""

//Archivo Excel si o no
lArchExcel  := IIF(oReport:CXLSFILE <> NIL, .T., .F.) 



nTotReg:=Len(aDetalle)

//oSection1:Print()

oReport:PrintText(cArchivo)
oReport:SkipLine()                                      
oReport:ThinLine()
oReport:SkipLine()                                      

oSection1:Init()

oReport:SetMeter(nTotReg)

For h:=2 to len(aDetalle)
    
	If oReport:Cancel()
		Exit
	EndIf
    For j:=1 to len(aDetalle[h])                             
        
        xValor:= aDetalle[h,j]
        IF aDetalle[1,j,2]=="N"
           xValor:= VAL(aDetalle[h,j])
        ELSEIF aDetalle[1,j,2]=="D"
           xValor:= CTOD(aDetalle[h,j])
        ENDIF
		oSection1:Cell(aDetalle[1,j,1]):SetValue(xValor)
	
	Next j
	oReport:IncMeter()
	oSection1:PrintLine()

Next h

oSection1:Finish()          

//Cierra tabla temporal



Return NIL

