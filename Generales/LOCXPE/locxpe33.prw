#INCLUDE 'PROTHEUS.CH'
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ LOCXPE33 ³ Autor ³ Lucas                 ³ Data ³ 31.05.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Define  campos de que deben ser visuales o obligados       ³±±
±±³          ³ conforme la rutina ejecutada. Ej: MATA465N Campo Serie como³±±
±±³          ³ visual...                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExecBlock("LOCXPE33",.F.,.F.)           					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ LOCXNF                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User function LOCXPE33()
Local aArea := GetArea()
Local aCposNF := ParamIxb[1]
Local nTipo := ParamIxb[2]
Local aDetalles := {}
Local nNuevoElem := 0
Local nPosCpo := 0
Local nL      := 0
Local _lOffline	:= !GetnewPar("LB_LOJOFF",.F.) // para saber si estamos en un ambiente offline

If nTipo == 10  .or. nTipo == 13 .or. nTipo == 15 .or. nTipo == 60 // Factura de entrada y Remito de entrada
	SX3->(MsSeek("F1_XOBSMEM"))                                      
	AAdd(aCposNF,{X3Titulo(),X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "", X3_USADO, X3_TIPO, "SF1", X3_CONTEXT,,,,,, X3_F3,""})       
ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Usuario debe definir nuevos Tipos...                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


If nTipo == 50 //Remito de Salida
	//Detalles,      Campo     Usado  Obligatorio  Visual
	Aadd(aDetalles,{"F2_XTIPO"  	,.T.   ,.F.         ,.F.   })
	Aadd(aDetalles,{"F2_XNROACO"  	,.T.   ,.F.         ,.F.   })
	Aadd(aDetalles,{"F2_XENDENT"  	,.T.   ,.F.         ,.F.   })
	Aadd(aDetalles,{"F2_XCONTAC"  	,.T.   ,.F.         ,.F.   })
ElseIf nTipo == 1 // Factura de Ventas
	//Detalles,      Campo       Usado  Obligatorio  Visual      
	Aadd(aDetalles,{"F2_XTIPO"  	,.T.   ,.F.      ,.F.   })
	Aadd(aDetalles,{"F2_XNROACO"  	,.T.   ,.F.      ,.F.   })
	AADD(aDetalles,{"F2_DOC"        ,.T.   ,.T.      ,.T.   })   
	Aadd(aDetalles,{"F2_XCONTAC"  	,.T.   ,.F.         ,.F.   })
ElseIf nTipo == 4  //Nota de credito cliente
	//Detalles,      Campo     Usado  Obligatorio  Visual
	Aadd(aDetalles,{"F1_XTIPO"  	,.T.   ,.F.         ,.F.   }) 
	Aadd(aDetalles,{"F1_XNROACO"  	,.T.   ,.F.         ,.F.   })
	Aadd(aDetalles,{"F1_XOBS"   	,.T.   ,.F.         ,.F.   })
	Aadd(aDetalles,{"F1_XOBS"   	,.T.   ,.F.         ,.F.   })
	Aadd(aDetalles,{"F1_XNF "   	,.T.   ,.F.         ,.F.   })
	Aadd(aDetalles,{"F1_XSERNF"   	,.T.   ,.F.         ,.T.   })
	Aadd(aDetalles,{"F1_XESPNF"   	,.T.   ,.F.         ,.T.   })
	Aadd(aDetalles,{"F1_XPORC"  	,.T.   ,.F.         ,.F.   })  
ElseIf nTipo == 2 .and. CESPECIE='NDC' // Nota de Debito de Cliente - NDC
	//   Detalles,      Campo   Usado  Obligatorio  Visual
	Aadd(aDetalles,{"F2_XTIPO"  	,.T.   ,.F.         ,.F.   })
	Aadd(aDetalles,{"F2_XNROACO"  	,.T.   ,.F.         ,.F.   })
	Aadd(aDetalles,{"F2_XOBS"   	,.T.   ,.F.         ,.F.   })

ElseIf nTipo == 51.or.nTipo == 53  //Remito de devoluciones Facturacion            M

		If Alltrim(Funname())=='MATA462DN'	                     
			//Detalles,      Campo     Usado  Obligatorio  Visual
		Aadd(aDetalles,{"F1_XTIPO"  	,.T.   ,.F.         ,.F.   }) 
		Aadd(aDetalles,{"F1_XNROACO"  	,.T.   ,.F.         ,.F.   })
		Aadd(aDetalles,{"F1_IDIOMA"  	,.T.   ,.F.         ,.F.   })
		Aadd(aDetalles,{"F1_PAISENT"  	,.T.   ,.F.         ,.F.   })
		Aadd(aDetalles,{"F1_XPORC"  	,.T.   ,.F.         ,.F.   }) 
		EndIf
ElseIf nTipo == 54 .AND. ALLTRIM(FUNNAME())=='MATA462TN'
	//Detalles,      Campo     Usado  Obligatorio  Visual
		Aadd(aDetalles,{"F2_XOBS"  	,.T.   ,.F.         ,.F.   })
EndIf 

/*
If nTipo == 7 .or. nTipo == 6 // NCP nota de credito proveedor
	//Detalles,      Campo       Usado  Obligatorio  Visual
	AADD(aDetalles,{"F2_SERIE"  ,  .T.      ,.T.      ,.F.   })
	AADD(aDetalles,{"F2_DOC"    ,  .T.      ,.T.      ,.F.   })
	AADD(aDetalles,{"F2_PROVENT",  .T.      ,.T.      ,.F.   })
	AADD(aDetalles,{"F2_DTDIGIT",  .T.      ,.T.      ,.T.   })
	AADD(aDetalles,{"F2_VALSUSS"    ,.T.      ,.F.      ,.F.   })	
	
ElseIf nTipo == 1 // Factura de Ventas
	//Detalles,      Campo       Usado  Obligatorio  Visual
	AADD(aDetalles,{"F2_SERIE"  , .T.      ,.T.      ,.T.   })
	AADD(aDetalles,{"F2_DOC"    , .T.      ,.T.      ,.T.   })
	AADD(aDetalles,{"F2_PROVENT", .T.      ,.T.      ,.F.   })
	AADD(aDetalles,{"F2_NATUREZ", .T.      ,.F.      ,.F.   })
	
ElseIf nTipo == 9 .or. nTipo == 8	// Nota de debito proveedor  

	If Alltrim(Funname())=='MATA466N'
		//   Detalles,      Campo       Usado  Obligatorio  Visual
		AADD(aDetalles,{"F1_SERIE"  , .T.      ,.T.      ,.F.   })
		AADD(aDetalles,{"F1_DOC"    , .T.      ,.T.      ,.F.   })
//		AADD(aDetalles,{"F1_PROVENT", .T.      ,.F.      ,.F.   })
	Endif
	
ElseIf nTipo == 4 .and. CESPECIE='NCC'  // Nota de Credito de Cliente - NCC
	//   Detalles,      Campo   Usado  Obligatorio  Visual
		AADD(aDetalles,{"F1_SERIE"  , .T.      ,.T.      ,.T.   })
		AADD(aDetalles,{"F1_DOC"    , .T.      ,.T.      ,.T.   })         
		AADD(aDetalles,{"F1_XOBSERV"    , .T.      ,.F.      ,.F.   })

ElseIf nTipo == 5 .and. CESPECIE='NDC' // Nota de Debito de Cliente - NDC
	//   Detalles,      Campo   Usado  Obligatorio  Visual
	AADD(aDetalles,{"F2_SERIE"  , .T.      ,.T.      ,.T.   })
	AADD(aDetalles,{"F2_DOC"    , .T.      ,.T.      ,.T.   })        
	AADD(aDetalles,{"F1_XOBSERV"    , .T.      ,.F.      ,.F.   })
ElseIf nTipo == 2 			// Nota de Debito de Cliente - NDC
	//   Detalles,      Campo       Usado  Obligatorio  Visual
	AADD(aDetalles, {"F2_XNDCCHQ", .T., .T., .F.})
ElseIf nTipo == 54
	AADD(aDetalles,{"F2_XSA"    ,.T.      ,.F.      ,.T.   })
	AADD(aDetalles,{"F2_DOC"        ,.T.       ,.T.      ,.T.   })
	AADD(aDetalles,{"F2_SERIE"      ,.T.       ,.T.      ,.T.   })

ElseIf nTipo == 10  .or. nTipo == 13 .or. nTipo == 15 // Factura de entrada
	AADD(aDetalles,{"F1_VALSUSS"    ,.T.      ,.F.      ,.F.   })
ElseIf nTipo == 50  //Remito de Ventas
	AADD(aDetalles,{"F2_XRETENI"    ,.T.      ,.F.      ,.F.   })
	AADD(aDetalles,{"F2_TRANSP"    ,.T.      ,.F.      ,.F.   })
ElseIf nTipo == 53  //Remito de devoluciones Facturacion            M
		If Alltrim(Funname())=='MATA462DN'	
		AADD(aDetalles,{"F1_XFIELD", .T.      ,.T.      ,.F.   }) 	
		EndIf
EndIf 
*/
If (nTipo == 10  .or. nTipo == 13 .or. nTipo == 15 .or. nTipo == 60) .AND. CMODULO == 'COM'// Factura de entrada y Remito de entrada
	//   Detalles,      Campo   Usado  Obligatorio  Visual .
	AADD(aDetalles,{"F1_XOBS"    ,.T.      ,.F.      ,.F.   })
	AADD(aDetalles,{"F1_XOBSMEM"    ,.T.      ,.F.      ,.F.   })  
	AADD(aDetalles,{"F1_XPRONP"    ,.T.      ,.F.      ,.F.   })  
ENDIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ No cambiar dentro del Loop For...Next, llamar AC/Localizaciones ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

For nL := 1 To Len(aDetalles)
	If (nPosCpo := Ascan(aCposNF,{|x| x[2] == aDetalles[nL][1] })) > 0
		aCposNF[nPosCpo][13] := aDetalles[nL][3] 				   // Obligatorio
		If Len(aCposNF[nPosCpo]) == 16
			SX3->(DbSetOrder(2))
			SX3->(DbSeek(AllTrim(aDetalles[nL][1])))
			aCposNF[nPosCpo] := {X3Titulo(),X3_CAMPO,,,,,,,,,,,aDetalles[nL][3],,,,If(aDetalles[nL][4],".F.",".T.")}
		EndIf
		aCposNF[nPosCpo][17] := If(aDetalles[nL][4],".F.",".T.")   // Desabilita el campo
		If !aDetalles[nL][2]
			ADel(aCposNF,nPosCpo) 								   // Quita el campo
			ASize(aCposNF,Len(aCposNF)-1)                          // Ajusta Array
		EndIf
	Else
		DbSelectArea("SX3")
		DbSetOrder(2)
		If DbSeek( aDetalles[nL][1] )
			nNuevoElem := Len(aCposNF)+1
			aCposNF := aSize(aCposNF,nNuevoElem)
			aIns(aCposNF,nNuevoElem)
			aCposNF[nNuevoElem] := {X3Titulo(),X3_CAMPO,,,,,,,,,,,aDetalles[nL][3],,,,If(aDetalles[nL][4],".F.",".T.")}
		EndIf
	EndIf
	
Next nL

//* Lagonegro Nestor Adrian; Inicio
//*			If nTipo == 4 .Or. nTipo == 63 .Or. nTipo == 64 .Or. nTipo == 8
			If (nTipo == 10  .or. nTipo == 13 .or. nTipo == 15 .or. nTipo == 60) .AND. CMODULO == 'COM'// Factura de entrada y Remito de entrada
			   aTemp   := { }                                   // Array para Ordenar los Campos del Encabezado
			   nPos    := 0
			   nPosFin := 6	//*3 									// Posicion incluida Manual
			   nPosMCSe:= 0
			   If SF1->( FieldPos( "F1_XPRONP" ) ) <> 0
			      nPosMCSe:= Ascan( aCposNF,{|x| alltrim(x[2]) == "F1_XPRONP"     } )
			   ENDIF
			   For nPos:= 1 to nPosFin                          // Transfiero el Array de Campos al Temporario
			      Aadd( aTemp, AClone( aCposNf[ nPos ]  ) )     // hasta la posicion de insercion.
			   Next

			   IF nPosMCSe > 0
			      Aadd( aTemp, AClone( aCposNf[ nPosMCSe ]  ) )
			      Adel( aCposNf, nPosMCSe )
			      Asize( aCposNf,Len( aCposNf ) - 1 )
			   ENDIF

			    For nPos:= nPosFin + 1 to Len( aCposNf )        // Continuo insertando los campos restantes del
			      Aadd( aTemp, AClone( aCposNf[ nPos ]  ) )     // Encabezamiento de la factura.
			    Next
			  	aCposNF := aClone( aTemp )                      // Copio el Array Temporario al Array Final
			EndIf
//* Lagonegro Nestor Adrian; Fin

RestArea(aArea)
Return( aCposNF )