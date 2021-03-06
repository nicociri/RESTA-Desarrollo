#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "FileIO.ch"


// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������             
// �������������������������������������������������������������������������ͻ��
// ���Programa  �IMPSA1    � Autor � 				 � Data �             ���
// �������������������������������������������������������������������������͹��
// ���Descricao � Programa de importacao de Clientes                         ���
// ���          �								                           ���
// �������������������������������������������������������������������������͹��
// ���Uso       � 			                                             ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

User Function IMPSA1()

Local oDlg

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Lectura de archivo .CSV")
@ 02,10 TO 080,190 Title OemToAnsi("")
@ 10,018 Say " Este programa leer� el contenido de un archivo .csv, conforme"
@ 18,018 Say " los par�metros definidos por el usuario y va a grabar el contenido "
@ 26,018 Say " en la tabla SA1(Clientes). 								"

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

	// Quito espacios inicio y fin
	cLine:=AllTrim(cLine)
	// Convierto a ANSI
	cLine:=OEMToANSI(cLine)
	
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
	// Vai para a proxima linha
	//FT_FSKIP()
EndDo

FClose( oArch:nFileHandler )

If !lError
	Processa({|| GrabaSA1(aCabec,aImport)})
Endif

Return

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � Grava    � Autor � Ivaldo Junior      � Data �  27/02/09   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     �Executa a importa��o dos registros.                         ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function GrabaSA1(aCabec,aImport)

Local nX 		:= 0
Local nCpo      := 0
Local cCod      := ""
Local nPosCod   := 0
Local nPosLoj   := 0
Local nCantErr  := 0
Local lsalir    := .F.
Local aNoCpos   := {"A1_FILIAL"}
Local cDirLog   := "\log\"
Local cSubdir   := "clientes\"

Private lMsErroAuto 	:= .F.
Private aVector       	:= {}

ProcRegua(Len(aImport))

nPosCod := aScan( aCabec,{|x| allTrim(x) == "A1_COD" })
nPosLoj := aScan( aCabec,{|x| allTrim(x) == "A1_LOJA" })
For nX:=1 To Len(aImport)
	IncProc("Importaci�n: Insertando registro "+AllTrim( Str(nX) )+" de "+AllTrim( Str(Len(aImport)) ))
	
	aVector  := {}
	DbSelectArea("SA1")
	DbSetOrder(1)
	

	If nPosCod+nPosLoj > 0 .And. !DbSeek( xFilial("SA1")+aImport[nX][nPosCod]+aImport[nX][nPosLoj])
	
		For nCpo := 1 To Len(aCabec)
			//If !esVisual(aCabec[nCpo])
			If !Empty(aCabec[nCpo]) .And. aScan( aNoCpos,{|x| x == Alltrim(aCabec[nCpo]) }) == 0 .And.; 
			    u_esUsado(aCabec[nCpo])
				If Alltrim(aCabec[nCpo]) == "A1_CONTA"
					aImport[nX][nCpo] := u_buConta(aImport[nX][nCpo])
				Elseif Alltrim(aCabec[nCpo]) == "A1_TRANSP"
					aImport[nX][nCpo] := buTransp(aImport[nX][nCpo])
				Elseif Alltrim(aCabec[nCpo]) == "A1_COND" .And. !empty(aImport[nX][nCpo])
					aImport[nX][nCpo] := "V"+allTrim(aImport[nX][nCpo])
				ENDIF
				
				Aadd(aVector,{Alltrim(aCabec[nCpo]),valorCpo(aCabec[nCpo],aImport[nX][nCpo]),Nil})
			Endif
		Next nCpo
		
		MSExecAuto({|x,y| mata030(x,y)},aVector,3)   
						
		If lMsErroAuto
			ProcLogAtu("ERRO",'Atenci�n',"Error en la importaci�n de Clientes")
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


CLASS TA_ARCHXLINEAS

	DATA cFileName
	DATA nFileHandler     
	DATA cBuffer  
	DATA nBufferMaxSize     	// Tama�o maximo del buffer
	DATA nBufferSize     			// Tama�o del buffer actual
	DATA nBufferPos      			// Posicion del cursor en el buffer
	DATA nFilePos     				// Posicion del cursor en el archivo
	DATA nFileSize           		// Tama�o del archivo 
	DATA cEOL						// Caracter EOL
	DATA nTotLineFile               // Cantidad total de lineas del archivo

	METHOD new() CONSTRUCTOR
	METHOD leerLinea()
	METHOD abrirArchivo()
	METHOD totLineFile()
	METHOD cerrarArchivo()
	METHOD finArchivo()
	METHOD cargarBuffer()
	METHOD reset()

ENDCLASS

//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa   � new      � Autor � Nahuel Espindola  � Fecha � 06/07/2010 ���
//�������������������������������������������������������������������������͹��
//���Descripcion�                                                           ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������

METHOD new(cArch) CLASS TA_ARCHXLINEAS

	// Inicializo valores por default
	::reset()

	::cFileName := cArch
	
	// Cargo las cantidad de lineas del archivo
	::totLineFile()
	
	::abrirArchivo()	

RETURN SELF          

//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa   � reset    � Autor � Nahuel Espindola  � Fecha � 06/07/2010 ���
//�������������������������������������������������������������������������͹��
//���Descripcion�                                                           ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
                                
METHOD reset() CLASS TA_ARCHXLINEAS
                                              
	// Valores por default
	::cFileName := ""
	::nFileHandler     := Nil
	::cBuffer  := ""
	::nBufferMaxSize := 50000     // Tama�o del buffer
	::nBufferSize  := 0         // Tama�o real del buffer
	::nBufferPos  := 1         // Posicion del cursor en el buffer
	::nFilePos  := 0         // Posicion de lectura en el archivo
	::nFileSize    := 0      // Tama�o del archivo
	//::cEOL := CRLF        // Caracter EOL
	::cEOL := Chr(10)        // Caracter EOL
	::nTotLineFile := -1  //Cantidad de Lineas del Archivo Abierto
	    
RETURN                                      


//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa� abrirArchivo � Autor � Nahuel Espindola  � Fecha � 06/07/2010���
//�������������������������������������������������������������������������͹��
//���Descripcion�  Abre el archivo                                          ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//
// Abre el archivo
// 
//       
METHOD abrirArchivo() CLASS TA_ARCHXLINEAS 

::nFileHandler := FOpen(::cFileName , FO_READ + FO_SHARED )
If ::nFileHandler == -1   
   MsgStop("Error abriendo archivo " + ::cFileName + " : FERROR " + STR(FError(),4))
   Return ::nFileHandler
EndIf
	 
// Obtengo el size del archivo
::nFileSize := FSEEK(::nFileHandler, 0, FS_END)       

// Posiciono al comienzo
FSEEK(::nFileHandler, 0)

Return ::nFileHandler                       

//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa   � new      � Autor � Nahuel Espindola  � Fecha � 06/07/2010 ���
//�������������������������������������������������������������������������͹��
//���Descripcion�  Lee una linea de un archivo abierto                      ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������

METHOD leerLinea(cLineaRet) CLASS TA_ARCHXLINEAS

Local nNumRead:=0
Local nBuffAux:= 0                  
Local cBufferTmp:= ""
Local nEol:=0               

cLineaRet := ''          

// Busco el prox EOL
nEol := AT( ::cEOL, SubStr(::cBuffer, ::nBufferPos))

// Itero hasta que en el buffer
// haya un EOL o un EOF
While nEol == 0

	::cargarBuffer()		

	// Busco el prox EOL
	nEol := AT( ::cEOL, SubStr(::cBuffer, ::nBufferPos))
	
	// Chequeo si no lo encontro por EOF
	// Entonces la linea es lo que queda del archivo
	If nEol == 0 .And. (::nFilePos + ::nBufferSize) >= ::nFileSize
		nEol := ::nBufferSize  
	EndIf  

End	                                                   

// Obtengo la linea (el ultimo caracter es el CRLF)
cLineaRet := SUBSTR( ::cBuffer, ::nBufferPos, nEol - 1)

::nBufferPos += nEol //+ 1     //Se comenta el +1 ya que me quita el primer caracter de la siguiente linea

Return nEol <> 0

//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa � cargarBuffer � Autor � Nahuel Espindola � Fecha � 06/07/2010���
//�������������������������������������������������������������������������͹��
//���Descripcion�                                                           ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������

METHOD cargarBuffer() CLASS TA_ARCHXLINEAS

Local nCarLeidos,cBufferTmp

// Modifico el buffer
// Sacando todo lo que ya fue leido
::cBuffer:= SubStr(::cBuffer, ::nBufferPos)

// Vuelvo a cero las posiciones
::nBufferSize := Len(::cBuffer)
::nBufferPos := 1

cBufferTmp := ""
		
// Leo del archivo y lo agrego al buffer
nCarLeidos:= FREAD( ::nFileHandler, @cBufferTmp, ::nBufferMaxSize)	
::cBuffer += cBufferTmp             

// Incremento posicion buffer y archivo
::nBufferSize += nCarLeidos
::nFilePos += nCarLeidos

Return nCarLeidos <> 0                                        

//�����������������������������������������������������������������������������
//������������������������������������������������������������������������������ͻ��
//���Programa   � cerrarArchivo � Autor � Nahuel Espindola  � Fecha � 06/07/2010 ���
//������������������������������������������������������������������������������͹��
//���Descripcion�                                                           ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������

METHOD cerrarArchivo() CLASS TA_ARCHXLINEAS
// Cierro archivo
FClose(::nFileHandler)                                                                                                

// Reseteo parametros
::reset()

Return

//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa � finArchivo � Autor � Nahuel Espindola  � Fecha � 06/07/2010 ���
//�������������������������������������������������������������������������͹��
//���Descripcion�                                                           ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������

METHOD finArchivo() CLASS TA_ARCHXLINEAS
// Si recorrio todo el buffer y el archivo              
Return (::nBufferPos >= ::nBufferSize) .And. (::nFilePos >= ::nFileSize)   

//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  �totLineFile � Autor � Nahuel Espindola � Fecha � 06/07/2010 ���
//�������������������������������������������������������������������������͹��
//���Descripcion�                                                           ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������

METHOD totLineFile() CLASS TA_ARCHXLINEAS
        
        If (::nTotLineFile == -1)
			FT_FUSE(::cFileName)
        	::nTotLineFile := FT_FLASTREC()
        	FT_FUSE() 
        EndIf
        
return 


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
// ���Programa  � buConta  � Autor � Ariel Gel          � Data �  21/06/11   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     � Para el codigo resumido retorna el codigo completo         ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

User Function buConta(cContRes)

Local aArea    := GetArea()
Local aAreaCT1 := CT1->(GetArea())
Local cConta   := ""

If !Empty(cContRes)
	CT1->(dbSetOrder(2))
	If CT1->(DbSeek( xFilial( "CT1" ) + PadR(cContRes,TamSX3("CT1_RES")[1])))
		cConta := CT1->CT1_CONTA
	Endif
Endif

RestArea(aAreaCT1)
RestArea(aArea)

Return cConta

// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������
// �������������������������������������������������������������������������ͻ��
// ���Programa  � buTransp � Autor � Ariel Gel          � Data �  25/06/11   ���
// �������������������������������������������������������������������������͹��
// ���Desc.     � Para el codigo de transp del sim retorna el codigo         ���
// ���          �                                                            ���
// �������������������������������������������������������������������������͹��
// ���Uso       � AP                                                         ���
// �������������������������������������������������������������������������ͼ��
// �����������������������������������������������������������������������������
// �����������������������������������������������������������������������������

Static Function buTransp(cTraspSim)

Local aArea    := GetArea()
Local aAreaSA4 := SA4->(GetArea())
Local cTransp   := ""

If !Empty(cTraspSim)
	SA4->(dbSetOrder(4))
	If SA4->(DbSeek( xFilial( "SA4" ) + PadR(cTraspSim,TamSX3("A4_XCODSIM")[1])))
		cTransp := SA4->A4_COD
	Endif
Endif

RestArea(aAreaSA4)
RestArea(aArea)

Return cTransp