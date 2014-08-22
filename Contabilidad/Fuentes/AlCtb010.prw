#include "protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ AlCtb010 ³ Autor ³ Marcelo Rodriguez     ³ Fecha³ 03/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Impresion de Asiento Resumen                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxis  ³ U_AlCtb010( void )                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Ninguno                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Alparamis                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Ninguno                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AlCtb010

Private CPERG,CSTRING,M,TAMANHO,LIMITE,TITULO,;
        CDESC1,CDESC2,CDESC3,CNATUREZA,ARETURN,NOMEPROG,;
        NLASTKEY,LCONTINUA,NLIN,WNREL,NTAMNF,CINDTMP,;
        NINDEX,NMESORD,CORDEN,CFORNECE,CLOJA,NNUMREG,;
        NINDEXANT,AINFORET,NPOSCON,ACONCEPTO,CCONCEPTO,NPOSBL,;
        NPOSINFO,NTOTAL,NSALDO,NRETANT,NRETACTUAL,NACUM,;
        NFORNE,NALIQ,NMONTOGRAV,NMINIMO,NNROCERT,FECHA,;
        NNETO,CMES,CANO, CNOMFORNECE,CEND,CCP,CCGC,;
        NM,NLININI,NOPCA,_SALIAS,AREGS,I,J
Private M_PAG := 1, lFirstPrint := .T.

cPerg    :="ALCTB010  "

ValidPerg()

If !Pergunte( cPerg, .T. )
   Return
EndIf

cString  := "CT2"
M        := 0
tamanho  := "G"
limite   := 220
titulo   := PADC("ASIENTO RESUMEN" ,74)
cDesc1   := PADC(" ",74)
cDesc2   := PADC("",74)
cDesc3   := ""
//Cabec1   := "Cuenta               Descrip. Cuenta                          C.C.      Descrip. C.C.                                   Debitos         Creditos" 
Cabec1   := "Cuenta               Descrip. Cuenta                           Debe         Haber"
Cabec2   := ""
cNatureza:= ""
aReturn  := { OemToAnsi("Especial"), 1,OemToAnsi("Administración"), 2, 1, 1,"",1 }
nomeprog := "ALCTB010"
nLastKey := 0
lContinua:= .T.
nLin     := 0
wnrel    := "ALCTB010"
ntipo    := 15

nTamNf   := 72

wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,"G")

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

RptStatus( {|| RptDetail()} )

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Marcelo Rodriguez     ³ Data ³ 05/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                    Marcelo Rodriguez                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RptDetail()
Local aCob     := { 0, 0 },;
      aEgr     := { 0, 0 },;
      nFinDeb  := 0,;
      nFinCre  := 0,;
      nTam     := 218


Private cAliasCT2 := 'TMPCT2',;
        nFirst    := 10,;
        nSalto    := 55,;
        cDesde    := DtoS( mv_par01 ),;
        cHasta    := DtoS( mv_par02 ),;
        aPos      := {}

M_PAG := mv_par05

Aadd( aPos, 000 )                                  // Codigo de Cuenta
Aadd( aPos, aPos[1] + Len(CT2->CT2_DEBITO) + 1 )   // Descrip. Cuenta
Aadd( aPos, aPos[2] + Len(CT1->CT1_DESC01) + 1 )   // Codigo CC
//Aadd( aPos, aPos[3] + Len(CT2->CT2_CCD   ) + 1 )   // Descrip. CC
Aadd( aPos, aPos[3] + 17 )                         // Debito
Aadd( aPos, aPos[4] + Len(CTT->CTT_DESC01) + 1 )   // Debito
Aadd( aPos, aPos[5] + 17 )                         // Saldo 


Informe( GetNewPar( 'MV_ACTR010', '001/002' ), 'ASIENTO RESUMEN' )

If aReturn[5] = 1
   Set Printer To
   Commit
   Ourspool(wnrel)
EndIf

Ms_Flush()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Marcelo Rodriguez     ³ Data ³ 05/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Informe( cMV, cTitulo )
Local aCabec
Local nProxDoc := 0

cLotes   := '%' + FormatIn( cMV, '/' ) + '%'
cTipoDeb := '%' + FormatIn( '1/3', '/' ) + '%'
cTipoCre := '%' + FormatIn( '2/3', '/' ) + '%'
cTabela  := "%'SB'%"
cNull    := "%''%"

If ALLTRIM(mv_par06)=='FAT' .and. ALLTRIM(mv_par07)=='FAT'
 
BeginSql Alias cAliasCT2
//   COLUMN DEBITO  AS NUMERIC(14,2)
//   COLUMN CREDITO AS NUMERIC(14,2)
   COLUMN SALDO	  AS NUMERIC(14,2)
   SELECT
   SUBLOTE, ISNULL( ( SELECT X5_DESCSPA FROM %Table:SX5% H WHERE X5_FILIAL = %xFilial:SX5% AND H.X5_TABELA = %Exp:cTabela% AND H.X5_CHAVE = SUBLOTE AND H.%NotDel% ),%Exp:cNull% ) AS SUBLOTED,
   CUENTA,  ISNULL( ( SELECT CT1_DESC01 FROM %Table:CT1% A WHERE CT1_FILIAL = %xFilial:CT1% AND CT1_CONTA = CUENTA  AND A.%NotDel% ), %Exp:cNull% ) AS CUENTAD,
//   CC,      
//   ISNULL( ( SELECT CTT_DESC01 FROM %Table:CTT% B WHERE CTT_FILIAL = %xFilial:CTT% AND CTT_CUSTO = CC      AND B.%NotDel% ), %Exp:cNull% ) AS CCD,
   (SUM(DEBITO)-SUM(CREDITO))*-1 AS SALDO
   FROM ( SELECT CT2_DEBITO AS CUENTA,
         //   CT2_CCD AS CC,
            SUM(CT2_VALOR) AS DEBITO,
            0 AS CREDITO,
			'FAT' AS SUBLOTE
         FROM %table:CT2% E
            WHERE CT2_FILIAL BETWEEN %Exp:mv_par09% AND %Exp:mv_par10%
            AND CT2_DATA BETWEEN %Exp:cDesde% AND %Exp:cHasta%
            AND CT2_SBLOTE BETWEEN %Exp:mv_par06% AND %Exp:mv_par07%
            AND CT2_DC IN %Exp:cTipoDeb%
            AND CT2_MOEDLC = %Exp:mv_par03%
            AND CT2_TPSALD = %Exp:mv_par04%
            AND CT2_LP <> '631'
            AND E.%NotDel%
         GROUP BY CT2_SBLOTE, CT2_DEBITO//, CT2_CCD 
         UNION ALL
         SELECT CT2_CREDIT AS CUENTA,
         //   CT2_CCC AS CC,
            0 AS DEBITO,
            SUM(CT2_VALOR) AS CREDITO,
			'FAT' AS SUBLOTE
         FROM %table:CT2% G
//            WHERE CT2_FILIAL = %xFilial:CT2%
            WHERE CT2_FILIAL BETWEEN %Exp:mv_par09% AND %Exp:mv_par10%
            AND CT2_DATA BETWEEN %Exp:cDesde% AND %Exp:cHasta%
            AND CT2_SBLOTE BETWEEN %Exp:mv_par06% AND %Exp:mv_par07%
            AND CT2_DC IN %Exp:cTipoCre%
            AND CT2_MOEDLC = %Exp:mv_par03%
            AND CT2_TPSALD = %Exp:mv_par04%
            AND CT2_LP <> '631'
            AND G.%NotDel% 
         GROUP BY CT2_SBLOTE, CT2_CREDIT ) F//, CT2_CCC ) F
   GROUP BY SUBLOTE, CUENTA
   ORDER BY SUBLOTE, SALDO ,CUENTA//, CC
EndSql 

elseIf ALLTRIM(mv_par06)=='COB' .and. ALLTRIM(mv_par07)=='COB'

BeginSql Alias cAliasCT2
//   COLUMN DEBITO  AS NUMERIC(14,2)
//   COLUMN CREDITO AS NUMERIC(14,2)
   COLUMN SALDO	  AS NUMERIC(14,2)
   SELECT
   SUBLOTE, ISNULL( ( SELECT X5_DESCSPA FROM %Table:SX5% H WHERE X5_FILIAL = %xFilial:SX5% AND H.X5_TABELA = %Exp:cTabela% AND H.X5_CHAVE = SUBLOTE AND H.%NotDel% ),%Exp:cNull% ) AS SUBLOTED,
   CUENTA,  ISNULL( ( SELECT CT1_DESC01 FROM %Table:CT1% A WHERE CT1_FILIAL = %xFilial:CT1% AND CT1_CONTA = CUENTA  AND A.%NotDel% ), %Exp:cNull% ) AS CUENTAD,
//   CC,      
//   ISNULL( ( SELECT CTT_DESC01 FROM %Table:CTT% B WHERE CTT_FILIAL = %xFilial:CTT% AND CTT_CUSTO = CC      AND B.%NotDel% ), %Exp:cNull% ) AS CCD,
   (SUM(DEBITO)-SUM(CREDITO))*-1 AS SALDO
   FROM ( SELECT CT2_DEBITO AS CUENTA,
         //   CT2_CCD AS CC,
            SUM(CT2_VALOR) AS DEBITO,
            0 AS CREDITO,
			'COB' AS SUBLOTE
         FROM %table:CT2% E
            //WHERE CT2_FILIAL = %xFilial:CT2% AND 
            WHERE CT2_FILIAL BETWEEN %Exp:mv_par09% AND %Exp:mv_par10%
            AND  CT2_DATA BETWEEN %Exp:cDesde% AND %Exp:cHasta%
            AND (CT2_SBLOTE = %Exp:mv_par06% ) or (CT2_SBLOTE='FAT' AND CT2_LP = '631') //cuando es COB, tiene que incluir las cobranzas de loja, que estan en FAT
            AND CT2_DC IN %Exp:cTipoDeb%
            AND CT2_MOEDLC = %Exp:mv_par03%
            AND CT2_TPSALD = %Exp:mv_par04%
            AND E.%NotDel%
         GROUP BY CT2_SBLOTE, CT2_DEBITO//, CT2_CCD 
         UNION ALL
         SELECT CT2_CREDIT AS CUENTA,
         //   CT2_CCC AS CC,
            0 AS DEBITO,
            SUM(CT2_VALOR) AS CREDITO,
			'COB' AS SUBLOTE
         FROM %table:CT2% G
            //WHERE CT2_FILIAL = %xFilial:CT2% AND 
            WHERE CT2_FILIAL BETWEEN %Exp:mv_par09% AND %Exp:mv_par10% 
            AND  CT2_DATA BETWEEN %Exp:cDesde% AND %Exp:cHasta%
            AND (CT2_SBLOTE BETWEEN %Exp:mv_par06% AND %Exp:mv_par07%) or (CT2_SBLOTE='FAT' AND CT2_LP = '631') //cuando es COB, tiene que incluir las cobranzas de loja, que estan en FAT
            AND CT2_DC IN %Exp:cTipoCre%
            AND CT2_MOEDLC = %Exp:mv_par03%
            AND CT2_TPSALD = %Exp:mv_par04%
            AND G.%NotDel% 
         GROUP BY CT2_SBLOTE, CT2_CREDIT ) F//, CT2_CCC ) F
   GROUP BY SUBLOTE, CUENTA
   ORDER BY SUBLOTE, SALDO ,CUENTA//, CC
EndSql

Else

BeginSql Alias cAliasCT2
//   COLUMN DEBITO  AS NUMERIC(14,2)
//   COLUMN CREDITO AS NUMERIC(14,2)
   COLUMN SALDO	  AS NUMERIC(14,2)
   SELECT
   SUBLOTE, ISNULL( ( SELECT X5_DESCSPA FROM %Table:SX5% H WHERE X5_FILIAL = %xFilial:SX5% AND H.X5_TABELA = %Exp:cTabela% AND H.X5_CHAVE = SUBLOTE AND H.%NotDel% ),%Exp:cNull% ) AS SUBLOTED,
   CUENTA,  ISNULL( ( SELECT CT1_DESC01 FROM %Table:CT1% A WHERE CT1_FILIAL = %xFilial:CT1% AND CT1_CONTA = CUENTA  AND A.%NotDel% ), %Exp:cNull% ) AS CUENTAD,
//   CC,      
//   ISNULL( ( SELECT CTT_DESC01 FROM %Table:CTT% B WHERE CTT_FILIAL = %xFilial:CTT% AND CTT_CUSTO = CC      AND B.%NotDel% ), %Exp:cNull% ) AS CCD,
   (SUM(DEBITO)-SUM(CREDITO))*-1 AS SALDO
   FROM ( SELECT CT2_DEBITO AS CUENTA,
         //   CT2_CCD AS CC,
            SUM(CT2_VALOR) AS DEBITO,
            0 AS CREDITO,
			CT2_SBLOTE AS SUBLOTE
         FROM %table:CT2% E
//            WHERE CT2_FILIAL = %xFilial:CT2%
            WHERE CT2_FILIAL BETWEEN %Exp:mv_par09% AND %Exp:mv_par10%
            AND CT2_DATA BETWEEN %Exp:cDesde% AND %Exp:cHasta%
            AND CT2_SBLOTE BETWEEN %Exp:mv_par06% AND %Exp:mv_par07%
            AND CT2_DC IN %Exp:cTipoDeb%
            AND CT2_MOEDLC = %Exp:mv_par03%
            AND CT2_TPSALD = %Exp:mv_par04%
            AND E.%NotDel%
         GROUP BY CT2_SBLOTE, CT2_DEBITO//, CT2_CCD 
         UNION ALL
         SELECT CT2_CREDIT AS CUENTA,
         //   CT2_CCC AS CC,
            0 AS DEBITO,
            SUM(CT2_VALOR) AS CREDITO,
			CT2_SBLOTE AS SUBLOTE
         FROM %table:CT2% G
//            WHERE CT2_FILIAL = %xFilial:CT2%
            WHERE CT2_FILIAL BETWEEN %Exp:mv_par09% AND %Exp:mv_par10%
            AND CT2_DATA BETWEEN %Exp:cDesde% AND %Exp:cHasta%
            AND CT2_SBLOTE BETWEEN %Exp:mv_par06% AND %Exp:mv_par07%
            AND CT2_DC IN %Exp:cTipoCre%
            AND CT2_MOEDLC = %Exp:mv_par03%
            AND CT2_TPSALD = %Exp:mv_par04%
            AND G.%NotDel% 
         GROUP BY CT2_SBLOTE, CT2_CREDIT ) F//, CT2_CCC ) F
   GROUP BY SUBLOTE, CUENTA
   ORDER BY SUBLOTE, SALDO ,CUENTA//, CC
EndSql

EndIf

nLin     := 80
nTotDeb  := 0
nTotCre  := 0
nTotSal	 := 0
nTotSal1 := 0
Titulo   := cTitulo   
nProxDoc := IIF(MV_PAR08=0,1,MV_PAR08)//default en 1 si está en cero

DbSelectArea( cAliasCT2 )
DbGoTop()

While !Eof()

   cSubLote := (cAliasCT2)->SUBLOTE
   cSubLoteD:= (cAliasCT2)->SUBLOTED
   nTotSBD  := 0
   nTotSBC  := 0 
   nTotSal2  := 0
   
   If nLin > nSalto
      CabecLzb( cTitulo )
   EndIf            


   @ nLin, aPos[1] PSAY +'CORRELATIVO :'+STRZERO(nProxDoc,4)+' - SUBLOTE: ' + (cAliasCT2)->SUBLOTE + ' - ' + (cAliasCT2)->SUBLOTED
   nLin++
   
   While !(cAliasCT2)->(Eof()) .and. (cAliasCT2)->SUBLOTE == cSubLote
      If nLin > nSalto
         CabecLzb( cTitulo )
      EndIf

      @ nLin, aPos[1] PSAY (cAliasCT2)->CUENTA
      @ nLin, aPos[2] PSAY (cAliasCT2)->CUENTAD
  //    @ nLin, aPos[3] PSAY (cAliasCT2)->CC
  //    @ nLin, aPos[4] PSAY (cAliasCT2)->CCD
   
  /*    If !Empty( (cAliasCT2)->DEBITO )
         @ nLin, aPos[3] PSAY (cAliasCT2)->DEBITO  PICTURE '@E 999,999,999.99'
      EndIf
      
      If !Empty( (cAliasCT2)->CREDITO )
         @ nLin, aPos[4] PSAY (cAliasCT2)->CREDITO PICTURE '@E 999,999,999.99'
      EndIf
  */
      If (cAliasCT2)->SALDO > 0
         @ nLin, aPos[4] PSAY (cAliasCT2)->SALDO PICTURE '@E 999,999,999.99'
      Else
         @ nLin, aPos[3] PSAY (cAliasCT2)->SALDO * (-1) PICTURE '@E 999,999,999.99'
      EndIf
      
      	nTotSal1 += (cAliasCT2)->SALDO * (-1)
      	nTotSal2 += (cAliasCT2)->SALDO * (-1) 
//      nTotDeb += (cAliasCT2)->DEBITO
//      nTotCre += (cAliasCT2)->CREDITO
//      nTotSBD += (cAliasCT2)->DEBITO
//      nTotSBC += (cAliasCT2)->CREDITO
      nLin++
      
      (cAliasCT2)->(DbSkip())
   EndDo
   
   If nLin > nSalto - 2
      CabecLzb( cTitulo )
   EndIf

   @ nLin, aPos[1] PSAY __PrtThinLine()
   nLin++

   @ nLin, aPos[1] PSAY 'TOTAL CORRELATIVO :'+STRZERO(nProxDoc,4)+' - SUBLOTE: ' + cSubLote + ' - ' + Alltrim( cSubLoteD )
   @ nLin, aPos[5] PSAY nTotSal2  PICTURE '@E 999,999,999,999.99'
//   @ nLin, aPos[5] PSAY nTotSBD  PICTURE '@E 999,999,999,999.99'
//   @ nLin, aPos[6] PSAY nTotSBC PICTURE '@E 999,999,999,999.99'
   nLin  += 2

   //proximo documento, para renumerar segun parametro informado por el usuario en cada mes
   nProxDoc ++    
      
EndDo

If nLin > nSalto - 3
   CabecLzb( cTitulo )
EndIf

@ nLin, aPos[1] PSAY __PrtFatLine()
nLin++
@ nLin, aPos[1] PSAY 'TOTALES -------->'
@ nLin, aPos[5] PSAY nTotSal1 PICTURE '@E 999,999,999,999.99'
//@ nLin, aPos[5] PSAY nTotDeb PICTURE '@E 999,999,999,999.99'
//@ nLin, aPos[6] PSAY nTotCre PICTURE '@E 999,999,999,999.99'
nLin++

DbSelectArea( cAliasCT2 )
DbCloseArea()

Return( { nTotDeb, nTotCre } )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Marcelo Rodriguez     ³ Data ³ 05/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CabecLzb( cTitulo )

nLin  := 0

If lFirstPrint
   @ nLin, 00 PSAY AvalImp(limite)
   lFirstPrint := .F.
EndIf

@ nLin, 00 PSAY __PrtFatLine()
nLin++
@ nLin, 00 PSAY __PrtLeft( SM0->M0_NOMECOM )
nLin++
@ nLin, 00 PSAY __PrtLeft( SM0->M0_ENDCOB )
nLin++
@ nLin, 00 PSAY __PrtLeft( "(" + SM0->M0_CEPCOB + ")" + " " + Alltrim(SM0->M0_CIDCOB) +" "+Alltrim(SM0->M0_BAIRCOB) )
@ nLin, 00 PSAY __PrtCenter( cTitulo )
@ nLin, 00 PSAY __PrtRight( 'Del ' + DtoC( mv_par01 ) + ' Al ' + DtoC( mv_par02 ) )
nLin++
@ nLin, 00 PSAY __PrtLeft( OemToAnsi( '' ) )
@ nLin, 00 PSAY __PrtRight( 'Hoja: ' + StrZero( M_PAG, 3 ) )
nLin++
@ nLin, 00 PSAY __PrtFatLine()
nLin++
@ nLin, 00 PSAY Cabec1
nLin++
@ nLin, 00 PSAY __PrtFatLine()
nLin++

M_PAG++

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³          ³ Autor ³ Marcelo Rodriguez     ³ Data ³ 05/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()
Local aArea := GetArea()
Local i     := 0
Local j     := 0
Local aRegs := {}

dbSelectArea("SX1")
dbSetOrder(1)

AADD(aRegs,{cPerg,"01","De Fecha  ","De Fecha  ","De Fecha  ","mv_ch1" ,"D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
AADD(aRegs,{cPerg,"02","A Fecha   ","A Fecha   ","A Fecha   ","mv_ch2" ,"D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
AADD(aRegs,{cPerg,"03","Moneda    ","Moneda    ","Moneda    ","mv_ch3" ,"C", 2,0,1,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTO","","",""} )
AADD(aRegs,{cPerg,"04","Tipo Saldo","Tipo Saldo","Tipo Saldo","mv_ch4" ,"C", 1,0,1,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SLD","","",""} )
AADD(aRegs,{cPerg,"05","Prox. Pag.","Prox. Pag.","Prox. Pag.","mv_ch5" ,"N",10,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""} )
AADD(aRegs,{cPerg,"06","De SubLote","De SubLote","De SubLote","mv_ch6" ,"C",03,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
AADD(aRegs,{cPerg,"07","A SubLote ","A SubLote ","A SubLote ","mv_ch7" ,"C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
AADD(aRegs,{cPerg,"08","Prox. Doc.","Prox. Doc.","Prox. Doc.","mv_ch8" ,"N",10,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","",""} )   
AADD(aRegs,{cPerg,"09","Desde Sucursal?:","Desde Sucursal?:","Desde Sucursal?:","mv_ch9" ,"C", 2,0,1,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","",""} )
AADD(aRegs,{cPerg,"10","Hasta Sucursal?:","Hasta Sucursal?:","Hasta Sucursal?:","mv_cha" ,"C", 2,0,1,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","",""} )

For i:=1 to Len(aRegs)
   If !dbSeek(cPerg+aRegs[i,2])
      RecLock("SX1",.T.)
      For j:=1 to FCount()
         If j <= Len(aRegs[i])
            FieldPut(j,aRegs[i,j])
         Endif
      Next
      MsUnlock()
   Endif
Next

RestArea( aArea )

Return

