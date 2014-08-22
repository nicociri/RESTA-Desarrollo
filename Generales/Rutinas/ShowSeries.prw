#INCLUDE "PROTHEUS.CH"

User Function ShowSeries(cTipoCli,cEspecie)

Local aAreaSF1 := GetArea("SF1")
Local aAreaSF2 := GetArea("SF2")
Local aAreaSFP := GetArea("SFP")
Local cSerieCli:= "   "
Local aSerNF   := {}
Local aEspecie := {"NF","RFN","NDI","NCC","NDC","RTS","RTE"}
Local cPosEspe := ""
Local cVarQ    := ''
Local lOkSel   := .F.

cPosEspe := AllTrim( Str( AScan( aEspecie,AllTrim(cEspecie) ) ) )

Do Case
	
	Case cTipoCli == 'E'
		If SD2->D2_LOCAL == 'B1'
			cSerieCli := 'B0'
		Else
			cSerieCli := 'E'
		EndIf
		
	Case cTipoCli $ "I-N"
		cSerieCli := 'A'
		
	Otherwise
		cSerieCli := 'B'
		
EndCase
If Substr(cEspecie,1,1) ='R'
	cSerieCli := 'R'
EndIf

DbSelectArea("SFP")
DbGoTop()

While !SFP->(EOF())
	               
	IF SFP->FP_FILUSO <> CFILANT
	   DBSKIP();LOOP
	ENDIF
	If ((SFP->FP_ESPECIE == cPosEspe .AND. SFP->FP_DTAVAL > dDatabase .AND. SFP->FP_ATIVO == '1' .AND. Left(SFP->FP_SERIE,1) $ cSerieCli) .or.;
		(SFP->FP_ESPECIE == cPosEspe .AND. SFP->FP_DTAVAL > dDatabase .AND. SFP->FP_ATIVO == '1' .AND. Left(SFP->FP_SERIE,1) $ 'B' .and. Left(SFP->FP_NUMINI,4) ='0006' .and. cSerieCli =='E'))
           IF FUNNAME()='MATA462AN' .AND. cPosEspe =='2' 
                IF SC5->C5_XENVIO =='2'	.AND. SFP->FP_XNEGRO=='S'	
   		           AADD( aSerNF,{ SFP->FP_SERIE, Left(SFP->FP_NUMINI,4),SFP->FP_NUMFIM} )
   		        ELSEIF SC5->C5_XENVIO <>'2'	.AND. SFP->FP_XNEGRO <> 'S'
 		           AADD( aSerNF,{ SFP->FP_SERIE, Left(SFP->FP_NUMINI,4),SFP->FP_NUMFIM} )
 	            ENDIF
 	       ELSE
        		AADD( aSerNF,{ SFP->FP_SERIE, Left(SFP->FP_NUMINI,4),SFP->FP_NUMFIM} )
           ENDIF
	EndIf
	
	DbSkip()
	
EndDo
                                          
If Len(aSerNF) > 1
	
	While !lOkSel
		DEFINE MSDIALOG oDlgSerie TITLE "Series comprobantes" FROM 300,300 TO (450+(16 *Len(aSerNF))),618 OF oMainWnd	PIXEL
		@ .5,.80 LISTBOX oSeri VAR cVarQ Fields HEADER "Serie","PV","N.FINAL" SIZE 150,(40 + (10 *Len(aSerNF))) NOSCROLL
		oSeri:SetArray(aSerNF)
		oSeri:bLine := { || {aSerNf[oSeri:nAT,1],aSerNf[oSeri:nAT,2],aSerNf[oSeri:nAT,3]}}
		DEFINE SBUTTON FROM (50 + (10 *Len(aSerNF))),7	00 TYPE 1 ACTION (cSerieCli:= aSerNf[oSeri:nAt,1],lOkSel:= .T.,oDlgSerie:End()) ENABLE OF oDlgSerie
		ACTIVATE MSDIALOG oDlgSerie
	EndDo
Else
	
	If Len(aSerNF) == 1      
		
		cSerieCli := aSernf[1][1]
	
	Else
	
		IW_MsgBox("No se encontró serie para " + cEspecie + " activa/vigente para esta empresa/sucursal/comprobante! Se utilizará una serie por defecto. Avise al depto. de Sistemas","Sin Serie!","STOP")

	EndIf
	
EndIf

SFP->(DbCloseArea()	)

RestArea(aAreaSFP)
RestArea(aAreaSF2)
RestArea(aAreaSF1)

Return(cSerieCli)
