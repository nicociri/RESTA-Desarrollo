#include 'Protheus.ch'
#Include "TBIconn.Ch"
#Include "FileIO.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBORRA_MIG บAutor  ณAndres Demarziani   บFecha ณ  02/01/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcion para eliminar todos los registros de las tablas de บฑฑ
ฑฑบ          ณ movimientos del sistema.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function BORRA_MIG

Local cFileLog		:= ""	
Local cDirLog		:= "" 
Local cPath			:= ""
Local lIsJob		:= !(Type('cEmpAnt') == 'C')
Local oImpoTab
Local oCheckBox2
Local oCheckBox3

Private	nOpc		:= 0
Private lDel		:= .F.
Private lImpoTab	:= .F.
Private lCheckBox2	:= .F.
Private lCheckBox3	:= .F.
Private oDlg
Private oMainWnd    

If lIsJob
	RpcSetType(3)
	RpcSetEnv('00','00',,,'CFG')
EndIf

DEFINE MSDIALOG oDlg TITLE "Limpieza de datos" FROM C(249),C(410) TO C(539),C(784) PIXEL

	@ C(002),C(004) TO C(142),C(183) LABEL " Limpieza de datos " PIXEL OF oDlg

	@ C(012),C(012) Say "Este programa tiene el objetivo de borrar los movimientos de" 	Size C(200),C(008) COLOR CLR_BLACK 	PIXEL OF oDlg
	@ C(022),C(012) Say "todo el sistema. Puede usar la opcion 'Importa Tablas'" 		Size C(200),C(008) COLOR CLR_BLACK 	PIXEL OF oDlg
	@ C(032),C(012) Say "si desea levantar desde un archivo, las tablas a eliminar."	Size C(200),C(008) COLOR CLR_BLACK 	PIXEL OF oDlg
	
	@ C(050),C(012) CheckBox oImpoTab 		Var lImpoTab 	Prompt "Importa Tablas" Size C(048),C(008) PIXEL OF oDlg
	@ C(062),C(012) CheckBox oCheckBox2 	Var lCheckBox2 	Prompt "CheckBox2" 		Size C(048),C(008) PIXEL OF oDlg
	@ C(074),C(012) CheckBox oCheckBox3 	Var lCheckBox3 	Prompt "CheckBox3" 		Size C(048),C(008) PIXEL OF oDlg

	DEFINE SBUTTON oBtnOk FROM C(121),C(137) TYPE 1 ACTION ( nOpc := 1, oDlg:End() )	ENABLE OF oDlg PIXEL	

ACTIVATE MSDIALOG oDlg CENTERED 

If nOpc == 1

	AutoGrLog( "Fecha Inicio.......: " + DToC(MsDate()) )
	AutoGrLog( "Hora Inicio........: " + Time() )
	AutoGrLog( "Environment........: " + GetEnvServer() )
	AutoGrLog( " " )

	Processa( {|| fLimpiaDatos() }, 'Limpiando Tablas...'   , 'Aguarde Por Favor... ' )

	AutoGrLog( " " )
	AutoGrLog( "Fecha Fin...........: " + Dtoc(MsDate()) )
	AutoGrLog( "Hora Fin............: " + Time() )
			
	cFileLog := NomeAutoLog()
	
	If cFileLog <> ""
		nX := 1
		While .T.
			If File( Lower( cDirLog + Dtos( MSDate() ) + StrZero( nX, 3 ) + '.log' ) ) // El directorio debe estar creado en el servidor bajo DATA
				nX++
				If nX == 999
					Exit
				EndIf
				Loop
			Else
				Exit
			EndIf
		EndDo
		__CopyFile( cPath + Alltrim( cFileLog ), Lower( cDirLog + Dtos( MSDate() ) + StrZero( nX, 3 ) + '.log' ) )
		MostraErro(cPath,cFileLog)
		FErase( cFileLog )
	EndIf
EndIf

If lIsJob
	RpcClearEnv()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBORRA_MIG บAutor  ณMicrosiga           บFecha ณ  02/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fLimpiaDatos()

Local cFileLog	:= ""	
Local cQuery	:= ""
Local cDirLog	:= "" 
Local cPath		:= ""
Local nRegDEL	:= 0
Local aTablas 	:= {	'SB2','SB7','SB8','SBC','SBF','SBJ','SBK','SC1','SC2','SC5','SC6','SC7','SC8','SC9',;
						'SCR','SD1','SD2','SD3','SD4','SD5','SF1','SF2','SF3','SE1','SE2','SE5','SEK','SFE',;
						'SEL','ADA','ADB','CT2','CT6','CT7','SE8','SEF','SC3','SL1','SL2','SL4','SB9','SCP',;
						'SCQ','SDA','SDD','SW0','SW1','SW2','SW3','SW4','SW5','SW6','SW7','SW8','SW9','SWN',;
						'SWD','SWW','SEU','SCJ','SCK'}					

If lImpoTab
	aTablas := aClone(fCargaTablasArchivo())
EndIf

#IFDEF TOP
	For nX := 1 To Len(aTablas)
		cQuery := 'DELETE FROM ' + RetSqlName(aTablas[nX])
		TCSqlExec(cQuery)		
		AutoGrLog("Tabla "+aTablas[nX])		
		nRegDEL++		
	Next
#ELSE
	For nX := 1 To Len(aTablas)
		DbSelectArea( aTablas[nX] )
		__DbZap()
		AutoGrLog("Tabla "+aTablas[nX])		
		nRegDEL++		
	Next
#ENDIF

CloseOpen(aTablas,aTablas)		

AutoGrLog( "Tablas borradas: "+cValToChar(nRegDEL))

Return

/****************************************************************************/
Static Function C(nRet)
Return nRet
/****************************************************************************/ 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBORRA_MIG บAutor  ณMicrosiga           บFecha ณ  02/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCargaTablasArchivo()

Local cFile 		:= ""
Local cLinea		:= ""
Local cTitulo1  	:= "Seleccione Archivo"
Local cExtens   	:= "Archivo | *.*"
Local aRet 			:= {}

cFile := cGetFile(cExtens,cTitulo1,,,.T.)

If File( cFile )

	FT_FUse( cFile )
	FT_FGotop()
	
	dbSelectArea("SX2")
	dbSetOrder(1)
		
	While !FT_FEof()		
		cLinea	:= SubStr(FT_FREADLN(),01,03)
		If SX2->(dbSeek(cLinea))
			aAdd(aRet,cLinea)		
		Else
			AutoGrLog("La tabla "+cLinea+" No existe!")
		EndIf
		FT_FSkip()
	EndDo					
EndIf

Return aRet