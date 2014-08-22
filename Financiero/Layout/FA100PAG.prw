#include "PROTHEUS.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  บAutor  ณAlejandro Perret    บFecha ณ 14/08/2009  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impresion del movimiento bancario.                         บฑฑ
ฑฑบ          ณmodificacion Sergio DUre 9/01/2010	                      บฑฑ
ฑฑบ          ณmodificacion Nicolas Cirigliano 20/02/2014                  บฑฑ
ฑฑฬออออออออออัอออออออัออออออออออออออออออออออออออออออหออออออัออออออออออออออนฑฑ
ฑฑบUso       ณ FINA100                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function FA100PAG()
	
	Local aArea 		:= GetArea()
	Local cDesc1		:= "Este programa imprime el comprobante de Movimiento Bancario"
	Local cDesc2		:= ""
	Local cDesc3		:= ""
	Local wnrel			:= "FA100PAG"
	Local cString		:= "SE5"
	Local cPerg         := PAdr("MPG100",10," ")

	Private M_PAG		:= 1
	Private tamanho		:= "P"
	Private limite		:= 80
	Private titulo		:= "Movimientos bancarios y cajas"
	Private aReturn		:= { OemToAnsi("A Rayas"), 1,OemToAnsi("Administracion"), 2, 2,1,"",1 } //"Zebrado"###"Administracao"
	Private nomeprog	:= "FA100PAG"
	Private nLastKey	:= 0
	private entra 		:= .T.
	Private nLine 		:= 0
	Private lEntre 		:= .F.
	
	//---------------------------
	/*
	Private cBcoOrig	:= ParamIxb[1]
	Private cAgenOrig	:= ParamIxb[2]
	Private cCtaOrig	:= ParamIxb[3]
	Private cNaturOri	:= ParamIxb[4]
	
	Private cBcoDest	:= ParamIxb[5]
	Private cAgenDest	:= ParamIxb[6]
	Private cCtaDest	:= ParamIxb[7]
	Private cNaturDes	:= ParamIxb[8]
	
	Private cTipoTran	:= ParamIxb[9]
	Private nValorTran	:= ParamIxb[10]
	Private cDocTran	:= ParamIxb[11]
	Private cBenef100	:= ParamIxb[12]
	Private cHist100	:= ParamIxb[13]
	Private cModSpb		:= ParamIxb[14]
	*/
	//---------------------------
	Private cData := ""
	Private cBcoOrig 
	Private cAgenOrig
	Private cCtaOrig
	Private cNaturOri
	
	Private cTipoTran
	Private nValorTran
	Private cDocTran
	Private cBenef100
	Private cHist100
	Private cModSpb  
	Private cTipo
	Private cSecNum
	Private cSecNumV	// Secuencia de Numero Vigente
	Private cSecNumP	// Secuencia de Numero
	Private cSecNumS	// Secuencia de Numero
	
	If Funname()=="FINA100"
		cBcoOrig	:= E5_BANCO
		cAgenOrig	:= E5_AGENCIA
		cCtaOrig	:= E5_CONTA
		cNaturOri	:= E5_NATUREZ
		cTipoTran	:= E5_MOEDA
		nValorTran	:= E5_VALOR
		cNumCh      := E5_NUMCHEQ
		cDocTran	:= E5_DOCUMEN
		cBenef100	:= E5_BENEF
		cHist100	:= E5_HISTOR
		cTipo 		:= E5_RECPAG
		lEntre := .T.
	Else               
	   //ajusta o crea las preguntas                       	
	   ajustasx1(cPerg)	
		if pergunte(cPerg,.t.)
			//	PARAMETROS: NUMERO A IMPRIMIR? / DE BANCO ORIGEN?
			//	Buscar el movimiento y reemplazar estos valores
			
			cAliasSE5:="SE5_TMP"
			If Select((cAliasSE5))<>0
				DbSelectArea((cAliasSE5))
				DbCloseArea()
			Endif

			cQuery:="SELECT E5_BANCO,E5_AGENCIA,E5_CONTA,E5_RECPAG,E5_BENEF,E5_HISTOR,E5_NATUREZ,E5_VALOR,E5_MOEDA,E5_NUMCHEQ,E5_DOCUMEN,E5_SECNUM "
			cQuery+="FROM "+RetSqlName("SE5")+" "+(cAliasSE5)+" "
			cQuery+="WHERE E5_FILIAL='"+xfilial("SE5")+"' AND D_E_L_E_T_<>'*' "
			cQuery+=" AND ( E5_DOCUMEN = '"+mv_par01+"' "
			cQuery+=" AND ( E5_RECPAG = 'P' OR E5_RECPAG = 'R' ) "
			cQuery+=" AND E5_BANCO = '"+MV_PAR02+"' AND E5_AGENCIA = '"+MV_PAR03+"' AND E5_CONTA = '"+MV_PAR04+"'"

			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasSE5),.F.,.T.)
			cuenta:=0
			DBSELECTAREA((cAliasSE5))
			dbgotop()
			cData		:= (cAliasSE5)->E5_DATA
			cBcoOrig	:= (cAliasSE5)->E5_BANCO
			cAgenOrig	:= (cAliasSE5)->E5_AGENCIA
			cCtaOrig	:= (cAliasSE5)->E5_CONTA
			cNaturOri	:= (cAliasSE5)->E5_NATUREZ
			cTipoTran	:= (cAliasSE5)->E5_MOEDA
			nValorTran	:= (cAliasSE5)->E5_VALOR
			cNumCh      := (cAliasSE5)->E5_NUMCHEQ
			cDocTran	:= (cAliasSE5)->E5_DOCUMEN
			cBenef100	:= (cAliasSE5)->E5_BENEF
			cHist100	:= (cAliasSE5)->E5_HISTOR
		    cTipo 		:= (cAliasSE5)->E5_RECPAG
			cuenta++

			if cuenta > 0
				entra:=.t. 
			else 
				entra:=.f.
				msgalert("No hay datos para mostrar...")
			endif
		else
			entra:=.f.
		endif
	EndIf
	if entra
		If MsgYesNo("Desea imprimir el comprobante?","Comprobante Movimiento bancacrio")
			wnrel := SetPrint(cString,wnrel,,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,tamanho,"",.T.)
			If nLastKey <> 27
				SetDefault(aReturn,cString)
				If nLastKey <> 27
					RptStatus({|| ImpComp()},Titulo)
					If aReturn[5]==1
						dbCommitAll()
						SET PRINTER TO
						OurSpool(wnrel)
					Endif
					MS_FLUSH()
				Endif
			Endif
			RestArea(aArea)
		EndIf
	endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpComp    บAutor  ณAlejandro Perret    บFecha ณ  14/08/09   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime el comprobante.                                     บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FINA100                                                     บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpComp()
Local cAux := ""
Local nMoedaCx := 0
Local aSA6 := SA6->(GetArea())

SA6->(DbSetOrder(1))
SA6->(DbSeek(xFilial("SA6")+cBcoOrig+cAgenOrig+cCtaOrig))
nMoedaCx:=Max(SA6->A6_MOEDA,1)
cAux:="MV_SIMB"+Alltrim(Str(nMoedaCx))

Cabec(Titulo,"","",NomeProg,Tamanho)

nLine := nLine +7

@nLine,017 Psay "Tipo de Movimiento: " + Iif(cTipo=="R","Ingreso","Egreso")
nLine := nLine +5
@nLine,017 Psay "De Banco  : " + cBcoOrig  + " - "+ Alltrim(SA6->A6_NREDUZ)
nLine++
@nLine,017 Psay "Agencia   : " + cAgenOrig
nLine++
@nLine,017 Psay "Cuenta    : " + cCtaOrig
nLine++
@nLine,017 Psay "Naturaleza: " + Posicione("SED",1,xfilial("SED")+ cNaturOri,"ED_DESCRIC")
nLine++
@nLine,017 Psay "Cheque    : " + cNumCh

nLine++
nLine++

@nLine,017 Psay "Valor     : " + Alltrim(SuperGetMV(cAux,,"")) + TransForm(nValorTran,"@E 9,999,999.99" )

nLine++
@nLine,017 Psay "Documento : " + cDocTran
nLine++
@nLine,017 Psay "Benefic.  : " + cBenef100
nLine++
@nLine,017 Psay "Historial : " + cHist100
nLine++

nLine := nLine +20
@nLine,011 Psay "______________________________"
@nLine,045 Psay "______________________________"
nLine++
@nLine,011 Psay "Firma de Responsable"
@nLine,045 Psay "Firma de Responsable"

SA6->(RestArea(aSA6))
Return()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ AjustaSX1บ Autor ณ Gilson da Silva   บ Data ณ  29.01.04    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Criacao de Perguntas no SX1                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MATRAR1                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function AjustaSX1(cPerg)

PutSx1(cPerg,"01","De Numero de movimiento bancario ?","De numero de Movimiento ?","De Numero de Numero de movimiento ?","mv_ch1","C",15,0,0,"G","","","","","mv_par01","","","","",;
"","","","","","","","","","","","")

PutSx1(cPerg,"02","Banco Origen ?","Banco Origen ?","Banco Origen ?","mv_ch2","C",3,0,0,"G","","SA6","","","mv_par02","","","","",;
"","","","","","","","","","","","")

PutSx1(cPerg,"03","Agencia Origen ?","Agencia Origen ?","Agencia Origen ?","mv_ch3","C",5,0,0,"G","","","","","mv_par03","","","","",;
"","","","","","","","","","","","")

PutSx1(cPerg,"04","Cuenta Origen ?","Cuenta Origen ?","Cuenta Origen ?","mv_ch4","C",10,0,0,"G","","","","","mv_par04","","","","",;
"","","","","","","","","","","","")

RETURN
