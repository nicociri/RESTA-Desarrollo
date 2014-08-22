#include "rwmake.ch"
#include "protheus.ch"

User Function PROVENT()
Local lRet:=.T.

If Funname()=="MATA120"
	CA120PROVENT:='CF'
EndIf

If Funname()=="MATA101N"
	M->F1_PROVENT:='CF'
EndIf

If Funname()=="MATA102N"
	M->F1_PROVENT:='CF'
EndIf

Return (lRet)