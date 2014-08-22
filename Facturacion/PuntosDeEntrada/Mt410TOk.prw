#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "tbiconn.CH"
/*/
�����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcion   � Mt410TOk � Autor � Fernando Cardeza		� Data �   .  .    ���
��������������������������������������������������������������������������Ĵ��
���Descrip.  �                                                             ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                    ���
��������������������������������������������������������������������������Ĵ��
��� ATUALIZACIONES SUFRIDAS DESDE EL DESARROLLO INICIAL                    ���
��������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � FECHA  � BOPS �  MOTIVO DE LA ALTERACION                ���
��������������������������������������������������������������������������Ĵ��
���              �        �      �                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function Mt410TOk
Local nX    := 0
Local nTot  := 0
Local Ped1	:= .F.
Private lRet:= .T.

ulista() //Agregado por Fernando Cardeza para segunda etapa de acopio para produccion comentar esta linea
    
Ped1:= AlTraePed (M->C5_NUM)
    
If !Empty( M->C5_XNROACO ) .AND.  M->C5_XESACO=="S"
   
   If M->C5_DOCGER=="2" .AND. Ped1
      lRet:=.F.
      Alert("No se puede modificar el segundo pedido de venta de entrega futura")
      Return( lRet ) 
   Endif
   
   For nX := 1 To Len( aCols )
      If GdDeleted()
         Loop
      EndIf
      
      nTot  += xMoeda(GdFieldGet('C6_VALOR', nX) , M->C5_MOEDA, 1, dDataBase, 4, M->C5_TXMOEDA, 1 )
   Next
   
   If M->C5_XTOTACO>0 .AND. Round(M->C5_XTOTACO,2) <= Round(nTot,2) .AND. M->C5_XTPACO=="D"
      lRet:=.F.
      Alert("La sumatoria del pedido de venta es mayor al valor del acopio definido")
      Return( lRet ) 
   Endif
   
   If M->C5_DOCGER=="2" .AND. M->C5_XTPACO=="I"
      
      lRet:=ValMonAco(nTot)
      If !lRet
         Return(lRet)
      EndIf
      
      lRet:=ulista()
      
      If !lRet
         Return(lRet)
      EndIf
   EndIf
   
EndIf

//Aprobar por credito el pedido de acopio indefinido
If M->C5_XTPACO=="I"
	APROV1()
EndIf
           
If altera
   lRet:=Prodaco1()
   If !lRet
         Return(lRet)
   EndIf
EndIf

If Inclui  
	If  ALLTRIM(M->C5_CATPV)=="00003" .AND. cFilant<>M->C5_LOJACLI
	//	lRet:=MyMata120()
		LjMsgRun("Espere, Generando Pedido de compra en la empresa "+M->C5_LOJACLI +" ","",MyMata120())
	EndIf 
EndIf

Return( lRet )
                        

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AlTraePed    �Autor  �Microsiga           � Data �  09/23/10���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function AlTraePed (CPedido)

Local _aAreaSC5	:= SC5->(GetArea())
Local aRet      := .F.

DbselectArea("SC5")
DbSetOrder(5)

If dbseek(Xfilial("SC5")+ cPedido)     
	If !Empty(SC5->C5_XPVTRO)	
		aRet:=.T.
	Endif
EndIf 
RestArea(_aAreaSC5)

return (aRet)                               


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �APROV1   �Autor  �Microsiga            �Fecha �  12/30/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Aprobar pedidos comercialmente                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function APROV1()

	Local aArea		:= GetArea()
	Local nI		:= 0					//Contador
	Local lRet     	:= .T.
	Local idx      	:= 0
	Local nCantLib	:= 0                    
	Local nPosQTDV	:= GdFieldPos("C6_QTDVEN")  
	Local nPosQTDL	:= GdFieldPos("C6_QTDLIB")  
	Local nPosProd:= GdFieldPos("C6_PRODUTO") 
	Local cItem
	LOCAL NTOTAL:=0
	//Recorrer la grilla y actualizar Cantidad Aprobada con Cantidad del PV	
//If inclui      
If MV_PAR01 == 1 .And. (INCLUI .OR. ALTERA)
	For idx:= 1 To Len(aCols)		
		If !GdDeleted(idx)
			cItem := GdFieldGet("C6_ITEM",idx)
			SC9->(DBSETORDER(1))
			If SC9->(DBSEEK(xFilial("SC9")+M->C5_NUM+cItem))
				Do while !SC9->(EOF()) .and. M->C5_NUM + cItem == SC9->C9_PEDIDO + SC9->C9_ITEM .and. xFilial("SC9") == SC9->C9_FILIAL .and. (SC9->C9_BLCRED == "10" .or. !Empty(SC9->C9_REMITO) .or. !Empty(SC9->C9_NFISCAL) ) .AND. SC9->C9_PRODUTO<>'ACOPIO'
			    	nCantLib := nCantLib + SC9->C9_QTDLIB
			    	SC9->(DBSKIP())
				EndDo                
				If nCantLib > aCols[idx,nPosQTDV]
					nCantLib := 0
				EndIf
			EndIf    
			aCols[idx,nPosQTDL] := aCols[idx,nPosQTDV] - nCantLib  // apruebo el saldo por aprobar             				
	 	EndIf
		nCantLib := 0
	Next idx
EndIf
	
	RestArea(aArea)
//EndIf
Return                                                                        

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Prodaco  �Autor  �Microsiga            �Fecha �  12/30/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cartel de aviso para cuando borran el producto acopio      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Prodaco1()
	Local aArea		:= GetArea()
	Local nPosDel	:= Len(aHeader) + 1
	Local nI 		:= 0
	Local lRet		:= .T.
	
	For nI := 1 To Len(aCols)
		If ALLTRIM(aCols[nI][GdFieldPos("C6_PRODUTO")]) == "ACOPIO" .AND. GdDeleted() 
			lRet:=MSGYESNO("Usted esta borrando el producto ACOPIO, al hacer esto va a cerrar el pedido de venta, �Desea continuar?")	
		EndIf
	Next nI                                  
	RestArea(aArea)
Return(lRet)         

/*
generacion automatica de orden de compra
*/
Static Function MyMata120()

Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local nX := 0
Local nY := 0
Local cDoc := ""
Local lOk := .T.
PRIVATE lMsErroAuto := .F.

ConOut(Repl("-",80))
ConOut(PadC("Inclusion de pedido de compra",80))
ConOut("Inicio: "+Time())

//��������������������������������������������������������������Ŀ
//| Verifica o ultimo documento valido para um fornecedor |
//����������������������������������������������������������������

dbSelectArea("SC7")
dbSetOrder(1)
MsSeek(xFilial("SC7")+"zzzzzz",.T.)
dbSkip(-1)
cDoc := SC7->C7_NUM
For nY := 1 To 1
	aCabec := {}
	aItens := {}

	If Empty(cDoc)
		cDoc := StrZero(1,Len(SC7->C7_NUM))
	Else
		cDoc := Soma1(cDoc)
	EndIf

	aadd(aCabec,{"C7_NUM" 		,cDoc})
	aadd(aCabec,{"C7_EMISSAO" 	,dDataBase})
	aadd(aCabec,{"C7_FORNECE" 	,"900000"})
//	aadd(aCabec,{"C7_LOJA" 		,M->C5_LOJACLI})
	aadd(aCabec,{"C7_LOJA" 		,cfilant})
	aadd(aCabec,{"C7_COND" 		,"001"})
	aadd(aCabec,{"C7_CONTATO"   ,"AUTO"})
	aadd(aCabec,{"C7_FILENT"    ,M->C5_LOJACLI})
//	aadd(aCabec,{"C7_NATUREZ" 	,M->C5_NATUREZ})
//	aadd(aCabec,{"C7_FILIAL"    ,M->C5_LOJACLI})    
	
For nX := 1 To len(Acols) 
	aLinha := {}
	 If GdDeleted()
         Loop
      EndIf
	aadd(aLinha,{"C7_PRODUTO" 	,GdFieldGet('C6_PRODUTO', nX)	,Nil})
	aadd(aLinha,{"C7_QUANT" 	,GdFieldGet('C6_QTDVEN' , nX)	,Nil})
	aadd(aLinha,{"C7_PRECO" 	,1								,Nil})
//	aadd(aLinha,{"C7_TOTAL" 	,GdFieldGet('C6_QTDVEN' , nX)	,Nil})
	aadd(aLinha,{"C7_TOTAL" 	,GdFieldGet('C6_VALOR' , nX)	,Nil})
	aadd(aLinha,{"C7_TES" 		,"199" 							,Nil})
	aadd(aLinha,{"C7_OBS" 		,"Solicitud por abastecimiento"	,Nil})
//	aadd(aLinha,{"C7_PRECO" 		,1                          ,Nil})
  	aadd(aLinha,{"C7_PRECO" 		,GdFieldGet('C6_PRCVEN' , nX),Nil})
	aadd(aLinha,{"C7_NATUREZ" 		,"ABASTEC"          	     ,Nil})  
	aadd(aItens,aLinha)
Next nX 
//��������������������������������������������������������������Ŀ
//| Teste de Inclusao |
//����������������������������������������������������������������
MATA120(1,aCabec,aItens,3)

If !lMsErroAuto  
    CLOCAUX:='01'
    DO CASE
	CASE M->C5_LOJACLI='01'
	     CLOCAUX:='01'
	CASE M->C5_LOJACLI='02'
    	 CLOCAUX:='10'
	CASE M->C5_LOJACLI='03'
    	 CLOCAUX:='20'
	CASE M->C5_LOJACLI='04'
    	 CLOCAUX:='30'
	ENDCASE
	ConOut("Inclusion con exito! "+cDoc) 
	lRet:=.T.               
	For nX := 1 To Len(aCols)
	SC7->( dbSetOrder( 1 ) )
	If SC7->( dbSeek( cFilant+cDoc ) )
		While SC7->( !Eof() .and. C7_FILIAL+C7_NUM == cFilant+cDoc )
    		RecLock( 'SC7', .F. )
    		Replace C7_NATUREZ  With M->C5_NATUREZ
    		Replace C7_LOCAL  With CLOCAUX
    		Replace C7_FILIAL  With M->C5_LOJACLI
    		SC7->( MsUnLock() )
			SC7->( DbSkip() )
		End
	EndIf
	Next 
Else
	ConOut("Error en inclusion!")
	MostraErro()
	lRet:=.F.
EndIf

Next nY
ConOut("Fin : "+Time())

Return           



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT410TOK  �Autor  �Microsiga           �Fecha �  06/06/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Validaci�n para el monto total de un acopio indefinido    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                                            

Static Function ValMonAco (nTot)

local nValMont :=  0    //Valor del monto del acopio indefinido
local cValMont :=  ""
local nmonsobre:=  0
local cmonsobre:=  ""
local ctot	   :=  STR(nTot)
local cTexto   :=  ""
local cQuery   :=  ""	//Para ejecuci�n de Query
local cAcopio  :=  M->C5_XNROACO
local lRet     :=  .T.

aAcopio:=Pendient()

For mk:=1 to Len(aAcopio)
	If aAcopio[mk][1]==cAcopio     
		cValMont := aAcopio[mk][2]
		nValMont := Val(aAcopio[mk][2]) //Valor del monto de acopio asociado al pedido de venta
	EndIf                        
Next
                        
If nValMont < nTot     //�Caso acopio definido menor a la sumatoria del pedido de venta
	lRet:=.F.
	
	nmonsobre:= nTot - nValMont
	cmonsobre:= STR(nmonsobre)
	                                                                   
	cTexto:="El total del pedido de venta es mayor al saldo pendiente del acopio "+Chr(13) + Chr(10)
	cTexto+="------------------------------------------------------------------- "+Chr(13) + Chr(10)
	cTexto+="Total del Pedido de ventas: $" + ALLTRIM(ctot) +Chr(13) + Chr(10)
	cTexto+="------------------------------------------------------------------- "+Chr(13) + Chr(10)
	cTexto+="Saldo pendiente del acopio: $" + ALLTRIM(cValMont) +Chr(13) + Chr(10)
	cTexto+="------------------------------------------------------------------- "+Chr(13) + Chr(10)
	cTexto+="Monto sobrepasado: $" + ALLTRIM(cmonsobre)
 	Alert(cTexto)                                                      
 	
Endif    

Return(lRet)
                                      
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ulista  �Autor  �Microsiga            �Fecha �  20/06/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cartel de aviso para cuando un producto que no esta en     ���
���          � la lista de acopio                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ulista()
Local aArea		:= GetArea()
Local lRet		:= .T. 
Local lRet1		:= .F.

dbselectarea("DA1")
DbSetOrder(1)

For nz:=1 to Len(aCols)                                                               
If !GdDeleted() 
	If DbSeek(xFilial("DA1")+M->C5_TABELA+aCols[nz][GdFieldPos("C6_PRODUTO")]) 
		aCols[nz][GdFieldPos("C6_XESLACO")]:="S"
	Else                                        
		lRet1:=.T.
		aCols[nz][GdFieldPos("C6_XESLACO")]:="N"		
	EndIf
EndIf
Next

If lRet1 		
	lRet:=MSGYESNO("Hay productos que no esta en la lista de precios del ACOPIO, �Desea continuar?")
EndIf
 
RestArea(aArea)
Return(lRet) 


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

Local cQuery   :=  ""	//Para ejecuci�n de Query
Local cCliente :=  M->C5_CLIENTE
Local aAcopio  := {}

cQuery := "exec [QRY_VAL_ACOPIO_"+SM0->M0_CODIGO+"]'"+ cCliente +"'"
cQuery := PLSAvaSQL(cQuery)
  If Select("TODO01") <> 0
	DBSelectArea("TODO01")
	TODO01->(DBCloseArea())
  EndIf
// Executa a Query
PLSQuery(cQuery,"TODO01")
// Vai para o inicio da area de trabalho
TODO01->(DBGoTop())
    While TODO01->(!Eof())
   		AADD( aAcopio, {TODO01->ACOPIO,TODO01->VALOR} )
    	DbSkip()
	Enddo

Return(aAcopio)  