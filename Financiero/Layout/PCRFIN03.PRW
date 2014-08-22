#include "rwmake.ch"
#include "Protheus.ch"
//--------------------------------------------------------
//Definiciones de papel
#define DMPAPER_LETTER      1           /* Letter 8 1/2 x 11 in               */
#define DMPAPER_LETTERSMALL 2           /* Letter Small 8 1/2 x 11 in         */
#define DMPAPER_TABLOID     3           /* Tabloid 11 x 17 in                 */
#define DMPAPER_LEDGER      4           /* Ledger 17 x 11 in                  */
#define DMPAPER_LEGAL       5           /* Legal 8 1/2 x 14 in                */
#define DMPAPER_STATEMENT   6           /* Statement 5 1/2 x 8 1/2 in         */
#define DMPAPER_EXECUTIVE   7           /* Executive 7 1/4 x 10 1/2 in        */
#define DMPAPER_A3          8           /* A3 297 x 420 mm                    */
#define DMPAPER_A4          9           /* A4 210 x 297 mm                    */
#define DMPAPER_A4SMALL     10          /* A4 Small 210 x 297 mm              */
#define DMPAPER_A5          11          /* A5 148 x 210 mm                    */
#define DMPAPER_B4          12          /* B4 250 x 354                       */
#define DMPAPER_B5          13          /* B5 182 x 257 mm                    */
#define DMPAPER_FOLIO       14          /* Folio 8 1/2 x 13 in                */
#define DMPAPER_QUARTO      15          /* Quarto 215 x 275 mm                */
#define DMPAPER_10X14       16          /* 10x14 in                           */
#define DMPAPER_11X17       17          /* 11x17 in                           */
#define DMPAPER_NOTE        18          /* Note 8 1/2 x 11 in                 */
#define DMPAPER_ENV_9       19          /* Envelope #9 3 7/8 x 8 7/8          */
#define DMPAPER_ENV_10      20          /* Envelope #10 4 1/8 x 9 1/2         */
#define DMPAPER_ENV_11      21          /* Envelope #11 4 1/2 x 10 3/8        */
#define DMPAPER_ENV_12      22          /* Envelope #12 4 \276 x 11           */
#define DMPAPER_ENV_14      23          /* Envelope #14 5 x 11 1/2            */
#define DMPAPER_CSHEET      24          /* C size sheet                       */
#define DMPAPER_DSHEET      25          /* D size sheet                       */
#define DMPAPER_ESHEET      26          /* E size sheet                       */
#define DMPAPER_ENV_DL      27          /* Envelope DL 110 x 220mm            */
#define DMPAPER_ENV_C5      28          /* Envelope C5 162 x 229 mm           */
#define DMPAPER_ENV_C3      29          /* Envelope C3  324 x 458 mm          */
#define DMPAPER_ENV_C4      30          /* Envelope C4  229 x 324 mm          */
#define DMPAPER_ENV_C6      31          /* Envelope C6  114 x 162 mm          */
#define DMPAPER_ENV_C65     32          /* Envelope C65 114 x 229 mm          */
#define DMPAPER_ENV_B4      33          /* Envelope B4  250 x 353 mm          */
#define DMPAPER_ENV_B5      34          /* Envelope B5  176 x 250 mm          */
#define DMPAPER_ENV_B6      35          /* Envelope B6  176 x 125 mm          */
#define DMPAPER_ENV_ITALY   36          /* Envelope 110 x 230 mm              */
#define DMPAPER_ENV_MONARCH 37          /* Envelope Monarch 3.875 x 7.5 in    */
#define DMPAPER_ENV_PERSONAL 38         /* 6 3/4 Envelope 3 5/8 x 6 1/2 in    */
#define DMPAPER_FANFOLD_US  39          /* US Std Fanfold 14 7/8 x 11 in      */
#define DMPAPER_FANFOLD_STD_GERMAN  40  /* German Std Fanfold 8 1/2 x 12 in   */
#define DMPAPER_FANFOLD_LGL_GERMAN  41  /* German Legal Fanfold 8 1/2 x 13 in */
#define DMPAPER_LAST        DMPAPER_FANFOLD_LGL_GERMAN
#define DMPAPER_USER        256

//--------------------------------------------------------
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ PCRFIN03 ³Autor  ³ Microsiga           ³ Data ³ 17.10.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Formato de Salida para Comprobantes de Retencion         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ SIGAFIN                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
User Function PCRFIN03(cDesde, cHasta, nCop)

//Declaracion de Variables
Private aEnvOpag := GetArea()
PRIVATE lPrOk  := .T.                  //Status de la impresion
Private cStartPath	:= GetSrvProfString("Startpath","")

//Comprobante
PRIVATE nFilad   := 0
PRIVATE nUltiEnc := 1000                 //Ultima Fila Utilizada por el Encabezado
PRIVATE nPrimPie := 2500                 //Primera Fila Utilizada por el Pie
PRIVATE nCuantas := 0                    //Cuantas veces fue impreso el comprobante SCN->CN_PRINTED
PRIVATE cNombCom := "CONSTANCIA DE RETENCION"    //Nombre del Comprobante
PRIVATE cObe1Com := ""                   //Observaciones en Encabezado 1 SA1->A1_OBSERV
PRIVATE cObe2Com := ""                   //Observaciones en Encabezado 2 SA1->A1_OBS1
PRIVATE cObe3Com := ""                   //Observaciones en Encabezado 3
PRIVATE cObspCom := ""                   //Observaciones en el Pie
PRIVATE cNocoCom := ""                   //Nombre de la Copia
PRIVATE cEnleCom := ""                   //Importe en letras
PRIVATE cMoneCom := ""                   //Moneda del Comprobante
PRIVATE cMonnCom := ""                   //Nombre de la Moneda
PRIVATE cMonsCom := ""                   //Signo de la Moneda del comprobante
PRIVATE nCopaCom := 0                    //Copia Actual del Comprobante
PRIVATE nCopiCom := 0                    //Cantidad de Copias del Comprobante
PRIVATE nPagaCom := 0                    //P gina actual del Comprobante
PRIVATE nPagsCom := 0                    //N£mero total de p ginas del Comprobante
PRIVATE cFirmCod := Space( 6 )         //Firmante de los Comprobantes
PRIVATE cFirmNom := Space( 30 )         //Firmante de los Comprobante(Nombre)
PRIVATE cFirmCar := Space( 30 )         //Firmante de los Comprobantes(Cargo)
PRIVATE dFechCom := CTOD( "  /  /  " ) // Fecha del comprobante
PRIVATE cNumeCom := " "                    //Numero del comprobante
PRIVATE cTiprCom := " "                     //Tipo de retencion
PRIVATE cImpuCom := " "                    //Nombre del impuesto
PRIVATE cRegiCom := " "                     //Nombre del regimen de retencion
PRIVATE cOpagCom := " "                     //Numero de Orden de Pago origen
PRIVATE nBaseCom := 0                       //Base de retencion
PRIVATE nReteCom := 0                       //Importe de la retencion
PRIVATE nPagina  := 0                      //Numero de pagina

//Agente
PRIVATE cCodiAge := ""                   //Codigo del Agente
PRIVATE cNombAge := ""                   //Razon Social del Agente
PRIVATE cDomiAge := ""                   //Domicilio del Agente
PRIVATE cLocaAge := ""                   //PRIVATEidad del Agente
PRIVATE cCodPAge := ""                   //Codigo Postal del Agente
PRIVATE cProvAge := ""                   //Provincia del Agente
PRIVATE cPaisAge := ""                   //Pais del Agente
PRIVATE cCivaAge := ""                   //Responsabilidad frente al IVA (CODIGO)
PRIVATE cRivaAge := ""                   //Responsabilidad frente al IVA (NOMBRE)
PRIVATE cCuitAge := ""                   //CUIT del Agente
PRIVATE cIIBBAge := ""                   //Numero de IIBB
PRIVATE cNumAAge := ""                   //Numero Agente retencion

//Proveedor
PRIVATE cCodiPro := ""                   //Codigo del Proveedor
PRIVATE cNombPro := ""                   //Razon Social del Proveedor
PRIVATE cNom2Pro := ""                   //Nombre del Proveedor
PRIVATE cDomiPro := ""                   //Domicilio del Proveedor
PRIVATE cLocaPro := ""                   //PRIVATEidad del Proveedor
PRIVATE cCodPPro := ""                   //Codigo Postal del Proveedor
PRIVATE cProvPro := ""                   //Provincia del Proveedor
PRIVATE cPaisPro := ""                   //Pais del Proveedor
PRIVATE cCivaPro := ""                   //Responsabilidad frente al IVA (CODIGO)
PRIVATE cRivaPro := ""                   //Responsabilidad frente al IVA (NOMBRE)
PRIVATE cCuitPro := ""                   //CUIT del Proveedor
PRIVATE cVendPro := ""                   //Vendedor del Proveedor
PRIVATE cOrdcPro := ""                   //Orden de Compra del Proveedor
PRIVATE cContPro := ""                   //Contacto del Proveedor
PRIVATE cIIBBPro := ""                   //Numero de IIBB del proveedor
PRIVATE cRGSUS 	 := ""					 //RG de SUSS del Proveedor
PRIVATE	cCodIB   := ""  				 //Nro. IIBB ????? 	
PRIVATE cRGIBCF  := GetNewPar("MV_RGIBCF"	,"Regimen General de retención y percepción")
PRIVATE cRGIBBA	 := GetNewPar("MV_RGIBBA"	,"Regimen General de retención y percepción")
PRIVATE cRGIBSF	 := GetNewPar("MV_RGIBSF"	,"Regimen General de retención y percepción")
PRIVATE cARiesgo := ""
PRIVATE cRSimpl  := ""

Private cFirmAut := GetNewPar("MV_MCFFIR1",cStartPath+"Mc"+cEmpAnt+"Apoderado.bmp") //patch y nombre archivo de firma a imprimir, debe ser BMP
//   \system\Mc01Apoderado.bmp



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variables del detalle.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ariel ÄÄÄÙ
PRIVATE acComp := {}                   //Comprobantes

// Definicion de Fonts para Impresion
PRIVATE oPrn  := TMSPrinter():New(), ;
oFont1 := TFont():New( "Arial"      ,, 12,, .t.,,,,    , .f. )
oFont2 := TFont():New( "Arial"      ,, 10,, .t.,,,,    , .f. )
oFont3 := TFont():New( "Arial"      ,, 08,, .t.,,,,    , .f. )
oFont4 := TFont():New( "Arial"      ,, 12,, .t.,,,,    , .f. )
oFont5 := TFont():New( "Arial"      ,, 10,, .f.,,,,    , .f. )
oFont6 := TFont():New( "Arial"      ,, 08,, .f.,,,,    , .f. )

oPrn:SETPAPERSIZE(DMPAPER_A4)  //setea hoja A4
oPrn:SetPortrait()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros:                          ³
//³ mv_par01 == Desde Numero             ³
//³ mv_par02 == Hasta Numero             ³
//³ mv_par03 == Cantidad de Copias       ³
//³ mv_par04 == Tipo de Retencion        ³
//³ mv_par05 == de Proveedor             ³
//³ mv_par06 == a Proveedor              ³
//³ mv_par07 == desde                    ³
//³ mv_par08 == hasta                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If FunName(1) = "PCRFIN03"
	VldPerg()
	
	If !Pergunte("PCRFIN03", .T.)
		Return
	EndIf
	
	cParDesde := MV_par01 //StrZero( Val( mv_par01 ), 12 )
	cParHasta := MV_PAR02 //StrZero( Val( mv_par02 ), 12 )
	nParCopia := mv_par03
	cPardProv := mv_par05
	cParaProv := mv_par06
	cParddesd := mv_par07
	cParahast := mv_par08
Else
	Pergunte("PCRFIN03", .F.)
	cParDesde := cDesde
	cParHasta := cHasta
	nParCopia := nCop
	cPardProv := ""
	cParaProv := "ZZZZZZ"
	cParddesd := CToD('  /  /  ')
	cParahast := CToD('31/12/49')
	mv_par04  := 1
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definici¢n de Vectores para Control de Impresi¢n. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ariel ÄÄÄÄÙ
aHeader := {}
aCols   := {}
nEle    := 0

AADD(aHeader,{ "Comprobante"   , "O.Pago", "@!",03,0,".T.","€€€€€€‚","C","", "" } )
AADD(aHeader,{ "Tipo"   , "Tipo", "@!",03,0,".T.","€€€€€€‚","C","", "" } )
AADD(aHeader,{ "Certificado"   , "Certificado", "@!",03,0,".T.","€€€€€€‚","C","", "" } )
AADD(aHeader,{ "Proveedor    "   , "Proveedor", "@!",03,0,".T.","€€€€€€‚","C","", "" } )

aCab := {}
AADD(aCab,OemToAnsi("O.Pago"))
AADD(aCab,OemToAnsi("Tipo"))
AADD(aCab,OemToAnsi("Certificado"))
AADD(aCab,OemToAnsi("Proveedor"))

//Imprimir certificados
RptStatus( {|lEnd| ImpReport(@lEnd)}, "Aguarde...","Impresion de Comprobantes de Retencion", .T. )



Return
//------------------------------------------------------------------------------------------
//  IMPRIMIR CERTIFICADOS DE RETENCION
//
//-----------------------------------------------------------------------------------------

Static Function ImpReport

Local 	cQuery	:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carga de Variables.                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ariel ÄÄÄÙ
DbSelectArea("SEK")
DbSetOrder(1)
DbSelectArea("SFH")
DbSetOrder(1)


//Posiciono SFE
//Query para performance y unificar certificados separados por orden de registros

cQuery := " SELECT * "
cQuery += " FROM " + RetSQLName ("SFE") +" SFE "
cQuery += " WHERE SFE.FE_FILIAL = '"+xFilial("SFE")+"' AND SFE.D_E_L_E_T_<> '*' AND (SFE.FE_NROCERT <> 'NORET' ) " 
cQuery += " AND (SFE.FE_EMISSAO >= '" + DTos(cPardDesd) + "' AND SFE.FE_EMISSAO <='" + DTOS(cParaHast)+"') "
cQuery += " AND (SFE.FE_FORNECE>='"+cPardProv+"' AND SFE.FE_FORNECE <='"+cParaProv+"') "
cQuery += " AND (SFE.FE_ORDPAGO>='"+cParDesde+"' AND SFE.FE_ORDPAGO <='"+cParHasta+"') "
cQuery += " ORDER BY SFE.FE_FILIAL, SFE.FE_ORDPAGO, SFE.FE_NROCERT, SFE.R_E_C_N_O_ "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), 'TMP' ,.T.,.T.)

TCSetField("TMP","FE_EMISSAO","D", 8,0)
TCSetField("TMP","FE_RETENC" ,"N",17,2)
TCSetField("TMP","FE_ALIQ"   ,"N",17,2)
TCSetField("TMP","FE_VALBASE","N",17,2)

dbSelectArea('TMP')
dbGoTop()
SetRegua( RecCount() )


//dbSelectarea("SFE")
//dbSetOrder(2)  // FE_FILIAL, FE_ORDPAGO, FE_TIPO.
//dbSeek(xFilial("SFE")+cParDesde, .T.)

lSalida := .F.             //Salida no prevista
lUltimo := .F.             //Salida por finalizaci¢n
quecom  := TMP->FE_ORDPAGO

If  Empty( cFirmCod )
	PideFirm( cFirmCod )
EndIf

//Agente
cCodiAge := SM0->M0_CODIGO
cNombAge := "SUCESORES DE DOMINGO RESTA Y CIA S.A."//SM0->M0_NOMECOM
cDomiAge := ALLTRIM(SM0->M0_ENDENT) 			//"Incluir datos de la empresa"
cLocaAge := ALLTRIM(SM0->M0_CIDENT)				//"Incluir datos de la empresa"
cCodPAge := "("+ALLTRIM(SM0->M0_CEPENT)+")" 	//"Incluir datos de la empresa"
cProvAge := ALLTRIM(SM0->M0_ESTENT)				//"Incluir datos de la empresa"
cPaisAge := SM0->M0_FILIAL
cCuitAge := SM0->M0_CGC
cIIBBAge := SM0->M0_INSC			            //"Nro. agente IIBB

//nCuantas := SF1->F1_PRINTED  //Control de Cantidad de Impresiones

//dbSelectArea( "SFE" )
//SetRegua(RecCount())

// While quecom <= cParHasta .and. !lSalida .and. !lUltimo .and. !SFE->( Eof() ) .and. SFE->FE_FORNECE >= cPardProv .and. SFE->FE_FORNECE <= cParaProv .and. SFE->FE_EMISSAO >= cPardDesd .and. SFE->FE_EMISSAO <= cParaHast
nPagina:=1
While quecom <= cParHasta .and. !lSalida .and. !lUltimo .and. !TMP->( Eof() )
	

	
	lLoop := .F.
	If mv_par04 != 1 .and. (;
		(mv_par04 == 2 .and. TMP->FE_TIPO <> "G") .or.;
		(mv_par04 == 3 .and. TMP->FE_TIPO <> "I") .or.;
		(mv_par04 == 4 .and. TMP->FE_TIPO <> "B") .or.;
		(mv_par04 == 5 .and. !(TMP->FE_TIPO $ "U/S")))
		lLoop := .T.
	Elseif TMP->(FE_RETENC == 0 .or. !(TMP->FE_FORNECE >= cPardProv .and. TMP->FE_FORNECE <= cParaProv .and. TMP->FE_EMISSAO >= cPardDesd .and. TMP->FE_EMISSAO <= cParaHast))
		// Quique 07/01/04 - se quito el signo ">"  en la condicion, para
		// que tome en cuenta las retenciones de Ingresos Brutos en NCP.
		lLoop := .T.
	Elseif TMP->FE_NROCERT = "NORET"
		lLoop := .T.
	Endif
	
	If lLoop
		TMP->(dbSkip())
		quecom := TMP->FE_ORDPAGO
		Loop
	Endif
	
	// Inicializar variables.
	IniVars()
	
	nCopiCom := nParCopia
	nCopaCom := 1
	nPagaCom := 0
	nPagsCom := 0
	
	cCodiPro := TMP->FE_FORNECE + TMP->FE_LOJA
	
	//Posiciono SA2
	dbSelectarea( "SA2" )
	dbSetOrder(1)
	dbSeek( xFilial("SA2")+cCodiPro, .F. )
	
	If !Found()
		MsgStop( "Proveedor " + cCodiPro + " no hallado en la tabla !" )
		lSalida := .T.
		Loop
	Else
		If nCopiCom == 0
			nCopiCom := 1
		EndIf
		
		cConnCom := " "
		cNombPro := AllTrim( SA2->A2_NOME )
		cnom2Pro := AllTrim( SA2->A2_NREDUZ )
		cDomiPro := SA2->A2_END
		cLocaPro := SA2->A2_MUN
		cCodPPro := SA2->A2_CEP
		cProvPro := NomProv( SA2->A2_EST )
		cPaisPro := ""
		cCivaPro := SA2->A2_TIPO
		cCobrPro := ""
		cCuitPro := SA2->A2_CGC
		cContPro := SA2->A2_CONTATO
		cIIBBPro := TransForm(SA2->A2_NROIB,PesqPict( "SA2", "A2_NROIB" ))
		cRGSUS	 := IIF(!Empty(SA2->A2_CONCSUS),Tabela('CS',SA2->A2_CONCSUS),"")
		cCodIB	 := ""
	EndIf
	
	nPagsCom += 1
	dFechCom := TMP->FE_EMISSAO   // Fecha del comprobante.
	cNumeCom := TMP->FE_NROCERT   // Numero del comprobante.
	cTiprCom := TMP->FE_TIPO      // Tipo de retencion.
	cOpagCom := TMP->FE_ORDPAGO   // Numero de orden de pago origen.
	
	Do Case
		Case TMP->FE_TIPO == "I"
			cImpuCom := "IMPUESTO AL VALOR AGREGADO (I.V.A.)"
			cRegiCom := Posicione("SFF", 3, xFilial( "SFF" ) + "IVR" + TMP->FE_SERIE, "FF_CONCEPT")
			While TMP->(!Eof() .and. TMP->FE_TIPO == "I" .and. TMP->FE_ORDPAGO == quecom .and. TMP->FE_NROCERT == cNumeCom)
				nBaseCom += TMP->FE_VALBASE   // Base de retencion.
				nReteCom += TMP->FE_RETENC    // Importe de la retencion.
				If TMP->FE_ALIQ > 0
					AADD( acComp, {TMP->FE_NFISCAL, TMP->FE_ALIQ, TMP->FE_RETENC, TMP->FE_VALBASE })
				Else
					AADD( acComp, {TMP->FE_NFISCAL, TMP->FE_PORCRET, TMP->FE_RETENC, TMP->FE_VALBASE })
				EndIf								
				TMP->(dbSkip())
		        IncRegua("Imprimiendo...")
			EndDo
			
		Case TMP->FE_TIPO == "G"
			cImpuCom := "IMPUESTO A LAS GANANCIAS "
			cRegiCom := Posicione("SFF", 2, xFilial( "SFF" ) + TMP->FE_CONCEPT, "FF_CONCEPT")
			While TMP->(!Eof() .and. TMP->FE_TIPO == "G" .and. TMP->FE_ORDPAGO == quecom .and. TMP->FE_NROCERT == cNumeCom)
				AgregaTit(acComp, @nBaseCom, @nReteCom)
				TMP->(dbSkip())
		        IncRegua("Imprimiendo...")
			EndDo
			
		Case TMP->FE_TIPO == "B" .AND. TMP->FE_EST == "CF"			
			cCodIB 		:= AllTrim(GetNewPar("MV_CODIBCF",""))
			cPcia		:= Tabela("12",TMP->FE_EST)
			cImpuCom 	:= "IMPUESTO SOBRE LOS INGRESOS BRUTOS " + alltrim(cPcia)

 			SFH->(dbSeek(xFilial("SFH")+TMP->(FE_FORNECE+FE_LOJA)+"IBR"+"CF"))
 			
            If SFH->(FieldPos("FH_USRISCO")) > 0 .And. SFH->(FieldPos("FH_USRSIMP")) > 0
	            If SFH->FH_USRISCO == "1"
					cARiesgo := GetNewPar("MV_LEYAR","(REGIMEN ALTO RIESGO)")
					cRSimpl  := ""
	            ElseIf SFH->FH_USRSIMP == "1"
					cARiesgo := ""
					cRSimpl  := GetNewPar("MV_LEYRS","(REGIMEN REGIMEN SIMPLIFICADO)")            
	            Else
					cARiesgo := ""
					cRSimpl  := ""
	            EndIf
			EndIf
			
			cRegiCom 	:= cRGIBCF +" "+ cARiesgo +" "+ cRSimpl

			While TMP->(!Eof() .and. TMP->FE_TIPO == "B" .and. TMP->FE_EST == "CF" .and. TMP->FE_ORDPAGO == quecom .and. TMP->FE_NROCERT == cNumeCom)
				AgregaTit(acComp, @nBaseCom, @nReteCom)
				TMP->(dbSkip())
		        IncRegua("Imprimiendo...")
			EndDo
			
		Case TMP->FE_TIPO == "B" .AND. TMP->FE_EST == "BA"
			cCodIB 		:= AllTrim(GetNewPar("MV_CODIBBA",""))
			cPcia		:= Tabela("12",TMP->FE_EST)
			cImpuCom 	:= "IMPUESTO SOBRE LOS INGRESOS BRUTOS " + alltrim(cPcia)
			cRegiCom 	:= cRGIBBA //Regimen de retencion para capital federal
			While TMP->(!Eof() .and. TMP->FE_TIPO == "B" .and. TMP->FE_EST == "BA" .and. TMP->FE_ORDPAGO == quecom .and. TMP->FE_NROCERT == cNumeCom)
				AgregaTit(acComp, @nBaseCom, @nReteCom)
				TMP->(dbSkip())
		        IncRegua("Imprimiendo...")
			EndDo

		Case TMP->FE_TIPO == "B" .AND. TMP->FE_EST == "SF"
			cCodIB 		:= AllTrim(GetNewPar("MV_CODIBSF",""))
			cPcia		:= Tabela("12",TMP->FE_EST)
			cImpuCom 	:= "IMPUESTO SOBRE LOS INGRESOS BRUTOS " + alltrim(cPcia)
			cRegiCom 	:= cRGIBSF //Regimen de retencion para capital federal
			While TMP->(!Eof() .and. TMP->FE_TIPO == "B" .and. TMP->FE_EST == "SF" .and. TMP->FE_ORDPAGO == quecom .and. TMP->FE_NROCERT == cNumeCom)
				AgregaTit(acComp, @nBaseCom, @nReteCom)
				TMP->(dbSkip())
		        IncRegua("Imprimiendo...")
			EndDo			
			
		Case TMP->FE_TIPO == "B" .AND. TMP->FE_EST != "BA" .AND. TMP->FE_EST != "CF" .AND. TMP->FE_EST != "SF"
			cPcia		:= Tabela("12",TMP->FE_EST)
			cImpuCom 	:= "IMPUESTO SOBRE LOS INGRESOS BRUTOS " + alltrim(cPcia)
			cRegiCom 	:= ""
			While TMP->(!Eof() .and. TMP->FE_TIPO == "B" .and. TMP->FE_EST != "BA" .AND. TMP->FE_EST != "CF" .AND. TMP->FE_EST != "SF" .and. TMP->FE_ORDPAGO == quecom .and. TMP->FE_NROCERT == cNumeCom)
				AgregaTit(acComp, @nBaseCom, @nReteCom)
				TMP->(dbSkip())
		        IncRegua("Imprimiendo...")
			EndDo
			
		Case TMP->FE_TIPO == "S"
			cImpuCom := "A CUENTA DE LAS CONTRIBUCIONES CON DESTINO AL S.U.S.S. "+IIF(!Empty(cRGSUS),"("+cRGSUS+")","")
			cRegiCom := "S.U.S.S."
			While TMP->(!Eof() .and. TMP->FE_TIPO == "S" .and. TMP->FE_ORDPAGO == quecom .and. TMP->FE_NROCERT == cNumeCom)
				AgregaTit(acComp, @nBaseCom, @nReteCom)
				TMP->(dbSkip())
		        IncRegua("Imprimiendo...")
			EndDo
			
		Case TMP->FE_TIPO == "U"
			cImpuCom := "A CUENTA DE LAS CONTRIBUCIONES CON DESTINO AL S.U.S.S. (R.G. 1784)"
			cRegiCom := "S.U.S.S."
			While TMP->(!Eof() .and. TMP->FE_TIPO == "U" .and. TMP->FE_ORDPAGO == quecom .and. TMP->FE_NROCERT == cNumeCom)
				AgregaTit(acComp, @nBaseCom, @nReteCom)
				TMP->(dbSkip())
		        IncRegua("Imprimiendo...")
			EndDo
			
		Case TMP->FE_TIPO == "L"
			cImpuCom := "RETENCION AFIP  -  RG 1556/2003)"
			cRegiCom := "Servicio de Limpieza."
			While TMP->(!Eof() .and. TMP->FE_TIPO == "L" .and. TMP->FE_ORDPAGO == quecom .and. TMP->FE_NROCERT == cNumeCom)
				AgregaTit(acComp, @nBaseCom, @nReteCom)
				TMP->(dbSkip())
		        IncRegua("Imprimiendo...")
			EndDo                      
		
	EndCase
//	TMP->(dbSkip(-1)
	
	If nPagsCom >= 1
        nPagina:=1
		Imprimir()
	EndIf
    quecom := TMP->FE_ORDPAGO
	
	If !lPrOk
		Exit
	EndIf
EndDo

//Cierra tabla temporal de query
dbSelectArea ('TMP')
dbclosearea('TMP')

If empty(aCols)
	AADD(aCols, {"000000", " ", "000000", "NO FUE IMPRESO NINGUN COMPROBANTE!"})
EndIf

oPrn:Setup()
oPrn:PreView()

MS_FLUSH()
ContImp()
RestArea( aEnvOpag )

Return( lPrOk )


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ INIVARS  ³ Autor ³ Ariel A. Musumeci   ³ Data ³ 08.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Inicializaci¢n de Variables                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function Inivars()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variables del encabezado y pie.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ariel ÄÄÄÙ

lPrOk  := .T.                  //Status de la impresion

//Comprobante
nFilad   := 0
nUltiEnc := 1000                 //Ultima Fila Utilizada por el Encabezado
nPrimPie := 2500                 //Primera Fila Utilizada por el Pie
nCantItm := 16    	             //Cantidad de Items por Hoja En Una sola pagina (Sin Transporte)
nCanmItm := 16                   //Cantidad de Items por Hoja En Varias paginas (Con Transporte)
nCuantas := 0                    //Cuantas veces fue impreso el comprobante SCN->CN_PRINTED
nNumItem := 0                    //Numero de Item para impresion
cNombCom := "CONSTANCIA DE RETENCION"    //Nombre del Comprobante
cClasCom := "   "                //Clase del comprobante
cNumeCom := Space(12)            //Numero del comprobante
cObe1Com := ""                   //Observaciones en Encabezado 1 SA1->A1_OBSERV
cObe2Com := ""                   //Observaciones en Encabezado 2 SA1->A1_OBS1
cObe3Com := ""                   //Observaciones en Encabezado 3
cNumpCom := ""                   //Numeros de Pedido Relacionados
cNumrCom := ""                   //Numeros de O. Compra Origen del Item
cObspCom := ""                   //Observaciones en el Pie
cNocoCom := ""                   //Nombre de la Copia
cCondCom := ""                   //Condicion de Venta
cConNCom := ""                   //Nombre de la Condicion de Pago
cEnleCom := ""                   //Importe en letras
cMoneCom := ""                   //Moneda del Comprobante
cMonnCom := ""                   //Nombre de la Moneda
cMonsCom := ""                   //Signo de la Moneda del comprobante
nCopaCom := 0                    //Copia Actual del Comprobante
nCopiCom := 0                    //Cantidad de Copias del Comprobante
nPagaCom := 0                    //P gina actual del Comprobante
nPagsCom := 0                    //N£mero total de p ginas del Comprobante
dFechCom := CTOD( "  /  /  " ) // Fecha del comprobante
cNumeCom := " "                    //Numero del comprobante
cTiprCom := " "                     //Tipo de retencion
cImpuCom := " "                    //Nombre del impuesto
cRegiCom := " "                     //Nombre del regimen de retencion
cOpagCom := " "                     //Numero de Orden de Pago origen
nBaseCom := 0                       //Base de retencion
nReteCom := 0                       //Importe de la retencion

//Proveedor
cCodiPro := ""                   //Codigo del Proveedor
cNombPro := ""                   //Razon Social del Proveedor
cNom2Pro := ""                   //Nombre del Proveedor
cDomiPro := ""                   //Domicilio del Proveedor
cLocaPro := ""                   //PRIVATEidad del Proveedor
cCodPPro := ""                   //Codigo Postal del Proveedor
cProvPro := ""                   //Provincia del Proveedor
cPaisPro := ""                   //Pais del Proveedor
cCivaPro := ""                   //Responsabilidad frente al IVA (CODIGO)
cRivaPro := ""                   //Responsabilidad frente al IVA (NOMBRE)
cCuitPro := ""                   //CUIT del Proveedor
cVendPro := ""                   //Vendedor del Proveedor
cOrdcPro := ""                   //Orden de Compra del Proveedor
cContPro := ""                   //Contacto del Proveedor

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variables del detalle.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ariel ÄÄÄÙ
acComp := {}                   //Comprobantes

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ IMPRIMIR ³ Autor ³ Ariel A. Musumeci   ³ Data ³ 08.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Rutina de Impresi¢n.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function Imprimir()     


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Control de Impresi¢n.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ariel ÄÄÄÙ
If (nCuantas > 0 .and. MsgYesNo( "O.Pago: " + cNumeCom + ", IMPRESIONES: " + AllTrim(Str(nCuantas,3)) + Chr(13) + Chr(10) +;
	"DESEA IMPRIMIRLA NUEVAMENTE ?", "Comprobante ya Impreso" ) ) .or. nCuantas == 0
	
	//	ProcRegua( nCopiCom )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ C lculo de Cantidad de P ginas.           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ariel ÄÄÄÙ
	//nPagsCom := Len( acDetItm ) / nCanmItm
	nPagsCom := Int( If( nPagsCom < 1, 1, If( nPagsCom > 1 .and. nPagsCom > Int(nPagsCom), nPagsCom + 1, nPagsCom ) ) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Llamada al spool de impresi¢n.            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ariel ÄÄÄÙ
	While nCopaCom <= nCopiCom
		lPrOk := .T.
		ImpEncab()
		ImpDetal( cTiprCom )
		ImpPie()
		
		//		IncProc("Constancia: "+cNumeCom+" - Copia: " + Alltrim(Str(nCopaCom,3)) + " de " + Alltrim(Str(nCopiCom,3)))
		//		IncProc()
		If !lProk
			Exit
		EndIf
		nCopaCom += 1
		nPagaCom := 0
	EndDo
	
	//Cargo Vector para control de Impresi¢n
	AADD(aCOLS,{ quecom, cTipRCom, cNumeCom, cNombPro })
Endif

If !lPrOk
	Return(lPrOk)
EndIf

dbSelectArea("TMP")
/*/
TMP->(dbSkip())   //aca avanza
quecom := TMP->FE_ORDPAGO
If quecom > cParHasta .or. SFE->(Eof())
	lUltimo := .T.
EndIf
/*/
Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ ImpEncab ³ Autor ³ Ariel A. Musumeci   ³ Data ³ 08.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Rutina de Impresi¢n de Encabezados.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ VESFAC                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function ImpEncab()

oPrn:StartPage()


nFilaEnc := 0
                             

nPagaCom := nPagaCom + 1

NomeCopi()

If !Empty( GetMV( "MV_DIRLOGO" ) )
	If File( AllTrim( GetMV( "MV_DIRLOGO" ) ) )
		//oPrn:SayBitmap( 0070, 0100, AllTrim( GetMV( "MV_DIRLOGO" ) ) , 350, 150 )
	EndIf
EndIf

oPrn:Say( 0100, 0150, PadL( "CONSTANCIA DE RETENCION", 80 ), oFont1, 100 )
oPrn:Say( 0200, 1700, "NUMERO:", oFont6, 100 )
oPrn:Say( 0200, 2000, cNumeCom, oFont2, 100 )
oPrn:Say( 0250, 1700, "FECHA:", oFont6, 100 )
oPrn:Say( 0250, 2000, DToC( dFechCom ), oFont2, 100 )
oPrn:Line( 0370, 0050, 0370, 2300 )

oPrn:Say( 0300, 1700, "PAGINA:", oFont6, 100 )
oPrn:Say( 0300, 2000, STRZERO(nPagina,4), oFont2, 100 )

oPrn:Say( 0400, 0100, "DATOS DEL AGENTE DE RETENCION:", oFont3, 100 )
oPrn:Line( 0450, 0050, 0450, 2300 )
oPrn:Say( 0500, 0150, "RAZON SOCIAL  :", oFont6, 100 )
oPrn:Say( 0500, 0450, Upper( OemToAnsi( cNombAge ) ), oFont2, 100 )
If cTiprCom = "B"
	oPrn:Say( 0500, 1500, "NRO. I.I.B.B:", oFont6, 100 )
	oPrn:Say( 0500, 1700, cIIBBAge, oFont2, 100 )
EndIf
If !Empty(cCodIB)
	oPrn:Say( 0550, 1500, "NRO. AGENTE:", oFont6, 100 )
	oPrn:Say( 0550, 1700, cCodIB, oFont2, 100 )
EndIf
oPrn:Say( 0550, 0150, "DOMICILIO     :", oFont6, 100 )
oPrn:Say( 0550, 0450, Upper( OemToAnsi( cDomiAge ) ), oFont2, 100 )
oPrn:Say( 0600, 0150, "LOCALIDAD     :", oFont6, 100 )
oPrn:Say( 0600, 0450, Upper( cLocaAge ), oFont2, 100 )
oPrn:Say( 0650, 0150, "PROVINCIA     :", oFont6, 100 )
oPrn:Say( 0650, 0450, Upper( cProvAge ), oFont2, 100 )
oPrn:Say( 0700, 0150, "REGIMEN DE IVA:", oFont6, 100 )
oPrn:Say( 0700, 0450, Upper( "Responsable Inscripto" ), oFont2, 100 )
oPrn:Say( 0700, 1500, "C.U.I.T.:", oFont6, 100 )
oPrn:Say( 0700, 1700, SubStr( cCuitAge, 1, 2 ) + "-" + SubStr( cCuitAge, 3, 8 ) + "-" + SubStr( cCuitAge, 11, 1 ), oFont2, 100 )
oPrn:Say( 0800, 0100, "DATOS DEL SUJETO RETENIDO:", oFont3, 100 )
oPrn:Line( 0850, 0050, 0850, 2300 )
oPrn:Say( 0900, 0150, "RAZON SOCIAL  :", oFont6, 100 )
oPrn:Say( 0900, 0450, Trim(cNombPro), oFont2, 100 )
oPrn:Say( 0900, 1500, "CODIGO  :", oFont6, 100 )
oPrn:Say( 0900, 1700, cCodiPro, oFont2, 100 )
oPrn:Say( 0950, 0150, "DOMICILIO     :", oFont6, 100 )
oPrn:Say( 0950, 0450, Upper( cDomiPro ), oFont2, 100 )
oPrn:Say( 0950, 1500, "NRO. I.I.B.B.:", oFont6, 100 )
oPrn:Say( 0950, 1700, Upper( cIIBBPro )	, oFont2, 100 )
oPrn:Say( 1000, 0150, "LOCALIDAD     :", oFont6, 100 )
oPrn:Say( 1000, 0450, Upper( cLocaPro ), oFont2, 100 )
oPrn:Say( 1050, 0150, "PROVINCIA     :", oFont6, 100 )
oPrn:Say( 1050, 0450, Upper( cProvPro ), oFont2, 100 )
oPrn:Say( 1100, 0150, "REGIMEN DE IVA:", oFont6, 100 )
oPrn:Say( 1100, 0450, Upper( Tabela("SF",cCivaPro) ), oFont2, 100 )
oPrn:Say( 1100, 1500, "C.U.I.T.:", oFont6, 100 )
oPrn:Say( 1100, 1700, SubStr( cCuitPro, 1, 2 ) + "-" + SubStr( cCuitPro, 3, 8 ) + "-" + SubStr( cCuitPro, 11, 1 ), oFont2, 100 )

oPrn:Say( 1200, 0100, "DATOS DE LA RETENCION PRACTICADA:", oFont3, 100 )
oPrn:Line( 1250, 0050, 1250, 2300 )
oPrn:Say( 1300, 0150, "IMPUESTO     :", oFont6, 100 )
oPrn:Say( 1300, 0450, Upper( cImpuCom ), oFont2, 100 )
oPrn:Say( 1350, 0150, "REGIMEN      :", oFont6, 100 )
oPrn:Say( 1350, 0450, Left( cRegiCom, 84 ), oFont2, 100 )
oPrn:Say( 1400, 0150, "ORDEN DE PAGO:", oFont6, 100 )
oPrn:Say( 1400, 0450, cOpagCom, oFont2, 100 )
oPrn:Say( 1450, 0150, "BASE IMP.:", oFont6, 100 )
oPrn:Say( 1450, 0450, PadL( Transform( nBaseCom, "@E 9,999,999,999.99" ), 17), oFont2, 100 )
oPrn:Say( 1500, 0150, "MONTO RETENIDO:", oFont6, 100 )
oPrn:Say( 1500, 0450, PadL( Transform( nReteCom, "@E 9,999,999,999.99" ), 17), oFont2, 100 )

oPrn:Line( 1600, 0050, 1600, 2300 )

oPrn:Say( 1600, 0100, "SON " + Extenso( nReteCom ), oFont3, 100 )

nFilad := nUltiEnc


Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ IMPDETAL ³ Autor ³ Ariel A. Musumeci   ³ Data ³ 08.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Rutina de Impresi¢n de Detalles.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function Impdetal( cRetip )

//If cRetip $ "BS"
IF Len(acComp) > 0
	            
	ImpDetT()//Titulos de detalles
	
	nFilad := 1900
	
	For d := 1 To Len( acComp )
	
	    IF nFilad >= 2800                  
	
		   nPagina++
	    
           oPrn:Say( 3000, 0100, "Continua en pagina "+STRZERO(nPagina,4), oFont6, 100 )
           oPrn:EndPage()//finaliza pagina
	       
		   
		   ImpEncab()//Impresion de cabecera
		   
	       ImpDetT()//Titulos de detalles
	       
	       nFilad := 1900         
	    
	    
	    ENDIF
	
		nFilad += 50
		oPrn:Say( nFilad, 0150, acComp[d][1], oFont6, 100 )
		oPrn:Say( nFilad, 0900, PadL( Transform( acComp[d][4], "@E 999,999.99" ), 10), oFont6, 100 )
		If acComp[d][2] > 0
			oPrn:Say( nFilad, 1600, PadL( Transform( acComp[d][2], "@E 999,999.99" ), 10), oFont6, 100 )
		Endif
		oPrn:Say( nFilad, 1900, PadL( Transform( acComp[d][3], "@E 999,999.99" ), 10), oFont6, 100 )
		
	Next d
EndIf

Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ IMPPIE   ³ Autor ³ Ariel A. Musumeci   ³ Data ³ 08.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Rutina de Impresi¢n de Pie de Documento.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function ImpDetT()

	oPrn:Say( 1780, 0100, "COMPROBANTES APLICADOS:", oFont6, 100 )
	oPrn:Box( 1820, 0050, 1900, 2300 )
	
	oPrn:Say( 1850, 0150, "COMPROBANTE", oFont6, 100 )
	oPrn:Say( 1850, 0900, "BASE IMPONIBLE", oFont6, 100 )
	oPrn:Say( 1850, 1600, "% DE RETENCION", oFont6, 100 )
	oPrn:Say( 1850, 1900, "IMPORTE RETENCION", oFont6, 100 )

Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ IMPPIE   ³ Autor ³ Ariel A. Musumeci   ³ Data ³ 08.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Rutina de Impresi¢n de Pie de Documento.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function ImpPie()

LOCAL cLeyPie1 := " "
LOCAL cLeyPie2 := " "

cLeyPie1 := "DECLARO QUE LOS DATOS CONSIGNADOS EN ESTE FORMULARIO SON CORRECTOS Y COMPLETOS, "
cLeyPie2 := "SIN OMITIR NI FALSEAR DATO ALGUNO QUE DEBA CONTENER, SIENDO FIEL EXPRESION DE LA VERDAD."

//oPrn:Box( 2850, 1620, 3200, 2300 )

oPrn:SayBitmap(2960,1750,cFirmAut ,370,330) // Tiene que estar abajo del RootPath

//oPrn:Say( 3150, 1640, "POR PARTE DE "+SM0->M0_NOMECOM, oFont3, 100 )

oPrn:Say( 3100, 0100, cLeyPie1, oFont6, 100 )
oPrn:Say( 3150, 0100, cLeyPie2, oFont6, 100 )

oPrn:EndPage()

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ALTERMSG ³ Autor ³ Ariel A. Musumeci     ³ Data ³ 18.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Obtenci¢n de mensajes y observaciones para O. Compras.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static FUNCTION AlterMsg()

@ 000, 000 TO 275, 500 DIALOG oDlgMR TITLE "Orden de Compra: " + cNumeCom + " - " + cNombPro
@ 000, 002 TO 120, 248

@ 010, 010 SAY "Domicilio de Entrega: "
@ 020, 010 GET cDomiEnt SIZE 230, 050

@ 035, 010 SAY "Horario de Entrega: "
@ 045, 010 GET cHoraEnt SIZE 230, 050

@ 060, 010 SAY "Observaciones: "
@ 070, 010 GET cObe3Com SIZE 230, 050

@ 123, 180 BMPBUTTON TYPE 1 ACTION /*Close*/ ( nOpca := 1, oDlgMR:End() )//(oDlgMR)-Rip
@ 123, 215 BMPBUTTON TYPE 2 ACTION /*Close*/ ( nOpca := 1, oDlgMR:End() )//(oDlgMR)-Rip
ACTIVATE DIALOG oDlgMR CENTERED

If nOpca != 1
	Return
EndIf


RETURN NIL

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ AGREBLAN ³ Autor ³ Ariel A. Musumeci     ³ Data ³ 18.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Agrega una linea en blanco en el Array de Detalle.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function AgreBlan()

AADD( acTipItm, "D" )
AADD( acCodItm, Space( Len( SC7->C7_PRODUTO ) ) )
AADD( acDetItm, Space( 40 ) )
AADD( anCntItm, 0 )
AADD( acUniItm, Space( Len( SC7->C7_UM ) ) )
AADD( anPreItm, 0 )
AADD( anDesItm, 0 )
AADD( anIvaItm, 0 )
AADD( anTotItm, 0 )
AADD( acPedItm, " " )
AADD( acItPItm, " " )
AADD( alSumItm, .F. )

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NOMECOPI ³ Autor ³ Ariel A. Musumeci     ³ Data ³ 19.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Nombres de las copias.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function NomeCopi()

Do Case
	Case nCopaCom == 1
		cNocoCom := "Proveedor"
	Case nCopaCom == 2
		cNocoCom := "ARCHIVO"
	Case nCopaCom == 3
		cNocoCom := "CONTADURIA"
	Case nCopaCom == 4
		cNocoCom := "COBRANZAS"
	Case nCopaCom == 5
		cNocoCom := "ADM. VENTAS"
	Otherwise
		cNocoCom := "COPIA " + AllTrim( Str( nCopaCom, 3 ) )
EndCase

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NOMEMONE ³ Autor ³ Ariel A. Musumeci     ³ Data ³ 19.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Nombres de las monedas.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function NomeMone()

Do Case
	Case Trim( cMoneCom ) == "00"
		cMonnCom := "PESOS"
		cMonsCom := "$"
	Case Trim( cMoneCom ) == "01"
		cMonnCom := "PESOS"
		cMonsCom := "$"
	Case Trim( cMoneCom ) == "02"
		cMonnCom := "DOLARES"
		cMonsCom := "U$D"
	Case Trim( cMoneCom ) == "03"
		cMonnCom := "EUROS"
		cMonsCom := "E$"
	Case Trim( cMoneCom ) == "04"
		cMonnCom := "REALES"
		cMonsCom := "R$"
EndCase

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ NOMPROV  ³ Autor ³ Ariel A. Musumeci   ³ Data ³ 17.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Devuelve el nombre de la provincia del Proveedor y entrega.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function NomProv(xCodp)

dbSelectArea( "SX5" )
dbSetOrder( 1 )
dbSeek( xFilial("SX5") + "12" + Trim( xCodp ), .F. )

If Found()
	cProv := SX5->X5_DESCRI
EndIf

Return cProv

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CONTIMP  ³ Autor ³ Ariel A. Musumeci     ³ Data ³ 18.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Muestra los comprobantes impresos en este proceso.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static FUNCTION ContImp()

@ 000, 000 TO 300, 500 DIALOG oDlgMues TITLE "Control de Impresi¢n"
@ 000, 002 TO 118, 245
@ 011, 010 SAY "Comprobantes Impresos: Certificados de Retencion"
oLbx := RDListBox( 1.5, 002, 230, 090, aCols, aCab)
@ 123, 210 BMPBUTTON TYPE 1 ACTION Close( oDlgMues)
ACTIVATE DIALOG oDlgMues CENTERED

RETURN


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PIDEFIRM ³ Autor ³ Ariel A. Musumeci     ³ Data ³ 29.11.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pide nombre del firmante.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function PideFirm( cFirmCod )

Local oDlgSign,oGetCodSign,oLblCodigo,oLblNom,oLblCar,oSButOk,oSayNom,oSayCar

dbSelectArea( "SX5"  )
dbSetOrder( 1 )
dbSeek( xFilial( "SX5" ) + "Z0", .F. )

If !Found()
	Return
EndIf

oDlgSign := MSDIALOG():Create()
oDlgSign:cName := "oDlgSign"
oDlgSign:cCaption := "Firmante Autorizado"
oDlgSign:nLeft := 0
oDlgSign:nTop := 0
oDlgSign:nWidth := 352
oDlgSign:nHeight := 173
oDlgSign:lShowHint := .F.
oDlgSign:lCentered := .T.

oGetCodSign := TGET():Create(oDlgSign)
oGetCodSign:cF3 := "Z0"
oGetCodSign:cName := "oGetCodSign"
oGetCodSign:cCaption := "Codigo"
oGetCodSign:nLeft := 77
oGetCodSign:nTop := 16
oGetCodSign:nWidth := 57
oGetCodSign:nHeight := 21
oGetCodSign:lShowHint := .F.
oGetCodSign:lReadOnly := .F.
oGetCodSign:Align := 0
oGetCodSign:cVariable := "cFirmCod"
oGetCodSign:bSetGet := {|u| If(PCount()>0,cFirmCod:=u,cFirmcod) }
oGetCodSign:lVisibleControl := .T.
oGetCodSign:lPassword := .F.
oGetCodSign:lHasButton := .T.
oGetCodSign:bValid := {|| SX5->( dbSeek( xFilial( "SX5" ) + "Z0" + cFirmCod, .F. ) ),oSayNom:cCaption :=Left( SX5->X5_DESCSPA, At( "/",SX5->X5_DESCSPA )-1 ), oSayCar:cCaption := SubStr( SX5->X5_DESCSPA, At( "/", SX5->X5_DESCSPA )+1) , .T. }

oLblCodigo := TSAY():Create(oDlgSign)
oLblCodigo:cName := "oLblCodigo"
oLblCodigo:cCaption := "Codigo:"
oLblCodigo:nLeft := 9
oLblCodigo:nTop := 18
oLblCodigo:nWidth := 65
oLblCodigo:nHeight := 17
oLblCodigo:lShowHint := .F.
oLblCodigo:lReadOnly := .F.
oLblCodigo:Align := 0
oLblCodigo:lVisibleControl := .T.
oLblCodigo:lWordWrap := .F.
oLblCodigo:lTransparent := .T.

oLblNom := TSAY():Create(oDlgSign)
oLblNom:cName := "oLblNom"
oLblNom:cCaption := "Nombre"
oLblNom:nLeft := 10
oLblNom:nTop := 53
oLblNom:nWidth := 65
oLblNom:nHeight := 17
oLblNom:lShowHint := .F.
oLblNom:lReadOnly := .F.
oLblNom:Align := 0
oLblNom:lVisibleControl := .T.
oLblNom:lWordWrap := .F.
oLblNom:lTransparent := .T.

oLblCar := TSAY():Create(oDlgSign)
oLblCar:cName := "oLblCar"
oLblCar:cCaption := "Cargo:"
oLblCar:nLeft := 9
oLblCar:nTop := 91
oLblCar:nWidth := 65
oLblCar:nHeight := 17
oLblCar:lShowHint := .F.
oLblCar:lReadOnly := .F.
oLblCar:Align := 0
oLblCar:lVisibleControl := .T.
oLblCar:lWordWrap := .F.
oLblCar:lTransparent := .T.

oSButOk := SBUTTON():Create(oDlgSign)
oSButOk:cName := "oSButOk"
oSButOk:cCaption := "AceptSign"
oSButOk:cMsg := "Ok"
oSButOk:nLeft := 270
oSButOk:nTop := 116
oSButOk:nWidth := 52
oSButOk:nHeight := 22
oSButOk:lShowHint := .F.
oSButOk:lReadOnly := .F.
oSButOk:Align := 0
oSButOk:lVisibleControl := .T.
oSButOk:nType := 1
oSButOk:bAction := {|| cFirmNom :=SX5->X5_DESCSPA, oDlgSign:End() }

oSayNom := TSAY():Create(oDlgSign)
oSayNom:cName := "oSayNom"
oSayNom:cCaption := "Nombre"
oSayNom:nLeft := 78
oSayNom:nTop := 53
oSayNom:nWidth := 255
oSayNom:nHeight := 17
oSayNom:lShowHint := .F.
oSayNom:lReadOnly := .F.
oSayNom:Align := 0
oSayNom:lVisibleControl := .T.
oSayNom:lWordWrap := .F.
oSayNom:lTransparent := .F.

oSayCar := TSAY():Create(oDlgSign)
oSayCar:cName := "oSayCar"
oSayCar:cCaption := "Cargo"
oSayCar:nLeft := 77
oSayCar:nTop := 90
oSayCar:nWidth := 257
oSayCar:nHeight := 17
oSayCar:lShowHint := .F.
oSayCar:lReadOnly := .F.
oSayCar:Align := 0
oSayCar:lVisibleControl := .T.
oSayCar:lWordWrap := .F.
oSayCar:lTransparent := .F.

oDlgSign:Activate()

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ VLDPERG  ³ Autor ³ Ariel A. Musumeci   ³ Data ³ 05.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Validaci¢n de SX1                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function VldPerg()

LOCAL aVldSX1  := GetArea()
LOCAL aCposSX1 := {}
LOCAL aPergs   := {}
LOCAL cPerg    := PadR("PCRFIN03",10)

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL	",;
"X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1",;
"X1_CNT01","X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02" ,"X1_VAR03",;
"X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03","X1_VAR04","X1_DEF04","X1_DEFSPA4",;
"X1_DEFENG4","X1_CNT04","X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
"X1_F3","X1_GRPSXG"}

aAdd(aPergs,{'Desde Ord.Pago','Desde Ord.Pago','Desde Ord.Pago','mv_ch1','C', 12, 0, 1, 'G', '', 'mv_par01','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
aAdd(aPergs,{'Hasta Ord.Pago','Hasta Ord.Pago','Hasta Ord.Pago','mv_ch2','C', 12, 0, 1, 'G', '', 'mv_par02','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
aAdd(aPergs,{'Copias        ','Copias        ','Copias        ','mv_ch3','N', 03, 0, 1, 'G', '', 'mv_par03','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
aAdd(aPergs,{'Retencion     ','Retencion     ','Retencion     ','mv_ch4','N', 01, 0, 1, 'C', '', 'mv_par04','Todas','Todas','Todas','','','Ganancias','Ganancias','Ganancias','','', 'I.V.A.', 'I.V.A.', 'I.V.A.', '',	'',	'I. Brutos','I. Brutos','I. Brutos','','','SUSS(RG-1784)','SUSS(RG-1784)','SUSS(RG-1784)','','',''})
aAdd(aPergs,{'De Proveedor  ','De Proveedor  ','De Proveedor  ','mv_ch5','C', 06, 0, 1, 'G', '', 'mv_par05','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','SA2',''})
aAdd(aPergs,{'A Proveedor   ','A Proveedor   ','A Proveedor   ','mv_ch6','C', 06, 0, 1, 'G', '', 'mv_par06','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','SA2',''})
aAdd(aPergs,{'Desde         ','Desde         ','Desde         ','mv_ch7','D', 08, 0, 1, 'G', '', 'mv_par07','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
aAdd(aPergs,{'Hasta         ','Hasta         ','Hasta         ','mv_ch8','D', 08, 0, 1, 'G', '', 'mv_par08','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	If !(dbSeek(cPerg+StrZero(nx,2)))
		RecLock("SX1",.T.)
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with StrZero(nx, 2)
		for nj:=1 to Len(aCposSX1)
			FieldPut(FieldPos(ALLTRIM(aCposSX1[nJ])),aPergs[nx][nj])
		next nj
		MsUnlock()
	Else
		IF aPergs[nX,4]=="mv_ch1" .or. 	aPergs[nX,4]=="mv_ch2"
			RecLock("SX1",.F.)
			Replace X1_PERGUNT with aPergs[nX,1]
			Replace X1_PERSPA  with aPergs[nX,1]
			Replace X1_PERENG  with aPergs[nX,1]
			Replace X1_TAMANHO with aPergs[nX,6]
			MsUnlock()
		ENDIF
	Endif
Next

RestArea( aVldSX1 )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AgregaTit ºAutor  ³ Felipe Raposo      º Data ³  28/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Agrega los titulos de la retencion en la matriz.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ McCain.                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AgregaTit(acComp, nBaseCom, nReteCom)
// Declaracion de variable.
Local cComprob  := TMP->(IIf(empty(FE_NFISCAL), FE_ORDPAGO, FE_NFISCAL))
Local cFornece  := TMP->(FE_FORNECE + FE_LOJA)
Local cNota     := TMP->(FE_NFISCAL + FE_SERIE)
Local cOrdPago  := TMP->FE_ORDPAGO
Local cTipo     := TMP->FE_TIPO
Local aArea     := GetArea()
Local aAreaSFE  := TMP->(GetArea())
Local nRecNoSFE := TMP->(RecNo())
Local nVlrBase  := 0
Local aVlrNeg   := {0, 0}
Local cAliasTRB := ""
Local nTamDec   := TamSX3("FE_RETENC")[2]
Local Registro  := 0

If TMP->FE_TIPO $ "B/G"  // B-Ingresos Brutos / G-Ganancias
	// Suma retencion 
	// Monta y ejecuta query.
	cQuery := "select FE_VALBASE as VALBASE, FE_ALIQ as ALIQ, FE_DEDUC as DEDUC, FE_RETENC as RETENC, FE_NROCERT as NROCERT, R_E_C_N_O_ as Registro " + CRLF +;
	"from " + RetSQLName("SFE") + " as SFE " + CRLF +;
	"where SFE.D_E_L_E_T_ = ' ' " + CRLF +;
	"and SFE.FE_FILIAL = '" + xFilial("SFE") + "' " + CRLF +;
	"and SFE.FE_EMISSAO like '" + left(dtos(TMP->FE_EMISSAO), 6) + "%' " + CRLF +;
	"and SFE.FE_CONCEPT = '" + TMP->FE_CONCEPT + "' " + CRLF +;
	"and SFE.FE_ORDPAGO <> '" + TMP->FE_ORDPAGO + "' " + CRLF +;   //cambio rodrigo por <> estaba <
	"and SFE.FE_FORNECE = '" + TMP->FE_FORNECE + "' " + CRLF +;
	"and SFE.FE_LOJA    = '" + TMP->FE_LOJA + "' " + CRLF +;
	"and SFE.FE_TIPO    = '" + TMP->FE_TIPO + "' " // + CRLF +;
	"order by R_E_C_N_O_" // "order by SFE.FE_ORDPAGO Desc"  Saco rodrigo por problemas en ganancias 
	cAliasTRB := GetNextAlias()
	DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAliasTRB, .T., .F.)
	Do While (cAliasTRB)->(!eof() .and. AllTrim(NROCERT) == "NORET")
		If (cAliasTRB)->(round(VALBASE * ALIQ / 100, nTamDec) == round(RETENC, nTamDec))
			aVlrNeg[2] += (cAliasTRB)->VALBASE  // Valor base.
		Else
			aVlrNeg[2] += (cAliasTRB)->(VALBASE - DEDUC)  // Valor base.
		Endif
		(cAliasTRB)->(dbSkip())        

		// en el caso que exista una orden de pago anterior que ya desconto el acumulado, deja en acumulado negativo en 0 "Agrego Rodrigo 29/12/08"
		If (cAliasTRB)->(!eof() .and. AllTrim(NROCERT) <> "NORET")  .and. nRecNoSFE > (cAliasTRB)->Registro
			aVlrNeg[2] := 0
		Endif

	EndDo
	(cAliasTRB)->(dbCloseArea())
	
	// Resta los pagos adelantados de los ingresos brutos.
	If TMP->FE_TIPO == "B"
		SEK->(dbSetOrder(1))  // EK_FILIAL, EK_ORDPAGO, EK_TIPODOC, EK_PREFIXO, EK_NUM, EK_PARCELA, EK_TIPO, EK_SEQ.
		SEK->(dbSeek(xFilial() + cOrdPago, .F.))
		Do While SEK->(!eof() .and. EK_FILIAL + EK_ORDPAGO == xFilial() + cOrdPago)
			If SEK->(EK_TIPODOC == "TB" .and. EK_TIPO == "PA ")
				// Posiciona retencion del PA.
				SFE->(dbSetOrder(2))  // FE_FILIAL, FE_ORDPAGO, FE_TIPO.
				If SFE->(dbSeek(xFilial() + SEK->EK_NUM + cTipo, .F.))
					nPropor := SEK->EK_VALOR / SFE->FE_VALBASE
					aVlrNeg[1] += (nPropor * SFE->FE_RETENC)
					If SFE->(round(FE_VALBASE * FE_ALIQ / 100, nTamDec) == round(FE_RETENC, nTamDec))
						aVlrNeg[2] += (nPropor * SFE->FE_VALBASE)
					Else
						aVlrNeg[2] += (nPropor * SFE->(FE_VALBASE - FE_DEDUC))
					Endif 
					If  aScan(acComp,{|x| AllTrim(x[1])== "PA - " + SFE->FE_ORDPAGO + " Ret. ya aplicada en pago ant."}) == 0  //Agrega Rodrigo
						AADD(acComp, {"PA - " + SFE->FE_ORDPAGO + " Ret. ya aplicada en pago ant.", SFE->FE_ALIQ, Round(aVlrNeg[1] / nPropor, nTamDec), Round(aVlrNeg[2] / nPropor, nTamDec)}) // Cambia Rodrigo estaba AADD(acComp, {"PA - " + SFE->FE_ORDPAGO, SFE->FE_ALIQ, -aVlrNeg[1], -aVlrNeg[2]})
					Endif // Agrego Rodrigo
					//nReteCom -= Round(aVlrNeg[1] / nPropor, nTamDec) // Agrega rodrigo estaba   nReteCom -= aVlrNeg[1]
					//nBaseCom -= Round(aVlrNeg[2] / nPropor, nTamDec) // Agraga Rodrigo estaba    nBaseCom -= aVlrNeg[2]
				Endif
			Endif
			SEK->(dbSkip())
		EndDo
	Endif
	
ElseIf TMP->FE_TIPO $ "S/U/L"  // S.U.S.S. / Limpieza.
	SFE->(dbSetOrder(4))  // FE_FILIAL, FE_FORNECE, FE_LOJA, FE_NFISCAL, FE_SERIE, FE_TIPO.
	SFE->(dbSeek(xFilial() + cFornece + cNota + cTipo, .F.))
	Do While SFE->(!eof() .and. FE_FILIAL + FE_FORNECE + FE_LOJA + FE_NFISCAL + FE_SERIE + FE_TIPO == xFilial() + cFornece + cNota + cTipo)
		If SFE->(nRecNoSFE <> RecNo() .and. AllTrim(FE_NROCERT) == "NORET")
			If SFE->(round(FE_VALBASE * FE_ALIQ / 100, nTamDec) == round(FE_RETENC, nTamDec))
				aVlrNeg[2] += SFE->FE_VALBASE
			Else
				aVlrNeg[2] += SFE->(FE_VALBASE - FE_DEDUC)
			Endif
		Endif
		SFE->(dbSkip())
	EndDo
Endif

// Reposiciona las tablas.
RestArea(aAreaSFE)
RestArea(aArea)

// Agrega la NF tambien.
If TMP->(round(FE_VALBASE * FE_ALIQ / 100, nTamDec) == round(FE_RETENC, nTamDec))
	nVlrBase := TMP->FE_VALBASE
Else
	nVlrBase := TMP->(FE_VALBASE - FE_DEDUC)
Endif

If TMP->FE_TIPO = "S" // Agrego Andres para que tome en cuenta la Alicouta en SUSS
	AADD(acComp, {cComprob, TMP->FE_VALIMP*100/TMP->FE_VALBASE, TMP->FE_RETENC, nVlrBase})	
Else
	AADD(acComp, {cComprob, TMP->FE_ALIQ, TMP->FE_RETENC, nVlrBase}) // Cambio Rodrigo Estaba AADD(acComp, {cComprob, SFE->FE_ALIQ, SFE->FE_RETENC + aVlrNeg[1], nVlrBase + aVlrNeg[2]})
EndIf

nReteCom += (TMP->FE_RETENC) // Cambio Rodrigo estaba nReteCom += (SFE->FE_RETENC + aVlrNeg[1])
nBaseCom += (nVlrBase) // Cambio Rodrigo Estaba nBaseCom += (nVlrBase + aVlrNeg[2])
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcRetIB ºAutor  ³Microsiga           º Data ³  28/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcula retenciones sobre IB (ingresos brutos).            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ McCain.                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CalcRetIB(cAgente,nSigno,nSaldo,cCF,cProv,lPA,nPropImp)

Local nRatValImp, nRateio, nValMerc, cZona, nJ, nPosIb, cEmpAct
Local nPosRet, nRecSM0
Local aZonaIb  := {}
Local nMoeda   := 1
Local aSFEIB   := {}
Local aPerIB     := {}
Local aProvVerif := {}
Local cProvEnt   := ""
Local cChave     := ""
Local nAliq      := 0
Local nVlrTotal  := 0
Local nPos       := 0
Local nI		 := 0
Local lCalcIb	 := .T.
Local nTotRetSFE:=0
Local nTotBasSFE:=0
Local nLimMInRet:=0
Local nImposto:=0
Local nBaseAtual:=0
Local nImpAtual:=0
Local nRetencao:=0
Local lCalImpos:=.F.
Local nTotBase:=0

DEFAULT nSigno	:=	1
DEFAULT nPropImp :=1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Obter Impostos somente qdo a Empresa Usuario for Agente de Reten‡„o.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(GetMV("MV_AGIIBB",,"CF|BA|SF|SE|TU|SA|JU|MI|FO|ME|ER|SJ|LR|CO|CB|CA|NE|LP|TF|CH|RN|CR")) .And. nSigno > 0
	If !lPA
		SA2->( dbSetOrder(1) )
		SA2->( dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) )
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Generar las Retenci¢n de Ingresos Brutos                       ³
	//³ Reter Ingressos Brutos somente se valor total da Orden de Pago ³
	//³ for igual ou maior que $400,00.                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If SA2->(FieldPos("A2_DTICALB")) > 0 .And. SA2->(FieldPos("A2_DTFCALB")) > 0 ;
		.And. !Empty(SA2->A2_DTICALB) .And. !Empty(SA2->A2_DTFCALB)
		If  ( Dtos(dDataBase)>= Dtos(SA2->A2_DTICALB) ) .And. ( Dtos(Ddatabase) <= Dtos(SA2->A2_DTFCALB) )
			lCalcIb:=.F.
		EndIf
	EndIf
	
	If ExistBlock("F0851IMP")
		lCalcIb:=ExecBlock("F0851IMP",.F.,.F.,{"IB"})
	EndIf
	
	If SA2->A2_RETIB=="S" .And. lCalcIb
		If lRetPa .and. lPA
			nPosIb := Ascan(aZonaIb,{|X| X[1]==cCF .And. X[2]==cProv})
			AAdd(aZonaIb,{cProv,cCF,nBaseImp})
		Else
			dbSelectArea("SF1")
			dbSetOrder(1)
			dbSeek(xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
			If Found()
				cChave := SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
				If cPaisLoc<>"ARG"
					nRateio := 1
				else
					nRateio     := SF1->F1_VALMERC / SF1->F1_VALBRUT
				EndIf
				
				nRatValImp  := ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) / Round(xMoeda(SF1->F1_VALBRUT,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) )
				nValMerc    := ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) * nRateio )
				
				
				nMoeda   := Max(nMoeda,SF1->F1_MOEDA)
				
				SD1->(DbSetOrder(1))
				SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
				
				If SD1->(Found())
					Do While xFilial("SD1")==SD1->D1_FILIAL .And. SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == cChave
						If AllTrim(SD1->D1_ESPECIE) <> Alltrim(SF1->F1_ESPECIE)
							SD1->(DbSkip())
							Loop
						Endif
						
						cProvEnt := ""
						If !Empty(SD1->D1_PROVENT)
							cProvEnt := SD1->D1_PROVENT
						ElseIf  !Empty(SF1->F1_PROVENT)
							cProvEnt := SF1->F1_PROVENT
						Else
							SX5->(DbSeek(xFilial()+"74"))
							cSucur := SM0->M0_CODFIL
							While !SX5->(EOF())  .And. SX5->X5_TABELA=="74"
								If SD1->D1_LOCAL  $ SX5->(X5DESCRI())
									cSucur := SUBS(SX5->X5_CHAVE,3,2)
									Exit
								Endif
								SX5->(DbSkip())
							EndDO
							
							nRecSM0 := SM0->(RecNo())
							cEmpAct := SM0->(M0_CODIGO)
							
							SM0->(DbSeek(cEmpAct+cSucur))
							If SM0->(FOUND())
								cProvEnt := SM0->M0_ESTENT
							Else
								MsgStop("No fue encontrada la sucursal en el archivo de empresas de SIGA." + CRLF +;
								"Ser  calculada la retenci¢n de I.B. con la direcci¢n de entrega de la empresa en uso.")
								SM0->(MsGoTo(nRecSM0))
								cProvEnt := SM0->M0_ESTENT
							Endif
						EndIf
						//Verifica se a cidade ou provincia ja possui calculo de IIBB
						//homologado pelo depto. de localizacoes...
						If cProvEnt $ GetMv("MV_AGIIBB") .And. !(cProvEnt$"CF|BA|SJ|TU|SF|SE|SA|JU|MI|FO|ME|ER|SJ|LR|CO|CB|CA|NE|LP|TF|CH|RN|CR")
							If aScan(aProvVerif,cProvEnt) == 0
								MsgInfo("Para la provincia o ciudad de " + cProvEnt +;
								" es necesario que el departamento de ubicaciones de Microsiga " +;
								"desarrolle la rutina de calculo. Por favor entre en contacto, " +;
								"con el administrador del sistema.")
								AAdd(aProvVerif,cProvEnt)
							EndIf
							
							SD1->(DbSkip())
							Loop
						EndIf
						If !(cProvEnt $ GetMv("MV_AGIIBB"))
							SD1->(DbSkip())
							Loop
						EndIf
						
						
						nVlrTotal := (SD1->D1_TOTAL+SD1->D1_BAIVAGA+SD1->D1_BAIVAFR)
						nProp:=(nVlrTotal/SF1->F1_Valmerc)
						nVlrTotal:=nVlrTotal-(SF1->F1_DESCONT*nProp)
						//Verifica as caracteristicas do TES para verificar se houve
						//a incidencia de Percepcao de IIBB...
						aImpInf := TesImpInf(SD1->D1_TES)
						aArea:=GetArea()
						aReaSFF:=SFF->(GetArea())
						SFF->(dbSetOrder(5))
						SFF->(dbSeek(xFilial()+"IBR" +SD1->D1_CF+cProvEnt))
						lCalImpos:=.F.
						nTotBase:=0
						If SFF->(Found())
							lCalImpos:=.F.
							aAreaAtu:=GetArea()
							If SFF->(FieldPos("FF_INCIMP")) > 0
								For nI := 1 To Len(aImpInf)
									If(Trim(aImpInf[nI][01])$ SFF->FF_INCIMP)
										lCalImpos:=.T.
										nTotBase+=SD1->(FieldGet(FieldPos(aImpInf[nI][02])))
									Endif
								Next
							EndIf
							RestArea(aAreaAtu)
						EndIf
						
						RestArea(aArea)
						SFF->(RestArea(aReaSFF))
						
						If !lCalImpos
							For nI:=1 to Len(aImpInf)
								If "IB"$Trim(aImpInf[nI][01]) .And. Trim(aImpInf[nI][01])<>"IBR"
									If !Empty(SD1->(FieldGet(FieldPos(aImpInf[nI][10]))))
										nPos := aScan(aPerIB,{|x| x[1]==cProvent .And.	x[2]==SD1->D1_CF .And. x[3]==aImpInf[nI][01]})
										If (nPos) == 0
											AAdd(aPerIB,{cProvEnt,SD1->D1_CF,aImpInf[nI][01],aImpInf[nI][09]})
										Else
											If aImpInf[nI][09] > aPerIB[nPos][04]
												aPerIB[nPos][04] := aImpInf[nI][09]
											EndIf
										EndIf
									EndIf
								EndIf
								
								//Os impostos devem se somados (ou tirados) do valor de mercadoria, quando
								//o fornecedor nao seja "Responsable Inscripto" e seja feita retencao em CF
								
								If (cProvEnt == "CF" .And. SA2->A2_TIPO <> "I")
									If aImpInf[nI][03] <> "3"
										nVlrTotal += (SD1->(FieldGet(FieldPos(aImpInf[nI][02]))) * Iif(aImpInf[nI][03]=="1",1,-1))
										nProp:=0
										
										
										nVlrTotIt:= (SD1->D1_TOTAL+SD1->D1_BAIVAGA+SD1->D1_BAIVAFR)
										nProp:=nVlrTotIt/SF1->F1_VALBRUT
										nVlrTotal:=nVlrTotal-(SF1->F1_DESCONT*nProp)
										
										
									EndIf
								EndIf
							Next nI
						EndIf
						nPosIb := Ascan(aZonaIb,{|X| X[1]==cProvEnt .And. X[2]=SD1->D1_CF})
						
						If nPosIb == 0
							AAdd(aZonaIb,{cProvEnt,SD1->D1_CF,((nVlrTotal+nTotBase )* nRatValImp)})
						Else
							aZonaIb[nPosIb][3] := aZonaIb[nPosIb][3]+((nVlrTotal+nTotBase )* nRatValImp)
						Endif
						nVlrTotal := 0
						SD1->(DbSkip())
					Enddo
				Else
					nPosIb := Ascan(aZonaIb,{|X| X[1]==cProvEnt .And. X[2]==SD1->D1_CF})
					AAdd(aZonaIb,{cProvEnt,SD1->D1_CF,nValMerc})
				Endif
			Else
				nPosIb := Ascan(aZonaIb,{|X| X[1]==cProvEnt .And. X[2]==SD1->D1_CF})
				AAdd(aZonaIb,{cProvEnt,SD1->D1_CF,nSaldo/1.21})
			Endif
		EndIf
		
		For nJ := 1 To Len(aZonaIb)
			//Converter a base para moeda 1
			aZonaIb[nJ][3] := Round(xMoeda(aZonaIb[nJ][3],nMoeda,1,,5,aTxMoedas[nMoeda][2]),MsDecimais(1))
			
			cZona := ""
			If aZonaIb[nJ][1] == "CF" .And. SA2->A2_TIPO == "I"
				SFF->(dbSetOrder(10))
				SFF->(dbSeek(xFilial()+"IBR"+aZonaIb[nJ][2]+aZonaIb[nJ][1]+SA2->A2_TIPO))
			Else
				SFF->(dbSetOrder(5))
				SFF->(dbSeek(xFilial()+"IBR"+aZonaIb[nJ][2]+aZonaIb[nJ][1]))
			EndIf
			
			If SFF->(Found())
				cZona := SFF->FF_ZONFIS //aZonaIb[nJ][1]
				nAliq := SFF->FF_ALIQ
				nLimMInRet:=SFF->FF_IMPORTE
			Else
				SFF->(dbSetOrder(11))
				If aZonaIb[nJ][1] == "CF" .And. SA2->A2_TIPO == "I"
					If SFF->(dbSeek(xFilial()+"IBR"+aZonaIb[nJ][1]+SA2->A2_TIPO+Replicate("*",TamSX3("FF_CFO_C")[1]) ))
						cZona := aZonaIb[nJ][1]
						nAliq := SFF->FF_ALIQ
						nLimMInRet:=SFF->FF_IMPORTE
					EndIf
				Else
					If SFF->(dbSeek(xFilial()+"IBR"+aZonaIb[nJ][1]+Replicate("*",TamSx3("FF_TIPO")[1])+Replicate("*",TamSX3("FF_CFO_C")[1]) ))
						cZona := aZonaIb[nJ][1]
						nAliq := SFF->FF_ALIQ
						nLimMInRet:=SFF->FF_IMPORTE
					EndIf
				EndIf
			EndIf
			
			If aZonaIb[nJ][1] =="CR"
				SFE->(dbSetOrder(4))
				nTotRetSFE:=0
				nTotBasSFE:=0
				If SFE->(dbSeek(xFilial("SFE")+SF1->F1_FORNECE+SF1->F1_LOJA))
					cChaveSFE := SFE->FE_FILIAL+SFE->FE_FORNECE+SFE->FE_LOJA
					While !SFE->(Eof()) .And. cChaveSFE == xFilial("SFE")+SFE->FE_FORNECE+SFE->FE_LOJA
						If Month(SFE->FE_EMISSAO) != Month(dDataBase) .Or.YEAR(SFE->FE_EMISSAO)!=Year(dDataBase) .Or.;
							!(SFE->FE_TIPO $"B")
							SFE->(dbSkip())
							Loop
						EndIf
						nTotRetSFE += SFE->FE_RETENC
						nTotBasSFE += SFE->FE_VALBASE
						SFE->(dbSkip())
					End
				EndIf
				nBaseAtual:= (nTotBasSFE + (aZonaIb[nJ][3]*nPropImp))*nSigno
			EndIf
			
			If !Empty(cZona)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Validar en el archivos de exepciones fiscales si el Proveedor  ³
				//³ es exento en la zona fiscal actual.                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SFH->(DbSetOrder(1))
				SFH->(DbSeek(xFilial()+SA2->A2_COD+SA2->A2_LOJA+"IBR"+cZona))
				If !SFH->(FOUND()) .Or. (SFH->FH_ISENTO <> "S")
					
					If SFH->(Found())
						//Aplica % de Reducao para Convenio Multilateral...
						If SFH->FH_COEFMUL <> 0
							aZonaIb[nJ][3] := aZonaIb[nJ][3] * (SFH->FH_COEFMUL/100)
						EndIf
						
						//Caso exista aliquota de retencao informada no SFH a mesma prevalece
						//sobre a aliquota informada no SFF...
						If SFH->FH_ALIQ <> 0
							nAliq := SFH->FH_ALIQ
						EndIf
					Endif
					If (SFF->FF_PRALQIB <> 0) .And. (Len(aPerIB) > 0)
						
						If aScan(aPerIB,{|x| X[1]==aZonaIb[nJ][1] .And. X[2]==aZonaIb[nJ][2] .And. x[4]<nAliq}) > 0
							nAliq := nAliq * (SFF->FF_PRALQIB/100)
						EndIf
					EndIf
					
					//nImposto:= aSFEIb[Len(aSFEIb)][5] + (nBaseAtual - nLimMInRet )
					
					nRetencao:=Round((((aZonaIb[nJ][3]*nPropImp)*nSigno)*(nAliq/100)),TamSX3("FE_VALIMP")[2])  //FE_VALIMP
					nImposto := Round((nBaseAtual  * (nAliq/100)) - nTotRetSFE,TamSX3("FE_VALIMP")[2])  //FE_VALIMP
					
					
					Aadd(aSFEIb,Array(12))
					aSFEIb[Len(aSFEIb)][1] := SE2->E2_NUM                   //FE_NFISCAL
					aSFEIb[Len(aSFEIb)][2] := SE2->E2_PREFIXO               //FE_SERIE
					aSFEIb[Len(aSFEIb)][3] := (aZonaIb[nJ][3]*nPropImp)*nSigno        //FE_VALBASE
					aSFEIb[Len(aSFEIb)][4] := nAliq
					If aZonaIb[nJ][1] =="CR"
						aSFEIb[Len(aSFEIb)][5] := Iif(nBaseAtual >= nLimMInRet,nImposto,0)
					Else
						aSFEIb[Len(aSFEIb)][5] := Round((aSFEIb[Len(aSFEIb)][3]*(nAliq/100)),TamSX3("FE_VALIMP")[2])  //FE_VALIMP
					EndIf
					aSFEIb[Len(aSFEIb)][6] := aSFEIb[Len(aSFEIb)][5]        //FE_RETENC
					aSFEIb[Len(aSFEIb)][7] := nSaldo //SE2->E2_VALOR
					aSFEIb[Len(aSFEIb)][8] := SE2->E2_EMISSAO
					aSFEIb[Len(aSFEIb)][9] := cZona
					aSFEIb[Len(aSFEIb)][10]:= SE2->E2_MOEDA
					aSFEIb[Len(aSFEIb)][11]:= SFF->FF_CFO_C   //CFO - Compra
					aSFEIb[Len(aSFEIb)][12]:= SFF->FF_CFO_V   //CFO - Venda
				Endif
			Endif
		Next nJ
	EndIf
EndIf
Return aSFEIB


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcRetIB2ºAutor  ³Microsiga           º Data ³  28/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcula retenciones sobre IB (ingresos brutos).            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ McCain.                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CalcRetIB2(cAgente, nSigno, nSaldo, nPropImp)

// Declaracion de variables
Local nRatValImp, nRateio, nValMerc, cZona, nJ, nPosIb, cEmpAct
Local nPosRet, nRecSM0
Local aZonaIb    := {}
Local aSFEIB     := {}
Local aPerIB     := {}
Local aProvVerif := {}
Local cProvEnt   := ""
Local cChave     := ""
Local nMoeda     := 1
Local nAliq      := 0
Local nVlrTotal  := 0
Local nPos       := 0
Local cCpoCFO    := ""
Local nI		 := 0
Local lCalcIb	 := .T.
Local lCalcImp   := .T.
Local nTotRetSFE := 0
Local nTotBasSFE := 0
Local nLimMInRet := 0
Local nImposto   := 0
Local nBaseAtual := 0
Local nImpAtual  := 0
Local nRetencao  := 0
Local lCalImpos  := .F.
Local nTotBase   := 0
DEFAULT nSigno	 :=	-1
DEFAULT nPropImp := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Obter Impostos somente qdo a Empresa Usuario for Agente de Reten‡„o.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(GetMV("MV_AGIIBB",,"CF|BA|SF|SE|TU|SA|JU|MI|FO|ME|ER|SJ|LR|CO|CB|CA|NE|LP|TF|CH|RN|CR")) //.And. nSigno > 0
	
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Generar las Retenci¢n de Ingresos Brutos                       ³
	//³ Reter Ingressos Brutos somente se valor total da Orden de Pago ³
	//³ for igual ou maior que $400,00.                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If SA2->(FieldPos("A2_DTICALB")) > 0 .And. SA2->(FieldPos("A2_DTFCALB")) > 0 ;
		.And. !Empty(SA2->A2_DTICALB) .And. !Empty(SA2->A2_DTFCALB)
		If  ( Dtos(dDataBase)>= Dtos(SA2->A2_DTICALB) ) .And. ( Dtos(Ddatabase) <= Dtos(SA2->A2_DTFCALB) )
			lCalcIb:=.F.
		EndIf
	EndIf
	
	If ExistBlock("F0851IMP")
		lCalcIb:=ExecBlock("F0851IMP",.F.,.F.,{"IB2"})
	EndIf
	
	
	If SA2->A2_RETIB=="S" .And. lCalcIb
		
		dbSelectArea("SF2")
		dbSetOrder(1)
		dbSeek(xFilial("SF2")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
		If Found()
			cChave := SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
			If cPaisLoc<>"ARG"
				nRateio := 1
			else
				nRateio     := SF2->F2_VALMERC / SF2->F2_VALBRUT
			EndIf
			
			nRatValImp  := ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) / Round(xMoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) )
			nValMerc    := ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) * nRateio )
			nMoeda   := Max(nMoeda,SF2->F2_MOEDA)
			
			SD2->(DbSetOrder(3))
			SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
			If SD2->(Found())
				Do while xFilial("SD2")==SD2->D2_FILIAL .And. SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cChave
					If Alltrim(SD2->D2_ESPECIE) <> Alltrim(SF2->F2_ESPECIE)
						SD2->(DbSkip())
						Loop
					Endif
					
					cProvEnt := ""
					If  !Empty(SD2->D2_PROVENT)
						cProvEnt := SD2->D2_PROVENT
					ElseIf !Empty(SF2->F2_PROVENT)
						cProvEnt := SF2->F2_PROVENT
					Else
						SX5->(DbSeek(xFilial()+"74"))
						cSucur := SM0->M0_CODFIL
						While !SX5->(EOF()) .And. SX5->X5_TABELA=="74"
							If SD2->D2_LOCAL $ SX5->(X5DESCRI())
								cSucur := SUBS(SX5->X5_CHAVE,3,2)
								Exit
							Endif
							SX5->(DbSkip())
						EndDO
						nRecSM0  := SM0->(REcno())
						cEmpAct  := SM0->(M0_CODIGO)
						
						SM0->(DbSeek(cEmpAct+cSucur))
						If SM0->(FOUND())
							cProvEnt := SM0->M0_ESTENT
						Else
							MsgStop("No fue encontrada la sucursal en el archivo de empresas de SIGA." + CRLF +;
							"Ser  calculada la retenci¢n de I.B. con la direcci¢n de entrega de la empresa en uso.")
							SM0->(MsGoTo(nRecSM0))
							cProvEnt := SM0->M0_ESTENT
						Endif
					EndIf
					
					//Verifica se a cidade ou provincia ja possui calculo de IIBB
					//homologado pelo depto. de localizacoes...
					If cProvEnt $ GetMv("MV_AGIIBB") .And. !(cProvEnt$"CF|BA|SF|SE|TU|SA|JU|MI|FO|ME|ER|SJ|LR|CO|CB|CA|NE|LP|TF|CH|RN|CR")
						If aScan(aProvVerif,cProvEnt) == 0
							MsgInfo("Para la provincia o ciudad de " + cProvEnt +;
							" es necesario que el departamento de ubicaciones de " +;
							"Microsiga desarrolle la rutina de calculo. Por favor " +;
							"entre en contacto, con el administrador del sistema.")
							AAdd(aProvVerif, cProvEnt)
						EndIf
						
						SD2->(DbSkip())
						Loop
					EndIf
					
					If !(cProvEnt $ GetMv("MV_AGIIBB"))
						SD2->(DbSkip())
						Loop
					EndIf
					
					nVlrTotal := SD2->D2_TOTAL
					
					//Verifica as caracteristicas do TES para verificar se houve
					//a incidencia de Percepcao de IIBB...
					aImpInf := TesImpInf(SD2->D2_TES)
					aArea:=GetArea()
					aReaSFF:=SFF->(GetArea())
					SFF->(dbSetOrder(5))
					SFF->(dbSeek(xFilial()+"IBR" +SD1->D1_CF+cProvEnt))
					nTotBase:=0
					lCalImpos:=.F.
					If SFF->(Found())
						aAreaAtu:=GetArea()
						If SFF->(FieldPos("FF_INCIMP")) > 0
							For nI := 1 To Len(aImpInf)
								If(Trim(aImpInf[nI][01])$ SFF->FF_INCIMP)
									lCalImpos:=.T.
									nTotBase+=SD1->(FieldGet(FieldPos(aImpInf[nI][02])))
								Endif
								
							Next
						EndIf
						RestArea(aAreaAtu)
					EndIf
					
					RestArea(aArea)
					SFF->(RestArea(aReaSFF))
					
					If !lCalImpos
						
						For nI := 1 To Len(aImpInf)
							If "IB"$Trim(aImpInf[nI][01]) .And. Trim(aImpInf[nI][01])<>"IBR"
								If !Empty(SD2->(FieldGet(FieldPos(aImpInf[nI][10]))))
									nPos := aScan(aPerIB,{|x| x[1]==cProvent .And.	x[2]==SD2->D2_CF .And. x[3]==aImpInf[nI][01]})
									If (nPos) == 0
										AAdd(aPerIB,{cProvEnt,SD2->D2_CF,aImpInf[nI][01],aImpInf[nI][09]})
									Else
										If aImpInf[nI][09] > aPerIB[nPos][04]
											aPerIB[nPos][04] := aImpInf[nI][09]
										EndIf
									EndIf
								EndIf
							EndIf
							
							//Os impostos devem se somados (ou tirados) do valor de mercadoria, quando
							//o fornecedor nao seja "Responsable Inscripto" e seja feita retencao em CF
							If cProvEnt == "CF" .And. SA2->A2_TIPO <> "I"
								If aImpInf[nI][03] <> "3"
									nVlrTotal += (SD2->(FieldGet(FieldPos(aImpInf[nI][02]))) * Iif(aImpInf[nI][03]=="1",1,-1))
								EndIf
							EndIf
						Next
					EndIf
					nPosIb := Ascan(aZonaIb,{|X| X[1]==cProvEnt .And. X[2]=SD2->D2_CF})
					
					If nPosIb == 0
						AAdd(aZonaIb,{cProvEnt,SD2->D2_CF,((nVlrTotal+nTotBase) * nRatValImp),0})
					Else
						aZonaIb[nPosIb][3] := aZonaIb[nPosIb][3]+((nVlrTotal+nTotBase) * nRatValImp)
					Endif
					nVlrTotal := 0
					SD2->(DbSkip())
				Enddo
			Else
				nPosIb := Ascan(aZonaIb,{|X| X[1]==cProvEnt .And. X[2]==SD2->D2_CF})
				AAdd(aZonaIb,{cProvEnt,SD2->D2_CF,nValMerc,0})
			Endif
		ElseIf SE2->E2_TIPO $ MVPAGANT .And. lRetPA .And. Alltrim(SE2->E2_ORIGEM)=="FINA085A"
			nRatPa	:=	(nSaldo/SE2->E2_VALOR)
			//Procurar no SFE qual foi a base utilizada para calculo da retencao
			aArea:=GetArea()
			DbSelectArea("SFE")
			DbSetOrder(2)
			If MsSeek(xFilial("SFE")+ Substr(SE2->E2_NUM,1,Len(SFE->FE_ORDPAGO))+"B")
				AAdd(aZonaIb,{cProvEnt,SD2->D2_CF,SFE->FE_VALBASE*nRatPa,SFE->FE_VALIMP*nRatPa})
			Else
				AAdd(aZonaIb,{cProvEnt,SD2->D2_CF,nSaldo/1.21,0})
			Endif
			RestArea(aArea)
		Else
			nPosIb := Ascan(aZonaIb,{|X| X[1]==cProvEnt .And. X[2]==SD2->D2_CF})
			AAdd(aZonaIb,{cProvEnt,SD2->D2_CF,nSaldo/1.21,0})
		Endif
		For nJ   := 1  To Len(aZonaIb)
			//Converter a base para moeda 1
			aZonaIb[nJ][3] := Round(xMoeda(aZonaIb[nJ][3],nMoeda,1,,5,aTxMoedas[nMoeda][2]),MsDecimais(1))
			
			cZona := ""
			If aZonaIb[nJ][1] == "CF" .And. SA2->A2_TIPO == "I"
				SFF->( Iif(aZonaIb[nJ][2] < "500",dbSetOrder(10),dbSetOrder(12)) )
				SFF->(dbSeek(xFilial()+"IBR"+aZonaIb[nJ][2]+aZonaIb[nJ][1]+SA2->A2_TIPO))
			Else
				SFF->( Iif(aZonaIb[nJ][2] < "500",dbSetOrder(5),dbSetOrder(6)) )
				SFF->(dbSeek(xFilial()+"IBR"+aZonaIb[nJ][2]+aZonaIb[nJ][1]))
			EndIf
			
			If SFF->(Found())
				cZona := SFF->FF_ZONFIS //aZonaIb[nJ][1]
				nAliq := SFF->FF_ALIQ
			Else
				cCpoCFO := Iif(aZonaIb[nJ][2] < "500","FF_CFO_C","FF_CFO_V")
				SFF->( Iif(aZonaIb[nJ][2] < "500",dbSetOrder(11),dbSetOrder(13)) )
				If aZonaIb[nJ][1] == "CF" .And. SA2->A2_TIPO == "I"
					If SFF->(dbSeek(xFilial()+"IBR"+aZonaIb[nJ][1]+SA2->A2_TIPO+Replicate("*",TamSX3(cCpoCFO)[1]) ))
						cZona := aZonaIb[nJ][1]
						nAliq := SFF->FF_ALIQ
					EndIf
				Else
					If SFF->(dbSeek(xFilial()+"IBR"+aZonaIb[nJ][1]+Replicate("*",TamSx3("FF_TIPO")[1])+Replicate("*",TamSX3(cCpoCFO)[1]) ))
						cZona := aZonaIb[nJ][1]
						nAliq := SFF->FF_ALIQ
					EndIf
				EndIf
			EndIf
			
			
			If aZonaIb[nJ][1] =="CR"
				SFE->(dbSetOrder(4))
				nTotRetSFE:=0
				nTotBasSFE:=0
				//If SA2->(FieldPos("A2_CONCSUS")) > 0 .And. SA2->A2_CONCSUS =="1"
				If SFE->(dbSeek(xFilial("SFE")+SF2->F2_CLIENTE+SF2->F2_LOJA))
					cChaveSFE := SFE->FE_FILIAL+SFE->FE_FORNECE+SFE->FE_LOJA
					While !SFE->(Eof()) .And. cChaveSFE == xFilial("SFE")+SFE->FE_FORNECE+SFE->FE_LOJA
						If Month(SFE->FE_EMISSAO) != Month(dDataBase) .Or.YEAR(SFE->FE_EMISSAO)!=Year(dDataBase) .Or.;
							!(SFE->FE_TIPO $"B")
							SFE->(dbSkip())
							Loop
						EndIf
						nTotRetSFE += SFE->FE_RETENC
						nTotBasSFE += SFE->FE_VALBASE
						SFE->(dbSkip())
					End
				EndIf
				nBaseAtual:= (nTotBasSFE + (aZonaIb[nJ][3]*nPropImp))*nSigno
			EndIf
			If !Empty(cZona)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Validar en el archivos de exepciones fiscales si el Proveedor  ³
				//³ es exento en la zona fiscal actual.                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SFH->(DbSetOrder(1))
				SFH->(DbSeek(xFilial()+SA2->A2_COD+SA2->A2_LOJA+"IBR"+cZona))
				If !SFH->(FOUND()) .Or. (SFH->FH_ISENTO <> "S")
					If SFH->(FOUND())
						//Aplica % de Reducao para Convenio Multilateral...
						If SFH->FH_COEFMUL <> 0
							aZonaIb[nJ][3] := aZonaIb[nJ][3] * (SFH->FH_COEFMUL/100)
						EndIf
						
						//Caso exista aliquota de retencao informada no SFH a mesma prevalece
						//sobre a aliquota informada no SFF...
						If SFH->FH_ALIQ <> 0
							nAliq := SFH->FH_ALIQ
						EndIf
					Endif
					
					If (SFF->FF_PRALQIB <> 0) .And.(Len(aPerIB) > 0)
						
						If aScan(aPerIB,{|x| X[1]==aZonaIb[nJ][1] .And. X[2]==aZonaIb[nJ][2] .And. x[4]<nAliq}) > 0
							nAliq := nAliq * (SFF->FF_PRALQIB/100)
						EndIf
					EndIf
					
					nImposto:= Iif(aZonaIb[nJ][4]<>0,Round(aZonaIb[nJ][4]*nPropImp,TamSX3("FE_VALIMP")[2])*nSigno,Round(((nBaseAtual*(nAliq/100))-nTotRetSFE),TamSX3("FE_VALIMP")[2]))  //FE_VALIMP
					Aadd(aSFEIb,Array(12))
					aSFEIb[Len(aSFEIb)][1] := SE2->E2_NUM                   //FE_NFISCAL
					aSFEIb[Len(aSFEIb)][2] := SE2->E2_PREFIXO               //FE_SERIE
					aSFEIb[Len(aSFEIb)][3] := (aZonaIb[nJ][3]* nPropImp)*nSigno        //FE_VALBASE
					aSFEIb[Len(aSFEIb)][4] := nAliq
					If aZonaIb[nJ][1] == "CR"
						aSFEIb[Len(aSFEIb)][5] := Iif(nBaseAtual > nLimMInRet,nImposto,0)
					Else
						aSFEIb[Len(aSFEIb)][5] := Iif(aZonaIb[nJ][4]<>0,Round(aZonaIb[nJ][4]*nPropImp,TamSX3("FE_VALIMP")[2])*nSigno,Round((aSFEIb[Len(aSFEIb)][3]*(nAliq/100)),TamSX3("FE_VALIMP")[2]))  //FE_VALIMP
					EndIf
					aSFEIb[Len(aSFEIb)][6] := aSFEIb[Len(aSFEIb)][5]        //FE_RETENC
					aSFEIb[Len(aSFEIb)][7] := nSaldo//SE2->E2_VALOR
					aSFEIb[Len(aSFEIb)][8] := SE2->E2_EMISSAO
					aSFEIb[Len(aSFEIb)][9] := cZona
					aSFEIb[Len(aSFEIb)][10]:= SE2->E2_MOEDA
					aSFEIb[Len(aSFEIb)][11]:= SFF->FF_CFO_C  //CFO - COMPRA
					aSFEIb[Len(aSFEIb)][12]:= SFF->FF_CFO_V  //CFO - VENDA
				Endif
			Endif
		Next
	EndIf
EndIf

Return aSFEIB