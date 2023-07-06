//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : keepit_session
// Database: 4DPop KeepIt
// ID[8655756B26CB4818B05BA523A55EB05A]
// Created #21-9-2018 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($in : Object) : Object

If (False:C215)
	C_OBJECT:C1216(keepit_session; $1)
	C_OBJECT:C1216(keepit_session; $0)
End if 

var $out : Object

$out:={success: False:C215}

// ----------------------------------------------------
If (Bool:C1537($in.set))
	
	If (Storage:C1525.keepitSession=Null:C1517)
		
		Use (Storage:C1525)
			
			Storage:C1525.keepitSession:=New shared object:C1526
			
		End use 
		
	End if 
	
	Use (Storage:C1525.keepitSession)
		
		Storage:C1525.keepitSession[$in.key]:=$in.value
		
	End use 
	
	$out.success:=True:C214
	
Else 
	
	$out.success:=(Storage:C1525.keepitSession[$in.key]#Null:C1517)
	
	If ($out.success)
		
		$out.value:=Storage:C1525.keepitSession[$in.key]
		
	End if 
End if 

return $out