function [xg,yg,zg]=f_GetGripperPosition

%notice that the target name should be 'targetname'
vrep=remApi('remoteApi');
vrep.simxFinish(-1);% close all current connects
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);% setup connection

    
    %codes here
    [returnCode1,joint1]=vrep.simxGetObjectHandle(clientID,'redundantRob_tip',vrep.simx_opmode_blocking);
    [returnCode,arrayposition]=vrep.simxGetObjectPosition(clientID,joint1,-1,vrep.simx_opmode_blocking);
    xg=arrayposition(:,1);
   yg=arrayposition(:,2);
   zg=arrayposition(:,3);
   returncode_GetGripperPosition=1;

    
    
    vrep.simxFinish(-1)
end

        