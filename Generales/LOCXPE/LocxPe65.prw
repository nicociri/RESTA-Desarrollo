

User Function LocxPe65()
Local aCols    := ParamIxb[2]
Local nPosTES  := Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_TES"  })
Local nPosDep  := Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_LOCAL"})
Local cTes     := Getnewpar("RT_TES462E","011")
Local cLocal   := Getnewpar("RT_DEP462E","01")

If cEspecie == "RTE" // Remito de transferencia de entrada
   For nI := 1 To Len(aCols)
      aCols[nI][nPosTES] := cTes
      aCols[nI][nPosDep] := cLocal
   Next nI
EndIf

Return(aCols)