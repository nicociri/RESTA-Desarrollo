#include "protheus.ch"
#include "rwmake.ch" 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcion   � A085AFM2 � Autor � Fernando Stella �Fecha � 09/06/11       ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  � Impresi�n en la Orden de Pago                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Orden de Pago                                              ���
�������������������������������������������������������������������������Ĵ��
���         ACTUALIZACIONES EFECTUADAS DESDE LA CODIFICACION INICIAL      ���
�������������������������������������������������������������������������Ĵ��
���Programador � Fecha  �         Motivo de la Alteracion                 ���
�������������������������������������������������������������������������Ĵ��
���            �  /  /  �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function A085AFM2                       
Local aArea       := GetArea( ),;
      aAreaSE1    := SE1->( GetArea( ) ),;
      aOrd        := ParamIxb,;
      aAreaSEK    := SEK->( GetArea() ),;
      nLen        := Len( aOrd[1] ),;
      cOrdPago    := '',;
      nX2         := 0 ,;
      cProv       := '',;
      cLoja       := ''


For nX2 := 1 To nLen

    cOrdPago := aOrd[1][nX2][1]
	cProv    := aOrd[1][nX2][2]
	cLoja    := aOrd[1][nX2][3]

   DbSelectArea('SEK')
   DbSetOrder(1)
   DbSeek( xFilial('SEK') + cOrdPago )

   While !SEK->(Eof()) .and. xFilial('SEK') + cOrdPago == SEK->EK_FILIAL + SEK->EK_ORDPAGO

      //If SEK->EK_TIPODOC == 'CT'
      //   U_ECGCSEK()
      //EndIf

      SEK->(DbSkip())
   EndDo
   

Next

If MsgYesNo(OemToAnsi("Desea hacer la impresi�n de la/s orden/es de pago/s?"))
	U_PCRFIN02(aOrd[1][1][1],aOrd[1][Len(aOrd[1])][1])
EndIf

If MsgYesNo(OemToAnsi("Desea hacer la impresi�n de los certificados de retenci�n?"))
	U_PCRFIN03(aOrd[1][1][1],aOrd[1][Len(aOrd[1])][1],2)
EndIf



RestArea( aAreaSE1 )
RestArea( aAreaSEK )
RestArea( aArea )

fActualizaPosAr()


Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A085AFim  �Autor  �Microsiga           �Fecha �  03/18/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Punto de entrada despues de la grabacion de la orden de    ���
���          � pago.                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � P10 - PC ARTS                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fActualizaPosAr()

Local cQuery	:= ''

cQuery := "UPDATE "+RetSQLName("SEK")
cQuery += "   SET EK_USPOSAR = 'E'"
cQuery += "   FROM "		+RetSQLName("SEK")
cQuery += "   INNER JOIN "	+RetSQLName("SA2")
cQuery += "   ON A2_COD = EK_FORNECE AND A2_LOJA = EK_LOJA"
cQuery += "   WHERE EK_ORDPAGO = '"+cOrdPago+"'"
cQuery += "   AND A2_TIPO = 'E'"

TcSQLExec(cQuery)

Return