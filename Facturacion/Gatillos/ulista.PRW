/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ulista  �Autor  �Microsiga            �Fecha �  20/06/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cartel de aviso para cuando un producto que no esta en     ���
���          � la lista de acopio                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ulista()
Local aArea		:= GetArea()

dbselectarea("DA1")
DbSetOrder(1)

	If !DbSeek(xFilial("DA1")+M->C5_TABELA+aCols[n][GdFieldPos("C6_PRODUTO")]) .AND. !GdDeleted() 
		Alert("Usted esta ingresando un producto que no esta en la lista de precios del ACOPIO")
	EndIf
		
RestArea(aArea)
Return(M->C5_NUM)