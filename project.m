function project()
    disp('Program started');
    % vrep=remApi('remoteApi','extApi.h'); % using the header (requires a compiler)
    vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
    vrep.simxFinish(-1); % just in case, close all opened connections
    clientID=vrep.simxStart('127.0.0.1',19997,true,true,5000,5);

    if (clientID>-1)
        disp('Connected to remote API server');
        [camerro,vision1] = vrep.simxGetObjectHandle(clientID,'Vision_sensor#',vrep.simx_opmode_oneshot_wait);
        vrep.simxStartSimulation(clientID,vrep.simx_opmode_oneshot_wait);
        
        vrep.simxGetVisionSensorImage2(clientID,vision1,0,vrep.simx_opmode_streaming); % Initialize streaming

        i=0
        while i<2
            [returnCode,resolut,image]= vrep.simxGetVisionSensorImage2(clientID,vision1,0,vrep.simx_opmode_buffer); % Try to retrieve the streamed data
            if (returnCode==vrep.simx_return_ok) % After initialization of streaming, it will take a few ms before the first value arrives, so check the return code
                image=imshow(image);
                
                pause(0.1)
                i=i+1
            end
        end
        
        export_fig scene -r359.05 -q100 -c[NaN,NaN,NaN,NaN]  %export

        vrep.simxStopSimulation(clientID,vrep.simx_opmode_oneshot_wait);
        % Now close the connection to V-REP:   
        
        vrep.simxFinish(clientID);
    else
        disp('Failed connecting to remote API server');
    end
    vrep.delete(); % call the destructor!
    
    disp('Program ended');
end