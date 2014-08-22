#include "protheus.ch"
/*/
����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcion   � Fa088Can � Autor � Fernando Cardeza		� Data � 25/11/13 ���
�������������������������������������������������������������������������Ĵ��
���Descricion�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �  Financiero                                                ���
�������������������������������������������������������������������������Ĵ��
��� ACTUALIZACIONES SUFRIDAS DESDE LA CONSTRUCCION INICIAL.               ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
���              �        �      �                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Fa088Can
Local aArea    := GetArea()

If AllTrim(SEL->EL_TIPODOC) == 'TB' .and. AllTrim(SEL->EL_TIPO) == 'NF' 

   If SF2->(DbSeek(xFilial('SEL')+SEL->(EL_NUMERO+EL_PREFIXO+EL_CLIORIG+EL_LOJORIG)))
   	  If !Empty(SF2->F2_XNROACO)
         Z01->(DbSetOrder(1))
         If Z01->(DbSeek(xFilial('Z01')+SF2->F2_XNROACO))
            RecLock('Z01',.F.)
            Replace Z01_STATUS With '3'
	        MsUnLock()
         EndIf
      EndIf   
   EndIf
   
EndIf

RestArea(aArea)

Return