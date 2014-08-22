# include 'PRTOPDEF.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKALTU5  ºAutor  ³ Nicolas Cirigliano ºFecha ³  07/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE en la modificacion de los contactos, que graba la       º±±
±±º          ³ relacion contacto/cliente en la AC8                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TMKALTU5()

// AC8_FILIAL+AC8_CODCON+AC8_ENTIDA+AC8_FILENT+AC8_CODENT
AC8->(DbSetOrder(1))

//Busco relacion con la Constructora
If !EMpty(M->U5_XCONST+M->U5_XLOJCON)
	If !AC8->(DbSeek(xFilial('AC8')+M->U5_CODCONT+"SA1"+xFilial('AC8')+M->U5_XCONST+M->U5_XLOJCON))
		RecLock("AC8",.T.)
	     	Replace AC8->AC8_FILIAL 	    With "  "
	     	Replace AC8->AC8_FILENT	    	With "  "
	     	Replace AC8->AC8_ENTIDA			With "SA1"
		    Replace AC8->AC8_CODENT			With M->U5_XCONST+M->U5_XLOJCON
		    Replace AC8->AC8_CODCON			With M->U5_CODCONT
	    AC8->(MsUnlock())
	endif
endif

//Busco relacion con el Director de Proyecto
If !EMpty(M->U5_XDIRPRO+M->U5_XLOJDP)
	If !AC8->(DbSeek(xFilial('AC8')+M->U5_CODCONT+"SA1"+xFilial('AC8')+M->U5_XDIRPRO+M->U5_XLOJDP))
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
	If !AC8->(DbSeek(xFilial('AC8')+M->U5_CODCONT+"SA1"+xFilial('AC8')+M->U5_XDIROB+M->U5_XLOJDO))
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
	If !AC8->(DbSeek(xFilial('AC8')+M->U5_CODCONT+"SA1"+xFilial('AC8')+M->U5_XINSTAL+M->U5_XLOJIN))
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