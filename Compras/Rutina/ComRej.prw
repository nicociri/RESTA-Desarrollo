#INCLUDE "COMREJ.ch"
#INCLUDE "PROTHEUS.CH"
#DEFINE MAXGETDAD 99999
#DEFINE MAXSAVERESULT 999
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Com010Rej  � Autor �Eduardo Riera          � Data �02.10.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Reajuste das tabelas de precos                              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Alias do Arquivo                                     ���
���          �ExpN1: Numero do Registro                                   ���
���          �ExpN2: Opcao do aRotina                                     ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ComRej(cAlias,nReg,nOpc)

Local aArea := GetArea()
Local nOpcA := 0        
Local lRet  := .T.   

//����������������������������������������������������������������Ŀ
//� Ponto de Entrada para execu��o do Reajuste da Tabela de Pre�os �
//������������������������������������������������������������������
//������������������������������������������������������Ŀ
//� Define variaveis de parametrizacao de lancamentos    �
//�                                                      �
//� MV_PAR01 Produto inicial?                            �
//� MV_PAR02 Produto final  ?                            �
//� MV_PAR03 Grupo inicial  ?                            �
//� MV_PAR04 Grupo final    ?                            �
//� MV_PAR05 Tipo inicial   ?                            �
//� MV_PAR06 Tipo final     ?                            �
//� MV_PAR07 Tabela inicial ?                            �
//� MV_PAR08 Tabela final   ?                            �
//� MV_PAR09 Fornecedor     ?                            �
//� MV_PAR10 Loja           ?                            �
//� MV_PAR11 Fator          ?                            �
//� MV_PAR12 Numero decimais?                            �
//��������������������������������������������������������  
If lRet
	Pergunte("COMREJ",.F.)
	FormBatch(STR0010,{STR0011,STR0012},; //"Reajuste da Tabela de precos"###"Esta rotina efetuara o reajuste das tabelas de preco, conforme os parametros "###"solicitados."
		{{5,.T.,{|o| Pergunte("COMREJ",.T.) }},;
		{1,.T.,{|o| nOpcA:=1,o:oWnd:End()}  },;
		{2,.T.,{|o| o:oWnd:End() }}})
	If ( nOpcA == 1 )
		Processa({|| Com010Proc()})
	EndIf
EndIf
	
RestArea(aArea)
Return(.F.)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Com010Proc � Autor �Eduardo Riera          � Data �03.05.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Processamento da tabela de preco                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC Function Com010Proc()

Local aArea     := GetArea()
Local cQuery    := ""
Local cArqInd   := ""
Local cCursor   := "AIB"
Local cUltProc  := ""
Local lQuery    := .F.
Local lContinua := .F.
Local nIndex    := 0
Local cdesc1	:= 0
Local cdesc2	:= 0
Local cdesc3	:= 0
Local cdesc4	:= 0
Local cdesc5	:= 0
Local cdesc6	:= 0

//������������������������������������������������������Ŀ
//� Define variaveis de parametrizacao de lancamentos    �
//�                                                      �
//� MV_PAR01 Produto inicial?                            �
//� MV_PAR02 Produto final  ?                            �
//� MV_PAR03 Grupo inicial  ?                            �
//� MV_PAR04 Grupo final    ?                            �
//� MV_PAR05 Tipo inicial   ?                            �
//� MV_PAR06 Tipo final     ?                            �
//� MV_PAR07 Tabela inicial ?                            �
//� MV_PAR08 Tabela final   ?                            �
//� MV_PAR09 Fornecedor     ?                            �
//� MV_PAR10 Loja           ?                            �
//� MV_PAR11 Fator          ?                            �
//� MV_PAR12 Numero decimais?                            �
//� MV_PAR13 Descuento1		?                            �
//� MV_PAR14 Descuento2		?                            �
//� MV_PAR15 Descuento3		?                            �
//� MV_PAR16 Descuento4		?                            �
//� MV_PAR17 Descuento5		?                            �
//� MV_PAR18 Descuento6		?                            �
//��������������������������������������������������������
//������������������������������������������������������Ŀ
//�Processa a atualizacao da tabela de preco             �
//��������������������������������������������������������

cdesc1:=MV_PAR13
ldesc1:=!Empty(MV_PAR14)
cdesc2:=MV_PAR15
ldesc2:=!Empty(MV_PAR16)
cdesc3:=MV_PAR17
ldesc3:=!Empty(MV_PAR18)
cdesc4:=MV_PAR19
ldesc4:=!Empty(MV_PAR20)
cdesc5:=MV_PAR21
ldesc5:=!Empty(MV_PAR22)
cdesc6:=MV_PAR23
ldesc6:=!Empty(MV_PAR24)

dbSelectArea("AIB")
dbSetOrder(1)
#IFDEF TOP
	If TcSrvType()<>"AS/400"
		cCursor:= "Com010Rej"
		lQuery := .T.
		cQuery := "SELECT * "
		cQuery += "FROM "+RetSqlName("AIB")+" AIB,"
		cQuery += RetSqlName("SB1")+" SB1 "
		cQuery += "WHERE AIB.AIB_FILIAL='"+xFilial("AIB")+"' AND "
		cQuery += "AIB.AIB_CODPRO>='"+MV_PAR01+"' AND "
		cQuery += "AIB.AIB_CODPRO<='"+MV_PAR02+"' AND "
		cQuery += "AIB.AIB_CODTAB>='"+MV_PAR07+"' AND "
		cQuery += "AIB.AIB_CODTAB<='"+MV_PAR08+"' AND "
		cQuery += "AIB.AIB_CODFOR='"+MV_PAR09+"' AND "
		cQuery += "AIB.AIB_LOJFOR='"+MV_PAR10+"' AND "
		cQuery += "AIB.D_E_L_E_T_=' ' AND "
		cQuery += "SB1.B1_COD=AIB.AIB_CODPRO AND "
		cQuery += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "	
		If Empty(MV_PAR04)
			cCant:=RAT(",", mv_par03)+1
		    cPar:=""
		    For n:=1 to cCant
		    	cAT:=AT(",", mv_par03)  
		    	If cAT>0
		    		n:=cAT
		    		cPar+="'"+SUBSTRING(mv_par03,1,(cat-1))+"'"  
		    	endIf
		    	If n<cCant .AND. cAT>0
		    		cPar+=SUBSTRING(mv_par03,cat,1)
		    	EndIf
		    	mv_par03:=SUBSTRING(mv_par03,cat+1,(len(mv_par03)))
		    	If cAt==0
		    		cPar+="'"+ALLTRIM(mv_par03)+"'"
		    		n:=cCant
		    	EndIf	 
		    Next
		    mv_par03:=cPar
		    If (AT(";", mv_par03)>0) .OR. (AT(".", mv_par03)>0)
		    	Alert("Ingreso un caracter invalido para la generacion de grupos")
		    	mv_par03:="''"
		    EndIf
			cQuery += "SB1.B1_GRUPO in ("+MV_PAR03+") AND "
		Else
			cQuery += "SB1.B1_GRUPO>='"+MV_PAR03+"' AND "
			cQuery += "SB1.B1_GRUPO<='"+MV_PAR04+"' AND "
		EndIf
		cQuery += "SB1.B1_TIPO>='"+MV_PAR05+"' AND "
		cQuery += "SB1.B1_TIPO<='"+MV_PAR06+"' AND "
		cQuery += "SB1.D_E_L_E_T_=' ' "
		cQuery += "ORDER BY "+SqlOrder(AIB->(IndexKey()))

		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor,.T.,.T.)

	Else
#ENDIF
	cArqInd := CriaTrab(,.F.)

	cQuery := "AIB_FILIAL=='"+xFilial("AIB")+"' .AND. "
	cQuery += "AIB_CODPRO>='"+MV_PAR01+"' .AND. "
	cQuery += "AIB_CODPRO<='"+MV_PAR02+"' .AND. "
	cQuery += "AIB_CODTAB>='"+MV_PAR07+"' .AND. "
	cQuery += "AIB_CODTAB<='"+MV_PAR08+"' .AND. "
	cQuery += "AIB_CODFOR='"+MV_PAR09+"' .AND. "
	cQuery += "AIB_LOJFOR='"+MV_PAR10+"'"

	IndRegua("AIB",cArqInd,IndexKey(),,cQuery)
	nIndex := RetIndex("AIB")
	#IFNDEF TOP
		dbSetIndex(cArqInd+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
	dbGotop()
	#IFDEF TOP
	EndIf
	#ENDIF

ProcRegua(AIB->(LastRec()))

dbSelectArea(cCursor)
While ( !Eof() )
	lContinua := .F.
	If !lQuery
		dbSelectArea("SB1")
		dbSetOrder(1)
		If DbSeek(xFilial("SB1")+(cCursor)->AIB_CODPRO)
			If 	SB1->B1_GRUPO >= MV_PAR03 .And. ;
					SB1->B1_GRUPO <= MV_PAR04 .And. ;
					SB1->B1_TIPO >= MV_PAR05 .And. ;
					SB1->B1_TIPO <= MV_PAR06

				lContinua := .T.

			EndIf
		EndIf		
	Else
		lContinua := .T.
	EndIf
	If lContinua
		If (cCursor)->AIB_CODFOR+(cCursor)->AIB_LOJFOR+(cCursor)->AIB_CODTAB+(cCursor)->AIB_CODPRO==cUltProc
			lContinua := .F.
		EndIf
	EndIf
	If lContinua
		MaRejTabCom1((cCursor)->AIB_CODFOR,(cCursor)->AIB_LOJFOR,(cCursor)->AIB_CODTAB,(cCursor)->AIB_CODPRO,MV_PAR11,MV_PAR12,cdesc1,cdesc2,cdesc3,cdesc4,cdesc5,cdesc6,ldesc1,ldesc2,ldesc3,ldesc4,ldesc5,ldesc6)
	EndIf	
	cUltProc := (cCursor)->AIB_CODFOR+(cCursor)->AIB_LOJFOR+(cCursor)->AIB_CODTAB+(cCursor)->AIB_CODPRO
	dbSelectArea(cCursor)
	dbSkip()
	IncProc(STR0013+" : "+cUltProc) //"Reajustando"
EndDo
If lQuery
	dbSelectarea(cCursor)
	dbCloseArea()
	dbSelectArea("AIB")
Else
	dbSelectArea("AIB")
	RetIndex("AIB")
	Ferase(cArqInd+OrdBagExt())
EndIf
RestArea(aArea)
Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaRejTabCom� Autor � Eduardo Riera         � Data �03.10.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de reajuste da tabela de preco                       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpN1: Numerico (Preco de Compra)                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Fornecedor                                           ���
���          �ExpC2: Loja                                                 ���
���          �ExpC3: Tabela de Preco                                      ���
���          �ExpC4: Codigo do Produto                                    ���
���          �ExpN1: Fator                                                ���
���          �ExpN2: Decimais a serem consideradas                        ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
static Function MaRejTabCom1(cCodFor,cLoja,cCodTab,cCodPro,nFator,nDecimais,cdesc1,cdesc2,cdesc3,cdesc4,cdesc5,cdesc6,ldesc1,ldesc2,ldesc3,ldesc4,ldesc5,ldesc6)

Local aArea    := GetArea()
Local aAreaAIA := AIA->(GetArea())
Local aAreaAIB := AIB->(GetArea())
Local nBase    := 0

DEFAULT nDecimais := TamSx3("AIB_PRCVEN")[2]

dbSelectArea("AIB")
dbSetOrder(2)
If DbSeek(xFilial("AIB")+cCodFor+cLoja+cCodTab+cCodPro)
	While !Eof() .And. AIB->AIB_FILIAL == xFilial("AIB") .And.;
			AIB->AIB_CODFOR == cCodFor .And.;
			AIB->AIB_LOJFOR == cLoja .And.;
			AIB->AIB_CODTAB == cCodTab .And.;
			AIB->AIB_CODPRO == cCodPro

		Begin Transaction

			RecLock("AIB")

			nBase   := AIB->AIB_PRBASE

			nBase1 := If(nFator > 0, NoRound(nBase * nFator,nDecimais), nBase )
			
			AIB->AIB_PRBASE:=nBase1
			
			If ldesc1
				AIB->AIB_DESC1 :=cdesc1
			EndIf
			If ldesc2 
				AIB->AIB_DESC2 :=cdesc2
			EndIf
			If ldesc3 
				AIB->AIB_DESC3 :=cdesc3
			EndIf
			If ldesc4
				AIB->AIB_DESC4 :=cdesc4 
			EndIf
			If ldesc5 
				AIB->AIB_DESC5 :=cdesc5
			EndIf
			If ldesc6 
				AIB->AIB_DESC6 :=cdesc6
			Endif
			nBase1:=round(((((((nBase1*(100-AIB->AIB_DESC1)/100)*(100-AIB->AIB_DESC2)/100)*(100-AIB->AIB_DESC3)/100)*(100-AIB->AIB_DESC4)/100)*(100-AIB->AIB_DESC5)/100)*(100-AIB->AIB_DESC6)/100),2)
			AIB->AIB_PRCCOM:=nBase1
			MsUnLock() 

		End Transaction 
		
		dbSelectArea("AIB")
		dbSkip()
	EndDo
EndIf
RestArea(aAreaAIB)
RestArea(aAreaAIA)
RestArea(aArea)
Return(.T.)