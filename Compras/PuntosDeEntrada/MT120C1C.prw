
User Function MT120C1C
Local aRetTitle := PARAMIXB
If Alias() == 'SC1'    
	Aadd(aRetTitle, RetTitle('C1_FORNECE'))    
	Aadd(aRetTitle, RetTitle('C1_DESCRI'))
Else    
Endif
Return(aRetTitle)         
