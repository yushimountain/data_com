//==================================================================================================
//  Copyright     : ������ʱ�˾���˾
//  Filename      : top.sv
//  Description   : TB���㣬��������ģ�͡�����ģ�͡�����ģ�͡�ʱ����ģ��
//  Date          : 2016/7/20
//  Author        : WangTao
//==================================================================================================
 `timescale 1ns/1ns
 module top ();

  `include "E:/FPGA/Project/gangyu/TB/TX.sv"
  `include "E:/FPGA/Project/gangyu/TB/RX.sv"
  `include "E:/FPGA/Project/gangyu/TB/timing_check.sv"
 parameter      CHANNEL_IN_NUM  = 2;                             //�������ݿ�����
 parameter      CHANNEL_OUT_NUM = 1;                             //������ݿ�����
 parameter      HEAD_DIRECTION  = 1;
 parameter      TOP_BOTTOM_SEL  = 0;                             //�������ݿ����ϡ��²�����ɱ�ʶ
 parameter      FRAME_RAM_EN    = 1;                             //֡����ʹ�ܣ�1���������л��棬0�������л���
 parameter      OUTPUT_DIRECTION= 0;                             //�������ݿ�Ķ�������0���������Ҷ���1�����������

 parameter      OVERLAP_WIDTH   = 4;                             //������ݿ齻�����

 parameter      VIDEO_DATA_WIDTH= 30;                            //��Ƶ�����źſ�ȣ�Ĭ����18bit
 parameter      TIMING_CNT_WIDTH= 11;                            //�С��м������źſ��
 parameter      RAM_DEPTH       = 1024;                          //RAM�������
 reg                                           sclr;             //ͬ�������ź�
 reg                                           ce;               //ʱ��ʹ���źţ�0��ʱ����Ч��1��ʱ��ʧ��
 reg                                           ch_clk;           //ģ���������ʱ��
 reg                                           clk;              //ģ�鷢������ʱ��
 reg [CHANNEL_IN_NUM-1'b1:0]                   hblank_in;        //�������ź�
 reg [CHANNEL_IN_NUM-1'b1:0]                   vblank_in;        //�������ź�
 reg [CHANNEL_IN_NUM-1'b1:0]                   active_video_in;  //������Ч�ź�
 reg [CHANNEL_IN_NUM*VIDEO_DATA_WIDTH-1'b1:0]  video_data_in;    //��������
 reg                                           mode;             //1������ģʽ��0������ģʽ
 reg                                           sel;              //�����Ч����ʱ���ѡ��0�������Ч���ݣ�1�����0

 reg [TIMING_CNT_WIDTH-1'b1:0]                 col_start;        //����ÿһ����Ч����ʱ�п�ʼλ��0~col_startΪ��Ч����
 reg [TIMING_CNT_WIDTH-1'b1:0]                 col_end;          //����ÿһ����Ч�����н���λ��
 reg [TIMING_CNT_WIDTH-1'b1:0]                 row_start;        //������Ч�����п�ʼλ��
 reg [TIMING_CNT_WIDTH-1'b1:0]                 row_end;          //���һ����Ч����
 reg [9:0]                                     col_max;          //ÿ�����ݿ�һ�е����ݸ����������ֵ
 reg [9:0]                                     row_max;          //ÿ�����ݿ��ж���������

 wire[CHANNEL_OUT_NUM-1'b1:0]                  hblank_out;       //�������ź�
 wire[CHANNEL_OUT_NUM-1'b1:0]                  vblank_out;       //�������ź�
 wire[CHANNEL_OUT_NUM-1'b1:0]                  active_video_out; //����������Ч�ź�
 wire[CHANNEL_OUT_NUM*VIDEO_DATA_WIDTH-1'b1:0] video_data_out;   //�������


 parameter CLK_PERIOD = 10;         //clkʱ������
 parameter N = CHANNEL_IN_NUM/CHANNEL_OUT_NUM;
 always #(CLK_PERIOD*N/2) ch_clk = ~ch_clk;
 initial begin
 //clk�������ͺ�ch_clk������1ns
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
//����ģ��
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