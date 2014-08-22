#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALCUIT   �Autor  �Microsiga           �Fecha �  07/15/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacion de cuit del cliente                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VALCUIT
           
Local lRet    := .T.
Local aArea   := SA1->(GetArea())     
Local cCGC    := M->A1_CGC
Local cPessoa := M->A1_PESSOA


DbSelectArea("SA1")
DbSetOrder(3)
IF SA1->(DbSeek(xFilial("SA1")+cCGC))
   lRet:=A030CGC("F",cCGC)
ELSE   
   lRet:=CUIT(cCGC)
ENDIF

RestArea(aArea)
Return lRet