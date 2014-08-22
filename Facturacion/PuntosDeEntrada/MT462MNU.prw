#Include 'Rwmake.ch'
#Include 'TopConn.ch'

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MT462MNU ³ Autor ³ Mauro Vilosio         ³ Data ³ 17/11/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Punto de Entrada que agrega un Boton que permite la    	  ³±±
±±³          ³ Reimpresion de las Etiquetas en Impresora Zebra desde el   ³±±
±±³          ³ Programa Remitos de Entrada (MATA102N)                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExecBlock("MT462MNU",.F.,.F.)                           	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGACOM                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function MT462MNU()
Local _lRet := .T.
Local _cFunName := FUNNAME()
If FunName()=="MATA462N"
	AADD(aRotina,{'Impr.RVta',"u_KRem01 ('RFN  ',SF2->F2_SERIE,SF2->F2_DOC)",0,4,0,NIL})
	AADD(aRotina,{'Cump/An.Cump RVta',"U_RemCump('RFN  ',SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_FILIAL)",0,4,0,NIL})
Endif
If _cFunName $ ("MATA462DN") .AND. Alltrim(cEspecie) == 'RFD'
	AAdd(aRotina,{"Cump/An.Cump RDev","U_RdCump('RFD  ',SF1->F1_SERIE,SF1->F1_DOC,SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_FILIAL)", 0 , 0,0,NIL})
EndIf




/*
If _cFunName $ ("MATA102N")
	AAdd(aRotina,{"Imprimir Etiqueta","U_ARETI001()", 0 , 0,0,NIL})
	AAdd(aRotina,{"Imprimir Remito","U_ARIFA009()", 0 , 0,0,NIL})
EndIf
If _cFunName $ ("MATA462TN") .AND. Alltrim(cEspecie) == 'RTE'
	AAdd(aRotina,{"Imprimir Etiqueta","U_ARETI001()", 0 , 0,0,NIL})
EndIf
If _cFunName $ ("MATA462DN") .AND. Alltrim(cEspecie) == 'RFD'
	AAdd(aRotina,{"Imprimir Eti. Master","U_ARETI001()", 0 , 0,0,NIL})
EndIf
If _cFunName $ ("MATA462DN") .AND. Alltrim(cEspecie) == 'RFD'
	AAdd(aRotina,{"Imprimir Eti. 1","U_ARETI005()", 0 , 0,0,NIL})
EndIf
If _cFunName $ ("MATA462N")
	AAdd(aRotina,{"Imprimir Etiqueta","U_ARETI004()", 0 , 0,0,NIL})
	If cEmpant == '00' .and. cfilant =='04'
		AAdd(aRotina,{"Imprimir Remito","U_ARIFA008()", 0 , 0,0,NIL})
	Else
		AAdd(aRotina,{"Imprimir Remito","U_ARIFA004()", 0 , 0,0,NIL})
	EndIf
	AADD(aRotina,{'Aprob Reteni','U_ARAFA02H()',0,4,0,NIL})
EndIf

If _cFunName $ ("MATA462TN")
	AAdd(aRotina,{"Imprimir Remito","U_ARIFA007()", 0 , 0,0,NIL})
EndIf
*/   
///
///
//----------------------------------------------------------------
//----------------------------------------------------------------


User Function RemCump(cEsp,cSerie,cDoc,cCli,cLoja,cFil)
Local aarea := getarea()
Local aAreaSF2 := SF2->(Getarea())
Local aAreaSD2 := SD2->(Getarea())
	DbSelectArea( "SD2" )
	DbSetorder(3)

    DbSeek( cFil+ cDoc+ cSerie+cCli + cLoja )
IF !MSGYESNO(IF(D2_XCUMPLI=='S','Desea Borrar el Cumplimiento del Remito ','Desea Cumplir Remito ')+SF2->F2_SERIE+SF2->F2_DOC ,'Confirma  ?')
    RestArea(aAreaSF2)
    RestArea(aAreaSD2)
	RestArea(aAREA)
	Return .T.
Endif

	DbSelectArea( "SD2" )
	DbSetorder(3)

    DbSeek( cFil+ cDoc+ cSerie+cCli + cLoja )

   DO While !Eof() .and. (cFil+ cDoc+ cSerie+cCli + cLoja) == (D2_FILIAL+D2_DOC+D2_SERIE +D2_CLIENTE + D2_LOJA) .and. D2_ESPECIE $ 'RFN    '  
      IF D2_XCUMPLI <>'S'
        	RecLock("SD2",.F.)
			D2_XGERANF := D2_GERANF
			D2_GERANF := 'N'
			D2_XCUMPLI:= 'S'
            MsUnlock()  
      ELSE
        	RecLock("SD2",.F.)
			D2_GERANF := D2_XGERANF
			D2_XGERANF := ' '
			D2_XCUMPLI:= ' '
            MsUnlock()  
      ENDIF
      dbskip()    
   ENDDO  
	MsgAlert('Proceso en el Remito '+cserie+cdoc+' Finalizado')
                          
RestArea(aAreaSF2)
RestArea(aAreaSD2)
restarea(aarea)
   

Return .T.


///
//----------------------------------------------------------------
//----------------------------------------------------------------


User Function RDCump(cEsp,cSerie,cDoc,cCli,cLoja,cFil)
Local aarea := getarea()
Local aAreaSF1 := SF1->(Getarea())
Local aAreaSD1 := SD1->(Getarea())
	DbSelectArea( "SD1" )
	DbSetorder(1)

    DbSeek( cFil+ cDoc+ cSerie+cCli + cLoja )

IF !MSGYESNO(IF(D1_XCUMPLI=='S','Desea Borrar el Cumplimiento del Remito ','Desea Cumplir Remito ')+SF1->F1_SERIE+SF1->F1_DOC ,'Confirma  ?')
    RestArea(aAreaSF1)
    RestArea(aAreaSD1)
	RestArea(aAREA)
	Return.T.
Endif

	DbSelectArea( "SD1" )
	DbSetorder(1)

    DbSeek( cFil+ cDoc+ cSerie+cCli + cLoja )

   DO While !Eof() .and. (cFil+ cDoc+ cSerie+cCli + cLoja) == (D1_FILIAL+D1_DOC+D1_SERIE +D1_FORNECE + D1_LOJA) .and. D1_ESPECIE $ 'RFD    '  
//      IF D1_QTDACLA<>0
      IF D1_XCUMPLI<>'S'
        	RecLock("SD1",.F.)
			D1_XQACLA:= D1_QTDACLA
			D1_QTDACLA:= 0
			D1_XCUMPLI:= 'S'
            MsUnlock()  
      ELSE
        	RecLock("SD1",.F.)
			D1_QTDACLA:= D1_XQACLA
			D1_XQACLA:= 0
			D1_XCUMPLI:= ' '
            MsUnlock()  
      ENDIF
      dbskip()    
   ENDDO  
	MsgAlert('Proceso en el Remito '+cserie+cdoc+' Finalizado')
                          
RestArea(aAreaSF1)
RestArea(aAreaSD1)
restarea(aarea)
   

Return .T.


Return(_lRet)


