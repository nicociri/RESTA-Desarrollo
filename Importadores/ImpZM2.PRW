#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "FileIO.ch"


// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������             
// �������������������������������������������������������������������������ͻ��
// ���Programa  �IMPZM2    � Autor � 			    	� Data �             ���
// �������������������������������������������������������������������������͹��
// ���Descricao � Programa de importacao de Ordenes de Servicio              ���
// ���          �								                             ���
// �������������������������������������������������������������������������͹��
// ���Uso       � 			                                                 ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

User Function IMPZM2()

Local oDlg

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Lectura de archivo .CSV")
@ 02,10 TO 080,190 Title OemToAnsi("")
@ 10,018 Say " Este programa leer� el contenido de un archivo .csv, conforme"
@ 18,018 Say " los par�metros definidos por el usuario y va a grabar el contenido "
@ 26,018 Say " en las tablas ZM2(Cabecera de OS) y ZM3(Items de OS). "

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
Local nCpo    := 0
Local aDados  := {}  
Local aDadAux := {}
Local aCabecC := {}
Local aCabecI := {}
Local aImporC := {}
Local aImporI := {}
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
    
 	aDadAux := {}
		
	If nCount == 1 // cabecera con los campos a ser migrados
		cLine  := 'Tipo;'+cLine
		aCabecC := FA_StrSplit(cLine,cSep) // Convierto a Array. Separo por "|" 
	ElseIf nCount == 2 // cabecera con los campos a ser migrados
		cLine  := 'Tipo;'+cLine
		aCabecI := FA_StrSplit(cLine,cSep) // Convierto a Array. Separo por "|"
	Else
		aDados := FA_StrSplit(cLine,cSep) // Convierto a Array. Separo por "|"  
		If aDados[1] == '1'
			If Len(aCabecC) <> Len(aDados)
				If Len(aCabecC) > Len(aDados)
					MsgAlert('Existen m�s campos definidos que datos en la Cabecera. Ver l�nea: '+AllTrim(str(nCount)),'Atenci�n')
				Else
					MsgAlert('Existen m�s datos que campos definidos en la Cabecera. Ver l�nea: '+AllTrim(str(nCount)),,'Atenci�n')
				Endif
				lError := .T.
			Else
			    For nCpo := 1 To Len (aDados)
			     //	If nCpo > 1
			    		AAdd(aDadAux,aDados[nCpo])
			     //	EndIf
			    Next nCpo
				AAdd(aImporC,aClone(aDadAux))
				Processa({|| GrabaZM2(aCabecC,aImporC)}) 
				aImporC := {}
			Endif 
		Else	
			If Len(aCabecI) <> Len(aDados) 
				If Len(aCabecI) > Len(aDados) 
					MsgAlert('Existen m�s campos definidos que datos en los Items. Ver l�nea: '+AllTrim(str(nCount)),'Atenci�n')
				Else
					MsgAlert('Existen m�s datos que campos definidos en los Items. Ver l�nea: '+AllTrim(str(nCount)),,'Atenci�n')
				Endif
				lError := .T.
			Else   
				For nCpo := 1 To Len (aDados)
			       //	If nCpo > 1
			    		AAdd(aDadAux,aDados[nCpo])
			       //	EndIf
			    Next nCpo
				AAdd(aImporI,aClone(aDadAux))
				Processa({|| GrabaZM3(aCabecI,aImporI)})
				aImporI := {} 
			Endif
		EndIf	
	Endif

EndDo

FClose( oArch:nFileHandler )

//If !lError
//	Processa({|| GrabaZM2(aCabecC,aImporC)})   
//	Processa({|| GrabaZM3(aCabecI,aImporI)})
//Endif

Return

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � GrabaZM2 � Autor � Ivaldo Junior      � Data �  27/02/09   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     �Executa a importa��o dos registros.                         ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function GrabaZM2(aCabecC,aImporC)

Local nX 		:= 0
Local nCpo      := 0
Local cCod      := ""
Local nPosCod   := 0
Local nPosLoj   := 0
Local nCantErr  := 0
Local lsalir    := .F.
Local lNeg      := .F.
Local aCpos     :={	"ZM2_FILIAL",;
					"ZM2_NUM",;
					"ZM2_DATALT",; 
					"ZM2_HORALT",; 
					"ZM2_NUMFOR",;
					"ZM2_SOBRE",;
					"ZM2_DATEMI",;
					"ZM2_HOREMI",;
					"ZM2_CODCLI",;
					"ZM2_SUCCLI",;
					"ZM2_NOMCLI",;
					"ZM2_SERIE",;
					"ZM2_CODPRO",;
					"ZM2_NOMPRO",;
					"ZM2_CODCON",;
					"ZM2_NOMCON",;
					"ZM2_TELCON",;
					"ZM2_DATSOL",;
					"ZM2_HORSOL",;
					"ZM2_LUGAR",;
					"ZM2_GARANT",;
					"ZM2_INTERV",;
					"ZM2_CLASIF",;
					"ZM2_ESTADO",;
					"ZM2_INFFAT",;
					"ZM2_CODCOM",;
					"ZM2_SUCCOM",;
					"ZM2_SUCFAT",;
					"ZM2_NUMFAT",;
					"ZM2_FECFAT",;
					"ZM2_CICLO",;
					"ZM2_DATVIS",;
					"ZM2_HORVIS",;
					"ZM2_DATFIN",;
					"ZM2_HORFIN",;
					"ZM2_KM",;
					"ZM2_FINPV"}

Local cDirLog   := "\log\"
Local cSubdir   := "maestrDeService\"
Local nPosCod   := 0
      
Private lMsErroAuto 	:= .F.
Private aVector       	:= {}

ProcRegua(Len(aImporC))

nPosCod := aScan( aCabecC,{|x| allTrim(x) == "ZM2_NUM" })

For nX:=1 To Len(aImporC)
  //	IncProc("Importaci�n: Insertando registro "+AllTrim( Str(nX) ))
	
	aVector  := {}
	lNeg     := .F.
	
	DbSelectArea("ZM2")
	DbSetOrder(1)
	
	If nPosCod > 0 .And. !DbSeek( xFilial("ZM2")+aImporC[nX][nPosCod])
		
		For nCpo := 2 To Len(aCabecC)
			If !Empty(aCabecC[nCpo]) //.And. aScan( aCpos,{|x| x == Alltrim(aCabecC[nCpo]) }) > 0 //.And.; 
			    //u_esUsado(aCabecC[nCpo])
				
				Aadd(aVector,{Alltrim(aCabecC[nCpo]),valorCpo(aCabecC[nCpo],aImporC[nX][nCpo]),Nil})
			Endif
		Next nCpo
		       
		
		If RecLock("ZM2",.T.) 
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

//If nCantErr > 0
//	MsgAlert("Fin del Proceso. Registros con errores: "+str(nCantErr),'Atenci�n')
//Else
////	MsgAlert('Proceso finalizado con �xito','Atenci�n')
//Endif

//End Transaction

Return
    
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � GrabaZM3 � Autor � Ivaldo Junior      � Data �  27/02/09   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     �Executa a importa��o dos registros.                         ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function GrabaZM3(aCabecI,aImporI)

Local nX 		:= 0
Local nCpo      := 0
Local cCod      := ""
Local nPosNum   := 0     
Local nPosCod   := 0
Local nPosLoj   := 0
Local nCantErr  := 0
Local lsalir    := .F.
Local lNeg      := .F.
Local aCpos    :={	"ZM3_FILIAL",;
										"ZM3_NUM",;
										"ZM3_COD",;  
										"ZM3_DESC",;
										"ZM3_SUSTIT",;
										"ZM3_SUSDES",;
										"ZM3_DEFECT",;
										"ZM3_DEFDES",;
										"ZM3_ACCION",;
										"ZM3_ACCDES",;
										"ZM3_PEDIDA",;
										"ZM3_REPONE",;
										"ZM3_RECEP",;
										"ZM3_PV",;
										"ZM3_ITPV",;
										"ZM3_UNIT"}
										

Local cDirLog   := "\log\"
Local cSubdir   := "maestrDeService\"
Local nPosCod   := 0
      
Private lMsErroAuto 	:= .F.
Private aVector       	:= {}

ProcRegua(Len(aImporI))

nPosNum := aScan( aCabecI,{|x| allTrim(x) == "ZM3_NUM" })   
nPosCod := aScan( aCabecI,{|x| allTrim(x) == "ZM3_COD" })

For nX:=1 To Len(aImporI)
   //	IncProc("Importaci�n: Insertando registro "+AllTrim( Str(nX) )+" de "+AllTrim( Str(Len(aImporI)) ))
	
	aVector  := {}
	lNeg     := .F.
	
	DbSelectArea("ZM3")
	DbSetOrder(1)
	
	If nPosCod > 0 .And. !DbSeek( xFilial("ZM3")+aImporI[nX][nPosNum]+aImporI[nX][nPosCod])
		
		For nCpo := 2 To Len(aCabecI)
			If !Empty(aCabecI[nCpo]) .And. aScan( aCpos,{|x| x == Alltrim(aCabecI[nCpo]) }) > 0 //.And.; 
			    //u_esUsado(aCabecI[nCpo])
				
				Aadd(aVector,{Alltrim(aCabecI[nCpo]),valorCpo(aCabecI[nCpo],aImporI[nX][nCpo]),Nil})
			Endif
		Next nCpo
		       
		
		If RecLock("ZM3",.T.) 
	 		For nCpo := 1 To Len(aVector)
			 	Replace &(aVector[nCpo][1]) with aVector[nCpo][2]
			 Next nCpo
			 MsUnlock()
		EndIf
				 				
	EndIf	
	
	If lsalir
		Exit
	Endif
Next

//If nCantErr > 0
//	MsgAlert("Fin del Proceso. Registros con errores: "+str(nCantErr),'Atenci�n')
//Else
//	MsgAlert('Proceso finalizado con �xito','Atenci�n')
//Endif

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