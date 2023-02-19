Global MAIN_WINDOW: TGadget;
Global NAME_INPUT: TGadget;
Global IS_MEMOISED_CHECKBOX: TGadget;
Global WITH_PROPS_CHECKBOX: TGadget;
Global GEN_CONSTS_CHECKBOX: TGadget;
Global GEN_STYLES_CHECKBOX: TGadget;
Global GEN_HOOKS_CHECKBOX: TGadget;
Global GEN_HELPERS_CHECKBOX: TGadget;
Global GEN_SLICE_CHECKBOX: TGadget;
Global GENERATE_BUTTON: TGadget;

Const i_win_w% = 400, i_win_h% = 220;
Const btn_h% = 30, btn_xs_h% = 22, inp_h% = 20;
Const magrin_y% = 10;
Global rowHeight% = magrin_y + inp_h;
Global indputWidth% = 190;
Global rowWidth% = indputWidth+10;

Function BuildMainWindow()
	MAIN_WINDOW = createWindow("Component generator", 0, 30, 500, 350, Null,WINDOW_CENTER|WINDOW_TITLEBAR);
	SetGadgetSensitivity(MAIN_WINDOW, SENSITIZE_ALL);
    local panel:TGadget = CreatePanel(5, 5, GadgetWidth(MAIN_WINDOW)-15, GadgetHeight(MAIN_WINDOW)-45, MAIN_WINDOW, PANEL_GROUP, "Settings");

	NAME_INPUT = GenerateTextField(0, "Component name", panel);
	SetGadgetText( NAME_INPUT, "TestComponent" )
	IS_MEMOISED_CHECKBOX = GenerateCheckbox(1, "is memoised", panel);
	WITH_PROPS_CHECKBOX = GenerateCheckbox(2, "is with props", panel);
	GEN_CONSTS_CHECKBOX = GenerateCheckbox(3, "Generate .constants", panel, 1);
	GEN_STYLES_CHECKBOX = GenerateCheckbox(4, "Generate .scss", panel, 1);
	GEN_HOOKS_CHECKBOX = GenerateCheckbox(5, "Generate .hooks", panel);
	GEN_HELPERS_CHECKBOX = GenerateCheckbox(6, "Generate .helpers", panel);
	GEN_SLICE_CHECKBOX = GenerateCheckbox(7, "Generate .slice", panel);

	GENERATE_BUTTON = CreateButton( "Generate", 5, rowHeight * 8 + 5, rowWidth, inp_h, panel );
EndFunction

Function GenerateTextField: TGadget(id%, name$, parent: TGadget)
	local label:TGadget = CreateLabel(name, 5, rowHeight * id + 5, rowWidth, inp_h, parent);
    return CreateTextField(rowWidth + 5, rowHeight * id + 5, rowWidth, inp_h, parent);
EndFunction

Function GenerateCheckbox: TGadget(id%, name$, parent: TGadget, state@ = 0)
	local localButton: TGadget = CreateButton( name, 5, rowHeight * id + 5, rowWidth, inp_h, parent, BUTTON_CHECKBOX );
	SetButtonState( localButton, state );
	return localButton;
EndFunction