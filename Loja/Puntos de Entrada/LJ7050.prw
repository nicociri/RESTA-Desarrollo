#INCLUDE "PROTHEUS.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LJ7050    �Autor  �Microsiga           �Fecha �  09/09/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �   Punto de entrada para modificar el codigo de cliente     ���
���          �   enviado a la fiscal                                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LJ7050(cRetorno, lImpTicket)

Local cCadena	:= cRetorno
Local aCadena	:= {}
Local nX		:= 1  
Local cRet		:="" 
Local aArea := GetArea()
Local cSocio

//msgstop(cCadena)  
aCadena	:= strtokarr(cCadena,"|") 
aCadena[2]	:= alltrim(SL1->L1_CLIENTE) + " - " + Alltrim(aCadena[2]) 

for nX:=1 to Len(aCadena) 
	cRet	:= cRet + aCadena[nX]
	if nX != Len(aCadena)
		cRet	:= cRet	+ "|"
	Endif
Next nX

RestArea(aArea)
Return cRet