# include 'PRTOPDEF.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKINCU5  ºAutor  ³ Nicolas Cirigliano ºFecha ³  07/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE en la inclusion de nuevos contactos, que graba la       º±±
±±º          ³ relacion contacto/cliente en la AC8                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function TMKINCU5()

// AC8_FILIAL+AC8_CODCON+AC8_ENTIDA+AC8_FILENT+AC8_CODENT
AC8->(DbSetOrder(1))


//Busco relacion con la Constructora
If !EMpty(M->U5_XCONST+M->U5_XLOJCON)
	If AC8->(DbSeek(xFilial('AC8')+M->U5_CODCONT+"SA1"+xFilial('AC8')+M->U5_XCONST+M->U5_XLOJCON))
		Alert ("La Constructora ya figura como contacto de esta obra")
	else
   		RecLock("AC8",.T.)
     	Replace AC8->AC8_FILIAL         With "  "
     	Replace AC8->AC8_FILENT         With "  "
     	Replace AC8->AC8_ENTIDA			With "SA1"
	    Replace AC8->AC8_CODENT			With M->U5_XCONST+M->U5_XLOJCON
	    Replace AC8->AC8_CODCON			With M->U5_CODCONT
	    AC8->(MsUnlock())
	endif
endif

//Busco relacion con el Director de Proyecto
If !EMpty(M->U5_XDIRPRO+M->U5_XLOJDP)
	If AC8->(DbSeek(xFilial('AC8')+M->U5_CODCONT+"SA1"+xFilial('AC8')+M->U5_XDIRPRO+M->U5_XLOJDP))
		Alert ("El director de proyecto ya figura como contacto de esta obra")
	else
   		RecLock("AC8",.T.)
     	Replace AC8->AC8_FILIAL         With "  "
     	Replace AC8->AC8_FILENT         With "  "
     	Replace AC8->AC8_ENTIDA			With "SA1"
	    Replace AC8->AC8_CODENT			With M->U5_XDIRPRO+M->U5_XLOJDP
	    Replace AC8->AC8_CODCON			With M->U5_CODCONT
	    AC8->(MsUnlock())
	endif
endif
     
//Busco relacion con el Director de Obra
If !EMpty(M->U5_XDIROB+M->U5_XLOJDO)
	If AC8->(DbSeek(xFilial('AC8')+M->U5_CODCONT+"SA1"+xFilial('AC8')+M->U5_XDIROB+M->U5_XLOJDO))
		Alert ("El director de obra ya figura como contacto de esta obra")
	else
   		RecLock("AC8",.T.)
	     	Replace AC8->AC8_FILIAL         With "  "
	     	Replace AC8->AC8_FILENT         With "  "
	     	Replace AC8->AC8_ENTIDA			With "SA1"
		    Replace AC8->AC8_CODENT			With M->U5_XDIROB+M->U5_XLOJDO
		    Replace AC8->AC8_CODCON			With M->U5_CODCONT
	    AC8->(MsUnlock())
	endif
endif


//Busco relacion con el Instalador
If !EMpty(M->U5_XINSTAL+M->U5_XLOJIN)
	If AC8->(DbSeek(xFilial('AC8')+M->U5_CODCONT+"SA1"+xFilial('AC8')+M->U5_XINSTAL+M->U5_XLOJIN))
		Alert ("El Instalador ya figura como contacto de esta obra")
	else
   		RecLock("AC8",.T.)
	     	Replace AC8->AC8_FILIAL         With "  "
	     	Replace AC8->AC8_FILENT         With "  "
	     	Replace AC8->AC8_ENTIDA			With "SA1"
		    Replace AC8->AC8_CODENT			With M->U5_XINSTAL+M->U5_XLOJIN
		    Replace AC8->AC8_CODCON			With M->U5_CODCONT
	    AC8->(MsUnlock())
	endif
endif

Return