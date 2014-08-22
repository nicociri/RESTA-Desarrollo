#include 'protheus.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ BORRA_MIG³ Autor ³ ms			         ³Fecha ³ 05/11/03³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Migraci¢ de Datos y Borrado de Tablas                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                         		                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Ninguno                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ACTUALIZACIONES EFECTUADAS DESDE LA CODIFICACION INICIAL      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Fecha  ³         Motivo de la Alteracion                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function BORRAMIG

Private oSRA,oSRB,oSA2,oDEL,oSB1,oSE1,oSE2,oSD3,oSM2,oSF1,oSF2,oTruncate,oWhile,oMarkAll,;
        nOpc      := 0  ,;
        lSRA      := .F.,;
        lSRB      := .F.,;
        lDEL      := .F.,;
        lSA2      := .F.,;
        lSB1      := .F.,;
        lSE1      := .F.,;
        lSE2      := .F.,;
        lSF2      := .F.,;
        lSF1      := .F.,;
        lSD3      := .F.,;
        lSM2      := .F.,;
        lTruncate := .T.,;
        lMarkAll  := .F.,;
        lWhile    := .F.,;
        nHnd      := FOpen( 'MM.LOG', 2 )
Private oMainWnd    


DEFINE MSDIALOG oDlg TITLE OemToAnsi( "Migraci¢n - Limpieza de Datos" ) FROM 222, 091 TO 494, 696 OF oMainWnd PIXEL

@ 005, 005 TO 105,255 PROMPT OemToAnsi(" Migraciones Habilitadas ") OF oDlg PIXEL
@ 110, 005 TO 135,255 PROMPT OemToAnsi(" Opciones ")                OF oDlg PIXEL

@ 045, 015 CHECKBOX oDEL      VAR lDEL      PROMPT OemToAnsi("Limpia tablas.    ")            SIZE 075, 010 OF oDlg PIXEL

@ 120, 015 CHECKBOX oTruncate VAR lTruncate PROMPT OemToAnsi("Truncar Tablas")               SIZE 075, 010 OF oDlg PIXEL
//@ 120, 075 CHECKBOX oMarkAll  VAR lMarkAll  PROMPT OemToAnsi("Marcar Todo")                  SIZE 075, 010 OF oDlg PIXEL ON CHANGE MMMarkAll()
//@ 120, 150 CHECKBOX oWhile    VAR lWhile    PROMPT OemToAnsi("Usar While y For")             SIZE 075, 010 OF oDlg PIXEL WHEN .F.

DEFINE SBUTTON oBtnOk FROM 007, 260 TYPE 1 ACTION ( nOpc := 1, oDlg:End() ) ENABLE OF oDlg PIXEL
DEFINE SBUTTON oBtnCn FROM 025, 260 TYPE 2 ACTION oDlg:End()                ENABLE OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

If lDEL .and. nOpc == 1
   Processa( {|| LimpiaDB() }, 'Limpiando Tablas...'   , 'Aguarde Por Favor... ' )
EndIf

FClose( nHnd )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ BORRA_MIG³ Autor ³ ms				     ³Fecha ³ 05/11/03³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Migraci¢ de Datos y Borrado de Tablas                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                             		              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Ninguno                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ACTUALIZACIONES EFECTUADAS DESDE LA CODIFICACION INICIAL      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Fecha  ³         Motivo de la Alteracion                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LimpiaDB()
If lTruncate
   #IFDEF TOP
      cQuery   := 'TRUNCATE TABLE ' + RetSqlName('SA5')     // vinculo prod/prov
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SA7')     // vinc. prod/cliente
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SAD')     
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SAC')     
      TCSqlExec( cQuery )
      //------------------------------------------
      cQuery   := 'DROP TABLE ' + RetSqlName('SB2')     // saldos stock
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SB3')     // demandas
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SB6')     // saldos 3ros
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SB8')     // saldos x lote
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SB9')     // saldos iniciales
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SBC')     //  perdidas x op
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SBI')     //  prod vs precios
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SBJ')     
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SBK')     
      TCSqlExec( cQuery )
      //--------------------------------------------
      cQuery   := 'DROP TABLE ' + RetSqlName('SC0')     // reservas para fact.
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SC1')     // solic. compra
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SC2')     //  OP
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SC3')
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SC4')     //  OP
      TCSqlExec( cQuery )
	  cQuery   := 'DROP TABLE ' + RetSqlName('SC5')    // ped. venta cab.
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SC6')    // ped. venta det.
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SC7')    // pedido compras
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SC8')    // cotizacion
      TCSqlExec( cQuery )                                                       
      cQuery   := 'DROP TABLE ' + RetSqlName('SC9')    // aprob. ped. ventas
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SCE')    // CIERRE DE COTIZ.
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SCJ')    // PRESUP
      TCSqlExec( cQuery )                           
      cQuery   := 'DROP TABLE ' + RetSqlName('SCK')    // ITEMS PRESUP
      TCSqlExec( cQuery )    
      cQuery   := 'DROP TABLE ' + RetSqlName('SCL')
      TCSqlExec( cQuery )                           
      cQuery   := 'DROP TABLE ' + RetSqlName('SCM')    // ARCH. REMITOS
      TCSqlExec( cQuery )    
      cQuery   := 'DROP TABLE ' + RetSqlName('SCN')
      TCSqlExec( cQuery )                           
      cQuery   := 'DROP TABLE ' + RetSqlName('SCP')
      TCSqlExec( cQuery )                           
      cQuery   := 'DROP TABLE ' + RetSqlName('SCQ')    // REQUISICIONES PREVIAS
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SCR')    // aprob. ped. compras
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SCY')    // HISTORIAL PED.COMPRAS
      TCSqlExec( cQuery )
      //--------------------------------------------
      cQuery   := 'DROP TABLE ' + RetSqlName('SD1')     // doc.entrada/detalle
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SD2')    // doc.salida/detalle
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SD3')    // mov. internos
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SD4')    //  reservas
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SD5')    // mov. interno x lote
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SD6')     
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SD7')     
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SD8')     
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SDC')     
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SDE')     
      TCSqlExec( cQuery )
      //-------------------------------------------
      cQuery   := 'DROP TABLE ' + RetSqlName('SF1')      // doc. entrada / cabec
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SF2')      // doc. salida /cabec
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SF3')     // libro iva
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SFE')  // certificados
      TCSqlExec( cQuery )
      //-------------------------------------------
      cQuery   := 'DROP TABLE ' + RetSqlName('SE1')    // titulos x cobrar
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SE2')    // titulos x pagar
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SE5')  // mov. bancarios
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SE8')  // mov. bancarios
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SEF')  // recibos
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SEK')  // recibos
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SEL')   // o pago
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SET')   // o pago
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SEU')   // o pago
      TCSqlExec( cQuery )
      //----------------------------------
      cQuery   := 'DROP TABLE ' + RetSqlName('ADA')
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('ADB')
      TCSqlExec( cQuery )
      //----------------------------------
      cQuery   := 'DROP TABLE ' + RetSqlName('CT2')    // asientos 
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('CT3')    // asientos 
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('CT6')   // saldos x cuenta
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('CT7')
      TCSqlExec( cQuery )                            
      cQuery   := 'DROP TABLE ' + RetSqlName('CTC')
      TCSqlExec( cQuery )                            
      cQuery   := 'DROP TABLE ' + RetSqlName('CTU')
      TCSqlExec( cQuery )                            
      cQuery   := 'DROP TABLE ' + RetSqlName('CTV')
      TCSqlExec( cQuery )                            
      cQuery   := 'DROP TABLE ' + RetSqlName('CTW')
      TCSqlExec( cQuery )                            
      cQuery   := 'DROP TABLE ' + RetSqlName('CTX')
      TCSqlExec( cQuery )                            
      //-----------------------------------------
      cQuery   := 'DROP TABLE ' + RetSqlName('SL1')
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SL2')
      TCSqlExec( cQuery )
      cQuery   := 'DROP TABLE ' + RetSqlName('SL4')
      TCSqlExec( cQuery )
      
   #ENDIF
   //CloseOpen( { 'CT2', 'CT6','CT7', 'ADA', 'ADB', 'SB2', 'SB8', 'SC5', 'SC8', 'SC6', 'SC7','SC9', 'SCR', 'SD1', 'SD2', 'SD3', 'SD4', 'SD5', 'SF1', 'SF2', 'SF3', 'SE1', 'SE2','SE5','SEK','SFE','SEL','SC1','SE8','SEF','SEU','SC3','SB9','SCP','SCQ' },;
    //          { 'CT2', 'CT6','CT7', 'ADA', 'ADB', 'SB2', 'SB8', 'SC5', 'SC8', 'SC6', 'SC7','SC9', 'SCR', 'SD1', 'SD2', 'SD3', 'SD4', 'SD5', 'SF1', 'SF2', 'SF3', 'SE1', 'SE2','SE5','SEK','SFE','SEL','SC1','SE8','SEF','SEU','SC3','SB9','SCP','SCQ' } )
EndIf

Return
