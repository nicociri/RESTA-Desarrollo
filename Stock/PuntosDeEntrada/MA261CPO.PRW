#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA261CPO  �Autor  �Uyrande Ribeiro     � Data �  07/22/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para agregar campos no aHeader            ���
���          � Serao agragados os campos necessarios para a Rotina de     ���
���          � Transferencia Modelo 2 Especifica para o Cliente Delta     ���
�������������������������������������������������������������������������͹��
���Uso       � MATA261                                                    ���
�������������������������������������������������������������������������͹��
���     ROBSON LUIZ MELHOROU A FUNCIONALIDADE DESTE PONTO DE ENTRADA      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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