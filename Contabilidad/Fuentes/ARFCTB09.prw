#Include "RwMake.ch"
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncao    � ARFCTB09 � Autor � MS				    � Data � 11/03/08 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Geracao do codigo por modulo para o cadastro de auxiliar   潮�
北�          � de asiento (SZB)                                           潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � MRO					                                      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砄bs.      � Gatilho        : ZB_MODULO                                 潮�
北�          � Contra Dominio : ZB_COD	 	                              潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User Function ARFCTB09()
*
Local aArea  	:= GetArea()
Local cModulo	:= M->ZB_MODULO
Local cCodigo := "001"
*
IF Inclui
	If Empty(cModulo)
		MsgStop("Favor preencher o campo Modulo")
		M->ZB_MODULO := SPACE(Len(M->ZB_MODULO))
		cCodigo := SPACE(Len(M->ZB_COD))
	Endif
	*
	dbSelectArea("SZB")
	dbSetOrder(1)
	While .T.
		IF !MsSeek(xFilial("SZB")+M->ZB_MODULO+cCodigo)
			Exit
		Endif
		cCodigo := SOMA1(cCodigo)
	Enddo
	*
Else
	cCodigo := M->ZB_COD
Endif
RestArea(aArea)
Return(cCodigo)
