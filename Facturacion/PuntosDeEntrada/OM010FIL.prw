#include "rwmake.ch" 
#include "protheus.ch" 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ OM010FIL  ³ Autor ³ MS			          ³ Data ³ 01/10/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Punto de entrada que en el Armado de la query		            ³±±
±±³			 ³En listas de precios de ventas								³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function OM010FIL()
Local cQuery:=""
            
If !Empty(mv_par04) 
			cQuery := "SELECT B1_COD,B1_DESC,B1_PRV1,B1_MSBLQL "
		    cQuery += "FROM "+RetSqlName("SB1")+ " SB1 "
		    cQuery += "WHERE "
		    cQuery += "B1_FILIAL ='"+xFilial("SB1")+"' AND "
		    cQuery += "B1_COD >= '"+mv_par01+"' AND "
		    cQuery += "B1_COD <= '"+mv_par02+"' AND "
		    cQuery += "B1_GRUPO >= '"+mv_par03+"' AND "
		    cQuery += "B1_GRUPO <= '"+mv_par04+"' AND "
		    cQuery += "B1_TIPO >= '"+mv_par05+"' AND "
		    cQuery += "B1_TIPO <= '"+mv_par06+"' AND "
		    cQuery += "SB1.D_E_L_E_T_ = ' '"
		    cQuery += "ORDER BY "+SqlOrder(SB1->(IndexKey())) 
Else
			cQuery := "SELECT B1_COD,B1_DESC,B1_PRV1,B1_MSBLQL "
		    cQuery += "FROM "+RetSqlName("SB1")+ " SB1 "
		    cQuery += "WHERE "
		    cQuery += "B1_FILIAL ='"+xFilial("SB1")+"' AND "
		    cQuery += "B1_COD >= '"+mv_par01+"' AND "
		    cQuery += "B1_COD <= '"+mv_par02+"' AND " 
		    cCant:=RAT(",", mv_par03)+1
		    cPar:=""
		    For n:=1 to cCant
		    	cAT:=AT(",", mv_par03)  
		    	If cAT>0
		    		n:=cAT
		    		cPar+="'"+SUBSTRING(mv_par03,1,(cat-1))+"'"  
		    	endIf
		    	If n<cCant .AND. cAT>0
		    		cPar+=SUBSTRING(mv_par03,cat,1)
		    	EndIf
		    	mv_par03:=SUBSTRING(mv_par03,cat+1,(len(mv_par03)))
		    	If cAt==0
		    		cPar+="'"+ALLTRIM(mv_par03)+"'"
		    		n:=cCant
		    	EndIf	 
		    Next
		    mv_par03:=cPar
		    If (AT(";", mv_par03)>0) .OR. (AT(".", mv_par03)>0) .OR. (AT(" ", mv_par03)>0)
		    	Alert("Ingreso un caracter invalido para la generacion de grupos")
		    	mv_par03:="''"
		    EndIf
		    cQuery += "B1_GRUPO in ("+mv_par03+") AND "
		    cQuery += "B1_TIPO >= '"+mv_par05+"' AND "
		    cQuery += "B1_TIPO <= '"+mv_par06+"' AND "
		    cQuery += "SB1.D_E_L_E_T_ = ' '"
		    cQuery += "ORDER BY "+SqlOrder(SB1->(IndexKey()))
EndIf

Return(cQuery)