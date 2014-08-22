#include "Protheus.ch"
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ HsrStat   ³ Autor ³ Diego Fernando Rivero ³ Data ³ XX/XX/XX ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Control de Errores para impresora Hasar.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ HASAR SMH/PL-8F                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ Ninguno                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ACTUALIZACIONES EFECTUADAS DESDE LA CODIFICACION INICIAL       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data   ³         Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function HsrStat( cPrinter, cFiscal, cTitle )

LOCAL nX, cMsg
LOCAL lRet    := .T.
LOCAL cBinPrn := Hex2Bin( cPrinter )
LOCAL cBinFis := Hex2Bin( cFiscal  )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificacion de Status de la Impresora                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄDieghoÄÄÙ
// Bit  0 - Siempre Cero
// Bit  1 - Siempre Cero
// Bit  2 - 1 = Error de Impresora
// Bit  3 - 1 = Impresora Off-line
// Bit  4 - 1 = Falta Papel del Diario
// Bit  5 - 1 = Falta Papel de Tickets
// Bit  6 - 1 = Buffer de Impresora Lleno
// Bit  7 - 1 = Buffer de Impresora Vacio
// Bit  8 - 1 = Tapa de Impresora Abierta
// Bit  9 - Siempre Cero
// Bit 10 - Siempre Cero
// Bit 11 - Siempre Cero
// Bit 12 - Siempre Cero
// Bit 13 - Siempre Cero
// Bit 14 - 1 = Cajon de dinero cerrado o ausente
// Bit 15 - 1 = OR logico de los bits 2-5, 8 y 14

If     SubStr( cBinPrn, 14, 1 ) == '1'  // Bit 2
	MsgAlert( 'Error de Impresora Fiscal' , 'Verificar Problema' )

ElseIf SubStr( cBinPrn, 13, 1 ) == '1'  // Bit 3
	MsgAlert( 'Impresora Fiscal Off-Line!' , 'Verificar Problema' )

ElseIf SubStr( cBinPrn, 12, 1 ) == '1'  // Bit 4
	MsgAlert( 'Falta Papel en Impresora Fiscal' , 'Verificar Problema' )

ElseIf SubStr( cBinPrn, 11, 1 ) == '1'  // Bit 5
	MsgAlert( 'Falta Papel en Impresora Fiscal' , 'Verificar Problema' )

ElseIf SubStr( cBinPrn, 10, 1 ) == '1'  // Bit 8
	MsgAlert( 'Tapa de Impresora Abierta!', 'Verificar Problema' )

EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificacion de Status Fiscal                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄDieghoÄÄÙ
// Bit  0 - 1 = Error en chequeo de memoria fiscal
// Bit  1 - 1 = Error en chequeo de memoria de trabajo
// Bit  2 - Siempre Cero
// Bit  3 - 1 = Comando Desconocido
// Bit  4 - 1 = Datos no validos en un campo
// Bit  5 - 1 = Comando no valido para el estado fiscal actual
// Bit  6 - 1 = Desborde del Total
// Bit  7 - 1 = Memoria Fiscal llena, bloqueada o dada de baja
// Bit  8 - 1 = Memoria Fiscal a punto de llenarse
// Bit  9 - 1 = Terminal fiscal certificada
// Bit 10 - 1 = Terminal dfiscal fiscalizada
// Bit 11 - 1 = Error en ingreso de fecha
// Bit 12 - 1 = Documento Fiscal Abierto
// Bit 13 - 1 = Documento Abierto
// Bit 14 - Siempre Cero
// Bit 15 - 1 = OR logico de los bits 0 a 8

If Left( cBinFis, 1 ) == '1'   // Bit 15

	If     SubStr( cBinFis, 16, 1 ) == '1'  // Bit 0
		cMsg := 'Error en Chequeo de Memoria Fiscal. Terminal Bloqueada!'

	ElseIf SubStr( cBinFis, 15, 1 ) == '1'  // Bit 1
		cMsg := 'Error en Chequeo de Memoria de Trabajo. Terminal Bloqueada!'

	ElseIf SubStr( cBinFis, 13, 1 ) == '1'  // Bit 3
		cMsg := 'Comando Desconocido'

	ElseIf SubStr( cBinFis, 12, 1 ) == '1'  // Bit 4
		cMsg := 'Datos No Validos en un Campo'

	ElseIf SubStr( cBinFis, 11, 1 ) == '1'  // Bit 5
		cMsg := 'Comando No Valido para el Estado Fiscal Actual'

	ElseIf SubStr( cBinFis, 10, 1 ) == '1'  // Bit 6
		cMsg := 'Desborde del Total'

	ElseIf SubStr( cBinFis,  9, 1 ) == '1'  // Bit 7
		cMsg := 'Memoria Fiscal llena, bloqueada o dada de baja. Terminal Bloqueda!'

	ElseIf SubStr( cBinFis,  8, 1 ) == '1'  // Bit 8
		cMsg := 'Memoria Fiscal a Punto de Llenarse!'

	Else
		cMsg := 'Error no determinado en la Impresora Fiscal!'

	EndIf

	MsgAlert( cMsg, 'HASAR' + Iif( ValType(cTitle)<>'C', '', ' - ' + cTitle ) )
	lRet := .F.

EndIf

Return( lRet )


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ Hex2Bin   ³ Autor ³ Diego Fernando Rivero ³ Data ³ XX/XX/XX ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ HASAR SMH/PL-8F                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ Ninguno                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ACTUALIZACIONES EFECTUADAS DESDE LA CODIFICACION INICIAL       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data   ³         Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Hex2Bin( cHex )

LOCAL nX, cChar, nPos
LOCAL cRet := ''
LOCAL cAux := '0123456789ABCDEF'
LOCAL aHex := { '0000', '0001', '0010', '0011', '0100', '0101', '0110', '0111', ;
                '1000', '1001', '1010', '1011', '1100', '1101', '1110', '1111' }

For nX := 1 To Len( cHex )
	cChar := SubStr( cHex, nX, 1 )
	nPos  := At( cChar, cAux )
	If nPos <> 0
		cRet += aHex[nPos]
	EndIf
Next

Return( cRet )
