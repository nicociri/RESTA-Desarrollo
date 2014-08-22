#include "Protheus.ch"

User Function FI85ATCH()
Local aCpTitles := ParamIxb[1]
Local aCpCheqs := ParamIxb[2]
Local cCpLine := ParamIxb[3]
Local nloop := 0             
Local cEstado := ''

	aAdd(aCpTitles,RetTitle("E1_RECIBO"))   
	aAdd(aCpTitles,RetTitle("E1_CLIENTE"))
	aAdd(aCpTitles,RetTitle("E1_XNOMFIR"))
	aAdd(aCpTitles,RetTitle("E1_XESTADO"))

	For nloop := 1 to len(aCpCheqs)
		SE1->(dbGoto(aCpCheqs[nloop,11]))
		
		aAdd(aCpCheqs[nloop],SE1->E1_RECIBO)
		aAdd(aCpCheqs[nloop],SE1->E1_CLIENTE)
		aAdd(aCpCheqs[nloop],SE1->E1_XNOMFIR)        
		
		Do case
			case SE1->E1_XESTADO == '1'       
				cEstado := 'Ok' 
			case SE1->E1_XESTADO == '2'       
				cEstado := 'No a la Orden'
			case SE1->E1_XESTADO == '3'       
				cEstado := 'Dudoso'
		    case SE1->E1_XESTADO == '4'       
				cEstado := 'Depositar'
			case SE1->E1_XESTADO == '5'       
				cEstado := 'Interior'	
			case SE1->E1_XESTADO == '6'       
				cEstado := 'Viejo' 
		 End Case		
		aAdd(aCpCheqs[nloop],cEstado)
		aAdd(aCpCheqs[nloop],aCpCheqs[nloop,11])
	Next nloop
	
	cCpLine := { || {IIf(aCheques[oLbx:nAt][1]$"0",oOk,oNo),aCheques[oLbx:nAt][9],aCheques[oLbx:nAt][2],aCheques[oLbx:nAt][3],aCheques[oLbx:nAt][4],;
	TransForm(aCheques[oLbx:nAt][5],TM(aCheques[oLbx:nAt][5],18,MsDecimais(aCheques[oLbx:nAt][6]))),aCheques[oLbx:nAt][6],DTOC(aCheques[oLbx:nAt][7]),DTOC(aCheques[oLbx:nAt][8]),aCheques[oLbx:nAt][12],aCheques[oLbx:nAt][13],aCheques[oLbx:nAt][14],aCheques[oLbx:nAt][15]}}

	
	Return ( { aCpTitles, aCpCheqs, cCpLine})