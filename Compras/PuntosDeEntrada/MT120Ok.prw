#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"


//+----------------------------------------------------------------------+
//| Rotina    | MT120OK    | Autor | Robson Luiz     | Data | 16.03.2006 |
//+----------------------------------------------------------------------+
//| Descri��o | Valida��o total da getdados.                             |
//+----------------------------------------------------------------------+
//| Objetivo  | Se a rotina for AE e o campo nr. e item de contrato      |
//|           | preenchido, criticar.                                    |
//+----------------------------------------------------------------------+
//| Uso       | Delta Compresi�n (Gerenciado por Hector Merlino)         |
//+----------------------------------------------------------------------+

User Function MT120Ok()

Local lRet:=.T.

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


If altera
   lRet:=Prodaco4()
EndIf           

If Inclui
	lRET:=!MSGYESNO("Verificar que la provincia de entrega en la cabecera sea la correcta, �Desea modificarla?")
EndIf

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

Static Function Prodaco4()
	Local aArea		:= GetArea()
	Local nPosDel	:= Len(aHeader) + 1
	Local nI 		:= 0
	Local lRet		:= .T.
	
	For nI := 1 To Len(aCols)
		If ALLTRIM(aCols[nI][GdFieldPos("C7_PRODUTO")]) == "ACOPIO" .AND. GdDeleted() 
			lRet:=MSGYESNO("Usted esta borrando el producto ACOPIO, al hacer esto va a cerrar el pedido de venta, �Desea continuar?")	
		EndIf
	Next nI                                  
	RestArea(aArea)
Return(lRet) 