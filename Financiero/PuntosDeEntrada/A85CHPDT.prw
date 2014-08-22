
#include 'protheus.ch'
#include 'vkey.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ A85CHPDT ³ Autor ³ Hugo Gabriel Bermudez  ³Fecha ³16/01/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Punto de Entrada en la seleccion de cheques de terceros.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINA085A (Ordenes de Pago)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Ninguno                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ACTUALIZACIONES EFECTUADAS DESDE LA CODIFICACION INICIAL      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Fecha  ³ BOPS ³  Motivo de la Alteracion                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Gabriel    ³16/01/07³      ³ Busqueda por numero de cheque.           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A85CHPDT

Local lAcepto     := .F.,;
lTerc       := .T.,;
aCheques    := {},;
lCart       := .F.,;
lMark       := .F.,;
oTerc,;
oDlg,;
oDlg1,;
oCart,;
oOrden,;     
aOrden,; 
nOrden,;
nOrden1
nOrden := 2  
Private cCheque     := Criavar("EK_NUM")//,;

DEFINE MSDIALOG oDlg FROM 65,000 TO 200,350  TITLE OemToAnsi("Pago con Cheques de Terceros.") PIXEL
@ 01,003 TO 068, 140 Label OemToAnsi("Datos del cheque")  Of oDlg PIXEL

@ 027,008 RADIO oOrden VAR nOrden ITEMS "Importe" , "Fecha Vto." , "Nro.Cheque"  SIZE 100,008 OF oDlg PIXEL

DEFINE SBUTTON FROM 35,145 Type 1 Action (lAcepto:=.T.,oDlg:End()) Of oDlg PIXEL ENABLE
DEFINE SBUTTON FROM 52,145 Type 2 Action oDlg:End() Of oDlg PIXEL ENABLE
ACTIVATE MSDIALOG oDlg CENTERED


nPosVlr  := Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_VALOR"})
	DbSelectArea("SE1")
	DbSetOrder(1) // E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	_cFltUsr := " Alltrim(SE1->E1_TIPO) $ 'CH-BO' .and. SE1->E1_SALDO > 0 "
	MSFilter( _cFLTUSR )
	While !EOF() //.And.   xFilial()+cCheque >= E1_FILIAL+E1_NUM
		If E1_SALDO > 0 .And. Alltrim(E1_TIPO)<> 'NP'.And. Alltrim(E1_TIPO) $ MVCHEQUE +'|BO' .And. (E1_SITUACA $ " 0" )//.AND. E1_CIRCUI=="JUN" // .Or. lCart) .And. E1_OK <> cMarcaE1
			AAdd(aCheques,{E1_SITUACA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_VALOR,E1_MOEDA,E1_EMISSAO,E1_VENCTO,E1_XESTADO,E1_TIPO,SE1->(Recno())})
		Endif
		DbSelectArea("SE1")
		DbSkip()
	Enddo

If Len(aCheques) == 0
	MsgInfo( 'No existe Cheque de Terceros con el numero ingresado.', OemToAnsi('Verifique parametros'))
else
    nOrden1 := iif(nOrden = 1, 5, iif(norden = 2 , 8, 3))
    asort(aCheques,,,{|x,y| x[nOrden1] < y[nOrden1]})
Endif

Return( aCheques )

Static Function vCodBar

If !empty(cCodBar)
	cCheque := Substr(cCodBar,12,8)+Space(4)
EndIf

Return (.T.)

