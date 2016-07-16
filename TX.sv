//==================================================================================================
//  Copyright     : ������ʱ�˾���˾
//  Filename      : TX.sv
//  Description   : ����ģ�ͣ�����������룬��������ʱ�򣬴�mem_model�ж�ȡ���ݣ����͸�DUT
//  Date          : 2016/7/20
//  Author        : WangTao
//==================================================================================================
`timescale 1ns/1ps

task send;
//�Ӹ�������ͨ����mem_tx��ȡ�����ݣ����video_data_in
input   [10:0] h_cnt;    //�������ڵ���
input   [10:0] l_cnt;    //�������ڵ���
integer       i;
for (int i = 0; i < top.CHANNEL_IN_NUM; i++) begin
    top.video_data_in[i * top.VIDEO_DATA_WIDTH+top.VIDEO_DATA_WIDTH-1 -:top.VIDEO_DATA_WIDTH] = model.mem_tx[i][h_cnt][l_cnt];
    //-��18�������λΪi*18+17-18
end
endtask

task header;
//vblank_inΪ���ڼ䣬hblank_in������
input integer times;          //hblank_in�ظ�����
input integer hblank_h;       //hblank_in�ߵ�ƽʱ��
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
//��������ʱ�򣬽�video_data_in���͸�DUT
input integer   tx_num;       //���Ͷ���֡����
reg   [10:0]    h_cnt;        //��mem_tx��ȡ����ʱ���м�����
reg   [10:0]    l_cnt;        //��mem_tx��ȡ����ʱ���м�����
reg             border;       //�߽����ָʾ�ź�
reg             hblank_err;   //���һ��hblank_in�͵�ƽʱ����������1-5��
integer         hblank_h;     //hblank�����źų���ʱ��
integer         i;
integer         seed;
integer         mode_cnt;
integer         border_cnt;
seed      = 0;
mode_cnt  = 0;
hblank_h  = 2*top.OVERLAP_WIDTH + 5;

for(i = 0;i < tx_num;i = i + 1) begin
    $display("-----------------------------------%8d        -----------------------------------",i+1);
    border        = {$random()}%10/9;            //1:�߽������0���Ǳ߽����
    hblank_err    = {$random()}%10/9;            //hblank_in�����쳣
    top.mode      = !({$random()}%10/8);
    top.sel       = {$random()}%2;
    top.row_max   = $dist_uniform(seed,50,950);  //���ݿ���Ч��������
    top.col_max   = $dist_uniform(seed,50,950);  //ÿ����Ч��������
    mode_cnt      = mode_cnt + top.mode;         //��¼�ж���֡����������ģʽ
    if(border) begin
    //row_start=0,col_start=0,��������Ч�У���Ч��
        top.row_start = 0;
        top.col_start = 0;
    end
    else begin
    //�Ǳ߽����
        top.row_start = {$random()}%50;
        top.col_start = {$random()}%50;
    end
    top.col_end       = top.col_max + top.col_start - 1;
    top.row_end       = top.row_max + top.row_start - 1;
    #1;
    @(posedge top.ch_clk) begin end
    //�������ʼ��
        h_cnt               = 10'd0;
        l_cnt               = 0;
        model.mem_init();       //��ʼ�����ݿ�
        model.dig_mem();        //�������ݿ�ģ��
    header({$random()}%20 + 2,hblank_h);     //����vblank_in=1��hblank_in�������ʱ��
    if(top.mode) begin
        //����ģʽ�£���Ҫ�ȷ�row_start����Ч����
        repeat(top.row_start) begin
            repeat(hblank_h) begin           //hblank_in�ߵ�ƽ����hblank_h��ʱ��
                @(posedge top.ch_clk) begin end //����hblamk_in������
                    top.hblank_in       = {top.CHANNEL_IN_NUM{1'b1}};
                    top.vblank_in       = {top.CHANNEL_IN_NUM{1'b0}};
                    top.active_video_in = {top.CHANNEL_IN_NUM{1'b0}};
            end
            repeat(top.col_max + 2 * top.col_start) begin//ÿ������ô�������
                @(posedge top.ch_clk) begin end
                    top.hblank_in       = 0;
                    top.active_video_in = {top.CHANNEL_IN_NUM{1'b1}};
                    top.video_data_in[top.CHANNEL_IN_NUM*18-1:0] = $random();
            end
        end
    end

    //��ʼ������Ч������
    repeat(top.row_max) begin
        repeat(hblank_h) begin //����hblank_in�ߵ�ƽ����
            @(posedge top.ch_clk) begin end
                top.hblank_in       = {top.CHANNEL_IN_NUM{1'b1}};
                top.vblank_in       = {top.CHANNEL_IN_NUM{1'b0}};
                top.active_video_in = {top.CHANNEL_IN_NUM{1'b0}};
        end
        repeat(top.col_start * (top.mode)) begin //����ģʽ���ȷ�����Ч����
            @(posedge top.ch_clk) begin end
                top.hblank_in       = {top.CHANNEL_IN_NUM{1'b0}};
                top.active_video_in = {top.CHANNEL_IN_NUM{1'b1}};
                top.video_data_in[top.CHANNEL_IN_NUM*18-1:0] = $random();
        end
        l_cnt = 0;
        repeat(top.col_max) begin//������Ч����
            @(posedge top.ch_clk) begin end
                top.hblank_in       = {top.CHANNEL_IN_NUM{1'b0}};
                top.active_video_in = {top.CHANNEL_IN_NUM{1'b1}};
                send(h_cnt,l_cnt);
                l_cnt++;
        end
        h_cnt++;
        repeat(top.col_start * (top.mode)) begin //����ģʽ�»�Ҫ����col_start����Ч����
            @(posedge top.ch_clk) begin end
                top.hblank_in       = {top.CHANNEL_IN_NUM{1'b0}};
                top.active_video_in = {top.CHANNEL_IN_NUM{1'b1}};
                top.video_data_in[top.CHANNEL_IN_NUM*18-1:0] = $random();
        end
    end
    $display("%5d frame effect data sent to DUT complete!",i+1);

    //����ģʽ��Ҫ�ٷ�����Ч��
    repeat(top.row_start*top.mode) begin    //����row_start����Ч������
        repeat(hblank_h) begin              //hblank_in�ߵ�ƽ����hblank_h��ʱ��
            @(posedge top.ch_clk) begin end //����hblamk_in������
                top.hblank_in       = {top.CHANNEL_IN_NUM{1'b1}};
                top.active_video_in = {top.CHANNEL_IN_NUM{1'b0}};
        end
        repeat(top.col_max + 2 * top.col_start) begin//ÿ������ô�������
            @(posedge top.ch_clk) begin end
                top.hblank_in       = {top.CHANNEL_IN_NUM{1'b0}};
                top.active_video_in = {top.CHANNEL_IN_NUM{1'b1}};
                top.video_data_in[top.CHANNEL_IN_NUM*18-1:0] = $random();
        end
    end
    if(hblank_err) begin
    //���һ�е�hblank_in�͵�ƽ��������1-5��
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

    wait (top.vblank_out[0]==1'b1); //����ȵ�DUT����һ֡���ݣ����ܸ�DUT������һ֡����
    repeat($dist_uniform(seed,1000,1200)) begin
        @(posedge top.ch_clk) begin end
    end
    seed = $time();
end
$display("%5d frame data were combined successful.%5d frame are normal mode",tx_num,mode_cnt);
$finish;

endtask