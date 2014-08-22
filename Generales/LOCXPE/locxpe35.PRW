#INCLUDE "PROTHEUS.CH"

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Programa: LOCXPE35      ||Data: 06/09/2010 ||Empresa: SACEEM        //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Autor: Marcus Pacheco   ||Empresa: TOTVS   ||Módulo: Compras        //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Descrição: P.E. informar usuario sobre solicitud de nota de credito //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
User Function LOCXPE35() 
Local aArea     := GetArea()
Local	_nPosRem 	:= AScan(aHeader,{|x|Alltrim(x[2])=="D1_REMITO"})
Local	_nPosItRem 	:= AScan(aHeader,{|x|Alltrim(x[2])=="D1_ITEMREM"})
Local	_nPosSeRem 	:= AScan(aHeader,{|x|Alltrim(x[2])=="D1_SERIREM"})  
Local	_nPDescri 	:= AScan(aHeader,{|x|Alltrim(x[2])=="D1_XDESCOD"})
Local	_nPProduc 	:= AScan(aHeader,{|x|Alltrim(x[2])=="D1_COD"})
Local 	calias		:= "QryWrk"
Local 	nValDesc	:= 0
Local  	nDescTot	:= 0
Local  	nDescTot2	:= 0

If funname()='MATA101N'  // si es Factura de compras
 	If SF1->( dbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE) )
       M->F1_NATUREZ := SF1->F1_NATUREZ     
    ENDIF
	acols[len(acols)][_nPDescri] := SD1->D1_XDESCOD
	acols[LEN(ACOLS)][GDFieldPos("D1_PEDIDO")]:= Criavar("D1_PEDIDO")
	acols[LEN(ACOLS)][GDFieldPos("D1_ITEMPC")]:= Criavar("D1_ITEMPC")	
	
ElseIf Funname()== "MATA465N"   
/*
	ACOLS[LEN(ACOLS)][ GDFieldPos( "D1_XDESCOD" )] := Posicione("SB1",1,Xfilial("SB1")+SD1->D1_COD,"B1_DESC")
	If Empty(SD1->D1_NFORI)
		ACOLS[LEN(ACOLS)][ GDFieldPos( "D1_NFORI" )] := ACOLS[LEN(ACOLS)][ GDFieldPos( "D1_REMITO" )] 
	EndIf
	If Empty(SD1->D1_SERIORI)
		ACOLS[LEN(ACOLS)][ GDFieldPos( "D1_SERIORI" )] := ACOLS[LEN(ACOLS)][ GDFieldPos( "D1_SERIREM" )] 
	EndIf
*/
EndIf

RestArea(aArea)       
Return 