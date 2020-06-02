function err = sd_file_open(filename, pathname, handles)
global filedata

err = 0;

% If SD has been edited but not saved, notify user there's unsaved changes
% before loading new file
if SDgui_EditsMade()
    msg{1} = 'SD data has been edited. Are you sure you want to load a new file and lose your changes? ';
    msg{2} = 'If you''re not sure, click ''No'' to return to main GUI and save your changes before ';
    msg{3} = 'loading a new file. Otherwise click ''Yes'' to proceed with loading new file';
    q = MenuBox([msg{:}], {'Yes','No'});
    if q==2
        return;
    end
end

SDgui_clear_all(handles);

% Load new SD file
[filedata, err] = sd_file_load([pathname, filename], handles);
if err
    return;
end

% Initialize SD object with data from SD file
% then fix any errors in the SD file data
sd_data_Init(filedata.SD);

err = sd_data_ErrorFix();
if err
    return;
end

% Now we're ready to use the SD data
SrcPos       = sd_data_Get('SrcPos');
DetPos       = sd_data_Get('DetPos');
DummyPos     = sd_data_Get('DummyPos');
ml           = sd_data_GetMeasList();
sl           = sd_data_GetSpringList();
al           = sd_data_GetAnchorList();
Lambda       = sd_data_Get('Lambda');

set(handles.sd_filename_edit,'string',filename);

%%%%%%%% DRAW PROBE GEOMETRY IN THE GUI AXES %%%%%%%
probe_geometry_axes_Init(handles,SrcPos,DetPos,DummyPos,ml);

%%%%%%%% DRAW PROBE GEOMETRY IN THE GUI AXES2 %%%%%%%
probe_geometry_axes2_Init(handles,[SrcPos; DetPos; DummyPos],...
    size([SrcPos; DetPos],1),sl);


%%%%%%%% Initialize source, detector and dummy optode tables in SD %%%%%%%
optode_src_tbl_Update(handles);
optode_det_tbl_Update(handles);
optode_dummy_tbl_Update(handles);

%%%%%%%% Initialize optode spring tables in the to SD %%%%%%%
optode_spring_tbl_Init(handles,sl);

%%%%%%%% Initialize optode anchor points tables in SD %%%%%%%
optode_anchor_tbl_Init(handles,al);

%%%%%%%% Initialize Spatial Unit
%    if strcmpi(SpatialUnit,'cm')
%        set( handles.popupmenuSpatialUnit, 'value',1);
%    else
%        set( handles.popupmenuSpatialUnit, 'value',2);
%    end

%%%%%%%% Initialize Lambda Panel %%%%%%%
if length(Lambda)>0
    wavelength1_edit_Update(handles,Lambda(1));
else
    wavelength1_edit_Update(handles,[]);
end
if length(Lambda)>1
    wavelength2_edit_Update(handles,Lambda(2));
else
    wavelength2_edit_Update(handles,[]);
end
if length(Lambda)>2
    wavelength3_edit_Update(handles,Lambda(3));
else
    wavelength3_edit_Update(handles,[]);
end

% Set ninja cap checkbox if any of the grommet types set to None
if sd_data_AnyGrommetTypeSet()
    set(handles.checkboxNinjaCap, 'value',1)
end

[~, fname,ext] = fileparts(filename);
SDgui_disp_msg(handles, sprintf('Loaded %s', [fname,ext]));

sd_file_panel_SetPathname(handles,pathname);
sd_filename_edit_Set(handles,filename);


