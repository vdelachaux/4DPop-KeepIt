C_TEXT:C284($Txt_code)
C_OBJECT:C1216($Obj_form)

$Obj_form:=Form:C1466.definition

If (OBJECT Get name:C1087(Object with focus:K67:3)=$Obj_form.code)
	
	$Txt_code:=Get edited text:C655
	
	If (OBJECT Is styled text:C1261(*; $Obj_form.code))
		
		$Txt_code:=ST Get plain text:C1092($Txt_code)
		
	End if 
	
	Form:C1466.current.code:=keepit_indent($Txt_code)
	Form:C1466.current.save()
	
End if 