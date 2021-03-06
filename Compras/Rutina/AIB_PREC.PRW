#include 'protheus.ch'
#include 'colors.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AIB_PREC  �Autor  � Nicolas Cirigliano �Fecha �  10/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � gatillo para calcular el precio unitario en base a los     ���
���          � descuentos y el precio base en la tabla AIB                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AIB_PREC()

Local nPrecio
local nPosBase := GDFieldPos("AIB_PRBASE")
local nPosDes1 := GDFieldPos("AIB_DESC1")
local nPosDes2 := GDFieldPos("AIB_DESC2")
local nPosDes3 := GDFieldPos("AIB_DESC3")
local nPosDes4 := GDFieldPos("AIB_DESC4")
local nPosDes5 := GDFieldPos("AIB_DESC5")
local nPosDes6 := GDFieldPos("AIB_DESC6")

nprecio := round(((((((acols[n][nPosBase]*(100-acols[n][nPosDes1])/100)*(100-acols[n][nPosDes2])/100)*(100-acols[n][nPosDes3])/100)*(100-acols[n][nPosDes4])/100)*(100-acols[n][nPosDes5])/100)*(100-acols[n][nPosDes6])/100),2)

return (nPrecio)