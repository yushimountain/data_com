//==================================================================================================
//  Copyright     : 重庆宜时宜景公司
//  Filename      : timing_check.sv
//  Description   : 时序检查模型：检查hblank_in和hblank_out周期是否一致、DUT是否产生输出时序
//  Date          : 2016/7/20
//  Author        : WangTao
//==================================================================================================


task timing_check();

integer   timea_i;//计算hblank_in周期
integer   timeb_i;
integer   hblank_in_t;
integer   timea_o;//计算hblank_out周期
integer   timeb_o;
integer   hblank_out_t;
integer   active_out_cnt;

active_out_cnt = 0;
fork
    forever begin
    //检查vblank_in=0期间hblank_in的周期
    #1;
    @(negedge top.vblank_in) begin end
    while(!top.vblank_in[0]) begin
        @(posedge top.hblank_in[0]) begin end
            timea_i = $time();
            #1;
            if(top.vblank_in[0]) begin
            //若上面的hblank_in是最后一个上升沿，跳出循环
                break;
            end
        @(posedge top.hblank_in[0]) begin end
            timeb_i = $time();
            hblank_in_t = timeb_i - timea_i;
        end
    end

    forever begin
    //检查vblank_out期间hblank_out的周期
    #1;
    @(negedge top.vblank_out[0]) begin end
    while(!top.vblank_out[0]) begin
        @(posedge top.hblank_out[0]) begin end
            timea_o = $time();
            #1;
            if(top.vblank_out[0]) begin
            //若上面的hblank_out是最后一个上升沿，跳出循环
                break;
            end
        @(posedge top.hblank_out[0]) begin end
            timeb_o = $time();
            hblank_out_t = timeb_o - timea_o;
            if((hblank_out_t != hblank_in_t) && (!top.vblank_in[0])) begin
                $display("Period of hblank_in%0d and hblank_out%0d not equal!!!",hblank_in_t,hblank_out_t);
                $finish;
            end
        end
    end

    forever begin
    //检查输出时序是否产生，vblank_in期间对active_out计数，若大于零，则产生了输出时序
        #1;
        @(negedge top.vblank_in[0]) begin end
        while(!top.vblank_in[0]) begin
            #1;
            if(top.active_video_out) begin
                active_out_cnt++;
            end
        end
        if(active_out_cnt == 0) begin
            $display("Timing error:data was not output!!!");
            $finish;
        end
        active_out_cnt = 0;
    end
join

endtask