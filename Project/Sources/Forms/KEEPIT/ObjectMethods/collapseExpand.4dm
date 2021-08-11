// ----------------------------------------------------
// Object method : KEEPIT.opened - (4DPop KeepIt)
// ID[D5087D194E7640AEAE918F475F0DA08E]
// Created #4-7-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_BOOLEAN:C305($Boo_collapsed)
C_LONGINT:C283($Lon_; $Lon_bottom; $Lon_left; $Lon_right; $Lon_separator; $Lon_top)
C_LONGINT:C283($Lon_window)
C_OBJECT:C1216($Obj_form)

// ----------------------------------------------------
// Initialisations
$Obj_form:=Form:C1466.definition
$Obj_form.event:=Form event code:C388
$Obj_form.current:=OBJECT Get name:C1087(Object current:K67:2)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Obj_form.event=On Clicked:K2:4)
		
		$Lon_window:=Current form window:C827
		
		OBJECT GET COORDINATES:C663(*; $Obj_form.separator; $Lon_; $Lon_; $Lon_separator; $Lon_)
		
		GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_window)
		
		If (($Lon_right-$Lon_left)>$Lon_separator)
			
			// Minimize to the list width
			$Lon_right:=$Lon_left+$Lon_separator
			SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_window)
			
			// Deny horizontal resizing
			FORM SET HORIZONTAL RESIZING:C892(False:C215)
			
			// Set automatic size to the line separator
			FORM SET SIZE:C891($Obj_form.separator; 0; 0)
			
			$Boo_collapsed:=True:C214
			
			// Hide vertical splitter
			OBJECT SET VISIBLE:C603(*; $Obj_form.splitter; False:C215)
			
			// Allowed events
			ARRAY LONGINT:C221($tLon_events; 3)
			$tLon_events{1}:=On Mouse Move:K2:35
			$tLon_events{2}:=On Begin Drag Over:K2:44
			OBJECT SET EVENTS:C1239(*; "snippetList"; $tLon_events; Enable events disable others:K42:37)
			
		Else 
			
			// Expand to the last used width
			OBJECT GET COORDINATES:C663(*; $Obj_form.zoom; $Lon_; $Lon_; $Lon_right; $Lon_)
			$Lon_right:=$Lon_left+$Lon_right+10
			SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_window)
			
			// Deny horizontal resizing
			FORM SET HORIZONTAL RESIZING:C892(True:C214)
			
			// Set automatic size to the text box
			FORM SET SIZE:C891($Obj_form.code; 0; 0)
			
			$Boo_collapsed:=False:C215
			
			// Show vertical splitter
			OBJECT SET VISIBLE:C603(*; $Obj_form.splitter; True:C214)
			
			// Allowed events
			ARRAY LONGINT:C221($tLon_events; 6)
			$tLon_events{1}:=On Selection Change:K2:29
			$tLon_events{2}:=On Clicked:K2:4
			$tLon_events{3}:=On Double Clicked:K2:5
			$tLon_events{4}:=On Before Data Entry:K2:39
			$tLon_events{5}:=On Losing Focus:K2:8
			$tLon_events{6}:=On Delete Action:K2:56
			
			OBJECT SET EVENTS:C1239(*; $Obj_form.list; $tLon_events; Enable events disable others:K42:37)
			
			// Update UI
			SET TIMER:C645(-1)
			
		End if 
		
		OBJECT SET HELP TIP:C1181(*; $Obj_form.list; "")
		
		// Set me
		Self:C308->:=Num:C11($Boo_collapsed)
		
		// Keep the state
		//keepit_preferences ("minimized.set";->$Boo_collapsed)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+String:C10($Obj_form.event)+")")
		
		//______________________________________________________
End case 