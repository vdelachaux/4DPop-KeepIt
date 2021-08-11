//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : keepit_ask
// Database: 4DPop KeepIt
// ID[27BFAB84990A477B8DFCDB30E697EA53]
// Created 14-11-2012 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters; $Win_hdl)
C_TEXT:C284($Txt_question; $Txt_type)
C_OBJECT:C1216($Obj_data)

If (False:C215)
	C_TEXT:C284(keepit_ask; $0)
	C_TEXT:C284(keepit_ask; $1)
	C_TEXT:C284(keepit_ask; $2)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	$Txt_question:=$1
	
	If ($Lon_parameters>=2)
		
		$Txt_type:=$2
		
	Else 
		
		$Txt_type:="text"
		
	End if 
	
	$Obj_data:=New object:C1471(\
		"question"; $Txt_question; \
		"type"; $Txt_type)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
$Win_hdl:=Open form window:C675("ASK"; Movable form dialog box:K39:8; Horizontally centered:K39:1; Vertically centered:K39:4)
DIALOG:C40("ASK"; $Obj_data)
CLOSE WINDOW:C154

If (Bool:C1537(OK))
	
	Case of 
			
			//______________________________________________________
		: ($Obj_data.type="text")  // Empty string
			
			$0:=String:C10($Obj_data.result)
			
			//______________________________________________________
		: ($Obj_data.type="integer")\
			 | ($Obj_data.type="real")  // 0
			
			$0:=String:C10(Num:C11($Obj_data.result))
			
			//______________________________________________________
		Else 
			
			$0:=String:C10($Obj_data.result)  // As text
			
			//______________________________________________________
	End case 
End if 

// ----------------------------------------------------
// End