#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "FileIO.ch"


// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������             
// �������������������������������������������������������������������������ͻ��
// ���Programa  �IMPSF1    � Autor � 				 � Data �             ���
// �������������������������������������������������������������������������͹��
// ���Descricao � Programa de importacion de Facturas de Compras             ���
// ���          �								                           ���
// �������������������������������������������������������������������������͹��
// ���Uso       � 			                                             ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

User Function IMPSF1()

Local oDlg

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Lectura de archivo .CSV")
@ 02,10 TO 080,190 Title OemToAnsi("")
@ 10,018 Say " Este programa leer� el contenido de un archivo .csv, conforme"
@ 18,018 Say " los par�metros definidos por el usuario y va a grabar el contenido "
@ 26,018 Say " en la tabla SF1 y SD1 (Facturas de compra). 			"

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
	Processa({|| GrabaSF1(aCabec,aImport)})
Endif

Return

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � GrabaSF1 � Autor � Ivaldo Junior      � Data �  27/02/09   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     �Executa a importa��o dos registros.                         ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function GrabaSF1(aCabec,aImport)

Local nX 		:= 0
Local nCpo      := 0
Local nCantErr  := 0
Local lsalir    := .F.
// Local aSF1      :={	"F1_TIPO",;		
					// "F1_DOC",;	
					// "F1_SERIE",;
					// "F1_COND",;	
					// "F1_EMISSAO",;
					// "F1_FORNECE",;
					// "F1_LOJA",;
					// "F1_MOEDA",;
					// "F1_ESPECIE",;
					// "F1_TIPODOC",;
					// "F1_TXMOEDA",;
					// "F1_NATUREZ"}	

// Local aSD1      :={	"D1_DOC",;	    				
                    // "D1_SERIE" ,;	
                    // "D1_ITEM",;	 
                    // "D1_COD",;	
                    // "D1_UM",;	
                    // "D1_SEGUM",;	
                    // "D1_QUANT",;	
                    // "D1_VUNIT",;	
                    // "D1_TOTAL",;	
                    // "D1_CONTA",;	
                    // "D1_TES"}

Local cDirLog   := "\log\"
Local cSubdir   := "factCompra\"
Local nPosDoc   := 0
Local nPosSer   := 0
Local nPosFor   := 0
Local nPosLoj   := 0
Local nPosTip   := 0
Local cDoc      := ""
Local cSer      := ""
Local cFor      := ""
Local cLoj      := ""
Local cTip      := ""
Local cCodAnt   := ""
Local cProd     := ""
Local lCabec    := .F.
Local lprod     := .F.
Local cItem     := "0000"
Local nSaldo    := 0

Private lMsErroAuto 	:= .F.
Private aVector       	:= {}
Private aCab            := {}
Private aItem           := {}

ProcRegua(Len(aImport))

nPosDoc := aScan( aCabec,{|x| allTrim(x) == "F1_DOC" })
nPosSer := aScan( aCabec,{|x| allTrim(x) == "F1_SERIE" })
nPosFor := aScan( aCabec,{|x| allTrim(x) == "F1_FORNECE" })
nPosLoj := aScan( aCabec,{|x| allTrim(x) == "F1_LOJA" })
nPosTip := aScan( aCabec,{|x| allTrim(x) == "F1_TIPO" })

If nPosDoc+nPosSer+nPosFor+nPosLoj+nPosTip == 0
	MsgAlert('No se localizaron los campos del �ndice de SF1','Atenci�n')
	Return
Endif

SB1->(DbSetOrder(1))

For nX:=1 To Len(aImport)
	IncProc("Importaci�n: Insertando registro "+AllTrim( Str(nX) )+" de "+AllTrim( Str(Len(aImport)) ))
	
	DbSelectArea("SF1")
	DbSetOrder(1) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
	
	cDoc := aImport[nX][nPosDoc]
	cSer := aImport[nX][nPosSer]
	cFor := aImport[nX][nPosFor]
	cLoj := aImport[nX][nPosLoj]
	cTip := aImport[nX][nPosTip]
	
	If !DbSeek( xFilial("SF1")+cDoc+cSer+cFor+cLoj+cTip)
	
		If !Empty(cCodAnt) .And. cCodAnt <> cDoc+cSer+cFor+cLoj+cTip
			If !Empty(aCab) .And. !Empty(aItem)
				MSExecAuto({|x,y,z| MATA101N(x,y,z) },aCab,aItem,3) //Inclusao
								
				If lMsErroAuto
					ProcLogAtu("ERRO",'Atenci�n',"Error en la importaci�n de Facturas de Compras")
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
				Else

					saldoSE2(nSaldo)
				EndIf
			EndIf
			lCabec := .F.
			aCab   := {}
			aItem  := {}
			cItem     := "0000"
		Endif
		
		If lsalir
			Exit
		Endif
		
		aGets   := {}
		lprod   := .F.
		cProd   := ""
		For nCpo := 1 To Len(aCabec)
			If !Empty(aCabec[nCpo]) //.And. u_esUsado(aCabec[nCpo])
			
				If !lCabec .And. Left(Alltrim(aCabec[nCpo]),3) == "F1_" //aScan( aSF1,{|x| x == Alltrim(aCabec[nCpo]) }) > 0 
					If Alltrim(aCabec[nCpo]) == "F1_COND"
						If allTrim(aImport[nX][nCpo]) == "@" // la condici�n es manual, no se puede determinar el plazo
							aImport[nX][nCpo] := "C30"
						Else
							aImport[nX][nCpo] := "C"+allTrim(aImport[nX][nCpo])
						Endif
					Endif
					Aadd(aCab,{Alltrim(aCabec[nCpo]),valorCpo(aCabec[nCpo],aImport[nX][nCpo]),Nil})
				ElseIf Left(Alltrim(aCabec[nCpo]),3) == "D1_" //aScan( aSD1,{|x| x == Alltrim(aCabec[nCpo]) }) > 0
					If Alltrim(aCabec[nCpo]) == "D1_COD"				
						// cProd := aImport[nX][nCpo]
						// aImport[nX][nCpo] :=  SubStr(cProd,3,4)+SubStr(cProd,1,2)+SubStr(cProd,7)
						If !Empty(aImport[nX][nCpo]) .And. SB1->(DbSeek( xFilial("SB1")+aImport[nX][nCpo]))
							lprod := .T.
						Endif
					elseif Alltrim(aCabec[nCpo]) == "D1_ITEM"
						cItem := soma1(cItem)
						aImport[nX][nCpo] := cItem
					elseif Alltrim(aCabec[nCpo]) == "D1_CONTA"
						If lprod
							aImport[nX][nCpo] := SB1->B1_CONTA
						Endif
					elseif Alltrim(aCabec[nCpo]) == "D1_UM"
						If lprod
							aImport[nX][nCpo] := SB1->B1_UM
						Endif
					elseif Alltrim(aCabec[nCpo]) == "D1_TES"
						If lprod
							aImport[nX][nCpo] := SB1->B1_TE
						Endif
					Endif
					Aadd(aGets,{Alltrim(aCabec[nCpo]),valorCpo(aCabec[nCpo],aImport[nX][nCpo]),Nil})
				ElseIf Left(Alltrim(aCabec[nCpo]),3) == "E2_"
					nSaldo := valorCpo(aCabec[nCpo],aImport[nX][nCpo])
				Endif
			Endif
				
		Next nCpo
		
		lCabec := .T.
		Aadd(aItem,aGets)

		cCodAnt := cDoc+cSer+cFor+cLoj+cTip
	EndIf	
		
Next nX

If !Empty(aCab) .And. !Empty(aItem) .And. !lSalir
	MSExecAuto({|x,y,z| MATA101N(x,y,z) },aCab,aItem,3) //Inclusao
					
	If lMsErroAuto
		ProcLogAtu("ERRO",'Atenci�n',"Error en la importaci�n de Facturas de Compras")
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
	Else
		saldoSE2(nSaldo)
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

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � saldoSE2 � Autor � Ariel Gel          � Data �  17/08/12   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     � Ajusta los saldos de la factura de entrada                 ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function saldoSE2(nSaldo)

Local aArea     := GetArea()
Local aAreaSE2  := SE2->(GetArea())
Local aAreaSF1  := SF1->(GetArea())
Local nResta    := 0
Local lSigue    := .T.
Local nValor    := 0
Local cDoc      := ""
Local cSer      := ""
Local cFor      := ""
Local cLoj      := ""
Local cTip      := ""


cDoc := aCab[aScan( aCab,{|x| allTrim(x[1]) == "F1_DOC" })][2]
cSer := aCab[aScan( aCab,{|x| allTrim(x[1]) == "F1_SERIE" })][2]
cFor := aCab[aScan( aCab,{|x| allTrim(x[1]) == "F1_FORNECE" })][2]
cLoj := aCab[aScan( aCab,{|x| allTrim(x[1]) == "F1_LOJA" })][2]
cTip := aCab[aScan( aCab,{|x| allTrim(x[1]) == "F1_TIPO" })][2]

DbSelectArea("SF1")
DbSetOrder(1) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO

If DbSeek( xFilial("SF1")+cDoc+cSer+cFor+cLoj+cTip)

	nResta := SF1->F1_VALBRUT - nSaldo 

	If nResta <= 0
		Return
	Endif

	SE2->(dbSetOrder(6)) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	If SE2->(dbSeek(xFilial("SE2")+cFor+cLoj+cSer+cDoc))
		
		While SE2->(!Eof()) .And. xFilial("SE2")+cFor+cLoj+cSer+cDoc == ;
			SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM .And. lSigue
			
			If SE2->E2_VALOR > 0 
				If nResta > SE2->E2_VALOR
					nResta-=SE2->E2_VALOR
					nValor := 0
				Else // nResta <= SE2->E2_VALOR
					lSigue := .F.
					nValor := SE2->E2_VALOR - nResta
				Endif
				
				RecLock("SE2",.F.)
					replace SE2->E2_VALOR with nValor
					replace SE2->E2_SALDO with nValor
				MsUnLock()
			Endif
			
		
			SE2->(dbSkip())
		EndDo
	Endif
Endif

RestArea(aAreaSF1)
RestArea(aAreaSE2)
RestArea(aArea)

Return 