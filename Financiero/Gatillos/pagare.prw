/*
Gatillo que sirve para llevar la numeracion de los pagare
En los recibo de cobro y en las Ordenes de pago
La misma se dispara con los gatillos en EL_TIPODOC sec 009
EK_TIPODOC sec 001
*/
User Function pagare()
Local cNum :=""

If ALLTRIM(Funname())=="FINA087A"	
	If aCols[n, GdFieldPos("EL_TIPODOC")] =="NP"
	    cNum:=GETSX8NUM("SEL","EL_XNUMERO")
	    aCols[n, GdFieldPos("EL_XNUMERO")]:=cNum                                                                                                    
	EndIf     
EndIf

If ALLTRIM(Funname())=="FINA085A"	
	If aCols[n, GdFieldPos("EK_TIPODOC")] =="NP" 
	    cNum:=GETSX8NUM("SEK","EK_XNUMERO")
	    aCols[n, GdFieldPos("EK_XNUMERO")]:=cNum                                                                                                   
	EndIf     
EndIf	
Return(cNum) 