/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA416PV     ºAutor  ³MS				 ºFecha ³  06-11-10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de entrada para transferir datos del presupuesto	  º±±
±±º          ³ al pedido de venta								          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA416PV()

*/
Local aarea := getarea()
Local aAreaSB1 := SB1->(Getarea())
Local aAreaSCK := SCK->(Getarea())
Local aAreaSBG	:= SBG->(GetArea())
Local aAreaSF4	:= SF4->(GetArea())

//PUBLIC nMTA416PV := SCK->CK_QTDVEN
//PUBLIC cMTA416P2 := SCK->CK_LOCAL

//datos cabecera pedido
M->C5_XOBS1		:= SCJ->CJ_XOBS1 	// Observaciones Factura
M->C5_XOBS2		:= SCJ->CJ_XOBS2		// Observaciones Remito
M->C5_MOEDA   	:= SCJ->CJ_MOEDA
M->C5_DOCGER  	:= SCJ->CJ_DOCGER
/*
M->C5_ORIGEM 	:= SCJ->CJ_ORIGEM
M->C5_PAISENT	:= SCJ->CJ_PAISENT
M->C5_TPVENT	:= SCJ->CJ_TPVENT 
M->C5_IDIOMA  	:= SCJ->CJ_IDIOMA
M->C5_PERMISS  	:= SCJ->CJ_PERMISS   
M->C5_INCOTER  	:= SCJ->CJ_INCOTER   
M->C5_FECDSE  	:= SCJ->CJ_FECDSE
M->C5_FECHSE  	:= SCJ->CJ_FECHSE
M->C5_TXREF  	:= SCJ->CJ_TXREF
*/
M->C5_TRANSP  	:= POSICIONE('SA1',1,XFILIAL('SA1')+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_TRANSP")
M->C5_XNOMTRA   := POSICIONE('SA4',1,XFILIAL('SA4')+M->C5_TRANSP,"A4_NOME")
M->C5_XNOMCLI   := POSICIONE('SA1',1,XFILIAL('SA1')+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_NOME")    
M->C5_XENDENT  	:= SCJ->CJ_XENDENT

// items del pedido
//nPosQTDLIB	:= Ascan( aHeadC6, { |x| Trim(x[2]) == 'C6_QTDLIB' } )       
//_aCols[ParamIxb][nPosQTDLIB]	:= 	SCK->CK_QTDVEN
/*
nPosConta  	:= Ascan( aHeadC6, { |x| Trim(x[2]) == 'C6_XCONTA' } )
nPosCC  	:= Ascan( aHeadC6, { |x| Trim(x[2]) == 'C6_XCCUSTO' } )

*/
nPosXlis	:= Ascan( aHeadC6, { |x| Trim(x[2]) == 'C6_XLISTA' } )
nPosTes 	:= Ascan( aHeadC6, { |x| Trim(x[2]) == 'C6_TES' } )
nPosLocal	:= Ascan( aHeadC6, { |x| Trim(x[2]) == 'C6_LOCAL' } )
nPosOBS  	:= Ascan( aHeadC6, { |x| Trim(x[2]) == 'C6_OBS' } )
nPosDESCRI	:= Ascan( aHeadC6, { |x| Trim(x[2]) == 'C6_DESCRI' } )
nPosEMISSAO	:= Ascan( aHeadC6, { |x| Trim(x[2]) == 'C6_EMISSAO' } )
nPosDTCLIEN	:= Ascan( aHeadC6, { |x| Trim(x[2]) == 'C6_DTCLIEN' } )
nPosENTREG	:= Ascan( aHeadC6, { |x| Trim(x[2]) == 'C6_ENTREG' } )




_aCols[ParamIxb][nPosobs]  	 := SCK->CK_OBS
_aCols[ParamIxb][nPosTES]    := IF(SCJ->CJ_DOCGER=='3',STR(VAL(SCK->CK_TES)+1,3),SCK->CK_TES)
_aCols[ParamIxb][nPosLOCAL]  := SCK->CK_LOCAL
_aCols[ParamIxb][nPosDESCRI] := SCK->CK_DESCRI
_aCols[ParamIxb][nPosENTREG] := SCK->CK_ENTREG
If nPosXlis	> 0 
	_aCols[ParamIxb][nPosXlis] := SCK->CK_XLISTA
EndIf
*/
/*
DbSelectArea("SBG")
DbSetOrder(1)
If MsSeek(xFilial("SBG")+SCK->CK_PRODUTO,.F.)

	DbSelectArea("SF4")
	DbSetOrder(1)
	MsSeek(xFilial("SF4")+SCK->CK_TES)				

	If ( SBG->BG_GERAOP $ "S" .And. Empty(SCK->CK_NUMOP) .And. SF4->F4_ESTOQUE == "S" )
		RecLock("SCK",.F.)
			CK_QTDVEN := 99999999 
			CK_LOCAL := GetNewPar("MV_XLOCRES","")
		MsUnlock()
	EndIf
	
EndIf
*/
RestArea(aAreaSF4)
RestArea(aAreaSBg)
restarea(aareasb1)
restarea(aareasck)
restarea(aarea)
Return ()