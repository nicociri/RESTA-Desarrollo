#Include "RwMake.ch"
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � ARFCTB09 � Autor � MS				    � Data � 11/03/08 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Geracao do codigo por modulo para o cadastro de auxiliar   ���
���          � de asiento (SZB)                                           ���
�������������������������������������������������������������������������Ĵ��
���Uso       � MRO					                                      ���
�������������������������������������������������������������������������Ĵ��
���Obs.      � Gatilho        : ZB_MODULO                                 ���
���          � Contra Dominio : ZB_COD	 	                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
