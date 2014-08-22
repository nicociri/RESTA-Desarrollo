#include "protheus.ch"
#INCLUDE "rwmake.ch"

#define CRLF Chr(13)+Chr(10)



///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | A410CONS()   		| AUTOR | MC	| DATA 		   | 18/08/2008 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - CreateArchPed()                                           |//
//|           | Funcao de escritura archivo 					                |//
//|           |                                          						|//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

user function createArchPed() 

Local   lRet		:= .T.
Local 	aArea		:= GetArea()
Local   nx			:= 0
Private	cText		:=""
Private aHeaderAux 	:= aClone(aHeader)
Private aColsAux	:= aClone(aCols)
Private cStartPath	:= GetSrvProfString("Startpath","")
Private cFileLog	:= cStartPath+"pedven" + cEmpAnt + ".txt"
Private lEnd 		:= .F.
Private nHandle		:= nErase := 0
Private nPosPrd  	:= aScan(aHeaderAux,{|x| AllTrim(x[2])=="C6_PRODUTO"})           	// Producto
Private nPItem		:= aScan(aHeaderAux,{|x| AllTrim(x[2])=="C6_ITEM" })            	// item
Private nPQtdVen  	:= aScan(aHeaderAux,{|x| AllTrim(x[2])=="C6_QTDVEN" })         		// cant. vendida
Private nPPrcVen 	:= aScan(aHeaderAux,{|x| AllTrim(x[2])=="C6_PRCVEN" })        		// Precio venta (con descuento) 
Private nPDescont	:= aScan(aHeaderAux,{|x| AllTrim(x[2])=="C6_DESCONT" })     		// % descuento
Private nPValDesc	:= aScan(aHeaderAux,{|x| AllTrim(x[2])=="C6_VALDESC" })   	  		// valor descuento
Private nPPrUnit	:= aScan(aHeaderAux,{|x| AllTrim(x[2])=="C6_PRUNIT" })    	 		// Precio Lista
Private nPLinea		:= aScan(aHeaderAux,{|x| AllTrim(x[2])=="C6_PRODUTO" })    	 		// Linea Producto
Private nPValor		:= aScan(aHeaderAux,{|x| AllTrim(x[2])=="C6_VALOR" })     			// valor total
Private nPTES     	:= aScan(aHeaderAux,{|x| AllTrim(x[2])=="C6_TES"})        			// Tes
Private nPNfOri   	:= aScan(aHeaderAux,{|x| AllTrim(x[2])=="C6_NFORI"})      			// factura Original
Private nPSerOri  	:= aScan(aHeaderAux,{|x| AllTrim(x[2])=="C6_SERIORI"})    			// Serie Origen
Private nPItemOri 	:= aScan(aHeaderAux,{|x| AllTrim(x[2])=="C6_ITEMORI"})    			// Item Origen
Private nPIdentB6 	:= aScan(aHeaderAux,{|x| AllTrim(x[2])=="C6_IDENTB6"})   			//  ident.
Private nPDescri 	:= aScan(aHeaderAux,{|x| AllTrim(x[2])=="C6_DESCRI"})				// Descripcion
Private nTotBruto := nTotDes :=nTotQT :=0

// Valida seleccion de Cliente 
If Empty(M->C5_CLIENTE)
	MsgAlert("Debe seleccionar el Cliente") 
	Return(.F.)
Endif

// Debe existir al menos 1 registro
if n==len(aColsAux) .and. aColsAux[n][Len(aHeaderAux)+1]
     MsgAlert("Sin Items para mostrar") 
     Return(.F.)
endif

// obligatoriedad campos
for nx:=1 to Len(aColsAux)
	if !(lret := MaCheckCols(aHeaderAux,aColsAux,nx)) .and. !aColsAux[nx][Len(aHeaderAux)+1]
 	    Return(lret)
	endif
Next

CAbecArch()    							// imprime cabecera
                                 
MsAguarde({|lEnd| RunItems(@lEnd)},"Aguarde...","Processando Items",.T.)     // imprime detalle


CalculoImpos()   															// imprime impuestos y totales


VerArchivo()     															// ver archivo
                                
RestArea(aArea)
Return(lRet)         
           
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | CreateArch()   		| AUTOR | MC	| DATA 		   | 18/08/2008 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - FileWrite()                                            |//
//|           | Funcao de escritura archivo 					                |//
//|           |                                          						|//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function FileWrite(cText,nHandle,lFin)

DEFAULT lFin:=.F.

//Se tamanho do texto for maior que 200 bytes grava no arquivo texto 
If ((Len(cText)>200) .OR. (lFin))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Escreve arquivo de Log.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FWrite(nHandle, cText) 
	cText := ""
Endif

If lFin
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Fecho arquivo para poder move-lo.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FWrite(nHandle, replicate("_",115)+ CRLF)
	FClose(nHandle)                          
Endif

Return NIL      


///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | createArch()   | AUTOR | MC		  | DATA 		   | 18/08/2008 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - CreateLog()                                            |//
//|           | Funcao de processamento							                |//
//|           |                                          						|//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function CabecArch()

local   aAreaSX3	:= GetArea("SX3")
Local 	aDescMon   	:= {GetMV( "MV_MOEDA1" ), ;
                      	GetMV( "MV_MOEDA2" ), ;
                      	GetMV( "MV_MOEDA3" ), ;
                      	GetMV( "MV_MOEDA4" ), ;
                      	GetMV( "MV_MOEDA5" ) }
Local cMoneda		:= ""
local nCnt			:= 0
Local cNomCli		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria novo Log³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
If !File(cFileLog)
	nHandle := FCREATE(cFileLog,1)
Else
	nErase := FERASE(cFileLog)   
	While nErase = -1 
		nErase := FERASE(cFileLog)
	End
	nHandle := FCREATE(cFileLog,1)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cabecera Log³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SX3")
DbSetOrder(2)
If MsSeek("C5_NUM")
	cText += PADL(Alltrim(X3TITULO())+" Pedido : "	+ M->C5_NUM ,110) 	+ CRLF
Endif
If MsSeek("C5_CLIENTE")
	cNomCli:=Posicione("SA1",1,xfilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_NOME") 	
	cText += X3TITULO()+" : "+ M->C5_CLIENTE +"-"+cNomCli+"  "	
Endif
If MsSeek("C5_EMISSAO")
	cText += PADL(X3TITULO()+"  : "+ DTOC(M->C5_EMISSAO )	+ "  " ,40)   + CRLF
Endif
cCondPag := POSICIONE("SE4",1,xFilial("SE4")+M->C5_CONDPAG,"E4_DESCRI")
If MsSeek("C5_CONDPAG")
	cText += X3TITULO()+" : " + cCondPag 
Endif
cMoneda  := aDescMon[ If( Empty( M->C5_MOEDA ), 1, M->C5_MOEDA ) ]
If MsSeek("C5_MOEDA")
	cText += PADL(X3TITULO()+"  : " + cMoneda	+ space(10) ,73) + CRLF
Endif

/*If MsSeek("C5_DESC1")
	cText += X3TITULO()+" : " + StrTran(Str(M->C5_DESC1,5,2),".",",") + CRLF
Endif*/

If MsSeek("C5_DESCFI")
	cText += X3TITULO()+" : " + StrTran(Str(M->C5_DESCFI,5,2),".",",") + CRLF
Endif                  
If MsSeek("C5_DIADESC")
	cText += X3TITULO()+" : " + StrTran(Str(M->C5_DIADESC,2,0),".",",") + CRLF
Endif

If MsSeek("C5_MENREM1")
	cText += X3TITULO()+" : " + M->C5_MENREM1 + CRLF
Endif
If MsSeek("C5_MENREM2")
	cText += X3TITULO()+" : " + M->C5_MENREM2 + CRLF
Endif
If MsSeek("C5_MENNOTA")
	cText += X3TITULO()+" : " + M->C5_MENNOTA + CRLF
Endif
If MsSeek("C5_OC")
	cText += X3TITULO()+" : " + M->C5_OC + CRLF
Endif
RestArea(aAreaSx3)

cText += "                                            D E T A L L E   D E L   P E D I D O                                    "	+ CRLF 
cText += "___________________________________________________________________________________________________________________"	+ CRLF
cText += "PRODUCTO    DESCRIP.     CANT  P.UNIT. % DESC  % DESC  % DESC  % DESC   P.UNIT     IMPORTE     IMPORTE     IMPORTE "	+ CRLF
cText += "                               S/DESC  COMERC. GRILLA   ADIC.  TOTAL    C/DESC      BRUTO       DESC.       NETO   "	+ CRLF
cText += "___________________________________________________________________________________________________________________"	+ CRLF

FileWrite(@cText,nHandle)

Return NIL

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | createArch()   | AUTOR | MC		  | DATA 		   | 18/08/2008 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - RunItems()                                             |//
//|           | Funcao de processamento							                |//
//|           |                                          						|//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function RunItems(lEnd)

Local nLenAux 	:= Len(aColsAux)
Local nI		:= 1
Local _cCpo		:="" 
local _cLin    	:= Space(125)+CRLF
Local _cLineaAnt:= space(4)
Local cNomLin   := space(45)
Local _cDescr	:= space(15)
local nSubtPrcV := nSubTValDesc := nSubTPrUnit 	:= nSubTValor 	:= nSubTQtd := nSubtDesc :=nSubtBruto :=0
Local nDescCom	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})
Local nDesPub    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})//Descuento por Publicidad
Local nDesVol    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})//Descuento por Volumen
Local nDesExc    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})//Descuento por Exclusividad
Local nDesBon    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})//Descuento por Bonificacion
Local nqtdped	 := Ascan(aHeader,{|x| AllTrim(x[2]) =="C6_QTDVEN"})//Cantidad Pedida
Local nqtdven	 := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDENT"})//Cantidad a Entregar
Local nqtdadic	 := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDLIB"})//Cantidad Adicional
Local nqtdbon	 := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDLIB"}) //Cantidad Bonificada
Local ngdesc2	 := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_DESCONT"})//Descuento Adicional
Local nDesc1:=nDesc2:=nDesc3:=nDesc4:=nDesc5:=nDesc6:=nDescG:=nDesto:=nDesTot:=nDesTot1:=nDesTot2:=nDesTot3:=0

// Ordena array por Linea Producto    
ASort( aColsAux, , , { |x,y| y[nPLinea]+y[nPDescri] > x[nPLinea]+x[nPDescri] } ) 

While nI <= nLenAux  
	
	_cLineaAnt :=	aColsAux[nI][nPLinea]//Codigo de Linea de Negocio
	cNomLin    :=	"---"//Posicione("ZZ4",1,xfilial("ZZ4")+aColsAux[nI][nPLinea],"ZZ4_NOME")	//Linea de Negocio
	nSubtPrcV  := 	nSubTValDesc := nSubTPrUnit := nSubTValor := nSubTQtd :=nSubtDesc :=nSubtBruto :=0
	
	If !aColsAux[nI][Len(aHeaderAux)+1]
		cText += PADR("LINEA : "+cNomLin+"   ",20) + CRLF
		FileWrite(@cText,nHandle)
	Endif
		
	While Ni <= nLenAux .and. _cLineaAnt == aColsAux[nI][nPLinea]
		
		If lEnd
				cText += "************Cancelado por el operador*************"
				FileWrite(@cText,nHandle,.T.)
				Exit
		Endif
				
		If !aColsAux[nI][Len(aHeaderAux)+1] // Valida item deleteado.
	    						
			 _cDescr:= Posicione("SB1",1,xFilial("SB1")+aColsAux[nI][nPosPrd],"B1_DESC")

				nDesc1:=100-aColsAux[nI][nDesPub]						//Descuento Publicidad
				nDesc2:=nDesc1-(nDesc1*aColsAux[nI][nDesVol]/100)      //Descuento Volumen
				nDesc3:=nDesc2-(nDesc2*aColsAux[nI][nDesExc]/100)      //Descuento Pretemporada
				nDesc4:=nDesc3-(nDesc3*aColsAux[nI][nDesBon]/100)      //Descuento Bonificacion
				nDescG:=100-nDesc4            //Descuento de la Grilla
				
				nDesc5:=100-aColsAux[nI][ngdesc2] //Descuento Adicional
				nDesc6:= 0//nDesc5-(nDesc5*((1-((aColsAux[nI][nqtdped]+aColsAux[nI][nqtdbon])/aColsAux[nI][nqtdven]))*100)/100)//descuento de cantidad adicional
				nDesto:=100-nDesc6 //Descuentos Adicionales
			    
				nDesTot1:=100 - nDesto //Descuentos Adicionales
				nDesTot2:= 0 //nDesTot1-(nDesTot1*nDescG/100) //Descuento Total de la Grilla
				nDesTot3:= 0 //nDesTot2-(nDesTot2*aColsAux[nI][nDescCom]/100)//Descuento Comercial				
				nDesTot:= 100-nDesTot3			//Descuento Total	
				
				
			AddItemArch(	aColsAux[nI][nPosPrd],;   //Codigo de Producto
							_cDescr,;                  //Descripcion
							aColsAux[nI][nPQtdVen],;   //Cantidad
							aColsAux[nI][nPPrUnit],;   //Precio de Lista
			 				aColsAux[nI][nDescCom],;   //Descuento Comercial
			 				nDescG,;                    //Descuento de Grilla
			 				nDesto,;                    //Descuento Adicional
			 				nDesTot,;                   //Descuento Total
			 				aColsAux[nI][nPPrcVen],;    //Precio unitario c/descuento
			 				aColsAux[nI][nPQtdVen]*aColsAux[nI][nPPrUnit],;   //Precio total sin descuento
			 				(aColsAux[nI][nPQtdVen]*aColsAux[nI][nPPrUnit])-aColsAux[nI][nPValor]/*aColsAux[nI][nPValDesc]*/,; //Valor de descuento
			 				aColsAux[nI][nPValor] )     //Precio total con descuento
						
			// Acumula Subtotales
			nSubTValDesc+= 	(aColsAux[nI][nPQtdVen]*aColsAux[nI][nPPrUnit])-aColsAux[nI][nPValor]
			nSubTPrUnit += 	aColsAux[nI][nPPrUnit]
			nSubTValor 	+= 	aColsAux[nI][nPValor]
			nSubtPrcV 	+=	aColsAux[nI][nPPrcVen]
		    nSubtQtd	+=	aColsAux[nI][nPQtdVen]
		    nSubtDesc	+=	aColsAux[nI][nPDescont]
		    nSubtBruto  +=  aColsAux[nI][nPQtdVen]*aColsAux[nI][nPPrUnit]
		    
		    nTotBruto	+= 	aColsAux[nI][nPQtdVen]*aColsAux[nI][nPPrUnit] 
		    nTotDes 	+=	(aColsAux[nI][nPQtdVen]*aColsAux[nI][nPPrUnit])-aColsAux[nI][nPValor]
		    nTotQt		+=	aColsAux[nI][nPQtdVen]
		Endif
		
		nI+=1
		
	Enddo
    
    if nSubTValor > 0
    	// agrega subtotales
//    	AddItemArch("S U B T O T A L","L."+trim(cNomLin),nSubTQtd,nSubtPrcV,nSubtDesc,;
//			 								nSubTValDesc,nSubTPrUnit,nSubTValor )
    	//AddItemArch("S U B ","T O T A L. "+trim(cNomLin),0,0,0,0,0,;
		//	 								0,0,nSubTValor )
		_cCpo := "                     "//+left(cNomLin,11)							// Producto
		_clin := Stuff(_clin,1,23,_cCpo)                           // 01--07
		_cCpo := PADR(space(1),1)
		_clin := Stuff(_clin,24,1,_cCpo)
		
		_cCpo := StrTran(Str(nSubtQtd,5,0),".",",")    				// Cantidad
		_clin := Stuff(_clin,24,5,_cCpo)                            // 97--109
		_cCpo := PADR(space(1),1)
		_clin := Stuff(_clin,25,1,_cCpo)
		
		_cCpo := StrTran(Str(nSubtBruto,12,2),".",",")  				//  Importe Bruto
		_clin := Stuff(_clin,80,12,_cCpo)                            //  89--101
		_cCpo := PADR(Space(1),1)
		_clin := Stuff(_clin,93,1,_cCpo)

		_cCpo := StrTran(Str(nSubTValDesc,10,2),".",",")   				//valor descuento
		_clin := Stuff(_clin,93,10,_cCpo)                            // 102--112
		_cCpo := PADR(Space(1),1)
		_clin := Stuff(_clin,104,1,_cCpo)
		
		
		_cCpo := StrTran(Str(nSubTValor,12,2),".",",")    				// Valor Total
		_clin := Stuff(_clin,104,12,_cCpo)                            // 97--109

		cText += _clin
		FileWrite(@cText,nHandle)
	Endif	                         
	
Enddo

Return NIL

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | createArch()	  | AUTOR | MC	  | DATA 		   | 18/03/2008 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - VerArchivo()                                           |//
//|           | Muestra archivo Resumen del procesamiento realizado             |//
//|           | 						                                        |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function VerArchivo()
Local oDlg
Local cMemo
Local oFont 
local nDel
local cMask

If Empty(cFileLog)
	msgstop("archivo "+cFileLog +" no encontrado")
	return
Endif

//DEFINE FONT oFont NAME "Bauhaus Lt Bt" SIZE 8,0   
DEFINE FONT oFont NAME "Mono AS" SIZE 6,15 

cMemo :=MemoRead(cFileLog)
	
DEFINE MSDIALOG oDlg TITLE "Previsualizacion Pedido" From 3,0 to 495,830 PIXEL    //alto,ancho  550,700

@ 5,5 GET oMemo  VAR cMemo MEMO SIZE 363,230 OF oDlg PIXEL READONLY   //290,230   (ancho,alto)
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont 

DEFINE SBUTTON  FROM 53,382 TYPE 1 ACTION  (nDel:=FERASE(cFileLog),oDlg:End()) ENABLE OF oDlg PIXEL //Salir
//DEFINE SBUTTON  FROM 80,338 TYPE 13 ACTION (cFile:=cGetFile(cMask,OemToAnsi("Salvar Como...")),If(cFile="",.t.,MemoWrite(cFile,cMemo)),oDlg:End()) ENABLE OF oDlg PIXEL //Salva e Apaga //
	
ACTIVATE MSDIALOG oDlg CENTER

Return


///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | RunItems()		  | AUTOR | MC	  | DATA 		   | 18/03/2008 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - addItemArch()                                          |//
//|           | Muestra archivo Resumen del procesamiento realizado             |//
//|           | 						                                        |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function addItemArch(cTexto1,cTexto2,nValor1,nValor2,nValor3,nValor4,nValor5,nValor6,nValor7,nValor8,nValor9,nValor10)
 
Local _cCpo		:="" 
local _nTamLin 	:= 125
local _cLin    	:= Space(_nTamLin)+CRLF
local nCol     := 1
 
_cCpo := PADR(alltrim(cTexto1),6)							// Producto
_clin := Stuff(_clin,nCol,6,_cCpo)                           // 01--07
_cCpo := PADR(space(1),1)
nCol+=6
_clin := Stuff(_clin,nCol,1,_cCpo)
nCol+=1
_cCpo := PADR(alltrim(cTexto2),15)							// desc
_clin := Stuff(_clin,nCol,15,_cCpo)                           // 08--23
_cCpo := PADR(Space(1),1)
nCol+=15
_clin := Stuff(_clin,nCol,1,_cCpo)
nCol+=1
_cCpo := StrTran(Str(nValor1,5,0),".",",")    				// cantidad
_clin := Stuff(_clin,nCol,5,_cCpo)                             // 24--33
_cCpo := PADR(Space(1),1)
nCol+=5
_clin := Stuff(_clin,nCol,1,_cCpo)
nCol+=1
_cCpo := StrTran(Str(nValor2,8,2),".",",")   				// precio venta
_clin := Stuff(_clin,nCol,8,_cCpo)                            // 34--45
_cCpo := PADR(Space(1),1)
nCol+=8
_clin := Stuff(_clin,nCol,1,_cCpo)
nCol+=1
_cCpo := StrTran(Str(nValor3,7,2),".",",")    					// % desc Comercial
_clin := Stuff(_clin,nCol,07,_cCpo)                             // 46--53
_cCpo := PADR(Space(1),1)
nCol+=7
_clin := Stuff(_clin,nCol,1,_cCpo)
nCol+=1
_cCpo := StrTran(Str(nValor4,7,2),".",",")    					// % desc Grilla
_clin := Stuff(_clin,nCol,07,_cCpo)                             // 54--61
_cCpo := PADR(Space(1),1)
nCol+=7
_clin := Stuff(_clin,nCol,1,_cCpo)
nCol+=1
_cCpo := StrTran(Str(nValor5,7,2),".",",")    					// % desc Adicional
_clin := Stuff(_clin,nCol,07,_cCpo)                             // 62--69
_cCpo := PADR(Space(1),1)
nCol+=7
_clin := Stuff(_clin,nCol,1,_cCpo)
nCol+=1
_cCpo := StrTran(Str(nValor6,7,2),".",",")    					// % desc Total
_clin := Stuff(_clin,nCol,07,_cCpo)                             // 70--77
_cCpo := PADR(Space(1),1)
nCol+=7
_clin := Stuff(_clin,nCol,1,_cCpo)
nCol+=1
_cCpo := StrTran(Str(nValor7,8,2),".",",")  				//  Precio Unitario
_clin := Stuff(_clin,nCol,8,_cCpo)                            //  78--88
_cCpo := PADR(Space(1),1)
nCol+=8
_clin := Stuff(_clin,nCol,1,_cCpo)
nCol+=1
_cCpo := StrTran(Str(nValor8,12,2),".",",")  				//  Importe Bruto
_clin := Stuff(_clin,nCol,12,_cCpo)                            //  89--101
_cCpo := PADR(Space(1),1)
nCol+=12
_clin := Stuff(_clin,nCol,1,_cCpo)
nCol+=1
_cCpo := StrTran(Str(nValor9,10,2),".",",")   				//valor descuento
_clin := Stuff(_clin,nCol,10,_cCpo)                            // 101--112
_cCpo := PADR(Space(1),1)
nCol+=10
_clin := Stuff(_clin,nCol,1,_cCpo)
nCol+=1
_cCpo := StrTran(Str(nValor10,12,2),".",",")    				// Valor Total
_clin := Stuff(_clin,nCol,12,_cCpo)                            // 113--125
					
// graba item
cText += _clin 
FileWrite(@cText,nHandle)

Return NIL 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CImpArg           ºAutor  ³Fernando Bombardi   º Data ³  11/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo do Valor dos Impostos Argentina                            º±±
±±º          ³                                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RFAT001A                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CalculoImpos()

Local aArea		:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())
Local aFisGet	:= {}
Local aFisGetSC5:= {}
Local aImposto  := {}
Local nUsado    := Len(aHeaderAux)
Local nX        := 0
Local nAcerto   := 0
Local nPrcLista := 0
Local nValMerc  := 0
Local nDesconto := 0
Local nAcresFin := 0
Local nQtdPeso  := 0
Local nRecOri   := 0
Local nPosEntr  := 0
Local nItem     := 0
Local nY        := 0 
Local nPosCpo   := 0
Local cProduto  := ""
Local nTotDesc  := 0
Local nTotImp	:= 0
Local _cCpo		:="" 
local _nTamLin 	:= 125
local _cLin    	:= Space(_nTamLin)+CRLF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca referencias no SC6                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FisGetInit(@aFisGet,@aFisGetSC5)

MaFisIni(Iif(Empty(M->C5_CLIENT),M->C5_CLIENTE,M->C5_CLIENT),;	// 1-Codigo Cliente/Fornecedor
	M->C5_LOJAENT,;												// 2-Loja do Cliente/Fornecedor
	IIf(M->C5_TIPO$'DB',"F","C"),;								// 3-C:Cliente , F:Fornecedor
	M->C5_TIPO,;												// 4-Tipo da NF
	M->C5_TIPOCLI,;												// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza alteracoes de referencias do SC5         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aFisGetSC5) > 0
	dbSelectArea("SC5")
	For nY := 1 to Len(aFisGetSC5)
		If !Empty(&("M->"+Alltrim(aFisGetSC5[ny][2])))
			MaFisAlt(aFisGetSC5[ny][1],&("M->"+Alltrim(aFisGetSC5[ny][2])),,.F.)
		EndIf
	Next nY
Endif

SA1->(DbSetOrder(1))
SA1->(MsSeek(xFilial()+IIf(!Empty(M->C5_CLIENT),M->C5_CLIENT,M->C5_CLIENTE)+M->C5_LOJAENT))
MaFisAlt('NF_SERIENF',LocXTipSer('SA1',MVNOTAFIS))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Agrega os itens para a funcao fiscal         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nPValor > 0 .And. nPValDesc > 0 .And. nPPrUnit > 0 .And. nPosPrd > 0 .And. nPQtdVen > 0 .And. nPTes > 0
	For nX := 1 To Len(aColsAux)
		nQtdPeso := 0
		If Len(aColsAux[nX])==nUsado .Or. !aColsAux[nX][nUsado+1]
			nItem++
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona Registros                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cProduto := aColsAux[nX][nPosPrd]
			MatGrdPrRf(@cProduto)
			SB1->(dbSetOrder(1))
			If SB1->(MsSeek(xFilial("SB1")+cProduto))
				nQtdPeso := aColsAux[nX][nPQtdVen]*SB1->B1_PESO
			EndIf

        	If nPIdentB6 <> 0 .And. !Empty(aColsAux[nX][nPIdentB6])
				SD1->(dbSetOrder(4))
				If SD1->(MSSeek(xFilial("SD1")+aColsAux[nX][nPIdentB6]))
					nRecOri := SD1->(Recno())
				EndIf
        	ElseIf nPNfOri > 0 .And. nPSerOri > 0 .And. nPItemOri > 0
				If !Empty(aColsAux[nX][nPNfOri]) .And. !Empty(aColsAux[nX][nPItemOri])
					SD1->(dbSetOrder(1))
					If SD1->(MSSeek(xFilial("SD1")+aColsAux[nX][nPNfOri]+aColsAux[nX][nPSerOri]+M->C5_CLIENTE+M->C5_LOJACLI+aColsAux[nX][nPosPrd]+aColsAux[nX][nPItemOri]))
						nRecOri := SD1->(Recno())
					EndIf
				EndIf
			EndIf
            
            SF4->(dbSetOrder(1))
            SF4->(MsSeek(xFilial("SF4")+aColsAux[nX][nPTES]))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calcula o preco de lista                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nValMerc  := aColsAux[nX][nPValor]
			nPrcLista := aColsAux[nX][nPPrUnit]
			If ( nPrcLista == 0 )
				nPrcLista := NoRound(nValMerc/aColsAux[nX][nPQtdVen],TamSX3("C6_PRCVEN")[2])
			EndIf
			nAcresFin := A410Arred(aColsAux[nX][nPPrcVen]*M->C5_ACRSFIN/100,"D2_PRCVEN")
			nValMerc  += A410Arred(aColsAux[nX][nPQtdVen]*nAcresFin,"D2_TOTAL")
			/*
			nDesconto := a410Arred(nPrcLista*aColsAux[nX][nPQtdVen],"D2_DESCON")-nValMerc
			nDesconto := IIf(nDesconto==0,aColsAux[nX][nPValDesc],nDesconto)
			nDesconto := Max(0,nDesconto)
			*/ 
			nDesconto := 0
			nPrcLista += nAcresFin

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Agrega os itens para a funcao fiscal         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MaFisAdd(cProduto,;   			// 1-Codigo do Produto ( Obrigatorio )
				aColsAux[nX][nPTES],;	   		// 2-Codigo do TES ( Opcional )
				aColsAux[nX][nPQtdVen],;  		// 3-Quantidade ( Obrigatorio )
				nPrcLista,;		  			// 4-Preco Unitario ( Obrigatorio )
				nDesconto,; 				// 5-Valor do Desconto ( Opcional )
				"",;	   					// 6-Numero da NF Original ( Devolucao/Benef )
				"",;						// 7-Serie da NF Original ( Devolucao/Benef )
				nRecOri,;					// 8-RecNo da NF Original no arq SD1/SD2
				0,;							// 9-Valor do Frete do Item ( Opcional )
				0,;							// 10-Valor da Despesa do item ( Opcional )
				0,;							// 11-Valor do Seguro do item ( Opcional )
				0,;							// 12-Valor do Frete Autonomo ( Opcional )
				nValMerc,;					// 13-Valor da Mercadoria ( Obrigatorio )
				0)							// 14-Valor da Embalagem ( Opiconal )	
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Altera peso para calcular frete              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MaFisAlt("IT_PESO",nQtdPeso,nItem)
			MaFisAlt("IT_PRCUNI",nPrcLista,nItem)
			MaFisAlt("IT_VALMERC",nValMerc,nItem)
			
		EndIf
	Next nX
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Indica os valores do cabecalho               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisAlt("NF_FRETE",M->C5_FRETE)
If !Empty(SC5->(FieldPos("C5_VLR_FRT")))
	MaFisAlt("NF_VLR_FRT",M->C5_VLR_FRT)
EndIf	
MaFisAlt("NF_SEGURO",M->C5_SEGURO)
MaFisAlt("NF_AUTONOMO",M->C5_FRETAUT)
MaFisAlt("NF_DESPESA",M->C5_DESPESA)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Indenizacao por valor                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If M->C5_DESCONT > 0
	MaFisAlt("NF_DESCONTO",Min(MaFisRet(,"NF_VALMERC")-0.01,nTotDesc+M->C5_DESCONT),/*nItem*/,/*lNoCabec*/,/*nItemNao*/,GetNewPar("MV_TPDPIND","1")=="2" )
EndIf

If M->C5_PDESCAB > 0
	MaFisAlt("NF_DESCONTO",A410Arred(MaFisRet(,"NF_VALMERC")*M->C5_PDESCAB/100,"C6_VALOR")+MaFisRet(,"NF_DESCONTO"))
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza alteracoes de referencias do SC6         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")
If Len(aFisGet) > 0
	For nX := 1 to Len(aColsAux)
		If Len(aColsAux[nX])==nUsado .Or. !aColsAux[nX][Len(aHeaderAux)+1]
			For nY := 1 to Len(aFisGet)
				nPosCpo := aScan(aHeaderAux,{|x| AllTrim(x[2])==Alltrim(aFisGet[ny][2])})
				If nPosCpo > 0
					If !Empty(aColsAux[nX][nPosCpo])
						MaFisAlt(aFisGet[ny][1],aColsAux[nX][nPosCpo],nX,.F.)
					Endif
				EndIf
			Next nX
		Endif
	Next nY
EndIf


if (MaFisRet(,"NF_VALMERC")) > 0
		cText += replicate("_",115)+ CRLF

		_cCpo := "TOTAL SIN IMPUESTOS"							// Producto
		_clin := Stuff(_clin,1,23,_cCpo)                           // 01--07
		_cCpo := PADR(space(1),1)
		_clin := Stuff(_clin,24,1,_cCpo)
		
		_cCpo := StrTran(Str(nTotQt,5,0),".",",")    				// Cantidad
		_clin := Stuff(_clin,24,5,_cCpo)                            // 97--109
		_cCpo := PADR(space(1),1)
		_clin := Stuff(_clin,25,1,_cCpo)
		
		_cCpo := StrTran(Str(nTotBruto,12,2),".",",")  				//  Importe Bruto
		_clin := Stuff(_clin,80,12,_cCpo)                            //  89--101
		_cCpo := PADR(Space(1),1)
		_clin := Stuff(_clin,93,1,_cCpo)

		_cCpo := StrTran(Str(nTotDes,10,2),".",",")   				//valor descuento
		_clin := Stuff(_clin,93,10,_cCpo)                            // 102--112
		_cCpo := PADR(Space(1),1)
		_clin := Stuff(_clin,104,1,_cCpo)
		
		_cCpo := StrTran(Str(MaFisRet(,"NF_VALMERC"),12,2),".",",")    				// Valor Total
		_clin := Stuff(_clin,104,12,_cCpo)                            // 97--109
		
		cText += _clin 

		FileWrite(@cText,nHandle)
	
//	AddTotalArch(,MaFisRet(,"NF_VALMERC"),.F.)       // imprime Neto
Endif	

aImposto := MaFisRet(,"NF_IMPOSTOS") //Descricao [2] / /Aliquota [4]/ Valor [5]/ Base [3]
nTotImp:= 0
For I:=1 To Len(aImposto)// Vetor com os impostos
	If aImposto[I][4] > 1
		addImposArch(aImposto[I][2],aImposto[I][4],aImposto[I][3],aImposto[I][5],IIF(I==1,.T.,.F.))
		nTotImp+=aImposto[I][5]
	Endif
Next

/*IF nTotImp > 0
	AddTotalArch("T O T A L  I M P U E S T O S ",nTotImp,.F.)       // imprime Total impuestos
Endif

if (MaFisRet(,"NF_DESCONTO")) > 0
	AddTotalArch("T O T A L  D E S C U E N T O S",MaFisRet(,"NF_DESCONTO"),.F.)       // imprime descuentos
Endif*/		

if (MaFisRet(,"NF_TOTAL")) > 0
		cText += replicate("_",115)+ CRLF
		_clin := Space(_nTamLin)+CRLF
		_cCpo := "T O T A L             "							// Producto
		_clin := Stuff(_clin,1,23,_cCpo)                           // 01--07
		_cCpo := PADR(space(1),1)
		_clin := Stuff(_clin,24,1,_cCpo)
		
		/*_cCpo := StrTran(Str(nTotQt,5,0),".",",")    				// Cantidad
		_clin := Stuff(_clin,24,5,_cCpo)                            // 97--109
		_cCpo := PADR(space(1),1)
		_clin := Stuff(_clin,104,1,_cCpo)*/
		
		_cCpo := StrTran(Str(MaFisRet(,"NF_TOTAL"),12,2),".",",")    				// Valor Total
		_clin := Stuff(_clin,104,12,_cCpo)                            // 97--109
		
		cText += _clin 

		FileWrite(@cText,nHandle,.T.)
	
   //	AddTotalArch("T O T A L",MaFisRet(,"NF_TOTAL"),.T.)       // imprime Bruto
Endif		

MaFisEnd()

RestArea(aAreaSA1)
RestArea(aArea)

Return(.T.)         

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | CalculoImpos()	  | AUTOR | MC	  | DATA 		   | 18/03/2008 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - addImposArch()                                         |//
//|           | Muestra archivo Resumen del procesamiento realizado             |//
//|           | 						                                        |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function addImposArch(cTexto1,nValor1,nValor2,nValor3,lCabec)
 
Local _cCpo		:="" 
local _nTamLin 	:= 125
local _cLin    	:= Space(_nTamLin)+CRLF

if lCabec
	cText += replicate("_",115)+ CRLF
	cText += "           D E T A L L E   D E   I M P U E S T O S           "		+ CRLF 
	cText += "IMPUESTO                      ALIC.     BASE IMP.            "		+ CRLF

Endif

_cCpo := PADR(alltrim(cTexto1),30)							// Nombre Impuesto
_clin := Stuff(_clin,01,30,_cCpo)                           // 01--30
_cCpo := PADR(space(1),1)
_clin := Stuff(_clin,30,1,_cCpo)
_cCpo := StrTran(Str(nValor1,5,2),".",",")    				// Alicuota
_clin := Stuff(_clin,31,7,_cCpo)                           // 31--42
_cCpo := PADR(Space(1),1)
_clin := Stuff(_clin,38,1,_cCpo)
_cCpo := StrTran(Str(nValor2,11,2),".",",")   				// Base Impuesto
_clin := Stuff(_clin,39,11,_cCpo)                           // 39--50
_cCpo := PADR(Space(1),1)
_clin := Stuff(_clin,50,1,_cCpo)
_cCpo := StrTran(Str(nValor3,11,2),".",",")   				// Valor Impuesto
_clin := Stuff(_clin,105,11,_cCpo)                            // 51--62

// graba item
cText += _clin 
FileWrite(@cText,nHandle)

return NIL


///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | CalculoImpos()	  | AUTOR | MC	  | DATA 		   | 18/03/2008 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - addBrutoarch()                                         |//
//|           | Muestra archivo Resumen del procesamiento realizado             |//
//|           | 						                                        |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function AddTotalArch(cTitulo,nValor,lClose)
 
Local _cCpo		:=""               
local _nTamLin 	:= 125
local _cLin    	:= Space(_nTamLin)+CRLF


cText += replicate("_",115)+ CRLF

_cCpo := PADR(cTitulo,90)									// titulo
_clin := Stuff(_clin,1,90,_cCpo)                           // 01--90
_cCpo := PADR(space(1),1)
_clin := Stuff(_clin,90,1,_cCpo)
_cCpo := StrTran(Str(nValor,12,2),".",",")					// Valor Total
_clin := Stuff(_clin,104,12,_cCpo)                           // 89--101

// graba item
cText += _clin 

FileWrite(@cText,nHandle,lClose)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FisGetInit³ Autor ³Eduardo Riera          ³ Data ³17.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Inicializa as variaveis utilizadas no Programa              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FisGetInit(aFisGet,aFisGetSC5)

Local cValid      := ""
Local cReferencia := ""
Local nPosIni     := 0
Local nLen        := 0

If aFisGet == Nil
	aFisGet	:= {}
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SC6")
	While !Eof().And.X3_ARQUIVO=="SC6"
		cValid := UPPER(X3_VALID+X3_VLDUSER)
		If 'MAFISGET("'$cValid
			nPosIni 	:= AT('MAFISGET("',cValid)+10
			nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
			cReferencia := Substr(cValid,nPosIni,nLen)
			aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		If 'MAFISREF("'$cValid
			nPosIni		:= AT('MAFISREF("',cValid) + 10
			cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
			aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		dbSkip()
	EndDo
	aSort(aFisGet,,,{|x,y| x[3]<y[3]})
EndIf

If aFisGetSC5 == Nil
	aFisGetSC5	:= {}
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SC5")
	While !Eof().And.X3_ARQUIVO=="SC5"
		cValid := UPPER(X3_VALID+X3_VLDUSER)
		If 'MAFISGET("'$cValid
			nPosIni 	:= AT('MAFISGET("',cValid)+10
			nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
			cReferencia := Substr(cValid,nPosIni,nLen)
			aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		If 'MAFISREF("'$cValid
			nPosIni		:= AT('MAFISREF("',cValid) + 10
			cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
			aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		dbSkip()
	EndDo
	aSort(aFisGetSC5,,,{|x,y| x[3]<y[3]})
EndIf
MaFisEnd()

Return(.T.)




