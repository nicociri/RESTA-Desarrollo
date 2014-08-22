#include "rwmake.ch"       

User Function ARFISP03()     


SetPrvt("CALIAS,CRETCOD,_CTIPORET,_CCONCEPTO,")


cAlias   := Alias()

cRetCod := "   "
_cTipoRet   := ParamIxb[1]
_cConcepto  := ParamIxb[2]

Do case
	Case _cTipoRet == "G"
	   DbSelectArea("SFF")
	   DbSetOrder(5)
	   DbSeek( xFilial("SFF") + "GAN" )
	   While FF_IMPOSTO == "GAN" .and. !EOF()
	      If Alltrim( FF_ITEM ) == alltrim(_cConcepto)
	         IF FieldPos('FF_CODREG')>0
	         	cRetCod  := FF_CODREG
	         Endif
	         Exit
	      EndIf
	      DbSkip()
	   EndDo
	Case _cTipoRet == "S"
		DbSelectArea("SFF")
	   	DbSetOrder(5)
	   	DbSeek( xFilial("SFF") + "SUS" )
	   	While FF_IMPOSTO == "SUS" .and. !EOF()
	      If Alltrim( FF_ITEM )==alltrim(_cConcepto) 
	         IF FieldPos('FF_CODREG')>0
	         	cRetCod  := FF_CODREG
	         Endif
	         Exit
	      EndIf
	      DbSkip()
	   	EndDo
	Case _cTipoRet == "I"
		DbSelectArea("SFF")
	   	DbSetOrder(5)
	   	DbSeek( xFilial("SFF") + "IVR" )
	   	While FF_IMPOSTO == "IVR" .and. !EOF()
	      If Left(FF_CFO_C,3)==alltrim(_cConcepto) 
	         IF FieldPos('FF_CODREG')>0
	         	cRetCod  := FF_CODREG
	         Endif
	         Exit
	      EndIf
	      DbSkip()
	   	EndDo
	Case _cTipoRet == "B"
			cRetCod := "   "
EndCase

DbSelectArea( cAlias )

cRetCod := Right("000"+Trim(cRetCod),3)
Return( cRetCod ) 
