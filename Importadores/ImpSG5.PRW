#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "FileIO.ch"


// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������             
// �������������������������������������������������������������������������ͻ��
// ���Programa  �IMPSG5    � Autor � 			      � Data �             ���
// �������������������������������������������������������������������������͹��
// ���Descricao � Programa de importacao de Letras de Cambio                 ���
// ���          �								                      ���
// �������������������������������������������������������������������������͹��
// ���Uso       � 			                                               ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

User Function IMPSG5()

Local oDlg

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Lectura de archivo .CSV")
@ 02,10 TO 080,190 Title OemToAnsi("")
@ 10,018 Say " Este programa leer� el contenido de un archivo .csv, conforme"
@ 18,018 Say " los par�metros definidos por el usuario y va a grabar el contenido "
@ 26,018 Say " en la tabla SG5(Letras de Cambio) y en SB5(Complemento de LC). 	"

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
	Processa({|| GrabaSG5(aCabec,aImport)})
Endif

Return

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � GrabaSG5 � Autor � Ivaldo Junior      � Data �  27/02/09   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     �Executa a importa��o dos registros.                         ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function GrabaSG5(aCabec,aImport)

Local nX 		:= 0
Local nCpo      := 0
Local cCod      := ""
Local cDescPrd  := ""
Local nPosPro   := 0
Local nPosLet   := 0
Local nPosLoj   := 0
Local nCantErr  := 0
Local lsalir    := .F.
Local lNeg      := .F.
Local aCpos     :={	"G5_FILIAL",;
					"G5_PRODUTO",;  
					"G5_REVISA",;
					"G5_DATAREV",;
					"G5_OBS",;
					"G5_USER",;
					"G5_STATUS",;
					"G5_MSBLQL",;
					"G5_DATVIG",;
					"G5_PROXREV"}

Local cDirLog   := "\log\"
Local cSubdir   := "LetraCambio\"
Local nPosCod   := 0
      
Private lMsErroAuto 	:= .F.
Private aVector       	:= {}

ProcRegua(Len(aImport))

nPosPro := aScan( aCabec,{|x| allTrim(x) == "G5_PRODUTO" })   
nPosLet := aScan( aCabec,{|x| allTrim(x) == "G5_REVISAO" })

For nX:=1 To Len(aImport)
	IncProc("Importaci�n: Insertando registro "+AllTrim( Str(nX) )+" de "+AllTrim( Str(Len(aImport)) ))
	
	aVector  := {}
	lNeg     := .F.
	cDescPrd := Posicione("SB1",1,xFilial("SB1")+aImport[nX][nPosPro],"B1_DESC")
	
	DbSelectArea("SG5")
	DbSetOrder(1)
	
	If nPosPro > 0 .And. !DbSeek( xFilial("SG5")+aImport[nX][nPosPro]+aImport[nX][nPosLet])
		
		For nCpo := 1 To Len(aCabec)
			If !Empty(aCabec[nCpo]) //.And. aScan( aCpos,{|x| x == Alltrim(aCabec[nCpo]) }) > 0 //.And.; 
			    //u_esUsado(aCabec[nCpo])
				If aCabec[nCpo]== "VIGENTE"
					Aadd(aVector,{Alltrim(aCabec[nCpo]),aImport[nX][nCpo],Nil})
				Else
				   Aadd(aVector,{Alltrim(aCabec[nCpo]),valorCpo(aCabec[nCpo],aImport[nX][nCpo]),Nil})    
				EndIf
			Endif
		Next nCpo
		       
		
		If RecLock("SG5",.T.) 
			Replace  G5_FILIAL  with xFilial("SG5")
	 		For nCpo := 1 To Len(aVector)
				Do Case
					Case aVector[nCpo][1]== "G5_USER"
						Replace  G5_USER   with Subs(cUsuario,7,6)
					Case aVector[nCpo][1]== "VIGENTE" .And. aVector[nCpo][2] == "S"    
						If RecLock("SB5",.T.) 
							Replace  B5_FILIAL   with xFilial("SB5")
							Replace  B5_COD      with aImport[nX][nPosPro]
							Replace  B5_CEME     with cDescPrd
							Replace  B5_ROTACAO  with "2"
							Replace  B5_UMIND    with "1"
							Replace  B5_PORTMS   with "2"
							Replace  B5_NPULMAO  with "1"
							Replace  B5_TIPUNIT  with "1"
							Replace  B5_QTDVAR   with "2"
							Replace  B5_IMPETI   with "1"
							Replace  B5_PERIOT   with "1"
							Replace  B5_NSERIE   with "1"
							Replace  B5_REVPROD  with "1"   //1=TIENE LETRA DE CAMBIO, SINO 2
							Replace  B5_FORMMRP  with "1"
							Replace  B5_AGLUMRP  with "1"
							Replace  B5_BLQINVA  with "1"
							Replace  B5_VERSAO   with aImport[nX][nPosLet]
							Do Case
								Case aVector[nCpo+1][2] = '02' .Or. aVector[nCpo+1][2] = '08'
									Replace  B5_XSUCPRD  with '  ' 
								Case aVector[nCpo+1][2] = '11' 
									Replace  B5_XSUCPRD  with '02'
								Otherwise
									Replace  B5_XSUCPRD  with aVector[nCpo+1][2] 
							EndCase
							Replace  B5_XLINSTD  with aVector[nCpo+2][2]
							Replace  B5_XPRMAN   with aVector[nCpo+3][2]														
							MsUnlock()    
							exit
						EndIf
					Otherwise
						Replace  &(aVector[nCpo][1])  with aVector[nCpo][2]
				EndCase
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