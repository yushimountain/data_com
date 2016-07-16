//==================================================================================================
//  Copyright     : 重庆宜时宜景公司
//  Filename      : mem_model.sv
//  Description   : 仿真模型，初始化CHANNEL_IN_NUM个输入数据块mem_tx；
//                  生成CHANNEL_OUT_NUM个输出数据块参考模型
//  Date          : 2016/7/20
//  Author        : WangTao
//==================================================================================================

`timescale 1ns/1ps
module mem_model(
    mode,
    col_max,
    row_max
);
parameter   TOP_BOTTOM_SEL   = 1;                                           //上下部分标识
parameter   CHANNEL_IN_NUM   = 4;
parameter   CHANNEL_OUT_NUM  = 4;
parameter   HEAD_DIRECTION   = 2;                                           //输入数据方向
parameter   OUTPUT_DIRECTION = 0;                                           //输出数据方向
parameter   FRAME_RAM_EN     = 0;                                           //帧缓冲使能
parameter   OVERLAP_WIDTH    = 3;                                           //填充行数
parameter   RAM_DEPTH        = 100;
parameter   VIDEO_DATA_WIDTH = 18;
localparam  TX_DEPTH         = RAM_DEPTH;                                   //mem_tx每行数据个数
localparam  BIG_DEPTH        = TX_DEPTH*CHANNEL_IN_NUM+2*OVERLAP_WIDTH;     //mem_big每行数据个数
localparam  REFER_DEPTH      = (TX_DEPTH+2*OVERLAP_WIDTH)*1024;             //mem_refer深度：每行数据个数*数据块行数
input                                   mode;                                          //1：正常模式；2：测试模式
input       [9:0]                       col_max;                                       //一行有多少个数据
input       [9:0]                       row_max;                                       //每个数据块有多少行

reg         [VIDEO_DATA_WIDTH-1:0]      mem_tx[CHANNEL_IN_NUM:0][1024:0][TX_DEPTH:0];   //生成的原始数据块，发送给DUT
reg         [VIDEO_DATA_WIDTH-1:0]      mem_big[2048:0][BIG_DEPTH:0];                   //将所有数据块拼接成的大数据块
reg         [VIDEO_DATA_WIDTH-1:0]      mem_refer[CHANNEL_OUT_NUM:0][REFER_DEPTH:0];    //合成后的数据块，与DUT输出作对比
reg         [63:0]                      channel_direction;                              //每一个输入块的HEAD_DIRECTION
reg         [19:0]                      ram_add_end;                                    //每个合成后的数据块拥有的数据个数
reg         [19:0]                      block_len;                                      //每个输出数据块一行的数据个数

// initial begin            //对模型仿真时用的代码
//     configure();
//     mem_init();
//     dig_mem();
//     display_mem();
// end

// task configure;
// begin
//     mode            = 1'b1;
//     col_max         = 10'd10;
//     row_max         = 10'd10;
//     $display("configure well!!");
// end
// endtask


// task display_mem();//将数据块数据打印出来，方便观察,调试仿真模型时使用
// integer handle0,handle1,handle2,handle3;    //mem_tx的句柄，每个数据块单独存放
// //integer handle4,handle5,handle6,handle7;
// integer handle_big;
// integer handle_0,handle_1,handle_2,handle_3;//输出数据块句柄，每个数据块单独存放
// integer i,j,k;
// reg [9:0] h_cnt_big;
// reg [9:0] l_cnt_big;
// reg [9:0] block_depth;                      //输出数据块行数
// reg [6:0] N;                                //mem_big中一行数据由N个数据块拼接而成
// begin
//     N       = CHANNEL_IN_NUM*$pow(2,(!TOP_BOTTOM_SEL))/2; //若为两行排列，mem_big上半部分拥有CHANNEL_IN_NUM/2个数据块，否则为CHANEL_IN_NUM个数据块
//     handle0 = $fopen("mem0.txt");  //handle0=pow(2,1)
//     handle1 = $fopen("mem1.txt");  //handle1=pow(2,2)=handle0*2
//     handle2 = $fopen("mem2.txt");  //handle2=pow(2,3)=handle0*4
//     handle3 = $fopen("mem3.txt");
//     handle_big = $fopen("mem_big.txt");
//     handle_0 = $fopen("mem_refer0.txt");
//     handle_1 = $fopen("mem_refer1.txt");
//     handle_2 = $fopen("mem_refer2.txt");
//     handle_3 = $fopen("mem_refer3.txt");
//     h_cnt_big = 0;
//     //打印发送的数据块mem_tx
//     for (i = 0; i < CHANNEL_IN_NUM; i++) begin
//         for (int j = 0; j < row_max; j++) begin
//             for (int k = 0; k < col_max; k++) begin
//                 $fwrite(handle0*$pow(2,i),"%d",mem_tx[i][j][k]);
//             end
//             $fwrite(handle0*$pow(2,i),"\n");
//         end
//         $fclose(handle0*$pow(2,i));
//     end
//     //打印mem_big
//     if(CHANNEL_IN_NUM == 1) begin
//     //防止误操作，比如输入1个块，但top_bottom=1
//         block_depth = row_max;
//     end
//     else begin
//         //输入数据块两行排列，mem_big拥有2*row_max行数据；单行排列mem_big有row_max行数据
//         block_depth = $pow(2,TOP_BOTTOM_SEL)*row_max;
//     end
//     repeat(block_depth) begin
//         l_cnt_big = 0;
//         repeat((col_max)*N+2*OVERLAP_WIDTH) begin //mem_big一行拥有的数据个数
//             $fwrite(handle_big,"%d",mem_big[h_cnt_big][l_cnt_big++]);
//         end
//         $fwrite(handle_big,"\n");
//         h_cnt_big++;
//     end
//     $fclose(handle_big);
//     //打印mem_refer
//     for (int i = 0; i < CHANNEL_OUT_NUM; i++) begin
//         for (int j = 0; j < ram_add_end; j++) begin
//             $fwrite(handle_0*$pow(2,i),"%d",mem_refer[i][j]);
//             if((j + 1) % (block_len) == 0) begin
//                 $fwrite(handle_0*$pow(2,i),"\n");
//             end
//         end
//         $fclose(handle_0*$pow(2,i));
//     end
// end
// endtask

task mem_init;
//根据参数生成数据块
//每一个像素点有18bit，前6位表示第几个数据块，后面12bit表示像素点所在的行、列
reg [10:0] h_cnt;      //ram 行计数器，暂定每一个数据块为8行
reg [10:0] l_cnt;      //ram 列计数器，一行最多512个数据
reg [5:0] channel;
integer i;
begin
    h_cnt  = 0;
    l_cnt  = 0;
    channel= 0;
    for(i=0;i<CHANNEL_IN_NUM;i++) begin
        repeat(row_max) begin        //数据块有多少行数据
            l_cnt = 0;
            repeat(col_max) begin    //一行有col_max个数据
                mem_tx[channel][h_cnt][l_cnt++] = {channel*1000000 + h_cnt*1000 + l_cnt};
                //每个数据能反映出其位置。649999:第64通道的第99行第99列个数
            end
            h_cnt++;
        end
        h_cnt = 0;
        channel++;
    end
    //打印mem_tx
    // for (i = 0; i < CHANNEL_IN_NUM; i++) begin
    //     for (int j = 0; j < row_max; j++) begin
    //         for (int k = 0; k < col_max; k++) begin
    //             $write("%0d  ",mem_tx[i][j][k]);
    //         end
    //         $write("\n");
    //     end
    // end
end

endtask

task judge_direction;
//判断每个数据块的输入方向
begin
    if(HEAD_DIRECTION == 0) begin
        channel_direction = 64'h0;
    end
    else if(HEAD_DIRECTION == 1'b1) begin
        channel_direction = 64'hffff_ffff_ffff_ffff;
    end
    else begin
        if(TOP_BOTTOM_SEL == 1'b1) begin
            case (CHANNEL_IN_NUM)
            7'd2: begin
                channel_direction = 64'h0;
            end
            7'd4: begin
                channel_direction = 64'b0110;
            end
            7'd8: begin
                channel_direction = 64'b0011_1100;
            end
            7'd16:begin
                channel_direction = 64'hff0;
            end
            7'd32:begin
                channel_direction = 64'hffff_00;
            end
            7'd64:begin
                channel_direction = 64'hffff_ffff_0000;
            end
            default : channel_direction = 64'h0;
            endcase
        end
        else begin
            case (CHANNEL_IN_NUM)
            7'd2: begin
                channel_direction = 64'b10;
            end
            7'd4: begin
                channel_direction = 64'b1100;
            end
            7'd8: begin
                channel_direction = 64'hf0;
            end
            7'd16:begin
                channel_direction = 64'hff00;
            end
            7'd32:begin
                channel_direction = 64'hffff_0000;
            end
            7'd64:begin
                channel_direction = 64'hffff_ffff_0000_0000;
            end
            default : channel_direction = 64'h0;
            endcase
        end
    end
end
endtask

task mem_gather;
//操作mem_big，将所有数据存放到一个mem里面
integer i;
reg [19:0] l_cnt;       //接收数据块列计数器
reg [19:0] h_cnt;       //接收数据块行计数器
reg [19:0] h_cnt_big;   //mem_big的行计数器
reg [19:0] l_cnt_big;   //mem_big的列计数器
reg        rptr_dir;    //指针方向，1：递增；0：递减
reg [6:0]  repeat_time; //大数据块横向由多少个小数据块组成
reg [5:0]  channel;     //当前操作的是哪一个数据块
reg [19:0] block_depth;
reg [10:0] N;
begin
//根据每个块的输入方向，将输入数据块根据规则拼接成一个大的数据块
    l_cnt     = 0;
    h_cnt     = 0;
    h_cnt_big = 0;
    repeat(row_max) begin
        channel   = 0;
        l_cnt_big = 0;
        if(channel_direction[0] == 1'b0) begin
            l_cnt    = OVERLAP_WIDTH;
            rptr_dir = 1'b0;
        end
        else begin
            l_cnt    = col_max - 1'b1 - OVERLAP_WIDTH;
            rptr_dir = 1'b1;
        end
        repeat(OVERLAP_WIDTH) begin//左边对称填充区
            if(rptr_dir == 1'b1) begin
                mem_big[h_cnt_big][l_cnt_big++] = mem_tx[0][h_cnt][l_cnt++];
            end
            else begin
                mem_big[h_cnt_big][l_cnt_big++] = mem_tx[0][h_cnt][l_cnt--];
            end
        end
        if(CHANNEL_IN_NUM == 1) begin
        //防止误操作，比如输入1个块，但top_bottom=1
            repeat_time = 7'd1;
        end
        else if(TOP_BOTTOM_SEL == 1'b0) begin //只有一行数据块
            repeat_time = CHANNEL_IN_NUM;
        end
        else begin//有两行数据块
            repeat_time = CHANNEL_IN_NUM/2;
        end
        repeat(repeat_time) begin
            if(channel_direction[channel] == 1'b1) begin
                l_cnt    = col_max - 1'b1;
                rptr_dir = 1'b0;
            end
            else begin
                l_cnt    = 0;
                rptr_dir = 1'b1;
            end
            repeat(col_max) begin
                if(rptr_dir == 1'b1) begin //当前数据块从左向右递减
                    mem_big[h_cnt_big][l_cnt_big++] = mem_tx[channel][h_cnt][l_cnt++];
                end
                else begin
                    mem_big[h_cnt_big][l_cnt_big++] = mem_tx[channel][h_cnt][l_cnt--];
                end
            end
            channel++;
        end
        channel--;

        if(channel_direction[channel] == 1'b1) begin
            l_cnt    = 1'b1;
            rptr_dir = 1'b1;
        end
        else begin
            l_cnt    = col_max - 2'd2;
            rptr_dir = 1'b0;
        end
        repeat(OVERLAP_WIDTH) begin
            if(rptr_dir == 1'b1) begin
                mem_big[h_cnt_big][l_cnt_big++] = mem_tx[channel][h_cnt][l_cnt++];
            end
            else begin
                mem_big[h_cnt_big][l_cnt_big++] = mem_tx[channel][h_cnt][l_cnt--];
            end
        end
        h_cnt_big++;
        h_cnt++;
    end

    if(repeat_time == CHANNEL_IN_NUM/2) begin //上下两行数据块
        h_cnt = row_max - 1;               //从mem_tx的最后一行开始写
        repeat(row_max)begin
            channel   = CHANNEL_IN_NUM - 1'd1;
            l_cnt_big = 0;
            if(channel_direction[0] == 1'b0) begin
                l_cnt    = OVERLAP_WIDTH;
                rptr_dir = 1'b0;
            end
            else begin
                l_cnt    = col_max - 1'b1 - OVERLAP_WIDTH;
                rptr_dir = 1'b1;
            end
            repeat(OVERLAP_WIDTH) begin
                if(rptr_dir == 1'b1) begin
                    mem_big[h_cnt_big][l_cnt_big++] = mem_tx[channel][h_cnt][l_cnt++];
                end
                else begin
                    mem_big[h_cnt_big][l_cnt_big++] = mem_tx[channel][h_cnt][l_cnt--];
                end
            end
            //发送有效数据区数据
            repeat(repeat_time) begin //CHANNEL_IN_NUM/2个数据块
                if(channel_direction[channel] == 1'b1) begin
                    l_cnt    = col_max - 1'b1;
                    rptr_dir = 1'b0;
                end
                else begin
                    l_cnt    = 0;
                    rptr_dir = 1'b1;
                end
                repeat(col_max) begin
                    if(rptr_dir == 1'b0) begin //当前数据块从左向右递减
                        mem_big[h_cnt_big][l_cnt_big++] = mem_tx[channel][h_cnt][l_cnt--];
                    end
                    else begin
                        mem_big[h_cnt_big][l_cnt_big++] = mem_tx[channel][h_cnt][l_cnt++];
                    end
                end
                channel--;
            end
            channel++;
            //最右边对称填充
            if(channel_direction[channel] == 1'b1) begin
                l_cnt    = 1'b1;
                rptr_dir = 1'b1;
            end
            else begin
                l_cnt    = col_max - 2'd2;
                rptr_dir = 1'b0;
            end
            repeat(OVERLAP_WIDTH) begin
                if(rptr_dir == 1'b1) begin
                    mem_big[h_cnt_big][l_cnt_big++] = mem_tx[channel][h_cnt][l_cnt++];
                end
                else begin
                    mem_big[h_cnt_big][l_cnt_big++] = mem_tx[channel][h_cnt][l_cnt--];
                end
            end
            h_cnt--;
            h_cnt_big++;
        end
    end
    //打印mem_big
    //  N       = CHANNEL_IN_NUM*$pow(2,(!TOP_BOTTOM_SEL))/2; //若为两行排列，mem_big上半部分拥有CHANNEL_IN_NUM/2个数据块，否则为CHANEL_IN_NUM个数据
    // if(CHANNEL_IN_NUM == 1) begin
    // //防止误操作，比如输入1个块，但top_bottom=1
    //     block_depth = row_max;
    // end
    // else begin
    //     //输入数据块两行排列，mem_big拥有2*row_max行数据；单行排列mem_big有row_max行数据
    //     block_depth = $pow(2,TOP_BOTTOM_SEL)*row_max;
    // end
    // h_cnt_big = 0;
    // repeat(block_depth) begin
    //     l_cnt_big = 0;
    //     repeat((col_max)*N+2*OVERLAP_WIDTH) begin //mem_big一行拥有的数据个数
    //         $write("%d",mem_big[h_cnt_big][l_cnt_big++]);
    //     end
    //     $write("\n");
    //     h_cnt_big++;
    // end
end
endtask

task mem_move;              //将mem_big目标地址的数据搬到mem_refer,只操作一个输出数据块
input [5:0] channel;        //当前要操作的是哪一个mem_refer
input [20:0] rptr;          //数据在mem_big中的横向起始地址
input       h_cnt_big_dir;  //从mem_big取数据时，判断行计数器递增还是递减1：递增；0：递减
reg   [10:0] block_num;      //block_num=CHANNEL_IN_NUM /CHANNEL_OUT_NUM
reg   [30:0]ram_add;        //mem_refer 的地址
reg   [20:0]h_cnt_big;      //mem_big中的行计数器
reg   [20:0]l_cnt_big;      //mem_big的列计数器
reg   [10:0] block_depth;    //输出块的行数
begin
    ram_add = 0;
    block_num = CHANNEL_IN_NUM/CHANNEL_OUT_NUM;
    if(mode == 1'b1) begin //正常模式需要列填充,一行的数据个数
        block_len = 2*OVERLAP_WIDTH + (col_max)*block_num;
    end
    else begin
        block_len = (col_max)*block_num;
    end

    //判断从mem_big取数据时起始行数，从mem_big取的第一个数据坐标为（h_cnt_big，rptr）
    if(h_cnt_big_dir == 1'b0) begin//第二行的输出数据块
        h_cnt_big = row_max*2 - 1'd1;
    end
    else begin//第一行的输出数据块
        h_cnt_big = 0;
    end

    if(mode && TOP_BOTTOM_SEL && !FRAME_RAM_EN && (CHANNEL_IN_NUM != 1)) begin
    //需要进行行填充的条件，此时每个输出块的行数如下
        block_depth = row_max + OVERLAP_WIDTH;
    end
    else begin
    //不用进行行填充
        block_depth = row_max;
    end
    repeat(block_depth) begin
        l_cnt_big = rptr;
        repeat(block_len)begin //输出数据块的一行数据
            if(OUTPUT_DIRECTION[channel] == 1'b0) begin //从左向右读
                mem_refer[channel][ram_add++] = mem_big[h_cnt_big][l_cnt_big++];
            end
            else begin
                mem_refer[channel][ram_add++] = mem_big[h_cnt_big][l_cnt_big--];
            end
        end
        if(h_cnt_big_dir == 1'b1) begin
            h_cnt_big++;
        end
        else begin
            h_cnt_big--;
        end
    end

    ram_add_end = ram_add;
end
endtask

task dig_mem;
//生成输出块，操作mem_refer
reg [5:0] channel;      //输出数据块的编号
reg [5:0] block_num;    //CHANNEL_IN_NUM/CHANNEL_OUT_NUM
reg [20:0] rptr;        //输出数据块第一个数据在mem_big一行中的地址
reg       h_cnt_big_dir;//从mem_big中取数据时，行计数器加减的方向，1：递增；2：递减
reg [30:0]rptr_frame;   //帧缓冲不使能进行行填充时其他mem_refer的地址指针，
reg [30:0]rptr_refer;   //行填充时，mem_refer中的地址指针
begin
    channel   = 0;
    block_num = CHANNEL_IN_NUM/CHANNEL_OUT_NUM;
    judge_direction();
    mem_gather();
    repeat(CHANNEL_OUT_NUM) begin //选取每个输出数据块
        if((TOP_BOTTOM_SEL == 1'b1) && (channel >= CHANNEL_OUT_NUM/2) && (CHANNEL_OUT_NUM != 1)) begin
        //上下排列数据块的下半部分
            if(OUTPUT_DIRECTION[channel] == 1'b0) begin
                rptr = (col_max) * (CHANNEL_OUT_NUM - 1'b1 - channel)
                        * block_num + OVERLAP_WIDTH*(!mode);
            end
            else begin
                rptr = (col_max) * (CHANNEL_OUT_NUM - channel)
                        * block_num + 2*OVERLAP_WIDTH - 1'b1 - OVERLAP_WIDTH*(!mode);
            end
            h_cnt_big_dir = 1'b0;   //取数据时mem_big行计数器递减
        end
        else begin //第一行数据块
            h_cnt_big_dir = 1'b1;
            if(OUTPUT_DIRECTION[channel] == 1'b0) begin
                rptr = (col_max) * channel * block_num + OVERLAP_WIDTH * (!mode);
            end
            else begin
                rptr = (col_max)*(channel + 1'b1) * block_num + 2*OVERLAP_WIDTH - 1'b1 - OVERLAP_WIDTH*(!mode);
            end
        end
        mem_move(channel,rptr,h_cnt_big_dir);
        channel++;
    end
    //打印mem_refer
    // for (int i = 0; i < CHANNEL_OUT_NUM; i++) begin
    //     $display("CHANNEL%0d",i);
    //     for (int j = 0; j < ram_add_end; j++) begin
    //         $write("%0d    ",mem_refer[i][j]);
    //     end
    // end
end
endtask

endmodule