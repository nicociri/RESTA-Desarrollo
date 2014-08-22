#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120LOK  �Autor  �F.C.                �Fecha �  21/10/200  ���
�������������������������������������������������������������������������͹��
���Desc.     � Punto de entrada que se ejecuta al validar las lineas del  ���
���          � pedido de compras.                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT120LOK()

Local lRet		:=	.T.
Local nPosTES    := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_TES"})
If altera
	lRet:=Prodaco2()
EndIf                     
/*
//MaFisClear()
A120Refresh(@aValores)
// agrego refresh para calculo de impuestos
SA2->(DbSetOrder(1))
SA2->(MsSeek(xFilial("SA2")+MaFisRet(,"NF_CODCLIFOR")+MaFisRet(,"NF_LOJA")))
A120VFold('NF_CODCLIFOR',"001")
A120VFold('NF_CODCLIFOR',ca120Forn)
MaFisAlt("NF_SERIENF",LocXTipSer("SA2",MVNOTAFIS))
MaFisToCols(aHeader,aCols,,"MT120")
Eval(bListRefresh)
Eval(bRefresh)
Eval(bGDRefresh)
  */
Return(lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Prodaco  �Autor  �Microsiga            �Fecha �  12/30/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cartel de aviso para cuando borran el producto acopio      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Prodaco2()
Local aArea		:= GetArea()
Local nPosDel	:= Len(aHeader) + 1
Local lRet		:= .T.

If ALLTRIM(SC7->C7_PRODUTO) == "ACOPIO" .AND. GdDeleted()
	Alert("Usted esta borrando el producto ACOPIO, al hacer esto va a cerrar el pedido de venta")
EndIf

RestArea(aArea)

Return(lRet)
