#INCLUDE "Protheus.ch"   
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460FIM   �Autor  �Andres Demarziani   �Fecha �  07/20/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Punto de entrada despues de la generacion de las facturas  ���
���          � a partir de pedido/remito (mata468n)                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M460FIM()
Local aArea    := GetArea()
Local aAreaSD2 := SD2->(GetArea())
Local aAreaSF2 := SF2->(GetArea())
Local aAreaSE1 := SE1->(GetArea())
Local aDatos	:= {}
Local _nOkDlg := 0
Local cObserv	:= space(200)


//����������������������������������������������������������Ŀ
//� Facturacion automatica - Agregado para Pago Facil.       �
//���������������������������������������������� Gabriel �����
If IsInCallStack("MATA468N") 

		DbSelectArea( "SE1" )
		DbSeek( xFilial('SE1') + SF2->F2_SERIE + SF2->F2_DOC )
		While !Eof() .and. E1_PREFIXO + E1_NUM == ( SF2->F2_SERIE + SF2->F2_DOC )
            IF RecLock("SE1",.F.)
               Replace E1_XNROACO With SF2->F2_XNROACO             // 
               MsUnlock()
            ENDIF
            DbSkip()
	 	EndDo 


EndIf

RestArea (aAreaSE1)
RestArea (aAreaSF2)
RestArea (aAreaSD2)
RestArea (aArea)
Return NIL
