#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "FileIO.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMPSB9    � Autor � 				   � Data �             ���
�������������������������������������������������������������������������͹��
���Descricao � Programa de Saldos de Stock                                ���
�������������������������������������������������������������������������͹��
���Uso       � 			                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function IMPSB9()
Local oDlg

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Lectura de archivo .CSV")
@ 02,10 TO 080,190 Title OemToAnsi("")
@ 10,018 Say " Este programa leer� el contenido de un archivo .csv, conforme"
@ 18,018 Say " los par�metros definidos por el usuario y va a grabar el contenido "
@ 26,018 Say " en la tabla SB9(Saldos). 								"

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
	MsgStop("Operaci�n cancelada!")
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
Static Function Importar()

Local nTotLin := 0
Local nCount  := 0
Local nX      := 0
Local aDados  := {}
Local aCabec  := {}
Local aImport := {}
Local cLine   := ""
Local cSep    := ";"
Local oArch
Local lError  := .F.

// Abro el archivo
oArch:=TA_ARCHXLINEAS():new(_cNomArq)

If oArch:nFileHandler == -1
	MsgAlert("No se pudo abrir el archivo ","Atencion!")
	Return .F.
Endif

nTotLin := oArch:nTotLineFile

//ProcRegua(oArch:nTotLineFile)

While !oArch:finArchivo( ) .And. !lError

	nCount++

	If !oArch:leerLinea(@cLine) 
	   MsgInfo("Error leyendo las lineas del archivo", "Error") 
	   Return .F.
	EndIf 

	cLine:=AllTrim(cLine) // Quito espacios inicio y fin
	cLine:=OEMToANSI(cLine)	// Convierto a ANSI
	
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
	Processa({|| GrabaSB9(aCabec,aImport)})
Endif

Return

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � GrabaSB9 � Autor � Ivaldo Junior      � Data �  27/02/09   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     �Executa a importa��o dos registros.                         ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function GrabaSB9(aCabec,aImport)

Local nX        := 0
Local nCpo      := 0
Local cCod      := ""
Local nPosCod   := 0
Local nPosLoj   := 0
Local nCantErr  := 0
Local lsalir    := .F.
Local cDirLog   := "\log\"
Local cSubdir   := "Saldos\"
Local aCabMov   := {}
Local aIteAuto  := {} 
Local cAlias    := "SB9"
Local nPosCod   := 0
Local nPosLoc   := 0
Local nPosQua   := 0
Local nPosQsu   := 0
Local nPosCos   := 0
Local nPosVin   := 0

Private aItem       := {}
Private aGet        := {}
Private aCab        := {}
Private lMsErroAuto 	:= .F.
Private aVector       	:= {}

ProcRegua(Len(aImport))

nPosCod := aScan( aCabec,{|x| allTrim(x) == "B9_COD" })
nPosLoc := aScan( aCabec,{|x| allTrim(x) == "B9_LOCAL" })
nPosQua := aScan( aCabec,{|x| allTrim(x) == "B9_QINI" })
nPosQsu := aScan( aCabec,{|x| allTrim(x) == "B9_QISEGUM" })
nPosCos := aScan( aCabec,{|x| allTrim(x) == "B9_CM1" })
nPosVin := aScan( aCabec,{|x| allTrim(x) == "B9_VINI1" })


//Begin Transaction
For nX:=1 To Len(aImport)
	IncProc("Importaci�n: Insertando registro "+AllTrim( Str(nX) )+" de "+AllTrim( Str(Len(aImport)) ))
	aItem  := {}
	DbSelectArea("SB9")
	DbSetOrder(1)
	If !DbSeek(xFilial("SB9")+aImport[nX][nPosCod]+aImport[nX][nPosLoc]) .And. Val(aImport[nX][nPosCos]) > 0
	    _cLocaliz :=SB1->B1_LOCALIZ 
		//Importacao de Saldo Inicial (SB9)
		aadd(aItem,	{"B9_COD"		,Alltrim(aImport[nX][nPosCod]),NIL})
		aadd(aItem,	{"B9_LOCAL"		,Alltrim(aImport[nX][nPosLoc]),NIL})
		aadd(aItem,	{"B9_QINI"		,Val(aImport[nX][nPosQua])	,NIL})
		aadd(aItem,	{"B9_VINI1"		,Val(aImport[nX][nPosQua]) * Val(aImport[nX][nPosCos])	,NIL})
		
		DbSelectArea("SB9")
		MSExecAuto({|x,y| mata220(x,y)},aItem,3) //Inclusao
		If lMsErroAuto
			ProcLogAtu("ERRO",'Atenci�n',"Error en la importaci�n de Movimientos Internos -> Saldos en Stock")
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
			/*
			ProcLogAtu("ERRO",'Aten��o',"Erro na importa��o de Saldo Inicial.")
			MOSTRAERRO("\tmp\saldos\")
			lMsErroAuto := .F.
			*/
		Else
/*		
			If _cLocaliz = "S"
			    //Enderecamento automatico do saldo
				dbSelectArea("SDA")
				dbSetOrder(1) // // DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_NUMSEQ+DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA
				If dbSeek(xFilial("SDA")+Alltrim(aImport[nX][nPosCod])+Alltrim(aImport[nX][nPosLoc]))
					aCab := {}
					aGet := {}
					
					aCab:= {	{"DA_FILIAL"	,xFilial("SDA")	,NIL},;
					{"DA_PRODUTO"	,Alltrim(aImport[nX][nPosCod])   	,NIL},;
					{"DA_LOCAL"		,Alltrim(aImport[nX][nPosLoc])	,NIL}}
					
					Aadd(aGet, {  {"DB_ITEM"		,"001"	 ,NIL},;
					{"DB_LOCALIZ"	,Alltrim(aImport[nX][5]) ,NIL},;
					{"DB_PRODUTO"	,Alltrim(aImport[nX][nPosCod]) ,NIL},;
					{"DB_QUANT"	    ,Val(aImport[nX][nPosQua])     ,NIL},;
					{"DB_DATA"		,DDATABASE				 ,NIL}})
					
					MSExecAuto({|x,y,z| mata265(x,y,z)},aCab,aGet,3) //Distribui
					
					If lMsErroAuto
						ProcLogAtu("ERRO",'Aten��o',"Erro no enderecamento de Saldo Inicial.")
						MOSTRAERRO("\tmp\endereco\")
						lMsErroAuto := .F.
					EndIf
					
				EndIf
				aItzem   := {}
			EndIf
*/			
		EndIf
	EndIf
	
	If lsalir
		Exit
	Endif
	
Next
//End Transaction

If nCantErr > 0
	MsgAlert("Fin del Proceso. Registros con errores: "+str(nCantErr),'Atenci�n')
Else
	MsgAlert('Proceso finalizado con �xito','Atenci�n')
Endif

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