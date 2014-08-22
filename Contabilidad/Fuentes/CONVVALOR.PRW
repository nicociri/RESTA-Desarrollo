#include 'protheus.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ ConvValor ³ Autor ³ ms				    ³ Data ³ 03/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Retorna valor para el asiento                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Microsiga Argentina....                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
VALORES DE LOS PARAMETROS QUE RECIBE LA RUTINA 

nMoneda = Moneda en la cual se quiere obteber el valor
nValor = Valor a convertir 
nMonOri = Moneda de origen de nValor
dFecha = Fecha en la cual se debe tomar la tasa de conversion
nTxMonDoc = tasa de la moneda de origen con respecto la moneda 1
*/

User Function ConvValor(nMoneda, nValor, nMonOri, dFecha, nTxMonDoc)

Local nValRet	 := 0

If nTxMonDoc == 0
	nTxMonDoc := 1
Endif
If nMonOri == 1 // Cuando el documento es en moneda 1
	If nMoneda == 1
		nValRet := nValor
	ElseIf nMoneda == 2
	                   //, nValor,        dDataOri,   nMoeOri,        nMoneda, nVerTasa, nTxMoeda )            
		nValRet := U_xVALOR(nValor,dFecha,MAX(nMonOri,1),2     ,2,        0)		
	Elseif nMoneda == 3
		nValRet := U_xVALOR(nValor,dFecha,MAX(nMonOri,1),3     ,3,        0)				
	Elseif nMoneda == 4
		nValRet := U_xVALOR(nValor,dFecha,MAX(nMonOri,1),4     ,4,        0)				
	Elseif nMoneda == 5
		nValRet := U_xVALOR(nValor,dFecha,MAX(nMonOri,1),5     ,5,        0)				
	Endif
ElseIf nMonOri == 2
	If nMoneda == 1
		nValRet := nValor * nTxMonDoc
	ElseIf nMoneda == 2
		nValRet := nValor
	Elseif nMoneda == 3
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,3     ,3,        0)				
	Elseif nMoneda == 4
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,4     ,4,        0)				
	Elseif nMoneda == 5
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,5     ,5,        0)				
	Endif			
ElseIf nMonOri == 3
	If nMoneda == 1
		nValRet := nValor * nTxMonDoc
	ElseIf nMoneda == 2
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,2     ,2,        0)				
	Elseif nMoneda == 3
		nValRet := nValor 
	Elseif nMoneda == 4
		nValRet :=  U_xVALOR(nValor * nTxMonDoc,dFecha,1,4     ,4,        0)				
	Elseif nMoneda == 5
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,5     ,5,        0)				
	Endif			
ElseIf nMonOri == 4
	If nMoneda == 1
		nValRet := nValor * nTxMonDoc
	ElseIf nMoneda == 2
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,2     ,2,        0)				
	Elseif nMoneda == 3
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,3     ,3,        0)				
	Elseif nMoneda == 4
		nValRet := nValor 
	Elseif nMoneda == 5
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,5     ,5,        0)				
	Endif					
ElseIf nMonOri == 5
	If nMoneda == 1
		nValRet := nValor * nTxMonDoc
	ElseIf nMoneda == 2
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,2     ,2,        0)				
	Elseif nMoneda == 3
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,3     ,3,        0)				
	Elseif nMoneda == 4
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,4     ,4,        0)				
	Elseif nMoneda == 5
		nValRet := nValor 
	Endif					
Else
	If nMoneda == 1
		nValRet := nValor * nTxMonDoc
	ElseIf nMoneda == 2
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,2     ,2,        0)				
	Elseif nMoneda == 3
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,3     ,3,        0)				
	Elseif nMoneda == 4
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,4     ,4,        0)				
	Elseif nMoneda == 5
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,5     ,5,        0)				
	Endif						
Endif

Return( nValRet )

