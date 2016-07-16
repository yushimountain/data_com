//=================================================================================================
//  Company       : LVIT Ltd.
//  Filename      : receive.v
//  Description   : ���ݽ���ģ��
//  Date          : 2016��7��12�� 10:22:46
//  Author        : PanShen
//=================================================================================================

`timescale 1ns/1ps

// `define  DEBUG_MODE

module receive (
    channel,    //ͨ�����
    sclr,
    ce,
    mode,
    ch_clk,
    clk,

    hblank_in,
    vblank_in,
    active_video_in,

    row_start,
    row_end,
    col_start,
    col_end,
    //to data save
    wr_addr1,
    wr_addr2,
    pp_flagw,
    pp_flagr,
    effect_reigon,
    //to send
    send_start,//receive --> send֪ͨsend.v��ʼ����������
    col_max,   //receive --> send,��֪send��ʼ�ǶεĿ��
    row_max,

`ifdef DEBUG_MODE
    col_cnt,
    row_cnt,
`endif
    hblank_low ///receive --> send,��֪send����ģʽ��Ч���ݿ��
);


parameter CHANNEL_IN_NUM   = 4;     //�������ݿ�����2^6 == 63
parameter CHANNEL_OUT_NUM  = 1;     //������ݿ�����
parameter VIDEO_DATA_WIDTH = 18;    //��Ƶ�����źſ��
parameter RAM_DEPTH        = 100;   //�л���ram���
parameter TIMING_CNT_WIDTH = 10;    //�С��м������źſ��
parameter OVERLAP_WIDTH    = 2;     //������ݿ齻����
parameter TOP_BOTTOM_SEL   = 1'd1;  //�������ݿ����ϡ��²�����ɱ�ʶ
parameter HEAD_DIRECTION   = 1'd0;  //��ͷ����0ȫ��,1ȫ��,2�԰��
parameter FRAME_RAM_EN     = 1'd0;  //֡����ʹ��
//һ�����Ϳ�������ٸ�����飬���������������Ķ��ٱ�
localparam TIMES           = CHANNEL_IN_NUM/CHANNEL_OUT_NUM;
//����RAM������ɣ�RAM������ַ���
localparam ADDR_WIDTH      = clogb2(RAM_DEPTH - 1);//addra,addrb width
localparam OVERLAP_W       = clogb2(OVERLAP_WIDTH + 1);

`ifdef  DEBUG_MODE

output [TIMING_CNT_WIDTH-1'b1:0]    col_cnt;        //send <-- receive
output [TIMING_CNT_WIDTH-1'b1:0]    row_cnt;        //send <-- receive������ģʽ��

wire                                hbi_high;
wire                                hblank_err;
`endif

input [5:0]                         channel;
input                               sclr;
input                               ce;
input                               mode;
input                               ch_clk;
input                               clk;            //faster than ch_clk

input                               hblank_in;
input                               vblank_in;
input                               active_video_in;

//�����ĸ�������Ͻ�����м�����ȷ����Ч��������
input [TIMING_CNT_WIDTH-1'b1:0]     row_start;
input [TIMING_CNT_WIDTH-1'b1:0]     row_end;
input [TIMING_CNT_WIDTH-1'b1:0]     col_start;
input [TIMING_CNT_WIDTH-1'b1:0]     col_end;
//����֪ͨ����ģ�鿪ʼ����
output                              send_start;     //send <-- receive
//hblank_inһ�����ֵ��ͬ��ʹhblank_out����һ����һ���������ڵ�ʱ��
output [TIMING_CNT_WIDTH-1'b1:0]    col_max;        //send <-- receive
output [TIMING_CNT_WIDTH-1'b1:0]    row_max;        //send <-- receive������ģʽ��
output [TIMING_CNT_WIDTH-1'b1:0]    hblank_low;     //send <-- receive
output [ADDR_WIDTH-1'b1:0]          wr_addr1;       //����ָ�룬ram0ʹ��
output [ADDR_WIDTH-1'b1:0]          wr_addr2;       //����ָ�룬ram1ʹ��
output                              pp_flagw;       //дƹ�Ҳ���
output                              pp_flagr;       //��ƹ�Ҳ���
output                              effect_reigon;  //��Ч��
//other reg
reg    [TIMING_CNT_WIDTH-1'b1:0]    row_cnt;        //�м�����
reg    [TIMING_CNT_WIDTH-1'b1:0]    col_cnt;        //�м�����
reg    [TIMING_CNT_WIDTH-1'b1:0]    col_max;        //hblank_inһ�����ֵ�������ߵ�ƽ��
reg    [TIMING_CNT_WIDTH-1'b1:0]    row_max;        //hblank_in��Ч�͵�ƽ�������ֵ
reg    [TIMING_CNT_WIDTH-1'b1:0]    hblank_low;     //active_video_in�͵�ƽ���򳤶ȣ�����ģʽ��

reg    [ADDR_WIDTH-1'b1:0]          wr_addr1;       //����ָ�룬ram0ʹ��
reg    [ADDR_WIDTH-1'b1:0]          wr_addr2;       //����ָ�룬ram1ʹ��
reg    [OVERLAP_W-1:0]              row_save_cnt1;  //ָʾ�Ѿ����˼�������
reg    [OVERLAP_W-1:0]              row_save_cnt2;  //ָʾ�Ѿ����˼�������
reg                                 send_start;     //����send��ʼ������
reg                                 send_once;      //ֻ����һ��send_start
reg                                 col_cnt_en;     //col_cntʹ�ܣ�Ϊ0 �����Ϳ����ݷ������
reg    [OVERLAP_W-1:0]              overlap_cnt;    //����������pp_flag
reg                                 active_sync;    //�����ʱ
reg                                 hblank_sync;
//wire -> reg
reg   [ADDR_WIDTH-1'b1:0]           effect_width;   //��Ч���
reg                                 effect_reigon;  //��Ч����

wire                                active_neg;
wire                                hblank_neg;
wire                                hblank_pos;
reg    [OVERLAP_W-1:0]              row_save;       //��������
reg                                 effect_row;     //����Ч��
//state reg
reg    [2:0]                        cur_state;
reg    [2:0]                        next_state;


reg                                 pp_flagw;       //ƹ�һ����־λ��0:ѡ��ram0, 1:ѡ��ram1
reg                                 pp_flagr;       //ƹ�һ����־λ��0:ѡ��ram0, 1:ѡ��ram1
reg                                 reverse_en;     //�洢�����Ƿ���,����Ч
reg                                 wait_;          //����������ת�۵�ʱ��pp_flagͣ��һ���������ڣ�,����ģʽ��
reg                                 once;
//state machine state data
localparam   IDLE          = 3'b001;                //���еȴ�
localparam   REC           = 3'b010;                //��������״̬
localparam   NXT           = 3'b100;                //����


always @(posedge ch_clk) begin
    if(sclr) begin
        active_sync <= 0;
    end else if(ce) begin
        active_sync <= active_video_in;
    end
end

assign active_neg = (!active_video_in && active_sync) ? 1'b1:1'b0;

always @(posedge ch_clk) begin
    if(sclr) begin
        hblank_sync <= 1;
    end else if(ce) begin
        hblank_sync <= hblank_in;
    end
end

assign hblank_neg = (!hblank_in && hblank_sync) ? 1'b1:1'b0;
assign hblank_pos = (hblank_in && !hblank_sync) ? 1'b1:1'b0;

//״̬����
always@(posedge ch_clk)
begin
    if(sclr)
        cur_state <= IDLE;
    else if(ce)
        cur_state <= next_state;
end

/*
* ״̬��˵��
* IDLE: ���У��ȴ���Ч����
* REC: ���ݽ���״̬
* NXT: ������״̬
*/
//״̬���л�
always@(*)
begin
    if(ce) begin
        case(cur_state)
            IDLE: begin
                //��Ч���ݿ�ʼ��
                if(active_video_in) begin
                    next_state = REC;
                end else begin
                    next_state = IDLE;
                end
            end
            REC: begin
                //һ���������꣬�������߽���
                if(!active_video_in) begin
                    //vblank_in���ߣ�һ֡��������
                    if(vblank_in)
                        next_state = IDLE;
                    else
                        next_state = NXT;
                end else begin
                    next_state = REC;
                end
            end
            NXT: begin
                //active_video_in���ߣ��µ�һ������������
                if(active_video_in) begin
                    next_state = REC;
                end else begin
                    next_state = NXT;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end else begin
        next_state = IDLE;
    end
end


always@(posedge ch_clk)
begin
    if(sclr)begin
        col_cnt_en  <= 1'b0;
        overlap_cnt <= 0;
        once        <= 1'b1;
    end else if(ce) begin
        //���е�����״̬���µ�һ֡����
        if(cur_state == IDLE && next_state == REC) begin
            col_cnt_en  <= 1'b1;
            overlap_cnt <= 0;
        //һ֡ĩβ�����ڷ����ͺ󣬷��Ͷ�ȥRAM��Ҫʹ��pp_flagr�����row_cnt��Ҫ�����������������
        end else if(col_cnt == col_max -1 && next_state == IDLE && row_cnt > row_end + 1 && mode) begin
            overlap_cnt  <= overlap_cnt + 1'b1;
            //ȷ�������з�����ɣ����ڵ͹��Ŀ��ǣ���ʱ�ر�ʹ���ź�
            if(TOP_BOTTOM_SEL && !FRAME_RAM_EN && mode) begin
                if((OVERLAP_WIDTH == overlap_cnt) ||                          //�����ڿ���״̬֮ǰδ���ͽ�����
                  (row_cnt - row_end > OVERLAP_WIDTH) ||                      //�����ڿ���״̬֮ǰ�Ѿ��������
                  (overlap_cnt == OVERLAP_WIDTH + row_end - row_max)) begin   //�����ڿ���״̬֮ǰ�Ѿ����Ͳ��ֽ�����
                    col_cnt_en <= 0;                                          //��ʱ�������
                    once       <= 1'b1;
                end
            end else begin
            //û�н������ر�ʹ��
                col_cnt_en <= 0;
                once       <= 1'b1;
            end
        //����ģʽ��������,,row_cnt > row_max + 1���һ��pp_flagr
        end else if(next_state == IDLE && !mode && row_cnt > row_max + 1) begin
            col_cnt_en <= 0;                                                 //��ʱ�������
            once       <= 1'b1;
        //��һ���͵�ƽʹ�ܣ������֡����
        end else if(!hblank_in && once) begin
            col_cnt_en <= 1'b1;
            once       <= 0;
        end
    end
end


//ÿһ�����ݸ����������������ֵ����
always@(posedge ch_clk)
begin
    if(sclr)begin
        col_cnt    <= 0;
        col_max    <= {TIMING_CNT_WIDTH{1'b1}};         //��ʼ��һ���ϴ�ֵ,��ֹsendģ��״̬�л�����
        hblank_low <= {TIMING_CNT_WIDTH{1'b1}};         //��ʼ��һ���ϴ�ֵ,��ֹsendģ��״̬�л�����
    end
    else if(ce) begin
        case(next_state)
            IDLE: begin
                // col_max��hblank_low�������ᵼ�·��Ͷ˵Ľ�����������������,pp_flagr
                if(hblank_pos  && !vblank_in) begin     //!vbi�������һ��hbiposӰ��
                    hblank_low <= col_cnt + 1;          //�����쳣��Ӱ�쵽��ֵ
                end
                //col_cnt_en==0���������з������
                if(!col_cnt_en) begin
                    col_max <= {TIMING_CNT_WIDTH{1'b1}};//Ӱ��send��gate
                end
                //����������ʹpp_flagr�������������ͽ���
                if(col_cnt == (col_max -1) || hblank_neg) begin
                    col_cnt <= 0;
                end else if(col_cnt_en) begin
                    col_cnt <= col_cnt + 1;
                end else begin
                    col_cnt <= 0;
                end
            end
            REC:begin
                //��IDLE ����> REC
                if(cur_state == IDLE) begin
                    col_cnt <= 0;
                    col_max <= col_cnt + 1;         //����col_cnt�����0��ʼ����(col_start����Ϊ0)����˼�һ
                //��IDLE ����> REC
                end else if(cur_state == NXT) begin
                    col_cnt <= 1'b0;
                end else begin
                    col_cnt <= col_cnt + 1'b1;
                end
            end
            NXT:begin
                //�ߵ�ƽ�ڼ������
                col_cnt <= col_cnt + 1'b1;
            end
            default:begin
                col_cnt <= 0;
            end
        endcase
     end
end

//ÿһ֡�����м���
always@(posedge ch_clk)
begin
    if(sclr)begin
        row_cnt <= 0;
    end
    else if(ce) begin
        //���յ����л��߽�������Ϊ������һ��,effect_width < hblank_lowҪ�󱾿��뽻�������ж����������ظ�����
        if((((next_state == NXT || (next_state == IDLE && effect_width < hblank_low)) && cur_state == REC) ||
           (next_state == IDLE && row_cnt > row_end -1 && col_cnt == effect_width)) && mode) begin  //���������򣬺�������ӣ�wait��Ҫʹ��
            row_cnt <= row_cnt + 1'b1;
        //����ģʽ����Ҫ��row_max�жϣ�
        end else if(((next_state == NXT && cur_state == REC) ||
           (next_state == IDLE && row_cnt > row_max -1 && col_cnt == effect_width)) && !mode) begin //��������ӣ�wait��Ҫʹ��
            row_cnt <= row_cnt + 1'b1;
        //���ͽ�����overlap_cnt����Ҫʹ�ã���ʱ�������㣩
        end else if(next_state == IDLE && !col_cnt_en) begin
            row_cnt <= 0;
        end
    end
end

//�м��������ֵ������ģʽ��hblank_lowһ��������
always@(posedge ch_clk)
begin
    if(sclr)begin
        row_max <= 0;
    end else if(ce) begin
        //��ֹ�ڶ�֡�м������ֵ��С
        if(next_state == REC && cur_state == IDLE) begin
            row_max <=0;
        //next_state == REC,��ֹ����Ϊpp_flagr����������Ч�и���
        end else if(row_max < row_cnt && next_state == REC) begin//��ʱ��С
            row_max <= row_cnt;
        end
     end
end

//send_start�ź����ɣ�֪ͨsendģ�鿪ʼ����
always@(posedge ch_clk)
begin
    if(sclr)begin
        send_start <= 0;
        send_once  <= 1'b1;
    end else if(ce) begin
        //row_cnt == 0 ʱ�򣬽��յ�0�о���������
        if(next_state == IDLE) begin
            send_once  <= 1'b1;
            send_start <= 0;
        //��active_video_in�Է�row_start == 0 ��send_once��֤һ��ֻ����һ��send_start
        end else if(effect_row && active_video_in && send_once && mode) begin
            send_start <= 1'b1;
            send_once  <= 1'b0;
        end else if(active_video_in && send_once && !mode) begin
            send_start <= 1'b1;
            send_once  <= 1'b0;
        end else if(next_state == NXT) begin
        //�������˻ᵼ��send��col_cnt����
            send_start <= 0;
        end
    end
end


//ƹ�Ҳ���д��־λ����
always @(posedge ch_clk) begin
    if(sclr) begin
        pp_flagw <= 1'b1;
    end else if(ce) begin
        //���������õ�������ch clk
        if(col_cnt == col_max-4 && col_max > 4 && mode && row_cnt > row_start) begin
            pp_flagw <= ~pp_flagw;
        end else if(active_neg && !mode) begin
            pp_flagw <= ~pp_flagw;
        end else if(next_state == IDLE && !col_cnt_en) begin//ÿһ֡����һ֡����
            pp_flagw <= 1'b1;
        end
    end
end

//ƹ�Ҷ�������־λ����
//����ַ��ǰhbblank_out_neg����clk��ֵ
//������hblank_out�͵�ƽ�����������,addr,dout����data_save.v
always @(posedge ch_clk) begin
    if(sclr) begin
        pp_flagr <= 1'b1;
        wait_ <= 0;
    end else if(ce) begin
        //���н׶���ͣһ�α任
        if((row_cnt == row_end + 2) && mode) begin
            wait_ <= 1'b1;
        end else begin
            wait_ <= 0;
        end
        //Ҫ��֤���������ʱ�����3clk
        if(col_cnt == col_max - 2 && !wait_) begin
            pp_flagr <= ~pp_flagr;
        //ÿһ֡����һ֡����
        end else if(send_start) begin
            pp_flagr <= 1'b1;
        end
    end
end



//��������
always @(posedge ch_clk) begin
    if(sclr) begin
        //��ֵȫ1ԭ�򣺵�һ�ξ�δʹ�ã���Ϊ��һ������׼��
        row_save_cnt1 <= (TOP_BOTTOM_SEL && !FRAME_RAM_EN && mode) ? ((OVERLAP_WIDTH-1)/2): 0;
        row_save_cnt2 <= (TOP_BOTTOM_SEL && !FRAME_RAM_EN && mode) ? ((OVERLAP_WIDTH-1)/2): 0;
    end else if(ce) begin
        // һ�����ݽ�����ɣ�pp_flagw���ˣ�����������Ҫȡ��
        if(cur_state == REC && next_state == NXT && (row_cnt + 1) >= row_start) begin
            //�������н���,ֻ����һ��,�����ǲ���ģʽ
            if((!(TOP_BOTTOM_SEL && !FRAME_RAM_EN && mode)) || (row_start == 0 && row_cnt == 0)) begin
                row_save_cnt1 <= 0;
                row_save_cnt2 <= 0;
            //Ϊ��һ��������׼��
            end else if((row_cnt + 1 == row_start) || (row_save_cnt1 == row_save && !pp_flagw)) begin
                row_save_cnt1 <= 0;
            //���л���ﵽĿ�꣬���ܵ�ַ����
            end else if(row_save_cnt2 == row_save && pp_flagw) begin
                row_save_cnt2 <= 0;
            end else begin
                //ƹ�ұ�־����������һ��������
                if(!pp_flagw) begin
                    row_save_cnt1 <= row_save_cnt1 +  1;
                end else begin
                    row_save_cnt2 <= row_save_cnt2 +  1;
                end
            end
        end else if(next_state == IDLE) begin
            row_save_cnt1 <= (TOP_BOTTOM_SEL && !FRAME_RAM_EN && mode) ? ((OVERLAP_WIDTH-1)/2): 0;
            row_save_cnt2 <= (TOP_BOTTOM_SEL && !FRAME_RAM_EN && mode) ? ((OVERLAP_WIDTH-1)/2): 0;
        end
    end
end

//�洢ָ���Ƿ�����ݼ���
always @(posedge ch_clk) begin
    if(sclr) begin
        reverse_en <= 0;
    end else if(ce) begin
        if(HEAD_DIRECTION==0) begin
            reverse_en <= 0;
        end else if(HEAD_DIRECTION==1) begin
            reverse_en <= 1;
        end else if(HEAD_DIRECTION == 2) begin
            //һ������
            if(!TOP_BOTTOM_SEL) begin
                if(CHANNEL_IN_NUM == 1) begin//0 !< 0
                    reverse_en <= 0;
                end else if((channel < CHANNEL_IN_NUM/2)) begin
                    reverse_en <= 0;
                end else begin
                    reverse_en <= 1;
                end
            //��������
            end else begin
                //���
                if(CHANNEL_IN_NUM <= 2) begin
                    reverse_en <= 0;
                end else if((channel < CHANNEL_IN_NUM/4) ||(channel >= (CHANNEL_IN_NUM - CHANNEL_IN_NUM/4))) begin
                    reverse_en <= 0;
                //�Ҳ�
                end else if((channel >= CHANNEL_IN_NUM/4) || (channel < (CHANNEL_IN_NUM - CHANNEL_IN_NUM/4))) begin
                    reverse_en <= 1;
                end
            end
        end
    end
end


//����ָ��
always @(posedge ch_clk) begin
    if(sclr) begin
        wr_addr1 <= reverse_en ? effect_width-1:0;
        wr_addr2 <= reverse_en ? effect_width-1:0;
    //��Ч������
    end else if(ce) begin
        // һ�����ݽ�����ɣ���ַ��ֵ
        if(next_state == NXT) begin
            if(pp_flagw) begin
                wr_addr1 <= reverse_en ? (effect_width*(row_save_cnt1 + 1'b1) - 1'b1):(effect_width*row_save_cnt1);
            end else begin
                wr_addr2 <=  reverse_en ? (effect_width*(row_save_cnt2 + 1'b1) - 1'b1):(effect_width*row_save_cnt2);
            end
        //δ�����꣬����Ч������
        end else if(effect_reigon) begin
            if(pp_flagw) begin
                wr_addr1 <= reverse_en ? (wr_addr1 - 1'b1):(wr_addr1 + 1'b1);
            end else begin
                wr_addr2 <= reverse_en ? (wr_addr2 - 1'b1):(wr_addr2 + 1'b1);
            end
        //һ֡���ݽ�����ɣ���ַ����
        end else if(next_state == IDLE) begin
            wr_addr1 <= reverse_en ? effect_width-1:0;
            wr_addr2 <= reverse_en ? effect_width-1:0;
        end
    end
end

always @(posedge ch_clk) begin
    if(sclr) begin
        effect_width  <= 0; //��Ч���
        effect_row    <= 0; //��Ч��
        row_save      <= 0; //ÿ��RAM��������
    end else if(ce) begin
        effect_width  <= mode ? (col_end - col_start + 1'b1):hblank_low;
        effect_row    <= (row_cnt >= row_start) && (row_cnt <= row_end);
        row_save      <= (TOP_BOTTOM_SEL && !FRAME_RAM_EN && mode) ? ((OVERLAP_WIDTH-1)/2):1'b0;
    end
end

//��Ч�����ź�����
always @(posedge ch_clk) begin
    if(sclr) begin
        effect_reigon <= 0;
    end else if(ce) begin
        //����ģʽȡ����col_start,col_end,row_start,row_end
        if(mode) begin
            //col_start > 0ʱ��ÿһ�еĵ�һ�����ݲ���Ҫ����,����ǰ�ƣ�����&& col_cnt < col_end����ͬ
            if(col_start > 0) begin
                //һ���ͷ��ʱ��col_cnt==col_max - 1,���ǲ�Ӧ�ý���
                if((cur_state == IDLE || cur_state == NXT) && next_state ==REC) begin
                    // $display("test effect_reigon = %d %t",effect_reigon,$time());
                    effect_reigon <= 0;
                end else begin
                    effect_reigon <= (col_start - 1 <= col_cnt && col_cnt < col_end &&  effect_row && next_state == REC);
                end
            end else begin
                //col_start = 0��һ���ͷ��ʱ��col_cnt = col_max -1,Ӧ�ý��գ�col��Ч
                if((cur_state == IDLE || cur_state == NXT) && next_state ==REC) begin//=0
                    effect_reigon <= effect_row;
                //col_start = 0, ��ȥÿ�е�һ������֮�������
                end else begin
                    effect_reigon <= (((col_cnt >= 0 && col_cnt < col_end) ||
                                    (col_cnt == col_max-1)) && effect_row && (next_state == REC));
                end
            end
        //����ģʽ����ȫ������
        end else begin
            effect_reigon <= active_video_in;
        end
    end
end

//  The following function calculates the address width based on specified RAM depth
function integer clogb2;
    input integer depth;
    for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
endfunction


`ifdef  DEBUG_MODE
//�ж�hblank_in�ߵ�ƽ�����Ƿ�����
assign hbi_high = (hblank_low-1) <= col_cnt && col_cnt <= (col_max - 2) && row_cnt > 0 ? 1'b1 : 1'b0;
assign hblank_err = hbi_high ? (hblank_in  ? 1'b0:1'b1) : 1'b0;
`endif

endmodule
