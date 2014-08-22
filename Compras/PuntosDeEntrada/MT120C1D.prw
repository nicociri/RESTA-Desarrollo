
User Function MT120C1D
Local aRetDados := PARAMIXB
If Alias() == 'SC1'    
	Aadd(aRetDados, Alltrim(Posicione ("SB1",1,XFILIAL("SB1") + SC1->C1_PRODUTO , "B1_PROC")))     
	Aadd(aRetDados, Alltrim(Posicione ("SA2",1,XFILIAL("SA2") + Alltrim(Posicione ("SB1",1,XFILIAL("SB1") + SC1->C1_PRODUTO , "B1_PROC")) , "A2_NOME")))
Else     
	Aadd(aRetDados, SC3->C3_OBS)
Endif
Return(aRetDados)
