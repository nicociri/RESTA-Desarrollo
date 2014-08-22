User Function lj720fim()

Local aArea := GetArea()
Local nIB2	:= 0
Local nIBP	:= 0
Local lRet	:= .T.
local _cDoc
local _cSerie
Local _cCliente
Local _cTienda
Local cTipo			:= ''
Local cFornece		:= ''
Local cLojFor		:=''
local aArea2		:={}
Local cSerie		:='B1'
Local cNumDoc		:=''
Local aAreaSF1 :={} 
Local aDatos	:={}   
Local aHead		:={}
Local aItems	:={} 
Local _nOpca

//Valido que no haya habido problemas
if len(paramixb[1]) < 2 // si tiene menos de eso, es que hubo algun error.
	return (.T.)
else
	dbselectarea("SF1")
	dbsetorder(1)
	if !dbseek(Xfilial("SF1")+paramixb[1][2]+paramixb[1][1]+paramixb[1][3]+paramixb[1][4]) //A esta altura, si se cancelo la operacion
		return (.T.)																		//borro la NCC de la SF1
	endif
endif

_cDoc		:= paramixb[1][2]
_cSerie		:= paramixb[1][1]
_cCliente	:=paramixb[1][3]
_cTienda	:=paramixb[1][4]
_nOpca		:= Paramixb[1][5]   // si es 1 es cambio si es 2 es devolucion 


iF _nOpca	== 1 // si es Cambio
	dbselectarea("SF1")
	dbsetorder(1)
	dbseek(Xfilial("SF1")+_cDoc+_cSerie+_cCliente+_cTienda)
	Reclock("SF1",.F.)
	Replace SF1->F1_VEND1 With SL1->L1_VEND        
	Msunlock() 
Else              
		dbselectarea("SF1")
		dbsetorder(1)
		dbseek(Xfilial("SF1")+_cDoc+_cSerie+_cCliente+_cTienda)
		DbSelectArea("SD1")
		DbSetOrder(1)
		DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE)
	If !(empty(SD1->D1_NFORI))	// SI TIENE FACTURA ORIGINAL
	Reclock("SF1",.F.)
	Replace SF1->F1_VEND1 With	Posicione("SL1",2,Xfilial("SL1")+SD1->D1_SERIORI+SD1->D1_NFORI,"L1_VEND")
	MsUnlock()
EndIf
EndIf
          
If nModulo != 12 .Or. cPaisLoc != "ARG"
	
	Return (.T.)
else
/*
	if !IIf(Type("lFiscal")#"U",lFiscal,.F.)
		cFornece:= _cCliente
		cLojFor:= _cTienda
		aArea2:= GetArea()
		//		DbSelectArea('SA1')
		//		DbSetOrder(1)
		//		dbSeek(xFilial("SA1")+cFornece+cLojFor)
		
		cTipo:=SA1->A1_TIPO
		If cTipo == 'I'
			cSerie:= 'A1'
		else
			if cTipo=='E'
				cSerie:='E'
			else
				cSerie:='B1'
			endif
		endif
		cNumDoc:=	tabela('01',cSerie)
		
		/******************************************************/
		/*desde aca */
		/******************************************************/
		
		//u_NccNum(cSerie, cNumDoc,cFornece, cLojFor, _cSerie, _cDoc)     
		
		/***************************************************/
		/*      Si el ciente es empleado graba la ZZS      */
		/***************************************************/

		
//	endIf
EndIf
IF lfiscal
	
	dbselectarea("SF1")
	dbsetorder(1)
	dbseek(Xfilial("SF1")+_cDoc+_cSerie+_cCliente+_cTienda)
	//RecLock('SF1',.F.)
	//		Replace F1_APHORA With time()
	//MsUnLock()
	A075IpNC()  

EndIf


RestArea( aArea )

Return( lRet )




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A075IpNC  ºAutor  ³Microsiga           º Data ³  01/16/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³LBRA075                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A075IpNC()
Local aArea    := GetArea()
Local lRet     := .F.
Local nD       := 0
Local aRecSE1  := {}
Local aRecSF3  := {}
lOCAL aRecZZO	:= {} 
Local aItems	:={}     
Local aPgto	:={}  
Private aCpos       := {}
Private _cFisSerie := ''
Private _cFisNum   := ''
Private acols	:= {}
Private aHeader   := { }
Private aEnchoice   := { }
Private aRecnos   := { 0, { } }


aRecnos[1] := SF1->(Recno())
aRecnos[2] := {}


//If MsgYesNo(OemToAnsi('Desea Imprimir la NC?'), OemToAnsi('Confirme') )
	DbSelectArea('SX3')
	DbSetOrder(1)
	DbSeek( 'SF1' )
	
	While !Eof() .and. X3_ARQUIVO == 'SF1'
		If X3Uso( X3_USADO )
			Aadd( aEnchoice, Alltrim( X3_CAMPO ) )
		Endif
		DbSkip()
	EndDo
	
	DbSeek( 'SD1' )
	
	While !Eof() .and. X3_ARQUIVO == 'SD1'
		If X3Uso( X3_USADO )
			aAdd( aHeader,{ X3Titulo(), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, Alltrim(X3_VALID),X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } )
			aAdd( aCpos, X3_CAMPO )
		Endif
		DbSkip()
	EndDo
	
	nLen  := Len( aHeader )
	
	dbSelectArea('SD1')
	dbSetOrder( 1 )
	dbSeek( Xfilial("SF1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
	
	
	
	While !Eof() .And. Xfilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA==;
		SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
		aAdd( aCols, Array( nLen + 1 ) )
		nCols    := Len( aCols )
		
		For nX := 1 To nLen
			cCampo   := Alltrim( aHeader[nX][2] )
			If Alltrim( aHeader[nX][10] ) <> 'V'
				aCols[nCols][nX] := &cCampo
			EndIf
		Next
		
		aCols[nCols][nLen+1] := .F.
		Aadd( aRecnos[2], SD1->(Recno()) )
		DbSkip()
	EndDo
	
	lRet := U_A075NCND( 'C' )
	
	If lRet
		RecLock('SF1',.F.)
		Replace F1_PRINTED With 'S'
		Replace F1_CAJALOJ With xNumCaixa() //Esto lo puse para usar en ResumCx.PRW
		MsUnLock()
		
		If !Empty(_cFisSerie) .and. !Empty(_cFisNum)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Actualizo SE1                                                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Diegho ÄÄÄÄÙ
			SE1->(DbSetOrder(2))
			SE1->(DbSeek(xFilial('SE1')+SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)))
			While !SE1->(Eof()) .and. xFilial('SE1')+SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC) == ;
				SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
				If Alltrim(SF1->F1_ESPECIE) == Alltrim( SE1->E1_TIPO )
					Aadd( aRecSE1, SE1->(RecNo()) )
				EndIf
				SE1->(DbSkip())
			EndDo
			
			For nD := 1 To Len(aRecSE1)
				SE1->(DbGoTo(aRecSE1[nD]))
				RecLock('SE1',.F.)
				Replace E1_PREFIXO With _cFisSerie
				Replace E1_SERIE   With _cFisSerie
				Replace E1_NUM     With _cFisNum
				Replace E1_NUMNOTA With _cFisNum
				Replace E1_PORTADO With xnumcaixa()  // Grabo el portador para el resumen de caja!!
				MsUnLock()
			Next
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Actualizo SD1                                                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Diegho ÄÄÄÄÙ
			For nD := 1 To Len(aRecnos[2])
				SD1->(DbGoTo(aRecnos[2][nD]))
				RecLock('SD1',.F.)
				Replace D1_SERIE   With _cFisSerie
				Replace D1_DOC     With _cFisNum
				MsUnLock()
			Next
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Actualizo SF3                                                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Diegho ÄÄÄÄÙ
			SF3->(DbSetOrder(4))
			SF3->(DbSeek(xFilial('SF3')+SF1->(F1_FORNECE+F1_LOJA+F1_DOC+F1_SERIE)))
			While !SF3->(Eof()) .and. xFilial('SF3')+SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC) == ;
				SF3->(F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_SERIE+F3_NFISCAL)
				If Alltrim(SF1->F1_ESPECIE) == Alltrim( SF3->F3_ESPECIE )
					Aadd( aRecSF3, SF3->(RecNo()) )
				EndIf
				SF3->(DbSkip())
			EndDo
			
			For nD := 1 To Len(aRecSF3)
				SF3->(DbGoTo(aRecSF3[nD]))
				RecLock('SF3',.F.)
				Replace F3_SERIE   With _cFisSerie
				Replace F3_NFISCAL With _cFisNum
				MsUnLock()
			Next
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Actualizo SF1                                                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Diegho ÄÄÄÄÙ
			SF1->(DbGoTo(aRecnos[1]))
			RecLock('SF1',.F.)
			Replace F1_SERIE   With _cFisSerie
			Replace F1_DOC     With _cFisNum
			Replace F1_DUPL    With _cFisNum
			MsUnLock()
		EndIf
	EndIf

	If Type('oDlg') == 'O'
		oDlg:End()
	EndIf
	
//EndIf
RestArea( aArea )

Return


