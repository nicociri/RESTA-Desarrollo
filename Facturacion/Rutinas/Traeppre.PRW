#include 'Protheus.ch'
#include 'rwmake.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TRAEPpreAutor  ³Microsiga           ºFecha ³  12/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³LBRXFUNA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TraePpre()  //Version de pablo

Local aArea     := GetArea()
Local aAreaSB1  := SB1->(GEtArea())
Local aCampos   := {"B1_COD","B1_DESC","B2_QATU","DA1_PRCVEN"}
Local aHeadCpos := {" "}
Local aHeadUser := {}
Local aNew      := {}
Local aLineNew  := {}
Local aNewF4    := {}
Local aLineF4   := {}
Local aArrayF4  := {}
Local aSavRec   := {}
Local aFiltro   := {}
Local aRecTMP1	:= {}
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
Local cItem     := "01"
Local lAux		:= .T.
Local oOk       := LoadBitMap(GetResources(), "LBOK")
Local oNo       := LoadBitMap(GetResources(), "LBNO")
Local oDlg
Local oQual
Local lQuery    := .F.
Local cQuery
Local aAux
Local nCntFor   := 0
Local nz        := 0
Local NPosQuant	:= GdFieldPos("CK_QTDVEN")
Local NPositem	:= GdFieldPos("CK_QTDVEN")
Local cPerg	:= Padr("TRAEPROD",10)
Local xPar01 := MV_PAR01
Local xPar02 := MV_PAR02  
Local _aCols
Static lMt120C1D := Nil, lMt120C1C := Nil

AjustaSX1()
If empty(M->CJ_TABELA)
	MsgInfo("Debe completar la Lista de Precios!", "Atención")
	Return 
EndIf

lFiltra := pergunte(cPerg,.T.)


//dbSelectArea("SCK")
//NPosQuant	:= GdFieldPos("CK_QTDVEN")

dbSelectArea("SX3")
dbSetOrder(2)
For nx := 1 to Len(aCampos)
	If MsSeek(aCampos[nx])
		AADD(aHeadCpos,AllTrim(X3Titulo()) )
	EndIf
Next

	cQuery := "SELECT B1_COD,B1_DESC,B2_QATU - B2_RESERVA as B2_QATU, DA1_PRCVEN "
	cQuery += " FROM " + RetSqlName("SB1") + " SB1 LEFT JOIN "+ RetSqlname("SB2")+ " SB2 ON " 
	cQuery += " B2_COD = B1_COD AND B2_LOCAL = B1_LOCPAD AND SB2.D_E_L_E_T_ <> '*'   AND B2_FILIAL ='" + xFilial("SB2") +"'" 
	cQuery += " LEFT JOIN "+ RetSqlname("DA1") + " DA1 ON DA1_CODPRO = B1_COD AND DA1_CODTAB ='" +M->CJ_TABELA+"' AND DA1.D_E_L_E_T_ <> '*' AND DA1_FILIAL ='" + xFilial("DA1") +"'"
	cQuery += " WHERE SB1.D_E_L_E_T_ <> '*'  AND B1_FILIAL ='" + xFilial("SB1") +"'"
	iF !eMPTY(MV_PAR01) .and. lFiltra
	cQuery += " AND B1_DESC LIKE '%"+ Alltrim(Upper(MV_PAR01)) +"%' "
	Endif
	iF !eMPTY(MV_PAR02) .and. lFiltra
	cQuery += " AND B1_COD LIKE '%"+ Alltrim(Upper(MV_PAR02)) +"%' "
	Endif
	
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", tcGenQry(,, cQuery), "TRB", .F., .T.)
	
	TRB->(dbGoTop())
	
	While TRB->(!Eof())
		If Eval( bIf )
			AADD(aArrayF4,{TRB->B1_COD,TRB->B1_DESC,TRB->B2_QATU,TRB->DA1_PRCVEN})
		EndIf
		TRB->(dbSkip())
	EndDo
	
	TRB->( dbCloseArea() )
	
	If Len(aArrayF4) == 0
		MsgInfo("No Existen productos con esta descripcion ","Verifique")
	Else
		aNewF4 := {}
		
		For nX := 1 To Len( aArrayF4 )
			aLineF4 := aArrayF4[ nX ]
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
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta dinamicamente o bline do CodeBlock                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			bLine := &( "{ || " + cLine + " }" )
			
			DEFINE MSDIALOG oDlg FROM 30,30 TO 565,860 TITLE cCadastro OF oMainWnd PIXEL
			
			@ 15,4 Say "Seleccione los Productos" PIXEL //"Produto"
			@ 14,30 MSGET cDescr WHEN .F. PIXEL
			oQual:= TWBrowse():New( 29,4,400,225,,aHeadCpos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oQual:SetArray(aArrayF4)
			oQual:bLDblClick := { || aArrayF4[oQual:nAt,1] := !aArrayF4[oQual:nAt,1] }
			oQual:bLine := bLine
			
			ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||(nOpcA := 1,nSavQual:= oQual:nAT,oDlg:End())},{||(nOpcA := 0,nSavQual:= oQual:nAt,oDlg:End())},,)
			
			If nOpcA == 1 
//				_acols := Array(0)
//				_acols := Array(0)
		aAreaTMP1 := TMP1->(GetArea())
		nItem	:= 0 
	     TMP1->(Dbgotop())

     While TMP1->(!EOF())
          nItem++
          cItem := TMP1->CK_ITEM
          TMP1->(dbskip())
     End
     
     RestArea(aAreaTMP1)     

     //Ajusta o sequencial do itens
     If nItem==1
          cItem := "01"
//     else
  //        cItem := TMP1->CK_ITEM
     endif
     
     //Iniciar a população das linhas
				For nx := 1 to Len(aArrayF4)
					
					If aArrayF4[nx][1]
						FOR NX:= 1 TO LEN(aArrayF4)
							if aArrayF4[nx][1]
								aadd(ANEW,aclone(aArrayF4[nx]))
							endif
						Next
						
					For nz:= 1 to len(anew)
			        If nz == 1
		               If nItem==1
//        		            oGetDad:AddLine()
				            TMP1->(dbGotop())
		               Else                         
		               SET DELETED OFF 
   	                       TMP1->(DbGotop())  // voy al primer registro
   	                       TMP1->(DBRECALL()) // recupero el registro elminado
   		               SET DELETED ON
	            //           TMP1->(DbGoto(LastRec()))
				            TMP1->(dbGoBottom())
	        //    		      oGetDad:AddLine()
        		           // TMP1->(DBGOTO(nITEM+1)) 
        		           
						  //	   oGetDad:Refresh() 
//							   oGetDad:ForceRefresh()
        					cItem := soma1(cItem)
		                    lAux:=.T.
		               Endif                    
                   Else
			 	   cItem := soma1(cItem)
//            	   oGetDad:AddLine()
            	   EndIf
				          Reclock("TMP1",.T.)
				          For nW := 1 To Len(aHeader)  
				          		If !( AllTrim(aHeader[nw,2]) $ "CK_ALI_WT/CK_REC_WT")	
							FieldPut(nW,CriaVar(aHeader[nW,2],.T.))
							EndIF
							Next nW
							
							For nCntFor := 1 To Len(aHeader)
								SB1->(DbSeek( xFilial("SB1") + anew[nz][2] ))
								SF4->(DbSeek( xFilial("SF4") + SB1->B1_TS))
								Do Case
									Case Trim(aHeader[nCntFor,2]) == "CK_PRODUTO"
										TMP1->CK_PRODUTO         := anew[nz][2]
										//M->CK_PRODUTO         := anew[nz][2]
										 A415PROD(TMP1->CK_PRODUTO)                                                                                 
									Case Trim(aHeader[nCntFor,2]) == "CK_QTDVEN"
										TMP1->CK_QTDVEN       := 1
									Case Trim(aHeader[nCntFor,2]) == "CK_TES"
										TMP1->CK_TES        := SB1->B1_TS
									
									Case Trim(aHeader[nCntFor,2]) == "CK_XTESDES"
										TMP1->CK_TES         := SF4->F4_TEXTO
										
									Case Trim(aHeader[nCntFor,2]) == "CK_CF"
										TMP1->CK_CF          := SubStr(SF4->F4_CF,1,3)
									Case Trim(aHeader[nCntFor,2]) == "CK_LOCAL"
										TMP1->CK_LOCAL       := RetFldProd(SB1->B1_COD,"B1_LOCPAD")
									
									Case Trim(aHeader[nCntFor,2]) == "CK_FILENT"
										TMP1->CK_FILENT       := M->CJ_FILENT
									Case Trim(aHeader[nCntFor,2]) == "CK_FILVEN"
										TMP1->CK_FILVEN       := xFilial("SCJ")
									Case Trim(aHeader[nCntFor,2]) == "CK_ENTREG"
										TMP1->CK_ENTREG       := M->CJ_EMISSAO
									Case Trim(aHeader[nCntFor,2]) == "CK_DT1VEN"
										TMP1->CK_DT1VEN       := M->CJ_EMISSAO
									Case Trim(aHeader[nCntFor,2]) == "CK_UM"
										TMP1->CK_UM          := SB1->B1_UM
									Case Trim(aHeader[nCntFor,2]) == "CK_DESCRI"
										TMP1->CK_DESCRI     := Posicione("SB1",1,xFilial("SB1")+anew[nz][2],"B1_DESC")
								EndCase 
						   oGetDad:Refresh() 
							   oGetDad:ForceRefresh()
							   oGetDad:nCount := Reccount("TMP1")
							Next nCntFor  
							TMP1->CK_ITEM := cItem
							TMP1->(Msunlock())
							A415LinOk(oGetDad)
							   oGetDad:Refresh() 
							   oGetDad:ForceRefresh()
							   oGetDad:nCount := Reccount("TMP1")
						     
								//ModxAtuObj()
						NEXT Nz
					endif
				next
				
			Endif
		Endif
	EndIf                       
	                       TMP1->(DbGoto(LastRec()))
//IF lAux==.F.
   TMP1->(DBGOTOP())
//     TMP1->(DBdelete())

//ENDIF

   oGetDad:nCount := nz +1
   oGetDad:ForceRefresh()
RestArea(aAreaSB1)
RestArea(aArea)

		 
//If Type("oGetDad") <> "U"
//	oGetDad:oBrowse:Refresh()
//Endif	

MV_PAR01 := xPar01
MV_PAR02 := xPar02
                                  
//A415TabAlt()
Return
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSx1  ºAutor ³ 				      º Data ³  11/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Parametros de la consulta							          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1()
	Local aArea := GetArea()
	Local aRegs := {}, i, j
	Local cPerg := ""
	cPerg := Padr("TRAEPROD",Len(SX1->X1_GRUPO))

	DbSelectArea("SX1")
	DbSetOrder(1)

	aAdd(aRegs,{cPerg,"01","Descripcion	","Descripcion 	","Descripciòn	","mv_ch1","C",TAMSX3("B1_DESC")[1],0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	aAdd(aRegs,{cPerg,"02","Cod. Producto	","Cod. Producto","Cod. Producto","mv_ch2","C",TAMSX3("B1_COD")[1],0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )

	
	For i:=1 to Len(aRegs)
	   If !dbSeek(cPerg+aRegs[i,2])
		  RecLock("SX1",.T.)
		  For j:=1 to FCount()
			 If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			 Endif
		  Next
		  MsUnlock()
		Endif
	Next
	RestArea(aArea)
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A415GrvSCL³ Autor ³ Eduardo Riera         ³ Data ³ 05.12.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de Atualizacao do Arquivo Temporario referente ao ³±±
±±³          ³ SCL                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void A415GrvSCL(aHeader,_acols)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aHeader e _acols                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A415GrvSCL(aHeader,_acols)

Local nX  := 0
Local nX2 := 0
Local nUsado  := nacols   := 0
Local nProduto:= aScan(aHeader,{|x| Trim(x[2])=="CL_PRODUTO" })
Local aArea   := GetArea()

dbSelectArea("TMP2")
dbSetOrder(1)
MsSeek(M->CJ_NUM+TMP1->CK_ITEM,.T.)
While  ( !Eof() .And. M->CJ_NUM+TMP1->CK_ITEM==TMP2->CL_NUM+TMP2->CL_ITEMORC )
	RecLock("TMP2")
	dbDelete()
	MsUnlock()
	dbSelectArea("TMP2")
	dbSkip()
EndDo
nacols := Len(_acols)
For nX := 1 To nacols
	If ( nProduto > 0 )
		If ( !Empty(_acols[nX,nProduto]) )
			nUsado := Len(aHeader)
			RecLock("TMP2",.T.)
			For nX2 := 1 To nUsado
				If !( AllTrim(aHeader[nX2,2]) $ "CL_ALI_WT/CL_REC_WT")				
					nPosField := FieldPos(Trim(aHeader[nX2,2]))
					If ( nPosField > 0 )
						FieldPut(nPosField,_acols[nX,nX2])
					EndIf
				EndIf
			Next nX2
			TMP2->CL_NUM      := M->CJ_NUM
			TMP2->CL_ITEMORC  := TMP1->CK_ITEM
			TMP2->CL_FLAG     := _acols[nX,nUsado+1]
			MsUnlock()
		EndIf
	EndIf
Next nX
RestArea(aArea)
Return(.T.)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A415GeraCL³ Autor ³ Eduardo Riera         ³ Data ³ 05.12.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de Preenchimento da aCols                         ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ aCols A415GeraCL(Void)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A415GeraCL()

Local aArea		:= GetArea()
Local aHeader  := {}
Local aCols    := {}
Local nUsado	:= 0
Local nX	:= 0
Local nAcols	:= 0
Local nPos		:= 0
Local nPos2		:= 0
Local nPosItem  := 0
Local nItem		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := aHeaderSCL
nUsado  := Len(aHeader)
nPosItem:= aScan(aHeader,{|x| Trim(x[2]) == "CL_ITEM" })
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VerIfico se existe no temporario registros validos           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TMP2") // SCL
dbSetOrder(1)
MsSeek(M->CJ_NUM+TMP1->CK_ITEM,.T.)
While  ( !Eof() .And. M->CJ_NUM+TMP1->CK_ITEM==TMP2->CL_NUM+TMP2->CL_ITEMORC )
	aadd( aCols , Array(nUsado+1) )
	nACols := Len(aCols)
	For nX := 1 To Len(aHeader)
		If ( aHeader[nX][10] <> "V")
			aCols[nAcols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
		Else
			aCols[nAcols][nX] := CriaVar(aHeader[nX][2],.T.)
		EndIf
	Next nX
	aCols[nAcols,nUsado+1] := TMP2->CL_FLAG
	dbSelectArea("TMP2")
	dbSkip()
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico se o Produto e'uma sugestao de venda e se o acols   ³
//³ esta vazia                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Empty(aCols) )
	nItem := 0
	dbSelectArea("SBH")
	dbSetOrder(1)
	MsSeek(xFilial()+TMP1->CK_PRODUTO,.T.)
	While  ( !Eof() .And. xFilial()==SBH->BH_FILIAL .And. ;
			SBH->BH_PRODUTO == TMP1->CK_PRODUTO )
		aadd( aCols , Array(nUsado+1) )
		nACols := Len(aCols)
		nPos   := 0
		For nX := 1 To Len(aHeader)
			Do Case
			Case Trim(aHeader[nX,2])=="CL_PRODUTO"
				aCols[nACols,nX] := SBH->BH_CODCOMP
				If ( nPos > 0 )
					dbSelectArea("SB1")
					dbSetOrder(1)
					MsSeek(xFilial()+aCols[nAcols,nX])
					aCols[nAcols,nPos] := PadL(SB1->B1_DESC,TamSX3("CL_DESCRI")[1])
				EndIf
				nPos := nX
			Case Trim(aHeader[nX,2])=="CL_QUANT"
				aCols[nACols,nX] := SBH->BH_QUANT
			Case Trim(aHeader[nX,2])=="CL_DESCRI"
				If ( nPos > 0 )
					dbSelectArea("SB1")
					dbSetOrder(1)
					MsSeek(xFilial()+aCols[nAcols,nPos])
					aCols[nAcols,nX] := PadL(SB1->B1_DESC,TamSX3("CL_DESCRI")[1])
				EndIf
				nPos := nX
			OtherWise     
				If !( AllTrim(aHeader[nX,2]) $ "CL_ALI_WT/CL_REC_WT")	
					aCols[nAcols][nX] := CriaVar(aHeader[nX][2],.T.)
				EndIf
			EndCase
		Next nX
		aCols[nAcols,nPosItem] := StrZero(++nItem,2)
		aCols[nAcols,nUsado+1] := .F.
		dbSelectArea("SBH")
		dbSkip()
	EndDo
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se nÆo existir registros validos e'criada uma aCols vazia    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Empty(aCols) )
	aadd( aCols , Array(nUsado+1) )
	nACols := Len(aCols)
	For nX := 1 To nUsado
		If !( AllTrim(aHeader[nX,2]) $ "CL_ALI_WT/CL_REC_WT")	
			aCols[nAcols][nX] := CriaVar(aHeader[nX][2],.T.)
		EndIf	
	Next nX
	aCols[nAcols,nUsado+1] := .F.
	aCols[nAcols,nPosItem] := "01"
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o a Qtd Necessaria para o orcamento               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPos := aScan(aHeader,{|x| Trim(x[2]) == "CL_QTDVEN" })
nPos2:= aScan(aHeader,{|x| Trim(x[2]) == "CL_QUANT" })
nACols := Len(aCols)
If ( nPos > 0 .And. nPos2 > 0 )
	For nX := 1 To nACols
		aCols[nX,nPos]  := aCols[nX,nPos2] * TMP1->CK_QTDVEN
	Next
EndIf
RestArea(aArea)
Return(aCols)


