function varargout = SPK_SAW(varargin)
% SPK_SAW MATLAB code for SPK_SAW.fig
%      SPK_SAW, by itself, creates a new SPK_SAW or raises the existing
%      singleton*.
%
%      H = SPK_SAW returns the handle to a new SPK_SAW or the handle to
%      the existing singleton*.
%
%      SPK_SAW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPK_SAW.M with the given input arguments.
%
%      SPK_SAW('Property','Value',...) creates a new SPK_SAW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SPK_SAW_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SPK_SAW_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SPK_SAW

% Last Modified by GUIDE v2.5 26-Jun-2021 10:21:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SPK_SAW_OpeningFcn, ...
                   'gui_OutputFcn',  @SPK_SAW_OutputFcn, ...
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


% --- Executes just before SPK_SAW is made visible.
function SPK_SAW_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SPK_SAW (see VARARGIN)

% Choose default command line output for SPK_SAW
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SPK_SAW wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SPK_SAW_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in tampil.
function tampil_Callback(hObject, eventdata, handles)
% hObject    handle to tampil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Menampilkan data dari xlsx A2-21 dan C2-21 s/d H2-21
data1 = xlsread('DATA RUMAH.xlsx','A2:A21');
data2 = xlsread('DATA RUMAH.xlsx','C2:H21');
dataKombin = [data1 data2];%menggabung data1 dan data2
set(handles.table1,'Data',dataKombin);%menampilkan data kombin pada table1


% --- Executes on button press in proses.
function proses_Callback(hObject, eventdata, handles)
% hObject    handle to proses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%nilai atribut, dimana 0= atribut biaya &1= atribut keuntungan

%Membaca nilai kriteria dari data Alternatif tabel C2-21 s/d H2-21
dataAlternatif = xlsread('DATA RUMAH.xlsx','C2:H21');

k=[0,1,1,1,1,1]; %memberi nilai atribut, 0= atribut cost dan 1= atribut benefit
w=[0.30, 0.20, 0.23, 0.10, 0.07, 0.10];% bobot masing-masing kriteria

%tahapan normalisasi matriks
[m,n]=size (dataAlternatif); %matriks m x n dengan ukuran sebanyak variabel data (input)
%input=dataAlternatif
R=zeros (m,n); %buat matriks R yaitu matriks kosong

for j=1:n
    if k(j)==1 %statement untuk kriteria dengan atribut keuntungan
        R(:,j)=dataAlternatif(:,j)./max(dataAlternatif(:,j));
    else
        R(:,j)=min(dataAlternatif(:,j))./dataAlternatif(:,j); %statement untuk kriteria biaya
    end
end

%proses penjumlahan dari perkalian dengan bobot sesuai dengan kriteria
for i=1:m
    V(i)= sum(w.*R(i,:));
end

sorting = sort(V,'descend');%perangkingan, mengurutkan secara descend

%memilih 20 terbaik, yaitu 20 rumah terbaik secara urut
for i=1:20
result(i) = sorting(i);
end

opts2 = detectImportOptions('DATA RUMAH.xlsx'); %mendapatkan file xlsx
opts2.SelectedVariableNames = [2]; %memilih kolom dengan index 2 yaitu kolom nama rumah

rumahTerbaik = readmatrix('DATA RUMAH.xlsx',opts2); %merupakan var sebagai nilai kolom nama rumah pada xls

%mencari nama rumah dengan 20 nilai terbaik
for i=1:20
 for j=1:m
   if(result(i) == V(j))
    namaRumah(i) = rumahTerbaik(j);
    break
   end
 end
end

perangkingan = namaRumah';%menampilkan perbaris dengan cara transpose matrix

set(handles.table2,'Data',perangkingan);%menampilkan data perangkingan pada tabel2
