
lib_name = '';


if strcmp(computer, 'PCWIN')
    lib_name = 'dxl_x86_c';
elseif strcmp(computer, 'PCWIN64')
    lib_name = 'dxl_x64_c';
elseif strcmp(computer, 'GLNX86')
    lib_name = 'libdxl_x86_c';
elseif strcmp(computer, 'GLNXA64')
    lib_name = 'libdxl_x64_c';
elseif strcmp(computer, 'MACI64')
    lib_name = 'libdxl_mac_c';
end

% Load Libraries
if ~libisloaded(lib_name)
    [notfound, warnings] = loadlibrary(lib_name, 'dynamixel_sdk.h', 'addheader', 'port_handler.h', 'addheader', 'packet_handler.h');
end

% Control table address
ADDR_AX_TORQUE_ENABLE       = 24;           % Control table address is different in Dynamixel model
ADDR_AX_GOAL_POSITION       = 30;
ADDR_AX_PRESENT_POSITION    = 36;

% Protocol version
PROTOCOL_VERSION            = 1.0;          % See which protocol version is used in the Dynamixel

% Default setting
DXL_ID_1                      = 1;
DXL_ID_2                      = 3;
DXL_ID_3                      = 2;
DXL_ID_4                      = 5;
DXL_ID_5                      = 17;
% Dynamixel ID: 1
BAUDRATE                    = 1000000;
DEVICENAME                  = 'COM11';       % Check which port is being used on your controller
% ex) Windows: 'COM1'   Linux: '/dev/ttyUSB0' Mac: '/dev/tty.usbserial-*'

TORQUE_ENABLE               = 1;            % Value for enabling the torque
TORQUE_DISABLE              = 0;            % Value for disabling the torque
% DXL_MINIMUM_POSITION_VALUE  = 100;          % Dynamixel will rotate between this value
% DXL_MAXIMUM_POSITION_VALUE  = 4000;         % and this value (note that the Dynamixel would not move when the position value is out of movable range. Check e-manual about the range of the Dynamixel you use.)
DXL_MOVING_STATUS_THRESHOLD = 10;           % Dynamixel moving status threshold

ESC_CHARACTER               = 'e';          % Key for escaping loop

COMM_SUCCESS                = 0;            % Communication Success result value
COMM_TX_FAIL                = -1001;        % Communication Tx Failed

% Initialize PortHandler Structs
% Set the port path
% Get methods and members of PortHandlerLinux or PortHandlerWindows
port_num = portHandler(DEVICENAME);

% Initialize PacketHandler Structs
packetHandler();

dxl_comm_result = COMM_TX_FAIL;             % Communication result
% dxl_goal_position = [DXL_MINIMUM_POSITION_VALUE DXL_MAXIMUM_POSITION_VALUE];         % Goal position

dxl_error = 0;                              % Dynamixel error
dxl_present_position = zeros(1,5);          % Present position


load test1



% Open port
if (openPort(port_num))
    fprintf('Succeeded to open the port!\n');
   
    % Set port baudrate
    if (setBaudRate(port_num, BAUDRATE))
        fprintf('Succeeded to change the baudrate!\n');
    else
        unloadlibrary(lib_name);
        fprintf('Failed to change the baudrate!\n');

        fprintf('Please reconnect the USB interface and run again!\n');
    end


    % Enable Dynamixel Torque_1
    for DXL_ID = [1,2,3,5,17,4]
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_AX_TORQUE_ENABLE, TORQUE_ENABLE);
        dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
        dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);
        if dxl_comm_result ~= COMM_SUCCESS
            fprintf('%s\n', getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
        elseif dxl_error ~= 0
            fprintf('%s\n', getRxPacketError(PROTOCOL_VERSION, dxl_error));
        else
            fprintf('Dynamixel has been successfully connected \n');
        end


    end

    write2ByteTxRx(port_num, PROTOCOL_VERSION, 4, ADDR_AX_GOAL_POSITION, (180/pi)*(512/150)*20+512);

    q1=zeros(length(q),5);
    q1(:,1)=-q(:,1);
    q1(:,2)=-q(:,2);
    q1(:,3)= q(:,3)
    q1(:,4)= q(:,4);
    q1(:,5)=-q(:,1);

    x = (180/pi)*(512/150);
    %q(:,2)=-q(:,2);
    pos = q1*x+512;
%     pos(:,1)=pos(:,1)+30;
    %  pos(:,4)=pos(:,4)-5;
    pos(:,3)=pos(:,3)-6;
    pos(:,2)=pos(:,2)-40;

    while 1
        if input('Press any key to continue! (or input e to quit!)\n', 's') == ESC_CHARACTER
            break;
        end

        h=[1,3,2,5,17];


        for i =1:5
            dxl_present_position(i) = read2ByteTxRx(port_num, PROTOCOL_VERSION, h(i) , ADDR_AX_PRESENT_POSITION);
            dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
            dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);
            if dxl_comm_result ~= COMM_SUCCESS
                fprintf('%s\n', getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
            elseif dxl_error ~= 0
                fprintf('%s\n', getRxPacketError(PROTOCOL_VERSION, dxl_error));
            end
        end

        pos1=jtraj(dxl_present_position,pos(1,:),15);
        pos1=[pos1;pos];
        % Write goal position
        for i = 1:length(pos1)
            for  j=1:5
                DXL_ID = h(j);
                %             pos1(i,j)
                write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_AX_GOAL_POSITION, round(pos1(i,j)));
                dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
                dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);
                if dxl_comm_result ~= COMM_SUCCESS
                    fprintf('%s\n', getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
                elseif dxl_error ~= 0
                    fprintf('%s\n', getRxPacketError(PROTOCOL_VERSION, dxl_error));
                end
            end
        end

        %     while 1
        %         % Read present position_1
        %         dxl_present_position = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_1, ADDR_AX_PRESENT_POSITION);
        %         dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
        %         dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);
        %         if dxl_comm_result ~= COMM_SUCCESS
        %             fprintf('%s\n', getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
        %         elseif dxl_error ~= 0
        %             fprintf('%s\n', getRxPacketError(PROTOCOL_VERSION, dxl_error));
        %         end
        %
        %         fprintf('[ID:%03d] GoalPos:%03d  PresPos:%03d\n', DXL_ID_1, pos, dxl_present_position);
        %
        %         if (abs(pos - dxl_present_position) < DXL_MOVING_STATUS_THRESHOLD)
        %             break;
        %         end
        %     end

        %     while 1
        %         % Read present position_2
        %         dxl_present_position = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_2, ADDR_AX_PRESENT_POSITION);
        %         dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
        %         dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);
        %         if dxl_comm_result ~= COMM_SUCCESS
        %             fprintf('%s\n', getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
        %         elseif dxl_error ~= 0
        %             fprintf('%s\n', getRxPacketError(PROTOCOL_VERSION, dxl_error));
        %         end
        %
        %         fprintf('[ID:%03d] GoalPos:%03d  PresPos:%03d\n', DXL_ID_2, pos, dxl_present_position);
        %
        %         if ~(abs(pos - dxl_present_position) > DXL_MOVING_STATUS_THRESHOLD)
        %             break;
        %         end
        %     end

        %     while 1
        %         % Read present position_3
        %         dxl_present_position = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_3, ADDR_AX_PRESENT_POSITION);
        %         dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
        %         dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);
        %         if dxl_comm_result ~= COMM_SUCCESS
        %             fprintf('%s\n', getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
        %         elseif dxl_error ~= 0
        %             fprintf('%s\n', getRxPacketError(PROTOCOL_VERSION, dxl_error));
        %         end
        %
        %         fprintf('[ID:%03d] GoalPos:%03d  PresPos:%03d\n', DXL_ID_3, pos, dxl_present_position);
        %
        %         if ~(abs(pos - dxl_present_position) > DXL_MOVING_STATUS_THRESHOLD)
        %             break;
        %         end
        %     end
        %
        %     while 1
        %         % Read present position_4
        %         dxl_present_position = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID_4, ADDR_AX_PRESENT_POSITION);
        %         dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
        %         dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);
        %         if dxl_comm_result ~= COMM_SUCCESS
        %             fprintf('%s\n', getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
        %         elseif dxl_error ~= 0
        %             fprintf('%s\n', getRxPacketError(PROTOCOL_VERSION, dxl_error));
        %         end
        %
        %         fprintf('[ID:%03d] GoalPos:%03d  PresPos:%03d\n', DXL_ID_4, pos, dxl_present_position);
        %
        %         if ~(abs(pos - dxl_present_position) > DXL_MOVING_STATUS_THRESHOLD)
        %             break;
        %         end
        %     end

    end


    % Disable Dynamixel Torque
    for DXL_ID = [1,2,3,5,17,4]
        write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_AX_TORQUE_ENABLE, TORQUE_DISABLE);
        dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
        dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);
        if dxl_comm_result ~= COMM_SUCCESS
            fprintf('%s\n', getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
        elseif dxl_error ~= 0
            fprintf('%s\n', getRxPacketError(PROTOCOL_VERSION, dxl_error));
        end
    end
    % Close port
    closePort(port_num);

    % Unload Library
    unloadlibrary(lib_name);
else
    unloadlibrary(lib_name);
    fprintf('Failed to open the port!\n');
    fprintf('Please reconnect the USB interface and run again!\n');
end
% close all;
% clear all;
