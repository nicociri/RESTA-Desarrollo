#include "protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ acoclien ³ Autor ³ Fernando Cardeza		³ Data ³   .  .    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Validacion para que no deje seleccionar acopio de otro      ³±±
±±³          ³ cliente en el pedido de ventas C5_XNROACO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACIONES SUFRIDAS DESDE EL DESARROLLO INICIAL                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ FECHA  ³ BOPS ³  MOTIVO DE LA ALTERACION                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User function acoclien(acopio)
Local lRet:=.T.        


//
//Validacion en Pedido de venta
//

If Funname()=='MATA410' .AND. inclui
	
	Z01->(DbSetOrder(1))
   	If Z01->(DbSeek(xFilial('Z01')+ M->C5_XNROACO))
   		If alltrim(M->C5_CLIENT)==alltrim(Z01->Z01_CLIENT) .AND. alltrim(M->C5_LOJACLI)==alltrim(Z01->Z01_LOJA)    
         	lRet	:= .T.
     	Else
         	MsgStop( 'El acopio seleccionado es de otro cliente!', 'Verifique cliente/tienda' ) 
         	lRet	:= .F.
      	EndIf
   	EndIf
   	
   	
EndIf


//
//Validacion en Factura
//     

If (Funname()=='MATA467N' .OR. (Funname()=='MATA465N' .AND. CESPECIE='NDC')) .AND. inclui
	
	Z01->(DbSetOrder(1))
   	If Z01->(DbSeek(xFilial('Z01')+ M->F2_XNROACO))
   		If alltrim(M->F2_CLIENTE)==alltrim(Z01->Z01_CLIENT) .AND. alltrim(M->F2_LOJA)==alltrim(Z01->Z01_LOJA)    
         	lRet	:= .T.
     	Else
         	MsgStop( 'El acopio seleccionado es de otro cliente!', 'Verifique cliente/tienda' ) 
         	lRet	:= .F.
      	EndIf
   EndIf
EndIf   

//
//Validacion en NCC y Rto de devolucion
//
If ((Funname()=='MATA465N' .AND. CESPECIE='NCC') .OR. Funname()=='MATA462DN') .AND. inclui
	
	Z01->(DbSetOrder(1))
   	If Z01->(DbSeek(xFilial('Z01')+ M->F1_XNROACO))
   		If alltrim(M->F1_FORNECE)==alltrim(Z01->Z01_CLIENT) .AND. alltrim(M->F1_LOJA)==alltrim(Z01->Z01_LOJA)    
         	lRet	:= .T.
     	Else
         	MsgStop( 'El acopio seleccionado es de otro cliente!', 'Verifique cliente/tienda' ) 
         	lRet	:= .F.
      	EndIf
   EndIf
EndIf  
                               

//
//Validacion en Recibo
//
If (Funname()=='FINA087A')
	
	Z01->(DbSetOrder(1))
   	If Z01->(DbSeek(xFilial('Z01')+ acopio))
   		If (CCLIENTE)==alltrim(Z01->Z01_CLIENT) .AND. alltrim(CLOJA)==alltrim(Z01->Z01_LOJA)    
         	lRet	:= .T.
     	Else
         	MsgStop( 'El acopio seleccionado es de otro cliente!', 'Verifique cliente/tienda' ) 
         	lRet	:= .F.
      	EndIf
   EndIf
EndIf  
                      
Return(lRet)  
