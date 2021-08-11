//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : hashtag.handler
// Database: 4DPop KeepIt
// ID[E556312A1B47464EA1028F0ADFAFDE33]
// Created 11-1-2013 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_BOOLEAN:C305($0)
C_TEXT:C284($1)
C_POINTER:C301(${2})

C_BOOLEAN:C305($Boo_debug)
C_LONGINT:C283($Lon_count; $Lon_parameters)
C_TEXT:C284($Txt_databasePath; $Txt_entrypoint; $Txt_hashtag; $Txt_methodPath; $Txt_rootPath)

If (False:C215)
	C_BOOLEAN:C305(hashtag_handler; $0)
	C_TEXT:C284(hashtag_handler; $1)
	C_POINTER:C301(hashtag_handler; ${2})
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	//NO PARAMETERS REQUIRED
	
	If ($Lon_parameters>=1)
		
		$Txt_entrypoint:=$1
		
		$Txt_rootPath:=Get 4D folder:C485(Database folder:K5:14; *)+"Preferences"+Folder separator:K24:12+"4DPop"+Folder separator:K24:12
		
		$Txt_databasePath:=$Txt_rootPath+"4DPop.4DD"
		
	End if 
	
	$Boo_debug:=(Structure file:C489=Structure file:C489(*))
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------

Case of 
		
		//______________________________________________________
	: (Length:C16($Txt_entrypoint)=0)
		
		If (Method called on error:C704=Current method name:C684)
			
			// ERROR MANAGEMENT
			sql_error:=ERROR
			
		End if 
		
		//______________________________________________________
	: ($Txt_entrypoint="init")
		
		C_LONGINT:C283(Lon_error)
		
		SET ASSERT ENABLED:C1131($Boo_debug; *)
		
		If (Not:C34($Boo_debug))  // Install the catching of the errors (no error)
			
			Lon_error:=0
			ON ERR CALL:C155("noError")
			
		End if 
		
		If (Test path name:C476($Txt_databasePath)#Is a document:K24:1)
			
			//Create path
			CREATE FOLDER:C475($Txt_rootPath; *)
			
			Begin SQL  //Create database
				
				CREATE DATABASE
				IF NOT EXISTS
				DATAFILE <<$Txt_databasePath>>;
				
			End SQL
			
			If (Lon_error=0)
				
				Begin SQL  //Create table
					
					USE LOCAL DATABASE
					DATAFILE <<$Txt_databasePath>>;
					
					CREATE TABLE IF NOT EXISTS HASHTAGS
					(word VARCHAR,
					path VARCHAR);
					
					USE DATABASE
					SQL_INTERNAL;
					
				End SQL
				
				If (Lon_error=0)
					
					//launch the parsing off all the methods
					hashtag_parse
					
				End if 
			End if 
		End if 
		
		// Disable the catching of the errors
		ON ERR CALL:C155("")
		
		//______________________________________________________
	: ($Txt_entrypoint="open")
		
		If (hashtag_handler("init"))
			
			If (Not:C34($Boo_debug))  // Install the catching of the errors (no error)
				
				Lon_error:=0
				ON ERR CALL:C155("noError")
				
			End if 
			
			Begin SQL
				
				USE DATABASE
				DATAFILE <<$Txt_databasePath>>;
				
			End SQL
			
		End if 
		
		//______________________________________________________
	: ($Txt_entrypoint="close")
		
		Begin SQL
			
			USE DATABASE
			SQL_INTERNAL;
			
		End SQL
		
		// Disable the catching of the errors
		ON ERR CALL:C155("")
		
		//______________________________________________________
	: ($Txt_entrypoint="empty")
		
		Begin SQL
			
			DELETE FROM HASHTAGS;
			
		End SQL
		
		//______________________________________________________
	: ($Lon_parameters<2)
		
		ASSERT:C1129(False:C215; "Missing parameter")
		
		//______________________________________________________
	: ($Txt_entrypoint="purge")
		
		$Txt_methodPath:=$2->
		
		Begin SQL
			
			DELETE FROM HASHTAGS
			WHERE path = <<$Txt_methodPath>>;
			
		End SQL
		
		//______________________________________________________
	: ($Txt_entrypoint="get-hashtag")
		
		Ptr_1:=$2
		
		Begin SQL
			
			SELECT DISTINCT word
			FROM HASHTAGS
			INTO <<Ptr_1>>;
			
		End SQL
		
		//______________________________________________________
	: ($Lon_parameters<3)
		
		ASSERT:C1129(False:C215; "Missing parameter")
		
		//______________________________________________________
	: ($Txt_entrypoint="store")
		
		$Txt_methodPath:=$2->
		$Txt_hashtag:=$3->
		
		Begin SQL
			
			SELECT COUNT(*)
			FROM HASHTAGS
			WHERE word = <<$Txt_hashtag>> AND path = <<$Txt_methodPath>>
			INTO <<$Lon_count>>;
			
		End SQL
		
		If ($Lon_count=0)
			
			Begin SQL
				
				INSERT INTO HASHTAGS (word, path)
				VALUES (<<$Txt_hashtag>>, <<$Txt_methodPath>>);
				
			End SQL
			
		End if 
		
		//______________________________________________________
	: ($Txt_entrypoint="get")
		
		Ptr_1:=$2
		Ptr_2:=$3
		
		Begin SQL
			
			SELECT ALL word, path
			FROM HASHTAGS
			INTO <<Ptr_1>>, <<Ptr_2>>;
			
		End SQL
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entrypoint: \""+$Txt_entryPoint+"\"")
		
		//______________________________________________________
End case 

$0:=(Lon_error=0)

// ----------------------------------------------------
// End