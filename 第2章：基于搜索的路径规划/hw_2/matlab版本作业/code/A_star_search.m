function path = A_star_search(map,MAX_X,MAX_Y)
%%
%This part is about map/obstacle/and other settings
    %pre-process the grid map, add offset
    size_map = size(map,1);
    Y_offset = 0;
    X_offset = 0;
    
    %Define the 2D grid map array.
    %Obstacle=-1, Target = 0, Start=1
    MAP=2*(ones(MAX_X,MAX_Y));
    
    %Initialize MAP with location of the target
    % 使用k来控制地图尺寸
    % 定义终点
    xval=floor(map(size_map, 1)) + X_offset;
    yval=floor(map(size_map, 2)) + Y_offset;
    xTarget=xval;
    yTarget=yval;
    MAP(xval,yval)=0;
    
    %Initialize MAP with location of the obstacle
    % 填充障碍物
    for i = 2: size_map-1
        xval=floor(map(i, 1)) + X_offset;
        yval=floor(map(i, 2)) + Y_offset;
        MAP(xval,yval)=-1;
    end 
    
    %Initialize MAP with location of the start point
    % 定义起点
    xval=floor(map(1, 1)) + X_offset;
    yval=floor(map(1, 2)) + Y_offset;
    xStart=xval;
    yStart=yval;
    MAP(xval,yval)=1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %LISTS USED FOR ALGORITHM
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %OPEN LIST STRUCTURE
    %--------------------------------------------------------------------------
    %IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
    %--------------------------------------------------------------------------
    OPEN=[];
    %CLOSED LIST STRUCTURE
    %--------------
    %X val | Y val |
    %--------------
    % CLOSED=zeros(MAX_VAL,2);
    CLOSED=[];

    %Put all obstacles on the Closed list
    % 将障碍物加入close list
    k=1;%Dummy counter
    for i=1:MAX_X
        for j=1:MAX_Y
            if(MAP(i,j) == -1)
                CLOSED(k,1)=i;
                CLOSED(k,2)=j;
                k=k+1;
            end
        end
    end
    
    % close list 点数
    CLOSED_COUNT=size(CLOSED,1);
    %set the starting node as the first node
    % 设置起点
    xNode=xval;
    yNode=yval;
    OPEN_COUNT=1;
    goal_distance=distance(xNode,yNode,xTarget,yTarget);
    path_cost=0;
    OPEN(OPEN_COUNT,:)=insert_open(xNode,yNode,xNode,yNode,goal_distance,path_cost,goal_distance + path_cost);
    
    CLOSED_COUNT=CLOSED_COUNT+1;
    CLOSED(CLOSED_COUNT,1)=xNode;
    CLOSED(CLOSED_COUNT,2)=yNode;
    NoPath=1;
    final_index = -1;
    
    
%%
%This part is your homework
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    stop_flag = 0;

    while(1) %you have to dicide the Conditions for while loop exit 

         if((sum(OPEN(:,1)))==0 || stop_flag == 1 )
             break
         end

         %从队列中弹出一个最小fn的节点
         i_min = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget);
         OPEN(i_min,1) = 0; % 标记为已经弹出
         Data_Pop = OPEN(i_min,[2,3,7]);

         %加入CLOSE LIST
         CLOSED_COUNT = CLOSED_COUNT + 1;
         CLOSED(CLOSED_COUNT,:) = [Data_Pop(1),Data_Pop(2)];

         %拓展周围的邻居
         Exp_array = expand_array(Data_Pop(1),Data_Pop(2),Data_Pop(3),xTarget,yTarget,CLOSED,MAX_X,MAX_Y);
         if(~isempty(Exp_array))
            for m=1:1:length(Exp_array(:,1))
                x_exp = Exp_array(m,1);
                y_exp = Exp_array(m,2);
                hn = Exp_array(m,3);
                gn = Exp_array(m,4);
                fn = Exp_array(m,5);
                if(x_exp == xTarget && y_exp == yTarget)
                    NoPath = 0;
                    OPEN_COUNT = OPEN_COUNT + 1;
                    OPEN(OPEN_COUNT,:) = insert_open(x_exp,y_exp,Data_Pop(1),Data_Pop(2),hn,gn,fn);
                    final_index = OPEN_COUNT;
                    %stop_flag = 1;
                    break;
                end

                n_index = node_index(OPEN,x_exp,y_exp,OPEN_COUNT);
                if(n_index > OPEN_COUNT)
                    OPEN_COUNT = OPEN_COUNT  + 1;
                    OPEN(OPEN_COUNT,:) = insert_open(x_exp,y_exp,Data_Pop(1),Data_Pop(2),hn,gn,fn);
                else
                    if(OPEN(n_index,8)> fn )
                        OPEN(n_index,4) = x_exp;
                        OPEN(n_index,5) = y_exp;
                        OPEN(n_index,7) = gn;
                        OPEN(n_index,8) = fn;
                    end
                end
            end
         end

         %finish the while loop


    end %End of While Loop
    
    %Once algorithm has run The optimal path is generated by starting of at the
    %last node(if it is the target node) and then identifying its parent node
    %until it reaches the start node.This is the optimal path
    
    %
    %How to get the optimal path after A_star search?
    %please finish it
    %
    path = [];
    if NoPath
        return
    else
        n = 1;
        path(n,:) = [xTarget,yTarget];
        while(final_index > 1)
            xval = OPEN(final_index,4);
            yval = OPEN(final_index,5);
            final_index = node_index(OPEN,xval,yval,OPEN_COUNT);
            n = n +1;
            path(n,:) = [xval,yval];
        end
    end
    
    path(n+1,:) = [xStart,yStart];
    path = flip(path);
    
    
end
