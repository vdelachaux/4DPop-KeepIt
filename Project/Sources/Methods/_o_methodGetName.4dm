//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : methodGetName
// Database: 4DPop KeepIt
// ID[B645F54F5ACF4822830E3A43BBFC41AF]
// Created #16-7-2013 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($0)
C_BOOLEAN:C305($1)

C_BOOLEAN:C305($Boo_frontmost)
C_LONGINT:C283($Lon_; $Lon_parameters; $Lon_x)
C_TEXT:C284($Txt_buffer)

If (False:C215)
	C_TEXT:C284(_o_methodGetName; $0)
	C_BOOLEAN:C305(_o_methodGetName; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	If ($Lon_parameters>=1)
		
		$Boo_frontmost:=$1
		
	Else 
		
		PROCESS PROPERTIES:C336(Current process:C322; $Txt_buffer; $Lon_; $Lon_)
		$Boo_frontmost:=($Txt_buffer="Macro_Call")
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
$Txt_buffer:=Choose:C955($Boo_frontmost; Get window title:C450(Frontmost window:C447); Get window title:C450(Next window:C448(Current form window:C827)))

// Delete database name as prefix if any
$Lon_x:=Position:C15(" - "; $Txt_buffer)

If ($Lon_x>0)
	
	$Txt_buffer:=Delete string:C232($Txt_buffer; 1; $Lon_x+3)
	
End if 

$0:=$Txt_buffer

// ----------------------------------------------------
// End