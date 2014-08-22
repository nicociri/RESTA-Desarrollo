#include "rwmake.ch"
#DEFINE DETAILBOTTOM 	3000   
#define CURTEXTLINE     2700
#define TOTLINE         2800
#define TEXTBEGINLINE   2200                                                                                                   
#define CAILINE         2950

/*-------------------------------------------------------------------------------------------------------*/
USER FUNCTION RCobroG()

   PRIVATE lPrinted   := .f.
   PRIVATE nHoja      := 0

	ValidPerg( "RECCOB" )

  if Alltrim(Funname()) == "FINA087A"     
	 MV_PAR01 :=  cRecibo
	 MV_PAR02 :=  cRecibo
	 MV_PAR03 := 3
	 MV_PAR04 := 1
	 MV_PAR05 := 2
	 MV_PAR06 := cSerie
	 RptStatus( { || SelectComp() } )
  Else
  	  IF Pergunte( "RECCOB    ", .t. )
		RptStatus( { || SelectComp() } )     	 	
      ENDIF

  End if

RETURN nil

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION SelectComp()

   PRIVATE nLine    := 0, ;
           aPedBloq := Array( 0 )

   PRIVATE oPrn  := TMSPrinter():New(), ;
           oFont    := TFont():New( "Arial"            ,, 10,, .f.,,,,    , .f. ), ;
           oFont3   := TFont():New( "Arial"            ,, 12,, .t.,,,,    , .f. ), ;
           oFont5   := TFont():New( "Arial"            ,, 10,, .t.,,,,    , .f. ), ;
           oFont8   := TFont():New( "Arial"            ,,  8,, .f.,,,,    , .f. ), ;
           oFont8b  := TFont():New( "Arial"            ,,  8,, .t.,,,, .t., .f. ), ;
           oFont12b := TFont():New( "Times New Roman"  ,, 12,, .t.,,,,    , .f. ), ;
           oFont12  := TFont():New( "Times New Roman"  ,, 12,, .f.,,,,    , .f. ), ;
           oFont14b := TFont():New( "Times New Roman"  ,, 14,, .t.,,,,    , .f. ), ;
           oFont14  := TFont():New( "Times New Roman"  ,, 14,, .f.,,,,    , .f. ), ;
           oFont20  := TFont():New( "Times New Roman"  ,, 20,, .t.,,,,    , .f. ), ;
           oFont18b := TFont():New( "Times New Roman"  ,, 18,, .t.,,,,    , .f. ), ;
           oFont18  := TFont():New( "Times New Roman"  ,, 18,, .f.,,,,    , .f. ), ;
           oFont18i := TFont():New( "Times New Roman"  ,, 18,, .f.,,,, .t., .f. ), ;
           oFont11  := TFont():New( "Times New Roman"  ,, 18,, .t.,,,,    , .t. ), ;
           oFont6   := TFont():New( "HAETTENSCHWEILLER",, 10,, .t.,,,,    , .f. ), ;
           oFont30  := TFont():New( "Bauhaus Lt Bt"    ,, 10,, .t.,,,,    , .f. ), ;
           oFont66  := TFont():New( "Arial"            ,,  6,, .f.,,,,    , .f. ), ;
           oFont31  := TFont():New( "Arial"            ,,  8,, .t.,,,,    , .f. )

   IF mv_par04 == 2
      oPrn:Setup()
   ENDIF

   DbSelectArea( "SA1" )
   DbSetOrder( 1 )
   DbSelectArea( "SE1" )
   DbSetOrder( 2 )
   DbSelectArea( "SYA" )
   DbSetOrder( 1 )
   DbSelectArea( "SEL" )
   DbSetOrder( 1 )
   

   DbSeek( xFilial() + mv_par06 + mv_par01, .t. )
   SetRegua( ( Val( mv_par02 ) - Val( mv_par01 ) ) + 1 )

   DbEval( { || PrintComp(), IncRegua() },, { || EL_FILIAL == xFilial() .AND. EL_RECIBO+EL_SERIE <= mv_par02 + mv_par06 } )

   IF mv_par04 == 1
      oPrn:PreView()
   ELSE
      oPrn:Print()
   ENDIF

   Ms_Flush()

RETURN

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PrintComp()

   PRIVATE cProvincia := Space( 0 ), ;
           cProvCMS   := Space( 0 ), ;
           cSitIVA    := Space( 0 ), ;
           cNroAnt    := Space( 12 ), ;
           aDriver    := ReadDriver(), ;
           nTotVal    := 0, ;
           nLine      := 0, ;
           nImpComp   := 0, ;
           nSalComp   := 0, ;
           nPagoAnt   := 0

   DbSelectArea( "SA1" )
   DbSeek( xFilial( "SA1" ) + SEL->EL_CLIORIG + SEL->EL_LOJA )

   DbSelectArea( "SYA" )
   DbSeek( xFilial( "SYA" ) + SA1->A1_PAIS )

   DbSelectArea( "SEL" )
   
   cProvincia := ""
   cProvCMS   := ""
   cSitIVA    := "" 
   IF !EMPTY( Tabela( "12", SA1->A1_EST )  )
      cProvincia := Tabela( "12", SA1->A1_EST )
   ELSE
      MsgStop( "En el cliente " + SA1->A1_COD + " " + SA1->A1_LOJA +",  se encuentra vacio el campo PROVINCIA", "Verifique" )
   ENDIF
   IF !EMPTY( Tabela( "12", SM0->M0_ESTCOB )  )
      cProvCMS := Tabela( "12", SM0->M0_ESTCOB )
   ELSE
      MsgStop( "En SM0 se encuentra vacio el campo PROVINCIA", "Verifique" )
   ENDIF
   IF !EMPTY( SA1->A1_TIPO )
       //cSitIVA    := Tabela( "SF", SA2->A2_TIPO )
   ELSE // IF SA2->A2_COD <> "000463"
      MsgStop( "En el cliente " + SA1->A1_COD + " " + SA1->A1_LOJA +",  se encuentra vacio el campo TIPO", "Verifique" )
   ENDIF   
   nii:=1
   //do while nii <=MV_PAR05
   nHoja := 1
   PrintHead()
   PrintItem()
   PrintFoot()
   nii:=nii+1 
   //enddo
RETURN nil

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PrintHead()

   IF !lPrinted
      lPrinted := .t.
   ELSE
      oPrn:StartPage()
   ENDIF

   nLine := 50

   oPrn:Say( nLine, 0100, " ", oFont, 100 )

   IF !Empty( GetMV( "MV_DIRLOGO" ) )
      IF File( AllTrim( GetMV( "MV_DIRLOGO" ) ) )
         //oPrn:Box( nLine, 0050, nLine + 470, 2350 )
         nLine += 10
         //oPrn:SayBitmap( nLine, 1900, AllTrim( GetMV( "MV_DIRLOGO" ) ) , 230, 150 )
      ELSE
         nLine += 10
      ENDIF
   //ELSE
      nLine += 120
      //oPrn:Box( nLine, 0050, nLine + 470, 2350 )
      nLine += 10
      oPrn:Say( nLine, 050, "", oFont8, 100 )
      oPrn:Box( nLine, 1100, nLine + 100, 1250 )
      oPrn:Say( nLine +  20, 1160, "X", oFont8, 100 )
      oPrn:Say( nLine +  140, 1050, "Comp.no Valido como Factura", oFont66, 100 )
      //oPrn:Say( nLine +  20, 0100, AllTrim( SM0->M0_NOME ), oFont30, 100 )
   	  oPrn:Say( nLine + 20, 0100, "SUCESORES DE DOMINGO RESTA Y CIA S.A.", oFont30, 100 )
      oPrn:Say( nLine + 060, 0100, "DR. LUIS BELAUSTEGUI 3925", oFont31, 100 )
      oPrn:Say( nLine + 100, 0100, "(C1407EXM) " + cProvCMS + " - Tel.: (54-11) 4568-9150 " , oFont31, 100 )
      oPrn:Say( nLine + 140, 0100, " FAX: (54-11) 4568-9150" , oFont31, 100 )
      oPrn:Say( nLine + 180, 0100, "C.U.I.T. " + AllTrim( SM0->M0_CGC ) + " - Responsable Inscripto" , oFont31, 100 )
   ENDIF
   nLine += 40
 
   oPrn:Say( nLine +10, 1590, Left( ALLTRIM(EL_RECIBO), 4 ) + "-" + Right( ALLTRIM(EL_RECIBO), 8), oFont12b, 100 )
   nLine += 100

   oPrn:Say( nLine, 1650, "COMPROBANTE", oFont8B, 100 )
   oPrn:Say( nLine, 2100, "FECHA", oFont8B, 100 )
   nLine += 30

   oPrn:Box( nLine, 1550, nLine + 100, 1950 )
   oPrn:Box( nLine, 2000, nLine + 100, 2300 )
   nLine += 30
   //oPrn:Say( nLine, 1000,"ORIGINAL", oFont8, 100 )
   oPrn:Say( nLine, 1100,if(MV_PAR05=1,"ORIGINAL",if(MV_PAR05=2,"DUPLICADO","TRIPLICADO")), oFont8, 100 )
   oPrn:Say( nLine, 1590, "RECIBO OFICIAL", oFont30, 100 )
   oPrn:Say( nLine, 2060, DToC( EL_DTDIGIT ), oFont30, 100 )
   nLine += 100

   IF EL_CANCEL
      oPrn:Say( nLine, 1600, "*** A N U L A D O *** ", oFont14b, 100 )
   ENDIF
   nLine += 170

   oPrn:Say( nLine, 0100, "Recibimos de: " + AllTrim( SA1->A1_NOME ) + " (" + AllTrim( SA1->A1_COD ) + ")", oFont, 100 )
   nLine += 50

   oPrn:Say( nLine, 0100, "Domicilio   : " + AllTrim( SA1->A1_END ), oFont, 100 )
   oPrn:Say( nLine, 1600, "Cobrador    : " + AllTrim( SEL->EL_COBRAD ), oFont, 100 )
   nLine += 50

   oPrn:Say( nLine, 0100, "Localidad   : " + Alltrim( SA1->A1_MUN ) + ;
                          If( SA1->A1_TIPO != "E", ;
                              If( !Empty( cProvincia ), " - " + cProvincia, "" ), ;
                              "   Pais: " + AllTrim( SYA->YA_DESCR ) ) + ;
                          "   C. Postal: " + AllTrim( SA1->A1_CEP ), oFont, 100 )
   oPrn:Say( nLine, 1600, "Reccibo Pr.N: " + AllTrim( SEL->EL_RECPROV), oFont, 100 )
   nLine += 50

   oPrn:Say( nLine, 0100, "C.U.I.T.    : " + AllTrim( SA1->A1_CGC ) + " - I.V.A.: " + cSitIVA, oFont, 100 )
   oPrn:Say( nLine, 1100, "Condicion de Pago: " + AllTrim( SE4->E4_DESCRI ),oFont, 100 ) 
                          //If( !Empty( SA1->A1_DTODESC ), " (" + AllTrim( SA1->A1_DTODESC ) + ")", "" ), ;

/*
   IF !Empty( GetMV( "MV_DIRLOGO" ) )
      IF File( AllTrim( GetMV( "MV_DIRLOGO" ) ) )
         nLine += 50
         oPrn:Box( nLine, 1900, nLine + 2, 2300 )
         nLine += 20
      ELSE
         nLine += 70
      ENDIF
   ELSE
      nLine += 50
      oPrn:Box( nLine, 0050, nLine + 2, 2300 )
      nLine += 20
   ENDIF

   IF !Empty( GetMV( "MV_DIRLOGO" ) )
      IF File( AllTrim( GetMV( "MV_DIRLOGO" ) ) )
         nLine += 50
         oPrn:Box( nLine, 1900, nLine + 2, 2300 )
         nLine += 20
      ELSE
         nLine += 70
      ENDIF
   ELSE
      nLine += 50
      oPrn:Box( nLine, 0050, nLine + 2, 2300 )
      nLine += 20
   ENDIF
*/
      nLine += 50
      oPrn:Box( nLine, 0050, nLine + 2, 2300 )
      nLine += 20

   nLine += 70

   oPrn:Box( nLine, 0050, nLine + 50, 1125 )
   oPrn:Box( nLine, 1125, nLine + 50, 2300 )
   nLine += 5

   oPrn:Say( nLine, 0100, "Aplicado al cobro de los comprobantes", oFont5, 100 )
   oPrn:Say( nLine, 1175, "Valores afectados", oFont5, 100 )
   nLine += 50

   oPrn:Box( nLine, 0050, nLine + 50, 0275 )
   oPrn:Box( nLine, 0275, nLine + 50, 0450 )
   oPrn:Box( nLine, 0450, nLine + 50, 0625 )
   oPrn:Box( nLine, 0625, nLine + 50, 0875 )
   oPrn:Box( nLine, 0875, nLine + 50, 1125 )
   oPrn:Box( nLine, 1125, nLine + 50, 1475 )
   oPrn:Box( nLine, 1475, nLine + 50, 1650 )
   oPrn:Box( nLine, 1650, nLine + 50, 1850 )
   oPrn:Box( nLine, 1850, nLine + 50, 2050 )
   oPrn:Box( nLine, 2050, nLine + 50, 2300 )
   nLine += 5

   oPrn:Say( nLine, 0055, "Comprobante", oFont8b, 100 )
   oPrn:Say( nLine, 0280, "Emision", oFont8b, 100 )
   oPrn:Say( nLine, 0455, "Vencto.", oFont8b, 100 )
   oPrn:Say( nLine, 0630, "Importe Orig.", oFont8b, 100 )
   oPrn:Say( nLine, 0880, "Importe Aplic.", oFont8b, 100 )
   oPrn:Say( nLine, 1130, "Tipo /Banco /Suc", oFont8b, 100 )
   oPrn:Say( nLine, 1480, "Vencto.", oFont8b, 100 )
   oPrn:Say( nLine, 1655, "Cta/Estado", oFont8b, 100 )
   oPrn:Say( nLine, 1855, "Cheque", oFont8b, 100 )
   oPrn:Say( nLine, 2055, "Importe", oFont8b, 100 )
   nLine += 100

RETURN NIL

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PrintItem()
   LOCAL cNroRec    := EL_FILIAL + EL_RECIBO, ;
         nRecSEL    := RecNo(), ;
         nLeftPanel := nLine, ;
		 nRigthPanel:= nLine, ;
		 nElem 		:= 0, ;
		 nIdx        := 0, ;
		 nPos        := 0, ;
		 aAux        := Array( 0 ), ;
		 aItemsl     := Array( 0 ), ;
		 aItemsr     := Array( 0 ), ;
		 nIdx        := 0, ;
         nPos        := 0, ;
		 cDespachos  := Space( 0 ), ;
	     aAux        := Array( 0 ), ;
		 cNUMDESP    := Space( 0 ), ;
		 cSerieSB8   := Space( 0 ), ;
		 cAduana     := Space( 0 ), ;
		 xDtValid    := Space( 0 ), ;
		 cStock      := Space( 0 ), ;
		 cOrigem     := Space( 0 ), ;
		 nSubTot     := .f., ;
		 aItems      := Array( 0 ), ;
		 xI          := 0,; 
		 xy          :=0,;
		 cEsserie    := Space( 0 )


 WHILE ( EL_FILIAL + EL_RECIBO ) == cNroRec

      IF Alltrim(EL_TIPODOC) == "TB" 
      
         SE1->( DbSeek( xFilial() + SEL->EL_CLIENTE + SEL->EL_LOJA + SEL->EL_PREFIXO + SEL->EL_NUMERO + ;
                        SEL->EL_PARCELA + SEL->EL_TIPO ) )
		
		AAdd( aItemsl,{ ALLTRIM(EL_NUMERO)+ALLTRIM(EL_TIPO),DToC( EL_EMISSAO ),DToC( EL_DTVCTO ),SE1->E1_VLCRUZ,EL_VLMOED1} )			// 05
		
		If ALLTRIM(EL_TIPO) $ 'NCC|RA '
			nImpComp := nImpComp - SE1->E1_VLCRUZ
			nSalComp := nSalComp - EL_VLMOED1
		else
			nImpComp := nImpComp + SE1->E1_VLCRUZ
			nSalComp := nSalComp + EL_VLMOED1
		EndIf
		
      ENDIF

      DbSkip()

   ENDDO

   DbGoTo( nRecSEL )

   WHILE ( EL_FILIAL + EL_RECIBO ) == cNroRec

      IF Alltrim(EL_TIPODOC) $ "CH-EF-TF-RG-RI-RB-RS-NP-CC-CD"

         cDescBco := ALLTRIM(EL_TIPODOC) +" / "+ ALLTRIM(EL_BCOCHQ) +" / "+ALLTRIM(EL_AGECHQ)
        
         IF Alltrim(EL_TIPODOC) == "CH"

		 			AAdd( aItemsr, ;
					{ cDescBco , ;			// 01 
					DToC( EL_DTVCTO ),;		// 02
					EL_XESTADO, ;			// 03
					EL_NUMERO, ;			// 04
					EL_VLMOED1} )			// 05
					
         elseIF Alltrim(EL_TIPODOC) $ "CC|CD"  /// TARJETA DE CREDITO
            CDESCBCO:=LEFT(POSICIONE('SA1',1,xFilial() + SEL->EL_CLIENTE + SEL->EL_LOJA,'A1_NOME'),20)
					 AAdd( aItemsr, ;
					{ cDescBco , ;			// 01 
					DToC( EL_EMISSAO),;			// 02
					DToC( EL_DTVCTO ), ;	// 03
					EL_NUMERO, ;			// 04
					EL_VLMOED1} )// 05
         ELSEIF Alltrim(EL_TIPODOC) == "NP"
		 		 AAdd( aItemsr, ;
					{ "PAGARE" , ;			// 01 
					DToC(EL_EMISSAO ),;			// 02
					DToC( EL_DTVCTO ), ;	// 03
					EL_NUMERO, ;			// 04
					EL_VLMOED1} )			// 05

         ELSEIF Alltrim(EL_TIPODOC) == "EF"
            If EL_BANCO == "RMU"
				ccampo:="RETENCION MUNICIPAL"
            ElseIf EL_BANCO == "RSU"
				ccampo:="RETENCION PREVISIONAL"
            ElseIf EL_BANCO == "PAT"
				ccampo:="BANCO DE LA PROVINCIA DE BS. AS."
            Else
				ccampo:="E F E C T I V O"
            EndIf
					AAdd( aItemsr, ;
					{ ccampo , ;			// 01 
					DToC(EL_EMISSAO),;			// 02
					EL_CONTA, ;				// 03
					EL_XESTADO, ;			// 04
					EL_VLMOED1} )// 05
			
         ELSEIF Alltrim(EL_TIPODOC) == "TF"
				ccampo:="TRANSFERENCIA DE: " + TransForm( EL_BANCO, PesqPict( "SEL", "EL_BANCO" ) )
				AAdd( aItemsr, ;
					{ ccampo , ;			// 01 
					DToC(EL_EMISSAO),;			// 02
					EL_CONTA, ;				// 03
					EL_XESTADO, ;			// 04
					EL_VLMOED1} )// 05
				
		ELSEIF Alltrim(EL_TIPODOC) == "RI"

		 	ccampo:="RETENCION I.V.A."
				AAdd( aItemsr, ;
					{ ccampo , ;			// 01 
					"",;			// 02
					"", ;				// 03
					"", ;			// 04
					EL_VLMOED1} )// 05
		
         ELSEIF Alltrim(EL_TIPODOC) == "RG"
				 	ccampo:="RETENCION GANANCIAS"
					AAdd( aItemsr, ;
					{ ccampo , ;			// 01 
					"",;			// 02
					"", ;				// 03
					"", ;			// 04
					EL_VLMOED1} )// 05
         ELSEIF Alltrim(EL_TIPODOC) == "RS"
					ccampo:="RETENCION PREVISIONAL"
					AAdd( aItemsr, ;
					{ ccampo , ;			// 01 
					"",;			// 02
					"", ;				// 03
					"", ;			// 04
					EL_VLMOED1} )// 05
        
         ELSE
				ccampo:="RETENCION INGRESOS BRUTOS"
				AAdd( aItemsr, ;
					{ ccampo , ;			// 01 
					"",;			// 02
					"", ;				// 03
					TraeProv(SEL->EL_NUMERO , SEL->EL_RECIBO), ;			// 04
					EL_VLMOED1} )// 05
		
         ENDIF

         nTotVal := nTotVal + EL_VLMOED1

      ELSEIF Alltrim(EL_TIPODOC) == "RA"

         cNroAnt  := EL_NUMERO
         nPagoAnt := EL_VLMOED1

      ENDIF

      DbSkip()

   ENDDO

   DbSkip( -1 )
	
ncantr:=Len( aItemsr )
ncantl:=Len( aItemsl )
If ncantl>ncantr
	nfor:=ncantl
elseif ncantr>ncantl
	nfor:=ncantr
else
	nfor:=ncantl
EndIf                 

For xy:= 1 to Len(aItemsr)
	aSort( aItems,,, { |x,y| x[3] < y[3] } )
next
For xy:= 1 to Len(aItemsl)
	aSort( aItems,,, { |x,y| x[3] < y[3] } )
next

For xI := 1 TO nfor

   If nLeftPanel > ( CURTEXTLINE - 200 )
      oPrn:EndPage()
      lPrinted := .F.
      nHoja++
      PrintHead( )
      nLeftPanel := nLine //+ 1400
      nRigthPanel:= nLine //+ 1400
   EndIf
         If xI<=ncantl
   		 	oPrn:Say( nLeftPanel, 0055, aItemsl[xI][1], oFont8, 100 ) 
         	oPrn:Say( nLeftPanel, 0285, aItemsl[xI][2], oFont8, 100 )
        	oPrn:Say( nLeftPanel, 0455, aItemsl[xI][3], oFont8, 100 )
        	oPrn:Say( nLeftPanel, 0630, TransForm( aItemsl[xI][4], PesqPict( "SE1", "E1_VLCRUZ" ) ), oFont8, 100 )
         	oPrn:Say( nLeftPanel, 0880, TransForm( aItemsl[xI][5], PesqPict( "SE1", "E1_VLCRUZ" ) ), oFont8, 100 )
			nLeftPanel  += 40
		 EndIf
		 If xI<=ncantr
			oPrn:Say( nRigthPanel, 1130, aItemsr[xI][1], oFont8, 100 )    //
			oPrn:Say( nRigthPanel, 1480, aItemsr[xI][2], oFont8, 100 )    //
			oPrn:Say( nRigthPanel, 1655, aItemsr[xI][3], oFont8, 100 )    //
			oPrn:Say( nRigthPanel, 1855, aItemsr[xI][4], oFont8, 100 )    //
			oPrn:Say( nRigthPanel, 2055, TransForm( aItemsr[xI][5], PesqPict( "SE1", "E1_VLCRUZ" ) ), oFont8, 100 )     //
		 	nRigthPanel += 40
		 EndIf   
Next
	If nLeftPanel > ( CURTEXTLINE - 200 )
     
      oPrn:EndPage()
      lPrinted := .F.
      PrintHead( )
      nLeftPanel := nLine + 1400
      nRigthPanel:= nLine + 1400
	EndIf                
		
nLine := DETAILBOTTOM

RETURN NIL
/*
   LOCAL cNroRec    := EL_FILIAL + EL_RECIBO, ;
         nRecSEL    := RecNo(), ;
         nLeftPanel := nLine


   WHILE ( EL_FILIAL + EL_RECIBO ) == cNroRec

      IF Alltrim(EL_TIPODOC) == "TB" 
      
         SE1->( DbSeek( xFilial() + SEL->EL_CLIENTE + SEL->EL_LOJA + SEL->EL_PREFIXO + SEL->EL_NUMERO + ;
                        SEL->EL_PARCELA + SEL->EL_TIPO ) )

	     oPrn:Say( nLeftPanel, 0055, Left( ALLTRIM(EL_NUMERO), 4 ) + "-" + Right( ALLTRIM(EL_NUMERO), 8 ), oFont8, 100 ) 
         oPrn:Say( nLeftPanel, 0285, DToC( EL_EMISSAO ), oFont8, 100 )
         oPrn:Say( nLeftPanel, 0455, DToC( EL_DTVCTO ), oFont8, 100 )
         oPrn:Say( nLeftPanel, 0630, TransForm( SE1->E1_VLCRUZ, PesqPict( "SE1", "E1_VLCRUZ" ) ), oFont8, 100 )
         oPrn:Say( nLeftPanel, 0880, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
         nLeftPanel += 50

         nImpComp := nImpComp + SE1->E1_VLCRUZ
         nSalComp := nSalComp + EL_VLMOED1

      ENDIF

      DbSkip()

   ENDDO

   DbGoTo( nRecSEL )

   WHILE ( EL_FILIAL + EL_RECIBO ) == cNroRec
      //AGREGO MARIANO 18/08 'RS' EN TIPODOC
      IF Alltrim(EL_TIPODOC) $ "CH-EF-TF-RG-RI-RB-RS-NP-CC"

         cDescBco := ALLTRIM(EL_TIPODOC) +" / "+ ALLTRIM(EL_BCOCHQ) +" / "+ALLTRIM(EL_MOEDA)
        
         IF Alltrim(EL_TIPODOC) == "CH"

            oPrn:Say( nLine, 1130, cDescBco, oFont8, 100 )
            oPrn:Say( nLine, 1480, DToC( EL_DTVCTO ), oFont8, 100 )
            oPrn:Say( nLine, 1655, EL_XESTADO, oFont8, 100 )
            oPrn:Say( nLine, 1855, EL_NUMERO, oFont8, 100 )
            oPrn:Say( nLine, 2055, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )

            nLine += 50
         elseIF Alltrim(EL_TIPODOC) == "CC"  /// TARJETA DE CREDITO
            CDESCBCO:=LEFT(POSICIONE('SA1',1,xFilial() + SEL->EL_CLIENTE + SEL->EL_LOJA,'A1_NOME'),20)
            oPrn:Say( nLine, 1130, cDescBco, oFont8, 100 )
            oPrn:Say( nLine, 1480, DToC( EL_DTVCTO ), oFont8, 100 )
            oPrn:Say( nLine, 1855, EL_NUMERO, oFont8, 100 )
            oPrn:Say( nLine, 2055, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
            nLine += 50
         ELSEIF Alltrim(EL_TIPODOC) == "NP"
            oPrn:Say( nLine, 1130, "PAGARE", oFont8, 100 )
            oPrn:Say( nLine, 1480, DToC( EL_DTVCTO ), oFont8, 100 )
            oPrn:Say( nLine, 1855, EL_NUMERO, oFont8, 100 )
            oPrn:Say( nLine, 2055, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
            nLine += 50

         ELSEIF Alltrim(EL_TIPODOC) == "EF"
            If EL_BANCO == "RMU"
               oPrn:Say( nLine, 1130, "RETENCION MUNICIPAL", oFont8, 100 )
            ElseIf EL_BANCO == "RSU"
               oPrn:Say( nLine, 1130, "RETENCION PREVISIONAL", oFont8, 100 )
            ElseIf EL_BANCO == "PAT"
               oPrn:Say( nLine, 1130, "BANCO DE LA PROVINCIA DE BS. AS.", oFont8, 100 )
            Else
               oPrn:Say( nLine, 1130, "E F E C T I V O", oFont8, 100 )
            EndIf
            oPrn:Say( nLine, 1655, EL_CONTA, oFont8, 100 )
            oPrn:Say( nLine, 2055, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
            nLine += 50

         ELSEIF Alltrim(EL_TIPODOC) == "TF"

            oPrn:Say( nLine, 1130, "TRANSFERENCIA DE: " + TransForm( EL_BANCO, PesqPict( "SEL", "EL_BANCO" ) ), oFont8, 100 )
            oPrn:Say( nLine, 1655, EL_CONTA, oFont8, 100 )
            oPrn:Say( nLine, 2055, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
            nLine += 50

         ELSEIF Alltrim(EL_TIPODOC) == "RI"

            oPrn:Say( nLine, 1130, "RETENCION I.V.A.", oFont8, 100 )
            oPrn:Say( nLine, 2055, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
            nLine += 50

         ELSEIF Alltrim(EL_TIPODOC) == "RG"

            oPrn:Say( nLine, 1130, "RETENCION GANANCIAS", oFont8, 100 )
            oPrn:Say( nLine, 2055, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
            nLine += 50
         //AGREGO MARIANO 18/08 RETENCION PREVISIONAL
         ELSEIF Alltrim(EL_TIPODOC) == "RS"

            oPrn:Say( nLine, 1130, "RETENCION PREVISIONAL", oFont8, 100 )
            oPrn:Say( nLine, 2055, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
            nLine += 50


         ELSE

            oPrn:Say( nLine, 1130, "RETENCION INGRESOS BRUTOS", oFont8, 100 )
            oPrn:Say( nLine, 2055, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
            nLine += 50

         ENDIF

         nTotVal := nTotVal + EL_VLMOED1

      ELSEIF Alltrim(EL_TIPODOC) == "RA"

         cNroAnt  := EL_NUMERO
         nPagoAnt := EL_VLMOED1

      ENDIF

      DbSkip()

   ENDDO

   DbSkip( -1 )

   nLine := DETAILBOTTOM
*/

RETURN NIL

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PrintFoot()

   oPrn:Box( nLine, 0050, nLine + 100, 1125 )
   oPrn:Box( nLine, 1125, nLine + 100, 2300 )
   nLine += 30

   oPrn:Say( nLine, 0100, "TOTAL COMPROBANTES APLICADOS", oFont8b, 100 )
   oPrn:Say( nLine, 0880, TransForm( nSalComp, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
   oPrn:Say( nLine, 1175, "TOTAL VALORES AFECTADOS", oFont8b, 100 )
   oPrn:Say( nLine, 2055, TransForm( nTotVal, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
   nLine += 50

   oPrn:Box( nLine, 0050, nLine + 100, 1125 )
   oPrn:Box( nLine, 1125, nLine + 100, 2300 )
   nLine += 30

   If nPagoAnt == 0
      oPrn:Say( nLine, 0100, "COBRO ANTICIPADO" , oFont8b, 100 )
   Else
      oPrn:Say( nLine, 0100, "COBRO ANTICIPADO NUMERO: " + cNroAnt , oFont8b, 100 )
   EndIf
   oPrn:Say( nLine, 0880, TransForm( nPagoAnt, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
   oPrn:Say( nLine, 1175, "TOTAL RECIBO", oFont5, 100 )
   oPrn:Say( nLine, 1980, TransForm( nTotVal, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont5, 100 )
   //nLine += 100
   nLine += 80                            
   cTCAMBIO:="Tipo de Cambio - Dolar: "+transf(SEL->EL_TXMOE02,"999.9999")+" / Euro: "+transf(SEL->EL_TXMOE03,"999.9999")+" / Real: "+transf(SEL->EL_TXMOE04,"999.9999")+" / P.CH.: "+transf(SEL->EL_TXMOE05,"999.9999")
   oPrn:Say( nLine, 0100, cTCAMBIO , oFont8, 100 )
   nLine += 50
   oPrn:Say( nLine, 0100, "El presente no aplica pago total,novacion o espera de ninguna indole", oFont8, 100 )
   //nLine += 30
   oPrn:Say( nLine, 1750, "SUCESORES DE DOMINGO RESTA Y CIA S.A.", oFont8, 100 )
   nLine += 30
   oPrn:Say( nLine, 1600, "-----------------------------------------------------------------------------------", oFont8, 100 )

   //oPrn:Say( nLine, 0050, "microsiga software de argentina" , oFont8b, 100 )
   //oPrn:Say( nLine, 1950, "Control: 0001-00" + StrZero( Val( EL_RECIBO ), 6 ), ;
   //          oFont8b, 100 )
   oPrn:EndPage()

RETURN NIL

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION ValidPerg( cPerg )

   LOCAL cAlias := Alias(), ;
         aRegs  := {}, ;
         i, ;
         j

   DbSelectArea( "SX1" )
   DbSetOrder( 1 )

   cPerg := PadR( cPerg, 10 )

   AAdd( aRegs, { cPerg, "01", "Desde Recibo    ", "Desde Recibo    ", "Desde Recibo    ", "mv_ch1", "C", 12, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "", "", "", ""  ,"","" } )
   AAdd( aRegs, { cPerg, "02", "Hasta Recibo    ", "Desde Recibo    ", "Desde Recibo    ", "mv_ch2", "C", 12, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "", "", "", ""  ,"","" } )
   AAdd( aRegs, { cPerg, "03", "Imprimir        ", "Imprimir        ", "Imprimir        ", "mv_ch3", "N", 01, 0, 0, "C", "", "mv_par03", "Activas", "Activas", "Activas", "", "","Anuladas","Anuladas","Anuladas", "", "", "Ambas", "Ambas", "Ambas", "", "", "", "", "", "", "", "", "", "", "", ""  ,"","" } )
   AAdd( aRegs, { cPerg, "04", "Visualiza       ", "Visualiza       ", "Visualiza       ", "mv_ch4", "N", 02, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
   AAdd( aRegs, { cPerg, "05", "Copias          ", "Copias          ", "Copias          ", "mv_ch5", "N", 02, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } ) 
   AAdd( aRegs, { cPerg, "06", "Serie           ", "Serie           ", "Serie           ", "mv_ch6", "C", 03, 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "","", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )

   FOR i := 1 TO Len( aRegs )

      IF !DbSeek( cPerg + aRegs[i,2] )

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

Static Function TraeProv(_cNumero,_cRecibo)
Local _aArea := GetArea()
Local _cProv	:= ""
Local _cAlias := "QRYUM"
Local _cQuery	:= ""


_cQuery	:= "SELECT FE_EST FROM "+RetSqlname("SFE")+ "WHERE FE_RECIBO ='"+_cRecibo +"' AND D_E_L_E_T_ ='' AND FE_NROCERT ='"+_CnUMERO+"'"
_cQuery	:= ChangeQuery(_cQuery)
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,_cQuery), _calias, .F., .T.)
		
		
While !(_cAlias)->(EOF())
	_cProv	:= (_cAlias)->FE_EST
	(_cAlias)->(Dbskip())
EndDo
(_cAlias)->(dbclosearea())

RestArea(_aArea)

Return _cProv