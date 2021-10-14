%%MATLAB VERSION r2013a was used%%
%%A GUI PUSH BUTTON FROM MATLAB WAS IMPLEMENTED%%
function varargout = PC_MATLAB_guptasr(varargin)
% PUSH_BUTTON MATLAB code for push_button.fig
%      PUSH_BUTTON, by itself, creates a new PUSH_BUTTON or raises the existing
%      singleton*.
%
%      H = PUSH_BUTTON returns the handle to a new PUSH_BUTTON or the handle to
%      the existing singleton*.
%
%      PUSH_BUTTON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PUSH_BUTTON.M with the given input arguments.
%
%      PUSH_BUTTON('Property','Value',...) creates a new PUSH_BUTTON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before push_button_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to push_button_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help push_button

% Last Modified by GUIDE v2.5 05-Apr-2016 19:05:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @push_button_OpeningFcn, ...
                   'gui_OutputFcn',  @push_button_OutputFcn, ...
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


% --- Executes just before push_button is made visible.
function push_button_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to push_button (see VARARGIN)

% Choose default command line output for push_button
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes push_button wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = push_button_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(instrfindall);% erase and close any ports
s = serial('COM4');% COM4 Selected
s.BaudRate = 9600;%Baud Rate Initialized 
s.Terminator = 'CR' %CR is used as terminator
fopen(s);%open com port

%Initialization of Variables
VFS = 5; %full scale voltage
bits = 10;
voltage = 0;
res= VFS/(2^bits);
i = 0;
t=0; v=5; tPrev=0;
plotHandle = line(nan, nan);
Samples=200;
totFreq=0;
avgFreq = 0;

%Plotting Configuration
title('Voltage Vs Time: Shubham Gupta 1416773')
xlabel('Time (s)') %x-axis 
ylabel('Voltage V') %y-axis
tic; %counter
while(i<Samples)
     voltage = str2double(fscanf(s))*res;
     time = toc; %current time
     v = [v voltage];
     t = [t time];
     if(mod(i,10)==0) %plotting after 10 samples to improve rate
     set(plotHandle, 'xData', t, 'yData', v);
     end
     pause(1e-16);
     freq=1/(time-tPrev); % calculation for frequency 
     totFreq= totFreq+ freq;
     tPrev=time;
     i=i+1;
end
toc; %measure total time
avgFreq= totFreq/i %average frequency
fclose(s)

    