//=================================================================================================
//  Company       : LVIT Ltd.
//  Filename      : send.v
//  Description   : ���ݷ���ģ��
//  Date          : 2016��7��12�� 10:22:46
//  Author        : PanShen
//=================================================================================================

module send(
    sclr,
    ce,
    clk,
    mode,
    sel,

    hblank_out,
    vblank_out,
    active_video_out,
    video_data_out,

    row_start,
    row_end,
    col_start,
    col_end,
    switch,

    //for main
    addr_m,
    dout_m,
    enb,
    //for left or right
    addr_sl,
    dout_sl,
    ena_sl,

    addr_sr,
    dout_sr,
    ena_sr,

    col_max,
    row_max,
    hblank_low,
    send_start
);


parameter CHANNEL_IN_NUM   = 4;       //�������ݿ�����2^6 == 63
parameter CHANNEL_OUT_NUM  = 2;       //������ݿ�����
parameter VIDEO_DATA_WIDTH = 18;      //��Ƶ�����źſ��
parameter RAM_DEPTH        = 100;     //�л���ram���
parameter TIMING_CNT_WIDTH = 10;      //�С��м������źſ��
parameter OVERLAP_WIDTH    = 2;       //������ݿ齻����
parameter TOP_BOTTOM_SEL   = 1'd1;    //�������ݿ����ϡ��²�����ɱ�ʶ
parameter HEAD_DIRECTION   = 1'd0;    //��ͷ����0ȫ��,1ȫ��,2�԰��
parameter FRAME_RAM_EN     = 1'd0;    //֡����ʹ��
parameter OUTPUT_DIRECTION = 0;       //�������ݿ�Ķ�������
parameter CH               = 0;
//һ�����Ϳ�������ٸ�����飬���������������Ķ��ٱ�
localparam TIMES           = CHANNEL_IN_NUM/CHANNEL_OUT_NUM;
//����RAM��Ⱦ���RAM�����ĵ�ַ���
localparam ADDR_WIDTH      = clogb2(RAM_DEPTH-1'b1);
//����������������
localparam OVERLAP_W       = clogb2(OVERLAP_WIDTH+1);
//�Ƿ��ж���ͻ
localparam NO_COLLIDE      = (CHANNEL_IN_NUM != CHANNEL_OUT_NUM ||
                             (!TOP_BOTTOM_SEL &&  CHANNEL_OUT_NUM <= 2) ||
                             (TOP_BOTTOM_SEL && CHANNEL_OUT_NUM <= 4));
//�������һ���飬���Ҿ�����Լ�
localparam ONE_BLOCK       = (CHANNEL_OUT_NUM == 1) || (TOP_BOTTOM_SEL && CHANNEL_OUT_NUM == 2);
//��߿�
localparam LEFT_BLOCK      = ((TOP_BOTTOM_SEL==1 &&  CH == 0) ||         //����
                             (!TOP_BOTTOM_SEL && CH == 0)) ||            //һ�������
                             (TOP_BOTTOM_SEL && CH == CHANNEL_OUT_NUM-1);//����
//�ұ߿�
localparam RIGHT_BLOCK     = ((TOP_BOTTOM_SEL && CH == (CHANNEL_OUT_NUM>>1)-1) ||
                             (!TOP_BOTTOM_SEL && CH == CHANNEL_OUT_NUM-1) ) ||
                             (TOP_BOTTOM_SEL && CH == CHANNEL_OUT_NUM>>1);
//�м��
localparam MIDD_BLOCK      = ((!TOP_BOTTOM_SEL && (0 < CH && CH < CHANNEL_OUT_NUM-1)) ||             //һ���м�
                             (TOP_BOTTOM_SEL && (0 < CH && CH < CHANNEL_OUT_NUM/2 -1))) ||           //�����м�
                             (TOP_BOTTOM_SEL && (CHANNEL_OUT_NUM/2 < CH && CH < CHANNEL_OUT_NUM-1 ));//���������м�
//��߾�������Լ����
localparam FILL_SELF_L     = (TOP_BOTTOM_SEL && CH == CHANNEL_OUT_NUM-1'b1) || CH == 6'd0;
//�ұ߾�������Լ��ұ�
localparam FILL_SELF_R     = (TOP_BOTTOM_SEL && (CH == (CHANNEL_OUT_NUM>>1'b1)-1'b1 ||
                                             CH == CHANNEL_OUT_NUM>>1'b1))  ||
                            (!TOP_BOTTOM_SEL && CH == CHANNEL_OUT_NUM-1'b1);
//�±߿飬midd_cnt�����ҵݼ�
localparam DOWN_BLOCK      = TOP_BOTTOM_SEL && (CH >= CHANNEL_OUT_NUM/2);

localparam IDLE            = 6'b000001;//���еȴ�
localparam HEAD            = 6'b000010;//׼����ͷ�׶�
localparam LEFT            = 6'b000100;//��߿�
localparam MIDDLE          = 6'b001000;//�м��
localparam RIGHT           = 6'b010000;//�ұ߿�
localparam NEXT            = 6'b100000;//����

input                                           clk;
input                                           sclr;
input                                           ce;
input                                           mode;
input                                           sel;
input [TIMING_CNT_WIDTH-1'b1:0]                 row_start;
input [TIMING_CNT_WIDTH-1'b1:0]                 row_end;
input [TIMING_CNT_WIDTH-1'b1:0]                 col_start;
input [TIMING_CNT_WIDTH-1'b1:0]                 col_end;
input [TIMING_CNT_WIDTH-1'b1:0]                 col_max;
input [TIMING_CNT_WIDTH-1'b1:0]                 row_max;
input [TIMING_CNT_WIDTH-1'b1:0]                 hblank_low;
//other signal
input                                           send_start;
input [TIMES*VIDEO_DATA_WIDTH-1'b1:0]           dout_m;             //data from data_save
input [VIDEO_DATA_WIDTH-1'b1:0]                 dout_sl;            //data from data_save
input [VIDEO_DATA_WIDTH-1'b1:0]                 dout_sr;            //data from data_save

output                                          hblank_out;
output                                          vblank_out;
output                                          active_video_out;
output [VIDEO_DATA_WIDTH-1'b1 :0]               video_data_out;
//һ�����TIMES��С�飬ÿ��RAM��ַADDRB
output [TIMES*ADDR_WIDTH-1'b1:0]                addr_m;             //�м��ַ Middle
output [ADDR_WIDTH-1'b1:0]                      addr_sl;            //��ߵ�ַ SideLeft
output [ADDR_WIDTH-1'b1:0]                      addr_sr;            //�ұߵ�ַ SideRight
output [TIMES-1:0]                              enb;                //ʹ���ź�
output                                          ena_sl;
output                                          ena_sr;
output                                          switch;             //ͨ���л��źţ��н���ʹ��

//b1 : before 1 clk period, b2 : before 2 clk period
reg                                             hblank_out_b1;
reg                                             vblank_out_b1;
reg                                             active_video_out_b1;
reg                                             hblank_out_b2;
reg                                             vblank_out_b2;
reg                                             active_video_out_b2;
reg                                             hblank_out_b3;
reg                                             vblank_out_b3;
reg                                             active_video_out_b3;
reg                                             hblank_out;
reg                                             vblank_out;
reg                                             active_video_out;

reg                                             switchb3;
reg                                             switchb2;
reg                                             switchb1;
reg                                             switch;           //�л�ͨ��

reg    [VIDEO_DATA_WIDTH-1'b1 :0]               video_data_out;

reg    [TIMES*ADDR_WIDTH-1'b1:0]                addr_m;
reg    [ADDR_WIDTH-1'b1:0]                      addr_sl;
reg    [ADDR_WIDTH-1'b1:0]                      addr_sr;
reg    [TIMES-1:0]                              enb;
reg                                             ena_sl;
reg                                             ena_sr;

//d1 : delay 1clk�� d2 : delay 2clk
reg    [TIMING_CNT_WIDTH*TIMES-1'b1:0]          col_cnt;          //�м����������ڱ���hblankinһ����ʱ��
reg    [TIMING_CNT_WIDTH     :0]                row_cnt;          //�м������������ѷ��͵�����
reg    [ADDR_WIDTH -1'b1:0]                     side_ptr;         //���ָ������
reg    [ADDR_WIDTH -1'b1:0]                     midd_ptr;         //�м�ָ������
reg    [clogb2(TIMES-1):0]                      midd_cnt;         //�����м䷢�Ϳ����
reg    [clogb2(TIMES-1):0]                      midd_cnt_d1;      //�����м䷢�Ϳ����
reg    [clogb2(TIMES-1):0]                      midd_cnt_d2;      //�����м䷢�Ϳ����
reg    [clogb2(TIMES-1):0]                      midd_cnt_d3;      //�����м䷢�Ϳ����
//FSM reg
reg    [5:0]                                    cur_state;
reg    [5:0]                                    next_state;
reg    [5:0]                                    next_state_d2;
reg    [5:0]                                    next_state_d3;    //д��ַ1clk��ʱ,��RAM����2��clk����ʱ��
//�н���ʹ��
reg    [OVERLAP_W-1:0]                          row_read_cnt;     //ָʾ�Ѿ���ȡ��������
reg                                             twice;            //ÿ�������У�����RAM����row_read_cnt��һ
reg    [TIMING_CNT_WIDTH     :0]                own_row;          //���н�����������
reg    [TIMING_CNT_WIDTH     :0]                all_row;          //������������
reg                                             own_finish;       //�ǽ������������
reg    [TIMING_CNT_WIDTH-1'b1:0]                effect_width_i;   //��������Ч���ݿ��
reg    [TIMING_CNT_WIDTH+clogb2(TIMES-1)-1:0]   next_gate;        //�м��������ˣ�NEXT״̬��������
reg    [TIMING_CNT_WIDTH+clogb2(TIMES-1)-1:0]   middle_gate;      //MIDELE״̬������������col_cnt�Ƶ���ֵ�����MIDDLE״̬
reg    [TIMING_CNT_WIDTH+clogb2(TIMES-1)-1:0]   right_left_gate;  //һ������Ч���ظ���������ģʽ�µ�right,left״̬��������
reg    [OVERLAP_W-1:0]                          col_save;         //�������������
reg                                             output_dir;       //�����������
reg                                             midd_cnt_dir;     //�м�鷢�ͷ���(ÿ���м��������С��)
reg    [ADDR_WIDTH+clogb2(TIMES-1)-1:0]         offset;           //���͵�ַƫ���������ó˷���
reg                                             wait_;            //�ȴ��ڼ䣬row_read_cnt���仯

//״̬������
always@(posedge clk)begin
    if(sclr)begin
        cur_state     <= IDLE;
        next_state_d2 <= IDLE;
    end else begin
        cur_state     <= next_state;
        next_state_d2 <= cur_state;
        next_state_d3 <= next_state_d2;
    end
end

/*
* ״̬��˵��
* IDLE  : ���У��ȴ���Ч����
* HEAD  : ���ݽ���״̬
* LEFT  ������������ݿ�
* RIGHT �������ұ����ݿ�
* MIDDLE�������м����ݿ�
* NXT   : �����������ź�
*/
always@(*)
begin
    if(ce) begin
        case(cur_state)
            IDLE: begin
                //��ʼ����
                if(send_start) begin
                    next_state = HEAD;
                end else begin
                    next_state = IDLE;
                end
            end
            HEAD: begin
                if(col_cnt == next_gate)begin
                    //mode=1,����
                    if(mode) begin
                        //1:�ҳ�ͷ
                        if(output_dir) begin
                            next_state = RIGHT;
                        //0: ���ͷ
                        end else begin
                            next_state = LEFT;
                        end
                    //mode=0,����
                    end else begin
                        next_state = MIDDLE;
                    end
                end else begin
                    next_state = HEAD;
                end
            end
            LEFT: begin
                //�������
                if(col_cnt == OVERLAP_WIDTH-1 || col_cnt == right_left_gate-1) begin
                    //�����������꣬���һ�з��͵�����
                    if(row_cnt == all_row && col_cnt == right_left_gate-1) begin
                        next_state = IDLE;
                    //1:�ҳ�ͷ
                    end else if(output_dir) begin
                        next_state = NEXT;//���껻��
                    //0: ���ͷ
                    end else begin
                        next_state = MIDDLE;
                    end
                end else begin
                    next_state = LEFT;
                end
            end
            MIDDLE: begin
                if(col_cnt == middle_gate) begin//��ȥ��������Ч���
                    //mode=1,����ģʽ
                    if(mode) begin
                        //1:�ҳ�ͷ
                        if(output_dir) begin
                            next_state = LEFT;
                        //0: ���ͷ
                        end else begin
                            next_state = RIGHT;
                        end
                    //mode=0,����
                    end else begin
                        if(row_cnt == all_row) begin
                            next_state = IDLE;
                        end else begin
                            next_state = NEXT;
                        end
                    end
                end else begin
                    next_state = MIDDLE;
                end
            end
            RIGHT:  begin
                //�������
                if(col_cnt == OVERLAP_WIDTH-1 || col_cnt == right_left_gate-1) begin
                    if(row_cnt == all_row && col_cnt == right_left_gate-1) begin
                        next_state = IDLE;
                    //�����������꣬���һ�з��͵�����
                    end else if(output_dir) begin
                        next_state = MIDDLE;
                    //0: ���ͷ
                    end else begin
                        next_state = NEXT;//���껻��
                    end
                end else begin
                    next_state = RIGHT;
                end
            end
            NEXT: begin
                //�ߵ�ƽʱ������ˣ���ʼ������������
                if(col_cnt == next_gate) begin
                    //����ģʽ
                    if(mode) begin
                        //1:�ҳ�ͷ
                        if(output_dir) begin
                            next_state = RIGHT;
                        //0: ���ͷ
                        end else begin
                            next_state = LEFT;
                        end
                    //����ģʽ
                    end else begin
                        next_state = MIDDLE;
                    end
                end else begin
                    next_state = NEXT;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end else
        next_state = IDLE;
end


//���ͼ���������
always@(posedge clk)
begin
    if(sclr) begin
        col_cnt <= 0;
        row_cnt <= 0;
    end else if(ce) begin
        case(next_state)
            IDLE: begin
                col_cnt <= 0;
                row_cnt <= 0;
            end
            HEAD: begin
                //������һ��״̬��Լ����ɲ��ò���
                if(send_start && cur_state == IDLE) begin
                    col_cnt    <= 0;
                end else begin
                    col_cnt    <= col_cnt + 1'b1;
                end
            end
            LEFT,MIDDLE,RIGHT,NEXT: begin
                if(col_cnt == next_gate) begin
                    col_cnt <= 1'b0;
                    row_cnt <= row_cnt +1'b1;
                end else begin
                    col_cnt    <= col_cnt + 1'b1;
                end
            end
            default : col_cnt <= 0;
        endcase
    end
end


//����hblank_out,vblank_out,active_video_out��ʱ��
always@(posedge clk)
begin
    if(sclr) begin
        hblank_out_b3       <= 1'b1;
        vblank_out_b3       <= 1'b1;
        active_video_out_b3 <= 1'b0;
    end else if(ce) begin
        case(next_state)
            IDLE: begin
                hblank_out_b3       <= 1'b1;
                vblank_out_b3       <= 1'b1;
                active_video_out_b3 <= 1'b0;
            end
            HEAD: begin
                //��ƽ����ʱ�������
                //����˵������vboû����hbo�����ر仯��Ӧ����gateû�м�ʱ����
                if(col_cnt >= right_left_gate) begin
                    hblank_out_b3 <= 1'b1;
                    vblank_out_b3 <= 1'b0;
                //��ƽ����ʱ��û����
                end else begin
                    hblank_out_b3 <= 1'b0;
                    vblank_out_b3 <= 1'b1;
                end
            end
            LEFT,MIDDLE,RIGHT: begin
                if((col_cnt == right_left_gate-1 && mode) || (col_cnt == middle_gate && !mode)) begin
                    hblank_out_b3 <= 1'b1;
                    active_video_out_b3 <= 1'b0;
                    if(row_cnt == all_row) begin//һ֡����
                        vblank_out_b3 <= 1'b1;
                    end else begin              //���ж���
                        vblank_out_b3 <= 1'b0;
                    end
                end else begin
                    active_video_out_b3 <= 1'b1;
                    hblank_out_b3       <= 1'b0;
                    vblank_out_b3       <= 1'b0;
                end
            end
            NEXT: begin
                active_video_out_b3 <= 1'b0;
                hblank_out_b3       <= 1'b1;
                vblank_out_b3       <= 1'b0;
            end
            default : /* default */;
        endcase
    end
end

//ʱ����ʱ�������ݶ���
always @(posedge clk) begin
    if(sclr) begin
        hblank_out          <= 1;
        vblank_out          <= 1;
        active_video_out    <= 0;
        hblank_out_b1       <= 1;
        vblank_out_b1       <= 1;
        active_video_out_b1 <= 0;
        hblank_out_b2       <= 1;
        vblank_out_b2       <= 1;
        active_video_out_b2 <= 0;
    end else if(ce) begin
        hblank_out_b2       <= hblank_out_b3;
        vblank_out_b2       <= vblank_out_b3;
        active_video_out_b2 <= active_video_out_b3;
        hblank_out_b1       <= hblank_out_b2;
        vblank_out_b1       <= vblank_out_b2;
        active_video_out_b1 <= active_video_out_b2;
        hblank_out          <= hblank_out_b1;
        vblank_out          <= vblank_out_b1;
        active_video_out    <= active_video_out_b1;
    end
end


//��鷢��ָ��
always@(posedge clk)
begin
    if(sclr) begin
        side_ptr <= 0;
    end else if(ce) begin
        case(next_state)
            //��һ������ָ���ʼ��
            HEAD,NEXT: begin
                //�����ң���߿��ʼ��
                if(!output_dir) begin
                    if(FILL_SELF_L) begin
                        //�����Լ�
                        side_ptr <= OVERLAP_WIDTH;
                    end else begin
                        //˳�����������ڿ�+
                        side_ptr <= effect_width_i - OVERLAP_WIDTH;
                    end
                //���ҵ���,�ұ߿��ʼ��,+
                end else begin
                    if(FILL_SELF_R)begin
                        //�ұ߾����Լ���
                        side_ptr <= effect_width_i - OVERLAP_WIDTH-1'b1;
                    end else begin
                        //˳������ұ����ڿ�
                        side_ptr <= OVERLAP_WIDTH-1;
                    end
                end
            end
            LEFT:begin
                if(!output_dir) begin
                    //����������Ҷ��Ǽ�
                    if(FILL_SELF_L) begin
                        if(side_ptr==1) begin
                            side_ptr <= 1;
                        end else begin
                            side_ptr <= side_ptr - 1'b1;
                        end
                    //������������Ҷ��Ǽ�
                    end else begin
                        if(side_ptr == effect_width_i - 1) begin
                            side_ptr <= effect_width_i - 1;
                        end else begin
                            side_ptr <= side_ptr + 1'b1;
                        end
                    end
                end else if(output_dir)begin
                    //��������ҵ����Ǽ�
                    if(FILL_SELF_L) begin
                        if(side_ptr==OVERLAP_WIDTH) begin
                            side_ptr <= OVERLAP_WIDTH;
                        end else begin
                            side_ptr <= side_ptr + 1'b1;
                        end
                    //����������ҵ����Ǽ�
                    end else begin
                        if(side_ptr == effect_width_i - OVERLAP_WIDTH) begin
                            side_ptr <= effect_width_i - OVERLAP_WIDTH;
                        end else begin
                            side_ptr <= side_ptr - 1'b1;
                        end
                    end
                end
            end
            MIDDLE: begin
                //�����ң��ұ߿��ʼ����
                if(!output_dir) begin
                    if(FILL_SELF_R) begin
                        //�ұ�����Լ� 01234 32 -
                        side_ptr <= effect_width_i - 2;
                    end else begin
                        //�ұ�������ڣ�˳�� 01 01234
                        side_ptr <= 0;
                    end
                //���ҵ���,��߿��ʼ����
                end else begin
                    if(FILL_SELF_L) begin
                        //�����Լ�21 01234 32+
                        side_ptr <= 1;
                    end else begin
                        //˳�����������ڿ�01234 34 -
                        side_ptr <= effect_width_i-1'b1;
                    end
                end
            end
            RIGHT:begin
                //����������Ҷ��Ǽ�
                if(!output_dir) begin
                    if(FILL_SELF_R) begin
                        if(side_ptr==effect_width_i-1'b1-OVERLAP_WIDTH) begin
                            side_ptr <= effect_width_i-1'b1-OVERLAP_WIDTH;
                        end else begin
                            side_ptr <= side_ptr - 1'b1;
                        end
                    end else begin
                        if(side_ptr==OVERLAP_WIDTH-1) begin
                            side_ptr <= OVERLAP_WIDTH-1;
                        end else begin
                            side_ptr <= side_ptr + 1'b1;
                        end
                    end
                //��������ҵ����Ǽ�
                end else if(output_dir)begin
                    if(FILL_SELF_R) begin
                        if(side_ptr==effect_width_i - 2) begin
                            side_ptr <= effect_width_i - 2;
                        end else begin
                            side_ptr <= side_ptr + 1'b1;
                        end
                    end else begin
                        if(side_ptr==0) begin
                            side_ptr <= 0;
                        end else begin
                            side_ptr <= side_ptr - 1'b1;
                        end
                    end
                end
            end
            default:;
        endcase
    end
end

//�м���־������,�ϱ߿���±߿��෴
always@(posedge clk)
begin
    if(sclr) begin
        midd_cnt    <= midd_cnt_dir ? (TIMES-1) : 0;
        midd_cnt_d1 <= 0;
        midd_cnt_d2 <= 0;
        midd_cnt_d3 <= 0;
    end else if(ce) begin
        midd_cnt_d1 <= midd_cnt;
        midd_cnt_d2 <= midd_cnt_d1;
        midd_cnt_d3 <= midd_cnt_d2;
        case(next_state)
            MIDDLE: begin
                if((midd_ptr == effect_width_i - 1'b1 && !output_dir) ||//һ����ӵ����
                   (midd_ptr == 0 && output_dir)) begin                 //һ���������С
                    if(!midd_cnt_dir) begin
                        if(midd_cnt == TIMES-1) begin                   //�ӵ�ĩβ��
                            midd_cnt <= midd_cnt;
                        //��һ���м��
                        end else begin
                            midd_cnt <= midd_cnt + 1'b1;
                        end
                    end else begin
                        if(midd_cnt == 0) begin                         //������ͷ��
                            midd_cnt <= midd_cnt;
                        end else begin
                            midd_cnt <= midd_cnt - 1'b1;
                        end
                    end
                end
            end
            NEXT:begin
                midd_cnt <= midd_cnt_dir ? (TIMES-1) : 0;
            end
            IDLE,HEAD: begin
                //RIGHT,LEFT״̬midd_cnt�����ܱ�
                midd_cnt <= midd_cnt_dir ? (TIMES-1) : 0;
            end
            default:;
        endcase
    end
end


//�м�鷢��ָ��,�м���־������,�ϱ߿���±߿��෴
always@(posedge clk)
begin
    if(sclr) begin
        midd_ptr <= 0;
    end else if(ce) begin
        case(next_state)
            MIDDLE: begin
                //�����Ҽӵ����midd_ptr��output_dir�йأ�
                if(midd_ptr == effect_width_i - 1'b1 && !output_dir) begin
                    //�м��ȫ������midd_cnt��midd_cnt_dir == 1����
                    if(midd_cnt == TIMES-1 && !midd_cnt_dir) begin
                        midd_ptr <= 0;
                    end else if(midd_cnt == 0 && midd_cnt_dir) begin
                        midd_ptr <= 0;
                    //��һ���м��
                    end else begin
                        midd_ptr <= 0;
                    end
                //���ҵ��������С
                end else if(midd_ptr == 0 && output_dir) begin
                    if(midd_cnt == 0 && midd_cnt_dir) begin
                        midd_ptr <= 0;
                    end else if(midd_cnt == TIMES-1 && !midd_cnt_dir) begin
                        midd_ptr <= 0;
                    end else begin
                        midd_ptr <= effect_width_i - 1'b1;
                    end
                //�������������,���ҵ�����
                end else if(!output_dir) begin
                    midd_ptr <= midd_ptr + 1'b1;
                end else if(output_dir)begin
                    midd_ptr <= midd_ptr - 1'b1;
                end
            end
            LEFT,RIGHT,IDLE,HEAD,NEXT:begin
                midd_ptr <= output_dir ?  effect_width_i - 1'b1 : 0;
            end
            default:;
        endcase
    end
end

//�Ѷ���������������
always@(posedge clk)
begin
    if(sclr) begin
        row_read_cnt <= 0;
    end else if(ce) begin
        case(next_state)
            IDLE: begin
                row_read_cnt <= 0;
            end
            LEFT,MIDDLE,RIGHT,NEXT: begin
                //һ�н���
                if(col_cnt == right_left_gate) begin
                    //��һ�ν�����row_read_cntӦ���ֲ���
                    if(twice && !wait_) begin
                        //�����Ѿ����ÿ��RAM��ַ�����һ�����ݣ�
                        if(row_read_cnt == col_save && !own_finish) begin
                            row_read_cnt <= 0;
                        //��������
                        end else if(row_read_cnt == 0 && own_finish) begin
                            row_read_cnt <= col_save;//��������
                        //�ǽ�����
                        end else begin
                            row_read_cnt <= own_finish ? row_read_cnt - 1 : row_read_cnt + 1;
                        end
                    end
                end
            end
            default : ;
        endcase
    end
end

////ÿ����row_read_cnt��һ��һ��ƹ�����ڣ�
always@(posedge clk)
begin
    if(sclr) begin
        twice        <= 0;
    end else if(ce) begin
        case(next_state)
            IDLE: begin
                twice <= 0;
            end
            LEFT,MIDDLE,RIGHT,NEXT: begin
                //�Լ��鷢�꣬��ʼ��������
                if(own_finish && wait_) begin//���¿�ʼ && overlap_cnt == 0
                    if(own_row%2 ==0) begin             //ż��
                        twice <= 0;
                    end else begin                      //����47 1�� 89 0
                        twice <= 1;
                    end
                //һ�н���
                end else if(col_cnt == right_left_gate) begin
                    twice <= ~twice;                    //ÿ���м�һ��һ��ƹ�����ڣ�
                end
            end
            default : ;
        endcase
    end
end


//ͨ�������л�
always@(posedge clk)
begin
    if(sclr) begin
        output_dir     <= 0;//�Լ���ķ���+������ķ���
    end else if(ce) begin
        case(next_state)
            HEAD: begin
                output_dir <= OUTPUT_DIRECTION[CH];
            end
            LEFT,MIDDLE,RIGHT,NEXT: begin
                //�����л�Ҫ��ǰ,��ַ��ֵ��ǰ3clk
                if(own_finish && col_cnt == next_gate-3) begin
                    output_dir <= OUTPUT_DIRECTION[CHANNEL_OUT_NUM - 1 - CH];
                end else if(!own_finish) begin
                    output_dir <= OUTPUT_DIRECTION[CH];
                end
            end
            default : ;
        endcase
    end
end


//ͨ���л�
always@(posedge clk)
begin
    if(sclr) begin
        switchb3     <= 1'b0;
        switchb2     <= 1'b0;
        switchb1     <= 1'b0;
        switch       <= 1'b0;
    end else if(ce) begin
        {switch,switchb1,switchb2} <= {switchb1,switchb2,switchb3};
        case(next_state_d2)
            HEAD:begin
                switchb3 <= 1'b0;//��һ���������
            end
            LEFT,MIDDLE,RIGHT,NEXT: begin
                if(own_finish && col_cnt == next_gate) begin
                    switchb3 <= 1'b1;
                end
            end
            default : ;
        endcase
    end
end


always @(posedge clk) begin
    if(sclr) begin
        own_row         <= 0;//�����н�������
        next_gate       <= 0;//���������ˣ�NEXT״̬��������
        middle_gate     <= 0;//MIDELE״̬������������col_cnt�Ƶ���ֵ�����MIDDLE״̬
        right_left_gate <= 0;//����ģʽ���н���ʱ���������ߵ��н��������ظ�����
                             //����ģʽ��middle_gateһ�£�right,left״̬��������
        all_row         <= 0;//������Ҫ���͵�����
        offset          <= 0;//����ַƫ����,���д���
        own_finish      <= 0;//�Լ��鷢���ˣ��÷�����������
        col_save        <= 0;//RAM�洢����
        midd_cnt_dir    <= 0;//�м��������ǵݼ�
        effect_width_i  <= 0;//һ�����ݵĸ�����������������
        wait_           <= 0;//�ȴ���һ�ν��������һ�з����Σ�
    end else if(ce) begin
        if(send_start) begin //��ֹcol_max������
            next_gate       <= (col_max*TIMES) - 1'b1;
        end
        middle_gate     <= mode ? (effect_width_i*TIMES + OVERLAP_WIDTH-1) : (effect_width_i*TIMES - 1);
        right_left_gate <= mode ? (effect_width_i*TIMES + (OVERLAP_WIDTH<<1'b1)) : (effect_width_i*TIMES - 1);
        effect_width_i  <= mode ? (col_end - col_start + 1'b1) : hblank_low;
        own_row         <= mode ? (row_end - row_start +1'b1) : row_max + 1;
        all_row         <= mode ? ((TOP_BOTTOM_SEL && !FRAME_RAM_EN ) ? (own_row + OVERLAP_WIDTH) : own_row) : own_row;
        offset          <= mode ? (row_read_cnt*effect_width_i) : 0;
        own_finish      <= row_cnt >  own_row - 1;
        col_save        <= (TOP_BOTTOM_SEL && !FRAME_RAM_EN) ? (OVERLAP_WIDTH-1)/2:1'b0;//ע���eceive����һ�£���
        midd_cnt_dir    <= DOWN_BLOCK ? (!output_dir) : output_dir;
        wait_           <= row_cnt == own_row;
    end
end

//���п��ܴ��ڳ�ͻ��ʱ��addrb,addrslһ��Ҫ��ʱ����
generate
    if(ONE_BLOCK)begin
        always@(posedge clk) begin
            if(sclr) begin
                addr_sr <= 0;
                ena_sr  <= 0;
                addr_sl <= 0;
                ena_sl  <= 0;
                addr_m  <= 0;
                enb     <= 0;
            end else if(ce) begin
                case(next_state_d2)
                    LEFT,RIGHT:begin
                        //Ϊ��һ�飨λ�ö��ԣ���׼��
                        if(next_state==MIDDLE) begin
                            enb <= 1<<midd_cnt;
                            addr_m <= midd_ptr + offset << (midd_cnt*ADDR_WIDTH);
                        end else begin
                            enb <= 1<<midd_cnt;
                            addr_m <= side_ptr + offset << (midd_cnt*ADDR_WIDTH);
                        end
                        addr_sr <= 0;
                        ena_sr  <= 0;
                        addr_sl <= 0;
                        ena_sl  <= 0;
                    end
                    MIDDLE:begin
                        //Ϊ��һ����׼��
                        if(next_state==RIGHT || next_state  == LEFT) begin
                            enb <= 1<<midd_cnt;
                            addr_m <= side_ptr + offset << (midd_cnt*ADDR_WIDTH);
                        end else begin
                            enb <= 1<<midd_cnt;
                            addr_m <= midd_ptr + offset << (midd_cnt*ADDR_WIDTH);
                        end
                        addr_sr <= 0;
                        ena_sr  <= 0;
                        addr_sl <= 0;
                        ena_sl  <= 0;
                    end
                    default: begin
                        addr_sr <= 0;
                        ena_sr  <= 0;
                        addr_sl <= 0;
                        ena_sl  <= 0;
                        //ֻ��ǰ2clk���ڳ�ʼ�����͹��Ŀ��ǣ���ͬ
                        if((col_cnt  == next_gate) || (col_cnt  == 0 && next_state_d2 != IDLE)) begin
                            if(mode) begin
                                //�������ֻ��һ�������MIDDLE�ĳ�ʼ���������Ҫ�����ж�
                                if(next_state  == MIDDLE) begin
                                    enb <= 1<<midd_cnt;
                                    addr_m <= midd_ptr + offset << (midd_cnt*ADDR_WIDTH);
                                end else begin
                                    enb <= 1<<midd_cnt;
                                    addr_m <= side_ptr + offset << (midd_cnt*ADDR_WIDTH);
                                end
                            end else begin
                                //����ģʽ����ʼ���м�ָ��
                                enb <= 1<<midd_cnt;
                                addr_m <= midd_ptr +offset << (midd_cnt*ADDR_WIDTH);
                            end
                        end
                    end
                endcase
            end
        end

        always@(posedge clk) begin
            if(sclr) begin
                video_data_out <= 0;
            end else if(ce) begin
                case(next_state_d3)
                    //��ַ�˿����ַ��Ӧ����ͬ����һһ����
                    LEFT:begin
                        video_data_out <= dout_m[midd_cnt_d3*VIDEO_DATA_WIDTH +VIDEO_DATA_WIDTH-1'b1 -:VIDEO_DATA_WIDTH];
                    end
                    MIDDLE:begin
                        video_data_out <= dout_m[midd_cnt_d3*VIDEO_DATA_WIDTH +VIDEO_DATA_WIDTH-1'b1 -:VIDEO_DATA_WIDTH];
                    end
                    RIGHT:begin
                        video_data_out <= dout_m[midd_cnt_d3*VIDEO_DATA_WIDTH +VIDEO_DATA_WIDTH-1'b1 -:VIDEO_DATA_WIDTH];
                    end
                    default:begin
                        if((next_state_d3 == NEXT || next_state_d3 == IDLE) && sel) begin
                            video_data_out <= 0;
                        end
                    end
                endcase
            end else begin
                video_data_out <= 0;
            end
        end
    end else if(LEFT_BLOCK && NO_COLLIDE) begin
        //   send_lself #(
        always@(posedge clk) begin
            if(sclr) begin
                addr_sr <= 0;
                ena_sr  <= 0;
                addr_sl <= 0;
                ena_sl  <= 0;
                addr_m  <= 0;
                enb     <= 0;
            end else if(ce) begin
                case(next_state_d2)
                    LEFT:begin
                        addr_sr <= 0;
                        ena_sr  <= 0;
                        addr_sl <= 0;
                        ena_sl  <= 0;
                        if(next_state==MIDDLE) begin//Ϊ��һ����׼��
                            enb <= 1<<midd_cnt;
                            addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                        end else  begin//�Լ���ʹ��
                            enb  <= 1<<midd_cnt;
                            addr_m  <= side_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                        end
                    end
                    MIDDLE:begin
                        addr_sl <= 0;
                        ena_sl  <= 0;
                        if(next_state  == LEFT) begin//Ϊ��һ����׼��
                            enb <= 1<<midd_cnt;
                            addr_m  <= side_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                        end else if(next_state  == RIGHT) begin
                            ena_sr  <= 1;
                            addr_sr <= side_ptr + offset;
                        end else begin//�Լ���ʹ��
                            enb <= 1<<midd_cnt;
                            addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                        end
                    end
                    RIGHT:begin
                        addr_sl <= 0;
                        ena_sl  <= 0;
                        if(next_state==MIDDLE) begin//Ϊ��һ����׼��
                            enb <= 1<<midd_cnt;
                            addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                        end else begin//�Լ���ʹ��
                            ena_sr  <= 1;
                            addr_sr <=  side_ptr + offset;// + offset <<(midd_cnt*ADDR_WIDTH);
                        end
                    end
                    default: begin
                        addr_sl <= 0;
                        ena_sl  <= 0;
                        //ֻ��ǰ2clk���ڳ�ʼ�����͹��Ŀ���
                        if((col_cnt  == next_gate) || (col_cnt  == 0 && next_state_d2 != IDLE)) begin
                            if(mode) begin//����ģʽ����ʼ�����ָ��
                                if(!output_dir) begin//�����ң���ʼ�����ָ��,
                                    if(next_state  == MIDDLE) begin
                                        enb    <= 1<<midd_cnt;
                                        addr_m <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                                    end else begin
                                        enb    <= 1<<midd_cnt;
                                        addr_m <= side_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                                    end
                                end else begin //���ҵ��󣬳�ʼ���ұ�ָ��
                                    if(next_state  == MIDDLE) begin
                                        enb    <= 1<<midd_cnt;
                                        addr_m <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                                    end else begin
                                        ena_sr  <= 1;
                                        addr_sr <=  side_ptr + offset;
                                    end
                                end
                            end else begin//����ģʽ����ʼ���м�ָ��
                                enb     <= 1<<midd_cnt;
                                addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                            end
                        end
                    end
                endcase
            end
        end

        always@(posedge clk) begin
            if(sclr) begin
                video_data_out <= 0;
            end else if(ce) begin
                case(next_state_d3)
                    LEFT:begin
                        video_data_out <= dout_m[midd_cnt_d3*VIDEO_DATA_WIDTH +VIDEO_DATA_WIDTH-1'b1 -:VIDEO_DATA_WIDTH];
                    end
                    //�м���ұ߹���
                    MIDDLE:begin
                        video_data_out <= dout_m[midd_cnt_d3*VIDEO_DATA_WIDTH +VIDEO_DATA_WIDTH-1'b1 -:VIDEO_DATA_WIDTH];
                    end
                    RIGHT:begin
                        video_data_out <= dout_sr[VIDEO_DATA_WIDTH-1'b1  -:VIDEO_DATA_WIDTH];
                    end
                    default: begin
                        if((next_state_d3 == NEXT || next_state_d3 == IDLE) && sel) begin
                            video_data_out <= 0;
                        end
                    end
                endcase
            end else begin
                video_data_out <= 0;
            end
        end
    end else if(RIGHT_BLOCK) begin
        always@(posedge clk) begin
            if(sclr) begin
                addr_sr <= 0;
                ena_sr  <= 0;
                addr_sl <= 0;
                ena_sl  <= 0;
                addr_m  <= 0;
                enb     <= 0;
            end else if(ce) begin
                case(next_state_d2)
                    LEFT:begin
                        if(next_state==MIDDLE) begin            //Ϊ��һ����׼��
                            addr_sl <= 0;
                            ena_sl  <= 0;
                            enb    <= 1<<midd_cnt;
                            addr_m <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                        end else begin                          //�Լ���ʹ��
                            addr_m  <= 0;
                            enb     <= 0;
                            ena_sl  <= 1;
                            addr_sl <=  side_ptr + offset;
                        end
                    end
                    MIDDLE:begin
                        if(next_state  == RIGHT) begin          //Ϊ��һ����׼��
                            ena_sl  <= 0;
                            addr_sl <= 0;
                            enb     <= 1<<midd_cnt;
                            addr_m  <= side_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                        end else if(next_state  == LEFT) begin
                            addr_m  <= 0;
                            enb     <= 0;
                            ena_sl  <= 1;
                            addr_sl <=  side_ptr + offset;
                        end else begin                          //�Լ���ʹ��
                            addr_sl <= 0;
                            ena_sl  <= 0;
                            enb     <= 1<<midd_cnt;
                            addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                        end
                    end
                    RIGHT:begin
                        addr_sl <= 0;
                        ena_sl  <= 0;
                        if(next_state==MIDDLE) begin            //Ϊ��һ����׼��
                            enb    <= 1<<midd_cnt;
                            addr_m <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                        end else  begin                         //�Լ���ʹ��
                            enb    <= 1<<midd_cnt;
                            addr_m <= side_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                        end
                    end
                    default: begin
                        //ֻ��ǰ2clk���ڳ�ʼ�����͹��Ŀ���
                        if((col_cnt  == next_gate) || (col_cnt  == 0 && next_state_d2 != IDLE)) begin
                            if(mode) begin                      //����ģʽ����ʼ�����ָ��
                                if(!output_dir) begin           //�����ң���ʼ�����ָ��
                                    if(next_state  == MIDDLE) begin
                                        addr_sl <= 0;
                                        ena_sl  <= 0;
                                        enb     <= 1<<midd_cnt;
                                        addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                                    end else begin
                                        addr_m  <= 0;
                                        enb     <= 0;
                                        ena_sl  <= 1;
                                        addr_sl <=  side_ptr + offset;
                                    end
                                end else begin                  //���ҵ��󣬳�ʼ���ұ�ָ��
                                    addr_sl <= 0;
                                    ena_sl  <= 0;
                                    if(next_state  == MIDDLE) begin
                                        enb    <= 1<<midd_cnt;
                                        addr_m <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                                    end else begin
                                        enb    <= 1<<midd_cnt;
                                        addr_m <= side_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                                    end
                                end
                            end else begin                      //����ģʽ����ʼ���м�ָ��
                                addr_sl <= 0;
                                ena_sl  <= 0;
                                enb     <= 1<<midd_cnt;
                                addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                            end
                        end else begin
                        end
                    end
                endcase
            end
        end

        always@(posedge clk) begin
            if(sclr) begin
                video_data_out <= 0;
            end else
            if(ce) begin
                case(next_state_d3)
                    LEFT:begin
                        video_data_out <= dout_sl[VIDEO_DATA_WIDTH-1'b1 -:VIDEO_DATA_WIDTH];
                    end
                    //�м���ұ߹���
                    MIDDLE:begin
                        video_data_out <= dout_m[midd_cnt_d3*VIDEO_DATA_WIDTH +VIDEO_DATA_WIDTH-1'b1 -:VIDEO_DATA_WIDTH];
                    end
                    RIGHT:begin
                        video_data_out <= dout_m[midd_cnt_d3*VIDEO_DATA_WIDTH +VIDEO_DATA_WIDTH-1'b1 -:VIDEO_DATA_WIDTH];
                    end
                    default: begin
                        if((next_state_d3 == NEXT || next_state_d3 == IDLE) && sel) begin
                            video_data_out <= 0;
                        end
                    end
                endcase
            end else begin
                video_data_out <= 0;
            end
        end
    end else if(MIDD_BLOCK) begin
        always@(posedge clk) begin
            if(sclr) begin
                addr_sr <= 0;
                ena_sr  <= 0;
                addr_sl <= 0;
                ena_sl  <= 0;
                addr_m  <= 0;
                enb     <= 0;
            end else if(ce) begin
                case(next_state_d2)
                    LEFT:begin
                        if(next_state==MIDDLE) begin         //Ϊ��һ����׼��
                            addr_sl <= 0;
                            ena_sl  <= 0;
                            enb     <= 1<<midd_cnt;
                            addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                        end else begin                      //�Լ���ʹ��
                            addr_m  <= 0;
                            enb     <= 0;
                            ena_sl  <= 1;
                            addr_sl <=  side_ptr + offset;
                        end
                    end
                    MIDDLE:begin
                        if(next_state  == LEFT) begin       //Ϊ��һ����׼��
                            addr_m  <= 0;
                            enb     <= 0;
                            ena_sl  <= 1;
                            addr_sl <=  side_ptr + offset;
                        end else if(next_state  == RIGHT) begin
                            addr_m  <= 0;
                            enb     <= 0;
                            addr_sl <= 0;
                            ena_sl  <= 0;
                            ena_sr   <= 1;
                            addr_sr  <=  side_ptr + offset;
                        end else  begin                     //�Լ���ʹ��
                            addr_sl <= 0;
                            ena_sl  <= 0;
                            enb     <= 1<<midd_cnt;
                            addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                        end
                    end
                    RIGHT:begin
                        addr_sl <= 0;
                        ena_sl  <= 0;
                        if(next_state==MIDDLE) begin        //Ϊ��һ����׼��
                            enb     <= 1<<midd_cnt;
                            addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                        end else begin                      //�Լ���ʹ��
                            addr_m  <= 0;
                            enb     <= 0;
                            addr_sl <= 0;
                            ena_sl  <= 0;
                            ena_sr  <= 1;
                            addr_sr <=  side_ptr + offset;
                        end
                    end
                    default: begin
                        //ֻ��ǰ2clk���ڳ�ʼ�����͹��Ŀ���
                        if((col_cnt  == next_gate) || (col_cnt  == 0 && next_state_d2 != IDLE)) begin
                            if(mode) begin                  //����ģʽ����ʼ�����ָ��
                                if(!output_dir) begin       //�����ң���ʼ�����ָ��
                                    if(next_state  == MIDDLE) begin
                                        ena_sl  <= 0;
                                        addr_sl <= 0;
                                        enb     <= 1<<midd_cnt;
                                        addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                                    end else begin
                                        enb     <= 0;
                                        addr_m  <= 0;
                                        ena_sl  <= 1;
                                        addr_sl <=  side_ptr + offset;
                                    end
                                end else begin              //���ҵ��󣬳�ʼ���ұ�ָ��
                                        addr_sl <= 0;
                                        ena_sl  <= 0;
                                    if(next_state  == MIDDLE) begin
                                        enb     <= 1<<midd_cnt;
                                        addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                                    end else begin
                                        enb     <= 0;
                                        addr_m  <= 0;
                                        ena_sr  <= 1;
                                        addr_sr <=  side_ptr + offset;
                                    end
                                end
                            end else begin                  //����ģʽ����ʼ���м�ָ��
                                addr_sl <= 0;
                                ena_sl  <= 0;
                                enb     <= 1<<midd_cnt;
                                addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                            end
                        end
                    end
                endcase
            end
        end

        always@(posedge clk) begin
            if(sclr) begin
                video_data_out <= 0;
            end else if(ce) begin
                case(next_state_d3)
                    LEFT:begin
                        video_data_out <= dout_sl[VIDEO_DATA_WIDTH-1'b1 -:VIDEO_DATA_WIDTH];
                    end
                    //�м���ұ߹���
                    MIDDLE:begin
                        video_data_out <= dout_m[midd_cnt_d3*VIDEO_DATA_WIDTH +VIDEO_DATA_WIDTH-1'b1 -:VIDEO_DATA_WIDTH];
                    end
                    RIGHT:begin
                        video_data_out <= dout_sr[VIDEO_DATA_WIDTH-1'b1  -:VIDEO_DATA_WIDTH];
                    end
                    default: begin
                        if((next_state_d3 == NEXT || next_state_d3 == IDLE) && sel) begin
                            video_data_out <= 0;
                        end
                    end
                endcase
            end else begin
                video_data_out <= 0;
            end
        end
    end else if(LEFT_BLOCK && !NO_COLLIDE)begin
        always@(posedge clk) begin
            if(sclr) begin
                addr_sr <= 0;
                ena_sr  <= 0;
                addr_sl <= 0;
                ena_sl  <= 0;
                addr_m  <= 0;
                enb     <= 0;
            end else if(ce) begin
                case(next_state_d2)
                    LEFT:begin
                        if(next_state==MIDDLE) begin    //Ϊ��һ����׼��
                            addr_sl <= 0;
                            ena_sl  <= 0;
                            enb     <= 1<<midd_cnt;
                            addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                        end else begin                  //�Լ���ʹ��
                            addr_m  <= 0;
                            enb     <= 0;
                            ena_sl  <= 1;
                            addr_sl <=  side_ptr + offset;
                        end
                    end
                    MIDDLE:begin
                        if(next_state  == LEFT) begin   //Ϊ��һ����׼��
                            addr_m  <= 0;
                            enb     <= 0;
                            ena_sl  <= 1;
                            addr_sl <=  side_ptr + offset;
                        end else if(next_state  == RIGHT) begin
                            addr_m  <= 0;
                            enb     <= 0;
                            addr_sl <= 0;
                            ena_sl  <= 0;
                            ena_sr   <= 1;
                            addr_sr  <=  side_ptr + offset;
                        end else  begin                 //�Լ���ʹ��
                            addr_sl <= 0;
                            ena_sl  <= 0;
                            enb     <= 1<<midd_cnt;
                            addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                        end
                    end
                    RIGHT:begin
                        addr_sl <= 0;
                        ena_sl  <= 0;
                        if(next_state==MIDDLE) begin    //Ϊ��һ����׼��
                            enb     <= 1<<midd_cnt;
                            addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                        end else begin                  //�Լ���ʹ��
                            addr_m  <= 0;
                            enb     <= 0;
                            ena_sr  <= 1;
                            addr_sr <=  side_ptr + offset;
                        end
                    end
                    default: begin
                        //ֻ��ǰ2clk���ڳ�ʼ�����͹��Ŀ���
                        if((col_cnt  == next_gate) || (col_cnt  == 0 && next_state_d2 != IDLE)) begin
                            if(mode) begin              //����ģʽ����ʼ�����ָ��
                                if(!output_dir) begin   //�����ң���ʼ�����ָ��
                                    if(next_state  == MIDDLE) begin
                                        addr_sl <= 0;
                                        ena_sl  <= 0;
                                        enb     <= 1<<midd_cnt;
                                        addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                                    end else begin
                                        addr_m  <= 0;
                                        enb     <= 0;
                                        ena_sl  <= 1;
                                        addr_sl <=  side_ptr + offset;
                                    end
                                end else begin          //���ҵ��󣬳�ʼ���ұ�ָ��
                                    addr_sl <= 0;
                                    ena_sl  <= 0;
                                    if(next_state  == MIDDLE) begin
                                        enb     <= 1<<midd_cnt;
                                        addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                                    end else begin
                                        addr_m  <= 0;
                                        enb     <= 0;
                                        ena_sr  <= 1;
                                        addr_sr <=  side_ptr + offset;
                                    end
                                end
                            end else begin              //����ģʽ����ʼ���м�ָ��
                                addr_sl <= 0;
                                ena_sl  <= 0;
                                enb     <= 1<<midd_cnt;
                                addr_m  <= midd_ptr + offset <<(midd_cnt*ADDR_WIDTH);
                            end
                        end
                    end
                endcase
            end
        end

        always@(posedge clk) begin
            if(sclr) begin
                video_data_out <= 0;
            end else if(ce) begin
                case(next_state_d3)
                    LEFT:begin
                        video_data_out <= dout_sl[VIDEO_DATA_WIDTH-1'b1 -:VIDEO_DATA_WIDTH];
                    end
                    //�м���ұ߹���
                    MIDDLE:begin
                        video_data_out <= dout_m[midd_cnt_d3*VIDEO_DATA_WIDTH +VIDEO_DATA_WIDTH-1'b1 -:VIDEO_DATA_WIDTH];
                    end
                    RIGHT:begin
                        video_data_out <= dout_sr[VIDEO_DATA_WIDTH-1'b1  -:VIDEO_DATA_WIDTH];
                    end
                    default: begin
                        if((next_state_d3 == NEXT || next_state_d3 == IDLE) && sel) begin
                            video_data_out <= 0;
                        end
                    end
                endcase
            end else begin
                video_data_out <= 0;
            end
        end
    end
endgenerate

//  The following function calculates the address width based on specified RAM depth
function integer clogb2;
    input integer depth;
    for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
endfunction


endmodule



