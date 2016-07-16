//==================================================================================================
//  Copyright     : 重庆宜时宜景公司
//  Filename      : TX.sv
//  Description   : 发送模型：随机配置输入，产生发送时序，从mem_model中读取数据，发送给DUT
//  Date          : 2016/7/20
//  Author        : WangTao
//==================================================================================================
`timescale 1ns/1ps

task send;
//从各个输入通道的mem_tx中取出数据，组成video_data_in
input   [10:0] h_cnt;    //数据所在的列
input   [10:0] l_cnt;    //数据所在的行
integer       i;
for (int i = 0; i < top.CHANNEL_IN_NUM; i++) begin
    top.video_data_in[i * top.VIDEO_DATA_WIDTH+top.VIDEO_DATA_WIDTH-1 -:top.VIDEO_DATA_WIDTH] = model.mem_tx[i][h_cnt][l_cnt];
    //-：18代表最低位为i*18+17-18
end
endtask

task header;
//vblank_in为高期间，hblank_in在跳变
input integer times;          //hblank_in重复次数
input integer hblank_h;       //hblank_in高电平时间
begin
    repeat(times) begin
        repeat(hblank_h) begin
            @(posedge top.ch_clk) begin end
            top.hblank_in       = {top.CHANNEL_IN_NUM{1'b1}};
            top.vblank_in       = {top.CHANNEL_IN_NUM{1'b1}};
            top.active_video_in = {top.CHANNEL_IN_NUM{1'b0}};
            top.video_data_in   = 0;
        end
        repeat(top.mode*2*top.col_start+top.col_max) begin
            @(posedge top.ch_clk) begin end
            top.hblank_in       = {top.CHANNEL_IN_NUM{1'b0}};
        end
    end
end
endtask

task TX;
//产生发送时序，将video_data_in发送给DUT
input integer   tx_num;       //发送多少帧数据
reg   [10:0]    h_cnt;        //从mem_tx中取数据时的行计数器
reg   [10:0]    l_cnt;        //从mem_tx中取数据时的列计数器
reg             border;       //边界情况指示信号
reg             hblank_err;   //最后一个hblank_in低电平时间是正常的1-5倍
integer         hblank_h;     //hblank消隐信号持续时间
integer         i;
integer         seed;
integer         mode_cnt;
integer         border_cnt;
seed      = 0;
mode_cnt  = 0;
hblank_h  = 2*top.OVERLAP_WIDTH + 5;

for(i = 0;i < tx_num;i = i + 1) begin
    $display("-----------------------------------%8d        -----------------------------------",i+1);
    border        = {$random()}%10/9;            //1:边界情况；0：非边界情况
    hblank_err    = {$random()}%10/9;            //hblank_in周期异常
    top.mode      = !({$random()}%10/8);
    top.sel       = {$random()}%2;
    top.row_max   = $dist_uniform(seed,50,950);  //数据块有效数据行数
    top.col_max   = $dist_uniform(seed,50,950);  //每行有效数据列数
    mode_cnt      = mode_cnt + top.mode;         //记录有多少帧数据是正常模式
    if(border) begin
    //row_start=0,col_start=0,不发送无效行，无效列
        top.row_start = 0;
        top.col_start = 0;
    end
    else begin
    //非边界情况
        top.row_start = {$random()}%50;
        top.col_start = {$random()}%50;
    end
    top.col_end       = top.col_max + top.col_start - 1;
    top.row_end       = top.row_max + top.row_start - 1;
    #1;
    @(posedge top.ch_clk) begin end
    //对输入初始化
        h_cnt               = 10'd0;
        l_cnt               = 0;
        model.mem_init();       //初始化数据块
        model.dig_mem();        //生成数据块模型
    header({$random()}%20 + 2,hblank_h);     //产生vblank_in=1，hblank_in在跳变的时序
    if(top.mode) begin
        //正常模式下，需要先发row_start行无效数据
        repeat(top.row_start) begin
            repeat(hblank_h) begin           //hblank_in高电平持续hblank_h个时钟
                @(posedge top.ch_clk) begin end //产生hblamk_in上升沿
                    top.hblank_in       = {top.CHANNEL_IN_NUM{1'b1}};
                    top.vblank_in       = {top.CHANNEL_IN_NUM{1'b0}};
                    top.active_video_in = {top.CHANNEL_IN_NUM{1'b0}};
            end
            repeat(top.col_max + 2 * top.col_start) begin//每行有这么多个数据
                @(posedge top.ch_clk) begin end
                    top.hblank_in       = 0;
                    top.active_video_in = {top.CHANNEL_IN_NUM{1'b1}};
                    top.video_data_in[top.CHANNEL_IN_NUM*18-1:0] = $random();
            end
        end
    end

    //开始发送有效行数据
    repeat(top.row_max) begin
        repeat(hblank_h) begin //发送hblank_in高电平脉冲
            @(posedge top.ch_clk) begin end
                top.hblank_in       = {top.CHANNEL_IN_NUM{1'b1}};
                top.vblank_in       = {top.CHANNEL_IN_NUM{1'b0}};
                top.active_video_in = {top.CHANNEL_IN_NUM{1'b0}};
        end
        repeat(top.col_start * (top.mode)) begin //正常模式下先发送无效数据
            @(posedge top.ch_clk) begin end
                top.hblank_in       = {top.CHANNEL_IN_NUM{1'b0}};
                top.active_video_in = {top.CHANNEL_IN_NUM{1'b1}};
                top.video_data_in[top.CHANNEL_IN_NUM*18-1:0] = $random();
        end
        l_cnt = 0;
        repeat(top.col_max) begin//发送有效数据
            @(posedge top.ch_clk) begin end
                top.hblank_in       = {top.CHANNEL_IN_NUM{1'b0}};
                top.active_video_in = {top.CHANNEL_IN_NUM{1'b1}};
                send(h_cnt,l_cnt);
                l_cnt++;
        end
        h_cnt++;
        repeat(top.col_start * (top.mode)) begin //正常模式下还要发送col_start列无效数据
            @(posedge top.ch_clk) begin end
                top.hblank_in       = {top.CHANNEL_IN_NUM{1'b0}};
                top.active_video_in = {top.CHANNEL_IN_NUM{1'b1}};
                top.video_data_in[top.CHANNEL_IN_NUM*18-1:0] = $random();
        end
    end
    $display("%5d frame effect data sent to DUT complete!",i+1);

    //正常模式需要再发送无效行
    repeat(top.row_start*top.mode) begin    //发送row_start行无效行数据
        repeat(hblank_h) begin              //hblank_in高电平持续hblank_h个时钟
            @(posedge top.ch_clk) begin end //产生hblamk_in上升沿
                top.hblank_in       = {top.CHANNEL_IN_NUM{1'b1}};
                top.active_video_in = {top.CHANNEL_IN_NUM{1'b0}};
        end
        repeat(top.col_max + 2 * top.col_start) begin//每行有这么多个数据
            @(posedge top.ch_clk) begin end
                top.hblank_in       = {top.CHANNEL_IN_NUM{1'b0}};
                top.active_video_in = {top.CHANNEL_IN_NUM{1'b1}};
                top.video_data_in[top.CHANNEL_IN_NUM*18-1:0] = $random();
        end
    end
    if(hblank_err) begin
    //最后一行的hblank_in低电平是正常的1-5倍
        repeat(({$random()}%5+1)*(top.col_max+2*top.col_start*top.mode)) begin
            @(posedge top.ch_clk) begin end
                top.hblank_in       = {top.CHANNEL_IN_NUM{1'b0}};
                top.vblank_in       = {top.CHANNEL_IN_NUM{1'b1}};
                top.active_video_in = {top.CHANNEL_IN_NUM{1'b0}};
        end
    end
    @(posedge top.ch_clk) begin end
        top.hblank_in       = {top.CHANNEL_IN_NUM{1'b1}};
        top.vblank_in       = {top.CHANNEL_IN_NUM{1'b1}};
        top.active_video_in = {top.CHANNEL_IN_NUM{1'b0}};

    wait (top.vblank_out[0]==1'b1); //必须等到DUT发完一帧数据，才能给DUT发送下一帧数据
    repeat($dist_uniform(seed,1000,1200)) begin
        @(posedge top.ch_clk) begin end
    end
    seed = $time();
end
$display("%5d frame data were combined successful.%5d frame are normal mode",tx_num,mode_cnt);
$finish;

endtask