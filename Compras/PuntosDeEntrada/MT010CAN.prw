#Include "Protheus.Ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT010CAN  บAutor  ณMicrosiga           บ Data ณ  12/25/11   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
Ponto de entrada executado na final da transacao de inclusao | alteracao
| exclusao.
Apos a confirmacao sera gravado ou modificado o produto em todas as empresas
cadastradas no SIGAMAT.EMP.
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function MT010CAN()
	
	Local nxOpc 	:= PARAMIXB[1]
	Local nX		:= 0
	Local aSB1		:= {}
	Local aArea		:= GetArea()
	
	//Parametros que definem a empresa e filial
	//responsavel pela replicacao do produto nas
	//demais empresas
	Local cEmpResp	:= GetMv("MV_XEMPREP",,"00")
	Local cFilResp	:= GetMv("MV_XFILREP",,"00")
	
	
	//Variaveis RPC
	Local cAmb		:= GetEnvServ()
	Local cLocal	:= GetMv("MV_XLOCAL",,"LocalHost")
	Local nPorta	:= GetMv("MV_XPORTA",,1234)
	
	
	//Verifica se esta na empresa correta
	//para replicar o produto
	If cEmpAnt+cFilAnt <> cEmpResp+cFilResp
		Return()
	EndIf
	
	//nxOpc = 1 - Inclusao | Alteracao
	//nxOpc = 2 - Exclusao
	If nxOpc <> 1 .And. nxOpc <> 2
		Return()
	EndIf
	
	//Guarda as informacoes do registro incluido ou alterado
	//para gravar nas demais empresas e filiais
	If nxOpc == 1
		For nX:= 1 To SB1->(FCount())
			aAdd(aSB1,{ SB1->(FieldName(nX)), SB1->(FieldGet(nX)), Posicione("SX3",2,SB1->(FieldName(nX)),"X3_TIPO")})			
		Next nX
	Else	
		aSB1:= axSB1	
	EndIf
	
	//Cria objeto RPC para abrir outra empresa
	oServer := TRPC():New(cAmb)
	SM0->(DbGoTop())
	While SM0->(!Eof())
		
		//Caso seja a mesma empresa e filial que o produto
		//foi cadastrado sera ignorado
		If cEmpAnt+cFilAnt == SM0->M0_CODIGO+SM0->M0_CODFIL
			SM0->(DbSkip())
			Loop
		EndIf
		
		If oServer:Connect(cLocal,nPorta)
			oServer:CallProc("RPCSetType",3)
			oServer:CallProc("RPCSetEnv",SM0->M0_CODIGO,SM0->M0_CODFIL,,,,, {"SB1"})
			LjMsgRun("Espere, actualizando producto en la empresa "+SM0->M0_CODIGO+" - "+SM0->M0_CODFIL,"",{|| oServer:CallProc("U_MANPROD",aSB1,nxOpc == 2)})
			//U_INCPROD(aSB1,nxOpc == 2)
			oServer:CallProc( "DbCloseAll" )
			oServer:Disconnect()
		Else
			Aviso("Atenci๓n!","Error de conexi๓n.",{"Ok"},3,"ERRO RPC")
			lRetQry:=.F.
			Return()
		EndIf 
		               
		SM0->(DbSkip())
	EndDo
	
	RestArea(aArea)
	
Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT010CAN  บAutor  ณMicrosiga           บ Data ณ  12/25/11   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
Funcao responsavel pela inclusao ou modificacao do produto nas empresas.
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function MANPROD(aSB1,lDel)
	
	Local nX			:= 1
	Local aStruct		:= SB1->(DbStruct())
	Local nPos			:= 0
	Local nPosCod		:= aScan( aSB1,{ |x| Alltrim(x[1]) == "B1_COD" } )	
	Local _cModo		:= AllTrim(GetMv("MV_WFMODMF",,"L"))
	Local lLock			:= .T.
	Local lRetRegra		:= .T.
	Local _xConteudo	:= ""
	Local _xNome		:= ""
	Private aExcecao	:= {}
	
	//Carrega excessoes
	Z0E->( DbGoTop() )
	While Z0E->( !Eof() )
		aAdd( aExcecao , { 	Z0E->Z0E_ITEM ,;
							Z0E->Z0E_TIPOE	,;
							Z0E->Z0E_TABELA	,;
							Z0E->Z0E_FILEXC	,;
							Z0E->Z0E_CAMPO	,;
							Z0E->Z0E_INCALT	,;
							Z0E->Z0E_PADRAO	})
							
		Z0E->( DbSkip() )
	EndDo
	
	Conout(Time()+" - Empresa "+SM0->M0_CODIGO+" Filial "+SM0->M0_CODFIL+" - "+DTOS(DDATABASE))
    
	//Verifica se o produto ja existe	
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+ aSB1[nPosCod][2]))
		lLock	:= .F.		
	EndIf
	
	//Caso seja delecao
	If lDel .And. !lLock
		Conout(Time()+" - Deletando produto "+Alltrim(SB1->B1_COD)+"- "+DTOS(DDATABASE))
		//Nao esta sendo usado execauto por motivos de inconsistencias de cadastro entre empresas
		//por este motivo esta sendo utilizado DBDELETE().
		RecLock("SB1",.F.)
			SB1->(DbDelete())
		SB1->(MsUnLock())
	ElseIf !lDel
		RecLock("SB1",lLock)	
			For nX := 1 to Len(aStruct)
				
				nPos:= aScan( aSB1,{ |x| Alltrim(x[1]) == Alltrim(aStruct[nX][1]) } )	
				
				//Verifica se o campo existe no dicionario
				//da empresa que foi cadastrada o produto
				If nPos == 0
					Loop
				EndIf
				        
				//Verifica se o tipo do campo esta igual
				If Alltrim(aSB1[nPos][3]) <> Alltrim(aStruct[nX][2]) 
					Loop
				EndIf
				
				//Os campos abaixo esta com bug na funcao fieldput
				If Alltrim(aStruct[nX][1]) $ "B1_QB|B1_LOJPROC|B1_FILIAL"
					SB1->B1_FILIAL 	:= xFilial("SB1")
					SB1->B1_QB		:= SB1->B1_QB
					SB1->B1_LOJPROC	:= SB1->B1_LOJPROC
					Loop
				EndIf
				
				lRetRegra  := .T.
				_xConteudo := aSB1[nX][2]
				_xNome     := aSB1[nX][1]
				
				//Verifica regra de excecao para o campo
				_xConteudo	:= u_RegraCampo( _xConteudo , SB1->(FieldGet(nX)) , _xNome , lLock , xFilial("SB1") , _cModo , @lRetRegra )
				
				If lRetRegra
					DbSelectArea("SB1")
					nPos := FieldPos(aStruct[nX,1] )
					If nPos > 0
						FieldPut( nPos , _xConteudo )
					Endif							
				Endif
				
				Conout(Time()+" - Incluido conteudo do campo "+Alltrim(aStruct[nX][1])+"- "+DTOS(DDATABASE))
				
			Next nX
		SB1->(MsUnLock())	
	EndIf	
	
Return()