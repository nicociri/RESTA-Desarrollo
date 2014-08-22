// Cria barra de status    oTMsgBar := TMsgBar():New(oDlg, 'MP10 | Totvs/Software',;        .F.,.F.,.F.,.F., RGB(116,116,116),,,.F.)
// Cria item 01    oTMsgItem1 := TMsgItem():New( oTMsgBar,'oTMsgItem1', 100,,,,;        .T., {||} )               
// Cria item 02 com mudança de fonte    oFont := TFont():New('Courier new',,-14,.T.)    oTMsgItem2 := TMsgItem():New( oTMsgBar,'oTMsgItem2', 100,oFont,CLR_HRED,,;        .T., {||Alert("Click na barra de status")} )          ACTIVATE DIALOG oDlg CENTERED Return

#include "protheus.ch"

USER FUNCTION AFTERLOGIN
	/*IF LEN(OMAINWND:OMSGBAR:AITEM) < 9
		TMsgItem():New(OMAINWND:OMSGBAR,,,,,, .T.,{||U_PicColor()},'PMSRRFSH' )
		//OMAINWND:BPAINTED:={||U_PicColor()}	
	ENDIF*/
	oTMsgBar := TMsgBar():New(OMAINWND, 'SUPERINVENTO',.F.,.F.,.F.,.F., RGB(116,116,116),,,.F.)
	TMsgItem():New(oTMsgBar,,,,,, .T.,{||U_PicColor()},'PMSRRFSH' )
	//U_PicColor()
RETURN


User function PicColor
	Local oDlg, oColorT,oButton
	DEFINE MSDIALOG oDlg FROM 0,0 TO 400,400 PIXEL TITLE "Cores"
	// Usando o método create
	oColorT := tColorTriangle():Create( oDlg )
	oButton:= tButton():New(80,10,'',oDlg,{||U_ChgColor(oColorT:RetColor()),odlg:end()},100,20,,,,.T.)
	ACTIVATE MSDIALOG oDlg CENTERED
Return

User function ChgColor(nColor)

OMAINWND:NCLRPANE := nColor
for var:= 1 to Len(OMAINWND:ACONTROLS)
	IF ExprVal("OMAINWND:ACONTROLS["+ALLTRIM(STR(VAR))+"]:NCLRPANE")
		OMAINWND:ACONTROLS[VAR]:NCLRPANE := nColor
		OMAINWND:ACONTROLS[VAR]:NCLRTEXT := nColor
	endIf
Next

Return



STATIC FUNCTION EXPRVAL(cExpr)
Local oLastError := ErrorBlock({|e| cError := "ERRO"})
local cError := ""
local cvts := ""
local lExist := .F. 

cError := ""
cvts := &(cExpr)//OMAINWND:ACONTROLS[VAR]:CRESNAME
ErrorBlock(oLastError)


IF ValType(cvts) == "C"
	if	!cvts == "ERRO"
		lExist:= .T. 
	EndIf
ELSE
	lExist:= .T.
ENDIF

Return lExist

/*
User function getRes()
	Local var := 0
	Local cvts := "teste"
	Local var := 0
	Local aBmps := {}
	cvts := "32584"
	//{ || {|| GETSDIINFO(ODESKTOP,SELF:LMDI)}}
	//OMAINWND:NCLRPANE := nColor
	
	for var:= 1 to Len(OMAINWND:ACONTROLS)// fwocn_lyr_title_cnt.png
		IF ExprVal("OMAINWND:ACONTROLS["+ALLTRIM(STR(VAR))+"]:CRESNAME")
			//IF OMAINWND:ACONTROLS[VAR]:CRESNAME == "x.png"
				//OMAINWND:ACONTROLS[VAR]:CRESNAME := "cliente.png"
			//ENDIF
		ENDIF	
		
		IF ExprVal("OMAINWND:ACONTROLS["+ALLTRIM(STR(VAR))+"]:NCLRPANE")	
			IF MOD(VAR,2)>0
				OMAINWND:ACONTROLS[VAR]:NCLRPANE := 214229203
				OMAINWND:ACONTROLS[VAR]:NCLRTEXT := 000
			ELSE
				OMAINWND:ACONTROLS[VAR]:NCLRPANE := 142184112
				OMAINWND:ACONTROLS[VAR]:NCLRTEXT := 000
			ENDIF
	ENDIF
	next
	cvts := "32584"
	/*
	OMAINWND:OMENU:NCLRPANE:= nColor
	for var:= 1 to Len(OMAINWND:OMENU:AITEMS)
		OMAINWND:OMENU:AITEMS[VAR]:NCLRPANE := nColor
		//OMAINWND:OMENU:AITEMS[VAR]:NCLRTEXT := nColor  
	next
	
	cvts := "32584"
Return*/
 
/*
User Function ExRes()
     aRes := getResArray("*")
     aEval(aRes,{|x| resource2File(x,"c:\resources\" + x)})
Return
*/
 
 /*
 "x.png"	
"x.png"	
"x.png"	
"fwlgn_btn_hlp.png"	
"fwlgn_bg.png"	
"fwlgn_line.png"	
"fwlgn_line.png"	
"fw_logo.png"	
"x.png"	
"x.png"	
"x.png"	
"x.png"	
"fwlgn_mtr_bg.png"	
"x.png"	
"x.png"	
"x.png"	
"x.png"	
"x.png"	
"x.png"	
"x.png"	
"x.png"	
"FW_TOTVS.PNG"	
"x.png"	
"fwocn_lookup.png"	
"x.png"	
 
 
 fwocn_lyr_title_cnt.png
 */