
#Include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LJ7041    �Autor  �Nicolas Cirigliano  �Fecha �  04/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Punto de Entrada para la asignacion de deposito en la      ���
���          � venta asistida                                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LJ7041()
Local _cLocal   :=   ParamIxb [1]   // Recebe par�metro contendo almoxarifado
Local _aColsDet :=  ParamIxb[2]     // Recebe par�metro contendo o array aColsDet
Local cProduto  := ParamIxb[2][n][2]

_cLocal := POSICIONE("SBZ",1,xfilial("SBZ")+cProduto, "BZ_LOCPAD")


Return _cLocal


//Gatillo para asistencia al cambio de deposito
//Segun el TDN, el punto de entrada LJ7041 requiere tambien usar un gatillo desde LR_PRODUTO
//el de abajo, es una copia modificada del ejemplo del TDN

User Function LJ7041B()

Local _nPosLocal := aScan( aHeaderDet, { |x| Trim(x[2]) == 'LR_LOCAL' })
Local _nPosProd	 := aScan( aHeaderDet, { |x| Trim(x[2]) == 'LR_PRODUTO' })

_cLocal := POSICIONE("SBZ",1,xfilial("SBZ")+aColsDet[n][_nPosProd], "BZ_LOCPAD")

aColsDet[n][_nPosLocal] := _cLocal

Return (_cLocal)