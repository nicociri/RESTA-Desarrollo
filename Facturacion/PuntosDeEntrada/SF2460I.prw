#Include "RWMAKE.CH"
#include "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SF2460I  �Autor  �Fernando Cardeza    �Fecha �  08/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Punto de entrada para grabar datos en el encabezado de la  ���
���          � factura de venta desde el pedido de ventas o Remito.       ���
�������������������������������������������������������������������������͹��
���Uso       � AP11                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function SF2460I()

Local cprogram	:= Alltrim(FunName()) 
Local lRet		:= .T.

If cprogram == "MATA468N" .OR. cprogram=="MATA461"
	U_mdpent(cprogram)     

EndIf

Return(lRet)

//==================================================//
//      Modificacion de provincia de entrega        //
//==================================================//

User function mdpent(cprogram)

Local aArea 	:= GetArea()

//==================================================//
//      Generacion de Factura de Ventas             //
//==================================================//
     
If cprogram == "MATA468N" .OR. cprogram=="MATA461"
	
	If Empty(SF2->F2_XNROACO)
      If !Empty(SD2->D2_PEDIDO)
         SC5->(DbSetOrder(1))
         If SC5->(DbSeek(xFilial('SC5')+SD2->D2_PEDIDO)) .and. !Empty(SC5->C5_NUM)
            RecLock('SF2', .F.)
            Replace F2_XESACO  With SC5->C5_XESACO
            Replace F2_XNROACO With SC5->C5_XNROACO
            MsUnLock()
         EndIf
      EndIf
    EndIf
EndIf                 
	If !Empty(SF2->F2_XNROACO)
	  	Z01->(DbSetOrder(1))
      	If Z01->(DbSeek(xFilial('Z01')+SF2->F2_XNROACO))
         	nTotal   := xMoeda( SD2->D2_TOTAL, SF2->F2_MOEDA, 1, dDataBase, 4, SF2->F2_TXMOEDA, 1 )
         	nTotImp  := xMoeda( SD2->(D2_TOTAL+D2_VALIMP1+D2_VALIMP2+D2_VALIMP3+D2_VALIMP4+D2_VALIMP5+D2_VALIMP6), SF2->F2_MOEDA, 1, dDataBase, 4, SF2->F2_TXMOEDA, 1 )
         	RecLock('Z01',.F.)
         	Replace Z01_STATUS With "3"
         	MsUnLock()
      	EndIf 
	EndIf

RestArea (aArea)

Return                                          
