//Customizacion de usuario para manipulacion
//de campos en el array en la seleccion de solicitud de compras o contratos - F4 en el Pedido de Compras.

User function MT120VSC()         

 
Local ExpA1 := ParamIxb[1]            
Local ExpN2 := ParamIxb[2]    

If ExpN2==1 
	AADD(ExpA1,"C1_XPROSTD")  //Campo para indicar el codigo del proveedor standard
	AADD(ExpA1,"C1_XPRODES")  //Campo Para indicar el nombre del proveedor standard
EndIf 
Return ExpA1