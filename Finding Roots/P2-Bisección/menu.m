function varargout = menu(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @menu_OpeningFcn, ...
                       'gui_OutputFcn',  @menu_OutputFcn, ...
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

function menu_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);

function varargout = menu_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;


function function__CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function function__Callback(hObject, eventdata, handles)

function changePoints(handles)
    temp = get(handles.P1, 'String');
    set(handles.P1, 'String', get(handles.P2, 'String'));
    set(handles.P2, 'String', temp);

function Calculate_Callback(hObject, eventdata, handles)
    
    message = get(handles.function_, 'String');
    message = strrep(message, '^', '.^');
    for i = 0:9
        expression = strcat(num2str(i),'x');
        message = regexprep(message, expression, strcat(num2str(i), '*x'));
    end
    
    error_allowed = get(handles.error_allowed, 'String');
    
    if isnan(str2double(error_allowed))
      set(handles.error_allowed, 'String','0.1');
      warndlg('allowed error must be numerical');
      return;
    else
        error_allowed = abs(str2double(error_allowed));
        set(handles.error_allowed, 'String', num2str(error_allowed));
    end
    
    P1 = get(handles.P1, 'String');
    if isnan(str2double(P1))
      set(handles.P1, 'String','0');
      warndlg('P1 must be numerical');
      return;
    else
        P1 = str2double(P1);
    end
    
    set(handles.counter, 'String', sprintf('%s %d', 'Min iterations: ', ceil(log2(1/error_allowed))) );
    
    P2 = get(handles.P2, 'String');
    
    if isnan(str2double(P2))
      set(handles.P2, 'String','1');
      warndlg('P2 must be numerical');
      return;
    else
        P2 = str2double(P2);
    end
    
    if P1 > P2
        changePoints(handles);
        temp = P2;
        P2 = P1;
        P1 = temp;
    end
    
    fh = str2func(['@(x)' message]);
    
    
    
    axes(handles.plot_axes);
    xlim([P1-1 P2+1]);
    ylim auto;
    grid on;cla;hold on;
    x = P1:0.02:P2;
    plot(x,fh(x));
    
    g = diff(sym(fh));
    if (fh(P1) * fh(P2) > 0 ) && (subs(g, P1) * subs(g, P2) > 0)
        warndlg('Please check your guessed interval. It must have zero, two or more intersections with x axis');
        return;
    end
    
    set(handles.table_1, 'data', {});
    
    x = (P1 + P2)/2;
    if fh(x) == 0
        set(handles.table_1, 'data', {P1, P2, x, fh(x)});
        return
    elseif fh(P1) == 0
        set(handles.table_1, 'data', {P1, P2, P1, fh(P1)});
        return
    elseif fh(P2) == 0
        set(handles.table_1, 'data', {P1, P2, P2, fh(P2)});
        return
    end
        
    while true
        if fh(x) == 0
            break;
        end
        
        %new_data = {sprintf('%f', P1), sprintf('%f', P2), sprintf('%f', x), sprintf('%f', fh(x))};
        new_data = {P1, P2, x, fh(x)};
        
        if  (subs(g, P1) * subs(g, x) > 0) && (fh(P1) * fh(P2) > 0)
            P1 = x;
        elseif (subs(g, P2) * subs(g, x) > 0) && (fh(P1) * fh(P2) > 0)
            P2 = x;
        elseif fh(P1) * fh(x) > 0
            P1 = x;
        else
            P2 = x;
        end
        
        plot(x,fh(x),'or');
        data = get(handles.table_1, 'data');
        data(end + 1, : ) = new_data;
        set(handles.table_1, 'data', data)
        %pause(1);
        
        if (abs(fh(x)) < error_allowed) && abs( (x - cell2mat(data(end - 1, 3)) ) / x) < error_allowed
            break
        end
        
        x = (P1 + P2)/2;
        
    end

function Calculate_KeyPressFcn(hObject, eventdata, handles)

function P1_Callback(hObject, eventdata, handles)

function P1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function P2_Callback(hObject, eventdata, handles)

function P2_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function P1_KeyPressFcn(hObject, eventdata, handles)

function error_allowed_Callback(hObject, eventdata, handles)

function error_allowed_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end