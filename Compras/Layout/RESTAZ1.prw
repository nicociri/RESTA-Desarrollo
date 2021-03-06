#INCLUDE "PROTHEUS.CH"

//*�����������������������������������������������������������������������������
//*�����������������������������������������������������������������������������
//*�������������������������������������������������������������������������Ŀ��
//*���Programa  �RESTAZ1   � Autor � Nestor Lagonegro    � Data � 04.07.2014 ���
//*�������������������������������������������������������������������������Ĵ��
//*���Descricao �Transferencia multiple entre carteras						 ���
//*�������������������������������������������������������������������������Ĵ��
//*�����������������������������������������������������������������������������
//*�����������������������������������������������������������������������������

User Function RESTAZ1()

//*Local I:=0
//*Local lError  :=.T. 
//*Local bExcell :=0
Local bPrimEx :=.T. 
Local bTraeD := bPrimer :=.F.
Private cPerg := "RESTAZ1"
Private cPictVr :=  "@E 999999999.99"
Private nSalida    := 0
Private cDesProvee := ""
Private nNumPag:= nTotrIB:=nTotrIVAP:=nTotISNOC:=nTotTot:=ntotNC:=ntotRM:=ntotCF:=ntotRI:=ntotVNG:= nTotNGEx := nTotLey := nTotOtros:=nContab:=nTotEXEN:=0
Private cA2COD:=cA2NOME:=cA2CGC:=cA2TIPO:=""
Private aTipo:={}
Private aTMP :={}
Private cAliasE := GetNextAlias()
//*Private nLinE	:=3

AjustaSX1() 
Pergunte(cPerg,.T.)
ReportDef()
return
 
Static Function ReportDef()
Local oReport
Local oSection
Local cReport := "MATRAR2B" 
Local cTitulo := " "
Local cDesc   := "El objetivo de este programa es imprimir Reporte con Tranferencia multiple entre carteras."
Local cDesc2  := "Reporte de Tranferencia multiple entre carteras."
Local  i

*//////////////////////////////////*
*//Tratamento dos objetos TREPORT//*  
*//////////////////////////////////*
oReport:= TReport():New(cReport,cTitulo,cPerg,{|oReport| PrintReport(oReport,cAliasE,oSection)},cDesc)
oReport:SetTotalInLine(.F.)
oReport:SetLandscape(.T.)
oSection:= TRSection():New(oReport,cDesc2,{cAliasE})
oSection:lReadOnly := .T.
oReport:SetTotalInLine(.F.)

TRCell():New(oSection,"UNO"    ,cAliasE," "      ,/*Picture*/      ,15         ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
TRCell():New(oSection,"DOS"    ,cAliasE," "      ,/*Picture*/      ,15         ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
TRCell():New(oSection,"TRES"   ,cAliasE," "      ,/*Picture*/      ,15         ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
TRCell():New(oSection,"CUATRO" ,cAliasE," "      ,/*Picture*/      ,15         ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
TRCell():New(oSection,"CINCO"  ,cAliasE," "      ,/*Picture*/      ,15         ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
TRCell():New(oSection,"SEIS"   ,cAliasE," "      ,/*Picture*/      ,15         ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
TRCell():New(oSection,"SIETE"  ,cAliasE," "      ,/*Picture*/      ,15         ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
TRCell():New(oSection,"OCHO"   ,cAliasE," "      ,/*Picture*/      ,15         ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
TRCell():New(oSection,"NUEVE"  ,cAliasE," "      ,/*Picture*/      ,15         ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
TRCell():New(oSection,"DIEZ"   ,cAliasE," "      ,/*Picture*/      ,15         ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
TRCell():New(oSection,"ONCE"   ,cAliasE," "      ,/*Picture*/      ,15         ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
TRCell():New(oSection,"DOCE"   ,cAliasE," "      ,/*Picture*/      ,15         ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
TRCell():New(oSection,"TRECE"  ,cAliasE," "      ,/*Picture*/      ,15         ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
TRCell():New(oSection,"CATORCE",cAliasE," "      ,/*Picture*/      ,15         ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")

*//////////////////////*
*// Seteo de Titulos //* 
*//////////////////////*
oSection:Cell("UNO"    ):SetTitle("Numero	  "+CHR(13)+CHR(10)+"de  "+CHR(13)+CHR(10)+"Titulo")
oSection:Cell("DOS"    ):SetTitle("Vencimiento"+CHR(13)+CHR(10)+"del "+CHR(13)+CHR(10)+"Titulo")
oSection:Cell("TRES"   ):SetTitle("Valor"+CHR(13)+CHR(10)+"del "+CHR(13)+CHR(10)+"Titulo")
oSection:Cell("CUATRO" ):SetTitle("Codigo "+CHR(13)+CHR(10)+"del "+CHR(13)+CHR(10)+"Cliente ")
oSection:Cell("CINCO"  ):SetTitle("Nombre "+CHR(13)+CHR(10)+"del "+CHR(13)+CHR(10)+"Cliente ")
oSection:Cell("SEIS"   ):SetTitle("Numero"+CHR(13)+CHR(10)+"de "+CHR(13)+CHR(10)+"Transferencia ")
oSection:Cell("SIETE"  ):SetTitle(" "+CHR(13)+CHR(10)+" "+CHR(13)+CHR(10)+"Contacto")
oSection:Cell("OCHO"   ):SetTitle("Fecha"+CHR(13)+CHR(10)+"emision "+CHR(13)+CHR(10)+"Titulo ")
oSection:Cell("NUEVE"  ):SetTitle("Codigo"+CHR(13)+CHR(10)+"del "+CHR(13)+CHR(10)+"Portador ")
oSection:Cell("DIEZ"   ):SetTitle(" "+CHR(13)+CHR(10)+"Agencia"+CHR(13)+CHR(10)+"Depositaria ")
oSection:Cell("ONCE"   ):SetTitle("Numero"+CHR(13)+CHR(10)+"Cuenta "+CHR(13)+CHR(10)+"Corriente ")
oSection:Cell("DOCE"   ):SetTitle("Banco"+CHR(13)+CHR(10)+"Cheque "+CHR(13)+CHR(10)+"Liquidacion ")
oSection:Cell("TRECE"  ):SetTitle("CUIT/CUIL"+CHR(13)+CHR(10)+"del "+CHR(13)+CHR(10)+"cliente")
oSection:Cell("CATORCE"):SetTitle(""+CHR(13)+CHR(10)+" "+CHR(13)+CHR(10)+"RECNO ")

oReport:PrintDialog()
oReport:EndPage(.F.)
Return


Static Function PICABCUSTOM(cDesProvee)
Local aCabec:= {}
Local cChar         := " "
Local cLinea2Titulo := " "

	  cLinea2Titulo := Alltrim(SM0->M0_NOMECOM)+space(09)+OemToAnsi(Alltrim("Transferencia multiple entre carteras de Clientes DESDE EL: "))+dtoc(mv_par01)+" AL:"+dtoc(mv_par02)+space(05)+OemToAnsi(Alltrim("HOJA NRO.:"))+Alltrim(CvalToChar(nNumPag))
      aCabec := { cChar, cLinea2Titulo , cChar}
      nNumPag := nNumPag + 1
Return aCabec


Static Function PrintReport(oReport,cAliasE,oSection)
Local i:=0,y:=0

//* Totales.
Local nDos:=nTres:=nDiez:=nDoce:= 0
bExcell :=.T.
bPrimEx :=.T.

oReport:SetCustomText( {|| PICABCUSTOM(cDesProvee) } )

                               *// =================================================//*
                               *// =============> Inicio Query GENERAL <============//*
                               *// =================================================//*
                               cQrm:="SELECT      						"
                               cQrm+="		 A.E1_NUM 		      ,		" //*Numero do Titulo
                               cQrm+="		 A.E1_VENCTO 	      , 	" //*Vencimiento del titulo
                               cQrm+="		 A.E1_VALOR 	      ,  	" //*Valor del titulo
                               cQrm+=" 		 A.E1_CLIENTE 	      ,   	" //*codigo del cliente
                               cQrm+=" 		    B.A1_NREDUZ 	  ,   	" //*Nombre reducido del cliente
                               cQrm+=" 		 A.E1_XTRANFE 	      ,  	" //*Numero de trasnferencia
                               cQrm+=" 		 A.E1_XCONTAC 	      ,  	" //*Contacto
                               cQrm+=" 		 A.E1_EMISSAO 	      , 	" //*Fecha de emision del titulo
                               cQrm+=" 		 A.E1_PORTADO 	      ,   	" //*Codigo del Portador
                               cQrm+=" 		 A.E1_AGEDEP 	      ,  	" //*Agencia depositaria
                               cQrm+=" 	 	 A.E1_CONTA 	      , 	" //*Numero de cuenta corriente
                               cQrm+="  	 A.E1_BCOCHQ 	      , 	" //*Banco cheque liquidacion
                               cQrm+=" 		   B.A1_CGC 		  , 	" //*CUIT/CUIL del cliente
                               cQrm+=" 		 A.R_E_C_N_O_ 	AS RECNO        	"
                               cQrm+="  FROM "+RetSqlName("SE1")+" A 			"
                               cQrm+="  LEFT JOIN "+RetSqlName("SA1")+" B ON B.A1_COD = A.E1_CLIENTE AND B.A1_LOJA = A.E1_LOJA "
                               cQrm+=" WHERE "
                               cQrm+="       A.E1_FILIAL = '"+xFilial("SE1")+"' "
                               cQrm+="   AND B.A1_FILIAL = '"+xFilial("SA1")+"' "
                               cQrm+="   AND A.D_E_L_E_T_=' '"
                               cQrm+="   AND B.D_E_L_E_T_=' '"
                               cQrm+="   AND A.E1_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'
                               cQrm+="   AND A.E1_VENCTO  BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"'
                               cQrm+="   AND A.E1_CLIENTE BETWEEN '"+MV_PAR05+"'       AND '"+MV_PAR06+"'
                               cQrm+="	 AND A.E1_PORTADO = '"+MV_PAR07+"' "
                               cQrm+="   AND A.E1_AGEDEP  = '"+MV_PAR08+"' "
                               cQrm+="   AND A.E1_CONTA   = '"+MV_PAR09+"' "
                               cQrm+="   AND A.E1_TIPO    = 'CH' "
                               cQrm+="   AND A.E1_SALDO  <> 0
                               cQrm+=" ORDER BY A.E1_VENCTO"
                               cQrm := ChangeQuery(cQrm)
                               If Select( cAliasE ) > 0 ; dbSelectArea( cAliasE ) ; dbCloseArea() ; EndIf
                               //* =============>  Abre Tabelas
                               dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQrm), cAliasE , .F., .T.)
                               dbSelectArea(cAliasE)
                               oReport:SetMeter((cAliasE)->(Reccount()))
                               *// =============>  Impressao
                               (cAliasE)->(DbGotop())
                               While !( cAliasE )->(Eof())
                               oReport:Section(1):Init()
                               //**********************************//
                               //* Control para excel .... inicio *//
                               //**********************************//
                               nSalida := oReport:nDevice            
                               IF nSalida == 4 
                                 oReport:Section(1):SetHeaderSection(.F.) 
                                 oReport:Section(1):lHeaderVisible := .F.
                                  IF bPrimEx == .T.
                                     oReport:Section(1):Cell("UNO"    ):SetPicture("")
                                     oReport:Section(1):Cell("DOS"    ):SetPicture("")
                                     oReport:Section(1):Cell("TRES"   ):SetPicture("")
                                     oReport:Section(1):Cell("CUATRO" ):SetPicture("")
                                     oReport:Section(1):Cell("CINCO"  ):SetPicture("")
                                     oReport:Section(1):Cell("SEIS"   ):SetPicture("")
                                     oReport:Section(1):Cell("SIETE"  ):SetPicture("")
                                     oReport:Section(1):Cell("OCHO"   ):SetPicture("")
                                     oReport:Section(1):Cell("NUEVE"  ):SetPicture("")
                                     oReport:Section(1):Cell("DIEZ"   ):SetPicture("")
                                     oReport:Section(1):Cell("ONCE"   ):SetPicture("")
                                     oReport:Section(1):Cell("DOCE"   ):SetPicture("")
                                     oReport:Section(1):Cell("TRECE"  ):SetPicture("")
                                     oReport:Section(1):Cell("CATORCE"):SetPicture("")

                                     oReport:Section(1):Cell("UNO"    ):SetValue("Numero do Titulo")
                                     oReport:Section(1):Cell("DOS"    ):SetValue("Vencimiento del titulo")
                                     oReport:Section(1):Cell("TRES"   ):SetValue("Valor del titulo")
                                     oReport:Section(1):Cell("CUATRO" ):SetValue("codigo del cliente")
                                     oReport:Section(1):Cell("CINCO"  ):SetValue("Nombre reducido del cliente")
                                     oReport:Section(1):Cell("SEIS"   ):SetValue("Numero de trasnferencia")
                                     oReport:Section(1):Cell("SIETE"  ):SetValue("Contacto")
                                     oReport:Section(1):Cell("OCHO"   ):SetValue("Fecha de emision del titulo")
                                     oReport:Section(1):Cell("NUEVE"  ):SetValue("Codigo del Portador")
                                     oReport:Section(1):Cell("DIEZ"   ):SetValue("Agencia depositaria")
                                     oReport:Section(1):Cell("ONCE"   ):SetValue("Numero de cuenta corriente")
                                     oReport:Section(1):Cell("DOCE"   ):SetValue("Banco cheque liquidacion")
                                     oReport:Section(1):Cell("TRECE"  ):SetValue("CUIT/CUIL del cliente")
                                     oReport:Section(1):Cell("CATORCE"):SetValue("RECNO")
                                     oReport:ThinLine()
                                     bPrimEx:= .F.
                                     oReport:Section(1):PrintLine()
                                  ENDIF
                               ENDIF
                               //*******************************//
                               //* Control para excel .... fin *//
                               //*******************************//

                                     oReport:Section(1):Cell("UNO"    ):SetPicture("")
                                     oReport:Section(1):Cell("DOS"    ):SetPicture("")
                                     oReport:Section(1):Cell("TRES"   ):SetPicture("")
                                     oReport:Section(1):Cell("CUATRO" ):SetPicture("")
                                     oReport:Section(1):Cell("CINCO"  ):SetPicture("")
                                     oReport:Section(1):Cell("SEIS"   ):SetPicture("")
                                     oReport:Section(1):Cell("SIETE"  ):SetPicture("")
                                     oReport:Section(1):Cell("OCHO"   ):SetPicture("")
                                     oReport:Section(1):Cell("NUEVE"  ):SetPicture("")
                                     oReport:Section(1):Cell("DIEZ"   ):SetPicture("")
                                     oReport:Section(1):Cell("ONCE"   ):SetPicture("")
                                     oReport:Section(1):Cell("DOCE"   ):SetPicture("")
                                     oReport:Section(1):Cell("TRECE"  ):SetPicture("")
                                     oReport:Section(1):Cell("CATORCE"):SetPicture("")                                                                                                          

                                     oReport:Section(1):Cell("UNO"    ):SetValue((cAliasE)->E1_NUM)
                                     oReport:Section(1):Cell("DOS"    ):SetValue(Transform(STOD(( cAliasE )->E1_VENCTO),"@D"))
                                     oReport:Section(1):Cell("TRES"   ):SetValue((cAliasE)->E1_VALOR)
                                     oReport:Section(1):Cell("CUATRO" ):SetValue((cAliasE)->E1_CLIENTE)
                                     oReport:Section(1):Cell("CINCO"  ):SetValue((cAliasE)->A1_NREDUZ)
                                     oReport:Section(1):Cell("SEIS"   ):SetValue((cAliasE)->E1_XTRANFE)
                                     oReport:Section(1):Cell("SIETE"  ):SetValue((cAliasE)->E1_XCONTAC)
                                     oReport:Section(1):Cell("OCHO"   ):SetValue(Transform(STOD(( cAliasE )->E1_EMISSAO),"@D"))
                                     oReport:Section(1):Cell("NUEVE"  ):SetValue((cAliasE)->E1_PORTADO)
                                     oReport:Section(1):Cell("DIEZ"   ):SetValue((cAliasE)->E1_AGEDEP)
                                     oReport:Section(1):Cell("ONCE"   ):SetValue((cAliasE)->E1_CONTA)
                                     oReport:Section(1):Cell("DOCE"   ):SetValue((cAliasE)->E1_BCOCHQ)
                                     oReport:Section(1):Cell("TRECE"  ):SetValue((cAliasE)->A1_CGC)
                                     oReport:Section(1):Cell("CATORCE"):SetValue((cAliasE)->RECNO)

        	                        oReport:Section(1):PrintLine()

                              ( cAliasE )->(DbSkip())
                              EndDo
                              *// ==============================================//*
                              *// =============> FIN Query GNERAL <=============//*
                              *// ==============================================//*
	

*///////////////*
*// PERGUNTAS //*
*///////////////*
Static Function AjustaSX1()
Local aHelp := {}
Aadd(aHelp,{{"Fecha de Emision Inicial"		},{"Fecha de Emision Inicial"		},{"Fecha de Emision Inicial"}})
Aadd(aHelp,{{"Fecha de Emision Final"		},{"Fecha de Emision Final"			},{"Fecha de Emision Final"}})
Aadd(aHelp,{{"Fecha de Vencimiento Inicial"	},{"Fecha de Vencimiento Inicial"	},{"Fecha de Vencimiento Inicial"}})
Aadd(aHelp,{{"Fecha de Emision Final"		},{"Fecha de Emision Final"			},{"Fecha de Emision Final"}})
Aadd(aHelp,{{"Desde Cliente:"				},{"Desde Cliente:"					},{"Desde Cliente:"}})
Aadd(aHelp,{{"Hasta Cliente:"				},{"Hasta Cliente:"					},{"Hasta Cliente:"}})
Aadd(aHelp,{{"Codigo del Portador:"			},{"Codigo del Portador:"			},{"Codigo del Portador:"}})
Aadd(aHelp,{{"Agencia Depositaria:"			},{"Agencia Depositaria:"			},{"Agencia Depositaria:"}})
Aadd(aHelp,{{"Conta:"						},{"Conta:"							},{"Conta:"}})


PutSx1(CPERG,"01","Fecha de Emision Inicial?","Fecha de Emision Inicial?", "Fecha de Emision Inicial?","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","",;
       "","","","","","","","","","","","",aHelp[1,1],aHelp[1,2],aHelp[1,3])
PutSx1(CPERG,"02","Fecha de Emision Final?","Fecha de Emision Final?", "Fecha de Emision Final?","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","",;
       "","","","","","","","","","","","S",aHelp[2,1],aHelp[2,2],aHelp[2,3])
PutSx1(CPERG,"03","Fecha de Vencimiento Inicial?","Fecha de Vencimiento Inicial?", "Fecha de Vencimiento Inicial?","mv_ch3","D",8,0,0,"G","","","","","mv_par03","","","","",;
       "","","","","","","","","","","","",aHelp[1,1],aHelp[1,2],aHelp[1,3])
PutSx1(CPERG,"04","Fecha de Vencimiento Final?","Fecha de Vencimiento Final?", "Fecha de Vencimiento Final?","mv_ch4","D",8,0,0,"G","","","","","mv_par04","","","","",;
       "","","","","","","","","","","","S",aHelp[2,1],aHelp[2,2],aHelp[2,3])
PutSx1(CPERG,"05", "Desde Cliente:","Desde Cliente:","Desde Cliente:","mv_ch5", "C", 12, 00, 0, "G", "", "MV_PAR05", "", "", "", "",;
       "", "", "", "", "", "", "", "", "", "", "", "",aHelp[2,1],aHelp[2,2],aHelp[2,3])
PutSx1(CPERG,"06", "Hasta Cliente:","Hasta Cliente:","Hasta Cliente:","mv_ch6", "C", 12, 00, 0, "G", "", "MV_PAR06", "", "", "", "",;
       "", "", "", "", "", "", "", "", "", "", "", "",aHelp[2,1],aHelp[2,2],aHelp[2,3])
PutSx1(CPERG,"07", "Codigo del Portador:","Codigo del Portador:","Codigo del Portador:","mv_ch7", "C", 12, 00, 0, "G", "", "MV_PAR07", "", "", "", "",;
       "", "", "", "", "", "", "", "", "", "", "", "",aHelp[2,1],aHelp[2,2],aHelp[2,3])
PutSx1(CPERG,"08", "Agencia Depositaria:","Agencia Depositaria:","Agencia Depositaria:","mv_ch8", "C", 12, 00, 0, "G", "", "MV_PAR08", "", "", "", "",;
       "", "", "", "", "", "", "", "", "", "", "", "",aHelp[2,1],aHelp[2,2],aHelp[2,3])
PutSx1(CPERG,"09", "Conta:","Desde Documento: ","Desde Documento: ","mv_ch9", "C", 12, 00, 0, "G", "", "MV_PAR09", "", "", "", "",;
       "", "", "", "", "", "", "", "", "", "", "", "",aHelp[2,1],aHelp[2,2],aHelp[2,3])

Return