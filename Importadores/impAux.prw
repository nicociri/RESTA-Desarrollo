#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "FileIO.ch"


// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������             
// �������������������������������������������������������������������������ͻ��
// ���Programa  � IMPAUX   � Autor � Ariel Gel          � Data �  07/08/2012 ���
// �������������������������������������������������������������������������͹��
// ���Descricao � Programa de importacao de tablas auxiliares                ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � 			                                             ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

User Function IMPAUX(cTabla, nOpcion)

Local oDlg

Private nOpc := nOpcion

Default nOpcion := 1
//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Lectura de archivo .CSV")
@ 02,10 TO 080,190 Title OemToAnsi("")
@ 10,018 Say " Este programa leer� el contenido de un archivo .csv, conforme"
@ 18,018 Say " los par�metros definidos por el usuario y va a grabar el contenido "
@ 26,018 Say " en la tabla seleccionada. "

@ 60,128 BMPBUTTON TYPE 01 ACTION {Valida(cTabla),Close(oDlg)}
@ 60,158 BMPBUTTON TYPE 02 ACTION Close(oDlg)

Activate Dialog oDlg Centered


Return

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � Valida   � Autor � Ivaldo Junior      � Data �  27/02/09   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     �Executa a importa��o dos registros.                         ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
Static Function Valida(cTabla)

Private _cNomArq := ""
Private cTipo  := "Archivos del tipo (*.CSV)   | *.CSV     "

_cNomArq := cGetFile(cTipo,"Archivo a ser importado")

If !Empty(_cNomArq)
	Processa({|| Importar(cTabla)})
Else
	MsgStop("�Operaci�n cancelada!")
EndIf


Return


// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � Importat � Autor � Ivaldo Junior      � Data �  27/02/09   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     �Ejecuta la importaci�n del archivo                          ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
Static Function Importar(cTabla)

Local nTotLin := 0
Local nCount  := 0
Local nX      := 0
Local aDados  := {}
Local aCabec  := {}
Local aImport := {}
Local cLine   := ""
Local cSep    := ";" 
Local lError  := .F.

// Abro el archivo
oArch:=TA_ARCHXLINEAS():new(_cNomArq)

If oArch:nFileHandler == -1
	MsgAlert("No se pudo abrir el archivo ","Atenci�n!")
	Return .F.
Endif

nTotLin := oArch:nTotLineFile

While !oArch:finArchivo( ) .And. !lError

	nCount++

	If !oArch:leerLinea(@cLine) 
	   MsgInfo("Error leyendo las lineas del archivo", "Error") 
	   Return .F.
	EndIf 

	cLine:=AllTrim(cLine) // Quito espacios inicio y fin
	cLine:=OEMToANSI(cLine) // Convierto a ANSI 
	
	If nCount == 1 // cabecera con los campos a ser migrados
		aCabec := FA_StrSplit(cLine,cSep) // Convierto a Array. Separo por "|"
	Else
		aDados := FA_StrSplit(cLine,cSep) // Convierto a Array. Separo por "|"
		If Len(aCabec) <> Len(aDados)
			If Len(aCabec) > Len(aDados)
				MsgAlert('Existen m�s campos definidos que datos. Ver l�nea: '+AllTrim(str(nCount)),'Atenci�n')
			Else
				MsgAlert('Existen m�s datos que campos definidos. Ver l�nea: '+AllTrim(str(nCount)),,'Atenci�n')
			Endif
			lError := .T.
		Else
			AAdd(aImport,aClone(aDados))
		Endif
	Endif

EndDo

FClose( oArch:nFileHandler )

If !lError
	Processa({|| GrabaAux(aCabec,aImport,cTabla)})
Endif

Return

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � GrabaZM1 � Autor � Ivaldo Junior      � Data �  27/02/09   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     �Executa a importa��o dos registros.                         ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function GrabaAux(aCabec,aImport,cTabla)

Local nX 		:= 0
Local nCpo      := 0
Local nCantErr  := 0
Local lsalir    := .F.

Private aVector       	:= {}

// If MsgNoYes("�Desea borrar la tabla "+cTabla+"?","Atenci�n")
	// dbSelectArea(cTabla)
	// (cTabla)->(__dbZap())
// Endif

ProcRegua(Len(aImport))


For nX:=1 To Len(aImport)
	IncProc("Importaci�n: Insertando registro "+AllTrim( Str(nX) )+" de "+AllTrim( Str(Len(aImport)) ))
	
	aVector  := {}
	
	If !existeReg(aCabec,aImport,nX,cTabla)
		
		For nCpo := 1 To Len(aCabec)
			If !Empty(aCabec[nCpo]) 
				If "_FILIAL" $ Alltrim(aCabec[nCpo])
					aImport[nX][nCpo] := xFilial(cTabla)
				Endif
				
				Aadd(aVector,{Alltrim(aCabec[nCpo]),valorCpo(aCabec[nCpo],aImport[nX][nCpo]),Nil})
			Endif
		Next nCpo
		       
		
		If RecLock(cTabla,.T.) 
	 		For nCpo := 1 To Len(aVector)
			 	Replace  &(aVector[nCpo][1])  with aVector[nCpo][2]
			Next nCpo
			MsUnlock()
		EndIf
				 				
	EndIf	
	
	If lsalir
		Exit
	Endif
Next

If nCantErr > 0
	MsgAlert("Fin del Proceso. Registros con errores: "+str(nCantErr),'Atenci�n')
Else
	MsgAlert('Proceso finalizado con �xito','Atenci�n')
Endif

//End Transaction

Return

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � esVisual � Autor � Ariel Gel          � Data �  12/06/12   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     � Retorna si el campo es Visual                              ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function esVisual(cCampo)
	
Local aArea    := GetArea()
Local aAreaSX3 := SX3->(GetArea())
Local lRet     := .F.

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek(allTrim(cCampo)) .And. X3_CONTEXT == "V"
	lRet := .T.
EndIf

RestArea(aAreaSX3)
RestArea(aArea)

Return lRet

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � valorCpo � Autor � Ariel Gel          � Data �  27/02/09   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     � Retorna el valor formateado segun el tipo de dato del cpo  ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function valorCpo(cCampo,cValor)	

Local aArea    := GetArea()
Local aAreaSX3 := SX3->(GetArea())
Local xValor

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek(allTrim(cCampo))
	If X3_TIPO $ "C/M"
		xValor := cValor
	Elseif X3_TIPO == "N"
		xValor := Val(cValor)
	Elseif X3_TIPO == "D"
		xValor := CtoD(cValor)
	Endif
EndIf

RestArea(aAreaSX3)
RestArea(aArea)

Return xValor

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Libreria  |ArchXLinea� Autor � NAHUEL ESPINDOLA   �Fecha �  22/06/09   ���
// �������������������������������������������������������������������������͹��
// ���Descripcio� Funciones para recorrer archivos de texto linea por        ���
// ���          � Linea, sin la limitac de la cant de carac de los de TOTVS  ���
// �������������������������������������������������������������������������͹��
// ���Uso       �                                                            ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������


//
// Funcion que dado un string y un token (que puede ser de varios str)
// Devuelve un array con ese string separado por el token.
// similar a StrTokArr pero el token admite que sea de muchos caracteres
//
Static Function FA_StrSplit(cStr,cToken)

Local aStr    :={}
Local nStrLen := Len(cStr)  
Local nTokLen := Len(cToken)
Local nPos    :=1
Local nPosAnt :=1
Local nCantPos :=0
Local cAux := ""

nPos := AT(cToken,cStr)

While nPos <> 0

	cAux := ""         

	nCantPos := nPos - nPosAnt
	
	If nCantPos > 0
		cAux := SubStr(cStr,nPosAnt, nCantPos)
	EndIf
	               
	aAdd(aStr, cAux)
                                   
	nPosAnt := nPos + nTokLen
	nPos := AT(cToken,cStr,nPos + 1)
End

aAdd(aStr, SubStr(cStr, nPosAnt, nStrLen - nPosAnt + 1))

Return aStr

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  �existeReg � Autor � Ariel Gel          � Data �  07/08/12   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     � Retorna el valor formateado segun el tipo de dato del cpo  ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function existeReg(aCabec,aImport,nX,cTabla)	

Local aArea    := GetArea()
Local aAreaTab := (cTabla)->(GetArea())
Local lRet     := .F.
Local nPosCpo1 := ""
Local nPosCpo2 := ""
Local nPosCpo3 := ""
Local nPosCpo4 := ""
Local cClave   := ""


dbSelectArea(cTabla)
If cTabla == "SFH"
	If nOpc == 1 // EJECUTADO DESDE PROVEEDORES
		dbSetOrder(1) // FH_FILIAL+FH_FORNECE+FH_LOJA+FH_IMPOSTO+FH_ZONFIS
		nPosCpo1 := aScan( aCabec,{|x| allTrim(x) == "FH_FORNECE" })
		nPosCpo2 := aScan( aCabec,{|x| allTrim(x) == "FH_LOJA" })
		nPosCpo3 := aScan( aCabec,{|x| allTrim(x) == "FH_IMPOSTO" })
		nPosCpo4 := aScan( aCabec,{|x| allTrim(x) == "FH_ZONFIS" })
	Else // EJECUTADO DESDE CLIENTES
		dbSetOrder(3) // FH_FILIAL+FH_CLIENTE+FH_LOJA+FH_IMPOSTO+FH_ZONFIS
		nPosCpo1 := aScan( aCabec,{|x| allTrim(x) == "FH_CLIENTE" })
		nPosCpo2 := aScan( aCabec,{|x| allTrim(x) == "FH_LOJA" })
		nPosCpo3 := aScan( aCabec,{|x| allTrim(x) == "FH_IMPOSTO" })
		nPosCpo4 := aScan( aCabec,{|x| allTrim(x) == "FH_ZONFIS" })	
	Endif
	
	cClave   := aImport[nX][nPosCpo1]+aImport[nX][nPosCpo2]+aImport[nX][nPosCpo3]+aImport[nX][nPosCpo4]
		
Endif

lRet := DbSeek( xFilial(cTabla)+ cClave)

RestArea(aAreaTab)
RestArea(aArea)

Return lRet