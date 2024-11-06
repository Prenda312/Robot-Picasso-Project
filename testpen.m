
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
DXL_ID_6                      = 4;
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
dxl_present_position = zeros(1,6);          % Present position



% load testpen1
y=-30;
i=-36;
j=36;
v=6;
u=-50;

q1=jtraj([0,-10,0,0,0,0],[0,i-5,0,0,0,0],60);%提起
q1=[q1;jtraj([0,i-5,0,0,0,0],[y-5,i,0,0,0,0],60)];%平移
q1=[q1;jtraj([y-5,i,0,0,0,0],[y-5,i,0,0,0,u],10)];%开爪
q1=[q1;jtraj([y-5,i,0,0,0,u],[y-5,i,j,-(j+i),y-5,u],30)];%放下
q1=[q1;jtraj([y-5,i,j,-(j+i),y-5,u],[y,i,j,-(j+i),y,u],10)];%靠近夹块
q1=[q1;jtraj([y,i,j,-(j+i),y,u],[y,i,j,-(j+i),y,v],5)];%夹紧

C1=cos((-i-j/2)/180*pi)*cos(j/2/180*pi);
for n=0:0.5:j
    %     30:0.5:10
    theta1=(j-n)/2;
    theta2=acos(C1/cos(theta1/180*pi))*180/pi;
    qi=[y,-(theta2+theta1),2*theta1,theta2-theta1,y,v];
    q1=[q1;qi];
end
q2=jtraj(q1(end,:),q1(end,:)+[0,-20,0,-20,0,v]/2,30);
q2=[q2;jtraj(q1(end,:)+[0,-20,0,-20,0,v]/2,[0,-20,20,-10,0,v],100)];
q1=[q1;q2];
q1=q1*pi/180;
q=q1;
% q1=zeros(length(q),5);
% q1(:,1)=-q1(:,1);
% q1(:,2)=-q1(:,2);
% % q1(:,3)= q(:,3);
% % q1(:,4)= q(:,4);
% q1(:,5)=-q1(:,5);

x = (180/pi)*(512/150);
%q(:,2)=-q(:,2);
pos = q1*x+512;

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

    while 1

        if input('Press any key to continue! (or input e to quit!)\n', 's') == ESC_CHARACTER
            break;
        end

        h=[1,3,2,5,17,4];

        for i =1:6
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
            for  j=1:6
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