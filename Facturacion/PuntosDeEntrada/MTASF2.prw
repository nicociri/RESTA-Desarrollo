#Include "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTASF2    �Autor  �ms				     �Fecha �  11/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Punto de entrada para traer datos desde el pedido de       ���
���          � venta a la factura.							              ���
�������������������������������������������������������������������������͹��
���Uso       � AP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTASF2

Local cSF2     := RetSQLName("SF2")
Local cSC5     := RetSQLName("SC5")
Local cSQL     := ""

If Alltrim(FunName()) = "MATA468N"     // Generacion de Factura de Ventas
	IF SF2->( FieldPos( "F2_NATUREZ" ) ) > 0   
       REPLACE F2_NATUREZ WITH SC5->C5_NATUREZ
    ENDIF
	IF SF2->( FieldPos( "F2_XNROACO" ) ) > 0   
       REPLACE F2_XNROACO WITH SC5->C5_XNROACO
    ENDIF
    IF SF2->( FieldPos( "F2_XCONTAC" ) ) > 0   
       REPLACE F2_XCONTAC WITH SC5->C5_XCONTAC
    ENDIF
ENDIF

Return