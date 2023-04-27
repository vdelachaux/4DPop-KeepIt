//%attributes = {}
// ----------------------------------------------------
// Project method : Hashtag.tool
// Database: 4DPop KeepIt
// ID[3F50F6F5AD91492EAA34E93FE90EB9CB]
// Created 14-1-2013 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// #4DPop Main entryPoint for hashtags
// ----------------------------------------------------
// Declarations
C_POINTER:C301($1)

C_LONGINT:C283($Lon_parameters)

If (False:C215)
	C_POINTER:C301(Hashtag_tool; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	//NO PARAMETERS REQUIRED
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------

hashtag_list

// ----------------------------------------------------
// End