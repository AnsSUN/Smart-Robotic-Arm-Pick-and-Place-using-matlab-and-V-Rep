function project()

    vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
    vrep.simxFinish(-1); % just in case, close all opened connections
    clientID=vrep.simxStart('127.0.0.1',19997,true,true,5000,5);

    
    
    
    
    camera_signal=1;
    [target_Info,WorldCenters_1]=camera_analyse(camera_signal,clientID);
    target_Info %x,y,z,kind
    WorldCenters_1 %x,y,z,matchedPoints,kind,PairMark
    
    
    
    
    
    
        

               
    vrep.simxStopSimulation(clientID,vrep.simx_opmode_oneshot_wait);% Now close the connection to V-REP:                  
    vrep.simxFinish(-1)
    vrep.delete(); % call the destructor!  
end