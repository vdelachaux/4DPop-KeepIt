_O_C_LONGINT:C283($Lon_type)
_O_C_POINTER:C301($Ptr_table)
_O_C_TEXT:C284($Txt_formObjectName; $Txt_objectName; $Txt_path)

If (Self:C308->#0)
	
	//%W-533.3
	$Txt_path:=Self:C308->{Self:C308->}
	//%W+533.3
	
	METHOD RESOLVE PATH:C1165($Txt_path; $Lon_type; $Ptr_table; $Txt_objectName; $Txt_formObjectName; *)
	
	If ($Lon_type#0)
		
		METHOD OPEN PATH:C1213($Txt_path; *)
		
	End if 
	
End if 