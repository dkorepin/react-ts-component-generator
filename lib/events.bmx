Function HandleEvents()
	Select EventID()
        Case EVENT_GADGETACTION
            Select EventSource()
				Case GENERATE_BUTTON
					GenerateFiles();
			EndSelect
		Case EVENT_WINDOWCLOSE
		End
	EndSelect
EndFunction

Function GenerateFiles%()
	local id% = 0;
	local isMemoised@ = ButtonState(IS_MEMOISED_CHECKBOX);
	local withProps@ = ButtonState(WITH_PROPS_CHECKBOX);
	local withConsts@ = ButtonState(GEN_CONSTS_CHECKBOX);
	local withStyles@ = ButtonState(GEN_STYLES_CHECKBOX);
	local withHooks@ = ButtonState(GEN_HOOKS_CHECKBOX);
	local withHelpers@ = ButtonState(GEN_HELPERS_CHECKBOX);
	local withSlice@ = ButtonState(GEN_SLICE_CHECKBOX);
	Local inputName$ = trim(GadgetText( NAME_INPUT )).Replace(" ", "");
	if (len(inputName) < 1) return Notify( "Name is empty", true );

	local hookTypeName$ = "T"+inputName+"Hook";
	local stateTypeName$ = "T"+inputName+"State";

	local nameList: Tlist = new Tlist();

	local tempName$ = Chr(inputName[0]);
	For id = 1 Until len(inputName)
		local char$ = Chr(inputName[id]);

		if (char = char.ToLower())
			tempName:+char;
		else
			nameList.AddLast(tempName);
			tempName = char;
		endif
	Next

	if (len(tempName) > 0) nameList.AddLast(tempName);

	local fileName$ = "";
	id = 0;
	For Local name$ = EachIn nameList
		if (id = nameList.Count-1)
			fileName:+name.ToLower();
		Else
			fileName:+name.ToLower()+"-";
		EndIf
		id:+1;
	Next

	if (FileType(fileName) > 0) DeleteDir(fileName, 1);

	local newFolder% = CreateDir(fileName);
	GenerateMainFile(fileName, inputName, withStyles, withHooks, withSlice, isMemoised, withProps, hookTypeName, stateTypeName);
	GenerateStylesFile(fileName, withStyles);
	GenerateHooksFile(fileName, inputName, withHooks, hookTypeName);
	GenerateHelpersFile(fileName, withHelpers);
	GenerateSliceFile(fileName, inputName, withSlice, stateTypeName);
	' fileName
	return Notify( "Completed "+fileName+".tsx", false );
EndFunction

Function GetNewFileName$(name$)
	return"./"+name+"/"+name
EndFunction

Function GenerateMainFile%(name$, inputName$, withStyles@, withHooks@, withSlice@, isMemoised@, withProps@, hookTypeName$, stateTypeName$)
	local mainFileSuc% = CreateFile(GetNewFileName(name)+".tsx");
	local typesFileSuc% = CreateFile(GetNewFileName(name)+".types.ts");
	local propsName$ ="";
	if (withProps) propsName = "T"+inputName+"Props";

	if (mainFileSuc = 0 or typesFileSuc = 0) return Notify( "Create main file error: "+name, true );

	local mainFile: TStream = WriteFile(GetNewFileName(name)+".tsx");

	'import
	if (isMemoised)
		WriteLine( mainFile, "import React, { FC, memo } from 'react';" );
	Else
		WriteLine( mainFile, "import React, { FC } from 'react';" );
	EndIf
	if (withProps) WriteLine( mainFile, "import { "+propsName+" } from './"+name+".types';" );
	if (withStyles) WriteLine( mainFile, "// import styles from './"+name+".styles.scss';" );
	WriteLine( mainFile, "" );

	'component
	if (isMemoised)
		WriteLine( mainFile, "export const "+inputName+": "+GetFC(withProps, propsName)+" = memo(() => {" );
	Else
		WriteLine( mainFile, "export const "+inputName+": "+GetFC(withProps, propsName)+" = () => {" );
	EndIf
	WriteLine( mainFile, "" );
	WriteLine( mainFile, "	return (<></>);" );

	if (isMemoised)
		WriteLine( mainFile, "});" );
		WriteLine( mainFile, "" );
		WriteLine( mainFile, inputName+".displayName = '"+inputName+"';" );
	Else
		WriteLine( mainFile, "};" );
	EndIf
	WriteLine( mainFile, "" );
	CloseStream( mainFile );

	local typesFile: TStream = WriteFile(GetNewFileName(name)+".types.ts");
	if (withProps)
		WriteLine( typesFile, "export type "+propsName+" = {" );
		WriteLine( typesFile, "	isSomething: boolean;" );
		WriteLine( typesFile, "}" );
		WriteLine( typesFile, "" );
	EndIf
	if (withHooks)
		WriteLine( typesFile, "export type "+hookTypeName+" = () => any;" );
		WriteLine( typesFile, "" );
	EndIf
	if (withSlice)
		WriteLine( typesFile, "export type "+stateTypeName+" = {" );
		WriteLine( typesFile, "	isSomething: boolean;" );
		WriteLine( typesFile, "}" );
		WriteLine( typesFile, "" );
	EndIf
	CloseStream( typesFile );
EndFunction

Function GetFC$(withProps@, propsName$)
	if (withProps) return "FC<"+propsName+">";
	return "FC";
EndFunction

Function GenerateStylesFile%(name$, withStyles@)
	if (withStyles = 0) return 0;
	local stylesFileSuc% = CreateFile(GetNewFileName(name)+".styles.scss");

	if (stylesFileSuc = 0) return Notify( "Create styles file error: "+name+".styles.scss", true );
EndFunction

Function GenerateHooksFile%(name$, inputName$, withHooks@, hookTypeName$)
	if (withHooks = 0) return 0;
	local hooksFileSuc% = CreateFile(GetNewFileName(name)+".hooks.ts");

	if (hooksFileSuc = 0) return Notify( "Create hooks file error: "+name+".hooks.ts", true );

	local mainFile: TStream = WriteFile(GetNewFileName(name)+".hooks.ts");

	WriteLine( mainFile, "import { "+hookTypeName+" } from './"+name+".types';" );
	WriteLine( mainFile, "" );
	WriteLine( mainFile, "export const use"+inputName+"Hook: "+hookTypeName+" = () => {" );
	WriteLine( mainFile, "	return {};" );
	WriteLine( mainFile, "};" );
	WriteLine( mainFile, "" );
	CloseStream( mainFile );
EndFunction

Function GenerateHelpersFile%(name$, withHelpers@)
	if (withHelpers = 0) return 0;
	local helpersFileSuc% = CreateFile(GetNewFileName(name)+".helpers.ts");

	if (helpersFileSuc = 0) return Notify( "Create helpers file error: "+name+".helpers.ts", true );

	local typesFile: TStream = WriteFile(GetNewFileName(name)+".helpers.ts");
		WriteLine( typesFile, "export const testConst: any = {" );
		WriteLine( typesFile, "	isSomething: true," );
		WriteLine( typesFile, "}" );
		WriteLine( typesFile, "" );
	CloseStream( typesFile );
EndFunction

Function GenerateSliceFile%(name$, inputName$, withSlice@, stateTypeName$)
	if (withSlice = 0) return 0;
	local sliceFileSuc% = CreateFile(GetNewFileName(name)+".slice.ts");

	if (sliceFileSuc = 0) return Notify( "Create slice file error: "+name+".slice.ts", true );

	local mainFile: TStream = WriteFile(GetNewFileName(name)+".slice.ts");
	local sliceName$ = inputName+"Slice";

	WriteLine( mainFile, "import { createSlice } from '@reduxjs/toolkit';" );
	WriteLine( mainFile, "import { "+stateTypeName+" } from './"+name+".types';" );
	WriteLine( mainFile, "" );
	WriteLine( mainFile, "const initialState: "+stateTypeName+" = {" );
	WriteLine( mainFile, "	isSomething: false," );
	WriteLine( mainFile, "};" );
	WriteLine( mainFile, "" );

	WriteLine( mainFile, "export const "+sliceName+" = createSlice({" );
	WriteLine( mainFile, "	name: '"+inputName+"'," );
	WriteLine( mainFile, "	initialState," );
	WriteLine( mainFile, "	reducers: {" );
	WriteLine( mainFile, "		setInitialState: () => initialState," );
	WriteLine( mainFile, "	}," );
	WriteLine( mainFile, "});" );
	WriteLine( mainFile, "" );

	WriteLine( mainFile, "export const { setInitialState } = "+sliceName+".actions;" );
	
	CloseStream( mainFile );
EndFunction