function varargout = Data_plotter(varargin)
% DATA_PLOTTER MATLAB code for Data_plotter.fig
%      DATA_PLOTTER, by itself, creates a new DATA_PLOTTER or raises the existing
%      singleton*.
%
%      H = DATA_PLOTTER returns the handle to a new DATA_PLOTTER or the handle to
%      the existing singleton*.
%
%      DATA_PLOTTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_PLOTTER.M with the given input arguments.
%
%      DATA_PLOTTER('Property','Value',...) creates a new DATA_PLOTTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Data_plotter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Data_plotter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Data_plotter

% Last Modified by GUIDE v2.5 12-Jun-2013 23:54:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Data_plotter_OpeningFcn, ...
    'gui_OutputFcn',  @Data_plotter_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before Data_plotter is made visible.
function Data_plotter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Data_plotter (see VARARGIN)

% Choose default command line output for Data_plotter
handles.output = hObject;
handles.dir = varargin{1}.dir;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Data_plotter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Data_plotter_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;



function Fs_Callback(hObject, eventdata, handles)
global Fsp
Fsp = str2double(get(hObject,'String'));
return
function Fs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function chan2plot_Callback(hObject, eventdata, handles)
global strp
strp = get(hObject,'String');
return
function chan2plot_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function plot_Callback(hObject, eventdata, handles)
global strp;global Fsp;global row_on; global Collumns_on;
global x_ax; global y_ax; global axx;
x_ax = get(handles.x_ax,'String');
y_ax = get(handles.y_ax,'String');
strp = get(handles.chan2plot,'String');
Fsp = str2double(get(handles.Fs,'String'));
onset = str2num(get(handles.onset, 'String'));
if isempty(onset)
    onset = 0;
end
if (get(handles.row_on,'Value') == get(handles.row_on,'Max'))
    row_on = 1;
else
    row_on = 0;
end
if (get(handles.Collumns_on,'Value') == get(handles.Collumns_on,'Max'))
    Collumns_on = 1;
else
    Collumns_on = 0;
end

if isempty(strp)
    errordlg('Select rows/columns to plot')
else
    [a b c] = size(handles.data);
    ka = [eval(strp)];
    h = figure;
    for A = 1:length(strp)
        if Collumns_on == 1
            time = ((1:a)./Fsp)-onset;
            plot(time,handles.data(:,ka).*10^6);hold on %plot signal in microvolts
        elseif row_on == 1
            plot((1:b)./Fsp,handles.data(ka,:).*10^6);hold on %plot signal in microvolts
        else
            errordlg('select if rows or collums should be plotted','Please select');
            A = length(strp)+1;
        end
    end
    
    % Jonas edit: this way axes can be set individually.
    xlimit = get(gca, 'xlim');  %Get x range
    ylimit = get(gca, 'ylim');
    if ~isempty(x_ax)
        xlim(str2num(x_ax));
    else
        xlim([min(time) max(time)])
    end
    if ~isempty(y_ax)
        ylim((str2num(y_ax))); % set Ylim in uVolts
    end
    xlimit = get(gca, 'xlim');  %Get x range
    ylimit = get(gca, 'ylim');
    % if isempty(x_ax)==0
    %     axis(axx)
    % end
    % Jonas edit
    hold on
    plot([xlimit(1) xlimit(2)],[0 0],'k')
    % onset = str2num(get(handles.onset, 'String'));
    plot([0 0], [ylimit(1) ylimit(2)], 'k')
    labels = {'channel 1','channel 2','channel 3','channel 4','channel 5',...
        'channel 6','channel 7','channel 8','DIO 1','DIO 2','DIO 3','DIO 4','DIO 5','DIO 6'};
    labeling = labels(ka);
    legend(labeling,'Location','NorthEastOutside');
    hold off
    title(handles.filename,'Interpreter','none')
    xlabel('Time (s)')
    ylabel('EEG Amplitude (microvolts)')
end
% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
[handles.filename, handles.data] = EEGLoadData(handles);
if any(handles.filename)
    set(handles.l_data,'string',handles.filename);
    set(handles.l_size,'string',num2str(size(handles.data)));
end
  guidata(hObject,handles);
% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
web('Plotter_help.htm', '-helpbrowser')

function row_on_Callback(hObject, eventdata, handles)
global row_on
if (get(hObject,'Value') == get(hObject,'Max'))
    row_on =1;
else
    row_on =0;
end
function Collumns_on_Callback(hObject, eventdata, handles)
global Collumns_on
if (get(hObject,'Value') == get(hObject,'Max'))
    Collumns_on =1;
else
    Collumns_on =0;
end
function x_ax_Callback(hObject, eventdata, handles)
global x_ax
x_ax = str2double(get(hObject,'String')); return

function x_ax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function y_ax_Callback(hObject, eventdata, handles)
global y_ax
y_ax = str2double(get(hObject,'String'));return
function y_ax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function onset_Callback(hObject, eventdata, handles)
% hObject    handle to onset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of onset as text
%        str2double(get(hObject,'String')) returns contents of onset as a double

function onset_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
