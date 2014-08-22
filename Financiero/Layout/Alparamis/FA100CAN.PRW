
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA100CAN  บAutor  ณLovos Andres        บFecha ณ 10/02/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza la anulacion de una transferencia                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function FA100CAN()

	Private cSecNumV := 0	// Secuencia de Numero Vigente
	Private cSecNumP := 0	// Secuencia de Numero Primero
	Private cSecNumS := 0	// Secuencia de Numero Segundo

	cSecNumP := BuSecN()

	If FunName()<>'U_FA100CAN' .AND. FunName()<>'FA100CAN'
		cSecNumS := BuSecN()

		// Comparo el primer valor del campo "cSecNump" con el valor del segundo campo "cSecNumS"
		// Si los campos son los mismos grabo el primero, si los campos son distintos grabo el segundo
		// Que seria el ultimo que cambio.
		// Esto hace que si hay mas de un usuario realizando el Pago, tengan distintos numeros de secuencia.
		IF cSecNumP == cSecNumS
			RecLock("SE5",.F.)
			cSecNumV := strzero(val(cSecNumP)+1,12)
			SE5->E5_SECNUM := cSecNumV
			SE5->E5_HISTOR := "ANULACIำN"
			SE5->(MsUnLock()) // Confirma y finaliza la operacion
		ELSE
			RecLock("SE5",.F.)
			cSecNumV := strzero(val(cSecNumS)+1,12)
			SE5->E5_SECNUM := cSecNumV
			SE5->E5_HISTOR := "ANULACIำN"
			SE5->(MsUnLock()) // Confirma y finaliza la operacion
		EndIF
		MsgInfo("La Reversi๓n Se Grab๓ Con El N๚mero : " + cSecNumV )
		u_ALRFI001()
	EndIF

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBuSecN    บAutor  ณLovos Andres        บFecha ณ 10/02/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอทออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza la busqueda del ultimo numero del campo E5_SECNUM  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function BuSecN()
	Local cSecNum := ""		// Secuencia de Numero

	cAliasSE5:="SE5_TMP"
	If Select((cAliasSE5))<>0
		DbSelectArea((cAliasSE5))
		DbCloseArea()
	Endif

	cQuery:="SELECT MAX(E5_SECNUM) Maximo "
	cQuery+="FROM "+ RetSqlName("SE5") + " SE5 "
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., 'TOPCONN', TCGenQry(,,cQuery),(cAliasSE5),.F.,.T.)
	
	dbSelectArea((cAliasSE5))
	dbGoTop()

	cSecNum 	:= (cAliasSE5)->Maximo
	
Return cSecNum