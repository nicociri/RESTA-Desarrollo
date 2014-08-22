#INCLUDE "PROTHEUS.CH"
#Include "Topconn.ch"
#Include "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Validacion�Autor  �Microsiga           �Fecha �  06/06/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Validaci�n para el monto total de un acopio indefinido    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                                            

User Function acopenF1()      

Local aArea     := GetArea()
Local cQuery   :=  ""	//Para ejecuci�n de Query
Local lRet     := .T.
Local cTitulo  := "Acopios Pendientes"
Local cTexto   := ""
Local cResultado:= ""
Local aLinea   := {}
Local aAcopio  := {}
Private cnroaco  := ""
Private cCliente :=M->F1_FORNECE

If !ALLTRIM(Funname()) $ "MATA465N/MATA462DN"
  Return("")
EndIf
alinea:=Pendient()
If Len(aLinea)>0
	For nx:=1 to Len(aLinea)  //{"Z01_ACOPIO","Z01_XVFAC","Z01_EMIS","Z01_XDIRO"}
		AADD(aAcopio,{aLinea[nx][1],Alltrim(aLinea[nx][2]),Posicione("Z01",1,Xfilial("Z01")+aLinea[nx][1],"Z01_EMIS"),Posicione("Z01",1,Xfilial("Z01")+aLinea[nx][1],"Z01_XDIRO")})
	Next 
	cResultado:=Cuadro(aAcopio)
EndIf                        

RestArea(aArea)			
Return(cResultado)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ACOPEN    �Autor  �Microsiga           �Fecha �  06/27/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Arma cuadro de seleccion                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Cuadro(aAcopio)

Local aArea     := GetArea()
Local aCampos   := {"Z01_ACOPIO","Z01_XVFAC","Z01_EMIS","Z01_XDIRO"}
Local aHeadCpos := {" "}
Local aHeadUser := {}
Local aNew      := {}
Local aLineNew  := {}
Local aNewF4    := {}
Local aArrayF4   := {}
Local aLineF4   := {}
Local aSavRec   := {}
Local aFiltro   := {}
Local bWhile    := { || .T. }
Local bIf       := { || .T. }
Local nOpcA     := 0
Local nSavQual  := 0
Local nX        := 0
Local nY        := 0
Local nInclui   := 0
Local cCadastro := ""
Local cAliasQry := ""
Local cDescr    := ""
Local cLine     := ""
Local bLine     := ""
Local oOk       := LoadBitMap(GetResources(), "LBOK")
Local oNo       := LoadBitMap(GetResources(), "LBNO")
Local oDlg
Local oQual
Local lQuery    := .F.
Local lSalida:=.T.
Local cQuery
Local aAux
Local nCntFor   := 0
Local nz        := 0
Static lMt120C1D := Nil, lMt120C1C := Nil

If empty(cCliente)
	MsgInfo("Debe completar el cliente!", "Atenci�n")
	Return 
EndIf
     
dbSelectArea("SX3")
dbSetOrder(2)
For nx := 1 to Len(aCampos)
	If MsSeek(aCampos[nx])
		AADD(aHeadCpos,AllTrim(X3Titulo()) )
	EndIf
Next

		aNewF4 := {}
		
		For nX := 1 To Len( aAcopio )
			aLineF4 := aAcopio[ nX ]
			aLineNew := { .F. }
			AEval( aLineF4, { |x| AAdd( aLineNew, x ) } )
			AAdd( aNewF4, aLineNew )
		Next nX
		
		aArrayF4 := AClone( aNewF4 )
		
		If Len(aArrayF4) > 0
			nOpcA := 0
			
			cLine := "{If(aArrayF4[oQual:nAt,1],oOk,oNo)"
			
			
			For nX := 2 To Len( aHeadCpos )
				cLine += ",aArrayF4[oQual:nAT][" + AllTrim( Str( nX ) ) + "]"
			Next nX
			
			cLine += " } "
			
			//����������������������������������������������������������Ŀ
			//� Monta dinamicamente o bline do CodeBlock                 �
			//������������������������������������������������������������
			bLine := &( "{ || " + cLine + " }" )
			
			DEFINE MSDIALOG oDlg FROM 30,30 TO 565,860 TITLE cCadastro OF oMainWnd PIXEL
			
			@ 15,4 Say "Seleccion de acopios pendientes" PIXEL //"Produto"
			@ 14,30 MSGET cDescr WHEN .F. PIXEL
			oQual:= TWBrowse():New( 29,4,400,225,,aHeadCpos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oQual:SetArray(aArrayF4)
			oQual:bLDblClick := { || aArrayF4[oQual:nAt,1] := !aArrayF4[oQual:nAt,1] }
			oQual:bLine := bLine
			                                  
			
			ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||(nOpcA := 1,nSavQual:= oQual:nAT,oDlg:End())},{||(nOpcA := 0,nSavQual:= oQual:nAt,oDlg:End())},,)
			
			If nOpcA == 1 
				
				If Len(aArrayF4)>0
					For ny:=1 to Len(aArrayF4) 
						If aArrayF4[ny][1] .AND. lSalida 
							lSalida:=.F.
							aadd(ANEW,aclone(aArrayF4[ny]))
							M->F1_XNROACO:= anew[1][2] 
							cnroaco:= anew[1][2]
							M->F1_XPORC:=Posicione("Z01",1,xFilial("Z01")+M->F1_XNROACO,"Z01_XPORC")
							If Posicione("Z01",1,xFilial("Z01")+M->F1_XNROACO,"Z01_FCHVEN")< M->F1_EMISSAO
							   Aviso("El acopio seleccionado tiene fecha de vencimiento vencida")
							EndIf
						Endif
		   			Next
				 EndIf
			Endif
		Endif
RestArea(aArea)

Return (cnroaco)
                            


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALMONACO �Autor  �Microsiga           �Fecha �  06/26/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Ejecuta store procedure de los acopios pendientes         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function Pendient()
Local cQuery	:=""    
Local aAcopio   := {}

cQuery := "exec [QRY_VAL_ACOPIO_"+SM0->M0_CODIGO+"]'"+ cCliente +"'"
cQuery := PLSAvaSQL(cQuery)
  If Select("TODO01") <> 0
	DBSelectArea("TODO01")
	TODO01->(DBCloseArea())
  EndIf
// Executa a Query
PLSQuery(cQuery,"TODO01")
// Vai para o inicio da area de trabalho
TODO01->(DBGoTop())
    While TODO01->(!Eof())
   		AADD( aAcopio, {TODO01->ACOPIO,TODO01->VALOR,Posicione("Z01",1,Xfilial("Z01")+TODO01->ACOPIO,"Z01_EMIS"),ALLTRIM(Posicione("Z01",1,Xfilial("Z01")+TODO01->ACOPIO,"Z01_XDIRO"))} )
    	DbSkip()
	Enddo

Return(aAcopio)