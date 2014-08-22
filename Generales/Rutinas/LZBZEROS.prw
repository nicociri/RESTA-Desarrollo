#include 'protheus.ch'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funci�n   � LzbZeros � Autor � Diego Fernando Rivero  �Fecha� 01/07/04 ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  � Validaci�n para completar facilmente con ceros un campo    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Gen�rico                                                   ���
�������������������������������������������������������������������������Ĵ��
���Par�metros� cSep    Caracter/es separador/es                           ���
���          � nZero1  Primer tama�o de ceros                             ���
���          � nZero2  Segundo tama�o de ceros                            ���
���          � nZero3  Tercer tama�o de ceros                             ���
���          � nZero4  Cuarto tama�o de ceros                             ���
���          � nZero5  Quinto tama�o de ceros                             ���
�������������������������������������������������������������������������Ĵ��
���         ACTUALIZACIONES EFECTUADAS DESDE LA CODIFICACION INICIAL      ���
�������������������������������������������������������������������������Ĵ��
���Programador � Fecha  � BOPS �  Motivo de la Alteracion                 ���
�������������������������������������������������������������������������Ĵ��
���            �  /  /  �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function LzbZeros( cSep, nZero1, nZero2, nZero3, nZero4, nZero5 )
Local nX, xValor, aVal, nLenVar, cBlock, bBock,;
      cGetVar  := ReadVar(),;
      cReturn  := '',;
      nLen1    := 0,;
      nLen2    := 0

Default cSep   := '-'
Default nZero1 := 0
Default nZero2 := 0
Default nZero3 := 0
Default nZero4 := 0
Default nZero5 := 0

If ExistBlock('LZBZERVL')
   If !ExecBlock('LZBZERVL',.f.,.f.,{cSep, nZero1, nZero2, nZero3, nZero4, nZero5, cGetVar })
      Return( .t. )
   EndIf
EndIf

xValor   := &cGetVar
nLenVar  := Len( xValor )
aVal     := Str2Array( Alltrim(xValor), cSep )
aZeros   := { }

If Len( aVal ) == 1 .and. ;
   Len( Alltrim( xValor ) ) == ( nZero1+nZero2+nZero3+nZero4+nZero5 )
   Return( .T. )
EndIf

If !Empty( nZero1 )
   Aadd( aZeros, nZero1 )
EndIf

If !Empty( nZero2 )
   Aadd( aZeros, nZero2 )
EndIf

If !Empty( nZero3 )
   Aadd( aZeros, nZero3 )
EndIf

If !Empty( nZero4 )
   Aadd( aZeros, nZero4 )
EndIf

If !Empty( nZero5 )
   Aadd( aZeros, nZero5 )
EndIf

nLen1 := Len( aZeros )
nLen2 := Len( aVal )

For nX := 1 To nLen1
   If nX <= nLen2
      cReturn  += StrZero( Val( aVal[nX] ), aZeros[nX] )
   Else
      cReturn  := StrZero( 0, aZeros[nX] ) + cReturn
   EndIf
Next

cBlock   := '{|| ' + cGetVar + ' := "' + Padr( cReturn, nLenVar ) + '" }'
bBlock   := &cBlock

EVal( bBlock )     

Return( .T. )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funci�n   � Str2Array� Autor � Diego Fernando Rivero � Data � 01/07/04 ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  � Transforma un String en Array seg�n el separador           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxis  � Str2Array( cString, cSep )                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Str2Array( cString, cSep )

Local aReturn := { },;
      cAux    := cString,;
      nPos    := 0

While At( cSep, cAux ) > 0
   nPos := At( cSep, cAux )
	Aadd( aReturn, SubStr( cAux, 1, nPos-1 ) )
	cAux := SubStr( cAux, nPos+1 )
End

Aadd( aReturn, cAux )

Return( aReturn )
