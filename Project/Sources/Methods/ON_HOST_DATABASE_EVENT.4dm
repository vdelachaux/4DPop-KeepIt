//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : ON_HOST_DATABASE_EVENT - (4DPop KeepIt)
// ID[7F2BF97C7B8944F0ABEEF459E58C70C3]
// Created #21-9-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($1)

C_LONGINT:C283($Lon_databaseEvent)

If (False:C215)
	C_LONGINT:C283(ON_HOST_DATABASE_EVENT; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_databaseEvent:=$1

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Lon_databaseEvent=On before host database startup:K74:3)
		
		// The host database has just been started. The On Startup database method method
		// of the host database has not yet been called.
		// The On Startup database method of the host database is not called while the On
		// host Database Event database method of the component is running
		
		//______________________________________________________
	: ($Lon_databaseEvent=On after host database startup:K74:4)
		
		// The On Startup database method of the host database just finished running
		COMPILER_component
		
		keepit_update
		
		If (Is macOS:C1572)
			
			hashtag_parse
			
		End if 
		
		
		//______________________________________________________
	: ($Lon_databaseEvent=On before host database exit:K74:5)
		
		// The host database is closing. The On Exit database method of the host database
		// has not yet been called.
		// The On Exit database method of the host database is not called while the On Host
		// Database Event database method of the component is running
		
		//______________________________________________________
	: ($Lon_databaseEvent=On after host database exit:K74:6)
		
		// The On Exit database method of the host database has just finished running
		
		//______________________________________________________
End case 