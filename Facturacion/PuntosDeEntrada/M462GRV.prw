#include "rwmake.ch" 
#include "protheus.ch" 
#include "tbiconn.ch"

Static cMayUse

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ M462GRV  ³ Autor ³ MS			          ³ Data ³ 01/10/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Punto de entrada que permite transferir datos desde           ³±±
±±³			 ³la tabla SC5/sc6 hacia la SF2/SD2								³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function M462GRV

Local aArea		:= GetArea()
Local aAreaSC6	:= SC6->(GetArea()) 
Local aAreaSX5	:= SX5->(GetArea())                               
Local aDoc		:= {}
Local nr		:= 0
Local cprogram	:= Alltrim(FunName()) 
Local nPosnom	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D2_XNOME"})  

Private nX 		:= PARAMIXB[7]

aSF2[nX][Ascan(aHeadSF2,{|x| Alltrim(x)=="F2_NATUREZ"  	})]		:= SC5->C5_NATUREZ
aSF2[nX][Ascan(aHeadSF2,{|x| Alltrim(x)=="F2_XENDENT"  	})]		:= SC5->C5_XENDENT
aSF2[nX][Ascan(aHeadSF2,{|x| Alltrim(x)=="F2_XCONTAC" 	})]		:= SC5->C5_XCONTAC
//aSF2[nX][Ascan(aHeadSF2,{|x| Alltrim(x)=="F2_XPDV"  	})]		:= Posicione('ZZJ',7,cFilant+"R","ZZJ_COD")  
cclien:=aSF2[nX][Ascan(aHeadSF2,{|x| Alltrim(x)=="F2_CLIENTE" 	})]

If cprogram=="MATA461" .OR. cprogram=="MATA462AN"  
	For nr:=1 to Len(Acols)
		aCols[nr][nPosnom]:=Posicione("SA1",1,xFilial("SA1")+ALLTRIM(cclien),"A1_NOME")
	Next
	U_mdpent2()
EndIf

If cprogram=="MATA462AN"
   U_Sinfact()
EndIf 
/*          
For nI := 1 To Len(aCols)
	                                            
		aCols[nI][nPLocDes] :=SC6->C6_LOCDEST
		aCols[nI][nPProv]	:=SC6->C6_PROVENT
			   
		Dbselectarea("SC6")
		Dbsetorder(1)
		Dbgotop()
		IF Dbseek(xFilial("SC6")+aCols[nI][nPosPedido]+aCols[nI][nPosItPed]+aCols[nI][nPosProd])
			aCols[nI][nPDescr]  :=SC6->C6_DESCRI
	    Endif

Next
*/
RestArea(aAreaSC6)
RestArea(aAreaSX5)
RestArea(aArea)

Return
               
User function mdpent2()

Local cProv			:= ""
Local aPed			:= ""
Local nposPed		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D2_PEDIDO"})
Local _aArea 		:= GetArea()

	for nx:= 1 to len(acols)	
		If Empty(aPed)
			aPed:= acols[nx][nposPed]
		Endif
	next

   If Empty(aSF2[1][Ascan(aHeadSF2,{ |x| Alltrim(x)=="F2_XNROACO" })])
      If !Empty(aPed)
         SC5->(DbSetOrder(1))
         If SC5->(DbSeek(xFilial('SC5')+aPed)) .and. !Empty(SC5->C5_NUM)
            //RecLock('SF2', .F.)
            aSF2[1][Ascan(aHeadSF2,{ |x| Alltrim(x)=="F2_XESACO" })]  := SC5->C5_XESACO
            aSF2[1][Ascan(aHeadSF2,{ |x| Alltrim(x)=="F2_XNROACO" })] := SC5->C5_XNROACO
            //MsUnLock()
         EndIf
      EndIf
   EndIf
   		
RestArea(_aArea)

Return  

                     
User Function Sinfact()

Local nposCod		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D2_QTDEFAT"}) 
Local nposCant		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D2_QUANT"})   
Local nposser		:= aSF2[1][Ascan(aHeadSF2,{ |x| Alltrim(x)=="F2_SERIE" })]
Local _aArea 		:= GetArea()

If Posicione("SFP",1,xFilial('SFP')+xFilial('SD2')+nposser,'FP_XNEGRO')=="S"  //En la busqueda se puso Space(2) porque la tabla SFP esta compartida
	For nx:= 1 to len(acols)	
			acols[nx][nposCod]:=acols[nx][nposCant]  //Igualar cantidades para que no se pueda facturar
	next                                                    
EndIf
RestArea(_aArea)
Return