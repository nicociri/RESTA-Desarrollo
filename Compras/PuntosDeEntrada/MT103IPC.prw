#include "rwmake.ch"
#include "Protheus.ch"

/*
臼浜様様様様用様様様様様僕様様様冤様様様様様様様様様曜様様様冤様様様様様様傘�
臼�Programa  �MT103IPC  �Autor  �Nicolas Cirigliano  �Fecha �  04/27/10   艮�
臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒�
臼�Desc.     � P.E. que se ejecuta luego de que le damos OK a la ventana  艮�
臼�          � de inclusion de PC o AE en el Remito de Entrada            艮�
臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒�
*/

User Function MT103IPC()

Local nPosDesc := Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_XDESCOD"})
Local nPosDepo := Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_LOCAL"})
Local nPosTES  := Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_TES"})
Local nPosItem

nPosItem := Len(aCols)

M->F1_NATUREZ := SC7->C7_NATUREZ

If nPosItem > 0 .and. nPosDesc > 0
	aCols[nPosItem][nPosDesc] := SC7->C7_DESCRI
EndIf

If nPosItem > 0
	aCols[nPosItem][nPosDepo] := SC7->C7_LOCAL
EndIf       

If nPosTES > 0
	aCols[nPosItem][nPosTES] := SC7->C7_TES
EndIf

If FunName() == "MATA102N" //Remito de entrada

EndIf

If FunName() == "MATA101N" //Factura de entrada

EndIf

Return