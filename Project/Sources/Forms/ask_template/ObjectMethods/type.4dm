C_LONGINT:C283($Lon_; $Lon_bottom; $Lon_height; $Lon_index; $Lon_left; $Lon_offset; $Lon_right; $Lon_target)
C_LONGINT:C283($Lon_top; $Lon_windowRef)

$Lon_index:=(OBJECT Get pointer:C1124(Object named:K67:5; "type"))->

OBJECT SET VISIBLE:C603(*; "opt.@"; False:C215)

Case of 
		//______________________________________________________
	: ($Lon_index=9)
		
		OBJECT GET COORDINATES:C663(*; "tmpl.opt.value"; $Lon_; $Lon_top; $Lon_; $Lon_bottom)
		$Lon_height:=$Lon_bottom-$Lon_top
		
		OBJECT SET VISIBLE:C603(*; "opt.value.@"; True:C214)
		GOTO OBJECT:C206(*; "opt.value.list")
		
		//______________________________________________________
	: ($Lon_index=11)
		
		OBJECT GET COORDINATES:C663(*; "tmpl.opt.result"; $Lon_; $Lon_top; $Lon_; $Lon_bottom)
		$Lon_height:=$Lon_bottom-$Lon_top
		
		OBJECT SET VISIBLE:C603(*; "opt.result.@"; True:C214)
		GOTO OBJECT:C206(*; "opt.result.value")
		
		//______________________________________________________
	Else 
		
		//______________________________________________________
End case 

$Lon_target:=116+$Lon_height

OBJECT GET COORDINATES:C663(*; "b.OK"; $Lon_; $Lon_top; $Lon_; $Lon_)

If ($Lon_target#$Lon_top)
	
	$Lon_offset:=($Lon_target+Choose:C955($Lon_target>116; 10; 0))-$Lon_top
	
	OBJECT MOVE:C664(*; "b.OK"; 0; $Lon_offset)
	OBJECT MOVE:C664(*; "b.escape"; 0; $Lon_offset)
	
	$Lon_windowRef:=Current form window:C827
	GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_windowRef)
	SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_bottom+$Lon_offset; $Lon_windowRef)
	
End if 

