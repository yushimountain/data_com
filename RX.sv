//==================================================================================================
//  Copyright     : 重庆宜时宜景公司
//  Filename      : RX.sv
//  Description   : 接收模型：接收DUT的输出数据，与参考模型作对比
//  Date          : 2016/7/20
//  Author        : WangTao
//==================================================================================================

`timescale 1ns/1ps

task RX();
reg [30:0] data_cnt;  //当前接收的数据在模板mem_refer中所处位置
reg [9:0] h_cnt;      //统计接收了多少行
reg [9:0] frame_cnt;  //统计接收了多少帧数据
integer   i;
integer   handle;     //文件句柄，将每次仿真的参数导入txt
reg       data_err;   //接收数据错误标志
h_cnt    = 0;
data_cnt = 0;
data_err = 0;
frame_cnt= 0;

handle = $fopen("data_com_conf.txt","a+");
//$fdisplay(handle,"CHANNEL_IN\tCHANNEL_OUT\tHEAD_DIR\tTOP_BOTTOM\tOUTPUT_DIR\tFRAME_EN\tOVERLAP_WIDTH\tcol_start\tcol_end\trow_start\trow_end");
forever begin
    #1;
    if((top.vblank_out[0] == 1'd1) && (h_cnt != 0)) begin
    //DUT一帧数据发送完成
        h_cnt    = 0;
        data_cnt = 0;
        $fdisplay(handle,"%0d\t%0d\t%0d\t%0d\t%0h\t%0d\t%0d\t%0d\t%0d\t%0d\t%0d",
                top.CHANNEL_IN_NUM,top.CHANNEL_OUT_NUM,top.HEAD_DIRECTION,top.TOP_BOTTOM_SEL,
                top.OUTPUT_DIRECTION,top.FRAME_RAM_EN,top.OVERLAP_WIDTH,top.row_start,top.row_end,top.col_start,top.col_end);
        $display("%5d FRAME data combination success!!",++frame_cnt);
        $display("    CHANNEL_IN  CHANNEL_OUT  HEAD_DIR  TOP_BOTTOM  OUTPUT_DIR  FRAME_EN");
        $display("%10d%11d%12d%11d\t\t\t\t\t\t%8h%11d",
                top.CHANNEL_IN_NUM,top.CHANNEL_OUT_NUM,top.HEAD_DIRECTION,top.TOP_BOTTOM_SEL,top.OUTPUT_DIRECTION,top.FRAME_RAM_EN);
        $display("       mode      row_start   row_end   col_start    col_end      border    hblank_err");
        $display("%9d%13d%12d%10d%13d%11d%9d",top.mode,top.row_start,top.row_end,top.col_start,top.col_end,TX.border,TX.hblank_err);
        $write("\n");
    end
    @(posedge top.active_video_out[0]) begin end
    #1;
    while(top.active_video_out[0] == 1'b1) begin //此时开始接收数据
        for (int i = 0; i < top.CHANNEL_OUT_NUM; i++) begin
            if(top.video_data_out[i*top.VIDEO_DATA_WIDTH+top.VIDEO_DATA_WIDTH-1 -:top.VIDEO_DATA_WIDTH] != model.mem_refer[i][data_cnt]) begin
                $display("channel %0d output wrong num%d not equals to %d",
                i,top.video_data_out[i*top.VIDEO_DATA_WIDTH+top.VIDEO_DATA_WIDTH-1 -:top.VIDEO_DATA_WIDTH],model.mem_refer[i][data_cnt]);
                $display("i=%d,data_cnt=%d",i,data_cnt);
                data_err = 1;
            end
        end
        if(data_err) begin
            repeat(10) begin
                @(posedge top.ch_clk) begin end
            end
             $display("data combination failed!\n    CHANNEL_IN  CHANNEL_OUT  HEAD_DIR  TOP_BOTTOM  OUTPUT_DIR  FRAME_EN");
             $display("%10d%11d%12d%11d%12h%11d",
                top.CHANNEL_IN_NUM,top.CHANNEL_OUT_NUM,top.HEAD_DIRECTION,top.TOP_BOTTOM_SEL,top.OUTPUT_DIRECTION,top.FRAME_RAM_EN);
            $display("       mode      row_start   row_end   col_start    col_end      border    hblank_err");
            $display("%9d%13d%12d%10d%13d%11d%9d",top.mode,top.row_start,top.row_end,top.col_start,top.col_end,TX.border,TX.hblank_err);
            $display("     row_max      col_max");
            $display("%9d%13d",top.row_max,top.col_max);
            $finish;
        end
        @(posedge top.clk) begin end
        #1;
        data_cnt++;
    end
    h_cnt++;
end
endtask