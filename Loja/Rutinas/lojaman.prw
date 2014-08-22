#include "rwmake.ch"        // incluido por el asistente de conversión del AP5 IDE en 26/04/00


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOJAMAN   ºAutor  ³Nicolas Cirigliano  ºFecha ³  20/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcion similar a la M465SER, pero solo para que la venta  º±±
±±º          ³ asistida seleccione correctamente la serie.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function lojaman()        // incluido por el asistente de conversión del AP5 IDE en 26/04/00

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