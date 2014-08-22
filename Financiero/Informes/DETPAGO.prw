#define DMPAPER_LETTER      1           /* Letter 8 1/2 x 11 in               */
#define DMPAPER_A4          9           /* A4 210 x 297 mm                    */
#include "protheus.ch"                                                                                                          
#include "totvs.ch"
#include "RWMAKE.ch"
#define nTop            50
#define nLef            0                                                                                                      
#define DETAILBOTTOM    2350                                                                                                                        
#define CURTEXTLINE     2700

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DETPAGO   ºAutor  ³Fernando Cardeza    ºFecha ³  08/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Detalle de pagos  -OP-Borderos-Transferencias-Pagos BCO   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function DETPAGO()
LOCAL aArea			:= GetArea()
SetPrvt("_CPERG,NLINE,NLINE1,NLINE2,CORDPAGO,DFECHA,CCODPROV,nhoja")
SetPrvt("cTIPO1,cMovBan,nmovban,cEncab,cQuery,sumador,NTOTAL,nTOTAL1,nTOTAL2,nTOTAL3,nTOTAL4,nTOTFINAL")
SetPrvt("dFecha1,cCodProv,cModelo,cNome,cDescri,cNomProv,cTIPODOC,cCUIT,cNUMERO,nIMPORTE,cTipo") 
SetPrvt("cPago,dFecha,cORDPAGO,ctipocomp,cSerie,cNroComp,cCodProv,cNomProv,cCuenta,cDesccta,cDescMov,nImp1")
SetPrvt("cDetalle,cCert,cbanco,cNomBan,CCTACTBLE,cDESCTACTE,dFECHAVENC,cCuit,nImp2,CDESCOPP,CDESCOPR,cCodProvOP")
SetPrvt("CDESCMBP,CDESCMBR,CDESCMBCAB,CCTACTBLE,CDESCTBP,CDESCTBR,CDESCTBCAB,CDESCOBP,CDESCOBR,CDESCOBCAB")
Private lNaturez := .F.
Private oExcel
Private cArq
Private nArq
Private cPath    
Private	cFile
Private aExclui
Private cVerb
Private cText
Private cDirDocs            
Private aHeader		:= {}
Private aColsLn		:= {}
Private aCols		:= {}
PRIVATE cProvincia := Space( 0 ), ;
nhoja:=0, ;
nCont:=0, ;
cc1:=050, ;
cc2:=850, ;
cc3:=1850, ;
cc4:=2150, ;
cc5:=2550, ;
cc6:=050, ;
cc7:=1150, ;
cc8:=1550, ;
cc9:=2550, ;
comienzo:=400,;
sumador	  := 25,;
nLine     := 0, ; 
nLine1    := 0, ;
nLine2    := 0, ;
lPrinted  := .F.

_cPerg     := "DETPAGO   "

   VldPerg( _cPerg )
   
   If Pergunte( _cPerg, .T. )
   	If MV_PAR06==1
   		Processa({|| fAcols()},"Espere, Calculando matriz de datos... Puede demorar") 

		If !ApOleClient("MSExcel")
			cText:="Microsoft Excel no esta instalado!" + Chr(13) + Chr(10) 
			cText+="Verifique en el proximo aviso donde" + Chr(13) + Chr(10) 
			cText+="sera guardado el archivo .csv"
   			MsgAlert(cText)                                                        
			DlgToExcel({ {"GETDADOS","DETALLE DE PAGOS ",aHeader,aCols}})   			
		Else
			DlgToExcel({ {"GETDADOS","DETALLE DE PAGOS ",aHeader,aCols}})
		EndIf

	  Else
      	RptStatus( { || SelectComp() } )
      EndIf
   EndIf

RETURN

Static FUNCTION SelectComp()
Local   nCopies  := 0       
Private nLine    := 0,;
        cDocum   := Space( 0 ),;
        oPrn     := TMSPrinter():New(),;
        oFontL   := TFont():New( "Courier New"      ,, 12,, .T.,,,,, .f. ),;
        oFont    := TFont():New( "Courier New"      ,, 10,, .f.,,,,, .f. ),;
        oFont1   := TFont():New( "Courier New"      ,, 14,, .f.,,,,, .f. ),;
        oFont2   := TFont():New( "Arial"		    ,, 22,, .t.,,,,, .f. ),;
        oFont3   := TFont():New( "Courier New"      ,, 08,, .f.,,,,, .f. ),;
		oFont4   := TFont():New( "Courier New"      ,, 14,, .t.,,,,, .f. ),;
		oFont5   := TFont():New( "Courier New"      ,, 8,, .f.,,,,,  .f. ),;
		oFontTit := TFont():New( "Arial"			,, 14,,	.F.,,,,,,.f. ),;
		oFont6	 := TFont():New( "Courier New"		,, 08,, .t.,,,,,,.f. ),;
		oFont7	 := TFont():New( "Arial"			,, 07,, .f.,,,,,,.f. ),;
		oFontN   := TFont():New( "Courier New"      ,, 10,, .T.,,,,, .f. ),;
		oFontF   := TFont():New( "Courier New"      ,, 08,, .T.,,,,, .f. ),;
        oFontB   := TFont():New( "Courier New"      ,, 12,, .t.,,,,, .f. )
                              
oPrn:SetLandScape(.F.)                             
oPrn:Setup()                  
oPrn:SetPaperSize(DMPAPER_A4) 
PrintComp()
oPrn:PreView()

RETURN NIL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Determina los límites de impresión                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static FUNCTION PrintComp()
   nline		:= comienzo
   nLine1   	:= nLine 
   nLine2   	:= nLine
   cOrdPagoANT	:= Space( 0 )
   cMoeda   	:= ""
   cNumDoc  	:= ""
   nTOTAL   	:= 0
   nTOTFINAL	:= 0                                                                                                                                                                                             
   cQuery   	:= ""

PrintHead()
   
cQuery := "exec [DETPAGO_01] '"+SubStr((DTOC(MV_PAR01)),7,4)+SubStr((DTOC(MV_PAR01)),4,2)+SubStr((DTOC(MV_PAR01)),1,2)+"','"+SubStr((DTOC(MV_PAR02)),7,4)+SubStr((DTOC(MV_PAR02)),4,2)+SubStr((DTOC(MV_PAR02)),1,2)+"','"+MV_PAR03+"'"+",'"+MV_PAR04+"',"+STR(MV_PAR05)
cQuery := PLSAvaSQL(cQuery)
If Select("TODO01") <> 0
	DBSelectArea("TODO01")
    TODO01->(DBCloseArea())
EndIf
PLSQuery(cQuery,"TODO01")
TODO01->(DBGoTop())

While TODO01->(!Eof())                 
      cPAGO		:=ALLTRIM(TODO01->PAGO)
  	  cTIPO		:=ALLTRIM(TODO01->TIPO)
  	  dFecha    :=TODO01->FECHA
  	  cORDPAGO	:=ALLTRIM(TODO01->NRO_OP)
  	  ctipocomp	:=ALLTRIM(TODO01->TIPO_COMP)
  	  cSerie	:=ALLTRIM(TODO01->SERIE)
  	  cNroComp	:=ALLTRIM(TODO01->NRO_COMP)
  	  cCodProv	:=ALLTRIM(TODO01->COD_PROVEEDOR_BANCO)
  	  cNomProv  :=ALLTRIM(TODO01->NOM_PROVEEDOR_BANCO)
  	  cCuenta	:=ALLTRIM(TODO01->CUENTA)
  	  cDesccta	:=ALLTRIM(TODO01->DESC_CUENTA)
  	  cDescMov	:=ALLTRIM(TODO01->DESC_MOV)
  	  nImp1		:=TODO01->IMPORTE1
  	  cDetalle	:=ALLTRIM(TODO01->DETALLE)
  	  cCert		:=ALLTRIM(TODO01->NRO_CH_CERT)
  	  cbanco	:=ALLTRIM(TODO01->BANCO)
  	  cNomBan	:=ALLTRIM(TODO01->NOM_BANCO)
  	  CCTACTBLE	:=ALLTRIM(TODO01->CTA_CONTABLE)
  	  cDESCTACTE:=ALLTRIM(TODO01->DESC_CTA_CTBLE)
  	  dFECHAVENC:=TODO01->FECHA_VENC
  	  cCuit		:=ALLTRIM(TODO01->CUIT)
  	  nImp2		:=TODO01->IMPORTE2          
  	  CDESCOPP  :=ctipocomp+'-'+cSerie+'-'+SubStr(cNroComp,1,4)+'-'+SubStr(cNroComp,5,8)
  	  IF	 cDetalle $ 'EFECTIVO' 		
  	  	CDESCOPR	:= cDetalle+'-'+cbanco
  	  ELSEIF cDetalle=='CH.TERCEROS'
  	  	CDESCOPR	:= 'Ch.3ros Nº'+cCert+' ('+cbanco+')-CUIT:'+cCuit
  	  ELSEIF cDetalle $ 'CH.PROPIOS/PAGARE'
  	  	CDESCOPR	:= cDetalle+'-'+cCert+'-'+cbanco
  	  ELSEIF cDetalle $ 'TRANSFERENCIAS'
  	  	CDESCOPR	:= cDetalle+'-'+cCert+'-'+cbanco
  	  ELSE
  	  	CDESCOPR	:= cDetalle+'-'+cCert
      ENDIF                                                    
      cCodProvOP:=SubStr(cNomProv,1,80)+"("+cCodProv+")"
      CDESCMBCAB	:= cDetalle+':'+cDescMov
  	  CDESCMBP		:= cCuenta+'('+cDesccta+')-'+cDescMov
  	  CDESCMBR		:= cbanco+'('+cNomBan+')-'+CCTACTBLE
  	  CDESCTBCAB	:= cDetalle+':'+cNroComp
  	  CDESCTBP		:= cCodProv+'('+cNomProv+')-'+cCuenta
  	  CDESCTBR		:= cbanco+'('+cNomBan+')-'+CCTACTBLE	    
  	  CDESCOBCAB	:= 'BORDERO:'+cORDPAGO
  	  CDESCOBP		:= cCodProv+'('+cNomProv+')-'+cCuenta
  	  CDESCOBR		:= 'Ch.3ros Nº'+cCert+' ('+cbanco+')-CUIT:'+cCuit
  	  	    
   IF cTIPO=="OP" 
      IF (cORDPAGOANT <> cORDPAGO)
            cEncab	:='1'
      			If nLine1>=nLine2
					oPrn:Say( nLine1, 050,Replicate( '-', 220 ), oFont3, 100 )
					nLine := nLine1 + sumador
					cQuery := "select SUM(EK_VALOR) VALOR from SEK010 where D_E_L_E_T_='' and EK_ORDPAGO='"+cORDPAGO+"' and EK_TIPODOC<>'TB' "
					cQuery := PLSAvaSQL(cQuery)
					If Select("TODO02") <> 0
						DBSelectArea("TODO02")
    					TODO02->(DBCloseArea())
					EndIf
					PLSQuery(cQuery,"TODO02")
					TODO02->(DBGoTop())
					nTOTAL  :=TODO02->VALOR
					If Select("TODO02") <> 0
						DBSelectArea("TODO02")
    					TODO02->(DBCloseArea())
					EndIf                     
					DBSelectArea("TODO01")
				ElseIf nLine2>nLine1    
					oPrn:Say( nLine2, 050,Replicate( '-', 220 ), oFont3, 100 )
					nLine := nLine2 + sumador
					cQuery := "select SUM(EK_VALOR) VALOR from SEK010 where D_E_L_E_T_='' and EK_ORDPAGO='"+cORDPAGO+"' and EK_TIPODOC<>'TB' "
					cQuery := PLSAvaSQL(cQuery)
					If Select("TODO02") <> 0
						DBSelectArea("TODO02")
    					TODO02->(DBCloseArea())
					EndIf
					PLSQuery(cQuery,"TODO02")
					TODO02->(DBGoTop())
					nTOTAL  :=TODO02->VALOR
					If Select("TODO02") <> 0
						DBSelectArea("TODO02")
    					TODO02->(DBCloseArea())
					EndIf                     
					DBSelectArea("TODO01")
				EndIf            
			nTOTFINAL+=nTOTAL
      	ELSE
      		cEncab	:='2'
      	ENDIF

   ElseIf cTIPO $"TB/BO/MB"
    	IF cPago == "P"
    		If nLine1>=nLine2
				oPrn:Say( nLine1, 050,Replicate( '-', 220 ), oFont3, 100 )
				nLine    := nLine1 + sumador
    			cEncab	 :='1'
       			nTOTAL   := nImp1+nImp2
       		Else
       			oPrn:Say( nLine2, 050,Replicate( '-', 220 ), oFont3, 100 )
				nLine    := nLine2 + sumador
    			cEncab	 :='1'
       			nTOTAL   := nImp1+nImp2 
	        EndIF                      
	        	nTOTFINAL+=nTOTAL
	    ELSE
	    		cEncab	:='2'
       	ENDIF
   EndIf              
      
     cORDPAGOANT	:=ALLTRIM(TODO01->NRO_OP)
      
      PrintItem()
      DbSkip()
      
ENDDO

		PrintTotal()

RETURN NIL

Static FUNCTION PrintHead()
nhoja++   
oPrn:StartPage()


oPrn:Say( nTop+0100, nLef+100,  'SUCESORES DE DOMINGO RESTA Y CIA S.A.'	    , oFontL, 200 )
oPrn:Say( nTop+0150, nLef+100,  'DR. LUIS BELAUSTEGUI 3925'			        , oFont, 100 )
oPrn:Say( nTop+0200, nLef+100,  'C.P.: (1407) C.A.B.A.'	           			, oFont, 100 )
oPrn:Say( nTop+0250, nLef+100,  'Tel.: (5411) 4568-9150'			       	, oFont, 100 )
oPrn:Say( nTop+0100, nLef+1250, 'Pagina Nº : '+STR(nhoja)					, oFontN, 100 )
oPrn:Say( nTop+0150, nLef+1250, 'Desde: '+DtoC(MV_PAR01)     				, oFontN, 100 )
oPrn:Say( nTop+0150, nLef+1800, 'Hasta: '+DtoC(MV_PAR02)					, oFontN, 100 ) 

nLine := comienzo

RETURN NIL

Static FUNCTION PrintItem()  
LOCAL ntipoc        := 1
LOCAL cMoneda 	  := "$"

If nLine > CURTEXTLINE
      oPrn:EndPage()
      lPrinted := .F.
      PrintHead()
      nLine := comienzo
EndIf   

If cTIPO=='OP' 
   If cEncab=='1'
      oPrn:Say( nLine, nLef+cc1, "Orden de pago: "+cOrdPago, oFont3, 100 )                 
      oPrn:Say( nLine, nLef+cc2, "Proveedor: "+ cCodProvOP, oFont3, 100 )                
      oPrn:Say( nLine, nLef+cc3, "Total: ", oFont3, 100 )                
      oPrn:Say( nLine, nLef+cc4, cMoneda +" "+AllTrim( TransForm( nTOTAL, PesqPict( "SEK", "EK_VALOR" ) ) )   , oFont3, 100 )                
      oPrn:Say( nLine, nLef+cc5, "Fecha: " + dfecha, oFont3, 100 )                
      nLine1 := nLine + sumador 
      nLine2 := nLine + sumador
      IF cPago=='P'
      	oPrn:Say( nLine1, nLef+cc6, CDESCOPP, oFont3, 100 ) 
      	oPrn:Say( nLine1, nLef+cc7, cMoneda +" "+AllTrim( TransForm( nImp1, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont3, 100 )               
      	nLine1 := nLine1+sumador
	  ELSE 
	  	oPrn:Say( nLine2, nLef+cc8, CDESCOPR, oFont3, 100 )
	  	oPrn:Say( nLine2, nLef+cc9, cMoneda +" "+AllTrim( TransForm( nImp2, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont3, 100 )
	  	nLine2 := nLine2+sumador
      EndIf
   Else                        
      IF cPago=='P' 
      	oPrn:Say( nLine1, nLef+cc6, CDESCOPP, oFont3, 100 ) 
      	oPrn:Say( nLine1, nLef+cc7, cMoneda +" "+AllTrim( TransForm( nImp1, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont3, 100 )               
      	nLine1 := nLine1+sumador
	  ELSE
	  	oPrn:Say( nLine2, nLef+cc8, CDESCOPR, oFont3, 100 )
	  	oPrn:Say( nLine2, nLef+cc9, cMoneda +" "+AllTrim( TransForm( nImp2, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont3, 100 )
	  	nLine2 := nLine2+sumador
      EndIf
   EndIf	
ElseIf cTIPO=='TB'
   	If cEncab=='1'        
      oPrn:Say( nLine, nLef+cc1, CDESCTBCAB	, oFont3, 100 )                 
      oPrn:Say( nLine, nLef+cc3, "Total: "	, oFont3, 100 )                
      oPrn:Say( nLine, nLef+cc4, cMoneda +" "+AllTrim( TransForm( nTOTAL, PesqPict( "SEK", "EK_VALOR" ) ) )  , oFont3, 100 )                
      oPrn:Say( nLine, nLef+cc5, "Fecha: " + dfecha, oFont3, 100 )                
      nLine1 := nLine + sumador 
      nLine2 := nLine + sumador       
      	If cPago == "R"   
			oPrn:Say( nLine1, nLef+cc6, CDESCTBP, oFont3, 100 ) 
      		oPrn:Say( nLine1, nLef+cc7, cMoneda +" "+AllTrim( TransForm( nImp1, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont3, 100 )               
      		nLine1 := nLine1+sumador
	  	ELSE
	  		oPrn:Say( nLine2, nLef+cc8, CDESCTBR, oFont3, 100 )
	  		oPrn:Say( nLine2, nLef+cc9, cMoneda +" "+AllTrim( TransForm( nImp2, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont3, 100 )
	  		nLine2 := nLine2+sumador
		EndIf
  	Else
		cMoneda := "$"
		If cPago == "R"   
			oPrn:Say( nLine1, nLef+cc6, CDESCTBP, oFont3, 100 ) 
      		oPrn:Say( nLine1, nLef+cc7, cMoneda +" "+AllTrim( TransForm( nImp1, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont3, 100 )               
      		nLine1 := nLine1+sumador
	  	ELSE
	  		oPrn:Say( nLine2, nLef+cc8,CDESCTBR, oFont3, 100 )
	  		oPrn:Say( nLine2, nLef+cc9,cMoneda +" "+AllTrim( TransForm( nImp2, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont3, 100 )
	  		nLine2 := nLine2+sumador
		EndIf
  	EndIf
ElseIf cTIPO=='BO'
   If cEncab=='1'        
      oPrn:Say( nLine, nLef+cc1, CDESCOBCAB	, oFont3, 100 )                 
      oPrn:Say( nLine, nLef+cc3, "Total: "	, oFont3, 100 )                
      oPrn:Say( nLine, nLef+cc4, cMoneda +" "+AllTrim( TransForm( nTOTAL, PesqPict( "SEK", "EK_VALOR" ) ) )  , oFont3, 100 )                
      oPrn:Say( nLine, nLef+cc5, "Fecha: " + dfecha, oFont3, 100 )                
      nLine1 := nLine + sumador 
      nLine2 := nLine + sumador       
      	If cPago == "P"   
			oPrn:Say( nLine1, nLef+cc6, CDESCOBP, oFont3, 100 ) 
      		oPrn:Say( nLine1, nLef+cc7, cMoneda +" "+AllTrim( TransForm( nImp1, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont3, 100 )               
      		nLine1 := nLine1+sumador
	  	ELSE
	  		oPrn:Say( nLine2, nLef+cc8, CDESCOBR, oFont3, 100 )
	  		oPrn:Say( nLine2, nLef+cc9, cMoneda +" "+AllTrim( TransForm( nImp2, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont3, 100 )
	  		nLine2 := nLine2+sumador
		EndIf
   Else
		cMoneda := "$"
		If cPago == "P"   
			oPrn:Say( nLine1, nLef+cc6, CDESCOBP, oFont3, 100 ) 
      		oPrn:Say( nLine1, nLef+cc7, cMoneda +" "+AllTrim( TransForm( nImp1, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont3, 100 )               
      		nLine1 := nLine1+sumador
	  	ELSE
	  		oPrn:Say( nLine2, nLef+cc8,CDESCOBR, oFont3, 100 )
	  		oPrn:Say( nLine2, nLef+cc9,cMoneda +" "+AllTrim( TransForm( nImp2, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont3, 100 )
	  		nLine2 := nLine2+sumador
		EndIf
   EndIf 
ElseIf cTIPO=='MB'
   If cEncab=='1'        
      oPrn:Say( nLine, nLef+cc1, CDESCMBCAB	, oFont3, 100 )                 
      oPrn:Say( nLine, nLef+cc3, "Total: "	, oFont3, 100 )                
      oPrn:Say( nLine, nLef+cc4, cMoneda +" "+AllTrim( TransForm( nTOTAL, PesqPict( "SEK", "EK_VALOR" ) ) )  , oFont3, 100 )                
      oPrn:Say( nLine, nLef+cc5, "Fecha: " + dfecha, oFont3, 100 )                
      nLine1 := nLine + sumador 
      nLine2 := nLine + sumador       
      	If cPago == "R"   
			oPrn:Say( nLine1, nLef+cc6, CDESCMBP, oFont3, 100 ) 
      		oPrn:Say( nLine1, nLef+cc7, cMoneda +" "+AllTrim( TransForm( nImp1, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont3, 100 )               
      		nLine1 := nLine1+sumador
	  	ELSE
	  		oPrn:Say( nLine2, nLef+cc8, CDESCMBR, oFont3, 100 )
	  		oPrn:Say( nLine2, nLef+cc9, cMoneda +" "+AllTrim( TransForm( nImp2, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont3, 100 )
	  		nLine2 := nLine2+sumador
		EndIf
   Else
		cMoneda := "$"
		If cPago == "R"   
			oPrn:Say( nLine1, nLef+cc6, CDESCMBP, oFont3, 100 ) 
      		oPrn:Say( nLine1, nLef+cc7, cMoneda +" "+AllTrim( TransForm( nImp1, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont3, 100 )               
      		nLine1 := nLine1+sumador
	  	ELSE
	  		oPrn:Say( nLine2, nLef+cc8,CDESCMBR, oFont3, 100 )
	  		oPrn:Say( nLine2, nLef+cc9,cMoneda +" "+AllTrim( TransForm( nImp2, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont3, 100 )
	  		nLine2 := nLine2+sumador
		EndIf
   EndIf
EndIf
RETURN NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ PrintTotal³ Autor ³ Fernando Cardeza   ³ Data ³ 31.07.14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Imprime total general		                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ DETPAGO                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static FUNCTION PrintTotal()
   
   If nLine1>=nLine2
		oPrn:Say( nLine1, 050,Replicate( '-', 220 ), oFont3, 100 )
		nLine1 := nLine1 + sumador                                 
		oPrn:Say( nLine1, nLef+cc9,"TOTAL GENERAL:"+AllTrim( TransForm( nTOTFINAL, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont4, 100 )
	ElseIf nLine2>nLine1    
		oPrn:Say( nLine2, 050,Replicate( '-', 220 ), oFont3, 100 )
		nLine2 := nLine2 + sumador
		oPrn:Say( nLine2, nLef+cc9,"TOTAL GENERAL:"+AllTrim( TransForm( nTOTFINAL, PesqPict( "SEK", "EK_VALOR" ) ) ), oFont4, 100 )
	EndIf

oPrn:EndPage()

RETURN NIL

Static FUNCTION fAcols()
   Local nImporte1:= 0
   Local nImporte2:= 0                                                                                                                                                                                             
   Local cQuery   := ""

Head()
   
cQuery := "exec [DETPAGO_01] '"+SubStr((DTOC(MV_PAR01)),7,4)+SubStr((DTOC(MV_PAR01)),4,2)+SubStr((DTOC(MV_PAR01)),1,2)+"','"+SubStr((DTOC(MV_PAR02)),7,4)+SubStr((DTOC(MV_PAR02)),4,2)+SubStr((DTOC(MV_PAR02)),1,2)+"','"+MV_PAR03+"'"+",'"+MV_PAR04+"',"+STR(MV_PAR05)
cQuery := PLSAvaSQL(cQuery)
If Select("TODO01") <> 0
	DBSelectArea("TODO01")
    TODO01->(DBCloseArea())
EndIf
PLSQuery(cQuery,"TODO01")
TODO01->(DBGoTop())

While TODO01->(!Eof())
	  
      IF ALLTRIM(TODO01->TIPO)=="OP"	//Ordenes de pago
  				IF ALLTRIM(TODO01->PAGO) == "P"
					AADD( aCols, {TODO01->TIPO,"'"+TODO01->NRO_OP,TODO01->FECHA,TODO01->TIPO_COMP,TODO01->SERIE,"'"+TODO01->NRO_COMP,;
					              "'"+TODO01->COD_PROVEEDOR_BANCO,TODO01->NOM_PROVEEDOR_BANCO,"'"+TODO01->CUENTA,TODO01->DESC_CUENTA,;
                                  TODO01->DESC_MOV,TODO01->IMPORTE1,TODO01->DETALLE,"'"+TODO01->NRO_CH_CERT,"'"+TODO01->BANCO,TODO01->NOM_BANCO,;
                                  "'"+TODO01->CTA_CONTABLE,TODO01->DESC_CTA_CTBLE,TODO01->FECHA_VENC,TODO01->CUIT,TODO01->IMPORTE2,''})
				ELSEIF ALLTRIM(TODO01->PAGO) == "R"
					AADD( aCols, {TODO01->TIPO,"'"+TODO01->NRO_OP,TODO01->FECHA,TODO01->TIPO_COMP,TODO01->SERIE,"'"+TODO01->NRO_COMP,;
					              "'"+TODO01->COD_PROVEEDOR_BANCO,TODO01->NOM_PROVEEDOR_BANCO,"'"+TODO01->CUENTA,TODO01->DESC_CUENTA,;
                                  TODO01->DESC_MOV,TODO01->IMPORTE1,TODO01->DETALLE,"'"+TODO01->NRO_CH_CERT,"'"+TODO01->BANCO,TODO01->NOM_BANCO,;
                                  "'"+TODO01->CTA_CONTABLE,TODO01->DESC_CTA_CTBLE,TODO01->FECHA_VENC,TODO01->CUIT,TODO01->IMPORTE2,''})
				ENDIF
				
	  ELSEIF ALLTRIM(TODO01->TIPO)=="BO" //Borderos
  				IF ALLTRIM(TODO01->PAGO) == "P"
					AADD( aCols, {TODO01->TIPO,"'"+TODO01->NRO_OP,TODO01->FECHA,TODO01->TIPO_COMP,TODO01->SERIE,"'"+TODO01->NRO_COMP,;
					              "'"+TODO01->COD_PROVEEDOR_BANCO,TODO01->NOM_PROVEEDOR_BANCO,"'"+TODO01->CUENTA,TODO01->DESC_CUENTA,;
                                  TODO01->DESC_MOV,TODO01->IMPORTE1,TODO01->DETALLE,"","'"+TODO01->BANCO,TODO01->NOM_BANCO,;
                                  "'"+TODO01->CTA_CONTABLE,TODO01->DESC_CTA_CTBLE,TODO01->FECHA_VENC,TODO01->CUIT,TODO01->IMPORTE2,''})
				ELSEIF ALLTRIM(TODO01->PAGO) == "R"
					AADD( aCols, {TODO01->TIPO,"'"+TODO01->NRO_OP,TODO01->FECHA,TODO01->TIPO_COMP,TODO01->SERIE,"'"+TODO01->NRO_COMP,;
					              "'"+TODO01->COD_PROVEEDOR_BANCO,TODO01->NOM_PROVEEDOR_BANCO,"'"+TODO01->CUENTA,TODO01->DESC_CUENTA,;
                                  TODO01->DESC_MOV,TODO01->IMPORTE1,TODO01->DETALLE,"'"+TODO01->NRO_CH_CERT,"'"+TODO01->BANCO,TODO01->NOM_BANCO,;
                                  "'"+TODO01->CTA_CONTABLE,TODO01->DESC_CTA_CTBLE,TODO01->FECHA_VENC,TODO01->CUIT,TODO01->IMPORTE2,''})
				ENDIF
	  
      ELSEIF ALLTRIM(TODO01->TIPO)=="TB" //Transferencias Bancarias
  				IF ALLTRIM(TODO01->PAGO) == "P"
					AADD( aCols, {TODO01->TIPO,"'"+TODO01->NRO_OP,TODO01->FECHA,TODO01->TIPO_COMP,TODO01->SERIE,"'"+TODO01->NRO_COMP,;
					              "'"+TODO01->COD_PROVEEDOR_BANCO,TODO01->NOM_PROVEEDOR_BANCO,"'"+TODO01->CUENTA,TODO01->DESC_CUENTA,;
                                  TODO01->DESC_MOV,TODO01->IMPORTE1,TODO01->DETALLE,"'"+TODO01->NRO_CH_CERT,"'"+TODO01->BANCO,TODO01->NOM_BANCO,;
                                  "'"+TODO01->CTA_CONTABLE,TODO01->DESC_CTA_CTBLE,TODO01->FECHA_VENC,TODO01->CUIT,TODO01->IMPORTE2,''})
				ELSEIF ALLTRIM(TODO01->PAGO) == "R"
					AADD( aCols, {TODO01->TIPO,"'"+TODO01->NRO_OP,TODO01->FECHA,TODO01->TIPO_COMP,TODO01->SERIE,"'"+TODO01->NRO_COMP,;
					              "'"+TODO01->COD_PROVEEDOR_BANCO,TODO01->NOM_PROVEEDOR_BANCO,"'"+TODO01->CUENTA,TODO01->DESC_CUENTA,;
                                  TODO01->DESC_MOV,TODO01->IMPORTE1,TODO01->DETALLE,"'"+TODO01->NRO_CH_CERT,"'"+TODO01->BANCO,TODO01->NOM_BANCO,;
                                  "'"+TODO01->CTA_CONTABLE,TODO01->DESC_CTA_CTBLE,TODO01->FECHA_VENC,TODO01->CUIT,TODO01->IMPORTE2,''})
				ENDIF	
	  ELSEIF ALLTRIM(TODO01->TIPO)=="MB" //Movimientos Bancarios
  				IF ALLTRIM(TODO01->PAGO) == "P"
					AADD( aCols, {TODO01->TIPO,"'"+TODO01->NRO_OP,TODO01->FECHA,TODO01->TIPO_COMP,TODO01->SERIE,"'"+TODO01->NRO_COMP,;
					              "'"+TODO01->COD_PROVEEDOR_BANCO,TODO01->NOM_PROVEEDOR_BANCO,"'"+TODO01->CUENTA,TODO01->DESC_CUENTA,;
                                  TODO01->DESC_MOV,TODO01->IMPORTE1,TODO01->DETALLE,"'"+TODO01->NRO_CH_CERT,"'"+TODO01->BANCO,TODO01->NOM_BANCO,;
                                  "'"+TODO01->CTA_CONTABLE,TODO01->DESC_CTA_CTBLE,TODO01->FECHA_VENC,TODO01->CUIT,TODO01->IMPORTE2,''})
				ELSEIF ALLTRIM(TODO01->PAGO) == "R"
					AADD( aCols, {TODO01->TIPO,"'"+TODO01->NRO_OP,TODO01->FECHA,TODO01->TIPO_COMP,TODO01->SERIE,"'"+TODO01->NRO_COMP,;
					              "'"+TODO01->COD_PROVEEDOR_BANCO,TODO01->NOM_PROVEEDOR_BANCO,"'"+TODO01->CUENTA,TODO01->DESC_CUENTA,;
                                  TODO01->DESC_MOV,TODO01->IMPORTE1,TODO01->DETALLE,"'"+TODO01->NRO_CH_CERT,"'"+TODO01->BANCO,TODO01->NOM_BANCO,;
                                  "'"+TODO01->CTA_CONTABLE,TODO01->DESC_CTA_CTBLE,TODO01->FECHA_VENC,TODO01->CUIT,TODO01->IMPORTE2,''})
				ENDIF	
      ENDIF              
      nImporte1+=TODO01->IMPORTE1
      nImporte2+=TODO01->IMPORTE2
      DbSkip()
      
ENDDO

AADD( aCols, {'','TOTAL GENERAL','','','','','','','','','',nImporte1,'','','','','','','','',nImporte2,''} )

RETURN NIL

STATIC FUNCTION Head()

AADD( aHeader, {"TIPO","C",10,0})
AADD( aHeader, {"NRO. OP","C",20,0}) 
AADD( aHeader, {"FECHA","C",10,0})
AADD( aHeader, {"TIPO COMP.","C",10,0})
AADD( aHeader, {"SERIE","C",10,0})
AADD( aHeader, {"NRO. COMP.","C",10,0})
AADD( aHeader, {"COD. PROVEEDOR/BANCO","C",10,0})
AADD( aHeader, {"NOM. PROVEEDOR/BANCO","C",99,0})
AADD( aHeader, {"CUENTA","C",10,0})
AADD( aHeader, {"DESC. CUENTA","C",99,0})
AADD( aHeader, {"DESC. MOV","C",10,0})
AADD( aHeader, {"IMPORTE","N",20,2})
AADD( aHeader, {"DETALLE","C",10,0}) 
AADD( aHeader, {"NRO.CH/CERT","C",10,0})
AADD( aHeader, {"BANCO","C",10,0})
AADD( aHeader, {"NOM. BANCO","C",10,0})
AADD( aHeader, {"CTA. CONTABLE","C",10,0})
AADD( aHeader, {"DESC. CTA. CTBLE","C",10,0})
AADD( aHeader, {"FECHA VENC.","C",10,0})
AADD( aHeader, {"CUIT","C",10,0})
AADD( aHeader, {"IMPORTE","N",20,2})
AADD( aHeader, {"","C",1,0})

RETURN NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ VLDPERG  ³ Autor ³ Fernando Cardeza    ³ Data ³ 16.12.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Validaci¢n de SX1 para DETPAGO                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ DETPAGO                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function VldPerg(_cPerg)                    
Local aHelpPor := {	'Opcion 1= Solo Ordenes de Pago','Opcion 2= Solo Transferencias Bacarias','Opcion 3= Solo Movimientos Bancarios','Opcion 4= Solo Bordero','Opcion 5= Todas'}
Local aHelpEng := {	'Opcion 1= Solo Ordenes de Pago','Opcion 2= Solo Transferencias Bacarias','Opcion 3= Solo Movimientos Bancarios','Opcion 4= Solo Bordero','Opcion 5= Todas'}	
Local aHelpSpa := {	'Opcion 1= Solo Ordenes de Pago','Opcion 2= Solo Transferencias Bacarias','Opcion 3= Solo Movimientos Bancarios','Opcion 4= Solo Bordero','Opcion 5= Todas'}

PutSx1(_cPerg,"01","Desde Fecha"     ,"Desde Fecha"    ,"Desde Fecha"    ,"mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",,,)
PutSx1(_cPerg,"02","Hasta Fecha"	 ,"Hasta Fecha"    ,"Hasta Fecha"    ,"mv_ch2","D",08,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",,,)
PutSx1(_cPerg,"03","Desde Modalidad" ,"Desde Modalidad","Desde Modalidad","mv_ch3","C",10,0,0,"G","","","SED","","mv_par03","","","","","","","","","","","","","","","","",,,)
PutSx1(_cPerg,"04","Hasta Modalidad" ,"Hasta Modalidad","Hasta Modalidad","mv_ch4","C",10,0,0,"G","","","SED","","mv_par04","","","","","","","","","","","","","","","","",,,)
PutSx1(_cPerg,"05","Tipo de mov."	 ,"Tipo de mov."   ,"Tipo de mov."   ,"mv_ch5","N",01,0,0,"C","","","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1(_cPerg,"06","Excel?"		     ,"Excel?"		   ,"Excel?"	     ,"mv_ch6","N",01,0,0,"C","","","","","mv_par06","Si"     ,"Si"     ,"Si"     ,"","No","No","No","","","","","","","","","",,,)

RETURN