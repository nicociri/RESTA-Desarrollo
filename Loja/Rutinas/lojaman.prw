#include "rwmake.ch"        // incluido por el asistente de conversi�n del AP5 IDE en 26/04/00


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LOJAMAN   �Autor  �Nicolas Cirigliano  �Fecha �  20/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcion similar a la M465SER, pero solo para que la venta  ���
���          � asistida seleccione correctamente la serie.                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function lojaman()        // incluido por el asistente de conversi�n del AP5 IDE en 26/04/00

local cDoc := ""                  
Local aArea := GetArea()
SetPrvt("_XCSERIE,")

_xcSerie := Space(3)

// Segun el tipo de cliente, sabremos que serie hay que usar
if ValType(M->LQ_CLIENTE) == "U" 
	__cTipo := "F"
elseif Empty(Alltrim(M->LQ_CLIENTE))
	__cTipo := "F"
else
	__cTipo := Posicione( 'SA1', 1, xFilial('SA1') + M->LQ_CLIENTE + M->LQ_LOJA, 'A1_TIPO' )   
endif 

If __cTipo $ 'E'
		_xcSerie := "E"+alltrim(cfilant)
ElseIf __cTipo $ "I-N"    
		_xcSerie := "A"+alltrim(cfilant)
Else
		_xcSerie := "B"+alltrim(cfilant)
EndIf

restarea(aArea)
return _xcSerie