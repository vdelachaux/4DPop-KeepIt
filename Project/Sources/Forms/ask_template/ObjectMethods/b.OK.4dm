C_LONGINT:C283($Lon_type; $Lon_x)
C_POINTER:C301($Ptr_type)
C_TEXT:C284($Txt_request; $Txt_type)

$Txt_request:=(OBJECT Get pointer:C1124(Object named:K67:5; "request"))->

ARRAY TEXT:C222($tTxt_type; 0x0000)
APPEND TO ARRAY:C911($tTxt_type; "text")
APPEND TO ARRAY:C911($tTxt_type; "integer")
APPEND TO ARRAY:C911($tTxt_type; "real")
APPEND TO ARRAY:C911($tTxt_type; "-")
APPEND TO ARRAY:C911($tTxt_type; "table")
APPEND TO ARRAY:C911($tTxt_type; "field")
APPEND TO ARRAY:C911($tTxt_type; "user")
APPEND TO ARRAY:C911($tTxt_type; "group")
APPEND TO ARRAY:C911($tTxt_type; "{%}")
APPEND TO ARRAY:C911($tTxt_type; "-")
APPEND TO ARRAY:C911($tTxt_type; "\\%")

$Ptr_type:=OBJECT Get pointer:C1124(Object named:K67:5; "type")
$Lon_type:=$Ptr_type->

Case of 
		
		//------------------------------------------------
	: ($Lon_type=11)  // Response
		
		$Lon_x:=(OBJECT Get pointer:C1124(Object named:K67:5; "opt.result.value"))->
		
		If ($Lon_x>0)
			
			$Txt_request:=Replace string:C233($tTxt_type{$Lon_type}; "%"; \
				String:C10($Lon_x))
			
			$Txt_type:="$"
			
		End if 
		
		//------------------------------------------------
	: (Length:C16($Txt_request)=0)
		
		BEEP:C151
		
		//------------------------------------------------
	: ($Lon_type=9)  // List
		
		$Txt_type:=Replace string:C233($tTxt_type{$Lon_type}; "%"; \
			Replace string:C233((OBJECT Get pointer:C1124(Object named:K67:5; "opt.value.list"))->; "\r"; ";"))
		
		//------------------------------------------------
	Else 
		
		$Txt_type:=$tTxt_type{$Lon_type}
		
		//------------------------------------------------
End case 

If (Length:C16($Txt_type)>0)
	
	Form:C1466.tag:=Choose:C955($Txt_type="$"; "<ask message=\""+$Txt_request+"\"/>"; "<ask message=\""+$Txt_request+"\" type=\""+$Txt_type+"\"/>")
	
	ACCEPT:C269
	
End if 