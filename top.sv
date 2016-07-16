//==================================================================================================
//  Copyright     : 重庆宜时宜景公司
//  Filename      : top.sv
//  Description   : TB顶层，包含发送模型、接收模型、仿真模型、时序检查模型
//  Date          : 2016/7/20
//  Author        : WangTao
//==================================================================================================
 `timescale 1ns/1ns
 module top ();

  `include "E:/FPGA/Project/gangyu/TB/TX.sv"
  `include "E:/FPGA/Project/gangyu/TB/RX.sv"
  `include "E:/FPGA/Project/gangyu/TB/timing_check.sv"
 parameter      CHANNEL_IN_NUM  = 2;                             //输入数据块数量
 parameter      CHANNEL_OUT_NUM = 1;                             //输出数据块数量
 parameter      HEAD_DIRECTION  = 1;
 parameter      TOP_BOTTOM_SEL  = 0;                             //输入数据块由上、下部分组成标识
 parameter      FRAME_RAM_EN    = 1;                             //帧缓存使能，1：不进行行缓存，0：进行行缓存
 parameter      OUTPUT_DIRECTION= 0;                             //输入数据块的读出方向，0：从左向右读，1：从右向左读

 parameter      OVERLAP_WIDTH   = 4;                             //输出数据块交叠宽度

 parameter      VIDEO_DATA_WIDTH= 30;                            //视频数据信号宽度，默认是18bit
 parameter      TIMING_CNT_WIDTH= 11;                            //行、列计数器信号宽度
 parameter      RAM_DEPTH       = 1024;                          //RAM缓存深度
 reg                                           sclr;             //同步清零信号
 reg                                           ce;               //时钟使能信号，0：时钟有效，1：时钟失能
 reg                                           ch_clk;           //模块接收数据时钟
 reg                                           clk;              //模块发送数据时钟
 reg [CHANNEL_IN_NUM-1'b1:0]                   hblank_in;        //行消隐信号
 reg [CHANNEL_IN_NUM-1'b1:0]                   vblank_in;        //列消隐信号
 reg [CHANNEL_IN_NUM-1'b1:0]                   active_video_in;  //数据有效信号
 reg [CHANNEL_IN_NUM*VIDEO_DATA_WIDTH-1'b1:0]  video_data_in;    //输入数据
 reg                                           mode;             //1：正常模式；0：测试模式
 reg                                           sel;              //输出无效数据时填充选择0：填充无效数据；1：填充0

 reg [TIMING_CNT_WIDTH-1'b1:0]                 col_start;        //接收每一行有效数据时列开始位置0~col_start为无效数据
 reg [TIMING_CNT_WIDTH-1'b1:0]                 col_end;          //接收每一行有效数据列结束位置
 reg [TIMING_CNT_WIDTH-1'b1:0]                 row_start;        //接收有效数据行开始位置
 reg [TIMING_CNT_WIDTH-1'b1:0]                 row_end;          //最后一行有效数据
 reg [9:0]                                     col_max;          //每个数据块一行的数据个数计数最大值
 reg [9:0]                                     row_max;          //每个数据块有多少行数据

 wire[CHANNEL_OUT_NUM-1'b1:0]                  hblank_out;       //行消隐信号
 wire[CHANNEL_OUT_NUM-1'b1:0]                  vblank_out;       //列消隐信号
 wire[CHANNEL_OUT_NUM-1'b1:0]                  active_video_out; //发送数据有效信号
 wire[CHANNEL_OUT_NUM*VIDEO_DATA_WIDTH-1'b1:0] video_data_out;   //输出数据


 parameter CLK_PERIOD = 10;         //clk时钟周期
 parameter N = CHANNEL_IN_NUM/CHANNEL_OUT_NUM;
 always #(CLK_PERIOD*N/2) ch_clk = ~ch_clk;
 initial begin
 //clk上升沿滞后ch_clk上升沿1ns
    @(posedge ch_clk) begin end
    #1;
    clk = ~clk;
    forever begin
        #(CLK_PERIOD/2) clk = ~clk;
    end
 end

 initial begin
     sclr             = 1'b0;
     ce               = 1'b0;
     clk              = 1'b0;
     ch_clk           = 1'b0;
     hblank_in        = {CHANNEL_IN_NUM{1'b1}};
     vblank_in        = {CHANNEL_IN_NUM{1'b1}};
     active_video_in  = {CHANNEL_IN_NUM{1'b0}};
     video_data_in    = 0;
     mode             = 1'b1;
     sel              = 1'b1;
     col_start        = 10'd0;
     row_start        = 10'd0;
     row_max          = 10'd40;
     col_max          = 10'd100;
     col_end          = col_start + col_max - 1'd1;
     row_end          = row_start + row_max - 1'd1;
     @(posedge ch_clk) begin end
     sclr             = 1'b1;
     @(posedge ch_clk) begin end
     sclr             = 1'b0;
     ce               = 1'b1;
 end

 initial begin
    @(negedge sclr) begin end
    fork
        TX(200);
        RX();
        timing_check();
    join
 end

mem_model #(
//仿真模型
    .HEAD_DIRECTION  (HEAD_DIRECTION),
    .CHANNEL_IN_NUM  (CHANNEL_IN_NUM),
    .CHANNEL_OUT_NUM (CHANNEL_OUT_NUM),
    .VIDEO_DATA_WIDTH (VIDEO_DATA_WIDTH),
    .OUTPUT_DIRECTION(OUTPUT_DIRECTION),
    .OVERLAP_WIDTH   (OVERLAP_WIDTH),
    .TOP_BOTTOM_SEL  (TOP_BOTTOM_SEL),
    .FRAME_RAM_EN    (FRAME_RAM_EN),
    .RAM_DEPTH       (RAM_DEPTH)
    ) model(
    .mode(mode),
    .col_max(col_max),
    .row_max(row_max)
);

 data_com #(
    .HEAD_DIRECTION   (HEAD_DIRECTION),
    .CHANNEL_IN_NUM   (CHANNEL_IN_NUM),
    .CHANNEL_OUT_NUM  (CHANNEL_OUT_NUM),
    .VIDEO_DATA_WIDTH (VIDEO_DATA_WIDTH),
    .TIMING_CNT_WIDTH (TIMING_CNT_WIDTH),
    .RAM_DEPTH        (RAM_DEPTH),
    .OVERLAP_WIDTH    (OVERLAP_WIDTH),
    .TOP_BOTTOM_SEL   (TOP_BOTTOM_SEL),
    .OUTPUT_DIRECTION (OUTPUT_DIRECTION),
    .FRAME_RAM_EN     (FRAME_RAM_EN)
    ) DUT(
    .sclr(sclr),
    .ce(ce),
    .clk(clk),
    .ch_clk(ch_clk),

    .hblank_in(hblank_in),
    .vblank_in(vblank_in),
    .active_video_in(active_video_in),
    .video_data_in(video_data_in),


    .hblank_out(hblank_out),
    .vblank_out(vblank_out),
    .active_video_out(active_video_out),
    .video_data_out(video_data_out),
    .mode(mode),
    .sel(sel),

    .col_start(col_start),
    .col_end(col_end),
    .row_start(row_start),
    .row_end(row_end)
 );
 endmodule