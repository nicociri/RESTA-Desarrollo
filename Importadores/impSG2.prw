#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "FileIO.ch"


// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������             
// �������������������������������������������������������������������������ͻ��
// ���Programa  � IMPSG2   � Autor � Ariel Gel          � Data �  05/10/2012 ���
// �������������������������������������������������������������������������͹��
// ���Descricao � Programa de importacao de la tabla de recursos             ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � 			                                             ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

User Function IMPSG2()

Local oDlg


//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Lectura de archivo .CSV")
@ 02,10 TO 080,190 Title OemToAnsi("")
@ 10,018 Say " Este programa leer� el contenido de un archivo .csv, conforme"
@ 18,018 Say " los par�metros definidos por el usuario y va a grabar el contenido "
@ 26,018 Say " en la tabla SG2. "

@ 60,128 BMPBUTTON TYPE 01 ACTION {Valida("SG2"),Close(oDlg)}
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
// ���Programa  � Importar � Autor � Ivaldo Junior      � Data �  27/02/09   ���
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
	Processa({|| GrabaSG2(aCabec,aImport,cTabla)})
Endif

Return

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � GrabaSG2 � Autor � Ivaldo Junior      � Data �  27/02/09   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     �Executa a importa��o dos registros.                         ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function GrabaSG2(aCabec,aImport,cTabla)

Local nX 		:= 0
Local nCpo      := 0
Local nCantErr  := 0
Local nPosProd  := 0
Local lsalir    := .F.
Local cDirLog   := "\log\"
Local cSubdir   := "hojaRuta\"
Local lError    := .F.
Local cCod      := "01"
Local cOper     := ""
Local cProdAnt  := ""
Local cCodProd  := ""

Private aVector  := {}


// If MsgNoYes("�Desea borrar la tabla "+cTabla+"?","Atenci�n")
	// dbSelectArea(cTabla)
	// (cTabla)->(__dbZap())
// Endif

ProcRegua(Len(aImport))

For nX:=1 To Len(aImport)
	IncProc("Importaci�n: Insertando registro "+AllTrim( Str(nX) )+" de "+AllTrim( Str(Len(aImport)) ))
	
	aVector  := {}
	
	nPosProd := aScan(aCabec,{|x| allTrim(x) == "G2_PRODUTO" })
	
	cCodProd  := aImport[nX][nPosProd]
	
	If Empty(cProdAnt) .OR. cProdAnt<>cCodProd
		cOper := "01"
	Endif
	
	If !existeReg(aCabec,aImport,nX,cTabla)
		
		For nCpo := 1 To Len(aCabec)
			If !Empty(aCabec[nCpo]) 
				If "_FILIAL" $ Alltrim(aCabec[nCpo])
					aImport[nX][nCpo] := xFilial(cTabla)
				elseif Alltrim(aCabec[nCpo]) == "G2_CODIGO"
					aImport[nX][nCpo] := cCod
				elseif Alltrim(aCabec[nCpo]) == "G2_OPERAC"
					aImport[nX][nCpo] := cOper
				elseif Alltrim(aCabec[nCpo]) == "G2_RECURSO"
					lError := buRecurso(aImport[nX][nCpo])
					
					If lError
						AutoGRLog("Error: No se encontr� el recurso "+allTrim(aImport[nX][nCpo])+;
										 " para el producto "+cCodProd)
						AutoGRLog("")
						AutoGRLog("Ver la l�nea "+AllTrim( Str(nX+1) ))
						
						exit
					Endif
				elseif Alltrim(aCabec[nCpo]) == "G2_PRODUTO"
					lError := buProd(aImport[nX][nCpo])
					
					If lError
						AutoGRLog("Error: No se encontr� el productro "+allTrim(aImport[nX][nCpo]))
						AutoGRLog("")
						AutoGRLog("Ver la l�nea "+AllTrim( Str(nX+1) ))
						
						exit
					Endif
				Endif
				
				Aadd(aVector,{Alltrim(aCabec[nCpo]),valorCpo(aCabec[nCpo],aImport[nX][nCpo]),Nil})
			Endif
		Next nCpo

		cOper := soma1(cOper)
		cProdAnt := cCodProd
		
		If !lError
			If RecLock(cTabla,.T.) 
				For nCpo := 1 To Len(aVector)
					Replace  &(aVector[nCpo][1])  with aVector[nCpo][2]
				Next nCpo
				MsUnlock()
			EndIf
		Else
			If !ExistDir(cDirLog)		
				MakeDir(cDirLog)
			EndIf
			If !ExistDir(cDirLog+cSubdir)		
				MakeDir(cDirLog+cSubdir)
			EndIf
			MOSTRAERRO(cDirLog+cSubdir)
			lError := .F.
			nCantErr += 1
		Endif

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
Local cClave   := ""


dbSelectArea(cTabla) // SG2
dbSetOrder(1) // G2_FILIAL+G2_PRODUTO+G2_CODIGO+G2_OPERAC

nPosCpo1 := aScan(aCabec,{|x| allTrim(x) == "G2_PRODUTO" })
nPosCpo2 := aScan(aCabec,{|x| allTrim(x) == "G2_CODIGO" })
nPosCpo3 := aScan(aCabec,{|x| allTrim(x) == "G2_OPERAC" })
cClave   := PadR(aImport[nX][nPosCpo1],TamSX3("H1_CODIGO")[1])+PadR(aImport[nX][nPosCpo2],TamSX3("G2_CODIGO")[1])+;
            PadR(aImport[nX][nPosCpo3],TamSX3("G2_OPERAC")[1])

lRet := DbSeek( xFilial(cTabla)+ cClave)

RestArea(aAreaTab)
RestArea(aArea)

Return lRet

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � buProd   � Autor � Ariel Gel          � Data �  12/10/12   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     � Valida la existencia de producto en SB1                    ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function buProd(cCod)

Local aArea    := GetArea()
Local aAreaSB1 := SB1->(GetArea())
Local lError   := .T.

If !Empty(cCod)
	dbSetOrder(1) // H1_FILIAL+H1_CODIGO
	SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD
	If SB1->(DbSeek( xFilial( "SB1" ) + PadR(cCod,TamSX3("B1_COD")[1])))
		lError := .F.
	Endif
Endif

RestArea(aAreaSB1)
RestArea(aArea)

Return lError

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � buRecurso� Autor � Ariel Gel          � Data �  12/10/12   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     � Valida la existencia de recursos SH1                       ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function buRecurso(cCod)

Local aArea    := GetArea()
Local aAreaSH1 := SH1->(GetArea())
Local lError   := .T.

If !Empty(cCod)
	SH1->(dbSetOrder(1)) // H1_FILIAL+H1_CODIGO
	If SH1->(DbSeek( xFilial("SH1") + PadR(cCod,TamSX3("H1_CODIGO")[1])))
		lError := .F.
	Endif
Endif

RestArea(aAreaSH1)
RestArea(aArea)

Return lError