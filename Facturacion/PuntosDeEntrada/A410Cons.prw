#Include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  A410Cons     �Autor  �Microsiga           � Data �  11/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Punto de entrada para agregar botones en EnchoiceBar Pedido de ventas���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
                   
User Function A410Cons 

Local aButtons  := {}
Local aButtons	:= array(0)

aadd(aButtons,{"BMPUSER",{|| U_createArchPed() },"Impr. Proform","Impr. Proform" }) 	//"Posi��o de Cliente"
                                                             
SetKey(VK_F6,{||u_TraeProd()})
Aadd(aButtons , {'S4WB013N' ,{|| u_traeprod() },"Incluir Productos","Incluir productos"} ) //"consulta de productos"

Return aButtons