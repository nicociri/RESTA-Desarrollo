#INCLUDE "PROTHEUS.CH"

User Function LXDORIG
Local lRet1:=.T.
                                      
// revisar esto es por linea no es necesario el recorrer el acols
If ALLTRIM(Funname())=='MATA462DN'
		Pendient()          
		MaFisReprocess(2)
EndIf   

Return .T.
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALMONACO �Autor  �Microsiga           �Fecha �  06/26/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static function Pendient()
Local aAcopio   := {}
Local cQuery    := ""	//Para ejecuci�n de Query       
Local dDias		:= (DATE()-GetMV( "MV_XDIANC" ))
Local nPrecio	:=0
Local nIncr		:=((M->F1_XPORC/100)+1)

If nIncr==0
	nIncr:=1
Endif

nX :=Len( aCols ) 
      	
      	cCod:=aCols[nX,AScan( aHeader, { |x| AllTrim( x[2] ) == "D1_COD" } )]
		cQuery := "SELECT MAX(D2_PRCVEN) PRECIO FROM " + RetSqlName("SD2") + " "
		cQuery += "WHERE D_E_L_E_T_='' AND D2_COD= '" + ALLTRIM(cCod) 
		cQuery += "' and D2_EMISSAO>CONVERT(VARCHAR(20),'"+dtoc(dDias)+"',112) and D2_CLIENTE='"+ALLTRIM(M->F1_FORNECE)+"' and D2_LOJA='" +ALLTRIM(M->F1_LOJA)+"' "		
		cQuery := PLSAvaSQL(cQuery)
  		If Select("TODO01") <> 0
			DBSelectArea("TODO01")
			TODO01->(DBCloseArea())
  		EndIf
		PLSQuery(cQuery,"TODO01")
		TODO01->(DBGoTop())
		If !Empty (TODO01->PRECIO)
			nPrecio:= TODO01->PRECIO
		EndIf
        If nPrecio>0
         	aCols[nX,AScan( aHeader, { |x| AllTrim( x[2] ) == "D1_VUNIT" } )]:=nPrecio * nIncr
         	If ExistTrigger("D1_VUNIT")
			RunTrigger(2,nX,"D1_VUNIT")
			EndIf
        Else  
        	DA1->(DbSetOrder(1))
   			If DA1->(dbseek(xFilial("DA1")+"001"+cCod)) 
         		aCols[nX,AScan( aHeader, { |x| AllTrim( x[2] ) == "D1_VUNIT" } )]:=DA1->DA1_PRCVEN * nIncr
         		If ExistTrigger("D1_VUNIT")
				RunTrigger(2,nX,"D1_VUNIT")
				EndIf
        	EndIf
      	EndIf
Return