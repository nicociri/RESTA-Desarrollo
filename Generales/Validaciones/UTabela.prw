
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �uTabela   �Autor  �Microsiga           �Fecha �  06/30/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function UTabela()
local cTabela  := M->Z01_XCDTAB
local cAcopio  := ""
local cQuery   := ""	//Para ejecuci�n de Query
local lRet     := .T.
                        
cQuery := "SELECT Z01_XCDTAB TABELA,Z01_ACOPIO ACOPIO FROM " + RetSqlName("Z01") + " "
cQuery += "WHERE D_E_L_E_T_='' AND Z01_XCDTAB='" + cTabela + "' "
cQuery := PLSAvaSQL(cQuery)
  If Select("TODO01") <> 0
	DBSelectArea("TODO01")
	TODO01->(DBCloseArea())
  EndIf
// Executa a Query
PLSQuery(cQuery,"TODO01")
// Vai para o inicio da area de trabalho
TODO01->(DBGoTop())
cAcopio:= TODO01->ACOPIO
cTabela:= TODO01->TABELA

If !Empty(cTabela)     //�Caso acopio definido menor a la sumatoria del pedido de venta
	lRet:=.T.
 	Alert("La lista de precios ya fue utilizada en el acopio: " + cAcopio +"")  
  	Return( lRet )  
Endif    

Return( lRet )       
