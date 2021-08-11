// ----------------------------------------------------
// Object method : KEEPIT.zoom - (4DPop KeepIt)
// ID[C9DE80DB4B4F4F73B3323115F64937A7]
// Created #4-7-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Modified #4-7-2018 by Vincent de Lachaux
// Modernization
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
	: ($Obj_form.event=On Data Change:K2:15)
		
		OBJECT SET FONT SIZE:C165(*; $Obj_form.code; Self:C308->)
		
		//______________________________________________________
	: ($Obj_form.event=On Mouse Enter:K2:33)
		
		SET DATABASE PARAMETER:C642(Tips delay:K37:80; 0)
		
		//______________________________________________________
	: ($Obj_form.event=On Mouse Leave:K2:34)
		
		SET DATABASE PARAMETER:C642(Tips delay:K37:80; 40)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+String:C10($Obj_form.event)+")")
		
		//______________________________________________________
End case 

OBJECT SET HELP TIP:C1181(*; $Obj_form.current; String:C10(Round:C94(100*Self:C308->/12; 0))+" %")