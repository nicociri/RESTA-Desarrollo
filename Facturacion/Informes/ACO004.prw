#include "rwmake.ch"        

/*    
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncion   � ACO004      � Autor � Fernando Cardeza   � Data � 16.03.14 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escripcion Impresion de Formulario.                                   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Modelo de impresion para Argentina                         潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/

User Function ACO004(nroaco1)       

//Declaracion de Variables
LOCAL aEnvOpag := GetArea()

PRIVATE lPrOk  := .T.                  //Status de la impresion

// Definicion de Fonts para Impresion
PRIVATE oPrn  := TMSPrinter():New(), ;
oFont1 := TFont():New( "Arial 12cpi"      ,, 12,, .t.,,,,    , .f. )
oFont2 := TFont():New( "Arial 10cpi"      ,, 10,, .t.,,,,    , .f. )
oFont3 := TFont():New( "Arial  8cpi"      ,, 08,, .t.,,,,    , .f. )
oFont4 := TFont():New( "Arial 12cpi"      ,, 12,, .t.,,,,    , .f. )
oFont5 := TFont():New( "Arial 10cpi"      ,, 10,, .f.,,,,    , .f. )
oFont6 := TFont():New( "Arial  8cpi"      ,, 08,, .f.,,,,    , .f. )

PRIVATE	cACOPIO   	:= ""
PRIVATE	dDATA     	:= CTOD("  /  /  ")
PRIVATE cVOLUMEN	:= ""         
PRIVATE dVENC		:= CTOD("  /  /  ")
PRIVATE	cCLIENTE  	:= ""
PRIVATE	cLOJA     	:= ""
PRIVATE	cRAZAO    	:= ""
PRIVATE	cEND      	:= ""
PRIVATE	cMUN      	:= ""
PRIVATE cPAUT		:= ""      
PRIVATE	cEST      	:= ""      
PRIVATE	cCEP      	:= ""      
PRIVATE	cMUNE     	:= ""      
PRIVATE	cCUIT     	:= ""
PRIVATE	aPROD   	:= {}
PRIVATE	aDESC   	:= {}
PRIVATE aGRUPO      := {}
PRIVATE	aGRUPO1  	:= {}
PRIVATE	aQUANT  	:= {}
PRIVATE	aPRECO  	:= {}
PRIVATE	aTOTIT  	:= {}
PRIVATE	cDIROBRA   	:= ""
PRIVATE	cMENSNOTA  	:= ""
PRIVATE cFactura	:= ""
PRIVATE cDescaco	:= ""
PRIVATE	cVEND     	:= ""
PRIVATE cDESCC		:= ""
PRIVATE	aux1     	:= ""
PRIVATE	nTOTAL	   	:= ""
PRIVATE nNumLin4	:= ""
PRIVATE cTipo		:= ""
PRIVATE nroAco		:= nroaco1
PRIVATE cincre	    :=0
PRIVATE	cSeguro	    :=""
PRIVATE	cPoliza	    :=""
PRIVATE	cTpSeg1	    :=""
PRIVATE	carclien1   :=""
PRIVATE	nPorc	    :=0
PRIVATE	cPoliz2	    :=""
PRIVATE	cTpSeg2	    :=""
PRIVATE	carclien2   :=""
PRIVATE	nPorc2	    :=0
SetPrvt("CPERG,ADRIVER,CSTRING,CBTXT,CBCONT,TAMANHO")
SetPrvt("LIMITE,TITULO,CDESC1,CDESC2,CDESC3,ARETURN")
SetPrvt("NOMEPROG,NLIN,WNREL,CTIPODOC,CDOC,CSERIE")
SetPrvt("DDATA,CVEND,CCLIENTE,CLOJA,CCOND,NTOTAL")
SetPrvt("CRAZAO,CEND,CMUN,CEST,CCEP,CENDE")
SetPrvt("CMUNE,CESTE,CCEPE,CCUIT,CDESC,DVENC")
SetPrvt("APROD,ADESC,ALOTE,AQUANT,APRECO,ATOTIT")
SetPrvt("NIMP4,NIMP5,NIMP6,NTOTQT,cLINHAS")
SetPrvt("NOPC,CCOR,LCONTINUA,_SALIAS,AREGS,I")
SetPrvt("J,")              

cPerg:="ACO004    "      

	VldPerg(cPerg)
If Empty(nroAco)	
	If !Pergunte(cPerg, .T.)
		Return
	EndIf
	nroaco:=MV_PAR01
EndIf 
	
aDRIVER := READDRIVER()

cString:="Z01"
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Variables utilizadas para parametros                         �
//� mv_par01             // De acopio       	                 �
//� mv_par02             // Hasta acopio	                     �
//� mv_par03             // Serie                                �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
CbTxt:=""
CbCont:=""
tamanho:="G"
limite 	:=220
titulo 	:=PADC("Emisi del formulario de acopios." ,74)
cDesc1 	:=PADC("Ser爏olicitado el Intervalo para la emisi de los",74)
cDesc2 	:=PADC("Acopios generados",74)
cDesc3 	:=""
aReturn := { OemToAnsi("Especial"), 1,OemToAnsi("Administraci"), 1, 2, 1,"",1 }
nomeprog:="ACO004"
nLin	:=0
wnrel   :="ACO004"


//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Envia control a funcion SETPRINT                             �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,"",.T.,"G","",.F.)

If nLastKey == 27
	Return
Endif

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Verifica Posicion del Formulario en la Impresora             �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif
         
//VerImp()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//�                                                              �
//� Inicio de Procesamiento del Factura                          �
//�                                                              �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
RptStatus({|| RptNota()})// Substituido pelo assistente de conversao do AP5 IDE em 17/04/00 ==>         RptStatus({|| Execute(RptNota)})
Return


// Substituido pelo assistente de conversao do AP5 IDE em 17/04/00 ==> Function RptNota
Static Function RptNota()
               
Local nCont := 0

//SetRegua(Val(mv_par02)-Val(mv_par01)) 
SetRegua(0)
dbSelectArea("Z01")
dbSetOrder(1)
dbSeek(xFilial("Z01")+nroaco,.T.)


WHILE Z01->Z01_ACOPIO = nroaco .AND. .NOT. EOF()
	INCREGUA()
	
	cACOPIO   :=       Z01->Z01_ACOPIO	 // NUMERO DE ACOPIO
	dDATA     :=       Z01->Z01_EMIS     // EMISION
	cCLIENTE  :=       Z01->Z01_CLIENTE  // COD CLIENTE
	cLOJA     :=       Z01->Z01_LOJA     // TIENDA DE CLIENTE
	dVENC	  :=	   Z01->Z01_FCHVEN   // FECHA DE VENCIMIENTO
	cDESCC	  := Transform( (Z01->Z01_DESC1), "@E 99.99" )+"+"  //DESCUENTOS APLICADOS AL CLIENTE Y AL ACOPIO
	cDESCC	  += Transform( (Z01->Z01_DESC2), "@E 99.99" )+"+"
	cDESCC	  += Transform( (Z01->Z01_DESC3), "@E 99.99" )+"+"
	cDESCC	  += Transform( (Z01->Z01_DESC4), "@E 99.99" )
	cincre	  := Z01->Z01_XINCR  //INCREMENTO EN EL BACKUP
	cDIROBRA  := Z01->Z01_XDIRO	 // DIRECCION DE OBRA
	cLista	  := Z01->Z01_XCDTAB //LISTA DE PRECIOS DEL ACOPIO
	cMENSNOTA := Z01->Z01_XOBS3  // MENSAGEM NO FINAL DO CORPO DA NOTA
	cPAUT     := Z01->Z01_XPAUT  // PERSONA AUTORIZADA
	nTOTAL	  := Z01->Z01_XVFAC	 // TOTAL DEL ACOPIO 
	cVOLUMEN  := Z01->Z01_XENVIO // PERTENECE A BACKUP
	cSeguro	  := Z01_XSEG
	cPoliza	  := Z01->Z01_POLIZA
	cTpSeg1	  := Z01->Z01_TPSEG1
	carclien1 := Z01->Z01_CCLIET
	nPorc	  := Z01->Z01_XPORC
	cPoliz2	  := Z01->Z01_POLIZ2
	cTpSeg2	  := Z01->Z01_TPSEG2 
	carclien2 := Z01->Z01_CCLIE2
	nPorc2	  := Z01->Z01_XPORC2
	cTipo	  := Z01->Z01_TIPO
	cDescaco  := Z01->Z01_DESC
	cFactura  := Z01->Z01_XFACT
 	//Z01_XFILIA
      		
		If cVOLUMEN=="2"       
			cVOLUMEN:="REMITO"
		Else
			cVOLUMEN:="FACTURA"
		EndIf
		     
		If cSeguro=="S"       
			cSeguro:="SI"
		Else
			cSeguro:="NO"
		EndIf               
		
		If cSeguro=="SI"
			If cTpSeg1=="1"       
				cTpSeg1:="ADJUDICADO"
			Else
				cTpSeg1:="ANTICIPO"
			EndIf
			If cTpSeg2=="1"       
				cTpSeg2:="ADJUDICADO"
			Else
				cTpSeg2:="ANTICIPO"
			EndIf
		Else
			cTpSeg1:=""
			cTpSeg2:=""
	   	EndIf
	SELECT SA1  // CLIENTES
	SEEK xFILIAL("SA1")+cCLIENTE+cLOJA
	
	cRAZAO    :=       SA1->A1_NOME      // NOME
	cEND      :=       SA1->A1_END       // ENDERECO
	cMUN      :=       SA1->A1_MUN       // MUNICIPIO
	cEST      :=       Posicione("SX5",1,"  12"+SA1->A1_EST,"X5_DESCRI") // ESTADO
	cCEP      :=       SA1->A1_CEP       // CEP
	cMUNE     :=       SA1->A1_MUNE      // MUNICIPIO DE ENTREGA
	cCUIT     :=       SA1->A1_CGC       // CUIT
	cVEND     := 	   SA1->A1_VEND  	// COD VENDEDOR 
	
	aPROD   := {}
	aDESC   := {}
	aGRUPO  := {}
	aQUANT  := {}
	aPRECO  := {}
	aTOTIT  := {}
	
	SELECT SC6
	SET ORDER TO 5
	SEEK xFILIAL("SC6")+cCLIENTE+cLOJA
	
	WHILE SC6->C6_CLI == cCLIENTE .AND. SC6->C6_LOJA == cLOJA .AND. .NOT. EOF()
		If SC6->C6_PRODUTO<>'ACOPIO' .AND. SC6->C6_XNROACO == cACOPIO
		AADD(aPROD,SC6->C6_PRODUTO)            							 // PRODUTO
		AADD(aDESC,SC6->C6_DESCRI)  	       							 // PRODUTO DESCRIPCION		
		AADD(aQUANT,SC6->C6_QTDVEN)           							 // QUANTIDADE
		AADD(aPRECO,SC6->C6_PRCVEN)            							 // PRECO UNITARIO PRATICADO
		AADD(aTOTIT,SC6->C6_VALOR)             							 // TOTAL DO ITEM
		EndIf
		SELECT SC6
		SKIP
	END
	
	
	aGRUPO:={}
	
	cQuery := "SELECT SUBSTRING(DA1_CODPRO,1,3) COD,DA1_VLRDES VALOR FROM " + RetSqlName("DA1") 
	cQuery += " WHERE D_E_L_E_T_='' AND DA1_ATIVO = '1' AND DA1_CODTAB='"+cLista+"'"
	cQuery += " GROUP BY SUBSTRING(DA1_CODPRO,1,3),DA1_VLRDES "
	cQuery += " ORDER BY SUBSTRING(DA1_CODPRO,1,3) "
	cQuery := PLSAvaSQL(cQuery)
  	If Select("TODO01") <> 0
		DBSelectArea("TODO01")
		TODO01->(DBCloseArea())
  	EndIf
		PLSQuery(cQuery,"TODO01")
		TODO01->(DBGoTop())
    While TODO01->(!Eof()) 
    		AADD(aGRUPO,TODO01->COD+" ("+ALLTRIM(Transform(TODO01->VALOR, "@E 999.99"))+")")  // GRUPO
   		DbSkip()
	Enddo
    cGrupo:=""
    cGrupo:=fGrupo() //Funcion que trae los grupos acopiados
  	
	nLIN := 0
	SELECT Z01
	SKIP
END

ImpEncab()
ImpPie()          
          
oPrn:PreView()
	
MS_FLUSH()
Return
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲unci     � ImpEncab � Autor � Ariel A. Musumeci   � Data � 08.05.00 潮�
北媚哪哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escripci � Rutina de Impresi de Encabezados.                      潮�
北媚哪哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso        � VESFAC                                                   潮�
北滥哪哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
/*/
Static Function ImpEncab()
Local nline:=0100

oPrn:StartPage()

nFilaEnc := 0

If !Empty( GetMV( "MV_DIRLOGO" ) )
	If File( AllTrim( GetMV( "MV_DIRLOGO" ) ) )
		oPrn:SayBitmap( 0070, 0100, AllTrim( GetMV( "MV_DIRLOGO" ) ) , 250, 250 )
	EndIf
EndIf

oPrn:Say( nline, 0250, PadL( "FORMULARIO DE ACOPIO", 80 ), oFont1, 100 )
nLine+=100
oPrn:Say( nline, 1700, "NUMERO:", oFont6, 100 )
oPrn:Say( nline, 2000, cACOPIO, oFont2, 100 )
nLine+=50
oPrn:Say( nline, 1700, "FECHA:", oFont6, 100 )
oPrn:Say( nline, 2000, DToC( dDATA ), oFont2, 100 )
nLine+=50
oPrn:Say( nline, 1700, "VOL.:", oFont6, 100 )
oPrn:Say( nline, 2000, cVOLUMEN, oFont2, 100 )

nLine+=120
oPrn:Line( nline, 0050, nline, 2300 )
nLine+=30
oPrn:Say ( nline, 0100, "DATOS DEL CLIENTE:", oFont3, 100 )
nLine+=50
oPrn:Line( nline, 0050, nline, 2300 )
nLine+=50
oPrn:Say( nline, 0150, "CODIGO :", oFont6, 100 )
oPrn:Say( nline, 0450, Upper( OemToAnsi( cCLIENTE+"-"+CLOJA ) ), oFont2, 100 )
oPrn:Say( nline, 1500, "DOMICILIO     :", oFont6, 100 )
oPrn:Say( nline, 1700, Upper( cEND	  ), oFont2, 100 )  
nLine+=50
oPrn:Say( nline, 0150, "RAZON SOCIAL     :", oFont6, 100 )
oPrn:Say( nline, 0450, Upper( OemToAnsi( cRAZAO ) ), oFont2, 100 )
oPrn:Say( nline, 1500, "LOCALIDAD     :", oFont6, 100 )
oPrn:Say( nline, 1700, Upper( cMUN 	  ), oFont2, 100 )
nLine+=50
oPrn:Say( nline, 0150, "ESTADO        :", oFont6, 100 )
oPrn:Say( nline, 0450, Upper( cEST	  ), oFont2, 100 )
oPrn:Say( nline, 1500, "C.U.I.T.:", oFont6, 100 )
oPrn:Say( nline, 1700, SubStr( cCUIT, 1, 2 ) + "-" + SubStr( cCUIT, 3, 8 ) + "-" + SubStr( cCUIT, 11, 1 ), oFont2, 100 )

nLine+=120                                   
oPrn:Line( nline, 0050, nline, 2300 )
nLine+=30
oPrn:Say( nline, 0100, "DATOS DEL ACOPIO:", oFont3, 100 )
nLine+=50
oPrn:Line( nline, 0050, nline, 2300 )

nLine+=50
oPrn:Say( nline, 0150, "TIPO DE ACOPIO:"									, oFont6, 100 )
oPrn:Say( nline, 0450, cTipo												, oFont2, 100 )
oPrn:Say( nline, 1500, "LISTA DE PRECIOS:"									, oFont6, 100 )
oPrn:Say( nline, 1850, cLista												, oFont2, 100 )
nLine+=50               
oPrn:Say( nline, 0150, "DESCRIPCION:"										, oFont6, 100 )
oPrn:Say( nline, 0450, Alltrim(cDescaco)									, oFont2, 100 )
oPrn:Say( nline, 1500, "" 													, oFont6, 100 )
oPrn:Say( nline, 1850, ""													, oFont2, 100 )
nLine+=50
oPrn:Say( nline, 0150, "DIRECCION DE OBRA:"									, oFont6, 100 )
oPrn:Say( nline, 0450, cDIROBRA												, oFont2, 100 )
oPrn:Say( nline, 1500, "PERSONA AUTORIZADA:"								, oFont6, 100 )
oPrn:Say( nline, 1850, cPAUT												, oFont2, 100 )
nLine+=50
oPrn:Say( nline, 0150, "CODIGO DE VENDEDOR:"					   			, oFont6, 100 )
oPrn:Say( nline, 0500, cVEND												, oFont2, 100 )
oPrn:Say( nline, 1500, "NOMBRE DE VENDEDOR:"								, oFont6, 100 )
oPrn:Say( nline, 1850, Posicione("SA3",1,"  "+cVEND,"A3_NOME")			, oFont2, 100 )
nLine+=50
oPrn:Say( nline, 0150, "MONTO DEL ACOPIO:"								, oFont6, 100 )
oPrn:Say( nline, 0450, "$"+Transform( nTOTAL, '@E 999,999,999.99')		, oFont2, 100 )
oPrn:Say( nline, 1500, "FECHA DE VENC.:"								, oFont6, 100 )
oPrn:Say( nline, 1850, DToC( dVENC )									, oFont2, 100 )
nLine+=50
oPrn:Say( nline, 0150, "INCREMENTO:"								, oFont6, 100 )
oPrn:Say( nline, 0450, "$"+Transform( cincre, '@E 999,999,999.99')		, oFont2, 100 )
oPrn:Say( nline, 1500, "Factura:"								, oFont6, 100 )
oPrn:Say( nline, 1850, cFactura									, oFont2, 100 )
nLine+=50

nLine+=120                                   
oPrn:Line( nline, 0050, nline, 2300 )
nLine+=30
oPrn:Say( nline, 0100, "DATOS DEL SEGURO:", oFont3, 100 )
nLine+=50
oPrn:Line( nline, 0050, nline, 2300 )

nLine+=50                                                                                      
oPrn:Say( nline, 0150, "SEGURO:"									, oFont6, 100 )
oPrn:Say( nline, 0450, cSeguro										, oFont2, 100 )
oPrn:Say( nline, 1500, ""											, oFont6, 100 )
oPrn:Say( nline, 1850, ""											, oFont2, 100 )
nLine+=50
oPrn:Say( nline, 0150, "NRO. POLIZA:"					   			, oFont6, 100 )
oPrn:Say( nline, 0500, cPoliza										, oFont2, 100 )
oPrn:Say( nline, 1500, "TIPO DE SEGURO:"							, oFont6, 100 )
oPrn:Say( nline, 1850, cTpSeg1										, oFont2, 100 )
nLine+=50
oPrn:Say( nline, 0150, "CARGO CLIENTE:"								, oFont6, 100 )
oPrn:Say( nline, 0450, carclien1									, oFont2, 100 )
oPrn:Say( nline, 1500, "PORCENTAJE:"								, oFont6, 100 )
oPrn:Say( nline, 1850, Transform( nPorc, '@E 999,999,999.99')		, oFont2, 100 )
nLine+=50
oPrn:Say( nline, 0150, "NRO. POLIZA:"					   			, oFont6, 100 )
oPrn:Say( nline, 0500, cPoliz2										, oFont2, 100 )
oPrn:Say( nline, 1500, "TIPO DE SEGURO:"							, oFont6, 100 )
oPrn:Say( nline, 1850, cTpSeg2										, oFont2, 100 )
nLine+=50
oPrn:Say( nline, 0150, "CARGO CLIENTE:"								, oFont6, 100 )
oPrn:Say( nline, 0450, carclien2									, oFont2, 100 )
oPrn:Say( nline, 1500, "PORCENTAJE:"								, oFont6, 100 )
oPrn:Say( nline, 1850, Transform( nPorc2, '@E 999,999,999.99')		, oFont2, 100 )
nLine+=50


nLinesObs4   := MLCount( Alltrim( cMENSNOTA ), 120)
oPrn:Say( nline, 0150, "OBSERVACIONES DEL ACOPIO:"  						, oFont6, 100 )	
nLine+=50
For nX := 1 To nLinesObs4
	If nX==1
		oPrn:Say( nline, 0250, MemoLine( Alltrim( cMENSNOTA ), 120, nX )	, oFont2, 100 )
		nLine+=30 
	Else
		oPrn:Say( nline, 0150, MemoLine( Alltrim( cMENSNOTA ), 120, nX )	, oFont2, 100 )
		nLine+=30
	EndIf	
Next

nLine+=120                                   
oPrn:Line( nline, 0050, nline, 2300 )
nLine+=30
oPrn:Say ( nline, 0100, "DESCUENTOS:", oFont3, 100 )
nLine+=50
oPrn:Line( nline, 0050, nline, 2300 )

nLine+=50
oPrn:Say( nline, 0150, "DESCUENTOS POR CLIENTE:"			, oFont6, 100 )
nLine+=50
oPrn:Say( nline, 0450, cDESCC								, oFont2, 100 )

ImpDetal(nline)

Return 


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲unci     � IMPDETAL � Autor � Ariel A. Musumeci   � Data � 08.05.00 潮�
北媚哪哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escripci � Rutina de Impresi de Detalles.                         潮�
北媚哪哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
/*/
Static Function Impdetal(nline)

nLin:= nline+100
	oPrn:Box( nLin, 0050, nLin+80, 2300 )
	nLin+=30
	oPrn:Say( nLin, 0150, "FAMILIAS ACOPIADAS", oFont6, 100 )
	
	nLinesObs4   := MLCount( Alltrim( cGRUPO ), 150)
	nLine+=200
For nX := 1 To nLinesObs4
	If nX==1
		oPrn:Say( nline, 0150, MemoLine( Alltrim( cGRUPO ), 150, nX )	, oFont6, 100 )
		nLine+=30 
	Else
		oPrn:Say( nline, 0150, MemoLine( Alltrim( cGRUPO ), 150, nX )	, oFont6, 100 )
		nLine+=30
	EndIf	
Next


//	oPrn:Say( nFilad, 0150, cGRUPO, oFont6, 100 )
	
Return                              


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲unci     � IMPDETAL � Autor � Ariel A. Musumeci   � Data � 08.05.00 潮�
北媚哪哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escripci � Rutina de Impresi de Detalles.                         潮�
北媚哪哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
/*/
Static Function fGrupo()
Local cGrupo:=""  

For l:=1 to LEN(aGRUPO)	
 cGrupo+=aGRUPO[l]
 If LEN(aGRUPO)>l
  	cGrupo+=" - "
 EndIf
Next
Return (cGRUPO)

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲unci     � IMPPIE   � Autor � Ariel A. Musumeci   � Data � 08.05.00 潮�
北媚哪哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escripci � Rutina de Impresi de Pie de Documento.                 潮�
北媚哪哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
/*/
Static Function ImpPie()

oPrn:Box( 2800, 0150, 3150, 2300 )
                                             
oPrn:Say( 2900, 0250, "Vendedor:........................", oFont3, 100 )
oPrn:Say( 2900, 1650, "Jefe de Ventas:..................", oFont3, 100 )
oPrn:Say( 3050, 0250, "Administracion:..................", oFont3, 100 )
oPrn:Say( 3050, 1650, "Compras:.........................", oFont3, 100 )

oPrn:EndPage()

Return
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲unci     � VLDPERG  � Autor � Ariel A. Musumeci   � Data � 05.05.00 潮�
北媚哪哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escripci � Validaci de SX1                                        潮�
北媚哪哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
/*/
Static Function VldPerg(cPerg)

LOCAL aVldSX1  := GetArea()
LOCAL aCposSX1 := {}
LOCAL aPergs   := {}

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL	",;
"X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1",;
"X1_CNT01","X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02" ,"X1_VAR03",;
"X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03","X1_VAR04","X1_DEF04","X1_DEFSPA4",;
"X1_DEFENG4","X1_CNT04","X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
"X1_F3","X1_GRPSXG"}
 
aAdd(aPergs,{'Numero de acopio','Numero de acopio','Numero de acopio','mv_ch1','C', 06, 0, 1, 'G', '', 'mv_par01','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','Z01',''})
//aAdd(aPergs,{'Desde Numero','Desde Numero','Desde Numero','mv_ch1','C', 06, 0, 1, 'G', '', 'mv_par01','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','Z01',''})
//aAdd(aPergs,{'Hasta Numero','Hasta Numero','Hasta Numero','mv_ch2','C', 06, 0, 1, 'G', '', 'mv_par02','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','Z01',''})

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	If !(dbSeek(cPerg+StrZero(nx,2)))
		RecLock("SX1",.T.)
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with StrZero(nx,2)
		for nj:=1 to Len(aCposSX1)
			FieldPut(FieldPos(ALLTRIM(aCposSX1[nJ])),aPergs[nx][nj])
		next nj
		MsUnlock()
	Endif
Next

RestArea( aVldSX1 )

Return