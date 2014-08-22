#Include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Locxpe37     �Autor  �Microsiga           �Fecha � 11/16/10 ���
�������������������������������������������������������������������������͹��
���Desc.     � Para Grabar datos en el titulo financiero que genera 	  ���
���          � una factura                                                ���
�������������������������������������������������������������������������͹��
���Uso       � ARIMEX                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Locxpe37()
Local _aDupori	:= paramixb  // guardo el array del titulo original
local _aAreaSe2	:= SE2->(GetArea())  // guardo el Area de la Se2
local _aAreaSe1	:= SE1->(GetArea())  // guardo el Area de la Se2

For nx	:= 1 to len(_aDupOri)
	If Funname()='MATA101N'  // si es factura de entrada
		SE2->(DBGOTO(_aDupOri[nx]))
		Reclock ("SE2",.F.)
		Replace SE2->E2_XPRONP WITH SF1->F1_XPRONP
		MsUnlock()
	EndIf
Next

RestArea(_aAreaSe2)
RestArea(_aAreaSe1)
Return _aDupOri
