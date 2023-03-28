%
% SMU_TAKE A GUI for performing nested-sweep experiements with the SMU.
%    SMU_TAKE(SMU) provides a GUI interface to the SMU source/measure unit 
%    for performing nested-sweep experiments with both chanels of the SMU 
%    as sources.  The chanel designated as the primary chanel is the one 
%    that is changed in the inner loop.  For each combination of source 
%    values specified, the values of one or both chanel measurements are 
%    recorded.  Both the source and measurement values become available in 
%    the workspace in the names specified by the user after the experiment 
%    is completed.  Names and values for both chanel sources must be specified, 
%    and a name for at least one chanel measurement must be specified.
function smu_take(smu)

smu_name = inputname(1);

% Test to see if another smutake window is running.  If so, bring it to the front and return.
fig_handles=get(0, 'children');
smutake_fig=findobj(fig_handles, 'Tag', [smu_name, '_take_fig']);
if length(smutake_fig)~=0,
    figure(smutake_fig);
    return;
end

set(0, 'units', 'pixels');
screen_rect=get(0, 'screensize');
screen_width=screen_rect(3); screen_height=screen_rect(4);
figure('Units', 'pixels',...
    'Position', [(screen_width/2-325), (screen_height/2-225), 650, 450],...
    'NumberTitle', 'off',...
    'Name', ['SMUtake (', smu_name,')'],...
    'Resize', 'off',...
    'Tag', [smu_name, '_take_fig']);

axes('Units', 'pixels',...
    'Position', [240, 160, 350, 260],...
    'Tag', [smu_name, '_takeplot']);

ch1panel = uipanel('Title', 'CH1 Settings',...
    'Units', 'pixels',...
    'FontSize', 8,...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10 230 170 210]);
uicontrol('Parent', ch1panel,...
    'Style', 'text',...
    'String', 'Function:',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [15, 170, 45, 15],...
    'HorizontalAlignment', 'right');
uicontrol('Parent', ch1panel,...
    'Style', 'popup',...
    'Position', [65, 175, 65, 15],...
    'BackgroundColor', 'white',...
    'FontName', 'Courier',...
    'String', 'SV/MI|SI/MV',...
    'Value', smu.get_function(1)+1,...
    'Tag', [smu_name, '_ch1function']);
ch1srcpanel = uipanel('Parent', ch1panel,...
    'Title', 'Source',...
    'Units', 'pixels',...
    'FontSize', 8,...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10 90 150 70]);
uicontrol('Parent', ch1srcpanel,...
    'Style', 'text',...
    'String', 'Name:',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10, 35, 40, 15],...
    'HorizontalAlignment', 'right');
uicontrol('Parent', ch1srcpanel,...
    'Style', 'edit',...
    'Position', [55, 35, 85, 18],...
    'HorizontalAlignment', 'left',...
    'FontName', 'Courier',...
    'Tag', [smu_name, '_ch1srcname']);
uicontrol('Parent', ch1srcpanel,...
    'Style', 'text',...
    'String', 'Values:',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10, 10, 40, 15],...
    'HorizontalAlignment', 'right');
uicontrol('Parent', ch1srcpanel,...
    'Style', 'edit',...
    'Position', [55, 10, 85, 18],...
    'HorizontalAlignment', 'left',...
    'FontName', 'Courier',...
    'Tag', [smu_name,'_ch1srcvalues']);
ch1measpanel = uipanel('Parent', ch1panel,...
    'Title', 'Measurement',...
    'Units', 'pixels',...
    'FontSize', 8,...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position',[10 10 150 70]);
uicontrol('Parent', ch1measpanel,...
    'Style', 'text',...
    'String', 'Name:',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10, 35, 40, 15],...
    'HorizontalAlignment', 'right');
uicontrol('Parent', ch1measpanel,...
    'Style', 'edit',...
    'Position', [55, 35, 85, 18],...
    'HorizontalAlignment', 'left',...
    'FontName', 'Courier',...
    'Tag', [smu_name, '_ch1measname']);
uicontrol('Parent', ch1measpanel,...
    'Style', 'text',...
    'String', 'Autorange:',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10, 10, 60, 15],...
    'HorizontalAlignment', 'right');
uicontrol('Parent', ch1measpanel,...
    'Style', 'checkbox',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [75, 11, 15, 15],...
    'Value', 1,...
    'Tag', [smu_name, '_ch1autorange']);
uicontrol('Parent', ch1measpanel,...
    'Style', 'text',...
    'String', 'Plot:',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [100, 10, 20, 15],...
    'HorizontalAlignment', 'right');
uicontrol('Parent', ch1measpanel,...
    'Style', 'checkbox',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [125, 11, 15, 15],...
    'Value', 1,...
    'Tag', [smu_name, '_ch1plot']);

ch2panel = uipanel('Title', 'CH2 Settings',...
    'Units', 'pixels',...
    'FontSize', 8,...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10 10 170 210]);
uicontrol('Parent', ch2panel,...
    'Style', 'text',...
    'String', 'Function:',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [15, 170, 45, 15],...
    'HorizontalAlignment', 'right');
uicontrol('Parent', ch2panel,...
    'Style', 'popup',...
    'Position', [65, 175, 65, 15],...
    'BackgroundColor', 'white',...
    'FontName', 'Courier',...
    'String', 'SV/MI|SI/MV',...
    'Value', smu.get_function(2)+1,...
    'Tag', [smu_name, '_ch2function']);
ch2srcpanel = uipanel('Parent', ch2panel,...
    'Title', 'Source',...
    'Units', 'pixels',...
    'FontSize', 8,...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10 90 150 70]);
uicontrol('Parent', ch2srcpanel,...
    'Style', 'text',...
    'String', 'Name:',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10, 35, 40, 15],...
    'HorizontalAlignment', 'right');
uicontrol('Parent', ch2srcpanel,...
    'Style', 'edit',...
    'Position', [55, 35, 85, 18],...
    'HorizontalAlignment', 'left',...
    'FontName', 'Courier',...
    'Tag', [smu_name, '_ch2srcname']);
uicontrol('Parent', ch2srcpanel,...
    'Style', 'text',...
    'String', 'Values:',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10, 10, 40, 15],...
    'HorizontalAlignment', 'right');
uicontrol('Parent', ch2srcpanel,...
    'Style', 'edit',...
    'Position', [55, 10, 85, 18],...
    'HorizontalAlignment', 'left',...
    'FontName', 'Courier',...
    'Tag', [smu_name, '_ch2srcvalues']);
ch2measpanel = uipanel('Parent', ch2panel,...
    'Title', 'Measurement',...
    'Units', 'pixels',...
    'FontSize', 8,...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10 10 150 70]);
uicontrol('Parent', ch2measpanel,...
    'Style', 'text',...
    'String', 'Name:',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10, 35, 40, 15],...
    'HorizontalAlignment', 'right');
uicontrol('Parent', ch2measpanel,...
    'Style', 'edit',...
    'Position', [55, 35, 85, 18],...
    'HorizontalAlignment', 'left',...
    'FontName', 'Courier',...
    'Tag', [smu_name, '_ch2measname']);
uicontrol('Parent', ch2measpanel,...
    'Style', 'text',...
    'String', 'Autorange:',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10, 10, 60, 15],...
    'HorizontalAlignment', 'right');
uicontrol('Parent', ch2measpanel,...
    'Style', 'checkbox',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [75, 11, 15, 15],...
    'Value', 1,...
    'Tag', [smu_name, '_ch2autorange']);
uicontrol('Parent', ch2measpanel,...
    'Style', 'text',...
    'String', 'Plot:',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [100, 10, 20, 15],...
    'HorizontalAlignment', 'right');
uicontrol('Parent', ch2measpanel,...
    'Style', 'checkbox',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [125, 11, 15, 15],...
    'Value', 1,...
    'Tag', [smu_name, '_ch2plot']);

measpanel = uipanel('Title', 'Measurement Settings',...
    'Units', 'pixels',...
    'FontSize', 8,...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [190 10 200 100]);
uicontrol('Parent', measpanel,...
    'Style', 'text',...
    'String', 'Primary Source:',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10, 60, 90, 15],...
    'HorizontalAlignment', 'right');
uicontrol('Parent', measpanel,...
    'Style', 'popup',...
    'Position', [105, 65, 50, 15],...
    'BackgroundColor', 'white',...
    'FontName', 'Courier',...
    'String', 'CH1|CH2',...
    'Tag', [smu_name, '_primsrc']);
uicontrol('Parent', measpanel,...
    'Style', 'text',...
    'String', 'Speed/Accuracy:',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10, 35, 90, 15],...
    'HorizontalAlignment', 'right');
uicontrol('Parent', measpanel,...
    'Style', 'popup',...
    'Position', [105, 40, 85, 15],...
    'BackgroundColor', 'white',...
    'FontName', 'Courier',...
    'String', 'accurate|medium|fast',...
    'Tag', [smu_name, '_accuracy']);
%uicontrol('Parent', measpanel,...
%    'Style', 'text',...
%    'String', 'Settling Control:',...
%    'BackgroundColor', [0.8, 0.8, 0.8],...
%    'Position', [10, 10, 90, 15],...
%    'HorizontalAlignment', 'right');
%uicontrol('Parent', measpanel,...
%    'Style', 'popup',...
%    'Position', [105, 15, 70, 15],...
%    'BackgroundColor', 'white',...
%    'FontName', 'Courier',...
%    'String', 'tight|medium|loose|off',...
%    'Tag', [smu_name, '_settling']);

axespanel = uipanel('Title', 'Axes Settings',...
    'Units', 'pixels',...
    'FontSize', 8,...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [400 10 165 100]);
uicontrol('Parent', axespanel,...
    'Style', 'text',...
    'String', 'X-Axis:',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10, 60, 70, 15],...
    'HorizontalAlignment', 'right');
uicontrol('Parent', axespanel,...
    'Style', 'popup',...
    'Position', [85, 65, 70, 15],...
    'BackgroundColor', 'white',...
    'FontName', 'Courier',...
    'String', 'linear|log',...
    'Tag', [smu_name, '_xaxis']);
uicontrol('Parent', axespanel,...
    'Style', 'text',...
    'String', 'Left Y-Axis:',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10, 35, 70, 15],...
    'HorizontalAlignment', 'right');
uicontrol('Parent', axespanel,...
    'Style', 'popup',...
    'Position', [85, 40, 70, 15],...
    'BackgroundColor', 'white',...
    'FontName', 'Courier',...
    'String', 'linear|log',...
    'Tag', [smu_name, '_y1axis']);
uicontrol('Parent', axespanel,...
    'Style', 'text',...
    'String', 'Right Y-Axis:',...
    'BackgroundColor', [0.8, 0.8, 0.8],...
    'Position', [10, 10, 70, 15],...
    'HorizontalAlignment', 'right');
uicontrol('Parent', axespanel,...
    'Style', 'popup',...
    'Position', [85, 15, 70, 15],...
    'BackgroundColor', 'white',...
    'FontName', 'Courier',...
    'String', 'linear|log',...
    'Tag', [smu_name, '_y2axis']);

uicontrol('Style', 'pushbutton',...
    'String', 'Start',...
    'Position', [575 44 65 22],...
    'Interruptible', 'on',...
    'Tag', [smu_name, '_startbutton'],...
    'UserData', 'idle',...
    'Callback', ['ch1srcname_h = findobj(''Tag'', ''', smu_name, '_ch1srcname'');',...
        'ch1srcvalues_h = findobj(''Tag'', ''', smu_name, '_ch1srcvalues'');',...
        'ch1measname_h = findobj(''Tag'', ''', smu_name, '_ch1measname'');',...
        'ch2srcname_h = findobj(''Tag'', ''', smu_name, '_ch2srcname'');',...
        'ch2srcvalues_h = findobj(''Tag'', ''', smu_name, '_ch2srcvalues'');',...
        'ch2measname_h = findobj(''Tag'', ''', smu_name, '_ch2measname'');',...
        'if (length(deblank(get(ch1srcname_h, ''String'')))~=0)&(length(deblank(get(ch2srcname_h, ''String'')))~=0),',...
        '    eval([deblank(get(ch1srcname_h, ''String'')), ''=['', deblank(get(ch1srcvalues_h, ''String'')), ''];'']);',...
        '    eval([deblank(get(ch2srcname_h, ''String'')), ''=['', deblank(get(ch2srcvalues_h, ''String'')), ''];'']);',...
        '    if (length(deblank(get(ch1measname_h, ''String'')))~=0)&(length(deblank(get(ch2measname_h, ''String'')))~=0),',...
        '        eval([''['', deblank(get(ch1measname_h, ''String'')), '', '', deblank(get(ch2measname_h, ''String'')), ''] = take(', smu_name, ', '', deblank(get(ch1srcname_h, ''String'')), '', '', deblank(get(ch2srcname_h, ''String'')), '');'']);',...
        '    elseif length(deblank(get(ch1measname_h, ''String'')))~=0,',...
        '        eval([''['', deblank(get(ch1measname_h, ''String'')), '', ch2_temp] = take(', smu_name, ', '', deblank(get(ch1srcname_h, ''String'')), '', '', deblank(get(ch2srcname_h, ''String'')), '');'']);',...
        '        clear ch2_temp;',...
        '    elseif length(deblank(get(ch2measname_h, ''String'')))~=0,',...
        '        eval([''[ch1_temp, '', deblank(get(ch2measname_h, ''String'')), ''] = take(', smu_name, ', '', deblank(get(ch1srcname_h, ''String'')), '', '', deblank(get(ch2srcname_h, ''String'')), '');'']);',...
        '        clear ch1_temp;',...
        '    else',...
        '        beep;',...
        '        warning(''You must specify measurement names either for CH1 or for CH2.'');',...
        '    end;',...
        'else',...
        '    beep;',...
        '    warning(''You must specify source names and values both for CH1 and for CH2.'');',...
        'end;',...
        'clear ch1srcname_h ch1srcvalues_h ch1measname_h ch2srcname_h ch2srcvalues_h ch2measname_h;']);
