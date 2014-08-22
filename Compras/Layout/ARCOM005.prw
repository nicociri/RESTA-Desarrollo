#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ARCOM005        ºAutor  ³Microsiga     ºFecha ³  08/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPRESIÓN DE PEDIDO DE COMPRAS SIN OBSERVACIONES POR ITEM  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RESTA      			                	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function ARCOM005(_cNumPedCom)

Local cDesc1  		:= "Este programa tiene como objetivo imprimir "
Local cDesc2  		:= "la orden de compra. "
Local NomeProg		:= "ARCOM005"
Local nLastKey    	:= 0
Local lAbortPrint	:= .F.
Private cPerg 		:= padr("ARCOM005",10)
Private aReturn		:= {"A Rayas", 1, "Administración", 1,2,1,"",1}
Private titulo		:= "ORDEN DE COMPRA"
Private _hFile
Private _lPriEscri := .T.
Private _cCadena:=""
Private _cNomeArc
Private _cmoeda		:= ""
Private nNumHoja := 0
Private nvaldesc	:= 0
Private nvalmerc	:= 0
Private nDesctot	:= 0
Private	_aLugEnt	:= Array(4)
//Private _cLugEnt	:= " "
Private _cCondicion	:= " "
Private	_cXobserv	:= " "

oPrn 	   			:= TMSPrinter():New()


//oPrn := TAvPrinter():New()

If Empty(_cNumPedCom)
	
	Preguntas()
	If !Pergunte(cPerg,.t.)
		return
	Endif
	
Else
	
	mv_par01 := SC7->C7_NUM
	mv_par02 := SC7->C7_NUM
	
Endif

If nLastKey == 27
	lAbortPrint:=.T.
	Return
Endif

If Val(mv_par01) > Val(mv_par02)
	Msgbox("Problema con los Parametros !!! ")
	Return
Endif

Processa( {||Imprime() })

Set Filter To
oPrn:Setup() 		// Pantalla para configurar impressora
oPrn:SetLandScape()
If lAbortPrint
	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	Return
Endif
oPrn:Preview()      // Ventana con la vista previa de impresion
MS_FLUSH()

Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ Imprime  ³ Autor ³ Skiddoo				³ Data ³ 25.06.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip   ³ Proceso principal para impresion de titulos                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/

Static Function Imprime()
oFont07  := TFont():New( "Arial",,07,,.f.,,,,,.f. )
oFont09  := TFont():New( "Arial",,09,,.f.,,,,,.f. )
oFont09b := TFont():New( "Arial",,09,,.t.,,,,,.f. )// negrita.
oFont08  := TFont():New( "Arial",,08,,.f.,,,,,.f. )
oFont10  := TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont08b := TFont():New( "Arial",,08,,.t.,,,,,.f. )// negrita.
oFont10b := TFont():New( "Arial",,10,,.t.,,,,,.f. )// negrita.
oFont11  := TFont():New( "Arial",,11,,.f.,,,,,.f. )
oFont11b := TFont():New( "Arial",,11,,.t.,,,,,.f. )// negrita.
oFont12  := TFont():New( "Arial",,12,,.f.,,,,,.f. )
oFont12b := TFont():New( "Arial",,12,,.t.,,,,,.f. )// negrita.
oFont13b := TFont():New( "Arial",,13,,.t.,,,,,.f. )// negrita.
oFont20b := TFont():New( "Arial",,20,,.t.,,,,,.f. )// negrita.
oFontAr07:= TFont():New( "Arial",,07,,.f.,,,,,.f. )
oFontAB07:= TFont():New( "Arial",,07,,.t.,,,,,.f. )

Private cBitMap :="/system/lgmid01.png"
Private lAbortPrint := .F., aLugarEnt := {}

oPrn:StartPage()

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Ciclo para Imprimir varios documentos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù
*/

//cQuery:="SELECT * FROM "+RetSqlName("SC7")+" "
cQuery:="SELECT * FROM "+RetSqlName("SC7")+" "
cQuery+="WHERE C7_NUM >= '"+mv_par01+"' AND C7_NUM <= '"+mv_par02+"' "
cQuery+="AND D_E_L_E_T_ <> '*' "
//cQuery+="AND C7_CONAPRO = 'L' "
cQuery+="ORDER BY C7_NUM,C7_ITEM"

TCQUERY cQuery Alias IS2 NEW

DbselectArea("IS2")
IF Eof()
	MsgStop("No se encontraron documentos con los parametros informados, o el Pedido no esta aprobado")
	Dbselectarea("IS2")
	DbCloseArea()
	return
Endif
lPrimera	:=.T.
nLin		:=3000
nTotCantidad:=0
_cObserv	:= ""
nTotCanSt	:=0
nTotIva		:=0
nTotIIBB	:= 0 
nTotsIva		:=0
nTotTotal	:=0
nTotTotSt	:=0
cNumPedido	:=IS2->C7_NUM
cSector		:=IS2->C7_CC
//_xObserv	:=IS2->C7_XOBSCAB
_cDescri	:=""

While !Eof()
	If nLin > 1600 .Or. IS2->C7_NUM <> cNumPedido
		If !lPrimera
			If IS2->C7_NUM <> cNumPedido
				Crea_Pie()
				_cmoeda		:= STR(IS2->C7_MOEDA)
			 	_cxObserv	:= ""
				nTotCantidad:=0
				nTotCanSt	:=0
				_cObserv 	:= 0
				nTotIva		:=0
				nTotsIva    :=0
				nTotTotal	:=0
				nTotTotSt	:=0
				nDesctot	:= 0
				cNumPedido	:=IS2->C7_NUM
			Else
				oPrn:Say( nLin+300, 2200, " *** CONTINUA EN LA SIGUIENTE PAGINA *** " ,oFont09,070 )
				
			Endif
			oPrn:EndPage()
		Else
			lPrimera:=.F.
			_cmoeda		:= STR(IS2->C7_MOEDA)
		Endif
		Crea_Pagina()
		nLin:=600
		//		nTotCantidad:=0
		//		nTotIva		:=0
		//		nTotsIva    :=0
		//		nTotTotal	:=0
		//		nTotCanSt	:=0
		//		nTotTotSt	:=0
		/*
		cNumPedido	:=IS2->C7_NUM
		cSector		:=IS2->C7_CC
		*/
		
	Endif
	//If Empty(_cDescri)
	_cDescri := Posicione("SB1",1,Xfilial("SB1")+IS2->C7_PRODUTO,"B1_DESC")
	//EndIf
	_nRenglon1 :=  mlcount(Alltrim(_cDescri),40)
	_aDescrip	:= Array(4)
	for nx := 1 to _nrenglon1
		If nx == 1
			_aDescrip[nx] := substr(_cDescri,1,40)
		elseIf nx == 2
			_aDescrip[nx] := substr(_cDescri,41,40)
		ElseIf nx == 3
			_aDescrip[nx] := substr(_cDescri,82,40)
		ElseIf nx == 4
			_aDescrip[nx] := substr(_cDescri,123,40)
		endIf
	Next
	_nRenglones	:= _nRenglon1
	nvalmerc	:= Is2->C7_TOTAL  // TOTAL DEL Pedido
	nTotTotSt	:= 0
	nValDesc	:= nvalmerc	- (nvalmerc * IS2->C7_DESC1 / 100)  // MERCADERIA MENOS DESCUENTO 1
	nvaldesc	:= nvaldesc	- (nvaldesc	* IS2->C7_DESC2 /100 ) // Mercaderia con los dos descuentos
	nvalFin		:= nvaldesc	- (nvaldesc	* IS2->C7_DESC3 /100 )
	nDesctot	+= nvaldesc - nvalfin    // el descuento a aplicar sera la diferencia entre los dos
	nTotTotSt	:=	nTotTotSt + (nValDesc)  // sumo al total el valor de la mercaderia menos el decuento 1 y 2
	
	Crea_Item(_nRenglon1)
	oPrn:Say( nLin, 0010, IS2->C7_PRODUTO,oFont10,070 )
	oPrn:Say( nLin, 0310,Space(1) + _aDescrip[1] ,oFont10,070 )
	oPrn:Say( nLin, 1245, TRANSFORM(IS2->C7_QUANT,"@E 99999999.99"),oFont10,070 )
	oPrn:Say( nLin, 1535, IS2->C7_UM,oFont10,070 )
	oPrn:Say( nLin, 1630, TRANSFORM(IS2->C7_PRECO,"@E 999,999.99"),oFont10,070 )
	oPrn:Say( nLin, 1905, TRANSFORM(IS2->C7_DESC1,"@E  99.99"),oFont10,070 )
	oPrn:Say( nLin, 2105, TRANSFORM(IS2->C7_DESC2,"@E 99.99"),oFont10,070 )
	oPrn:Say( nLin, 2305, TRANSFORM(IS2->C7_DESC3,"@E 99.99"),oFont10,070 )
	oPrn:Say( nLin, 2505, TRANSFORM((IS2->C7_TOTAL *(1-(IS2->C7_DESC1/100))*(1-(IS2->C7_DESC2/100))),"@E 99,999,999.99"),oFont10,070 )
	oPrn:Say( nLin, 2760, TRANSFORM(If(IS2->C7_ALQIMP2<>0,IS2->C7_ALQIMP2,IS2->C7_ALQIMP1),"@E 99.99"),oFont10,070 )
	oPrn:Say( nLin, 2921, substr(IS2->C7_DATPRF,7,2) + "/" +substr(IS2->C7_DATPRF,5,2)+ "/"+ substr(IS2->C7_DATPRF,1,4),oFont10,070 )
	nLin:= nLin + 50
	If !empty(_aDescrip[2])
		oPrn:Say( nLin, 0200, _aDescrip[2] ,oFont10,070 )
		nLin := nLin +50
	endIf
	If !empty(_aDescrip[3])
		oPrn:Say( nLin, 0200, _aDescrip[3] ,oFont10,070 )
		nLin := nLin +50
	endIf
	If !empty(_aDescrip[4])
		oPrn:Say( nLin, 0200, _aDescrip[4] ,oFont10,070 )
		nLin := nLin +55
	endIf
	
	nTotCantidad:=	nTotCantidad + IS2->C7_QUANT
	_cObserv	:= Alltrim(is2->C7_OBS) + " "
	
	
	
	nTotsIva		:= nTotsIva + (nValDesc)
	nTotCanSt	:=	nTotCanSt + IS2->C7_QUANT
	If IS2->C7_ALQIMP2 <> 0
		nTotIva		:=	nTotIva + (IS2->C7_TOTAL *(1-(IS2->C7_DESC1/100))*(1-(IS2->C7_DESC2/100))*(IS2->C7_ALQIMP2/100))
	ELSEIF  IS2->C7_ALQIMP1 <> 0
		nTotIva		:=	nTotIva + (IS2->C7_TOTAL *(1-(IS2->C7_DESC1/100))*(1-(IS2->C7_DESC2/100))*(IS2->C7_ALQIMP1/100))
	ENDiF
		If IS2->C7_ALQIMP6 <> 0
		nTotIIBB		:=	nTotIIBB + (IS2->C7_TOTAL *(1-(IS2->C7_DESC1/100))*(1-(IS2->C7_DESC2/100))*(IS2->C7_ALQIMP6/100))
	ELSEIF  IS2->C7_ALQIMP7 <> 0
		nTotIIBB		:=	nTotIIBB + (IS2->C7_TOTAL *(1-(IS2->C7_DESC1/100))*(1-(IS2->C7_DESC2/100))*(IS2->C7_ALQIMP7/100))
	ENDiF
	nTotTotal   :=   nTotsIva + nTotIva
	nDesctot	:= nTotTotal * (IS2->C7_DESC3 /100)
	

	Dbselectarea("IS2")
	Dbskip()
	
End

Crea_Pie()
oPrn:EndPage()

//crear nueva pagina y poner el lugar de entrega
If mv_par01 == mv_par02
	If !Empty( aLugarEnt )
		LugarEnt()
	EndIf
EndIf
//

Dbselectarea("IS2")
DbCloseArea()

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ Crea_Item    ³ Autor ³ Skiddoo			³ Data ³ 25.06.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip   ³ Proceso para impresion de pagina Estandar                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/

Static Function Crea_Item(_nRenglones)
cArea:=GetArea()
oPrn:Box( nLin, 0005,nLin+50* _nRenglones,1240 )
oPrn:Box( nLin, 1240,nLin+50* _nRenglones,1530 )
oPrn:Box( nLin, 1530,nLin+50* _nRenglones,1625 )
oPrn:Box( nLin, 1625,nLin+50* _nRenglones,1895 )
oPrn:Box( nLin, 1895,nLin+50* _nRenglones,2095 )
oPrn:Box( nLin, 2095,nLin+50* _nRenglones,2295 )
oPrn:Box( nLin, 2295,nLin+50* _nRenglones,2495 )
oPrn:Box( nLin, 2495,nLin+50* _nRenglones,2750 )
oPrn:Box( nLin, 2750,nLin+50* _nRenglones,2910 )
oPrn:Box( nLin, 2910,nLin+50* _nRenglones,3150 )
RestArea(cArea)
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ Crea_Pie     ³ Autor ³ Skiddoo			³ Data ³ 25.06.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip   ³ Proceso para impresion de pagina Estandar                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/

Static Function Crea_Pie()
Local _aDiasCp	:={}  // array para guardar los dias de la condicion de pago
Local _aDescCp	:= {} // Array para guardar los descuentos de la condicion de pago
Local _cDias	:= " "
Local _cDesc	:= " "
Local _nStartDias	:= 0
Local _nEndDias		:= 0
Local _nstartDesc	:= 0
Local _nEndDesc		:= 0
//Local _cCondicion	:=" "

nLin += 50

oPrn:Say( nLin, 0010, " Moneda: ",oFont10,100 )
oPrn:Say( nLin,0160 , GETMV("MV_SIMB"+alltrim(_cmoeda)) + " " +GETMV("MV_MOEDAP"+Alltrim(_cmoeda)) ,oFont10b,100 )
oPrn:Say( nLin, 2005, " Subtotal ",oFont10b,100 )
oPrn:Box( nLin, 2005,nLin+55,2900 )//SubTotal
oPrn:Say( nLin, 2570, TRANSFORM(nTotsIva,"@E 99,999,999.99"),oFont10b,100 )
oPrn:Say( nLin, 2310, GETMV("MV_SIMB"+alltrim(_cmoeda)),oFont10b,100 )
nLin:=nLin + 55

oPrn:Say( nLin, 2005, " Ingresos Brutos: ",oFont10b,100 )
oPrn:Box( nLin, 2005,nLin+55,2900 )// Total
oPrn:Say( nLin, 2310, GETMV("MV_SIMB"+alltrim(_cmoeda)),oFont10b,100 )
oPrn:Say( nLin, 2570, TRANSFORM(nTotIIBB,"@E 99,999,999.99"),oFont10b,100 )
nLin:=nLin + 55
oPrn:Say( nLin, 2005, " Iva ",oFont10b,100 )
oPrn:Box( nLin, 2005,nLin+55,2900 )//Iva
oPrn:Say( nLin, 2310, GETMV("MV_SIMB"+alltrim(_cmoeda)),oFont10b,100 )
oPrn:Say( nLin, 2570, TRANSFORM(nTotIva,"@E 99,999,999.99"),oFont10b,100 )
nLin:=nLin + 55
oPrn:Say( nLin, 2005, " Total ",oFont10b,100 )    
oPrn:Say( nLin, 2310, GETMV("MV_SIMB"+alltrim(_cmoeda)),oFont10b,100 )
oPrn:Say( nLin, 2570, TRANSFORM(nTotTotal - nDesctot ,"@E 99,999,999.99"),oFont10b,100 )
oPrn:Box( nLin, 2005,nLin+55,2900 )// Total

//cCondicion:=Posicione("SE4",1,Xfilial("SE4")+ is2->C7_COND,"E4_DESCRI")

nLin	:= 1880
oPrn:Say( nLin, 0005, " Condición de pago: "+_cCondicion ,oFont10,100 )
//oPrn:Say( nLin, 0400, _cCondicion,oFont10,100 )
nLin	:= 1930
oPrn:Say( nLin, 0005, " Horario de recepción: De Lunes a Viernes de 08:00 a 11:30 y de 13:00 a 16:30" ,oFont10,100 )
nLin	:= 1980
oPrn:Say( nLin, 0005, " Observaciones: " ,oFont10,100 )
nLin := 2030    //Leyenda               
oPrn:Say( nLin, 0010, _cXobserv ,oFont10,100 )
oPrn:Say( nLin, 2500, Replicate("_",25) ,oFont10,100 )
oPrn:Say( nLin+50,2600, "Firma y Sello" ,oFont10,100 )
oPrn:Box( nLin, 0005 ,nLin+200,2400 )// Total
nLin += 250    //Leyenda
oPrn:Say( nLin, 0010,"Impreso por: "+ cusername ,oFont10,100 )
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ Crea_PAgina  ³ Autor ³ Skiddoo			³ Data ³ 25.06.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip   ³ Proceso para impresion de pagina Estandar OP               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/

Static Function Crea_Pagina()
cArea:=GetArea()

nLin:=050
oPrn:SayBitmap( 000,0050,cBitMap,250,250)
//oPrn:Box( nLin, 2480,100,3150 )
oPrn:Say( nLin, 0300, AllTrim( SM0->M0_NOMECOM ), oFont11b, 100 )
//oPrn:Say( nLin, 2050, "Tel.: ( "+substr(SM0->M0_TEL,1,3) + ")" + Substr(SM0->M0_TEL,4,10) ,oFont08,100 )
oPrn:Say( nLin, 2520, iif(IS2->C7_CONAPRO=='L',"ORDEN DE COMPRA","PEDIDO PENDIENTE AUTORIZACION"),oFont12b,100)
nLin:=110 
oPrn:Say( nLin , 0300, "DOMICILIO LEGAL: " + AllTrim( SM0->M0_ENDENT ) , oFont08,100)
//oPrn:Say( nLin , 0850, "DOM. COMERCIAL: " + AllTrim( SM0->M0_ENDCOB ), oFont10, 100)
oPrn:Say( nLin, 0850, "Tel.: ( "+substr(SM0->M0_TEL,1,4) + ")" + Substr(SM0->M0_TEL,5,10),oFont08,100 )
oPrn:Say( nLin, 1100, "Fax.: ("+substr(SM0->M0_FAX,1,4) + ")"+ substr(SM0->M0_FAX,5,10),oFont08,100 )
oPrn:Say( nLin, 1900, "Nro: ",oFont12b,100)
//oPrn:Box( nLin, 2650,150,2850 )
oPrn:Say( nLin, 2700, IS2->C7_NUM,oFont12b,100)
cFecha:=Substr(IS2->C7_EMISSAO,7,2)+"/"+Substr(IS2->C7_EMISSAO,5,2)+"/"+Substr(IS2->C7_EMISSAO,1,4)
oPrn:Say( nLin+50, 2520, "Emisión: ",oFont12b,100)
oPrn:Say( nLin+50, 2700, cFecha,oFont12b,100)
//oPrn:Box( nLin, 2900,150,3150 )
nLin:=170     
oPrn:Say( nLin , 0300,  AllTrim( SM0->M0_CEPENT ) + " - C.A.B.A.", oFont08, 100 )
//oPrn:Say( nLin , 0700,  AllTrim( SM0->M0_CEPCOB ) + " -  CIUDAD AUTONOMA DE BUENOS AIRES", oFont08, 100 )


nLin:=250
oPrn:Box( nLin, 0005,nLin+300,2390 )
//oPrn:Box( nLin, 0900,nLin+90,1450 )
//oPrn:Box( nLin, 1450,nLin+300,2390 )
oPrn:Box( nLin, 2390,nLin+300,3150 )
nLin:=260

Dbselectarea("SA2")
Dbsetorder(1)
Dbgotop()
//_cxObserv	:= IS2->C7_XOBSCAB
Dbseek(xFilial("SA2")+IS2->C7_FORNECE+IS2->C7_LOJA)
oPrn:Say( nLin, 0110, SA2->A2_COD + "/" + SA2->A2_LOJA,oFont10,100 )
//oPrn:Say( nLin, 0920, "OBRA: "+SubStr(Posicione("CTT",1,Xfilial("CTT")+ IS2->C7_CC,"CTT_DESC01"),1,17),oFont09,70 )
//oPrn:Say( nLin, 0920, "Centro de Costo: "+IS2->C7_CC,oFont09,70 )
//oPrn:Say( nLin, 2410, "CUIT "+TRANSFORM(SM0->M0_CGC,"@R 99-99999999-9"),oFont10,100 )
oPrn:Say( nLin, 2410, "Comprador: ",oFont10,100 )
nLin:=300                                         
oPrn:Say( nLin, 2410, BuscaUser(is2->C7_user,1),oFont11,100 )
//oPrn:Box( nLin, 2390,nLin+130,3150 )
oPrn:Say( nLin, 0110, SA2->A2_NOME,oFont11,100 )
//_nRenglon2 := mlcount(Alltrim(IS2->C7_LUGENT),25)
//_aLugEnt 	:= array(4)
//_cLugEnt	:=	IS2->C7_LUGENT


/*
If empty(Is2->C7_LUGENT)
	_aLugEnt [1] := " "
endIf

for nx := 1 to _nrenglon2
	If nx == 1
		_aLugEnt[nx] := substr(_cLugEnt,1,25)
	elseIf nx == 2
		_aLugEnt[nx] := substr(_cLugEnt,26,25)
	ElseIf nx == 3
		_aLugEnt[nx] := substr(_cLugEnt,52,25)
	ElseIf nx == 4
		_aLugEnt[nx] := substr(_cLugEnt,78,25)
	endIf
Next*/

_cCondicion	:=	Posicione("SE4",1,Xfilial("SE4")+ is2->C7_COND,"E4_DESCRI")

//oPrn:Say( nLin, 1500, _aLugEnt[1] ,oFont10,070 )
//oPrn:Say( nLin, 0920, "OBRA: "+TRANSFORM(IS2->C7_CC,"99999 / 9999"),oFont09,70 )
//oPrn:Say( nLin, 0920, SubStr(Posicione("CTT",1,Xfilial("CTT")+ IS2->C7_CC,"CTT_DESC01"),18,23),oFont09,70 )
//oPrn:Say( nLin, 2410, "Condición de pago: ",oFont10,100 )
nLin:=340
oPrn:Say( nLin, 0110, SA2->A2_NREDUZ,oFont10,100 )
//oPrn:Say( nLin, 0920, POSICIONE("CTD",1,xFILIAL("CTD")+IS2->C7_ITEMCTA,"CTD_DESC01"),oFont10,100 )
oPrn:Say( nLin+10, 2410, "Contacto: ",oFont10,100 )
oPrn:Say( nLin+50, 2410, IS2->c7_CONTATO,oFont11,100 )
//oPrn:Say( nLin, 2410, SubStr(_cCondicion,1,40),oFont10,100 )
//oPrn:Say( nLin+55, 2410, SubStr(_cCondicion,41,40),oFont10,100 )
/*
If !empty(_aLugEnt[2])
	oPrn:Say( nLin, 1500, _aLugEnt[2] ,oFont10,070 )
endIf
*/
nLin:=380
//oPrn:Box( nLin+55, 2390,nLin+170,3150 )
oPrn:Say( nLin, 0110, ALLTRIM( SA2->A2_END ) + " - C.P.: "+SA2->A2_CEP,oFont11,100 )
oPrn:Say( nLin+55, 2410, "Solicitante: ",oFont10,100 )
/*
If !empty(_aLugEnt[3])
	oPrn:Say( nLin, 1500, _aLugEnt[3] ,oFont11,070 )
endIf
*/
nLin:=420
oPrn:Say( nLin+55, 2410, BuscaUser(Posicione("SC1",1,Xfilial("SC1")+is2->C7_NUMSC,"C1_SOLICIT"),2),oFont11,100 )
oPrn:Say( nLin, 0110, tABELA("12",SA2->A2_EST),oFont11,100)
//oPrn:Say( nLin, 0110, Iif( !Empty( SA2->A2_BAIRRO ), Alltrim( SA2->A2_BAIRRO ), '' ) + Iif( !Empty( SA2->A2_MUN ) .and. !Empty( SA2->A2_BAIRRO ), ' - ', '' ) + Iif( !Empty( SA2->A2_MUN ), Alltrim( SA2->A2_MUN ), '' ) ,oFont09b,100 )
nLin:=460                 

oPrn:Say( nLin, 0110, "Tel.: "+substr(SA2->A2_XTEL,1,50),oFont11,100 )
oPrn:Say( nLin, 0610, "Fax.: "+substr(SA2->A2_FAX ,1,50),oFont11,100 )
nLin:=500
oPrn:Say( nLin, 0110, "Email.: "+SA2->A2_EMAIL,oFont11,100 )
//oPrn:Box( nLin, 1450,nLin+50,2390 )
//oPrn:Say( nLin, 1500, "Horario de Recepcion: De L. A V. De 07:00 A 12:00 y de 13:00 a 15:30 ",oFont07,100 )
nLin:=540
//oPrn:Say( nLin, 0000, Replicate("_",190),oFont11b,100)
nLin:=550
oPrn:Box( nLin, 0005,nLin+50,1240 )
oPrn:Box( nLin, 1240,nLin+50,1530 )
oPrn:Box( nLin, 1530,nLin+50,1625 )
oPrn:Box( nLin, 1625,nLin+50,1895 )
oPrn:Box( nLin, 1895,nLin+50,2095 )
oPrn:Box( nLin, 2095,nLin+50,2295 )
oPrn:Box( nLin, 2295,nLin+50,2495 )
oPrn:Box( nLin, 2495,nLin+50,2750 )
oPrn:Box( nLin, 2750,nLin+50,2910 )
oPrn:Box( nLin, 2910,nLin+50,3150 )
//oPrn:Box( nLin, 1950,nLin+60,2350 )

nLin:=550
oPrn:Say( nLin, 0010, "Producto",oFont09,070 )
//oPrn:Say( nLin, 1300, "Cod. Fabricante",oFont09,070 )
oPrn:Say( nLin, 1245, "Cantidad",oFont09,070 )
oPrn:Say( nLin, 1535, "Uni",oFont09,070 )
oPrn:Say( nLin, 1630, "Prc Unit",oFont09,070 )
oPrn:Say( nLin, 1900, "%Desc1",oFont09,070 )
oPrn:Say( nLin, 2100, "%Desc2",oFont09,070 )
oPrn:Say( nLin, 2300, "%Desc3",oFont09,070 )
oPrn:Say( nLin, 2500, "Total",oFont09,070 )
oPrn:Say( nLin, 2755, "%IVA",oFont09,070 )
oPrn:Say( nLin, 2921, "Entrega",oFont09,070 )



//---------
nNumHoja := nNumHoja + 1
//---------




//-------Agrego Seryo por definicion en la planilla
oPrn:Say( 3200, 0110, 'Hoja Nº ' + Alltrim( Str( nNumHoja ) ) + '    ' + 'Fecha de Impresion: ' + DToC( Ddatabase ),oFont09,100 )
//-------Agrego Seryo

/*
oPrn:Say( nLin, 1610, "Desc",oFont10b,100 )
oPrn:Say( nLin, 1810, "Importe",oFont10b,100 )
*/

RestArea(cArea)
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ Crea_PAgina  ³ Autor ³ Skiddoo			³ Data ³ 25.06.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip   ³ Proceso para impresion de pagina Estandar OP               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/

Static Function Crea_PagEnt()
cArea:=GetArea()
nLin:=200
oPrn:SayBitmap( 200,1800,cBitMap,200,150 )
oPrn:Say( nLin, 0400, "HOJA ADJUNTA DEL PEDIDO ",oFont12B,100)
oPrn:Say( nLin, 1400, "N°",oFont12b,100)
oPrn:Box( nLin, 1480,250,1700 )
oPrn:Say( nLin, 1520, cNumPedido,oFont12b,100)
nLin:=260
oPrn:Box( nLin, 0100 ,nLin+4,1800 )

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ Crea_PAgina  ³ Autor ³ Skiddoo			³ Data ³ 25.06.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip   ³ Proceso para impresion de pagina Estandar OP               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/

Static Function LugarEnt()

Crea_PagEnt()
nLin:=300
For nS := 1 To Len( aLugarEnt )
	If nLin <= 2650
		oPrn:Say( nLin, 0110, 'El lugar de entrega para los items ' + aLugarEnt[nS][1] + ' es ' + aLugarEnt[nS][2], oFont09, 100 )
		nLin := nLin + 50
	Else
		oPrn:EndPage()
		Crea_PagEnt()
		nLin:=300
	EndIf
Next nS


Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ Prreguntas ³ Autor ³ Skiddoo				³ Data ³ 25.06.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip   ³ Proceso para creacion de preguntas en el archivo SX1       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/

Static Function Preguntas()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PADR(cPerg,10)

aAdd(aRegs,{cPerg,"01","","De Pedido 	?","","mv_ch1","C",6,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC7"})
aAdd(aRegs,{cPerg,"02","","A Pedido 	?","","mv_ch2","C",6,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC7"})

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

DbSelectArea(_sAlias)

Return      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPRESION PEDIDOºAutor  ³Microsiga           º Data ³  05/27/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Buscauser(_cUsuario,n)
Local _cNombre	:= " "
Local _aUsuarios	:= Allusers()
For nx:= 1 to len(_aUsuarios)
	If _cUsuario == _aUsuarios[nx][1][n]
		_cNombre	:= _aUsuarios[nx][1][4]
	EndIf
Next
Return _cNombre
