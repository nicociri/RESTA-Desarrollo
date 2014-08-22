#include "protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ ARFIN003 ³ Autor ³ Diego Fernando Rivero ³ Fecha³ 01/12/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Transferencia entre carteras de cheques                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxis  ³ U_WFina010( void )                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Ninguno                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Witcel                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Ninguno                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ARFIN003
Local bOK         := { || nOpca := 1, If( WF010TOk(), oDlg:End(), nOpca := 0 ) }
Local bcancel     := { || oDlg:End() }
Local nMedio      := 0
Local lOk         := .F.  
Local nX          := 0
Local aColsLF	:= {}
Local aHeadLF	:= {}
Local aColsLin	:= {}
Private cLote     := GetNewPar('MV_WF010LT', '980000')
Private cArquivo
Private cClienteDe:= Space(6)
Private cClienteAte := 'zzzzzz'
Private dDataDe   := dDataBase
Private dDataAte  := dDataBase + 30
Private dDataVDe   := dDataBase
Private dDataVAte  := dDataBase + 30
Private nTotals	   := 0
Private oClienteAte
Private oClienteDe
Private oDataAte
Private oTotalS
Private oDataDe
Private oDataVAte
Private oDataVDe
Private oOk       := LoadBitmap( GetResources(), "LBOK" )
Private oNo       := LoadBitmap( GetResources(), "LBNO" )
Private  nOpca    := 0
Private  oDlg
Private  aChq     := {}
Private  oChq
Private  aButtons := {}
Private  aRecs    := {}
Private lPadrao   := VerPadrao( '051' ) .and. VerPadrao( '052' )
Private cPerg     := Padr( 'ARFIN003', 10 )
Private  oDlg,;
         aBcoOri  := {},;
         aBcoDes  := {},;
         cBcoOri  := '',;
         cBcoDes  := ''

ValidPerg()

If !Pergunte( cPerg, .T. )
   Return
EndIf
                     
AADD(aHeadLF,{"Numero de cheque", "C",12,} )
AADD(aHeadLF,{"Valor del cheque", "N",17,2} )
AADD(aHeadLF,{"Codico de banco", "C",3,} )
AADD(aHeadLF,{"Sucursal banco", "C",3,} )
AADD(aHeadLF,{"Cuenta Bancaria", "C",10,} )
AADD(aHeadLF,{"Nombre Banco ", "C",50,} )
AADD(aHeadLF,{"Fecha Emisión", "D",8,} )
AADD(aHeadLF,{"Fecha Vencimiento", "D",8,} )
AADD(aHeadLF,{"Cod Firmante", "C",13,} )
AADD(aHeadLF,{"Nombre Firmante", "C",50,} )
AADD(aHeadLF,{"Origen", "C",20,} )
AADD(aHeadLF,{"a la Orden?", "C",2,} )
AADD(aHeadLF,{"Transferencia", "C",20,} )


Aadd( aButtons, {"LIQCHECK",{|| MsAguarde( { || U_WFi010MrkA() } )}, OemToAnsi("Invertir Selecci¢n" )})
Aadd( aButtons, {"FILTRO",  {|| MsAguarde( { || U_WFi010FC()   } )}, OemToAnsi("Filtrar Cheques" )})


MsAguarde( { || lOk := CargaBancos() }, 'Inicializando Datos...' )

If !lOk
   MsgStop('No se han encontrados Bancos para Cartera!' )
   Return
EndIf


DEFINE MSDIALOG oDlg TITLE 'Transferencias de Carteras' FROM C(204),C(228) TO C(671),C(914) PIXEL

@ C(015),C(005) TO C(070),C(340) LABEL " Datos del Filtro " PIXEL OF oDlg
@ C(075),C(005) TO C(225),C(340) LABEL " Cheques "          PIXEL OF oDlg

@ C(030),C(010) SAY "Caja Origen:"  SIZE C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(030),C(175) SAY "Caja Destino:" SIZE C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(045),C(010) SAY "Emision     :"  SIZE C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(045),C(090) SAY "A"             SIZE C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(045),C(175) SAY "Clientes:"     SIZE C(025),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(045),C(263) SAY "A"             SIZE C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(060),C(010) SAY "Vencimiento:"  SIZE C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(060),C(090) SAY "A"             SIZE C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(060),C(175) SAY "Total Seleccionado :"  SIZE C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg

@ C(030),C(052) COMBOBOX cBcoOri ITEMS aBcoOri SIZE C(100),C(010) PIXEL OF oDlg
@ C(030),C(225) COMBOBOX cBcoDes ITEMS aBcoDes SIZE C(100),C(010) PIXEL OF oDlg

@ C(044),C(052) MSGET oDataDe     VAR dDataDe     SIZE C(030),C(009) COLOR CLR_BLACK Picture "@D 99/99/99" PIXEL OF oDlg
@ C(045),C(100) MSGET oDataAte    VAR dDataAte    SIZE C(030),C(009) COLOR CLR_BLACK Picture "@D 99/99/99" PIXEL OF oDlg
@ C(045),C(225) MSGET oClienteDe  VAR cClienteDe  SIZE C(030),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg  F3 'SA1'
@ C(045),C(275) MSGET oClienteAte VAR cClienteAte SIZE C(030),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg  F3 'SA1'
@ C(060),C(052) MSGET oDataVDe     VAR dDataVDe     SIZE C(030),C(009) COLOR CLR_BLACK Picture "@D 99/99/99" PIXEL OF oDlg
@ C(060),C(100) MSGET oDataVAte    VAR dDataVAte    SIZE C(030),C(009) COLOR CLR_BLACK Picture "@D 99/99/99" PIXEL OF oDlg
@ C(060),C(225) SAY ototals    PROMPT transform(ntotals,"@E 999,999,999.99")    SIZE C(030),C(009) COLOR CLR_BLACK  PIXEL OF oDlg


Aadd( aChq, { .F., '', '', '', '', '', '', '', '', '', '','','','' } )

@ C(085),C(010)   LISTBOX oChq FIELDS;
                  HEADER   OemToAnsi(""),;
                           OemToAnsi("N£mero"),;
                           OemToAnsi("Vencto."),;
                           OemToAnsi("Valor"),;
                           OemToAnsi("Cliente"),;
                           OemToAnsi("Razon Social"),;
                           OemToAnsi("Emision"),;
                           OemToAnsi("Banco"),;
                           OemToAnsi("Agencia"),;
                           OemToAnsi("Conta"),;
                           OemToAnsi("Banco cheque"),;
                           OemToAnsi("Descripcion"),;
                           OemToAnsi("CUIT"),;
                           OemToAnsi("Observ.");
                  COLSIZES 15,;
                           GetTextWidth(0,Replicate('B',12)),;
                           GetTextWidth(0,Replicate('B',08)),;
                           GetTextWidth(0,Replicate('B',17)),;
                           GetTextWidth(0,Replicate('B',06)),;
                           GetTextWidth(0,Replicate('B',30)),;
                           GetTextWidth(0,Replicate('B',08)),;
                           GetTextWidth(0,Replicate('B',03)),;
                           GetTextWidth(0,Replicate('B',05)),;
                           GetTextWidth(0,Replicate('B',10)),;
                           GetTextWidth(0,Replicate('B',03)),;
                           GetTextWidth(0,Replicate('B',30)),;
                           GetTextWidth(0,Replicate('B',16)),;
                           GetTextWidth(0,Replicate('B',20));
                  SIZE C(325),C(115) ;
                  ON DBLCLICK (WF010Mark()) ;
                  OF oDlg PIXEL

oChq:SetArray(aChq)

oChq:bLine := { || { If(aChq[oChq:nAt,01],oOk,oNo),;
                        aChq[oChq:nAt,02],;
                        aChq[oChq:nAt,03],;
                        Transform( aChq[oChq:nAt,04], '@E 999,999,999.99' ),;
                        aChq[oChq:nAt,05],;
                        aChq[oChq:nAt,06],;
                        aChq[oChq:nAt,07],;
                        aChq[oChq:nAt,08],;
                        aChq[oChq:nAt,09],;
                        aChq[oChq:nAt,10],;
                        aChq[oChq:nAt,11],;
                        aChq[oChq:nAt,12],;
                        aChq[oChq:nAt,13],;
                        aChq[oChq:nAt,14] } }

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, bOK, bcancel,, aButtons ) CENTERED

If nOpca == 1

   nHdlPrv     := 0
   nTotal      := 0
   SA6->(DbSetOrder(1))


   If lPadrao .and. mv_par01 == 1
      nHdlPrv  := HeadProva(cLote,"ARFIN003",Substr(cUsuario,7,6),@cArquivo)
   EndIf
	_cNumTr	:= 	getsx8num("SE1","E1_XTRANFE")
	If (_cNumTr := GetMV('MV_XDOCTRAN')) # Nil
			cDocTran := Soma1(_cNumTr)
			PutMV('MV_XDOCTRAN',cDocTran)
	EndIf		
   For nX := 1 To Len( aChq )

      If !aChq[nX][1]
         Loop
      EndIf

      SA6->(DbSeek( xFilial('SA6') + SubStr( cBcoOri, 01, 03 ) + SubStr( cBcoOri, 05, 05 ) + SubStr( cBcoOri, 11, 10 ) ))
      SE1->(DbGoTo( aRecs[nX] ))

      If lPadrao .and. mv_par01 == 1
         nTotal   += DetProva(nHdlPrv,'051',"ARFIN003",cLote)
      EndIf

      RecLock('SE1', .F.)
      Replace E1_PORTADO With SubStr( cBcoDes, 01, 03 )
      Replace E1_AGEDEP  With SubStr( cBcoDes, 05, 05 )
      Replace E1_CONTA   With SubStr( cBcoDes, 11, 10 )                      
      Replace E1_XTRANFE With  _cNumTr
      MsUnLock()
      Reclock("ZXZ",.T.)
      Replace ZXZ_FILIAL WITH XFILIAL("ZXZ")
      Replace ZXZ_BANDES With SubStr( cBcoDes, 01, 03 )
      Replace ZXZ_AGENDE  With SubStr( cBcoDes, 05, 05 )
      Replace ZXZ_CTADES   With SubStr( cBcoDes, 11, 10 )
      Replace ZXZ_CAJAOR With SubStr( cBcoOri, 01, 03 )
      Replace ZXZ_AGENOR  With SubStr( cBcoOri, 05, 05 )
      Replace ZXZ_CTAORI   With SubStr( cBcoOri, 11, 10 )
      Replace ZXZ_TRANSF With  _cNumTr
      Replace ZXZ_EMISSA With  dDatabase
      Replace ZXZ_RECSE1 With  SE1->(RECNO())
       
      MsUnlock()
      
      SA6->(DbSeek( xFilial('SA6') + SubStr( cBcoDes, 01, 03 ) + SubStr( cBcoDes, 05, 05 ) + SubStr( cBcoDes, 11, 10 ) ))
                                     

      If lPadrao .and. mv_par01 == 1
         nTotal   += DetProva(nHdlPrv,'052',"ARFIN003",cLote)
      EndIf
		ZZZ->(DBSETORDER(1))
		ZZZ->( dbSeek( xFilial( "ZZZ" ) + SE1->E1_BCOCHQ , .F. ) )
		cDescBco :=  ZZZ->ZZZ_XDESCR
		//aColsLin:={CHR(160)+SE1->E1_NUM,SE1->E1_VALOR,chr(160)+SE1->E1_BCOCHQ,chr(160)+SE1->E1_AGECHQ,chr(160)+SE1->E1_CTACHQ,;
		//cDescBco,SE1->E1_EMISSAO,SE1->E1_VENCTO,cCUIT	   := TRANSFORM(SE1->E1_GCCUIT,"@R 99-99999999-9"),SE1->E1_GCFIRM,iF(SE1->E1_GCORIG== '1', "Cliente","Tercero"),;
		aColsLin:={CHR(160)+SE1->E1_NUM,SE1->E1_VALOR,chr(160)+SE1->E1_BCOCHQ,chr(160)+SE1->E1_AGECHQ,chr(160)+SE1->E1_CTACHQ,;
		cDescBco,SE1->E1_EMISSAO,SE1->E1_VENCTO,cCUIT	   := "CUIT","FIRMANTE","Cliente",;
		"SI",chr(160)+_cNumTr}      
		aAdd(aColsLin,.F.)
		aAdd(aColsLF, (aColsLin))
		aColsLin := {}					

   Next
                                      
	ConfirmSX8()
	If MsgYesNo(OemToAnsi("Desea pasar a un archivo de excel?"))
		DlgToExcel({ {"GETDADOS","Transferencia de cheques",aHeadLF,aColsLF}})
	EndIf
	
   If lPadrao .and. nTotal > 0 .and. mv_par01 == 1
      RodaProva( nHdlPrv, nTotal )
      CTB_Incl(cArquivo, nHdlPrv, 3, cLote, mv_par02 == 1, .F. )
   EndIf


   MsgInfo( OemToAnsi( 'Los Cheques fueron transferidos! Numero de Transferencia : ' + _cNumTr ), OemToAnsi( 'Confirmaci¢n' ) )

EndIf


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Diego Fernando Rivero ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function WFi010FC
Local cAliasSE1:= 'TRB'
Local cPortado := SubStr( cBcoOri, 01, 03 )
Local cAgencia := SubStr( cBcoOri, 05, 05 )
Local cConta   := SubStr( cBcoOri, 11, 10 )

BeginSql Alias cAliasSE1
   COLUMN E1_VENCTO  AS DATE
   COLUMN E1_EMISSAO AS DATE
   COLUMN E1_VALOR   AS NUMERIC(14,2)
   COLUMN RECNO      AS NUMERIC(14,2)
//   SELECT A.E1_NUM, A.E1_VENCTO, A.E1_VALOR, A.E1_CLIENTE, B.A1_NREDUZ,
//          A.E1_EMISSAO, A.E1_PORTADO, A.E1_AGEDEP, A.E1_CONTA,A.E1_BCOCHQ,A.E1_GCCUIT, A.R_E_C_N_O_ AS RECNO
   SELECT A.E1_NUM, A.E1_VENCTO, A.E1_VALOR, A.E1_CLIENTE, B.A1_NREDUZ,
          A.E1_EMISSAO, A.E1_PORTADO, A.E1_AGEDEP, A.E1_CONTA,A.E1_BCOCHQ,B.A1_CGC, A.R_E_C_N_O_ AS RECNO
   FROM %Table:SE1% A
   LEFT JOIN %Table:SA1% B ON B.A1_COD = A.E1_CLIENTE AND B.A1_LOJA = A.E1_LOJA
   WHERE  A.E1_FILIAL = %xFilial:SE1%
      AND B.A1_FILIAL = %xFilial:SA1%
      AND A.E1_CLIENTE BETWEEN %Exp:cClienteDe% AND %Exp:cClienteAte%
      AND A.E1_EMISSAO BETWEEN %Exp:DtoS(dDataDe)% AND %Exp:DtoS(dDataAte)%
      AND A.E1_VENCTO BETWEEN %Exp:DtoS(dDataVDe)% AND %Exp:DtoS(dDataVAte)%
      AND A.E1_PORTADO = %Exp:cPortado%
      AND A.E1_AGEDEP = %Exp:cAgencia%
      AND A.E1_CONTA = %Exp:cConta%
      AND A.E1_TIPO = "CH "
      AND A.E1_SALDO <> 0
      AND A.%NotDel%
      AND B.%NotDel%
   ORDER BY E1_VENCTO
EndSql

DbSelectArea(cAliasSE1)
DbGoTop()

aChq  := {}
aRecs := {}

While !Eof()
   //Aadd( aChq, { if(MV_PAR03=1,.T.,.F.), E1_NUM, E1_VENCTO, E1_VALOR,;
   //              E1_CLIENTE, A1_NREDUZ, DtoS(E1_EMISSAO), E1_PORTADO, E1_AGEDEP, E1_CONTA,E1_BCOCHQ,Posicione("ZZZ",1,Xfilial("ZZZ")+E1_BCOCHQ,"ZZZ_XDESCR"),TRANSFORM(E1_GCCUIT,"@R 99-99999999-9") , '',  } )
   Aadd( aChq, { if(MV_PAR03=1,.T.,.F.), E1_NUM, E1_VENCTO, E1_VALOR,;
                 E1_CLIENTE, A1_NREDUZ, DtoS(E1_EMISSAO), E1_PORTADO, E1_AGEDEP, E1_CONTA,E1_BCOCHQ,Posicione("ZZZ",1,Xfilial("ZZZ")+E1_BCOCHQ,"ZZZ_XDESCR"),'CUIT' , '',  } )
   Aadd( aRecs, (cAliasSE1)->RECNO )
   DbSkip()
EndDo
acttotal(ochq)
If Len( aChq ) == 0
   Aadd( aChq, { .F., '', '', '', '', '', '', '', '', '', '','','','' } )
EndIf

DbSelectArea(cAliasSE1)
DbCloseArea()

oChq:SetArray(aChq)
oChq:bLine := { || { If(aChq[oChq:nAt,01],oOk,oNo),;
                        aChq[oChq:nAt,02],;
                        aChq[oChq:nAt,03],;
                        Transform( aChq[oChq:nAt,04], '@E 999,999,999.99' ),;
                        aChq[oChq:nAt,05],;
                        aChq[oChq:nAt,06],;
                        aChq[oChq:nAt,07],;
                        aChq[oChq:nAt,08],;
                        aChq[oChq:nAt,09],;
                        aChq[oChq:nAt,10],;
                        aChq[oChq:nAt,11],;
                        aChq[oChq:nAt,12],;
                        aChq[oChq:nAt,13] } }
oChq:Refresh()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Diego Fernando Rivero ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function WF010Mark

aChq[oChq:nAt][1] := !aChq[oChq:nAt][1]
ActTotal(oChq)
oChq:Refresh()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Diego Fernando Rivero ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function WFi010MrkA
Local nX := 0

For nX := 1 To Len( aChq )
   aChq[nX][1] := !aChq[nX][1]
Next                         
acttotal(ochq)
oChq:Refresh()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Diego Fernando Rivero ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function WF010TOk
Local lRet  := .T.,;
      nX    := 0

If cBcoOri == cBcoDes
   MsgStop( OemToAnsi('Los Banco de Origen y Destino son Iguales!'), 'Verifique' )
   lRet :=  .F.
EndIf

If Len( aRecs ) == 0 .and. lRet
   MsgStop( OemToAnsi('No se ha ejecutado ning£n filtro!'), 'Verifique' )
   lRet :=  .F.
EndIf

AEval( aChq, { |x| nX += If( x[1], 1, 0 ) } )

If nX == 0
   MsgStop( OemToAnsi('No se han marcado cheques para transferir!'), 'Verifique' )
   lRet :=  .F.
EndIf

If lRet
   lRet  := MsgYesNo( OemToAnsi('Desea Tranferir los Cheques Marcados?'), 'Confirme' )
EndIf

Return( lRet )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Diego Fernando Rivero ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CargaBancos
Local aArea    := GetArea(),;
      cCarteir := GetNewPar("MV_CARTEIR",""),;
      aBcos    := {}
      lOk      := .F.

DbSelectArea('SA6')
DbSetOrder(1)
DbGoTop()

While !Eof()
   If A6_COD $ cCarteir
      Aadd( aBcos, A6_COD+'/'+A6_AGENCIA+'/'+A6_NUMCON+' '+Alltrim(A6_NOME) )
   EndIf

   DbSkip()
EndDo

If Len( aBcos ) > 0
   aBcoOri  := aClone( aBcos )
   aBcoDes  := aClone( aBcos )
   cBcoOri  := aBcoOri[1]
   cBcoDes  := aBcoDes[1]
   lOk      := .T.
EndIf

RestArea( aArea )
Return( lOk )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Diego Fernando Rivero ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C(nTam)
Local nHRes := oMainWnd:nClientWidth
   If nHRes == 640
      nTam *= 0.8
   ElseIf (nHRes == 798).Or.(nHRes == 800)
      nTam *= 1
   Else
      nTam *= 1.28
   EndIf

   If "MP8" $ oApp:cVersion
      If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
         nTam *= 0.90
      EndIf
   EndIf
Return Int(nTam)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Diego Fernando Rivero ³ Data ³ 05/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()
Local aArea := GetArea()
Local i     := 0
Local j     := 0
Local aRegs := {}

dbSelectArea("SX1")
dbSetOrder(1)

AADD(aRegs,{cPerg,"01","Asiento On-Line ","Asiento On-Line ","Asiento On-Line ","mv_ch1" ,"N", 1,0,1,"C","","mv_par01","Si","Si","Si","","","No","No","No","","","","","","","","","","","","","","","","","","","",""} )
AADD(aRegs,{cPerg,"02","Ver Asiento     ","Ver Asiento     ","Ver Asiento     ","mv_ch2" ,"N", 1,0,1,"C","","mv_par02","Si","Si","Si","","","No","No","No","","","","","","","","","","","","","","","","","","","",""} )
AADD(aRegs,{cPerg,"03","Trae Chq Marcado","Trae Chq Marcado","Trae Chq Marcado","mv_ch3" ,"N", 1,0,1,"C","","mv_par03","Si","Si","Si","","","No","No","No","","","","","","","","","","","","","","","","","","","",""} )

For i:=1 to Len(aRegs)
   If !dbSeek(cPerg+aRegs[i,2])
      RecLock("SX1",.T.)
      For j:=1 to FCount()
         If j <= Len(aRegs[i])
            FieldPut(j,aRegs[i,j])
         Endif
      Next
      MsUnlock()
   Endif
Next

RestArea( aArea )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Diego Fernando Rivero ³ Data ³ 05/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ActTotal(oChqs)
Local nTotal   := 0
Local nCant    := 0  
Local nTotal	:= 0

for nx	:= 1 to len(aChq) 
If aChq[nx][1] 
If ValType(aChq[nx][4]) =='N'
ntotal	+= aChq[nx][4]          
endIf
EndIf
Next

oTotals:SetText( Transform( nTotal, '@E 999,999,999.99' ) )


oTotals:Refresh()


Return