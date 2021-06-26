function varargout = SPK_WP(varargin)
% SPK_WP MATLAB code for SPK_WP.fig
%      SPK_WP, by itself, creates a new SPK_WP or raises the existing
%      singleton*.
%
%      H = SPK_WP returns the handle to a new SPK_WP or the handle to
%      the existing singleton*.
%
%      SPK_WP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPK_WP.M with the given input arguments.
%
%      SPK_WP('Property','Value',...) creates a new SPK_WP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SPK_WP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SPK_WP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SPK_WP

% Last Modified by GUIDE v2.5 26-Jun-2021 02:47:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SPK_WP_OpeningFcn, ...
                   'gui_OutputFcn',  @SPK_WP_OutputFcn, ...
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


% --- Executes just before SPK_WP is made visible.
function SPK_WP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SPK_WP (see VARARGIN)

% Choose default command line output for SPK_WP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SPK_WP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SPK_WP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in tampil.
function tampil_Callback(hObject, eventdata, handles)
% hObject    handle to tampil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Memunculkan data pada GUI table1
range = 'C2:F51';
dataAlternatif=xlsread('Real estate valuation data set.xlsx', range);
set(handles.table1,'Data',dataAlternatif);




% --- Executes on button press in proses.
function proses_Callback(hObject, eventdata, handles)
% hObject    handle to proses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%Import Data Alternatif
range =  'C2:F51';
dataAlternatif=xlsread('Real estate valuation data set.xlsx', range);

%Tentuin Nilai atribut tiap-tiap Kriteria
k=[1,0,1,0]; %nilai 0= atribut cost kala nilai 1 = atribut benefit

w = [3,5,4,1];%bobot nilai

%Tahapan perbaikan bobot
[m n]=size(dataAlternatif);
w=w./sum(w);

%Tahapan perhitungan vektor(S) per baris (alternatif)
for j=1:n,
    if k(j)==0,
        w(j)=-1*w(j);
    end;
end;
for i=1:m,
    S(i)=prod(dataAlternatif(i,:).^w);
end;

%Perangkingan
dataResult= S/sum(S);
sorting=sort(dataResult,'descend'); %sorting data secara descend
maxScore = max(dataResult); %Memanggil data dengan max
xlswrite('sorting.xlsx', sorting);
set(handles.display1,'String',maxScore); %menampilkan maxScore ke GUI static text

%Tampilan Sorting GUI
dataSorting = xlsread('sorting.xlsx'); %membaca data yang telah di sorting
set(handles.table2,'Data',dataSorting); %menampilkan data sorting ke GUI table2
