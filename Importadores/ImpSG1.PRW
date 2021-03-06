#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "FileIO.ch"


// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������             
// �������������������������������������������������������������������������ͻ��
// ���Programa  �IMPSG1    � Autor � 				 � Data �             ���
// �������������������������������������������������������������������������͹��
// ���Descricao � Programa de importacao de Cuentas por cobrar               ���
// ���          �								                           ���
// �������������������������������������������������������������������������͹��
// ���Uso       � 			                                             ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

User Function IMPSG1()

Local oDlg
Local aArray := {}
Local nTotDup := 0

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Lectura de archivo .CSV")
@ 02,10 TO 080,190 Title OemToAnsi("")
@ 10,018 Say " Este programa leer� el contenido de un archivo .csv, conforme"
@ 18,018 Say " los par�metros definidos por el usuario y va a grabar el contenido "
@ 26,018 Say " en la tabla SG1(Estructuras). 						"

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
	Processa({|| GrabaSG1(aCabec,aImport)})
Endif

Return

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � GrabaSG1 � Autor � Ivaldo Junior      � Data �  27/02/09   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     �Executa a importa��o dos registros.                         ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function GrabaSG1(aCabec,aImport)

Local nX 		:= 0
Local nCpo      := 0
Local cCod      := ""
Local nPosCod   := 0
Local nPosLoj   := 0
Local nCantErr  := 0
Local lsalir    := .F.
Local aCposCab  :={	"G1_COD",;	
                    "G1_QUANT"}
Local aCposItm  :={	"G1_COD",;	
                    "G1_COMP",;	
                    "G1_TRT",;	
                    "G1_QUANT",;	
                    "G1_PERDA",;	
                    "G1_INI",;	
                    "G1_FIM"}
					
Local aGets     := {}
Local cDirLog   := "\log\"
Local cSubdir   := "estructura\"
Local nPosCod   := 0
Local nPosCom   := 0
Local nPosTrt   := 0
Local cCodAnt   := ""
Local lCabec    := .F.
Local lInsert   := .T.
	  
Private lMsErroAuto 	:= .F.
Private aVector       	:= {}
Private aCab            := {}
Private aItem           := {}

ProcRegua(Len(aImport))

nPosCod := aScan( aCabec,{|x| allTrim(x) == "G1_COD" })
nPosCom := aScan( aCabec,{|x| allTrim(x) == "G1_COMP" })
nPosTrt := aScan( aCabec,{|x| allTrim(x) == "G1_TRT" })

If nPosCod+nPosCom+nPosTrt == 0
	MsgAlert('No se localizaron los campos del �ndice de SG1','Atenci�n')
	Return
Endif

For nX:=1 To Len(aImport)
	IncProc("Importaci�n: Insertando registro "+AllTrim( Str(nX) )+" de "+AllTrim( Str(Len(aImport)) ))
	
	DbSelectArea("SG1")
	DbSetOrder(1) //G1_FILIAL+G1_COD+G1_COMP+G1_TRT
	
	If !DbSeek( xFilial("SG1")+aImport[nX][nPosCod]+aImport[nX][nPosCom]+aImport[nX][nPosTrt])
	
		If !Empty(cCodAnt) .And. cCodAnt <> aImport[nX][nPosCod] 
			If !Empty(aCab) .And. !Empty(aItem)
				MSExecAuto({|x,y,z| mata200(x,y,z)},aCab,aItem,3) //Inclusao
								
				If lMsErroAuto
					ProcLogAtu("ERRO",'Atenci�n',"Error en la importaci�n de Estructuras")
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
			lCabec := .F.
			aCab   := {}
			aItem  := {}
			// nTrt   := 1
		Endif
		
		If lsalir
			Exit
		Endif
		
		aGets := {}
		lInsert := .T.
		For nCpo := 1 To Len(aCabec)
			If !Empty(aCabec[nCpo]) .And. u_esUsado(aCabec[nCpo])
			
				If !lCabec .And. aScan( aCposCab,{|x| x == Alltrim(aCabec[nCpo]) }) > 0  
					Aadd(aCab,{Alltrim(aCabec[nCpo]),valorCpo(aCabec[nCpo],aImport[nX][nCpo]),Nil})
				Endif
				If aScan( aCposItm,{|x| x == Alltrim(aCabec[nCpo]) }) > 0
					If Alltrim(aCabec[nCpo]) == "G1_FIM"
						If Empty(aImport[nX][nCpo])
							aImport[nX][nCpo] := "31/12/2049"
						ElseIf CtoD(aImport[nX][nCpo]) < dDataBase
							lInsert := .F.
							Exit						
						Endif
					Endif 
					// If Alltrim(aCabec[nCpo]) == "G1_TRT"
						// aImport[nX][nCpo] := PadR(allTrim(str(nTrt++)),3)
					// Endif
					Aadd(aGets,{Alltrim(aCabec[nCpo]),valorCpo(aCabec[nCpo],aImport[nX][nCpo]),Nil})
				Endif
			Endif
				
		Next nCpo
		
		If !lInsert
			aGets := {}
			If !lCabec
				aCab   := {}
			Endif
		Else
			lCabec := .T.
			Aadd(aItem,aGets)
		Endif	
		cCodAnt := aImport[nX][nPosCod]
	EndIf	
	
	
Next nX

If !Empty(aCab) .And. !Empty(aItem) .And. !lSalir
	MSExecAuto({|x,y,z| mata200(x,y,z)},aCab,aItem,3) //Inclusao
					
	If lMsErroAuto
		ProcLogAtu("ERRO",'Atenci�n',"Error en la importaci�n de Estructuras")
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
Endif

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
