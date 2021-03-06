#INCLUDE "Protheus.ch"   
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LOCXPE11   �Autor  �Andres Demarziani   �Fecha �  07/20/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Punto de entrada despues de la generacion de las facturas  ���
���          � a partir de pedido/remito (mata468n)                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LOCXPE11()
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
If ALLTRIM(FUNNAME()) $ "MATA467N|MATA468N"

		DbSelectArea( "SE1" )
		DbSeek( xFilial('SE1') + SF2->F2_SERIE + SF2->F2_DOC )
		While !Eof() .and. E1_PREFIXO + E1_NUM == ( SF2->F2_SERIE + SF2->F2_DOC )
            IF RecLock("SE1",.F.)
               Replace E1_XNROACO With SF2->F2_XNROACO             
               Replace E1_XCONTAC With SF2->F2_XCONTAC
               MsUnlock()
            ENDIF
            DbSkip()
	 	EndDo 
EndIf     

If FUNNAME()=='MATA102N' 
	If SF1->F1_NATUREZ="COMPRAS"	
	 //	For n:=1 to Len(Acols)
	 //		aCols[n][aScan(aHeader,{|x| AllTrim(x[2])=="D1_QTDPEDI" })]:=aCols[n][aScan(aHeader,{|x| AllTrim(x[2])=="D1_QUANT" })]
	 //	Next  
	    DbSelectArea("SD1")
	    DbSetOrder(1)
		DbSeek( xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
		While !Eof() .and. SD1->D1_SERIE + SD1->D1_DOC == ( SF1->F1_SERIE + SF1->F1_DOC )
            IF RecLock("SD1",.F.)
               Replace D1_QTDACLA With 0           
               MsUnlock()
            ENDIF
            DbSkip()
	 	EndDo 
	EndIf
EndIf

RestArea (aAreaSE1)
RestArea (aAreaSF2)
RestArea (aAreaSD2)
RestArea (aArea)
Return NIL