
/*���������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A100TRA   �Autor  �Lovos Andres        �Fecha � 10/02/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     � Realiza la primera accion para la transferencia entre      ���
���          � bancos                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������*/

User Function A100TRA
	Private cSecNumP	// Secuencia de Numero Primero
	Private cSecNumS	// Secuencia de Numero Segundo

	Public cSecNmV := ""	// Secuencia de Numero Vigente

	cSecNumP := BuSecN()

	If FunName()<>'U_A100TRA' .AND. FunName()<>'A100TRA'
		cSecNumS := BuSecN()
		IF cSecNumP == cSecNumS
			IF cSecNmV != cSecNumP
				RecLock("SE5",.F.)
				cSecNmV := strzero(val(cSecNumP)+1,12)
				SE5->E5_SECNUM := cSecNmV
				SE5->E5_DOCUMEN := cSecNmV
				SE5->(MsUnLock())
			ELSE
				RecLock("SE5",.F.)
				cSecNmV := strzero(val(cSecNumP)+2,12)
				SE5->E5_SECNUM := cSecNmV
				SE5->E5_DOCUMEN := cSecNmV
				SE5->(MsUnLock())
			EndIF
		ELSE
			RecLock("SE5",.F.)
			cSecNmV := strzero(val(cSecNumS)+1,12)
			SE5->E5_SECNUM := cSecNmV
			SE5->E5_DOCUMEN := cSecNmV
			SE5->(MsUnLock())
		EndIF
	EndIF
Return cSecNmV

/*���������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BuSecN    �Autor  �Lovos Andres        �Fecha � 10/02/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     � Realiza la busqueda del ultimo numero del campo E5_SECNUM  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������*/

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