#include "protheus.ch"
/*/
�����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcion   � LocxPe16 � Autor � Fernando Cardeza	    � Data �   .  .    ���
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
User Function LocxPe16

Local lRet  	:= .T.
Local nX    	:= 0
Local nTot  	:= 0
Local aArea 	:= GetArea()
Local nTotal   	:= 0
Local nTotImp  	:= 0
Local nposcod	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})
Local nposcod2	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D2_COD"})
Local atpacopio	:= .F.


If FUNNAME()=='MATA101N'
	lRET:=!MSGYESNO("Verificar que la provincia de entrega en la cabecera sea la correcta, �Desea modificarla?")
	Return(lRet)
EndIf

If StrZero(nNFTipo,2) == "50" .and. !Empty( M->F2_XNROACO ) 

   For nX := 1 To Len( aCols )
      If GdDeleted()
         Loop
      EndIf
      
      nTot  += xMoeda( GdFieldGet('D2_TOTAL', nX), M->F2_MOEDA, 1, dDataBase, 4, M->F2_TXMOEDA, 1 )
   Next
   
EndIf
/*BEGINDOC
//�������������������������������������������������������������������������������Ŀ
//�Llama a funcion para completar el monto del acopio sin iva en el ABM de acopios�
//���������������������������������������������������������������������������������
ENDDOC*/
If StrZero(nNFTipo,2) == "01" .and. !Empty( M->F2_XNROACO ) 

   monto()
 
EndIf       
                                                                           
//Validacion para controlar que no puedan cargar el producto acopio en una remito de venta

If Alltrim(FunName()) $ 'MATA462N|MATA462AN'
       	For ny:= 1 to len(acols)
      		If	ALLTRIM(GetMv("MV_PRODACO")) == ALLTRIM(acols[ny][nposcod2])
      		    lRet:=.F.
      		Endif		
      	Next
EndIf

If Alltrim(FunName()) == 'MATA462DN' .and. Alltrim(cEspecie) == 'RFD'
   If !Empty(M->F1_XNROACO) 
   //    	For ny:= 1 to len(acols)
   //   		If	ALLTRIM(GetMv("MV_PRODACO")) <> ALLTRIM(acols[ny][nposcod]) .AND. atpacopio==.F.
   //   		    atpacopio:=.T.
   //   		Endif		
   //   	Next  	
  //    	If atpacopio
      	//		GeraPV() //genera pedido de venta para acopio
  //     	Else
  //    	Endif
  		lRet:=Precero()
  		If lRet
  			Return(lRet)
  		EndIf
   EndIf
EndIf                 


RestArea( aArea )

Return( lRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraPV()  �Autor  �Fernando Cardeza    �Fecha �  25/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Genera el pedido de ventas en base a la NCC		          ���
���          �seleccionada                                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP 11                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GeraPV()

//Local cPedido := GetSXENum("SC5","C5_NUM")
Local _aCabec := {}
Local _aItens := {}
Local _aLinha := {}
Local nitem		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEM"}) 
Local ncod		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})
Local num  		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_UM"}) 
Local nquant	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_QUANT"})
Local nvunit	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_VUNIT"}) 
Local ntotal	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_TOTAL"})
Local ntes		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_TES"}) 
Local nlocal	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_LOCAL"})
Local nprovent 	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_PROVENT"})
Local ncf		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_CF"}) 
Local _cNum := "0"
Private lMsErroAuto := .F.



//��������������������������������������������������������������Ŀ
//| Cabecalho do Pedido de Venda                                 |
//����������������������������������������������������������������
    
//	Aadd(_aCabec,{"C5_NUM"     ,cPedido		  ,Nil})
 	Aadd(_aCabec,{"C5_TIPO"    ,"N"    		  ,Nil})
	Aadd(_aCabec,{"C5_CLIENTE" ,M->F1_FORNECE ,Nil})
	Aadd(_aCabec,{"C5_LOJACLI" ,M->F1_LOJA    ,Nil})
	Aadd(_aCabec,{"C5_CLIENT"  ,M->F1_FORNECE ,Nil})
	Aadd(_aCabec,{"C5_LOJAENT" ,M->F1_LOJA    ,Nil})
	Aadd(_aCabec,{"C5_CONDPAG" ,Posicione("SA1",1,xFilial("SA1")+M->F1_FORNECE+M->F1_LOJA,"A1_COND")  ,Nil})
	Aadd(_aCabec,{"C5_MOEDA"   ,M->F1_MOEDA	  ,Nil})
	Aadd(_aCabec,{"C5_TIPLIB"  ,"1"			  ,Nil})
	Aadd(_aCabec,{"C5_DOCGER"  ,"2"			  ,Nil})	
	Aadd(_aCabec,{"C5_XNROACO" ,M->F1_XNROACO ,Nil})
	Aadd(_aCabec,{"C5_XESACO"  ,"S"			  ,Nil})
	Aadd(_aCabec,{"C5_PROVENT" ,M->F1_PROVENT ,Nil}) 
	Aadd(_aCabec,{"C5_LIBEROK" ,"S"			  ,Nil})
//	Aadd(_aCabec,{"C5_TPVENT"  ,M->F1_TPVENT  ,Nil})	
//	Aadd(_aCabec,{"C5_TPVENT" ,"1"			  ,Nil})
	Aadd(_aCabec,{"C5_CATPV"  ,GetMv("MV_CATPV"),Nil})
//	Aadd(_aCabec,{"C5_IDIOMA" ,M->F1_IDIOMA  ,Nil})	
//	Aadd(_aCabec,{"C5_PAISENT",M->F1_PAISENT ,Nil})					
		
	//��������������������������������������������������������������Ŀ
	//| Itens do Pedido de Venda                                     |
	//����������������������������������������������������������������

	For nx:= 1 to len(acols)	
		_cNum := StrZero(Val(_cNum)+1,2)
		_aLinha := {}
		Aadd(_aLinha,{"C6_ITEM"    ,_cNum  					,Nil})    
		Aadd(_aLinha,{"C6_PRODUTO" ,acols[nx][ncod]			,Nil})
		Aadd(_aLinha,{"C6_UM"      ,acols[nx][num]		    ,Nil})
		Aadd(_aLinha,{"C6_QTDVEN"  ,acols[nx][nquant]		,Nil})
		Aadd(_aLinha,{"C6_PRCVEN"  ,acols[nx][nvunit]		,Nil})
		Aadd(_aLinha,{"C6_VALOR"   ,acols[nx][ntotal]		,Nil})
		Aadd(_aLinha,{"C6_TES"     ,GetMv("MV_TESFUT")		,Nil})
		Aadd(_aLinha,{"C6_LOCAL"   ,acols[nx][nlocal]		,Nil})
		Aadd(_aLinha,{"C6_PRUNIT"  ,acols[nx][nvunit]		,Nil})
		Aadd(_aLinha,{"C6_PROVENT" ,acols[nx][nprovent]		,Nil})	     
		Aadd(_aLinha,{"C6_CF"      ,Posicione("SF4",1,xFilial("SF4")+GetMv("MV_TESFUT"),"F4_CF")	,Nil})
		Aadd(_aLinha,{"C6_QTDLIB"  ,acols[nx][nquant]		,Nil}) 
		Aadd(_aItens,_aLinha)
	Next
//��������������������������������������������������������������Ŀ
//| Genara el pedido de ventas							         |
//����������������������������������������������������������������

	Begin Transaction
	MSExecAuto({|x,y,z|Mata410(x,y,z)},_aCabec,_aItens,3)
 
	If lMsErroAuto
		MostraErro()
		_lRet := .F.
		DisarmTransaction()
	Else
		MsgInfo("Pedido de Venta creado con exito " ,"Atencion!")
	EndIf
	End Transaction

Return           


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LOCXPE16  �Autor  �Microsiga           �Fecha �  06/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funci�n para guardar saldo del acopio     				  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP   Factura de adelanto - Acopio indefinido               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                       
Static function monto()

Z01->(DbSetOrder(1))
If Z01->(DbSeek(xFilial('Z01')+M->F2_XNROACO))   
	RecLock('Z01',.F.)
    	Replace Z01_XVFAC With M->F2_VALMERC 
    	Replace Z01_XFACT With M->F2_DOC
    MsUnLock() 
EndIf

Return        
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LOCXPE16  �Autor  �Microsiga           �Fecha �  06/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacion para no dejar cargar remito de devolucion con 	  ���
���          �Precio cero                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP   Acopio indefinido 						              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                       
Static function Precero()
Local lRet:=.T.
Local nvunit	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_VUNIT"})

   	For n:= 1 to len(acols)
   		If	acols[n][nvunit]==0
   		    lRet:=.F.
   		Endif		
   	Next  	

Return(lRet) 