#Include "Topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M440STTS  ºAutor  ³Pedro Sanchez       º Data ³ 20/06/08    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Para hacer que nunca se bloqueen los Pedidos por stock      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ mro						                                  º±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄ ÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
//±±Ponto de Entrada executado apos a gravacao do Aprobacion pedido de venda ±±//
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±//
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
