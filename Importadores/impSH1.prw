#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "FileIO.ch"


// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ             
// ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
// ฑฑบPrograma  ณ IMPSH1   บ Autor ณ Ariel Gel          บ Data ณ  05/10/2012 บฑฑ
// ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
// ฑฑบDescricao ณ Programa de importacao de la tabla de recursos             บฑฑ
// ฑฑบ          ณ                                                            บฑฑ
// ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
// ฑฑบUso       ณ 			                                             บฑฑ
// ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function IMPSH1()

Local oDlg


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Lectura de archivo .CSV")
@ 02,10 TO 080,190 Title OemToAnsi("")
@ 10,018 Say " Este programa leerแ el contenido de un archivo .csv, conforme"
@ 18,018 Say " los parแmetros definidos por el usuario y va a grabar el contenido "
@ 26,018 Say " en la tabla SH1. "

@ 60,128 BMPBUTTON TYPE 01 ACTION {Valida("SH1"),Close(oDlg)}
@ 60,158 BMPBUTTON TYPE 02 ACTION Close(oDlg)

Activate Dialog oDlg Centered


Return

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
// ฑฑบPrograma  ณ Valida   บ Autor ณ Ivaldo Junior      บ Data ณ  27/02/09   บฑฑ
// ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
// ฑฑบDesc.     ณExecuta a importa็ใo dos registros.                         บฑฑ
// ฑฑบ          ณ                                                            บฑฑ
// ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
// ฑฑบUso       ณ AP                                                         บฑฑ
// ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function Valida(cTabla)

Private _cNomArq := ""
Private cTipo  := "Archivos del tipo (*.CSV)   | *.CSV     "

_cNomArq := cGetFile(cTipo,"Archivo a ser importado")

If !Empty(_cNomArq)
	Processa({|| Importar(cTabla)})
Else
	MsgStop("กOperaci๓n cancelada!")
EndIf


Return


// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
// ฑฑบPrograma  ณ Importar บ Autor ณ Ivaldo Junior      บ Data ณ  27/02/09   บฑฑ
// ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
// ฑฑบDesc.     ณEjecuta la importaci๓n del archivo                          บฑฑ
// ฑฑบ          ณ                                                            บฑฑ
// ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
// ฑฑบUso       ณ AP                                                         บฑฑ
// ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
	MsgAlert("No se pudo abrir el archivo ","Atenci๓n!")
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
				MsgAlert('Existen mแs campos definidos que datos. Ver lํnea: '+AllTrim(str(nCount)),'Atenci๓n')
			Else
				MsgAlert('Existen mแs datos que campos definidos. Ver lํnea: '+AllTrim(str(nCount)),,'Atenci๓n')
			Endif
			lError := .T.
		Else
			AAdd(aImport,aClone(aDados))
		Endif
	Endif

EndDo

FClose( oArch:nFileHandler )

If !lError
	Processa({|| GrabaSH1(aCabec,aImport,cTabla)})
Endif

Return

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
// ฑฑบPrograma  ณ GrabaSH1 บ Autor ณ Ivaldo Junior      บ Data ณ  27/02/09   บฑฑ
// ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
// ฑฑบDesc.     ณExecuta a importa็ใo dos registros.                         บฑฑ
// ฑฑบ          ณ                                                            บฑฑ
// ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
// ฑฑบUso       ณ AP                                                         บฑฑ
// ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function GrabaSH1(aCabec,aImport,cTabla)

Local nX 		:= 0
Local nCpo      := 0
Local nCantErr  := 0
Local lsalir    := .F.
Local cDirLog   := "\log\"
Local cSubdir   := "recursos\"
Local lError    := .F. 

Private aVector := {}
Private cCodRec := ""

// If MsgNoYes("ฟDesea borrar la tabla "+cTabla+"?","Atenci๓n")
	// dbSelectArea(cTabla)
	// (cTabla)->(__dbZap())
// Endif

ProcRegua(Len(aImport))

For nX:=1 To Len(aImport)
	IncProc("Importaci๓n: Insertando registro "+AllTrim( Str(nX) )+" de "+AllTrim( Str(Len(aImport)) ))
	
	aVector  := {}
	
	If !existeReg(aCabec,aImport,nX,cTabla)
		
		For nCpo := 1 To Len(aCabec)
			If !Empty(aCabec[nCpo]) 
				If "_FILIAL" $ Alltrim(aCabec[nCpo])
					aImport[nX][nCpo] := xFilial(cTabla)
				elseif Alltrim(aCabec[nCpo]) == "H1_CCUSTO"
					lError := buCCosto(aImport[nX][nCpo])
					
					If lError
						AutoGRLog("Error: No se encontr๓ el centro de costo "+allTrim(aImport[nX][nCpo])+;
										 " para el recurso "+cCodRec)
						AutoGRLog("")
						AutoGRLog("Ver la lํnea "+AllTrim( Str(nX+1) ))
						
						Exit
					Endif
				elseif Alltrim(aCabec[nCpo]) == "H1_CALEND"
					aImport[nX][nCpo] := "001" // codigo de calendario por default
				Endif
				
				Aadd(aVector,{Alltrim(aCabec[nCpo]),valorCpo(aCabec[nCpo],aImport[nX][nCpo]),Nil})
			Endif
		Next nCpo

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
	MsgAlert("Fin del Proceso. Registros con errores: "+str(nCantErr),'Atenci๓n')
Else
	MsgAlert('Proceso finalizado con ้xito','Atenci๓n')
Endif

//End Transaction

Return


// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
// ฑฑบPrograma  ณ valorCpo บ Autor ณ Ariel Gel          บ Data ณ  27/02/09   บฑฑ
// ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
// ฑฑบDesc.     ณ Retorna el valor formateado segun el tipo de dato del cpo  บฑฑ
// ฑฑบ          ณ                                                            บฑฑ
// ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
// ฑฑบUso       ณ AP                                                         บฑฑ
// ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

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

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
// ฑฑบLibreria  |ArchXLineaบ Autor ณ NAHUEL ESPINDOLA   บFecha ณ  22/06/09   บฑฑ
// ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
// ฑฑบDescripcioณ Funciones para recorrer archivos de texto linea por        บฑฑ
// ฑฑบ          ณ Linea, sin la limitac de la cant de carac de los de TOTVS  บฑฑ
// ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
// ฑฑบUso       ณ                                                            บฑฑ
// ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿


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

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
// ฑฑบPrograma  ณexisteReg บ Autor ณ Ariel Gel          บ Data ณ  07/08/12   บฑฑ
// ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
// ฑฑบDesc.     ณ Retorna el valor formateado segun el tipo de dato del cpo  บฑฑ
// ฑฑบ          ณ                                                            บฑฑ
// ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
// ฑฑบUso       ณ AP                                                         บฑฑ
// ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function existeReg(aCabec,aImport,nX,cTabla)	

Local aArea    := GetArea()
Local aAreaTab := (cTabla)->(GetArea())
Local lRet     := .F.
Local nPosCpo1 := ""
Local cClave   := ""


dbSelectArea(cTabla) // SH1
dbSetOrder(1) // H1_FILIAL+H1_CODIGO

nPosCpo1 := aScan(aCabec,{|x| allTrim(x) == "H1_CODIGO" })
cCodRec  := aImport[nX][nPosCpo1]
cClave   := PadR(cCodRec,TamSX3("H1_CODIGO")[1])

lRet := DbSeek( xFilial(cTabla)+ cClave)

RestArea(aAreaTab)
RestArea(aArea)

Return lRet

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
// ฑฑบPrograma  ณ buConta  บ Autor ณ Ariel Gel          บ Data ณ  21/06/11   บฑฑ
// ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
// ฑฑบDesc.     ณ Para el codigo resumido retorna el codigo completo         บฑฑ
// ฑฑบ          ณ                                                            บฑฑ
// ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
// ฑฑบUso       ณ AP                                                         บฑฑ
// ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function buCCosto(cCod)

Local aArea    := GetArea()
Local aAreaCTT := CTT->(GetArea())
Local lError   := .T.

If !Empty(cCod)
	CTT->(dbSetOrder(1)) //CTT_FILIAL+CTT_CUSTO
	If CTT->(DbSeek( xFilial( "CTT" ) + PadR(cCod,TamSX3("CTT_CUSTO")[1])))
		lError := .F.
	Endif
Endif

RestArea(aAreaCTT)
RestArea(aArea)

Return lError