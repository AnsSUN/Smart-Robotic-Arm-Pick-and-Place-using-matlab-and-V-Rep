close all,clear all,clc
tic
f_gripperopen;
f_grippercontrol(0,0,1.17,0,0.8,0.33,-105,0,0)
%f_grippercontrol(-0.0167,0.4907,0.335,-105,0,0)
%f_grippercontrol(0,0.8,0.33,-105,0,0);
f_grippercontrol(0,0.8,0.23,-105,0,0)
toc
%f_readProxSensor
%re(2,:)=f_readProxSensor
f_gripperclose
f_grippercontrol(0,0,1.17,0,0,0)
f_grippercontrol(0,0.8,0.23,-105,0,0)