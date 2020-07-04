close all, clear all ,clc
 %this is system signal, which is to show the status of the system,
% 1-obs, 2-move to obj, 3-raise to safe height, 4-move to goal place,
% 5-back to IC
vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
vrep.simxFinish(-1); % just in case, close all opened connections
clientID=vrep.simxStart('127.0.0.1',19997,true,true,5000,5);

syms x sysSignal Xg Yg Zg Sg Scao Se Xo Yo Zo
sysSignal=1;
%[xg,yg,zg]=[0,0,1.17];
xg=0;
yg=0;
zg=1.17;
testcounter=1;
goalobjectcounter=0;
for i=1:2000
    if sysSignal==1 % obs
        camera_signal=1;
        [target_Info,WorldCenters_1]=camera_analyse(camera_signal,clientID);
        xo=target_Info(1,1);
        yo=target_Info(1,2);
        zo=target_Info(1,3);
        so=target_Info(1,4);
% recordposition=[0.106910398,0.471200802,0.32175,3;
%     -0.0250189697942384,0.4977591,0.337,1;
%     0.092768783,0.557618596,0.341,2;
%     -0.002037493,0.591352607,0.338,4;
%     -0.004543695,0.629598791,0.32175,3];
% xo=recordposition(testcounter,1);
% yo=recordposition(testcounter,2);
% zo=recordposition(testcounter,3);
        %x=[sysSignal;Xg;Yg;Zg;Sg;Scao;Se;Xo;Yo;Zo] % set up state vector.
        %Sg=0, gripper is open, Sg=1, gripper is close
        %Scao, kind of current active obj
        %Se, error signal, Se=1, system is wrong
        
        sysSignal=2;
        
    elseif sysSignal==2 % move to obj
        %[xt,yt,zt]=[xo,yo,zo];
        xt=xo;
        yt=yo;
        zt=zo;
        
        f_gripperopen
        f_grippercontrol(xg,yg,zg,xt,yt,zt,-130,0,0);
        sysSignal=3;
    elseif sysSignal==3
        [xg,yg,zg]=f_GetGripperPosition;
        dis=(xt-xg)^2+(yt-yg)^2+(zt-zg)^2;
       if dis>0.02
           continue
        
       else
           pause(3)
           f_gripperclose;
           pause(6)
           [xg,yg,zg]=f_GetGripperPosition;
           sysSignal=4;
       end
    elseif sysSignal==4 % raise to safe height
        %[xt,yt,zt]=[xt,yt,zt+0.2];
        xt=xt;
        yt=yt;
        zt=zt+0.3;
        f_grippercontrol(xg,yg,zg,xt,yt,zt,-90,0,0);
        sysSignal=5;
    elseif sysSignal==5
        [xg,yg,zg]=f_GetGripperPosition;
        dis=(xt-xg)^2+(yt-yg)^2+(zt-zg)^2;
        if dis>0.05
            continue
        else
            sysSignal=6;
        end
        
    elseif sysSignal==6 % move to goal place
        [xg,yg,zg]=f_GetGripperPosition;
        %[xt,yt,zt]=[0.5,0,zt];
        if so==1
            xt=0.4;
            yt=0.3;
            zt=zt-0.2;
        elseif so==3
            xt=0.7-goalobjectcounter*0.1;
            yt=0;
            zt=0.18;
            goalobjectcounter=goalobjectcounter+1;
        elseif so==2
            xt=0.4;
            yt=0;
            zt=zt-0.2;
        elseif so==4
            xt=0.7;
            yt=0.3;
            zt=zt-0.2;
        end

        
        f_grippercontrol(xg,yg,zg,xt,yt,zt,-105,90,0);
        sysSignal=7;
    elseif sysSignal==7
        [xg,yg,zg]=f_GetGripperPosition;
        dis=(xt-xg)^2+(yt-yg)^2+(zt-zg)^2;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            fprintf('start tracking%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
            camera_signal=2;  
            [target_Info,WorldCenters_1]=camera_analyse(camera_signal,clientID);
            target_Info
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if dis>0.05
            
            continue
        else
            pause(3)
            f_gripperopen
            pause(8)
            sysSignal=8;
        end
        
    elseif sysSignal==8 % back to IC
        [xg,yg,zg]=f_GetGripperPosition;
        %[xt,yt,zt]=[0,0,1.17];
        xt=0;
        yt=0;
        zt=1.17;
        f_grippercontrol(xg,yg,zg,xt,yt,zt,0,0,0);
        sysSignal=9;
    elseif sysSignal==9
        [xg,yg,zg]=f_GetGripperPosition;
        dis=(xt-xg)^2+(yt-yg)^2+(zt-zg)^2;
        if dis>0.05
            continue
        else
            pause(5)
            testcounter=testcounter+1;
        sysSignal=1
        end
    
    end
end
                  
    vrep.simxFinish(-1)
    vrep.delete(); % call the destructor!  
