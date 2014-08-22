#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA261CPO  ºAutor  ³Uyrande Ribeiro     º Data ³  07/22/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para agregar campos no aHeader            º±±
±±º          ³ Serao agragados os campos necessarios para a Rotina de     º±±
±±º          ³ Transferencia Modelo 2 Especifica para o Cliente Delta     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA261                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º     ROBSON LUIZ MELHOROU A FUNCIONALIDADE DESTE PONTO DE ENTRADA      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA261CPO()

Local aArea := GetArea()
Local aAreaSX3 := {}
Local aCPOS := {}

// aAdd(aCPOS,"D3_CPORTE")  */
//aAdd(aCPOS,"D3_XCODMED")
//aAdd(aCPOS,"D3_XPACIEN")
//aAdd(aCPOS,"D3_XINSTIT")
aAdd(aCPOS,"D3_XOBS")


dbSelectArea("SX3")
aAreaSX3 := SX3->(GetArea())
dbSetOrder(2)

For i:=1 To Len(aCPOS)
   dbSeek(aCPOS[i])
   aAdd(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO})
Next i

RestArea(aAreaSX3)
RestArea(aArea)  
Return