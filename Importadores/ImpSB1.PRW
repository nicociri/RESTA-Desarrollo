#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "FileIO.ch"


// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  �IMPPROD   � Autor � Ivaldo Junior    	 � Data �             ���
// �������������������������������������������������������������������������͹��
// ���Descricao � Programa de importacao do Produto Terminados               ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � PcArts                                                     ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

User Function IMPSB1()

Local oDlg

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Lectura de archivo .CSV")
@ 02,10 TO 080,190 Title OemToAnsi("")
@ 10,018 Say " Este programa leer� el contenido de un archivo .csv, conforme"
@ 18,018 Say " los par�metros definidos por el usuario y va a grabar el contenido "
@ 26,018 Say " en la tabla SB1 (Productos). 								"

@ 60,128 BMPBUTTON TYPE 01 ACTION {Valida(),Close(oDlg)}
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
Static Function Valida()

Private _cNomArq := ""
Private cTipo  := "Archivos del tipo (*.CSV)   | *.CSV     "

_cNomArq := cGetFile(cTipo,"Archivo a ser importado")

If !Empty(_cNomArq)
	Processa({|| Importar()})
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
Static Function Importar()

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

//ProcRegua(oArch:nTotLineFile)

While !oArch:finArchivo( ) .And. !lError

	nCount++
	//IncProc("Importaci�n: Leyendo linea "+AllTrim( Str(nCount) )+" de "+AllTrim( Str(nTotLin) ))

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
	Processa({|| GrabaSB1(aCabec,aImport)})
Endif

Return

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � GrabaSB1 � Autor � Ivaldo Junior      � Data �  27/02/09   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     �Executa a importa��o dos registros.                         ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function GrabaSB1(aCabec,aImport)

Local nX 		:= 0
Local nCpo      := 0
Local nPosCod   := 0
Local nCantErr  := 0
Local nEmax     := 0
Local nVal      := 0
Local cCod      := ""
Local lsalir    := .F.
Local aNoCpos   := {"B1_FILIAL"}
Local cDirLog   := "\log\"
Local cSubdir   := "productos\"

Private lMsErroAuto 	:= .F.
Private aVector       	:= {}

ProcRegua(Len(aImport))

nPosCod := aScan( aCabec,{|x| allTrim(x) == "B1_COD" })

For nX:=1 To Len(aImport)
	IncProc("Importaci�n: Insertando registro "+AllTrim( Str(nX) )+" de "+AllTrim( Str(Len(aImport)) ))
	
	aVector  := {}
	DbSelectArea("SB1")
	DbSetOrder(1)
	
	If nPosCod > 0 .And. !DbSeek( xFilial("SB1")+ PadR(aImport[nX][nPosCod],TamSX3("B1_COD")[1]))
	
		For nCpo := 1 To Len(aCabec)
			If !Empty(aCabec[nCpo]) .And. aScan( aNoCpos,{|x| x == Alltrim(aCabec[nCpo]) }) == 0 .And.; 
			    u_esUsado(aCabec[nCpo])
				If Alltrim(aCabec[nCpo]) == "B1_TIPCONV" 
					If Empty(aImport[nX][nCpo])
						aImport[nX][nCpo] := "M"
					Endif
				ElseIf Alltrim(aCabec[nCpo]) == "B1_COD" 
					aImport[nX][nCpo] := PadR(aImport[nX][nCpo],TamSX3("B1_COD")[1])
				ElseIf Alltrim(aCabec[nCpo]) == "B1_DESC" 
					aImport[nX][nCpo] := LTrim(aImport[nX][nCpo])
				ElseIf Alltrim(aCabec[nCpo]) == "B1_PROC" 
					aImport[nX][nCpo] := ""
				ElseIf Alltrim(aCabec[nCpo]) == "B1_GRUPO"
					aImport[nX][nCpo] := bu_grupo(aImport[nX][nCpo]) 
				ElseIf Alltrim(aCabec[nCpo]) $ "B1_CONTA|B1_CONTA1"
					aImport[nX][nCpo] := u_buConta(aImport[nX][nCpo]) 
				ElseIf Alltrim(aCabec[nCpo]) == "B1_EMAX"
					nEmax := val(aImport[nX][nCpo])
					If (nEmax / 1000000000) >= 1
						aImport[nX][nCpo] := "999999999.99"
					Endif
				ElseIf Alltrim(aCabec[nCpo]) $ "B1_EMIN|B1_ESTSEG" .And. !Empty(aImport[nX][nCpo])
					nVal := val(aImport[nX][nCpo])
					If nVal == 1
						aImport[nX][nCpo] := "          0.00"
					Endif
				ElseIf Alltrim(aCabec[nCpo]) == "B1_QE" .And. !Empty(aImport[nX][nCpo])
					nVal := val(aImport[nX][nCpo])
					If nVal == 1
						aImport[nX][nCpo] := "          0"
					Endif
				ENDIF
				
				Aadd(aVector,{Alltrim(aCabec[nCpo]),valorCpo(aCabec[nCpo],aImport[nX][nCpo]),Nil})
			Endif
		Next nCpo
	
		MSExecAuto({|x,y| mata010(x,y)},aVector,3) 
		If lMsErroAuto
			ProcLogAtu("ERROR",'Atenci�n',"Error en la importaci�n de Productos")
			If !ExistDir(cDirLog)		
				MakeDir(cDirLog)
			EndIf

			If !ExistDir(cDirLog+cSubdir)		
				MakeDir(cDirLog+cSubdir)
			EndIf
			MOSTRAERRO(cDirLog+cSubdir)
			lMsErroAuto := .F.
			DisarmTransaction()
			nCantErr += 1
		EndIf
	EndIf
	
	If lsalir
		Exit
	Endif
	
Next nX

If nCantErr > 0
	MsgAlert("Fin del Proceso. Registros con errores: "+str(nCantErr),'Atenci�n')
Else
	MsgAlert('Proceso finalizado con �xito','Atenci�n')
Endif

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
// ���Programa  �IMPPROD   � Autor � Ivaldo Junior    	 � Data �             ���
// �������������������������������������������������������������������������͹��
// ���Descricao � Rotina de geracao automatica do codigo do produto          ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � PcArts                                                     ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

User Function GERACOD()

Local _aAreaSB1 := GetArea("SB1")

SetPrvt("_ATUAL,_AREA,_ORDEM,_REC,")

_AREA  := Alias()
_ORDEM := IndexOrd()
_Rec   := Recno()

DBSELECTAREA("SB1")
DBSETORDER(1)

_cCOD:= ALLTRIM(_cTipo)+ALLTRIM(_cGrupo)

If dbSeek(xFilial("SB1")+_cCod,.f.)
	DBSEEK(XFILIAL()+_cCOD+"999999",.t.)
	DBSKIP(-1)
	_cATUAL:=_cCOD+STRZERO(VAL(SUBSTR(SB1->B1_COD,10,5))+1,6)
ELSE
	_cATUAL:=_cCOD+"000001"
ENDIF

DBSELECTAREA(_AREA)
DBSETORDER(_ORDEM)
DbGoto(_Rec)

RestArea(_aAreaSB1)

RETURN(_cATUAL)

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � bu_grupo � Autor � Ariel Gel          � Data �  18/06/11   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     � Para el codigo SIM retorna el codigo del Protheus          ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function bu_grupo(cGruSim)

Local aArea    := GetArea()
Local aAreaSBM := SBM->(GetArea())
Local cGruPro := ""

cGruSim := StrTran(cGruSim,"-","/")

SBM->(dbSetOrder(3))
If SBM->(DbSeek( xFilial( "SBM" ) + PadR(cGruSim,TamSX3("BM_GRUPOS")[1])))
	cGruPro := SBM->BM_GRUPO
Endif

RestArea(aAreaSBM)
RestArea(aArea)

Return cGruPro

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � esUsado  � Autor � Ariel Gel          � Data �  12/06/12   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     � Retorna si el campo es usado                               ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

User Function esUsado(cCampo)
	
Local aArea    := GetArea()
Local aAreaSX3 := SX3->(GetArea())
Local lRet     := .F.

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek(allTrim(cCampo)) .And. X3Uso( SX3->X3_USADO ) 
	lRet := .T.
EndIf

RestArea(aAreaSX3)
RestArea(aArea)

Return lRet