//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : doc_File
// Database: 4D Mobile App
// ID[E4BCA07C239A4A898B5AFF446D5CCD08]
// Created #12-7-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Waiting for File command !
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_invisible; $Boo_locked)
C_DATE:C307($Dat_creation; $Dat_modified)
C_LONGINT:C283($Lon_parameters)
C_TIME:C306($Gmt_creation; $Gmt_modified)
C_TEXT:C284($Txt_pathname)
C_OBJECT:C1216($Obj_file)

If (False:C215)
	C_OBJECT:C1216(doc_File; $0)
	C_TEXT:C284(doc_File; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$Txt_pathname:=$1
	
	// Default values
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Length:C16($Txt_pathname)#0)\
 & (Test path name:C476($Txt_pathname)=Is a document:K24:1)
	
	$Obj_file:=Path to object:C1547($Txt_pathname)
	$Obj_file.isFile:=True:C214
	
	$Obj_file.fullName:=$Obj_file.name+$Obj_file.extension
	$Obj_file.nativePath:=$Txt_pathname
	$Obj_file.path:=Convert path system to POSIX:C1106($Txt_pathname)
	
	GET DOCUMENT PROPERTIES:C477($Txt_pathname; $Boo_locked; $Boo_invisible; $Dat_creation; $Gmt_creation; $Dat_modified; $Gmt_modified)
	$Obj_file.creationDate:=String:C10($Dat_creation; ISO date GMT:K1:10; $Gmt_creation)
	$Obj_file.lastModification:=String:C10($Dat_modified; ISO date GMT:K1:10; $Gmt_modified)
	
	$Obj_file.size:=Get document size:C479($Txt_pathname)
	
Else 
	
	$Obj_file:=Path to object:C1547("")
	$Obj_file.isFile:=False:C215
	$Obj_file.fullName:=""
	$Obj_file.nativePath:=""
	$Obj_file.path:=""
	$Obj_file.creationDate:=String:C10(!00-00-00!; ISO date GMT:K1:10; ?00:00:00?)
	$Obj_file.lastModification:=String:C10(!00-00-00!; ISO date GMT:K1:10; ?00:00:00?)
	$Obj_file.size:=0
	
End if 

// ----------------------------------------------------
// Return
$0:=$Obj_file

// ----------------------------------------------------
// End