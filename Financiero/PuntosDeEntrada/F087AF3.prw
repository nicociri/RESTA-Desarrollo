User Function F087AF3()
// Variaveis Locais da Funcao
Local cRetorno := "SA1" // Consulta estandar Padron. Puede ser modificada
dbselectarea("SAE")

cTiposAdm := GetSAeTipos()

Return(cRetorno)