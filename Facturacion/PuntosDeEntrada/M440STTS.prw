#Include "Topconn.ch"
#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M440STTS  �Autor  �Pedro Sanchez       � Data � 20/06/08    ���
�������������������������������������������������������������������������͹��
���Desc.     �Para hacer que nunca se bloqueen los Pedidos por stock      ���
�������������������������������������������������������������������������͹��
���Uso       � mro						                                  ���
���Analista Resp.�  Data  � Bops � Manutencao Efetuada                    ���
�������������������� ����������������������������������������������������Ĵ��
���              �        �      �                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//�����������������������������������������������������������������������������//
//��Ponto de Entrada executado apos a gravacao do Aprobacion pedido de venda ��//
//�����������������������������������������������������������������������������//
User Function M440STTS()

Local aAreaAnt   := GetArea() 
Local aAreaSC9   := GetArea("SC9")
Local cPedido    := SC5->C5_NUM                      
Local cENDENT    := SC5->C5_XENDENT                      
Local _AtuStock  := "N"

DbSelectArea("SC9")
DbSetOrder(1)
If DbSeek(xFilial("SC9")+cPedido)
   Do While !EOF() .And. cPedido == SC9->C9_PEDIDO
   /*
		_AtuStock := posicione("SF4",1,xfilial("SC9")+SC9->C9_PRODUTO,"F4_ESTOQUE")
		IF _AtuStock == "S" .and. alltrim(SC9->C9_REMITO)="" .and. alltrim(SC9->C9_NFISCAL)=""
			Reclock("SC9",.F.)
			SC9->C9_BLEST:="02"
			MsUnlock()
	    Endif
	 */
			Reclock("SC9",.F.)
			SC9->C9_XENDENT :=CENDENT
			SC9->C9_XNOME	:=Posicione("SA1",1,xFilial("SA1")+SC9->C9_CLIENTE,"A1_NOME")
			MsUnlock()
   		("SC9")->(DbSkip())
   End
Endif

RestArea( aAreaAnt ) 
RestArea( aAreaSC9 )

Return()
