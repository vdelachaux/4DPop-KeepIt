//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : keepit_session
// Database: 4DPop KeepIt
// ID[8655756B26CB4818B05BA523A55EB05A]
// Created #21-9-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_in; $Obj_out)

If (False:C215)
	C_OBJECT:C1216(keepit_session; $0)
	C_OBJECT:C1216(keepit_session; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$Obj_in:=$1
	
	// Default values
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success"; False:C215)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Bool:C1537($Obj_in.set))
	
	If (Storage:C1525.keepitSession=Null:C1517)
		
		Use (Storage:C1525)
			
			Storage:C1525.keepitSession:=New shared object:C1526
			
		End use 
		
	End if 
	
	Use (Storage:C1525.keepitSession)
		
		Storage:C1525.keepitSession[$Obj_in.key]:=$Obj_in.value
		
	End use 
	
	$Obj_out.success:=True:C214
	
Else 
	
	$Obj_out.success:=(Storage:C1525.keepitSession[$Obj_in.key]#Null:C1517)
	
	If ($Obj_out.success)
		
		$Obj_out.value:=Storage:C1525.keepitSession[$Obj_in.key]
		
	End if 
End if 

// ----------------------------------------------------
// Return
$0:=$Obj_out

// ----------------------------------------------------
// End