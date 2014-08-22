#include 'protheus.ch'
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄn˜Û{üä{¿
//³Funsion que trae precio en base de la existencia de precio            ³
//³para producto en lista de precios particular y las condiciones        ³
//³de cliente 															 ³
//³																		 ³
//³Alexei                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄn˜Û{üä{Ù
ENDDOC*/

User Function TraePre(cProd,cLista,nCant,nMoe1,dFecEmi,ntipoF,nTxmoe)

Local nPrecio := 0//a415Tabela(cProd,cLista,nCant)
Local cQuery  := ""
Local nCan	  := 0    
Local cTipo  := "N" 
Local cListaOf:= "001" //Lista de precios oficial donde va a buscar el precio en el caso de que no lo encuentre en la lista de cabecera 
Local _aArea  := GetArea() 
Default nTIPOF := 1
Default nTxmoe := 1 

//LOCAL nMoe1 := iif(ISNULL(nMoe1),1,nMoe1)                                       
	
			
			cQuery := "SELECT COUNT(DA1_CODPRO) AS CANT FROM " + RetSqlName("DA1") + " "
			cQuery += "WHERE D_E_L_E_T_ = '' AND DA1_CODTAB = '" + cLista + "' "
			cQuery += "AND DA1_ATIVO = '1' AND DA1_QTDLOT >= " + CvalToChar(nCant) + " "
			cQuery += "AND DA1_CODPRO = '" + cProd + "' "
			cQuery += "AND DA1_QTDLOT <= (SELECT MIN(DA1_QTDLOT) FROM " + RetSqlName("DA1") + " " 
			cQuery +=						"WHERE D_E_L_E_T_ = '' AND DA1_CODTAB = '" + cLista + "' AND DA1_ATIVO = '1' AND DA1_CODPRO = '" + cProd + "' "
			cQuery +=						"AND DA1_QTDLOT >= " + CvalToChar(nCant) + ") "
			cQuery += "AND DA1_DATVIG=(select MAX(DA1_DATVIG) from DA1010 WHERE D_E_L_E_T_ = '' AND DA1_CODTAB = '" + cLista + "' AND DA1_CODPRO = '" + cProd + "' " + ") "
			cQuery := PLSAvaSQL(cQuery)
		    If Select("TODO01") <> 0
          		DBSelectArea("TODO01")
          		TODO01->(DBCloseArea())
    	 	EndIf
   		  	// Executa a Query
     		PLSQuery(cQuery,"TODO01")
   		  	// Vai para o inicio da area de trabalho
     		TODO01->(DBGoTop())
  		   	nCan:= TODO01->CANT

//			If nCan > 1
//				Alert("Existe mas de un Producto en Lista de Precios !!!!")
//				RestARea(_aArea)
//				Return()
			If nCan == 0
				cQuery := "SELECT * FROM " + RetSqlName("DA1") + " "
				cQuery += "WHERE D_E_L_E_T_ = '' AND DA1_CODTAB = '" + cListaOf + "' "
				cQuery += "AND DA1_ATIVO = '1' AND DA1_QTDLOT >= " + CvalToChar(nCant) + " "
				cQuery += "AND DA1_CODPRO = '" + cProd + "' "
				cQuery += "AND DA1_QTDLOT <= (SELECT MIN(DA1_QTDLOT) FROM " + RetSqlName("DA1") + " "
				cQuery +=						"WHERE D_E_L_E_T_ = '' AND DA1_CODTAB = '" + cListaOf + "' AND DA1_ATIVO = '1' AND DA1_CODPRO = '" + cProd + "' "
				cQuery +=						"AND DA1_QTDLOT >= " + CvalToChar(nCant) + ") "	
				//cQuery += "AND DA1_DATVIG=(select MAX(DA1_DATVIG) from DA1010 WHERE D_E_L_E_T_ = '' AND DA1_CODTAB = '" + cLista + "' AND DA1_CODPRO = '" + cProd + "' " + ") "
				cQuery := PLSAvaSQL(cQuery)
		    	If Select("TODO02") <> 0
          			DBSelectArea("TODO02")
       			TODO02->(DBCloseArea())
    	 		EndIf
   		  		// Executa a Query    
     			PLSQuery(cQuery,"TODO02")
   		  		// Vai para o inicio da area de trabalho
     			TODO02->(DBGoTop())
  		   		nPrecio := ROUND(xmoeda(TODO02->DA1_PRCVEN,TODO02->DA1_MOEDA,nMoe1,DFECEMI,5),2)
  		   		//
				cTipo := 'S'
			Else
				cQuery := "SELECT * FROM " + RetSqlName("DA1") + " "
				cQuery += "WHERE D_E_L_E_T_ = '' AND DA1_CODTAB = '" + cLista + "' "
				cQuery += "AND DA1_ATIVO = '1' AND DA1_QTDLOT >= " + CvalToChar(nCant) + " "
				cQuery += "AND DA1_CODPRO = '" + cProd + "' "
				cQuery += "AND DA1_QTDLOT <= (SELECT MIN(DA1_QTDLOT) FROM " + RetSqlName("DA1") + " "
				cQuery +=						"WHERE D_E_L_E_T_ = '' AND DA1_CODTAB = '" + cLista + "' AND DA1_ATIVO = '1' AND DA1_CODPRO = '" + cProd + "' "
				cQuery +=						"AND DA1_QTDLOT >= " + CvalToChar(nCant) + ") "	
				cQuery += "AND DA1_DATVIG=(select MAX(DA1_DATVIG) from DA1010 WHERE D_E_L_E_T_ = '' AND DA1_CODTAB = '" + cLista + "' AND DA1_CODPRO = '" + cProd + "' " + ") "
				cQuery := PLSAvaSQL(cQuery)
		    	If Select("TODO03") <> 0
          			DBSelectArea("TODO03")
       			TODO03->(DBCloseArea())
    	 		EndIf
   		  		// Executa a Query    
     			PLSQuery(cQuery,"TODO03")
   		  		// Vai para o inicio da area de trabalho
     			TODO03->(DBGoTop())
  		   		nPrecio := ROUND(xmoeda(TODO03->DA1_PRCVEN,TODO03->DA1_MOEDA,nMoe1,DFECEMI,5),2)
				cTipo := 'N'
			EndIf	  

RestARea(_aArea)	

Return(If(nTipoF == 1,nPrecio,cTipo))