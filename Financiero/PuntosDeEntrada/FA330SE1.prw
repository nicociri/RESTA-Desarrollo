
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA330SE1  �Autor  �Microsiga           �Fecha �  06/30/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Punto de entrada que completa campo de acopio              ���
���          � En un RA asociado a una factura que posea acopio           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function FA330SE1
Local cAcopio:=""

For mk:=1 to Len(aTitulos)
   If aTitulos[mk][8] .AND. ALLTRIM(aTitulos[mk][4])=="NF"//Indica que fue seleccionado y que el titulo corresponde a una NF
   		If Empty(cAcopio)
   			cAcopio:=Posicione("SF2",1,xFilial("SF2")+aTitulos[mk][2]+aTitulos[mk][1]+ccliente+cloja,"F2_XNROACO")
   		EndIf
   EndIf 
Next

If !Empty(cAcopio)
	RecLock("SE1",.F.)
	Replace E1_XNROACO	With cAcopio
	MsUnlock( )
Endif            

Return