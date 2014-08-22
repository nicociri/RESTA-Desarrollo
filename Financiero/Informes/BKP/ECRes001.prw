#include 'protheus.ch'

/*/{Protheus.doc} ECRes001
Informe Detallado de Cobros
@author Diegho
@since 17/07/2014
@version 1.0
/*/
User Function ECRes001()
Local oReport

oReport := ReportDef()

oReport:PrintDialog()
      
Ms_Flush()

Return


/*/{Protheus.doc} ReportDef
Definición del Reporte 
@author Diegho
@since 17/07/2014
@version 1.0
@return oReport, object, Intancia del Reporte
/*/
Static Function ReportDef()
Local oReport
Local oSection	
Local cNomeRel	:= 'ECRES001'
Local cTitulo	:= 'Informe Detallado de Cobros'
Local cPerg		:= PadR( 'MERFIN01', 10 )

AjustaSX1( cPerg )   

Pergunte( cPerg, .F. )

oReport := TReport():New(	cNomeRel,;
									cTitulo,;
									cPerg,;
									{ |oReport| ReportPrint(oReport) },;
									"Este reporte lista las cobranzas realizas por SIGALOJA." )


Pergunte( oReport:uParam, .F. )

oSection	:=	TRSection():New( oReport, "Ventas", { "SL1" } )

TRCell():New( oSection, "FECHA",, "Fecha Recibo",, 12,, /*{||}*/ )
TRCell():New( oSection, "RECIBO",, "Numero Recibo",, 13,, /*{||}*/ )
TRCell():New( oSection, "CLIENTE",, "Razón Social",, 50,, /*{||}*/ )
TRCell():New( oSection, "CBTE",, "Numero Comprobante",, 21,, /*{||}*/ )
TRCell():New( oSection, "TOTAL",, "Importe Documento", "@E 999,999,999.99", 14,,/*{||}*/)
TRCell():New( oSection, "FORMA",, "Tipo Valor",, 15,, /*{||}*/)
TRCell():New( oSection, "CUIT",, "CUIT Firmante",, 17,, /*{||}*/)
TRCell():New( oSection, "CARTON",, "Numero Valor",, 22,, /*{||}*/)
TRCell():New( oSection, "IMPORTE",, "Importe Valor", "@E 999,999,999.99", 14,,/*{||}*/)

oReport:SetLandScape()

Return( oReport )


/*/{Protheus.doc} ReportPrint
Impresión del Reporte 

@author Diegho
@since 17/07/2014
@version 1.0
@param oReport, object, Objeto del Reporte
/*/
Static Function ReportPrint( oReport )
Local oSection := oReport:Section(1)
Local dDataAtu	:= mv_par03

oReport:SetMeter(0)

nTotG2	:= 0
nTotG1	:= 0

oSection:Init()

While dDataAtu <= mv_par04

	
	BeginSQL Alias 'TRB'
	
		COLUMN L1_EMISNF AS DATE
		COLUMN L4_TOTAL AS NUMERIC( 17, 2 )
		COLUMN E5_VALOR AS NUMERIC( 17, 2 )
		COLUMN L4_VALOR AS NUMERIC( 17, 2 )
	
		SELECT A.L1_FILIAL, A.L1_EMISNF, A.L1_DOC, A.L1_SERIE, A.L1_NUM, A.L1_CLIENTE, A.L1_LOJA, A.L1_OPERADO, 
			(	SELECT SUM( L4_VALOR ) AS L4_VALOR
				FROM %Table:SL4% B
				WHERE B.L4_FILIAL = A.L1_FILIAL
					AND B.L4_NUM = A.L1_NUM 
					AND B.%NotDel% ) L4_TOTAL,
			(	SELECT ISNULL( SUM( D.E5_VALOR ), 0 )
				FROM %Table:SE5% D
				WHERE E5_PREFIXO = A.L1_SERIE
					AND E5_NUMERO = A.L1_DOC
					AND E5_TIPO = 'CR'
					AND E5_BANCO = A.L1_OPERADO
					AND %NotDel% ) E5_VALOR, 
			C.L4_FORMA, C.L4_NUMCART, C.L4_VALOR 
		FROM %Table:SL1% A, %Table:SL4% C
		WHERE A.L1_CLIENTE BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
			AND A.L1_EMISNF = %Exp:DtoS(dDataAtu)% 
			AND C.L4_FILIAL = A.L1_FILIAL 
			AND C.L4_NUM = A.L1_NUM
			AND A.%NotDel%
			AND C.%NotDel%
		ORDER BY A.L1_FILIAL, A.L1_EMISNF, A.L1_DOC
	
	EndSQL 
	
	TRB->(DbGoTop())

	While !TRB->(Eof())
	
		cFil		:= TRB->L1_FILIAL
		dEmis		:= TRB->L1_EMISNF
		cDoc		:= TRB->L1_DOC
		cSerie	:= TRB->L1_SERIE
		cOperado	:= TRB->L1_OPERADO
		lFirst	:= .T.
		lMore		:= .F.
		nTot1		:= 0
		nTot2		:= 0
	
		While !TRB->(Eof()) .and. ;
			cFil == TRB->L1_FILIAL .and. ;
			dEmis	== TRB->L1_EMISNF .and. ;
			cDoc == TRB->L1_DOC 
			
			If lFirst
				lFirst	:= .F.
				oSection:Cell('FECHA'):Show()
				oSection:Cell('RECIBO'):Show()
				oSection:Cell('CBTE'):Show()
				oSection:Cell('CLIENTE'):Show()
				oSection:Cell('TOTAL'):Show()
				oSection:Cell('FORMA'):Show()
				oSection:Cell('CUIT'):Show()
				oSection:Cell('CARTON'):Show()
				oSection:Cell('IMPORTE'):Show()
				
				nTot1		:= TRB->L4_TOTAL + TRB->E5_VALOR
				nTotG1	+=	TRB->L4_TOTAL + TRB->E5_VALOR
				
				SA1->(DbSetOrder(1))
				SA1->(DbSeek( xFilial('SA1') + TRB->L1_CLIENTE + TRB->L1_LOJA ))
				
			Else
				lMore	:= .T.
				oSection:Cell('FECHA'):Hide()
				oSection:Cell('RECIBO'):Hide()
				oSection:Cell('CBTE'):Hide()
				oSection:Cell('CLIENTE'):Hide()
				oSection:Cell('TOTAL'):Hide()
			EndIf
			
			oSection:Cell('FECHA'):SetBlock( { || TRB->L1_EMISNF } )
			oSection:Cell('RECIBO'):SetBlock( { || TRB->L1_DOC } )
			oSection:Cell('CLIENTE'):SetBlock( { || SubStr( AllTrim( SA1->A1_NOME ), 1, 40 ) + '(' + AllTrim( TRB->L1_CLIENTE ) + ')' } )
			oSection:Cell('CBTE'):SetBlock( { || 'NF  ' + TRB->L1_SERIE + ' ' + Left( TRB->L1_DOC, 4 ) + '-' + Right( TRB->L1_DOC, 8 ) } )
			oSection:Cell('TOTAL'):SetBlock( { || TRB->L4_TOTAL + TRB->E5_VALOR } )
			oSection:Cell('FORMA'):SetBlock( { || AllTrim( Posicione( 'SX5', 1, xFilial('SX5') + '24' + AllTrim( TRB->L4_FORMA ), 'X5_DESCSPA' ) ) } )
			oSection:Cell('CUIT'):SetBlock( { || '' } )
			oSection:Cell('CARTON'):SetBlock( { || TRB->L4_NUMCART } )
			oSection:Cell('IMPORTE'):SetBlock( { || TRB->L4_VALOR } )
			
			nTot2		+= TRB->L4_VALOR
			nTotG2	+=	TRB->L4_VALOR
			
			oSection:PrintLine()
			oReport:IncMeter() 
	
			TRB->(DbSkip())
		EndDo
		
		BeginSQL Alias 'TRBSE5'
			COLUMN E5_VALOR AS NUMERIC( 17, 2 )
		
			SELECT E5_TIPO, E5_DOCUMEN, E5_VALOR
			FROM %Table:SE5%
			WHERE E5_PREFIXO = %Exp:cSerie%
				AND E5_NUMERO = %Exp:cDoc%
				AND E5_TIPO = 'CR'
				AND E5_BANCO = %Exp:cOperado%
				AND %NotDel%
		
		EndSQL
		
		TRBSE5->(DbGoTop())
		
		While !TRBSE5->(Eof())
		
			oSection:Cell('FECHA'):Hide()
			oSection:Cell('RECIBO'):Hide()
			oSection:Cell('CBTE'):Hide()
			oSection:Cell('CLIENTE'):Hide()
			oSection:Cell('TOTAL'):Hide()
			
			oSection:Cell('FECHA'):SetBlock( { || NIL } )
			oSection:Cell('RECIBO'):SetBlock( { || NIL } )
			oSection:Cell('CBTE'):SetBlock( { || NIL } )
			oSection:Cell('CLIENTE'):SetBlock( { || NIL } )
			oSection:Cell('TOTAL'):SetBlock( { || NIL } )
			
			oSection:Cell('FORMA'):SetBlock( { || 'COMPENSACION' } )
			oSection:Cell('CUIT'):SetBlock( { || '' } )
			oSection:Cell('CARTON'):SetBlock( { || SubStr( TRBSE5->E5_DOCUMEN, 17, 3 ) + ' ' + SubStr( TRBSE5->E5_DOCUMEN, 1, 3 ) + ' ' + SubStr( TRBSE5->E5_DOCUMEN, 4, 4 ) + '-' + SubStr( TRBSE5->E5_DOCUMEN, 8, 8 ) } )
			oSection:Cell('IMPORTE'):SetBlock( { || TRBSE5->E5_VALOR } )

			nTot2		+= TRBSE5->E5_VALOR
			nTotG2	+=	TRBSE5->E5_VALOR
			
			oSection:PrintLine()
			oReport:IncMeter() 			
		
			TRBSE5->(DbSkip())
		EndDo
		
		DbSelectArea('TRBSE5')
		DbCloseArea()
		
		
		oSection:Cell('FORMA'):SetBlock( { || NIL } )
		oSection:Cell('CUIT'):SetBlock( { || NIL } )
		oSection:Cell('CARTON'):SetBlock( { || NIL } )
		oSection:Cell('IMPORTE'):SetBlock( { || NIL } )

		oSection:Cell('FECHA'):Hide()
		oSection:Cell('RECIBO'):Hide()
		oSection:Cell('CLIENTE'):Hide()
		oSection:Cell('CBTE'):Hide()
		oSection:Cell('FORMA'):Hide()	
		oSection:Cell('CUIT'):Hide()	
		oSection:Cell('CARTON'):Hide()	
		oSection:Cell('CBTE'):Show()
		oSection:Cell('TOTAL'):Show()	
		oSection:Cell('IMPORTE'):Show()	
		
		oSection:Cell('CBTE'):SetBlock( { || 'TOTAL COMPROBANTE:' } )
		oSection:Cell('TOTAL'):SetBlock( { || nTot1 } )
		oSection:Cell('IMPORTE'):SetBlock( { || nTot2 } )
		
		oSection:PrintLine()
		oReport:SkipLine()
	
	EndDo
	
	DbSelectArea('TRB')
	DbCloseArea()
	
	
	BeginSQL Alias 'TRB'
	
		COLUMN EL_DTDIGIT AS DATE
		COLUMN EL_VALOR AS NUMERIC( 17, 2 )
	
		SELECT EL_DTDIGIT, EL_RECIBO, EL_TIPO, EL_PREFIXO, EL_NUMERO, 
			EL_TIPODOC, EL_VALOR, EL_CLIORIG, EL_LOJORIG, EL_CGC
		FROM %Table:SEL%
		WHERE EL_DTDIGIT = %Exp:DtoS(dDataAtu)%
			AND EL_CANCEL <> 'T'
			AND %NotDel%
		ORDER BY EL_RECIBO, EL_TIPO, EL_PREFIXO, EL_NUMERO, EL_PARCELA
		
	EndSQL
	
	TRB->(DbGoTop())
	
	
	While !TRB->(Eof())
	
		SA1->(DbSetOrder(1))
		SA1->(DbSeek( xFilial('SA1') + TRB->EL_CLIORIG + TRB->EL_LOJORIG ))
	
		cRecibo	:= TRB->EL_RECIBO
		cCliente	:= AllTrim( SA1->A1_NOME ) + ' (' + AllTrim(TRB->EL_CLIORIG) + ')'
		dFecha	:= TRB->EL_DTDIGIT
		
		aTit	:= {}
		aPag	:= {}

		nTot1		:= 0
		nTot2		:= 0
		
		While !TRB->(Eof()) .and. cRecibo == TRB->EL_RECIBO
		
			If AllTrim( TRB->EL_TIPODOC ) $ 'TB/PA'
				AAdd( aTit, { TRB->EL_TIPO + ' ' + TRB->EL_PREFIXO + ' ' + Left( TRB->EL_NUMERO, 4 ) + '-' + Right( TRB->EL_NUMERO, 8 ),;
									TRB->EL_VALOR * If( AllTrim( TRB->EL_TIPO ) $ MV_CRNEG, -1, 1 ) } )
			Else
				cForma	:= AllTrim( Posicione( 'SX5', 1, xFilial('SX5') + '24' + AllTrim( TRB->EL_TIPODOC ), 'X5_DESCSPA' ) )
				AAdd( aPag, { If( Empty(cForma), AllTrim(TRB->EL_TIPODOC), cForma ), ;
									TRB->EL_NUMERO,;
									TRB->EL_VALOR * If( AllTrim( TRB->EL_TIPO ) $ MV_CRNEG, -1, 1 ),;
									If( !Empty(TRB->EL_CGC), Left(TRB->EL_CGC,2) + '-' + SubStr(TRB->EL_CGC,3,8) + SubStr(TRB->EL_CGC,11,1), '' ) } )
			EndIf 
		
			TRB->(DbSkip())
		EndDo 
		
		nLen := Max( Len( aTit ), Len( aPag ) )
		
		For nX := 1 To nLen
		
			If nX == 1
				oSection:Cell('FECHA'):Show()
				oSection:Cell('RECIBO'):Show()
				oSection:Cell('CLIENTE'):Show()
				
				oSection:Cell('FECHA'):SetBlock( { || dFecha } )
				oSection:Cell('RECIBO'):SetBlock( { || cRecibo } )
				oSection:Cell('CLIENTE'):SetBlock( { || cCliente } )
			Else
				oSection:Cell('FECHA'):Hide()
				oSection:Cell('RECIBO'):Hide()
				oSection:Cell('CLIENTE'):Hide()
			EndIf
			
			
			If nX <= Len( aTit )
				oSection:Cell('CBTE'):Show()
				oSection:Cell('TOTAL'):Show()
				oSection:Cell('CBTE'):SetBlock( { || aTit[nX][01] } )
				oSection:Cell('TOTAL'):SetBlock( { || aTit[nX][02] } )
				nTot1		+= aTit[nX][02] 
				nTotG1	+= aTit[nX][02]
			Else
				oSection:Cell('CBTE'):Hide()
				oSection:Cell('TOTAL'):Hide()
				oSection:Cell('CBTE'):SetBlock( { || NIL } )
				oSection:Cell('TOTAL'):SetBlock( { || NIL } )
			EndIf
			
			
			If nX <= Len( aPag )
				oSection:Cell('FORMA'):Show()
				oSection:Cell('CUIT'):Show()
				oSection:Cell('CARTON'):Show()
				oSection:Cell('IMPORTE'):Show()
				oSection:Cell('FORMA'):SetBlock( { || aPag[nX][01] } )
				oSection:Cell('CUIT'):SetBlock( { || aPag[nX][04] } )
				oSection:Cell('CARTON'):SetBlock( { || aPag[nX][02] } )
				oSection:Cell('IMPORTE'):SetBlock( { || aPag[nX][03] } )			
				nTot2		+= aPag[nX][03] 
				nTotG2	+= aPag[nX][03]
			Else
				oSection:Cell('FORMA'):SetBlock( { || NIL } )
				oSection:Cell('CUIT'):SetBlock( { || NIL } )
				oSection:Cell('CARTON'):SetBlock( { || NIL } )
				oSection:Cell('IMPORTE'):SetBlock( { || NIL } )			
				oSection:Cell('FORMA'):Hide()
				oSection:Cell('CUIT'):Hide()
				oSection:Cell('CARTON'):Hide()
				oSection:Cell('IMPORTE'):Hide()
			EndIf
			
			oSection:PrintLine()
			oReport:IncMeter() 		
		Next nX 
	
		oSection:Cell('FECHA'):Hide()
		oSection:Cell('RECIBO'):Hide()
		oSection:Cell('CLIENTE'):Hide()
		oSection:Cell('CBTE'):Hide()
		oSection:Cell('FORMA'):Hide()	
		oSection:Cell('CUIT'):Hide()	
		oSection:Cell('CARTON'):Hide()	
		oSection:Cell('CBTE'):Show()
		oSection:Cell('TOTAL'):Show()	
		oSection:Cell('IMPORTE'):Show()	
		
		oSection:Cell('FECHA'):SetBlock( { || NIL } )
		oSection:Cell('RECIBO'):SetBlock( { || NIL } )
		oSection:Cell('CLIENTE'):SetBlock( { || NIL } )
		oSection:Cell('CBTE'):SetBlock( { || NIL } )
		oSection:Cell('FORMA'):SetBlock( { || NIL } )
		oSection:Cell('CUIT'):SetBlock( { || NIL } )
		oSection:Cell('CARTON'):SetBlock( { || NIL } )
		oSection:Cell('CBTE'):SetBlock( { || 'TOTAL COMPROBANTE:' } )
		oSection:Cell('TOTAL'):SetBlock( { || nTot1 } )
		oSection:Cell('IMPORTE'):SetBlock( { || nTot2 } )
		
		oSection:PrintLine()
		oReport:SkipLine()	
			
	EndDo
	
	DbSelectArea('TRB')
	DbCloseArea()

	dDataAtu	+= 1
EndDo


oReport:SkipLine()

oSection:Cell('FECHA'):Hide()
oSection:Cell('RECIBO'):Hide()
oSection:Cell('CLIENTE'):Hide()
oSection:Cell('FORMA'):Hide()	
oSection:Cell('CUIT'):Hide()	
oSection:Cell('CARTON'):Hide()	

oSection:Cell('CBTE'):Show()
oSection:Cell('TOTAL'):Show()	
oSection:Cell('IMPORTE'):Show()

oSection:Cell('FECHA'):SetBlock( { || NIL } )
oSection:Cell('RECIBO'):SetBlock( { || NIL } )
oSection:Cell('CLIENTE'):SetBlock( { || NIL } )
oSection:Cell('FORMA'):SetBlock( { || NIL } )
oSection:Cell('CARTON'):SetBlock( { || NIL } )

oSection:Cell('CBTE'):SetBlock( { || 'TOTAL GENERAL:' } )
oSection:Cell('TOTAL'):SetBlock( { || nTotG1 } )
oSection:Cell('IMPORTE'):SetBlock( { || nTotG2 } )

oSection:PrintLine()

oSection:Finish()  



Return




/*/{Protheus.doc} AjustaSX1
Verifica la existencia de las preguntas

@author Diegho
@since 17/07/2014
@version 1.0

@param cPerg, character, Código del grupo de SX1
/*/
Static Function AjustaSX1( cPerg )

PutSX1(cPerg,"01","Desde Cliente?","Desde Cliente?","Desde Cliente?",;
		"mv_ch1","C",6,;
		0,0,"G",;
		"","SA1","",;
		"","mv_par01","",;
		"","","",;
		"","","",;
		"","","",;
		"","","",;
		"","","",;
		{},{},{})

PutSX1(cPerg,"02","Hasta Cliente?","Hasta Cliente?","Hasta Cliente?",;
		"mv_ch2","C",6,;
		0,0,"G",;
		"","SA1","",;
		"","mv_par02","",;
		"","","",;
		"","","",;
		"","","",;
		"","","",;
		"","","",;
		{},{},{})
		
PutSX1(cPerg,"03","Desde Fecha?","Desde Fecha?","Desde Fecha?",;
		"mv_ch3","D",8,;
		0,0,"G",;
		"","","",;
		"","mv_par03","",;
		"","",DTOS(ddatabase),;
		"","","",;
		"","","",;
		"","","",;
		"","","",;
		{},{},{})					

PutSX1(cPerg,"04","Hasta Fecha?","Hasta Fecha?","Hasta Fecha?",;
		"mv_ch4","D",8,;
		0,0,"G",;
		"","","",;
		"","mv_par04","",;
		"","",DTOS(ddatabase),;
		"","","",;
		"","","",;
		"","","",;
		"","","",;                             
		{},{},{})			


Return

