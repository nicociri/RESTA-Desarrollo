
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA330EXC  �Autor  �Microsiga           �Fecha �  06/30/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function FA330EXC
Local cAcopio:=""

If !Inclui
	cAcopio:="" //en el borrado deja el registro SE1 en vacio
EndIf

RecLock("SE1",.F.)
Replace E1_XNROACO	With cAcopio
MsUnlock( )


Return