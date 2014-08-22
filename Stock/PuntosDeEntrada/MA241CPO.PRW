#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA241CPO  ºAutor  ³carlos     º Data ³  29/01/2014          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para agregar campos no aHeader            º±±
±±º          ³ Serao agragados os campos necessarios para a Rotina de     º±±
±±º          ³ internos Modelo 2 Especifica                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA241                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA241CPO()

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