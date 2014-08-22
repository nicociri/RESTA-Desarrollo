#include "PROTHEUS.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALRFI001  บAutor  ณLovos Andres        บFecha ณ 16/02/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function ALRFI001()
	
	Local aArea 		:= GetArea()
	Local cDesc1		:= "Este programa imprime el comprobante de Movimiento Bancario"
	Local cDesc2		:= ""
	Local cDesc3		:= ""
	Local wnrel			:= "MovBancarios"
	Local cString		:= "SE5"
	Local cPerg         := PAdr("ALRFI001",10," ")
	
	Private tamanho		:= "P"
	Private limite		:= 80
	Private titulo		:= "Movimientos bancarios y cajas"
	Private aReturn		:= { OemToAnsi("A Rayas"), 1,OemToAnsi("Administracion"), 2, 2,1,"",1 } //"Zebrado"###"Administracao"
	Private nomeprog	:= "ALRFI001"
	Private nLastKey	:= 0
	Private entra 		:= .T.
	Private nLine 		:= 1
	Private M_PAG		:= 1
	
	Private aVar := {}

	If Funname()=="FINA100"
		AADD(aVar,{	DTOS(E5_DATA),;	// 1
					E5_BANCO,;		// 2
					E5_AGENCIA,;	// 3
					E5_CONTA,;		// 4
					E5_NATUREZ,;	// 5
					E5_MOEDA,;		// 6
					E5_VALOR,;		// 7
					E5_NUMCHEQ,;	// 8
					E5_DOCUMEN,;	// 9
					E5_BENEF,;		// 10
					E5_SECNUM,;		// 11
					E5_HISTOR,;		// 12
					E5_RECPAG,;		// 13
					E5_TIPODOC,;	// 14
					E5_SITUACA})	// 15
		entra := .T.
		cuenta := 1
	Else 
	
	Ajustasx1(cPerg)	
	if pergunte(cPerg,.t.)
		cAliasSE5:="SE5_TMP"
		If Select((cAliasSE5))<>0
			DbSelectArea((cAliasSE5))
			DbCloseArea()
		Endif

		cQuery:="SELECT E5_DATA,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_RECPAG,E5_BENEF,E5_HISTOR,E5_NATUREZ,E5_VALOR,E5_MOEDA,E5_NUMCHEQ,"
		cQuery+="E5_DOCUMEN,E5_SECNUM,E5_TIPODOC,E5_SITUACA "
		cQuery+="FROM "+RetSqlName("SE5")+" "+(cAliasSE5)+" "
		cQuery+="WHERE E5_FILIAL='"+xfilial("SE5")+"' AND D_E_L_E_T_<>'*' "
		cQuery+="AND E5_TIPODOC <> 'TR' "
		IF MV_PAR07 == 1	// Ingreso.
			cQuery+=" AND E5_RECPAG = 'R' "
//			cQuery+=" AND E5_TIPODOC <> 'TR' "
		ELSEIF MV_PAR07 == 2	// Egreso.
			cQuery+=" AND E5_RECPAG = 'P' "
//			cQuery+=" AND E5_TIPODOC <> 'TR' "
		ELSEIF MV_PAR07 == 3	// Reversion.
			cQuery+=" AND E5_HISTOR = 'REVERSION' "
//			cQuery+=" AND E5_TIPODOC <> 'TR' "
		ELSE
			cQuery+=" AND (E5_RECPAG = 'R' "
			cQuery+=" OR E5_RECPAG = 'P' "
			cQuery+=" OR E5_HISTOR = 'REVERSION') "
		EndIF
		cQuery+=" AND (E5_DATA >= '"	+DTOS(MV_PAR01)+"' AND E5_DATA <='"+DTOS(MV_PAR02)+"') "
		cQuery+=" AND (E5_BANCO >=  '"	+MV_PAR03+"' AND E5_BANCO <='"+MV_PAR04+"') "
		cQuery+=" AND (E5_SECNUM >= '"	+MV_PAR05+"' AND E5_SECNUM <='"+MV_PAR06+"') "
	
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasSE5),.F.,.T.)
		cuenta:=0
		DbSelectArea((cAliasSE5))
		(cAliasSE5)->(dbgotop())

		While (cAliasSE5)->(!Eof())
			AADD(aVar,{(cAliasSE5)->E5_DATA,; // 1
			(cAliasSE5)->E5_BANCO,;		// 2
			(cAliasSE5)->E5_AGENCIA,;	// 3
			(cAliasSE5)->E5_CONTA,;		// 4
			(cAliasSE5)->E5_NATUREZ,;	// 5
			(cAliasSE5)->E5_MOEDA,;		// 6
			(cAliasSE5)->E5_VALOR,;		// 7
			(cAliasSE5)->E5_NUMCHEQ,;	// 8
			(cAliasSE5)->E5_DOCUMEN,;	// 9
			(cAliasSE5)->E5_BENEF,;		// 10
			(cAliasSE5)->E5_SECNUM,;	// 11
			(cAliasSE5)->E5_HISTOR,;	// 12
			(cAliasSE5)->E5_RECPAG,;	// 13
			(cAliasSE5)->E5_TIPODOC,;	// 14
			(cAliasSE5)->E5_SITUACA})	// 15
			cuenta++			    
		    DbSkip()
		EndDo

		IF cuenta > 0
			entra:=.T.
		ELSE
			entra:=.f.
			msgalert("No hay datos para mostrar...")
		EndIF
	ELSE
		entra:=.f.
	EndIF
	EndIF
	IF entra
		If MsgYesNo("Seleccionados "+Str(cuenta)+" comprobantes"+CHR(13)+"Confirma la impresi๓n ?","Comprobante Movimiento bancacrio")
			wnrel := SetPrint(cString,wnrel,,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,tamanho,"",.T.)
			If nLastKey <> 27
				SetDefault(aReturn,cString)
				If nLastKey <> 27
					RptStatus({|| ImpComp()},Titulo)
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
	Local cTipMov := ""

	For i := 1 To Len(aVar)
		SA6->(DbSetOrder(1))
		SA6->(DbSeek(xFilial("SA6")+aVar[i][2]+aVar[i][3]+aVar[i][4]))
		nMoedaCx:=Max(SA6->A6_MOEDA,1)
		cAux:="MV_SIMB"+Alltrim(Str(nMoedaCx))
	
//		Cabec(Titulo,"","",NomeProg,Tamanho)

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

		nLine := nLine +7
		cTipMov := ""
	
		If Funname()=="FINA100"
			cTipMov := "Anulaci๓n"
		Else
			IF MV_PAR07 == 1	// Ingreso.
				cTipMov := "Ingreso"
			ELSEIF MV_PAR07 == 2// Egreso.
				cTipMov := "Egreso"
			ELSEIF MV_PAR07 == 3// Reversion.
				cTipMov := "Anulaci๓n" // "Reversion"
			ELSE
				IF aVar[i][12]=='REVERSION' .OR. aVar[i][15]=="E"
					cTipMov := "Anulaci๓n" // "Reversi๓n"
				ENDIF
				IF aVar[i][13] == "R" .AND. aVar[i][12] != "REVERSION"
					cTipMov := "Ingreso"
				ENDIF
				IF aVar[i][13] == "P" .AND. aVar[i][12] != "REVERSION"
					cTipMov := "Egreso"
				ENDIF
			EndIF		
		EndIF
			
		@nLine,017 Psay "Tipo de Movimiento : " + cTipMov
		nLine := nLine +5
	
		cFecMov := aVar[i][1]
		cFechMov := STOD(cFecMov)
		@nLine,017 Psay "Fec. Mov. : " + cValToChar(cFechMov)
		nLine++	
		@nLine,017 Psay "De Banco  : " + aVar[i][2] + " - "+ Alltrim(SA6->A6_NREDUZ)
		nLine++
		@nLine,017 Psay "Agencia   : " + aVar[i][3]
		nLine++
		@nLine,017 Psay "Cuenta    : " + aVar[i][4]
		nLine++
		@nLine,017 Psay "Naturaleza: " + Posicione("SED",1,xfilial("SED")+ aVar[i][5],"ED_DESCRIC")
		nLine++
		@nLine,017 Psay "Cheque    : " + aVar[i][8]
		nLine++
		nLine++
		@nLine,017 Psay "Valor     : " + Alltrim(SuperGetMV(cAux,,"")) + TransForm(aVar[i][7],"@E 9,999,999.99" )
		nLine++
		@nLine,017 Psay "Documento : " + aVar[i][9]
		nLine++
		@nLine,017 Psay "Benefic.  : " + aVar[i][10]
		nLine++
		@nLine,017 Psay "Historial : " + aVar[i][12]
		nLine++
		@nLine,017 Psay "Numeraci๓n: " + aVar[i][11]
		nLine := nLine +20
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
	Next
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

	Aadd(aRegs,{cPerg,'07',"Tipo de Movimiento","Tipo de Movimiento","Tipo de Movimiento","mv_ch7","C",01,0,0,"C","","MV_PAR07",;
	"Ingreso","Ingreso","Ingreso","","","Egreso","Egreso","Egreso","","",;
	"Reversion","Reversion","Reversion","", "","Todos", "Todos", "Todos","", "","","" } )

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