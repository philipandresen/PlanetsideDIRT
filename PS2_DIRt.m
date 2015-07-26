function varargout = PS2_DIRt(varargin)
% PLANETSIDE_BULLETDISTRO MATLAB code for planetside_bulletdistro.fig

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @planetside_bulletdistro_OpeningFcn, ...
                   'gui_OutputFcn',  @planetside_bulletdistro_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
gui_mainfcn(gui_State, varargin{:});
end
function planetside_bulletdistro_OpeningFcn(hObject, eventdata, handles, varargin)
global DATA_numeric DATA_text DATA_raw X_offset Y_offset BDROP
global STANCE AIM MOTION RANGE FIRE_PATTERN RECOMP CHART_type CUSTOM_pattern
X_offset=0;
Y_offset=0;
BDROP=0;
STANCE=get(handles.stance_popup,'Value');
AIM=get(handles.aimstyle_popup,'Value');
MOTION=get(handles.motion_popup,'Value');
RECOMP=get(handles.recoilcomp_checkbox,'Value');
RANGE=str2double(get(handles.range_editbox,'String'));
CHART_type=get(handles.charttype_popup,'Value');
FIRE_PATTERN=1;
CUSTOM_pattern=[1 1 1 1 1 0 0 0 1 0 0 0];
warning('off','MATLAB:xlsread:Mode');
[DATA_numeric DATA_text DATA_raw]=xlsread('Raw_data.xls','Sheet1','','basic');
warning('on','MATLAB:xlsread:Mode');
set(handles.main_axes,'XTickLabel','')
set(handles.main_axes,'YTickLabel','')
handles.output = hObject;
guidata(hObject, handles);
apply_filters_now(handles)
set(handles.infotext,'String',['This Planetside 2 Utility was written by Philip Andresen and is distributed for private use only. Use of this software for profit or for commercial gains is strictly prohibited without concent from the author. Please read the terms of service agreement by clicking on the ''?'' button to the right before using this program.'])



function varargout = planetside_bulletdistro_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
function bullestdistribution_popup_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%Createfcns---------------------------------------------------------------
function faction_popup_CreateFcn(hObject, eventdata, handles)
global FILTER_faction
FILTER_faction='none';
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function weaponclass_popup_CreateFcn(hObject, eventdata, handles)
global FILTER_type
FILTER_type='none';
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function weaponname_popup_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function charttype_popup_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function timeslider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function range_editbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function stance_popup_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function aimstyle_popup_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function motion_popup_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function xoff_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function yoff_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%Actual functions---------------------------------------------------------
function range_editbox_Callback(hObject, eventdata, handles) %#ok<*INUSD>
global RANGE
val=str2double(get(hObject,'String'));
if isnan(val); val=30; end;
if val<1; val=1; end;
if val>1000; val=1000; end;
RANGE=val;
set(hObject,'String',num2str(val))

function generate_button_Callback(hObject, eventdata, handles) %#ok<*INUSL>
global DATA_text DATA_raw STANCE AIM MOTION RANGE FIRE_PATTERN WEAPON_name 
global RECOMP CHART_type
[r_find c_find]=find(ismember(DATA_text,WEAPON_name));
rawdata_spec=DATA_raw(r_find,:);
[ttce ttk total_damage damage_dealt...
    range_list total_area total_damage_list...
    ttk_total]=bulletspray_generator(FIRE_PATTERN,rawdata_spec,STANCE,AIM,MOTION,RANGE,RECOMP,handles.main_axes,CHART_type,'Output_data'); %#ok<*ASGLU>
set(handles.main_axes,'XTickLabel','')
set(handles.main_axes,'YTickLabel','')
set(handles.ttk_text,'String',[num2str(ttk) ' s'])
set(handles.ttce_text,'String',[num2str(ttce) ' s'])
set(handles.shrl_text,'String',[num2str(rawdata_spec{9}) ' s'])
set(handles.lnrl_text,'String',[num2str(rawdata_spec{10}) ' s'])
set(handles.adsmove_text,'String',[num2str(rawdata_spec{20}) ' x'])
set(handles.damage_text,'String',[num2str(round(total_damage)) ' dmg'])

function timeslider_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
global TIME
TIME=get(hObject,'Value');

function charttype_popup_Callback(hObject, eventdata, handles)
global CHART_type
CHART_type=get(hObject,'Value');

function weaponname_popup_Callback(hObject, eventdata, handles)
global WEAPON_name
apply_filters_now(handles);
str=get(hObject,'String');
WEAPON_name=str(get(hObject,'Value'));

function bullestdistribution_popup_Callback(hObject, eventdata, handles)

function recoilcomp_checkbox_Callback(hObject, eventdata, handles)
global RECOMP
RECOMP=get(hObject,'Value');

function faction_popup_Callback(hObject, eventdata, handles)
global FILTER_faction
text=get(hObject,'String');
selection=text(get(hObject,'Value'));
FILTER_faction=selection;
apply_filters_now(handles);

function weaponclass_popup_Callback(hObject, eventdata, handles)
global FILTER_type
text=get(hObject,'String');
selection=text(get(hObject,'Value'));
FILTER_type=selection;
apply_filters_now(handles);

function apply_filters_now(handles)
global DATA_numeric DATA_text DATA_raw FILTER_faction FILTER_type WEAPON_name %#ok<*NUSED>
currentstringset=get(handles.weaponname_popup,'String');
currentsel=currentstringset(get(handles.weaponname_popup,'Value'));
r_type=[1:size(DATA_raw,1)]; %#ok<NBRAK> %defaults for 'none'
r_fact=[1:size(DATA_raw,1)]; %#ok<NBRAK>
if ~strcmp(FILTER_faction,'none')
    [r_fact c_fact]=find(ismember(DATA_text,FILTER_faction));
end;
if ~strcmp(FILTER_type,'none')
    [r_type c_type]=find(ismember(DATA_text,FILTER_type));
end;
filtered=DATA_raw(intersect(r_fact,r_type),:);
set(handles.weaponname_popup,'String',filtered(:,1))
if sum(find(ismember(filtered(:,1),currentsel)))>0;
    set(handles.weaponname_popup,'Value',find(ismember(filtered(:,1),currentsel)));
else
    set(handles.weaponname_popup,'Value',1);
end;
str=get(handles.weaponname_popup,'String');
WEAPON_name=str(get(handles.weaponname_popup,'Value'));


function stance_popup_Callback(hObject, eventdata, handles)
global STANCE
STANCE=get(hObject,'Value');

function aimstyle_popup_Callback(hObject, eventdata, handles)
global AIM
AIM=get(hObject,'Value');

function motion_popup_Callback(hObject, eventdata, handles)
global MOTION
MOTION=get(hObject,'Value');


% --- Executes when selected object is changed in Bulletgroup_panel.
function Bulletgroup_panel_SelectionChangeFcn(hObject, eventdata, handles)
global FIRE_PATTERN CUSTOM_pattern
% hObject    handle to the selected object in Bulletgroup_panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag')
    case 'fullauto_radio'
        FIRE_PATTERN=1;
        set(handles.custompattern_text,'Enable','off')
    case 'semiauto_radio'
        set(handles.custompattern_text,'Enable','off')
        FIRE_PATTERN=2;
    case 'burst_radio'
        FIRE_PATTERN=3;
        set(handles.custompattern_text,'Enable','off')
    case 'custompattern_radio'
        FIRE_PATTERN=4;
        set(handles.custompattern_text,'Enable','on')
        CUSTOM_pattern=eval(get(handles.custompattern_text,'String'));
end;


function xoff_edit_Callback(hObject, eventdata, handles)
global X_offset
X_offset=str2double(get(hObject,'String'));

function yoff_edit_Callback(hObject, eventdata, handles)
global Y_offset
Y_offset=str2double(get(hObject,'String'));

function custompattern_text_Callback(hObject, eventdata, handles)
global CUSTOM_pattern
CUSTOM_pattern=eval(get(handles.custompattern_text,'String'));

function custompattern_text_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
set(gcf,'units','pixels');
G=get(gcf,'Position');
ui7=get(handles.uipanel7,'Position');
bgp=get(handles.Bulletgroup_panel,'Position');
ui6=get(handles.uipanel6,'Position');
ui5=get(handles.uipanel5,'Position');
ui2=get(handles.uipanel2,'Position');
ui1=get(handles.uipanel1,'Position');

ghd=G(4)-ui7(4);
ghw=G(3)-ui2(3);
set(handles.uipanel1,'Position',[0 ui7(4) G(3)-ui2(3) ghd])
set(handles.uipanel7,'Position',[0 0 G(3) ui7(4)])
set(handles.uipanel2,'Position',[ghw G(4)-ui2(4) ui2(3) ui2(4)])
set(handles.uipanel6,'Position',[ghw G(4)-ui2(4)-ui6(4) ui6(3) ui6(4)])
set(handles.uipanel5,'Position',[ghw G(4)-ui2(4)-ui6(4)-ui5(4) ui5(3) ui5(4)])
set(handles.Bulletgroup_panel,'Position',[G(3)-ui2(3) G(4)-ui2(4)-ui6(4)-ui5(4)-bgp(4) bgp(3) bgp(4)])

ui1=get(handles.uipanel1,'Position');
set(handles.main_axes,'Position',[0 60 ui1(3) ui1(4)-120])
fp=get(handles.faction_popup,'Position');
tp=get(handles.weaponclass_popup,'Position');
wp=get(handles.weaponname_popup,'Position');
set(handles.faction_popup,'Position', [30 ui1(4)-40 fp(3) fp(4)])
set(handles.weaponclass_popup,'Position', [fp(3)+35 ui1(4)-40 tp(3) tp(4)])
set(handles.weaponname_popup,'Position', [fp(3)+tp(3)+40 ui1(4)-40 wp(3) wp(4)])

function infobutton_Callback(hObject, eventdata, handles)
web('TERMS OF SERVICE AGREEMENT.html')


function noresize_ClickedCallback(hObject, eventdata, handles)

function bulletdropbox_Callback(hObject, eventdata, handles)
global BDROP
BDROP=get(hObject,'Value');
