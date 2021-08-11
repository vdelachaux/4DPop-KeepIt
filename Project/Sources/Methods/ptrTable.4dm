//%attributes = {"invisible":true}
C_POINTER:C301($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_i)
C_POINTER:C301($Ptr_table)
C_TEXT:C284($Txt_table)

If (False:C215)
	C_POINTER:C301(ptrTable; $0)
	C_TEXT:C284(ptrTable; $1)
End if 

$Txt_table:=$1

$Txt_table:=Replace string:C233($Txt_table; "["; "")
$Txt_table:=Replace string:C233($Txt_table; "]"; "")

For ($Lon_i; 1; Get last table number:C254)
	
	If (Is table number valid:C999($Lon_i))
		
		If (Table name:C256($Lon_i)=$Txt_table)
			
			$Ptr_table:=Table:C252($Lon_i)
			
			$Lon_i:=MAXLONG:K35:2-1
			
		End if 
	End if 
End for 

$0:=$Ptr_table