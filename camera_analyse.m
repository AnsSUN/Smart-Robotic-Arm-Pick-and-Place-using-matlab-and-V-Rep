function [target_Info,WorldCenters_1]=camera_analyse(camera_signal,clientID)
  
        vrep=remApi('remoteApi');
        vrep.simxFinish(-1);% close all current connects
        clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);% setup connection
        fprintf('vrep_connect success\n')
        if camera_signal==1 %camera 1  
            [camerro,vision1] = vrep.simxGetObjectHandle(clientID,'Vision_sensor#',vrep.simx_opmode_oneshot_wait);
        else
            [camerro,vision1] = vrep.simxGetObjectHandle(clientID,'Vision_sensor0#',vrep.simx_opmode_oneshot_wait);
        end
        fprintf('get object handle succeed\n')
        vrep.simxStartSimulation(clientID,vrep.simx_opmode_oneshot_wait);
        
        vrep.simxGetVisionSensorImage2(clientID,vision1,0,vrep.simx_opmode_streaming); % Initialize streaming
        fprintf('vrep streaming succeed\n')
        
        i=0;
        while i<2
            [returnCode,resolut,image]= vrep.simxGetVisionSensorImage2(clientID,vision1,0,vrep.simx_opmode_buffer); % Try to retrieve the streamed data
            if (returnCode==vrep.simx_return_ok) % After initialization of streaming, it will take a few ms before the first value arrives, so check the return code  
                image=imshow(image);      
                pause(0.1)  
                i=i+1;
            end
            
        end
        
        if camera_signal==1
            export_fig scene -r358.7 -q100 -c[NaN,NaN,NaN,NaN]  %export
            WorldCenters_1=target_locate();
        else
            export_fig scene_2 -r200 -q100 -c[NaN,NaN,NaN,NaN]
            WorldCenters_1=target_track();
        end
    
        if camera_signal==1
            WorldCenters_1=sortrows(WorldCenters_1,2);
            target_Info=[WorldCenters_1(1,1),WorldCenters_1(1,2),WorldCenters_1(1,3),WorldCenters_1(1,5)];  %x,y,z,kind
        else
            target_Info=WorldCenters_1;
            WorldCenters_1=[0 0 0 0];
        end
            

        
end