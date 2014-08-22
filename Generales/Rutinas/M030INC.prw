#include "Protheus.ch"
#include 'Ap5Mail.ch'
#Include "RWMAKE.CH"
#Include "tbiconn.ch"
#Include "TOTVS.ch" 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M030Inc   ºAutor  ³Microsiga           º Data ³  12/25/11   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
Ponto de entrada executado na final da transacao de inclusao | alteracao
| exclusao.
Apos a confirmacao sera gravado ou modificado o produto em todas as empresas
cadastradas no SIGAMAT.EMP.
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M030Inc()
	
	Local nxOpc 	:= 0
	Local nX		:= 0
	Local aSA1		:= {}
	Local aArea		:= GetArea()
	Local nCantErr  := 0
	Local nCantErr1 := 0
	Local lsalir    := .F.
	Local lMsErroAuto := .F.
	Local cCount	:= 0
	Local lRet		:= .T.

	Local cEmpResp	:= '01'
	Local cFilResp	:= '01'
	
	
	//Variaveis RPC
	Local cAmb		:= GetEnvServ()
	Local cLocal	:= "localhost" //GetMv("MV_XLOCAL",,"LocalHost")
	Local nPorta	:= 1235 //GetMv("MV_XPORTA",,1235)

	//Verifica se esta na empresa correta
	//para replicar o produto
	If cEmpAnt <> cEmpResp
		Return()
	EndIf
	
	//nxOpc = 1 - Inclusao | Alteracao
	//nxOpc = 2 - Exclusao
	
	//Guarda as informacoes do registro incluido ou alterado
	//para gravar nas demais empresas e filiais
	If inclui
		For nX:= 1 To SA1->(FCount())
			aAdd(aSA1,{ SA1->(FieldName(nX)), SA1->(FieldGet(nX)), Posicione("SX3",2,SA1->(FieldName(nX)),"X3_TIPO")})			
		Next nX
	Else	
		Return()	
	EndIf
	
	//Cria objeto RPC para abrir outra empresa
	oServer := TRPC():New(cAmb)

	SM0->(DbGoTop())
	While SM0->(!Eof())
		
		//Caso seja a mesma empresa e filial que o produto
		//foi cadastrado sera ignorado
		If cEmpAnt == SM0->M0_CODIGO .OR. cCount>0 
			SM0->(DbSkip())
			Loop
		EndIf
		
                    
 	  	If oServer:Connect(cLocal,nPorta) 
 	  		oServer:CallProc("RPCSetType",3)
		 	oServer:CallProc("RPCSetEnv",SM0->M0_CODIGO,SM0->M0_CODFIL,,,,, {"SA1"})
		 	lDel:=(nxOpc == 2)
	 	 	LjMsgRun("Espere, actualizando Cliente en la empresa "+SM0->M0_CODIGO+" - "+SM0->M0_CODFIL,"",{|| oServer:CallProc('U_MANSA1',aSA1,lDel)})
            cCount :=1 
			oServer:CallProc( "DbCloseAll" )
			oServer:Disconnect()

	 	Else
	 		Aviso("Atención!","Error de conexión.",{"Ok"},3,"ERRO RPC")
			lRetQry:=.F.
			Return()
	 	EndIf 
		               
		SM0->(DbSkip())
	EndDo
	
	RestArea(aArea)	
                  
Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT010CAN  ºAutor  ³Microsiga           º Data ³  12/25/11   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
Funcao responsavel pela inclusao ou modificacao do produto nas empresas.
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MANSA1(aSA1,lDel)
	
	Local nX			:= 1
	Local aStruct		:= SA1->(DbStruct())
	Local nPos			:= 0
	Local nPosCod		:= aScan( aSA1,{ |x| Alltrim(x[1]) == "A1_COD" } )	 
	Local nPosloja		:= aScan( aSA1,{ |x| Alltrim(x[1]) == "A1_LOJA"  } )	
	Local _cModo		:= AllTrim(GetMv("MV_WFMODMF",,"L"))
	Local lLock			:= .T.
	Local lRetRegra		:= .T.
	Local _xConteudo	:= ""
	Local  xConteudo          
	Local xcampo		:= 0
	Local xContenido
	Local _xNome		:= ""
	Private aExcecao	:= {}


	Conout(Time()+" - Empresa "+SM0->M0_CODIGO+" Filial "+SM0->M0_CODFIL+" - "+DTOS(DDATABASE))
    
	//Verifica se o produto ja existe	
	DbSelectArea( "SA1" )
	SA1->(DbSetOrder(1))
	If SA1->(DbSeek(xFilial("SA1")+ aSA1[nPosCod][2] +aSA1[nPosLoja][2]))
		lLock	:= .F.		
	EndIf
	
	//Caso seja delecao
	If lDel .And. !lLock
		Conout(Time()+" - Borrando cliente "+Alltrim(SA1->A1_COD)+"- "+DTOS(DDATABASE))
		//Nao esta sendo usado execauto por motivos de inconsistencias de cadastro entre empresas
		//por este motivo esta sendo utilizado DBDELETE().
		RecLock("SA1",.F.)
			SA1->(DbDelete())
		SA1->(MsUnLock())
	ElseIf !lDel
		RecLock("SA1",lLock)
		
			For nX := 1 to Len(aStruct)
				
		  		nPos:= aScan( aSA1,{ |x| Alltrim(x[1]) == Alltrim(aStruct[nX][1]) } )	
				
				//Verifica se o campo existe no dicionario
				//da empresa que foi cadastrada o produto
				If nPos == 0
					Loop
				EndIf
				        
				//Verifica se o tipo do campo esta igual
				If Alltrim(aSA1[nPos][3]) <> Alltrim(aStruct[nX][2]) 
					Loop
				EndIf
					
				//Os campos abaixo esta com bug na funcao fieldput
				If Alltrim(aStruct[nX][1]) $ "A1_FILIAL"
					SA1->A1_FILIAL 	:= xFilial("SA1")
					Loop
				EndIf
				
				lRetRegra  := .T.
				_xConteudo := aSA1[nX][2]
				_xNome     := aSA1[nX][1]
				xCampo	   := aScan( aSA1,{ |x| Alltrim(x[1]) == aStruct[nX,1] } )
				xContenido := aSA1[xCampo][2]
				
				//Verifica regra de excecao para o campo
		   //		xConteudo	:= u_RegraCampo( _xConteudo , SA1->(FieldGet(nX)) , _xNome , lLock , xFilial("SA1") , _cModo , @lRetRegra )
				
				If lRetRegra
					DbSelectArea("SA1")
					nPos := FieldPos(aStruct[nX,1] )
					If nPos > 0
						FieldPut( nPos , xContenido )
					Endif							
				Endif
				
				Conout(Time()+" - Inclusion contenido de campo "+Alltrim(aStruct[nX][1])+"- "+DTOS(DDATABASE))
				
			Next nX
		SA1->(MsUnLock())	
	EndIf	               
	
Return()


/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RegraCampo     ³Rev.  ³ Mauro Paladini    ³ Data ³ 07/2010   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³          ³Valida o campo em questao na tabela de excecoes de campos da ³±±
±±³          ³replica.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                             ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Identifica se o campo deve ter um conteudo padrao ao ser     ³±±
±±³          ³importado na base de dados.                                  ³±±
±±³          ³                                                             ³±±
±±³          ³                                                             ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function RegraCampo( cConteudo , cContAtual , cCampo , lInclusao , cFilExc , cLojaMatriz , lRetRegra )

	Local cIncAlt	:= IIF( lInclusao , "I" , "A" )
	Local nPos1		:= 0
	Local cTipoRet	:= ""
		
	nPos1 := aScan( aExcecao , { |x| x[EX_TIPOE] + x[EX_FILIAL] + x[EX_IA] + RTrim(x[EX_CAMPO]) == cLojaMatriz + cFilExc + cIncAlt + RTrim(cCampo) } )	

	If nPos1 > 0
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se o campo esta cadastrado como alteracao ou inclusao   ³
		//³ e NAO tem conteudo estandar entao nao pisa o conteudo   ³
		//³ na base que esta sendo atualizada.                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If Alltrim(aExcecao[nPos1,EX_CONTEUD]) <> ""
				
			SX3->( DbSetOrder(2) )
			SX3->( DbSeek( RTrim(cCampo) ) )
			
			IF SX3->X3_TIPO == "C"
				cConteudo	:= RTrim(aExcecao[nPos1,EX_CONTEUD])
			Elseif SX3->X3_TIPO == "D"
				cConteudo	:= cTod(aExcecao[nPos1,EX_CONTEUD])
			Elseif SX3->X3_TIPO == "N"
				cConteudo	:= Val(aExcecao[nPos1,EX_CONTEUD]) / 100
			Endif	
			
			lRetRegra  := .T.
		
		Else 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Quando existir uma excecao de alteracao e o conteudo padrao                       ³
		//³ estiver em branco, significa que nao deve ser alterado na base                    ³
		//³ nova.                                                                             ³
		//³                                                                                   ³
		//³ Ou seja o registro foi incluido e esse campo pode ter sido                        ³
		//³ modificado na nova base e nao deve ser atualizado.                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			If !lInclusao
				lRetRegra  := .F.
			Endif
				
		Endif
	
	Endif

Return cConteudo