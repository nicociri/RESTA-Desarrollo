#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "FileIO.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPSD3    บ Autor ณ 				   บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa de importacao de Movimiento Interno               บฑฑ
ฑฑบ          ณ	        Saldos de Stock                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 			                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function IMPSD3()
Local oDlg

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Lectura de archivo .CSV")
@ 02,10 TO 080,190 Title OemToAnsi("")
@ 10,018 Say " Este programa leerแ el contenido de un archivo .csv, conforme"
@ 18,018 Say " los parแmetros definidos por el usuario y va a grabar el contenido "
@ 26,018 Say " en la tabla SD3(Movimientos Internos->Saldos en Stock). 								"

@ 60,128 BMPBUTTON TYPE 01 ACTION {Valida(),Close(oDlg)}
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
Static Function Valida()

Private _cNomArq := ""
Private cTipo  := "Archivos del tipo (*.CSV)   | *.CSV     "

_cNomArq := cGetFile(cTipo,"Archivo a ser importado")

If !Empty(_cNomArq)
	Processa({|| Importar()})
Else
	MsgStop("Operaci๓n cancelada!")
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
	Processa({|| GrabaSD3(aCabec,aImport)})
Endif

Return

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
// ฑฑบPrograma  ณ GrabaSD3 บ Autor ณ Ivaldo Junior      บ Data ณ  27/02/09   บฑฑ
// ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
// ฑฑบDesc.     ณExecuta a importa็ใo dos registros.                         บฑฑ
// ฑฑบ          ณ                                                            บฑฑ
// ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
// ฑฑบUso       ณ AP                                                         บฑฑ
// ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function GrabaSD3(aCabec,aImport)

Local nX        := 0
Local nCpo      := 0
Local cCod      := ""
Local nPosCod   := 0
Local nPosLoj   := 0
Local nCantErr  := 0
Local lsalir    := .F.
Local cDirLog   := "\log\"
Local cSubdir   := "SaldosEnStock\"
Local aCabMov   := {}
Local aIteAuto  := {} 
Local cAlias    := "SD3"
Local nPosCod   := 0
Local nPosLoc   := 0
Local nPosQua   := 0
Local nPosQsu   := 0
Local nPosCos   := 0

Private lMsErroAuto 	:= .F.
Private aVector       	:= {}

ProcRegua(Len(aImport))

nPosCod := aScan( aCabec,{|x| allTrim(x) == "B9_COD" })
nPosLoc := aScan( aCabec,{|x| allTrim(x) == "B9_LOCAL" })
nPosQua := aScan( aCabec,{|x| allTrim(x) == "B9_QINI" })
nPosQsu := aScan( aCabec,{|x| allTrim(x) == "B9_QISEGUM" })
nPosCos := aScan( aCabec,{|x| allTrim(x) == "B9_CM1" })


For nX:=1 To Len(aImport)
	IncProc("Importaci๓n: Insertando registro "+AllTrim( Str(nX) )+" de "+AllTrim( Str(Len(aImport)) ))

	aVector  := {}
	DbSelectArea("SD3")
	DbSetOrder(3)
	
	If nPosCod+nPosLoc > 0 .And. !DbSeek( xFilial("SD3")+aImport[nX][nPosCod]+aImport[nX][nPosLoc])
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Atualiza arquivo de saldos em estoque      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		dbSelectArea("SB2")
		If ! SB2->(dbSeek(xFilial("SB2")+aImport[nX][nPosCod]+aImport[nX][nPosLoc]))
			CriaSB2(aImport[nX][nPosCod],aImport[nX][nPosLoc])
		EndIf
		
		SB1->( DbSetOrder(1) )
		SB1->( DbSeek( xFilial('SB1') + aImport[nX][nPosCod] ) )
		
		aAdd(aCabMov,{"D3_TM"       , If ( valorCpo("D3_CUSTO1",aImport[nX][nPosCos]) == 0,GETMV("AL_TMAJSES"),GETMV("AL_TMAJSES")),Nil})
		aAdd(aCabMov,{"D3_CC"       , "  "	 ,Nil})                           
		aAdd(aCabMov,{"D3_EMISSAO"  ,dDataBase,Nil})
										  
		aAdd(aIteAuto, {{"D3_COD"    , aImport[nX][nPosCod], NIL},;
						{"D3_UM"     , SB1->B1_UM, NIL},; 
						{"D3_LOCAL"  , aImport[nX][nPosLoc], NIL},;    
						{"D3_MOEDA"  , "1", NIL},;
						{"D3_SEGUM"  , SB1->B1_SEGUM, NIL},;
						{"D3_QUANT"  , valorCpo("D3_QUANT",aImport[nX][nPosQua]), NIL},;
						{"D3_QTSEGUM", valorCpo("D3_QTSEGUM",aImport[nX][nPosQsu]), NIL},;
						{"D3_GRUPO"  , SB1->B1_GRUPO,Nil},;		
						{"D3_CUSTO1" , valorCpo("D3_CUSTO1",aImport[nX][nPosCos]), NIL},;
						{"D3_ITEMCTA" ,SB1->B1_ITEMCC,Nil},;
						{"D3_USUARIO", cUserName, NIL}}) //,;                       
						// {"D3_ITEMCTA" , "", NIL}}) // INDICAR ITEM CONTABLE QUE INFORME BENJAMIN
         
		MSExecAuto({|x,y,z| MATA241(x,y,z)}, aCabMov, aIteAuto, 3)
		 
		If lMsErroAuto
			ProcLogAtu("ERRO",'Atenci๓n',"Error en la importaci๓n de Movimientos Internos -> Saldos en Stock")
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
	
	aCabMov := {} 
	aIteAuto:= {}
	
	If lsalir
		Exit
	Endif
Next
//End Transaction
If nCantErr > 0
	MsgAlert("Fin del Proceso. Registros con errores: "+str(nCantErr),'Atenci๓n')
Else
	MsgAlert('Proceso finalizado con ้xito','Atenci๓n')
Endif

Return	

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
// ฑฑบPrograma  ณ esVisual บ Autor ณ Ariel Gel          บ Data ณ  12/06/12   บฑฑ
// ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
// ฑฑบDesc.     ณ Retorna si el campo es Visual                              บฑฑ
// ฑฑบ          ณ                                                            บฑฑ
// ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
// ฑฑบUso       ณ AP                                                         บฑฑ
// ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

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