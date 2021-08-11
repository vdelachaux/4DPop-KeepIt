// ----------------------------------------------------
// Object method : KEEPIT.text - (4DPop KeepIt)
// ID[A614D9877E26433AB2BDA39C058166B6]
// Created #21-9-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($Obj_form)

// ----------------------------------------------------
// Initialisations
$Obj_form:=Form:C1466.definition
$Obj_form.event:=Form event code:C388
$Obj_form.current:=OBJECT Get name:C1087(Object current:K67:2)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Obj_form.event=On Getting Focus:K2:7)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($Obj_form.event=On Data Change:K2:15)
		
		Form:C1466.save()
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+String:C10($Obj_form.event)+")")
		
		//______________________________________________________
End case 