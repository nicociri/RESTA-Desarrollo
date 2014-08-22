#Include 'Protheus.ch'
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LBRA075   �Autor  �Microsiga           � Data �  01/16/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function LBRA075()

Local aColors     := {}
Local cPerg       := Padr( 'LBR075', 10 )

Private cFilSF1   := xFilial('SF1')
Private cFilSD1   := xFilial('SD1')
Private cFilSF2   := xFilial('SF2')
Private cFilSD2   := xFilial('SD2')
Private aRecnos   := { 0, { } }
Private aRotina   := {}
Private cCadastro := ''

ValidPerg( cPerg )

If !Pergunte( cPerg, .T. )
	Return
EndIf

If MV_PAR01 == 1
	aRotina := {	{ OemToAnsi( 'B&uscar'    ), 'AxPesqui()'   , 0, 1 },;
	{ OemToAnsi( '&Visualizar'), 'U_A075NC(1)', 0, 2 },;
	{ OemToAnsi( '&Imprimir'  ), 'U_A075NC(2)', 0, 2 },;
	{ OemToAnsi( '&Leyenda'   ), 'U_A075Ly()' , 0, 6 } }
	
	Aadd( aColors, { 'Empty(SF1->F1_PRINTED)', 'BR_VERDE'   } )
	cCadastro := OemToAnsi( 'Notas de Credito sin Imprimir' )
	
	DbSelectArea('SF1')
	DbSetOrder(1)
	
	MsFilter( "cFilAnt == F1_FILIAL .And. F1_ESPECIE == '" + Padr('NCC',Len(SF2->F2_ESPECIE)) + "' .And. Empty(F1_PRINTED)" )
	_cAlias := 'SF1'
Else
	aRotina := {	{ OemToAnsi( 'B&uscar'    ), 'AxPesqui()'   , 0, 1 },;
	{ OemToAnsi( '&Visualizar'), 'U_A075ND(1)', 0, 2 },;
	{ OemToAnsi( '&Imprimir'  ), 'U_A075ND(2)', 0, 2 },;
	{ OemToAnsi( '&Leyenda'   ), 'U_A075Ly()' , 0, 6 } }
	
	Aadd( aColors, { 'Empty(SF2->F2_PRINTED)', 'BR_VERDE'   } )
	cCadastro := OemToAnsi( 'Notas de Debito sin Imprimir' )
	
	dbSelectArea('SF2')
	dbSetOrder(1)
	
	MsFilter( "cFilAnt == F2_FILIAL .And. F2_ESPECIE == '" + Padr( 'NDC',Len(SF2->F2_ESPECIE)) + "' .And. Empty(F2_PRINTED)" )
	_cAlias := 'SF2'
EndIf

dbGoTop()
mBrowse( 6, 1,22,75,_cAlias,,,,,,aColors)

dbSelectArea(_cAlias)
dbClearFil()

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A075NC    �Autor  �Microsiga           � Data �  01/16/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �LBRA075                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function A075NC( nTipo )

Local lOkEnt      := .F.
Local aEnchoice   := { }
Local cTitulo     := cCadastro
Local nMaxFor     := 0
Local aAltEnch    := { }
Local aHab        := { }
Local lVirtual    := .F.
Local oGetDados
Local cLinOk      := ''
Local cTudoOk     := ''
Local cFieldOk    := 'AllWaysTrue()'
Local nOpca
Local nOcupada
Local l020Visual  := .T.
Local l020Inclui  := .F.
Local l020Deleta  := .F.
Local l020Altera  := .F.
Local aCpos       := {}
Local nX          := 0

Private oDlg
Private oLib, oRes, oOcu, oTot
Private nLib      := 0
Private nRes      := 0
Private nOcu      := 0
Private nTot      := 0
Private aHeader   := { }
Private aCols     := { }
Private aTela     := Array(0,0)
Private aGets     := Array(0)
Private bCampo    := { |nCPO| Field(nCPO) }
Private aRegSD1   := {}
Private lRefresh  := .T.

VISUAL   := .T.
INCLUI   := .F.
ALTERA   := .F.
DELETA   := .F.

aRecnos[1] := SF1->(Recno())
aRecnos[2] := {}

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
dbSeek( cFilSD1 + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )

While !Eof() .And. cFilSD1+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA==;
	SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
	aAdd( aCols, Array( nLen + 1 ) )
	nCols    := Len( aCols )
	
	For nX := 1 To nLen
		cCampo   := Alltrim( aHeader[nX][2] )
		If Alltrim( aHeader[nX][10] ) == 'V'
			aCols[nCols][nX] := CriaVar( cCampo )
		Else
			aCols[nCols][nX] := &cCampo
		EndIf
	Next
	
	aCols[nCols][nLen+1] := .F.
	Aadd( aRecnos[2], SD1->(Recno()) )
	DbSkip()
EndDo

//������������������������������������������������������������������Ŀ
//� Muestro la pantalla                                              �
//������������������������������������������������������� Diegho �����
If nTipo == 1
	RegToMemory( "SF1", .F., .F. )
	
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )
	nGetLin := aPosObj[2,1]
	
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM aSize[7], 0 TO aSize[6],aSize[5] OF oMainWnd PIXEL
	EnChoice( 'SF1', SF1->(Recno()), 2,,,,,aPosObj[1],,3,,,,,,lVirtual )
	oGetDados := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],2,cLinOk,cTudoOk,"+D1_ITEM",.T.,aCpos,0,,300,,,,,,.F.)
	ACTIVATE MSDIALOG oDlg ON INIT A075CgBar(oDlg,{||oDlg:End()},{||oDlg:End()},1)
	
	//������������������������������������������������������������������Ŀ
	//� Imprimo Directo                                                  �
	//������������������������������������������������������� Diegho �����
ElseIf nTipo == 2
	
	If lFiscal
		A075IpNC()
	Else
		u_LBRR087()
	EndIf
	
EndIf

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A075ND    �Autor  �Microsiga           � Data �  01/16/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �LBRA075                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function A075ND( nTipo )
Local lOkEnt      := .F.
Local aEnchoice   := { }
Local cTitulo     := cCadastro
Local nMaxFor     := 0
Local aAltEnch    := { }
Local aHab        := { }
Local lVirtual    := .F.
Local oGetDados
Local cLinOk      := ''
Local cTudoOk     := ''
Local cFieldOk    := 'AllWaysTrue()'
Local nOpca
Local nOcupada
Local l020Visual  := .T.
Local l020Inclui  := .F.
Local l020Deleta  := .F.
Local l020Altera  := .F.
Local aCpos       := {}
Local nX          := 0

Private oDlg
Private oLib, oRes, oOcu, oTot
Private nLib      := 0
Private nRes      := 0
Private nOcu      := 0
Private nTot      := 0
Private aHeader   := { }
Private aCols     := { }
Private aTela     := Array(0,0)
Private aGets     := Array(0)
Private bCampo    := { |nCPO| Field(nCPO) }
Private aRegSD2   := {}
Private lRefresh  := .T.

VISUAL   := .T.
INCLUI   := .F.
ALTERA   := .F.
DELETA   := .F.

aRecnos[1] := SF2->(Recno())
aRecnos[2] := {}

DbSelectArea('SX3')
DbSetOrder(1)
DbSeek( 'SF2' )

While !Eof() .and. X3_ARQUIVO == 'SF2'
	If X3Uso( X3_USADO )
		Aadd( aEnchoice, Alltrim( X3_CAMPO ) )
	Endif
	DbSkip()
EndDo

DbSeek( 'SD2' )

While !Eof() .and. X3_ARQUIVO == 'SD2'
	If X3Uso( X3_USADO )
		aAdd( aHeader,{ X3Titulo(), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, Alltrim(X3_VALID),X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } )
		aAdd( aCpos, X3_CAMPO )
	Endif
	DbSkip()
EndDo

nLen  := Len( aHeader )

DbSelectArea('SD2')
DbSetOrder( 3 )
DbSeek( cFilSD2 + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA )

While !Eof() .And. cFilSD2+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA==;
	SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
	aAdd( aCols, Array( nLen + 1 ) )
	nCols    := Len( aCols )
	
	For nX := 1 To nLen
		cCampo   := Alltrim( aHeader[nX][2] )
		If Alltrim( aHeader[nX][10] ) == 'V'
			aCols[nCols][nX] := CriaVar( cCampo )
		Else
			aCols[nCols][nX] := &cCampo
		EndIf
	Next
	
	aCols[nCols][nLen+1] := .F.
	Aadd( aRecnos[2], SD2->(Recno()) )
	DbSkip()
EndDo

//������������������������������������������������������������������Ŀ
//� Muestro la pantalla                                              �
//������������������������������������������������������� Diegho �����
If nTipo == 1
	RegToMemory( "SF2", .F., .F. )
	
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )
	nGetLin := aPosObj[2,1]
	
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM aSize[7], 0 TO aSize[6],aSize[5] OF oMainWnd PIXEL
	EnChoice( 'SF2', SF2->(Recno()), 2,,,,,aPosObj[1],,3,,,,,,lVirtual )
	oGetDados := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],2,cLinOk,cTudoOk,"+D2_ITEM",.T.,aCpos,0,,300,,,,,,.F.)
	ACTIVATE MSDIALOG oDlg ON INIT A075CgBar(oDlg,{||oDlg:End()},{||oDlg:End()},2)
	
	//������������������������������������������������������������������Ŀ
	//� Imprimo Directo                                                  �
	//������������������������������������������������������� Diegho �����
ElseIf nTipo == 2
	If lFiscal
		A075IpND()
	Else
		u_lbrr086()
	EndIf
EndIf

Return


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A075Ly    �Autor  �Microsiga           � Data �  01/16/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �LBRA075                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function A075Ly()
Local aLey  := { }

Aadd( aLey, { 'BR_VERDE',   OemToAnsi( 'NCC sin Imprimir' ) } )

BrwLegenda( cCadastro, OemToAnsi( 'Leyenda' ), aLey )

Return


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A075CgBar �Autor  �Microsiga           � Data �  01/16/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �LBRA075                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function A075CgBar( oDlg, bOk, bCancel, nOpc)
Local aButtons   := {}
Local aButtonUsr := {}
Local nI         := 0

If nOpc == 1
	Aadd( aButtons,{"PEDIDO",{|| If(lFiscal,A075IpNC(),MsgInfo("Usuario no Fiscal","Sin acceso")) },'Impresion por Impresora Fiscal', 'Imprimir' })
Else
	Aadd( aButtons,{"PEDIDO",{|| If(lFiscal,A075IpND(),MsgInfo("Usuario no Fiscal","Sin acceso")) },'Impresion por Impresora Fiscal', 'Imprimir' })
EndIf

Return( EnchoiceBar( oDlg, bOK, bcancel,, aButtons) )


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A075IpNC  �Autor  �Microsiga           � Data �  01/16/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �LBRA075                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function A075IpNC()
Local aArea    := GetArea()
Local lRet     := .F.
Local nD       := 0
Local aRecSE1  := {}
Local aRecSF3  := {}
lOCAL aRecZZO	:= {}

Private _cFisSerie := ''
Private _cFisNum   := ''

If MsgYesNo(OemToAnsi('Desea Imprimir la NC?'), OemToAnsi('Confirme') )
	
	lRet := U_A075NCND( 'C' )
	
	If lRet
		RecLock('SF1',.F.)
		Replace F1_PRINTED With 'S'
		Replace F1_CAJALOJ With xNumCaixa() //Esto lo puse para usar en ResumCx.PRW
		MsUnLock()
		
		If !Empty(_cFisSerie) .and. !Empty(_cFisNum)
			
			//������������������������������������������������������������������Ŀ
			//� Actualizo SE1                                                    �
			//������������������������������������������������������� Diegho �����
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
//				Replace E1_CXLOJA  With xnumcaixa()  // Grabo el portador para el resumen de caja!!
			MsUnLock()
			Next
			
			//������������������������������������������������������������������Ŀ
			//� Actualizo SD1                                                    �
			//������������������������������������������������������� Diegho �����
			For nD := 1 To Len(aRecnos[2])
				SD1->(DbGoTo(aRecnos[2][nD]))
				RecLock('SD1',.F.)
				Replace D1_SERIE   With _cFisSerie
				Replace D1_DOC     With _cFisNum
				MsUnLock()
			Next
			
			//������������������������������������������������������������������Ŀ
			//� Actualizo SF3                                                    �
			//������������������������������������������������������� Diegho �����
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
			/*
			//������������������������������������������������������������������Ŀ
			//� Actualizo ZZO                                                    �
			//������������������������������������������������������� Pablo �����
			DBSELECTAREA("ZZO")
			ZZO->(DbSetOrder(2))
			ZZO->(DbSeek(xFilial('SE1')+SF1->(F1_DOC+F1_SERIE)))
			While !ZZO->(Eof()) .and. xFilial('ZZO')+SF1->(F1_DOC+F1_SERIE) == ;
				ZZO->(ZZO_FILIAL+ZZO_FATURA+ZZO_SERNF)
				//				If Alltrim(SF1->F1_ESPECIE) == Alltrim( SE1->E1_TIPO )
				Aadd( aRecZZO, ZZO->(RecNo()) )
				//				EndIf
				ZZO->(DbSkip())
			EndDo
			
			For nD := 1 To Len(aRecZZO)
				ZZO->(DbGoTo(aRecZZO[nD]))
				RecLock('ZZO',.F.)
				Replace ZZO_SERNF   With _cFisSerie
				Replace ZZO_FATURA With _cFisNum
				MsUnLock()
			Next
			*/
			//������������������������������������������������������������������Ŀ
			//� Actualizo SF1                                                    �
			//������������������������������������������������������� Diegho �����
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
	
EndIf
RestArea( aArea )

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A075IpND  �Autor  �Microsiga           � Data �  01/16/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �LBRA075                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function A075IpND()
Local aArea   := GetArea()
Local lRet    := .F.
Local nD      := 0
Local aRecSE1 := {}
Local aRecSF3 := {}

Private _cFisSerie := ''
Private _cFisNum   := ''

If MsgYesNo(OemToAnsi('Desea Imprimir la ND?'), OemToAnsi('Confirme') )
	
	lRet := U_A075NCND( 'D' )
	
	If lRet
		RecLock('SF2',.F.)
		Replace F2_PRINTED With 'S'
		Replace F2_CAJALOJ With xNumCaixa()
		MsUnLock()
		
		If !Empty(_cFisSerie) .and. !Empty(_cFisNum)
			
			//������������������������������������������������������������������Ŀ
			//� Actualizo SE1                                                    �
			//������������������������������������������������������� Diegho �����
			SE1->(DbSetOrder(2))
			SE1->(DbSeek(xFilial('SE1')+SF2->(F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC)))
			While !SE1->(Eof()) .and. xFilial('SE1')+SF2->(F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC) == ;
				SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
				If Alltrim(SF2->F2_ESPECIE) == Alltrim( SE1->E1_TIPO )
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
//				Replace E1_CXLOJA  With xnumcaixa()  // Grabo el portador para el resumen de caja!!
				MsUnLock()
			Next
			
			//������������������������������������������������������������������Ŀ
			//� Actualizo SD2                                                    �
			//������������������������������������������������������� Diegho �����
			For nD := 1 To Len(aRecnos[2])
				SD2->(DbGoTo(aRecnos[2][nD]))
				RecLock('SD2',.F.)
				Replace D2_SERIE   With _cFisSerie
				Replace D2_DOC     With _cFisNum
				MsUnLock()
			Next
			
			//������������������������������������������������������������������Ŀ
			//� Actualizo SF3                                                    �
			//������������������������������������������������������� Diegho �����
			SF3->(DbSetOrder(4))
			SF3->(DbSeek(xFilial('SF3')+SF2->(F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE)))
			While !SF3->(Eof()) .and. xFilial('SF3')+SF2->(F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE) == ;
				SF3->(F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE)
				If Alltrim(SF2->F2_ESPECIE) == Alltrim( SF3->F3_ESPECIE )
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
			
			//������������������������������������������������������������������Ŀ
			//� Actualizo SF2                                                    �
			//������������������������������������������������������� Diegho �����
			SF2->(DbGoTo(aRecnos[1]))
			RecLock('SF2',.F.)
			Replace F2_SERIE   With _cFisSerie
			Replace F2_DOC     With _cFisNum
			Replace F2_DUPL		With _cFisNum
			MsUnLock()
		EndIf
	EndIf
	
	If Type('oDlg') == 'O'
		oDlg:End()
	EndIf
	
EndIf

RestArea( aArea )

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  �Microsiga           � Data �  01/16/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica las preguntas y las genera si no existen.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �LBRA075                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function ValidPerg(cPerg)
Local _sAlias  := Alias()
Local j:=0
Local i:=1

dbSelectArea( "SX1" )
dbSetOrder( 1 )
cPerg    := PADR( cPerg, 10 )
aRegs    := { }

Aadd(aRegs,{cPerg,'01',"Tipo de Documento","Tipo de Documento","Tipo de Documento","mv_ch1","N",01,0,0,"C","","mv_par01","Nota Credito","Nota Credito","Nota Credito",""          ,"","Nota Debito","Nota Debito","Nota Debito","","",""          ,""          ,""          ,"","","","","","","","","","","",""   ,"","" } )

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock('SX1',.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	EndIf
Next
dbSelectArea(_sAlias)
Return


//�������������������
//�ORIGEM - LBLOJ010�
//�������������������

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A075NCND  �Autor  �Microsiga           � Data �  01/23/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �impressao de NCC/NDC pelo modulo SigaLoja                   ���
���          �Imprime NCC e NDC em Impresora Fiscal                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function A075NCND( cTipo ) //LBLoj010
Local aArea		:= GetArea()
Local nIB2		:= 0
Local nIBP		:= 0
Local nIBA		:= 0
local _CNROVALE	:= ""
Local lEpson	:= ( 'EPSON' $ Alltrim( Upper( LJGetStation('IMPFISC') ) ) )
Private _lRet	:= .T.

If nModulo != 12 .Or. !IIf(Type("lFiscal")#"U",lFiscal,.F.) .Or. cPaisLoc != "ARG"
	Return (.T.)
EndIf

If cTipo == 'C'
	MsAguarde( { || _lRet := LB075C()}, 'Imprimiendo....' )
	If ((SF1->F1_VALBRUT <= 1000) .and. (SE4->E4_CODIGO == '013')).and. _lret
		//If !((SF2->F2_VALBRUT >= 1000) .OR. (SE4->E4_CODIGO != '013'))
		If !lEpson
			ExecHsr( Chr( 153 ) )//Reprint
		EndIf
	EndIf

Else
	MsAguarde( { || _lRet := LB075D()}, 'Imprimiendo....' )
	If ((SF1->F1_VALBRUT <= 1000) .and. (SE4->E4_CODIGO == '013')) .and. _lret
		//If !((SF2->F2_VALBRUT >= 1000) .OR. (SE4->E4_CODIGO != '013'))
		If !lEpson
			ExecHsr( Chr( 153 ) )//Reprint
		EndIf
	EndIf
EndIf




RestArea( aArea )

Return( _lRet )

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LB075C    �Autor  �Microsiga           � Data �  01/23/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Impressao de NCC para impressora fiscal                     ���
���          �Nota de Credito(SigaLoja)                                   ���
�������������������������������������������������������������������������͹��
���Uso       �LBRA075                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function LB075C()

LOCAL _nX
LOCAL nTotalDesc:= 0
LOCAL nVlrIVA   := 0
LOCAL nLinCabec := 3
LOCAL nRet      := 1
LOCAL _nI
LOCAL nAliqIVA  := 0
LOCAL nAliqInt  := 0
LOCAL nPosHas   := 0
LOCAL nIB2      := 0
LOCAL nIBP      := 0
LOCAL nIBA	:= 0
LOCAL nAliqImp  := 0
LOCAL nBaseImp  := 0
LOCAL nValorImp := 0
LOCAL nTotVentaImp  := 0   //MACHIMA
LOCAL nTotNCC   := 0
LOCAL nDifer    := 0
LOCAL cNumNota  := Space(TamSX3("L1_DOC")[1])
LOCAL cVlrIVA   := ""
LOCAL cTipoCli  := ""
LOCAL cDescTotal:= ""
LOCAL cPdv      := ""
LOCAL cDocOri   := ""
LOCAL cCNPJ     := ""
LOCAL cDadosCli := ""
LOCAL cDadosCab := ""
LOCAL cTipoDoc  := ""
LOCAL cCodProd  := ""
LOCAL cDescProd := ""
LOCAL cQuant    := ""
LOCAL cVUnit    := ""
LOCAL cTotIt    := ""
LOCAL cAliquota :=""
LOCAL cIncluiIVA:= "B"  //Se T indica que o preco contem IVA incluido. Se B, o IVA eh discriminado
LOCAL cTexto    := ""
LOCAL cTotItem
LOCAL cTmpHas   := ""
LOCAL cHasar1   := ""
LOCAL cHasar2   := ""
LOCAL cVlrIB    := ""
LOCAL cVendedor := ""
LOCAL cTES      := ""
LOCAL cIndImp   := ""
LOCAL cCpoAlqImp:= ""
LOCAL cCpoBasImp:= ""
LOCAL cCpoVlrImp:= ""
LOCAL cCodImp   := ""
LOCAL aRet      := {}
LOCAL aTamQuant := TamSX3("D1_QUANT")
LOCAL aTamdeScri := TamSX3("D1_DESCRI")
LOCAL aTamUnit  := TamSX3("D1_VUNIT")
LOCAL aTamTotIt := TamSX3("D1_TOTAL")
LOCAL aTesImpInf:= {}
Local lFunImp		:= .F.									// Se a funcao da impressora eh 01 no LojxEcf
Local lVerHora		:= .T.									// Se a hora eh para verificar a hora, dependendo do retorno do LojxEcf
Local lEpson      := ( 'EPSON' $ Alltrim( Upper( LJGetStation('IMPFISC') ) ) )

Local sTipoTick := "|T|" 									//Indica o documento que sera aberto T=Ticket S=Folha Solta

cTmpHas   := GetMV("MV_IMPSIVA",,"IVA,IV1,IV7|")  //Codigo dos impostos que somam no IVA(Argentina)
nPosHas   := AT("|",cTmpHas)                      //Se agrego IV1, IV7 Gustavo
cHasar1   := Substr(cTmpHas,1,nPosHas-1)
cHasar2   := Substr(cTmpHas,nPosHas+1)
nPosHas   := IIf(nPosHas==0,Len(cTmpHas),nPosHas)

//���������������������������������������������������������������������Ŀ
//� Verifica si es la misma fecha del sistema con la impresora fiscal   �
//�����������������������������������������������������������������������
If LjEcfIFData( @lFunImp, @lVerHora )
	If !lFunImp
		If !VerifHora()
			Return(.F.)
		EndIf
	Else
		If !lVerHora
			Return (.F.)
		EndIf
	EndIf
EndIf

cRetorno := Space(40)
/*nRet     := IFStatus(nHdlECF, '9', @cRetorno)//Comando de impressora EPSON
If nRet == 1
	Return(.F.)
EndIf*/

//��������������������������������������������������������������������Ŀ
//� Si hay un cup�n abierto, hace la cancelaci�n para abrir uno nuevo  �
//����������������������������������������������������������������������
If nRet = 7
	nRet := IFCancCup( nHdlECF )//Comando de impressora EPSON
	If L010AskImp(.F.,nRet)
		Return(.F.)
	EndIf
	Inkey(8)   // da un tiempo para que la impresora haga la cancelaci�n
EndIf

nRet := IFPegPDV(nHdlECF, @cPdv)//Comando de impressora EPSON
aRet := LjStr2Array(cPdv)
If nRet == 1
	Return(.F.)
EndIf
cPdv  := aRet[1]

SA1->(DbSetOrder(1))
SA1->(DbSeek( xFilial("SA1") + SF1->F1_FORNECE + SF1->F1_LOJA ))
SA3->(DbSetOrder(1))
SA3->(DbSeek( xFilial("SA3") + SF1->F1_VEND1 ))
SE4->(DbSetOrder(1))
SE4->(DbSeek( xFilial("SE4") + SF1->F1_COND ))

Do Case
	Case SA1->A1_TIPO = "X"
		cTipoCli := "E"
	Case SA1->A1_TIPO = "F" .Or. Empty( SA1->A1_TIPO )
		cTipoCli := "C"
	Case SA1->A1_TIPO = "S"
		cTipoCli := "A"
	Case SA1->A1_TIPO = "Z"
		cTipoCli := "I"
	OtherWise
		cTipoCli := SA1->A1_TIPO
EndCase

If SA1->A1_TIPO == "F"
	cCNPJ    := If( Empty( SA1->A1_RG ), '10000000', Alltrim(SA1->A1_RG ) )
	cTipoID  :=   "2"
Else
	cCNPJ    := Alltrim( SA1->A1_CGC )
	cTipoID      :=   "C"
	If Empty(cCNPJ)
		MsgAlert("El cliente no tiene CUIT, por eso no se puede generar la Nota de Credito. Actualice los datos del cliente!")
		Return( .F. )
	EndIf
	If !Cuit(cCNPJ,"A1_CGC")
		MsgAlert("El CUIT del cliente no es valido, por eso no es posible generar la Nota de Credito. Actualice los datos del cliente!")
		Return( .F. )
	EndIf
Endif

//������������������������������������������������������������������Ŀ
//� Si estamos usando HASAR                                          �
//������������������������������������������������������� Diegho �����
If !lEpson
	
	cEnd := RTrim(SA1->A1_END)
	
	If ((SF1->F1_VALBRUT >= 1000) .OR. (SE4->E4_CODIGO != '013'))
		//Quantidade maxima de copias 0
		ExecHsr( Chr( 100 ) + '|9|0|' )
		sTipoTick := "|S|" //Folha Solta
	Else
		//Quantidade maxima de copias 4
		ExecHsr( Chr( 100 ) + '|9|4|' )
		sTipoTick := "|T|" //Ticket
	EndIf
	
	
	aRet  := ExecHsr( "b|" + SubStr( OemToAnsi( AllTrim( SA1->A1_COD ) + " - " + AllTrim( SA1->A1_NOME ) ), 1, 45) + ;
	"|" + StrTran( AllTrim(cCNPJ), "-", "" ) + ;
	"|" + cTipoCli + ;
	"|" + cTipoID + ;
	"|" + OemToAnsi( SA1->A1_END ) )
	
	If !U_HsrStat( aRet[1], aRet[2], 'Datos del Cliente' )                                //"Dados do Cliente"
		aRet   := ExecHsr( Chr( 152 ) )                                      // Cancel
		Return( .F. )
	EndIf
	
	If SA3->(Found())
		// SetHeaderTrailer
		aRet := ExecHsr( Chr(93) + "|4|VENDEDOR: " + Alltrim(SF1->F1_VEND1) + " " + Capital( SA3->(A3_NOME) ) )
	Else
		// SetHeaderTrailer
		aRet := ExecHsr( Chr(93) + "|4|" + Chr(127) )
	EndIf            
	
	If SE4->(Found())
		// SetHeaderTrailer
		aRet := ExecHsr( Chr(93) + "|5|COND. DE PAGO: " + Capital( SE4->(E4_DESCRI) ) )
	Else
		// SetHeaderTrailer
		aRet := ExecHsr( Chr(93) + "|5|" + Chr(127)  )
	EndIf
	
	
	For _nX := 1 To Len( aCols )
		If !aCols[_nX][Len(aCols[_nX])] .And. !Empty( aCols[_nX][31] )
			cDocOri := aCols[_nX][31]
			Exit
		End
	Next _nX
	
	If cTipoCli $ "IN"
		cTipoDoc  := "R"  //NDC serie A
	Else
		cTipoDoc  := "S"  //NDC serie B
	EndIf
	
	// SetEmbarkNumber
	aRet := ExecHsr( Chr( 147 ) + '|1|' + If( Empty( cDocOri ), 'NO INFORMADO', cDocOri ) )
	
	// OpenDNFH}
	aRet := ExecHsr( Chr( 128 ) + '|' + cTipoDoc + sTipoTick )
	If len(aRet) > 1
		If !U_HsrStat( aRet[1], aRet[2], 'Apertura del Documento' )
			aRet   := ExecHsr( Chr( 152 ) )
			Return( .F. )
		EndIf
	else
		MsgStop("Hubo Un Problema con el controlador Fiscal, El comprobante ha sido Cancelado","Atencion")
		Return(.F.)
	Endif
	
	_cFisSerie  := IIf(SA1->A1_TIPO $ "INZ", "A  ", "B  ")
	_cFisNum    := cPdv + aRet[3]
	cNumNota    := aRet[3]
	cSerie      := IIf(SA1->A1_TIPO $ "INZ", "A  ", "B  ")
	cNFiscal    := cPdv + cNumNota
	cNota       := cNFiscal
	M->F1_DOC   := cNFiscal
	
	//������������������������������������������������������������������Ŀ
	//� Si estamos usando EPSON                                          �
	//������������������������������������������������������� Diegho �����
Else
	If cTipoCli $ "IN"
		cTipoDoc  := "A"  //NDC serie A
	Else
		cTipoDoc  := "B"  //NDC serie B
	EndIf
	cTipoCli := If(cTipoCli == 'I', 'I', cTipoCli )
	cTipoCli := If(cTipoCli == 'N', 'R', cTipoCli )
	cTipoCli := If(cTipoCli == 'E', 'E', cTipoCli )
	cTipoCli := If(cTipoCli == 'M', 'M', cTipoCli )
	cTipoCli := If(cTipoCli == 'C', 'F', cTipoCli )
	cTipoCli := If(cTipoCli == 'A', 'S', cTipoCli )
	cNomeCli := OemToAnsi( Alltrim( SA1->A1_COD ) + " - " + AllTrim( SA1->A1_NOME ) )
	cTipoID  := If( cTipoID == '2', 'DNI', 'CUIT' )
	If SA3->(Found())
		cLinVend  := 'Vendedor: ' + AllTrim(SF1->F1_VEND1) + " " + Capital( SA3->(A3_NOME) )
	Else
		cLinVend  := " "
	End
	
	If SE4->(Found())
		cLinCond   := "Cond. de Pago: " + Capital( SE4->(E4_DESCRI) )
	Else
		cLinCond   := " "
	EndIf
	
	For _nX := 1 To Len( aCols )
		If !aCols[_nX][Len(aCols[_nX])] .And. !Empty( aCols[_nX][31] )
			cDocOri := aCols[_nX][31]
			Exit
		End
	Next _nX
	
	cCmd  := Chr(96) + '|'																				// Abrir TF / TNC
	cCmd  += 'M' + '|'																					// 01 T para Ticket Factura
	cCmd  += 'C' + '|'																					// 02 IGNORADO
	cCmd  += cTipoDoc + '|'																				// 03 A o B
	cCmd  += '1' + '|'																					// 04 IGNORADO
	cCmd  += 'F' + '|'																					// 05 IGNORADO
	cCmd  += '12' + '|'																					// 06 IGNORADO
	cCmd  += 'I' + '|'																					// 07 IVA del EMISOR
	cCmd  += cTipoCli + '|'																				// 08 IVA del COMPRADOR
	cCmd  += cNomeCli + '|'																				// 09 Nombre 1ra Linea
	cCmd  += '' + '|'																					// 10 Nombre 2da Linea
	cCmd  += cTipoID + '|'																				// 11 Tipo de Documento
	cCmd  += cCNPJ + '|'																				// 12 Nro de Documento
	cCmd  += 'N' + '|'																					// 13 Leyenda Bien de Uso
	cCmd  += 'Domicilio Desconocido' + '|'																// 14 Domicilio 1ra Linea
	cCmd  += cLinVend + '|'																				// 15 Domicilio 2da Linea
	cCmd  += cLinCond + '|'																				// 16 Domicilio 3ra Linea
	cCmd  += IIf( Empty( cDocOri ), 'Sin Remitos Asociados' + '|', cDocOri + '|' )	// 17 Remitos 1ra Linea
	cCmd  += '' + '|'																					// 18 Remitos 2da Linea
	cCmd  += 'C'																						// 19 Para Farmacias
	
	aRet := ExecHsr( cCmd )
	
	cRetorno   := Space(12)
	nRet       := IFPegCupom( nHdlECF, @cRetorno, "D|"+AllTrim(cTipoDoc))//Comando de impressora EPSON
	If nRet == 1
		Return( .F. )
	EndIf
	
	_cFisSerie  := IIf(SA1->A1_TIPO $ "INZ", "A  ", "B  ")
	cNumCup     := StrZero( Val( cRetorno ), 12, 0 )
	_cFisNum    := cPdv + Substr( cNumCup,1+Len(cPdv),Len(cNumCup)-Len(cPdv) )
	cNumNota    := Substr( cNumCup,1+Len(cPdv),Len(cNumCup)-Len(cPdv) )
	cSerie      := IIf(SA1->A1_TIPO $ "INZ", "A  ", "B  ")
	cNFiscal    := cPdv + cNumNota
	cNota       := cNFiscal
	M->F1_DOC   := cNFiscal
	
EndIf


For _nX := 1 To Len( aCols )
	If aCols[_nx][Len(aCols[_nx])]
		Loop
	Endif
	
	SD1->(DbGoTo(aRecnos[2][_nX]))
	
	nAliqIVA 	:= 0
	nAliqInt    := 0
	cVUnit		:=	""
	
	SB1->( DbSetOrder(1) )
	SB1->( DbSeek( xFilial("SB1") +  SD1->D1_COD ) )
	
	nTotalDesc  += SD1->D1_VALDESC
	cCodProd    := SB1->B1_COD
	cDescProd   := cCodProd + " " + Alltrim(SB1->B1_DESC) //Posicione("SB1",1,xFilial("SB1")+SB1->B1_COD,"B1_DESC")
	cQuant      := Alltrim( StrTran( Str( SD1->D1_QUANT,  aTamQuant[1], aTamQuant[2] ), ",", ".") )
	cVUnit      := Alltrim( StrTran( Str( SD1->D1_VUNIT,  aTamUnit[1],  aTamUnit[2]  ), ",", ".") )
	cTotIt      := Alltrim( StrTran( Str( SD1->D1_TOTAL,  aTamTotIt[1], aTamTotIt[2] ), ",", ".") )
	cValDescIt  := Alltrim( StrTran( Str( SD1->D1_VALDESC,  aTamTotIt[1], aTamTotIt[2] ), ",", ".") )
	
	cTES        := SD1->D1_TES
	aTesImpInf  := TesInfo(cTES)
	
	For _nI := 1 to Len(aTesImpInf)
		cIndImp     := Substr(aTesImpInf[_nI][2],10,1)
		cCodImp     := AllTrim(aTesImpInf[_nI][1])
		nAliqImp    := SD1->(FieldGet(FieldPos('D1_ALQIMP'+cIndImp)))
		nBaseImp    := SD1->(FieldGet(FieldPos('D1_BASIMP'+cIndImp)))
		nValorImp   := SD1->(FieldGet(FieldPos('D1_VALIMP'+cIndImp))) 
		//Agregado de impuesto interno
		If cIndImp='7'  // si es impuesto interno
	     		nAliqImp	:= (((nBaseImp+nValorImp)/nBaseImp)-1 )*100
	   	EndIf
		If nBaseImp > 0
			If cCodImp $ cHasar1       //Impostos que somam no IVA
				nAliqIVA := nAliqIVA + nAliqImp
			ElseIf cCodImp $ cHasar2   //Impostos internos
				nAliqInt := nAliqInt + nAliqImp
			Endif
			//�������������������������������������Ŀ
			//� Percepcoes                          �
			//���������������������������������������
			If cCodImp == "IB2" .And. nValorImp > 0
				nIB2	+=	nValorImp
			ElseIf cCodImp == "IBP" .And. nValorImp > 0
				nIBP   += nValorImp
			ElseIf cCodImp == "IVP" .And. nValorImp > 0
				nVlrIVA += nValorImp
			ElseIf cCodImp == "IBA" .And. nValorImp > 0
				nIBA    += nValorImp
 			EndIf
		Endif
	Next _nI
	
	//������������������������������������������������������������������Ŀ
	//� Si es HASAR                                                      �
	//������������������������������������������������������� Diegho �����
	If !lEpson
		cAliquota  := AllTrim(Str(nAliqIVA,5,2))+"|"+AllTrim(Str(nAliqInt,4,2))+"|"+cIncluiIVA
		
		aRet      := ExecHsr( "B" +;
		"|" + OemToAnsi( cDescProd ) +;         // Descripcion
		"|" + AllTrim(cQuant) +;                // Cantidad
		"|" + AllTrim(cVUnit) +;                 // Precio Unitario
		"|" + Alltrim(Str(nAliqIVA,5,2)) +;     // Alicuota de IVA
		"|M" +;
		"|%" + Alltrim(Str(nAliqInt,5,2)) +;       // Impuestos Internos
		"|0" +;                                 // Parametro Display
		"|s" )
		If Len(Aret) > 1
			If !U_HsrStat( aRet[1], aRet[2] )
				// Cancel
				aRet   := ExecHsr( Chr( 152 ) )
				Return( .F. )
			EndIf
		else
			MsgStop("Hubo Un Problema con el controlador Fiscal, El comprobante ha sido Cancelado","Atencion")
			Return(.F.)
		endif
		//������������������������������������������������������������������Ŀ
		//� Si es EPSON                                                      �
		//������������������������������������������������������� Diegho �����
	Else
		//Comando de impressora EPSON
		nRet  := IFRegItem( nHdlECF, cCodProd, cDescProd, AllTrim(cQuant), ;
		AllTrim(cVUnit), cValDescIt, AllTrim(Str(nAliqIVA,5,2)), ;
		AllTrim(Str(nAliqInt,4,2)) + "|" + cIncluiIVA )
		
		If nRet  == 1
			nRet := IFCancCup( nHdlECF ) //Comando de impressora EPSON
			If L010AskImp(.F.,nRet)
				Return( .F. )
			EndIf
			Inkey(8)
			Return( .F. )
		EndIf
	EndIf
	
Next _nX


If !lEpson
	aRet := ExecHsr( Chr(93) + "|11|" + Chr(127) )
	aRet := ExecHsr( Chr(93) + "|12|" + Chr(127) )
	aRet := ExecHsr( Chr(93) + "|13|" + Chr(127) )
	aRet := ExecHsr( Chr(93) + "|14|" + Chr(127) )
EndIf

If nTotalDesc > 0
	If !lEpson
		// GeneralDiscount
		aRet  := ExecHsr( 'T|Descuento Otorgado|' + Strzero(nTotalDesc,12,2) + '|m|0|B' )
		If Len(Aret) >1
			If !U_HsrStat( aRet[1], aRet[2] )
				// Cancel
				aRet   := ExecHsr( Chr( 152 ) )
				Return( .F. )
			EndIf
		Else
			MsgStop("Hubo Un Problema con el controlador Fiscal, El comprobante ha sido Cancelado","Atencion")
			return (.F.)
		Endif
	Else
		//IfDescTot( nHdlECF, " |"+Strzero(nTotalDesc),12,2)+"|0|" ) //Comando de impressora EPSON
		EndIf
	Endif
	
	If nVlrIVA > 0
		If !lEpson
			aRet  := ExecHsr( Chr(96)+"|**.**|Perc. I.V.A.|"+Alltrim(Str(nVlrIVA,14,2)) )
			If Len (Aret) >1
				If !U_HsrStat( aRet[1], aRet[2] )
					// Cancel
					aRet   := ExecHsr( Chr( 152 ) )
					Return( .F. )
				EndIf
			Else
				MsgStop("Hubo Un Problema con el controlador Fiscal, El comprobante ha sido Cancelado","Atencion")
				Return(.F.)
			EndIf
		Else
			cAliqIVA  := "**.**"
			cTexto    := "Perc. I.V.A."
			cValor    := AllTrim(Str(nVlrIVA,14,2))
			aRet      := {}
			nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cValor, @aRet)//Comando de impressora EPSON
			If nRet == 1
				Return(.F.)
			EndIf
		EndIf
	Endif
	
	If nIB2 > 0
		If !lEpson
			aRet  := ExecHsr( Chr(96)+"|**.**|Perc. 2,0% Bs.As.|"+Alltrim(Str(nIB2,14,2)) )
			If Len(aRet) >1
				If !U_HsrStat( aRet[1], aRet[2] )
					// Cancel
					aRet   := ExecHsr( Chr( 152 ) )
					Return( .F. )
				EndIf
			Else
				MsgStop("Hubo Un Problema con el controlador Fiscal, El comprobante ha sido Cancelado","Atencion")
				Return(.f.)
			EndIf
		Else
			cAliqIVA  := "**.**"
			cTexto    := "Perc. 2,0% Bs.As."
			cValor    := AllTrim(Str(nIB2,14,2))
			aRet      := {}
			nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cValor, @aRet)//Comando de impressora EPSON
			If nRet == 1
				Return(.F.)
			EndIf
		EndIf
	Endif

	If nIBA > 0
		If !lEpson
			aRet  := ExecHsr( Chr(96)+"|**.**|Perc. 2,0% E.Rios|"+Alltrim(Str(nIBA,14,2)) )
			If Len(aRet) >1
				If !U_HsrStat( aRet[1], aRet[2] )
					// Cancel
					aRet   := ExecHsr( Chr( 152 ) )
					Return( .F. )
				EndIf
			Else
				MsgStop("Hubo Un Problema con el controlador Fiscal, El comprobante ha sido Cancelado","Atencion")
				Return(.f.)
			EndIf
		Else
			cAliqIVA  := "**.**"
			cTexto    := "Perc. 2,0% E.Rios"
			cValor    := AllTrim(Str(nIBA,14,2))
			aRet      := {}
			nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cValor, @aRet)//Comando de impressora EPSON
			If nRet == 1
				Return(.F.)
			EndIf
		EndIf
	Endif
	
	If nIBP > 0
		If !lEpson
			aRet := ExecHsr( Chr(96)+"|**.**|Perc. 1,5% Cap.Fed|"+Alltrim(Str(nIBP,14,2)) )
			If Len(aret) > 1
				If !U_HsrStat( aRet[1], aRet[2] )
					// Cancel
					aRet   := ExecHsr( Chr( 152 ) )
					Return( .F. )
				EndIf
			else
				MsgStop("Hubo Un Problema con el controlador Fiscal, El comprobante ha sido Cancelado","Atencion")
				Return (.F.)
			endif
		Else
			cAliqIVA  := "**.**"
			cTexto    := "Perc. 1,5% Cap.Fed"
			cValor    := AllTrim(Str(nIBP,14,2))
			aRet      := {}
			nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cValor, @aRet)//Comando de impressora EPSON
			If nRet == 1
				Return(.F.)
			EndIf
		EndIf
	Endif
	
	If !lEpson
		//MACHIMA
		//Chamar ExecHsr do comando SubTotal, nao imprimir texto e valor (parametro |Z)
		aRet  := ExecHsr( Chr( 67 ) + "|Z" + "|Z" )
		If Len(aRet) > 1
			nTotVentaImp  := val(aRet[4])     //Total calculado pela impressora - Pablo agregue el val() porque viene en caracter
			nTotNCC  := SF1->F1_VALBRUT //Total gravado na NCC (sistema)
			nDifer   :=  nTotVentaImp - nTotNCC     //Diferenca
			//Apenas ajusta se a diferenca for de 0,01 para mais ou para menos
			If nDifer <> 0 .AND. Abs(nDifer) == 0.01
				//Valor da impressora e maior que da NCC gravada (SF1) -> dar desconto (parametro m)
				//O texto "Ajuste por redondeo" ajuda a identificar quando o PE envia o comando de ajuste
				//Se aparecer o texto "AJUSTE POR REDONDEO" (maiusculo), o ajuste foi enviado automaticamente pela impressora
				If nDifer > 0
					aRet  := ExecHsr( 'T|Ajuste por redondeo|' + Strzero(nDifer,12,2) + '|m|0|T' )
					
					//Valor da impressora e menor que da NCC gravada (SF1) -> dar acrescimo (parametro M)
				Else
					aRet  := ExecHsr( 'T|Ajuste por redondeo|' + Strzero((nDifer * -1),12,2) + '|M|0|T' ) // pablo agregue el *-1 para que se haga el ajuste
				EndIf                                                                                    //positivo
			EndIf
		else
			MsgStop("Hubo Un Problema con el controlador Fiscal, El comprobante ha sido Cancelado","Atencion")
			Return (.F.)
		Endif
		
		
		
		
		
		// CloseDNFH
		aRet  := ExecHsr( Chr( 129 ) + "|1" )
		If Len(aret) > 1
			If !U_HsrStat( aRet[1], aRet[2] )
				// Cancel
				aRet   := ExecHsr( Chr( 152 ) )
				Return( .F. )
			EndIf
		Else
			If MsgYesNo("Hubo Un Problema con el controlador Fiscal, �Se Imprimio Correctamente la Nota de Credito?","Atencion")
				Return  (.T.)
			Else
				Return (.F.)
			endIf
		Endif
	Else
		// nRet     := IFFechaCup( nHdlECF,'' )//Comando de impressora EPSON
		cCmd := Chr(101) + '|'
		cCmd += 'M|'
		cCmd += SubStr( cTipoDoc, 1, 1 ) + '|'
		
		aRet := ExecHsr( cCmd )
		
		If nRet == 1
			Return( .F. )
		EndIf
	EndIf
	
	
	Return  .T.
	
	/*���������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������ͻ��
	���Programa  �LB075D    �Autor  �Microsiga           � Data �  01/23/09   ���
	�������������������������������������������������������������������������͹��
	���Desc.     �Impressao de NDC para impressora fiscal                     ���
	���          �Nota de Debito ao Cliente(SigaLoja)                         ���
	�������������������������������������������������������������������������͹��
	���Uso       �LBRA075                                                     ���
	�������������������������������������������������������������������������ͼ��
	�����������������������������������������������������������������������������
	���������������������������������������������������������������������������*/
	Static Function LB075D()
	LOCAL _nX
	LOCAL _nI
	LOCAL nVlrIVA   := 0
	LOCAL nLinCabec := 3
	LOCAL nRet      := 1
	LOCAL nAliqIVA  := 0
	LOCAL nAliqInt  := 0
	LOCAL nIB2      := 0
	LOCAL nIBP      := 0
	LOCAL nAliqImp  := 0
	LOCAL nBaseImp  := 0
	LOCAL nValorImp := 0
	LOCAL nDecimais := MsDecimais(1)
	LOCAL nPosHas   := 0
	LOCAL nTamDoc   := TamSX3("L1_DOC")[1]
	LOCAL cQuant    := ""
	LOCAL cVUnit    := ""
	LOCAL cTotIt    := ""
	LOCAL cAliquota :=""
	LOCAL nTotVentaImp  := 0   //MACHIMA
	LOCAL cIncluiIVA:= "s"  //Se T indica que o preco contem IVA incluido. Caso contrario,
	//o IVA eh discriminado
	LOCAL cNumNota  := Space(TamSX3("L1_DOC")[1])
	LOCAL cTexto    := ""
	LOCAL cInfo     := ""
	LOCAL cTotItem
	LOCAL cTipoCli  := ""
	LOCAL cPdv      := Space(TamSX3("L1_PDV")[1])
	LOCAL cCNPJ     := ""
	LOCAL cDadosCab := ""
	LOCAL cSerieCup := ""
	//Argentina
	LOCAL cTmpHas   := ""
	LOCAL cHasar1   := ""
	LOCAL cHasar2   := ""
	LOCAL cVlrIB    := ""
	LOCAL cVendedor := ""
	LOCAL cTES      := ""
	LOCAL cIndImp   := ""
	LOCAL cCpoAlqImp:= ""
	LOCAL cCpoBasImp:= ""
	LOCAL cCpoVlrImp:= ""
	LOCAL cCodImp   := ""
	LOCAL cVlrIVA   := ""
	LOCAL cCodProd  := ""
	LOCAL cDescProd := ""
	Local cRetorno  := ""
	Local cDocOri	:= ""
	local nTotNDC	:= 0
	LOCAL aTamQuant := TamSX3("D1_QUANT")
	LOCAL aTamUnit  := TamSX3("D1_VUNIT")
	LOCAL aTamTotIt := TamSX3("D1_TOTAL")
	LOCAL aRet      := {}
	Local cEnd      := ""
	LOCAL aTesImpInf:= {}
	Local lEpson      := ( 'EPSON' $ Alltrim( Upper( LJGetStation('IMPFISC') ) ) )
	Local sTipoTick := "|T|" 									//Indica o documento que sera aberto T=Ticket S=Folha Solta
	
	If lEpson
		MsgStop( 'Documento No Soportado Por Impresora Actual' )
		Return( .F. )
	EndIf
	
	cTmpHas   := GetMV("MV_IMPSIVA",,"IVA|")  //Codigo dos impostos que somam no IVA(Argentina)
	nPosHas   := AT("|",cTmpHas)
	cHasar1   := Substr(cTmpHas,1,nPosHas-1)
	cHasar2   := Substr(cTmpHas,nPosHas+1)
	nPosHas   := IIf(nPosHas==0,Len(cTmpHas),nPosHas)
	
	// Cancel
	//aRet  := ExecHsr( Chr( 152 ) )
	nRet := IFPegPDV(nHdlECF, @cPdv)//Comando de impressora EPSON
	aRet := LjStr2Array(cPdv)
	If nRet == 1
		Return(.F.)
	EndIf
	cPdv  := aRet[1]
	SA1->(DbSetOrder(1))
	SA1->(DbSeek( xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA ))
	SA3->(DbSetOrder(1))
	SA3->(DbSeek( xFilial("SA3") + SF2->F2_VEND1 ))
	SE4->(DbSetOrder(1))
	SE4->(DbSeek( xFilial("SE4") + SF2->F2_COND ))
	
	Do Case
		Case SA1->A1_TIPO = "X"
			cTipoCli := "E"
		Case SA1->A1_TIPO = "F" .Or. Empty( SA1->A1_TIPO )
			cTipoCli := "C"
		Case SA1->A1_TIPO = "S"
			cTipoCli := "A"
		Case SA1->A1_TIPO = "Z"
			cTipoCli := "I"
		OtherWise
			cTipoCli := SA1->A1_TIPO
	EndCase
	
	If SA1->A1_TIPO == "F"
		cCNPJ		:=	SA1->A1_RG
		cTipoID	    :=	"2"
	Else
		cCNPJ		:=	Alltrim( SA1->A1_CGC )
		cTipoID	    :=	"C"
		If Empty(cCNPJ)
			MsgAlert("El cliente no tiene CUIT, por eso no se puede generar la Nota de Debito. �Actualice los datos del cliente!") //"O cliente nao possui CUIT, por isso nao e possivel gerar a Nota de Credito. Atualize os dados do cliente!"
			Return( .F. )
		EndIf
		If !Cuit(cCNPJ,"A1_CGC")
			MsgAlert("El CUIT del cliente no es valido, por eso no es posible generar la Nota de Debito. Actualice los datos del cliente!") //"O CUIT do cliente nao e valido, por isso nao e possivel gerar a Nota de Credito. Atualize os dados do cliente!"
			Return( .F. )
		EndIf
	Endif
	
	aRet  := ExecHsr( "b|" + SubStr( OemToAnsi( AllTrim( SA1->A1_COD ) + " - " + AllTrim( SA1->A1_NOME ) ), 1, 45) + ;
	"|" + StrTran( AllTrim(cCNPJ), "-", "" ) + ;
	"|" + cTipoCli + ;
	"|" + cTipoID + ;
	"|" + OemToAnsi( SA1->A1_END ) )
	
	If !U_HsrStat( aRet[1], aRet[2], 'Datos del Cliente' )                                //"Dados do Cliente"
		aRet   := ExecHsr( Chr( 152 ) )                                      // Cancel
		Return( .F. )
	EndIf
	
	If SA3->(Found())
		// SetHeaderTrailer
		aRet := ExecHsr( Chr(93) + "|4|VENDEDOR: " + Alltrim(cVendedor) + " " + Capital( SA3->(A3_NOME) ) )
	Else
		// SetHeaderTrailer
		aRet := ExecHsr( Chr(93) + "|4|" + Chr(127) )
	EndIf
	
	SE4->(DbSetOrder(1))
	SE4->(DbSeek( xFilial("SE4") + SF2->F2_COND ))//cCondicao ))
	
	If SE4->(Found())
		// SetHeaderTrailer
		aRet := ExecHsr( Chr(93) + "|5|COND. DE PAGO: " + Capital( SE4->(E4_DESCRI) ) )
	Else
		// SetHeaderTrailer
		aRet := ExecHsr( Chr(93) + "|5|" + Chr(127)  )
	EndIf
	
	cSerieCup := Iif( SA1->A1_TIPO $ "NI", "D", "E" )
	
	//�������������������������������������Ŀ
	//� Abre documento fiscal               �
	//���������������������������������������
	
	// OpenFiscalReceipt
	If ((SF2->F2_VALBRUT >= 1000) .OR. (SE4->E4_CODIGO != '013'))
		ExecHsr( Chr( 100 ) + '|9|0|' )
		sTipoTick := "|S|" //Folha Solta
	Else
		ExecHsr( Chr( 100 ) + '|9|4|' )
		sTipoTick := "|T|" //Ticket
	EndIf
	If  len(aRet) > 1
		If !U_HsrStat( aRet[1], aRet[2] )
			// Cancel
			aRet   := ExecHsr( Chr( 152 ) )
			Return( .F. )
		EndIf
	else
		MsgStop("Hubo un problema con el controlador Fiscal el comprobante ha sido Cancelado","Atencion")
		Return(.F.)
	EndIf
	
	/*
	If ValType( aRet ) != 'A' .Or. Len( aRet ) < 3 .Or. ValType( aRet[3] ) != 'C'
	aRet   := ExecHsr( Chr( 152 ) )   // Cancel
	Return( .F. )
	EndIf
	*/
	If cTipoCli $ "IN"
		cTipoDoc  := "D"  //NDC serie A
	Else
		cTipoDoc  := "E"  //NDC serie B
	EndIf
	
	// SetEmbarkNumber
	aRet := ExecHsr( Chr( 147 ) + '|1|' + If( Empty( cDocOri ), 'NO INFORMADO', cDocOri ) )
	
	// OpenDNFH}
	aRet := ExecHsr( Chr( 64 ) + '|' + cTipoDoc + sTipoTick )
	If Len(Aret) > 1
		If !U_HsrStat( aRet[1], aRet[2], 'Apertura del Documento' )
			aRet   := ExecHsr( Chr( 152 ) )
			Return( .F. )
		EndIf
	else
		MsgStop("Hubo un problema con el controlador Fiscal, El comprobante ha sido cancelado","Atencion")
		Return(.F.)
	EndIf
	
	_cFisSerie  := IIf(SA1->A1_TIPO $ "INZ", "A  ", "B  ")
	_cFisNum    := 	_cFisNum    := cPdv + aRet[3]
	cNumNota    := aRet[3]
	cSerie      := IIf( SA1->A1_TIPO $ "INZ", "A  ", "B  " )
	cNFiscal    := cPdv + cNumNota
	cNota       := cNFiscal
	M->F2_DOC   := cNFiscal
	
	aRet := ExecHsr( Chr(93) + "|11|" + Chr(127) )
	aRet := ExecHsr( Chr(93) + "|12|" + Chr(127) )
	aRet := ExecHsr( Chr(93) + "|13|" + Chr(127) )
	aRet := ExecHsr( Chr(93) + "|14|" + Chr(127) )
	
	
	For _nX := 1 To Len( aCols )
		
		If aCols[_nx][Len(aCols[_nx])]
			Loop
		Endif
		
		SD2->(DbGoTo(aRecnos[2][_nX]))
		
		nAliqIVA 	:= 0
		nAliqInt    := 0
		cVUnit		:=	""
		
		SB1->( DbSetOrder(1) )
		SB1->( DbSeek( xFilial("SB1") + SD2->D2_COD ) )
		
		cCodProd     := SB1->B1_COD
		cDescProd    := Alltrim( SB1->B1_DESC)
		cQuant       := Alltrim( StrTran( Str( SD2->D2_QUANT , aTamQuant[1], aTamQuant[2] ), ",", ".") )
		cVUnit       := Alltrim( StrTran( Str( SD2->D2_PRCVEN, aTamUnit[1] , aTamUnit[2] ), ",", ".") )
		cTotIt       := Alltrim( StrTran( Str( SD2->D2_TOTAL , aTamTotIt[1], aTamTotIt[2] ), ",", ".") )
		
		cTES         := SD2->D2_TES
		aTesImpInf   := TesInfo(cTES)
		
		For _nI := 1 to Len(aTesImpInf)
			cIndImp     := Substr(aTesImpInf[_nI][2],10,1)
			cCodImp     := AllTrim(aTesImpInf[_nI][1])
			nAliqImp    := SD2->(FieldGet(FieldPos('D2_ALQIMP'+cIndImp)))
			nBaseImp    := SD2->(FieldGet(FieldPos('D2_BASIMP'+cIndImp)))
			nValorImp   := SD2->(FieldGet(FieldPos('D2_VALIMP'+cIndImp)))
			If nBaseImp > 0
				If cCodImp $ cHasar1       //Impostos que somam no IVA
					nAliqIVA := nAliqIVA + nAliqImp
				ElseIf cCodImp $ cHasar2   //Impostos internos
					nAliqInt := nAliqInt + nAliqImp
				Endif
				//�������������������������������������Ŀ
				//� Percepcoes                          �
				//���������������������������������������
				If cCodImp == "IB2" .And. nValorImp > 0
					nIB2	+=	nValorImp
				ElseIf cCodImp == "IBP" .And. nValorImp > 0
					nIBP	+=	nValorImp
				ElseIf cCodImp == "IVP" .And. nValorImp > 0
					nVlrIVA += nValorImp
				EndIf
			Endif
		Next _nI
		
		cAliquota  := Str(nAliqIVA,5,2)+"|"+Str(nAliqInt,4,2)+"|"+cIncluiIVA
		
		aRet      := ExecHsr( "B" +;
		"|" + OemToAnsi( cDescProd ) +;           // Descripcion
		"|" + AllTrim(cQuant) +;                  // Cantidad
		"|" + AllTrim(cVUnit) +;                  // Precio Unitario
		"|" + Alltrim(Str(nAliqIVA,5,2)) +;       // Alicuota de IVA
		"|M" +;
		"|%" + Alltrim(Str(nAliqInt,5,2)) +;      // Impuestos Internos
		"|0" +;                                   // Parametro Display
		"|s" )
		If Len(aRet) > 1
			If !U_HsrStat( aRet[1], aRet[2] )
				// Cancel
				aRet   := ExecHsr( Chr( 152 ) )
				Return( .F. )
			EndIf
		else
			MsgStop("Ha Ocurrido un problema con el controlador Fiscal el comprobante ha sido Cancelado","Atencion" )
			Return (.F.)
		Endif
	Next _nX
	
	If nVlrIVA > 0
		aRet  := ExecHsr( Chr(96)+"|**.**|Perc. I.V.A.|"+Alltrim(Str(nVlrIVA,14,2)) )
		If len(aret) > 1
			If !U_HsrStat( aRet[1], aRet[2] )
				// Cancel
				aRet   := ExecHsr( Chr( 152 ) )
				Return( .F. )
			EndIf
		Else
			MsgStop("Ha Ocurrido un problema con el controlador Fiscal, el comprobante ha sido Cancelado")
		Endif
	Endif
	
	If nIB2 > 0
		aRet  := ExecHsr( Chr(96)+"|**.**|Perc. 2,0% Bs.As.|"+Alltrim(Str(nIB2,14,2)) )
		If Len(Acols) > 1
			If !U_HsrStat( aRet[1], aRet[2] )
				// Cancel
				aRet   := ExecHsr( Chr( 152 ) )
				Return( .F. )
			EndIf
		Else
			MsgStop("Ha Ocurrido un problema con el controlador Fiscal, el comprobante ha sido Cancelado")
			Return(.F.)
		EndIf
	Endif
	
	If nIBP > 0
		aRet := ExecHsr( Chr(96)+"|**.**|Perc. 1,5% Cap.Fed|"+Alltrim(Str(nIBP,14,2)) )
		If Len(aRet) > 1
			If !U_HsrStat( aRet[1], aRet[2] )
				// Cancel
				aRet   := ExecHsr( Chr( 152 ) )
				Return( .F. )
			EndIf
		eLSE
			MsgStop("Ha Ocurrido un problema con el controlador Fiscal, el comprobante ha sido Cancelado")
			Return(.F.)
		Endif
	Endif
	
	If !lEpson
		//MACHIMA
		//Chamar ExecHsr do comando SubTotal, nao imprimir texto e valor (parametro |Z)
		aRet  := ExecHsr( Chr( 67 ) + "|Z" + "|Z" )
		If len (aret) > 1
			nTotVentaImp  := val(aRet[4])     //Total calculado pela impressora - Pablo agregue el val() porque viene en caracter
			nTotNDC  := SF2->F2_VALBRUT //Total gravado na NCC (sistema)
			nDifer   :=  nTotVentaImp - nTotNDC     //Diferenca
			//Apenas ajusta se a diferenca for de 0,01 para mais ou para menos
			If nDifer <> 0 .AND. Abs(nDifer) == 0.01
				//Valor da impressora e maior que da NCC gravada (SF1) -> dar desconto (parametro m)
				//O texto "Ajuste por redondeo" ajuda a identificar quando o PE envia o comando de ajuste
				//Se aparecer o texto "AJUSTE POR REDONDEO" (maiusculo), o ajuste foi enviado automaticamente pela impressora
				If nDifer > 0
					aRet  := ExecHsr( 'T|Ajuste por redondeo|' + Strzero(nDifer,12,2) + '|m|0|T' )
					
					//Valor da impressora e menor que da NCC gravada (SF1) -> dar acrescimo (parametro M)
				Else
					aRet  := ExecHsr( 'T|Ajuste por redondeo|' + Strzero((nDifer * -1),12,2) + '|M|0|T' ) // pablo agregue el *-1 para que se haga el ajuste
				EndIf                                                                                    //positivo
			EndIf
		Else
			MsgStop("Hubo Un Problema con el controlador Fiscal, El comprobante ha sido Cancelado","Atencion")
			Return (.F.)
		endif
	endif
	
	
	// CloseFiscalReceipt
	aRet  := ExecHsr( Chr(69) + '|0' )
	If Len( Aret) > 1
		If !U_HsrStat( aRet[1], aRet[2] )
			// Cancel
			aRet   := ExecHsr( Chr( 152 ) )
			Return( .F. )
		EndIf
	else
		If MsgYesNo("Ha ocurrido un problema con el controlador Fiscal, � Se Imprimio correctamente la Nota de Debito?","Confirme")
			Return (.t.)
		Else
			Return (.F.)
		EndIf
	Endif
	
	Return .T.
	
	/*���������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������ͻ��
	���Programa  �TesInfo   �Autor  �Microsiga           � Data �  01/23/09   ���
	�������������������������������������������������������������������������͹��
	���Desc.     �                                                            ���
	���          �                                                            ���
	�������������������������������������������������������������������������͹��
	���Uso       �LBRA075                                                     ���
	�������������������������������������������������������������������������ͼ��
	�����������������������������������������������������������������������������
	���������������������������������������������������������������������������*/
	Static Function TesInfo(cTes)
	
	Local cAlias
	Local aImpFlag :={}
	
	cAlias  :=Alias()
	nOrder  :=IndexOrd ()
	nReg	  :=Recno()
	
	SFB->(DbSetOrder(1))
	
	DbSelectArea("SFC")
	DbSetOrder(1)
	DbSeek(xFilial("SFC")+cTes)
	
	While SFC->(!eof()) .and. xFilial("SFC")== FC_FILIAL .and. cTes== FC_TES
		
		If SFB->(DbSeek(xFilial("SFB")+SFC->FC_IMPOSTO))
			If (cTes<"500" )
				Aadd(aImpFlag,{SFB->FB_CODIGO,"D1_VALIMP"+SFB->FB_CPOLVRO,SFC->FC_INCNOTA,SFC->FC_INCDUPL,SFC->FC_CREDITA,"F1_VALIMP"+SFB->FB_CPOLVRO,"D1_BASIMP"+SFB->FB_CPOLVRO,"F1_BASIMP"+SFB->FB_CPOLVRO,SFB->FB_ALIQ,"D1_ALQIMP"+SFB->FB_CPOLVRO})
			Else
				Aadd(aImpFlag,{SFB->FB_CODIGO,"D2_VALIMP"+SFB->FB_CPOLVRO,SFC->FC_INCNOTA,SFC->FC_INCDUPL,SFC->FC_CREDITA,"F2_VALIMP"+SFB->FB_CPOLVRO,"D2_BASIMP"+SFB->FB_CPOLVRO,"F2_BASIMP"+SFB->FB_CPOLVRO,SFB->FB_ALIQ,"D2_ALQIMP"+SFB->FB_CPOLVRO})
			EndIf
		EndIf
		SFC->(DbSkip())
	End
	DbSelectArea(cAlias)
	DbSetOrder(nOrder)
	DbGoTo(nReg)
	
	Return(aImpFlag)
	
	
	
	
	
	
	
	
