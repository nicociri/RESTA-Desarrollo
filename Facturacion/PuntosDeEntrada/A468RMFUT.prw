
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A468RMFUT ºAutor  ³Microsiga           ºFecha ³  09/19/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de entrada en la generacion de la factura en la      º±±
±±º          ³ Entrega Futura                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                        

User Function A468RMFUT
                          
Local aRet 	  := {} 
Local nPosCod := 0
Local nX      := 0  
Local aCabPV  := PARAMIXB[1]
Local aItemPV := PARAMIXB[2]
Local cNumPed := PARAMIXB[1][1][2]
Local aFieldsC6:= {}       
Local nLenIt  := Len( PARAMIXB[2] )
Local aNUM    := PARAMIXB[1][1][2]   	 //C5_NUM
Local aDOCGER := PARAMIXB[1][18][2]  	 //C5_DOCGER
Local aTES    := PARAMIXB[2][1][10][2]   //C6_TES
Local aFieldsC5 := {{"C5_CATPV",SC5->C5_CATPV},;
					{"C5_NATUREZ",SC5->C5_NATUREZ},;
					{"C5_FECENT",SC5->C5_FECENT},; //Fecha de entrega
					{"C5_XNFSER",SF2->F2_SERIE},; //Serie de la factura
					{"C5_XNFDOC",SF2->F2_DOC},; // numero de la factura
					{"C5_VEND1",SC5->C5_VEND1}}  
Local nPosF_C5	:= 0
Local nPosF_C6	:= 0
		
		If SC5->C5_DOCGER=="3"           //Si es de entrega futura 
				RecLock("SC5",.F.)  
					SC5->C5_XPVTRO	:=aNUM  
				MsUnlock()
		EndIf                
		
//Pasa campos especificos del encabezado en el segundo pedido
For nC5 := 1 To Len(aFieldsC5)

	nPosF_C5:= aScan(aCabPV,{|x| AllTrim(x[1])==aFieldsC5[nC5][1]})
		
	If nPosF_C5 <> 0
		aCabPV[nPosF_C5][2] := aFieldsC5[nC5][2]
	Else
		aAdd(aCabPV,{aFieldsC5[nC5][1],aFieldsC5[nC5][2],Nil })
	EndIf
	
Next nC5   

aAdd(aRet,aCabPV)
aAdd(aRet,aItemPV)

Return aRet