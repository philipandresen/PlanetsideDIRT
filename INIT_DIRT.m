function [range rangelimit rangeincrement triallimit] = INIT_DIRT()
%This is a test function for loading scripts into ForestFire. The code may
%look complex because I was testing a complex 'inputdlg' function, but all
%you need to do is just have your custom function output a string that will
%be executed by the cluster. 
%For example: outstring='disp(''''hello world'''');' would work just fine.
%   Philip Andresen, 8-22-2012 (august)

prompt={'Start range';'End range';'Range spacing';...
    'Number of trials'};
name='D(I,R,t) initialization';
formats(1,1)=struct('type','edit','format','integer','limits',[1 inf],'style','edit');
formats(2,1)=struct('type','edit','format','integer','limits',[1 inf],'style','edit');
formats(3,1)=struct('type','edit','format','integer','limits',[1 inf],'style','edit');
formats(4,1)=struct('type','edit','format','integer','limits',[1 inf],'style','edit');

defaultanswer={1;100;4;4};

[inputs,canceled]=inputsdlg(prompt,name,formats,defaultanswer);

if canceled==1; 
    range=defaultanswer{1};
    rangelimit=defaultanswer{2};
    rangeincrement=defaultanswer{3};
    triallimit=defaultanswer{4};
    return; 
end;

range=inputs{1};
rangelimit=inputs{2};
rangeincrement=inputs{3};
triallimit=inputs{4};


end
