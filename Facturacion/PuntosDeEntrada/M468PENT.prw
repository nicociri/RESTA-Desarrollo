#Include "Protheus.ch"
User Function M468PENT()

Local aRet[1] := {GetMv("MV_TESFUT"),.F.}
/*
aRet[2] := Aviso("Punto M468PENT!!","Apresenta tela de solicitação de TES? ",{"Sim","Nao"}) == 1
If aRet[2]	
	If Aviso("Punto M468PENT!!","Mostra campo da TES preenchida? ",{"Sim","Nao"}) == 1		
		aRet[1] := "503" // <- TES com gera financeiro N e movimenta estoque S	
	EndIf
Else	
*/
//aRet[1] := cTes // <- TES  genera titulo financiero N y mueve stock S
//	EndIf
Return aRet