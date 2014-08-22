#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AXCAUXCTB �Autor  �MS			    �Fecha �  11-03-08    ���
�������������������������������������������������������������������������͹��
���Desc.     �  Programa para disponibilizar Maestro Auxiliar de Asientos ���
���          �  utilizado en el modulo CTB em la tabla CT5                ���
�������������������������������������������������������������������������͹��
���Uso       � MRO				                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AXCAUXCTB

axcadastro('SZB','Auxiliar de Asiento', '.T.', 'U_CTBALT()')

Return

//�����������������������������������������������������������������������͹��
//��� CTBALT � Tratamento para alteracao                                  ���
//�����������������������������������������������������������������������ͼ��

User Function CTBALT()
Local lRet		:= .T.
Local lAdmin 	:= .F.
Local aUsers	:= AllUsers()
Local aGrupos	:= {}
Local cUsuario	:= RetCodUsr()

For i := 1 to len (aUsers)
	If AUsers[i][1][1] == cUsuario
		aGrupos := AUsers[i][1][10]
		For j := 1 to len (aGrupos)
			If AUsers[i][1][10][j] == "000000"
				lAdmin := .T.
				Exit
			EndIF
		Next
	EndIF
Next

If lAdmin
	Return 	(lRet)
EndIF
IF M->ZB_DACES = "1" // Se o campo ZZS_DACES estiver como "Admin" e o usuario nao estiver no grupo de Administradores nao deixa alterar.
	MsgAlert("Este registro esta restrido a los Administradores, somente ellos pueden cambiar!")
	lRet := .F.
EndIF

Return (lRet)
