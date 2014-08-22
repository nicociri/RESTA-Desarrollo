User Function A087TUDOK
Local aArea     := GetArea()
Local lRet      := .T.
Local nPosEst   := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'EL_XESTADO'    } )
Local nPosTDoc  := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'EL_TIPODOC'    } )

If nPanel == 1
	For a := 1 to len(acols)
	  IF !aCols[a,Len(aHeader)+1]
         If Alltrim(aCols[a,nPosTDoc]) == "CH" .and. Empty(aCols[a,nPosEst])
            Msgstop("Estado vacio")
            lRet := .F.
         EndIf
     EndIf
	Next a
EndIf

RestArea(aArea)
Return (lRet)