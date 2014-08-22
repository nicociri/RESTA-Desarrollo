#Include 'Protheus.ch'
#include 'Rwmake.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA087GRV  ºAutor  ³Microsiga           ºFecha ³  06/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE GRAVACAO DO RECIBO                                      º±±
±±º          ³ Chamado apos a gravacao de todos os dados nos arquivos SE1,º±±
±±º			 ³	SEL e SE5 e antes dos lancamentos contabeis.              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA087GRV()
Local aArea    := GetArea()
Local aAreaE1  := SE1->(GetArea())
Local _cModalidad	:= ""
Local _nMayor		:= 0 
Local ctext		:= CRIAVAR("EL_XOBSER")  
Local cVend     := ""

@ 229,143 To 322,505 Dialog oDlg Title OemToAnsi("Observ. en el Recibo :" + crecibo )
@ 002,008 Get cText Size 153,13
@ 015,010 BMPBUTTON Type 1 Action oDlg:End()
Activate Dialog oDlg Centered
If !Empty( cText )
	DbSelectArea("SEL")
	dbsetorder(1)
	dbseek(xFilial("SEL")+cserie+crecibo)
	While !EOF() .and. SEL->EL_RECIBO == crecibo .and. SEL->EL_SERIE == cserie
		
		RecLock( 'SEL', .F. )
		Replace EL_XOBSER With cText
		MsUnLock()
		
		dbskip()
	EndDo
EndIf
cText := CriaVar('EL_XOBSER')
                   
DbSelectArea("SE1")
dbsetorder(1)
DbSelectArea("SEL")
dbsetorder(1)
dbseek(xFilial("SEL")+cserie+crecibo)
While !EOF() .and. SEL->EL_RECIBO == crecibo.and.SEL->EL_SERIE == cSERIE  
	IF SEL->EL_TIPODOC == 'CH'
        DbSelectArea("SE1")
		if SE1->(DBSEEK(xFilial("SE1")+SEL->EL_PREFIXO+SEL->EL_NUMERO+SEL->EL_PARCELA+'CH ')) 
			RECLOCK("SE1",.F.)
				Replace SE1->E1_XESTADO With SEL->EL_XESTADO  
				Replace SE1->E1_XNOMFIR With SEL->EL_XNOMFIR
			MsUnlock()
		EndIf
	EndIf		 		
    DbSelectArea("SEL")
	dbskip()
ENDDO

/*
DbSelectArea("SEL")
dbsetorder(1)
dbseek(xFilial("SEL")+crecibo)
While !EOF() .and. SEL->EL_RECIBO == crecibo  
	IF (SEL->EL_TIPODOC == 'CH' .AND. SEL->EL_TIPO='CH').OR.(SEL->EL_TIPODOC == 'RA' .AND. SEL->EL_TIPO='RA')
		if SE1->(DBSEEK(xFilial("SE1")+SEL->EL_PREFIXO+SEL->EL_NUMERO+SEL->EL_PARCELA+SEL->EL_TIPO)) 
			cVend1  := Posicione("ZZX", 1, xFilial("ZZX") + SE1->E1_CLIENTE+ _cModalidad, "ZZX_XVEND")
			RECLOCK("SE1",.F.)
				Replace SE1->E1_NATUREZ With _cModalidad  
				Replace SE1->E1_VEND1 With cVend1
				//Replace SE1->E1_VENCTO  With dDatabase+180
				//Replace SE1->E1_VENCREA With dDatabase+180
			MsUnlock()
		EndIf
	EndIf		 		
	RecLock("SEL",.F.)
	Replace EL_NATUREZ	With _cModalidad
	MsUnLock()
	dbskip()
	
	IF (SEL->EL_TIPODOC == 'RA' .AND. SEL->EL_TIPO='RA')
		if SE1->(DBSEEK(xFilial("SE1")+SEL->EL_PREFIXO+SEL->EL_NUMERO+SEL->EL_PARCELA+SEL->EL_TIPO));
		.and. Posicione("SA1",1,Xfilial("SA1")+SEL->EL_CLIENTE+SEL->EL_LOJA,"A1_TIPO") == 'E' 
			RECLOCK("SE1",.F.)
				//Replace SE1->E1_NATUREZ With _cModalidad
				Replace SE1->E1_VENCTO  With dDatabase+180
				Replace SE1->E1_VENCREA With dDatabase+180
			MsUnlock()
		EndIf
	EndIf		 		
	RecLock("SEL",.F.)
	Replace EL_NATUREZ	With _cModalidad
	MsUnLock()
	dbskip()
	
EndDo
/*
If nRecno>0
	SEY->(dbGoto(nRecno))
	RecLock("SEY")
	SEY->EY_RECPEND:=SEY->EY_RECPEND -1
	If SEY->EY_RECPEND<=0
		SEY->EY_RECPEND:=2
  		SEY->EY_STATUS:="1"
 	EndIf	
	MsUnlock("SEY")
EndIf	
*/
RestArea(aAreaE1)
restarea(aArea)                                                   
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//Funcion que lleva datos de la factura de acopio al recibo///////
recaco()
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

Return(.t.)


static Function recaco
Local aArea    := GetArea()
Local aSEL     := SEL->(GetArea())
Local nposnro  := Ascan(aHeader,{|x| AllTrim(x[2]) == "EL_XNROACO"}) 
Local nposes   := Ascan(aHeader,{|x| AllTrim(x[2]) == "EL_XESACO"})
Local cNature  := GetMv("MV_MODACO")
Local cText1   := Space(6)
Local cText2   := ""
Local cOdec	   := ""

For nn:=1 to Len(aLinSE1)     
	If ALLTRIM(aLinSE1[nn][5])=='NF' .AND. Empty(cOdec)  
		cOdec:=aLinSE1[nn][3]
    EndIf
Next
         If !Empty(cOdec)	
         	cQuery := "SELECT F2_XNROACO FROM " + RetSqlName("SF2") + " "
			cQuery += "WHERE D_E_L_E_T_ = '' AND F2_ESPECIE='NF' AND F2_DOC = '" + cOdec + "' "
			cQuery += " AND F2_XNROACO<>'' "
			cQuery := PLSAvaSQL(cQuery)
		   If Select("TODO01") <> 0
          		DBSelectArea("TODO01")
          		TODO01->(DBCloseArea())
    	 	EndIf
   		  	// Executa a Query
     		PLSQuery(cQuery,"TODO01")
   		  	// Vai para o inicio da area de trabalho
     		TODO01->(DBGoTop())
     		If !Empty(TODO01->F2_XNROACO)
  		   		cText2:= TODO01->F2_XNROACO
  		   	EndIf
  		   	DBSelectArea("TODO01")
			TODO01->(DBCloseArea())
		EndIf 

If !empty(cNatureza) .AND. ALLTRIM(cNatureza)==ALLTRIM(cNature)
	If Empty(cText2)  
	
		@ 229,143 To 322,505 Dialog oDlg Title OemToAnsi("Numero de acopio :" )
		@ 002,008 Get cText1 PICTURE "@E 999999" F3 "Z01INC" VALID U_ACOCLIEN(cText1) Size 153,13
		@ 015,010 BMPBUTTON Type 1 Action oDlg:End()
		Activate Dialog oDlg Centered
	EndIf
EndIf


SEL->(DbSetOrder(1))
dbselectarea("SEL")
SEL->(DbSeek(xFilial('SEL')+cSerie+cRecibo))

While !SEL->(Eof()) .and. xFilial('SEL')+cRecibo == SEL->(EL_FILIAL+EL_RECIBO)
     If  !Empty(cText2)
         SEL->EL_XESACO:="S"
         SEL->EL_XNROACO:=cText2
         For nx:= 1 to len(acols)	
			acols[nx][nposes]  := "S"
			acols[nx][nposnro] := cText2
		 Next
     Else
     	 SEL->EL_XESACO:="S"
         SEL->EL_XNROACO:=cText1  
         For nx:= 1 to len(acols)	
			acols[nx][nposes]  := "S"
			acols[nx][nposnro] := cText1
		 Next
     EndIf
   SEL->(DbSkip())
EndDo

RestArea(aSEL)
RestArea(aArea)

Return
