#INCLUDE 'rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LJ7020    �Autor  �Nicolas Cirigliano  �Fecha �  18/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE para controlar que botones aparecen como medios de      ���
���          � pago en la venta asistida. Pendiente linea 189, Canseco    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//reemplazado por LJ7023

User Function LJ7020()

Local lRet := .T.
/*
lRet := ! ( ParamIXB[01] == 'CONVENIO' )
*/

return (lRet)