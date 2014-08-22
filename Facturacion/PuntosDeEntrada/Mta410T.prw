#include "protheus.ch"
/*/
�����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcion   � Mta410T  � Autor � Fernando Cardeza		� Data �   .  .    ���
��������������������������������������������������������������������������Ĵ��
���Descrip.  � Punto de Entrada al Grabar el SC5                           ���
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
User Function Mta410T
Local aArea := GetArea()
Local aSC5  := SC5->(GetArea())
Local aSC6  := SC6->(GetArea())
Local nTotal:= 0

If inclui .AND. (SC5->C5_DOCGER=="3" .OR. SC5->C5_DOCGER=="1")
	If !Empty(SC5->C5_XNROACO) .AND. SC5->C5_XESACO=="S"
   		For nX := 1 To Len( aCols )
      		If GdDeleted()
         		Loop
      		EndIf
      		nTotal   += xMoeda( GdFieldGet('C6_VALOR', nX), M->C5_MOEDA, 1, dDataBase, 4, M->C5_TXMOEDA, 1 )
      	Next                                                                                                
      	
   		If Inclui
			SC5->C5_XTOTACO := nTotal
   			Z01->(DbSetOrder(1))
      		If Z01->(DbSeek(xFilial('Z01')+SC5->C5_XNROACO))
         		RecLock('Z01',.F.)
         		Replace Z01_STATUS With "2"
         		MsUnLock()
      		EndIf
   		EndIf
	EndIf
EndIf
RestArea( aSC5 )
RestArea( aSC6 )
RestArea( aArea )

Return
