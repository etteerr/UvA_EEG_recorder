function varargout = temp_browse(varargin)
% TEMP_BROWSE MATLAB code for temp_browse.fig
%      TEMP_BROWSE, by itself, creates a new TEMP_BROWSE or raises the existing
%      singleton*.
%
%      H = TEMP_BROWSE returns the handle to a new TEMP_BROWSE or the handle to
%      the existing singleton*.
%
%      TEMP_BROWSE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEMP_BROWSE.M with the given input arguments.
%
%      TEMP_BROWSE('Property','Value',...) creates a new TEMP_BROWSE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before temp_browse_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to temp_browse_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help temp_browse

% Last Modified by GUIDE v2.5 11-Jun-2013 12:24:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @temp_browse_OpeningFcn, ...
                   'gui_OutputFcn',  @temp_browse_OutputFcn, ...
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


% --- Executes just before temp_browse is made visible.
function temp_browse_OpeningFcn(hObject, ~, handles, varargin)
curdir = cd;
addpath([curdir filesep 'data']);
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to temp_browse (see VARARGIN)

% Choose default command line output for temp_browse
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes temp_browse wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = temp_browse_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function channelnr_Callback(hObject, eventdata, handles)
% hObject    handle to channelnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channelnr as text
%        str2double(get(hObject,'String')) returns contents of channelnr as a double


% --- Executes during object creation, after setting all properties.
function channelnr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function onset_Callback(hObject, eventdata, handles)
% hObject    handle to onset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of onset as text
%        str2double(get(hObject,'String')) returns contents of onset as a double


% --- Executes during object creation, after setting all properties.
function onset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to onset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
global channelnr;
global onset;
global browse_raw;
global browse_corrected;
global erp_data;
if size(erp_data,3) <= 1
    errordlg('Data must be 3D!')
else
    browse_raw = get(handles.raw, 'Value');
    browse_corrected = get(handles.corrected, 'Value');
    % global data1
    onset = str2num(get(handles.onset, 'String'));
    channelnr = str2num(get(handles.channelnr, 'String'));
    trial_browser;
end
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filenamep;
global erp_data;
curdir = cd;
cd([curdir filesep 'data']);
[filenamep, ~] = ...
    uigetfile({'*.mat';},'Select a 2D array');
cd(curdir);
if any(filenamep)
    load(filenamep);
    erp_data = data;
    set(handles.filename, 'string', filenamep);
    set(handles.filesize, 'String', num2str(size(data)));
end
clear data


% --- Executes on button press in baseline_correction.
function baseline_correction_Callback(hObject, eventdata, handles)
% hObject    handle to baseline_correction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global erp_data;
global onset;
global corrected_data;
onset = str2num(get(handles.onset, 'String'));
plot_figures = get(handles.plot_figures, 'Value');
if onset > 0
    baseline = squeeze(mean(erp_data(1:onset,:,:)));
else
    baseline = zeros(size(erp_data,2),size(erp_data,3));
end
corrected_data = zeros(size(erp_data));
if size(erp_data,2)<9
    baselinechannels = size(erp_data,2);
elseif size(erp_data,2)>8
    baselinechannels = 8;
end
baselinetrials = size(erp_data,3);
for ichan = 1:baselinechannels
    for itrial = 1:baselinetrials
        corrected_data(:,ichan,itrial) = erp_data(:,ichan,itrial)-baseline(ichan,itrial);
    end
    if plot_figures
        nrofsamples = size(erp_data,1);
        samples = 1:nrofsamples;
        samples = samples-onset;
        samplingrate = 256;
        time = samples/samplingrate*1000;
        raw_erp = mean(erp_data(:,ichan,:),3);
        base_erp = mean(corrected_data(:,ichan,:),3);
        figure; subplot(5,1,1:2);        
        for itrial = 1:baselinetrials
            plot(time, erp_data(:,ichan,itrial),'b'); hold on;
        end
        plot(time, raw_erp, 'r');
%         ylimit = get(gca,'ylim');  %Get x range 
        xlabel('time (ms)')
        ylabel('potential (V)')
        title('before')
        
        subplot(5,1,3);
        set(gca,'Visible','off') 
        text(0,.5,'blue = single trials, red = average')
        
        subplot(5,1,4:5); 
        for itrial = 1:baselinetrials
            plot(time, corrected_data(:,ichan,itrial),'b'); hold on;
        end
        plot(time, base_erp, 'r');
%         ylim(ylimit)
        xlabel('time (ms)')
        ylabel('potential (V)')
        title('after')
        suptitle(['channel ' num2str(ichan)])
    end
end

% erp_data = corrected_data;


% --- Executes on button press in plot_figures.
function plot_figures_Callback(hObject, eventdata, handles)
% hObject    handle to plot_figures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of plot_figures
% hObject    handle to browse_corrected_trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in erp_assesment.
function erp_assesment_Callback(hObject, eventdata, handles)
% hObject    handle to erp_assesment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global channelnr;
global onset;
global erp_data;
onset = str2num(get(handles.onset, 'String'));
channelnr = str2num(get(handles.channelnr, 'String'));
if length(channelnr)>1
    errordlg('Data must be 2D! (select 1 channel at the time)')
else

    ERP_assesment;
end


% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)

global corrected_data;
data = corrected_data;
curdir = cd;
cd([curdir filesep 'data']);
uisave({'data'},'Name');
cd(curdir);
clear data;
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
