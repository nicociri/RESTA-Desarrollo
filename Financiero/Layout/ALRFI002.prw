#include "PROTHEUS.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREPORT    บAutor  ณLovos Andres        บFecha ณ 16/02/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza la impresion de las Transferencias entre bancos    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function ALRFI002()
	
	Local aArea 		:= GetArea()
	Local cDesc1		:= "Este programa imprime el comprobante de Transferencias Bancarias"
	Local cDesc2		:= ""
	Local cDesc3		:= ""
	Local wnrel			:= "TransBancarias"
	Local cString		:= "SE5"
	Local cPerg         := PAdr("ALRFI002",10," ")
	Local cSecNumP 		:= ""
	Local cSecNumR 		:= ""
	Local cQuery		:= ""

	Private tamanho		:= "P"
	Private limite		:= 80
	Private titulo		:= "Impresi๓n de Transferencias Bancarias"
	Private aReturn		:= { OemToAnsi("A Rayas"), 1,OemToAnsi("Administracion"), 2, 2,1,"",1 } //"Zebrado"###"Administracao"
	Private nomeprog	:= "ALRFI002"
	Private nLastKey	:= 0
	Private entra 		:= .T.
	Private nLine 		:= 1
	Private M_PAG		:= 1

	Private aVar := {ctod("  /  /  "),"","","","","",0,"","","","","","","",""}
	
	Ajustasx1(cPerg)	
	if Funname()=="FINA100"
		fFecha:=E5_DATA
		cTran:=E5_PROCTRA
		cAliasSE5:="SE5_TMP"
		If Select((cAliasSE5))<>0
			DbSelectArea((cAliasSE5))
			DbCloseArea()
		Endif

		cQuery:="SELECT E5_DATA,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_RECPAG,E5_BENEF,E5_HISTOR,E5_NATUREZ,E5_VALOR,E5_MOEDA,E5_NUMCHEQ,"
		cQuery+="E5_DOCUMEN,E5_PROCTRA,E5_TIPODOC,E5_SITUACA "
		cQuery+="FROM "+RetSqlName("SE5")+" "+(cAliasSE5)+" "
		cQuery+="WHERE E5_FILIAL='"+xfilial("SE5")+"' AND D_E_L_E_T_<>'*' "
		cQuery+=" AND E5_TIPODOC = 'TR' "
		cQuery+=" AND E5_DATA = '"	+DTOS(fFecha)+"'"
		cQuery+=" AND E5_PROCTRA >=  '"	+cTran+"'"
		cQuery+=" ORDER BY E5_DATA, E5_BANCO, E5_AGENCIA, E5_TIPODOC "
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasSE5),.F.,.T.)
		cuenta:=0
		
	else
		pergunte(cPerg,.t.)
		cAliasSE5:="SE5_TMP"
		If Select((cAliasSE5))<>0
			DbSelectArea((cAliasSE5))
			DbCloseArea()
		Endif

		cQuery:="SELECT E5_DATA,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_RECPAG,E5_BENEF,E5_HISTOR,E5_NATUREZ,E5_VALOR,E5_MOEDA,E5_NUMCHEQ,"
		cQuery+="E5_DOCUMEN,E5_PROCTRA,E5_TIPODOC,E5_SITUACA "
		cQuery+="FROM "+RetSqlName("SE5")+" "+(cAliasSE5)+" "
		cQuery+="WHERE E5_FILIAL='"+xfilial("SE5")+"' AND D_E_L_E_T_<>'*' "
		cQuery+=" AND E5_TIPODOC = 'TR' "
		cQuery+=" AND E5_DATA = '"	+DTOS(MV_PAR01)+"'"
		cQuery+=" AND (E5_BANCO >=  '"	+MV_PAR03+"' AND E5_BANCO <='"+MV_PAR04+"') "
		cQuery+=" AND (E5_PROCTRA >= '"	+MV_PAR05+"' AND E5_PROCTRA <='"+MV_PAR06+"') "
		cQuery+=" ORDER BY E5_DATA, E5_BANCO, E5_AGENCIA, E5_TIPODOC "
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasSE5),.F.,.T.)
		cuenta:=0
	endif

	If MsgYesNo("Seleccionados comprobantes"+CHR(13)+"Confirma la impresi๓n ?","Comprobante Movimiento bancacrio")
		wnrel := SetPrint(cString,wnrel,,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,tamanho,"",.T.)
		If nLastKey <> 27
			SetDefault(aReturn,cString)
			If nLastKey <> 27		
				DbSelectArea((cAliasSE5))
				(cAliasSE5)->(dbgotop())
				While (cAliasSE5)->(!Eof())
					IF (cAliasSE5)->E5_RECPAG == 'P'
						aVar := {ctod("  /  /  "),"","","","","",0,"","","","","","","",""}			
						aVar[1] := (cAliasSE5)->E5_DATA	// 1
						aVar[2] := (cAliasSE5)->E5_BANCO	// 2 -  char
						aVar[3] := (cAliasSE5)->E5_AGENCIA	// 3 - char
						aVar[4] := (cAliasSE5)->E5_CONTA	// 4 - char
						aVar[5] := (cAliasSE5)->E5_NATUREZ	// 5 - char
						aVar[6] := (cAliasSE5)->E5_MOEDA	// 6 - char
						aVar[7] := (cAliasSE5)->E5_VALOR	// 7 - Num
						aVar[8] := (cAliasSE5)->E5_NUMCHEQ	// 8 - char
						aVar[9] := (cAliasSE5)->E5_BENEF	// 9 - char
						aVar[10] := (cAliasSE5)->E5_PROCTRA	// 10 - char
						aVar[11] := (cAliasSE5)->E5_HISTOR	// 11 - char
					EndIF
					IF (cAliasSE5)->E5_RECPAG == 'R' 
						aVar[12] := (cAliasSE5)->E5_BANCO		// 12
						aVar[13] := (cAliasSE5)->E5_AGENCIA	// 13
						aVar[14] := (cAliasSE5)->E5_CONTA		// 14
						aVar[15] := (cAliasSE5)->E5_NATUREZ	// 15
						
					EndIF
					cuenta++
				    DbSkip()
				EndDo
				
				RptStatus({|| ImpComp()},Titulo)
				
				DBSELECTAREA((cAliasSE5))
				dbclosearea()

				If aReturn[5]==1
					dbCommitAll()
					SET PRINTER TO
					OurSpool(wnrel)
				Endif
				MS_FLUSH()
			Endif
		Endif
		RestArea(aArea)
	EndIf

	IF cuenta > 0
		entra:=.t. 
	ELSE
		entra:=.f.
		msgalert("No hay datos para mostrar...")
	EndIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpComp    บAutor  ณLovos Andres	      บFecha ณ 15/02/2012  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime los comprobantes.                                   บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FINA100                                                     บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpComp()
	Local cAux := ""
	Local nMoedaCx := 0
	Local aSA6 := SA6->(GetArea())
	Local nLinMax  := 60
	Local cFechMov := ""
	Local cFecMov := ""

	SA6->(DbSetOrder(1))
	SA6->(DbSeek(xFilial("SA6")+aVar[2]+aVar[3]+aVar[4]))
	nMoedaCx:=Max(SA6->A6_MOEDA,1)
	cAux:="MV_SIMB"+Alltrim(Str(nMoedaCx))
	
//	Cabec(Titulo,"","",NomeProg,Tamanho)

	/*** Cabecera ***/
	// Fila, Columna
	@nLine,003 Psay Replicate("-",75)
	nLine:= 2
	@nLine,023 Psay Titulo
	nLine+= 2
	@nLine,020 Psay "Empresa: " + AllTrim(SM0->M0_NOME) + " / " + "Sucursal: "+ SM0->M0_FILIAL
	nLine+= 1
	@nLine,003 Psay Replicate("-",75)
	/****************/
	
	nLine := nLine +5
	cFecMov := aVar[1]
	cFechMov := STOD(cFecMov)
	@nLine,017 Psay "Fec. Mov. : " + cValToChar(cFechMov)
	nLine++
	@nLine,017 Psay "De Banco  : " + aVar[2]  + " - "+ Alltrim(SA6->A6_NREDUZ)
	nLine++
	@nLine,017 Psay "Agencia   : " + aVar[3]
	nLine++
	@nLine,017 Psay "Cuenta    : " + aVar[4]
	nLine++
	@nLine,017 Psay "Naturaleza: " + Posicione("SED",1,xfilial("SED")+ aVar[5],"ED_DESCRIC")
	nLine := nLine + 2

	SA6->(DbSeek(xFilial("SA6")+aVar[12]+aVar[13]+aVar[14]))
	@nLine,017 Psay "A Banco   : " + aVar[12]+ " - " + Alltrim(SA6->A6_NREDUZ)
	nLine++
	@nLine,017 Psay "Agencia   : " + aVar[13]
	nLine++
	@nLine,017 Psay "Cuenta    : " + aVar[14]
	nLine++
	@nLine,017 Psay "Naturaleza: " + Posicione("SED",1,xfilial("SED")+ aVar[15],"ED_DESCRIC")			
	nLine := nLine + 2
//	nLine++

	@nLine,017 Psay "Tipo      : " + aVar[6]
	nLine++
	@nLine,017 Psay "Valor     : " + Alltrim(SuperGetMV(cAux,,"")) + TransForm(aVar[7],"@E 9,999,999.99" )
//	nLine := nLine+4
	nLine++
	@nLine,017 Psay "Documento : " + aVar[8]
	nLine++
	@nLine,017 Psay "Benefic.  : " + aVar[9]
	nLine++
	@nLine,017 Psay "Historial : " + aVar[11]
	nLine++
	@nLine,017 Psay "Numeraci๓n: " + aVar[10]

	nLine := nLine + 18
	@nLine,011 Psay "______________________________"
	@nLine,045 Psay "______________________________"
	nLine++
	@nLine,011 Psay "Firma de Responsable"
	@nLine,045 Psay "Firma de Responsable"

	nLine := nLine + 6
				
	IF nLine >= 50
		nLine := 1
	EndIF
	SA6->(RestArea(aSA6))
Return()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณAjustaSX1 บ Autor ณ Andres Lovos       บ Data ณ 15/02/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Crea las Preguntas de SX1	                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                              		                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function AjustaSX1(cPerg)

	Local aArea := GetArea()
	Local aRegs := {}, i, j

	cPerg := Padr(cPerg,Len(SX1->X1_GRUPO))

	DbSelectArea("SX1")
	DbSetOrder(1)

	aAdd(aRegs,{cPerg,"01","Fecha Desde		","Fecha Desde	","Fecha Desde 	","mv_ch1","D",8,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	aAdd(aRegs,{cPerg,"02","Fecha Hasta		","Fecha Hasta	","Fecha Hasta 	","mv_ch2","D",8,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )

	aAdd(aRegs,{cPerg,"03","Banco Desde		","Banco Desde	","Banco Desde 	","mv_ch3","C",3,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","" } )    
	aAdd(aRegs,{cPerg,"04","Banco Hasta		","Banco Hasta	","Banco Hasta 	","mv_ch4","C",3,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","" } )

	aAdd(aRegs,{cPerg,"05","Registro Desde	","Registro Desde","Registro Desde 	","mv_ch5","C",12,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	aAdd(aRegs,{cPerg,"06","Registro Hasta	","Registro Hasta","Registro Hasta	","mv_ch6","C",12,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )

	For i:=1 to Len(aRegs)
	   If !dbSeek(cPerg+aRegs[i,2])
		  RecLock("SX1",.T.)
		  For j:=1 to FCount()
			 If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			 Endif
		  Next
		  MsUnlock()
		Endif
	Next
	RestArea(aArea)
RETURN