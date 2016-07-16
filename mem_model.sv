//==================================================================================================
//  Copyright     : ������ʱ�˾���˾
//  Filename      : mem_model.sv
//  Description   : ����ģ�ͣ���ʼ��CHANNEL_IN_NUM���������ݿ�mem_tx��
//                  ����CHANNEL_OUT_NUM��������ݿ�ο�ģ��
//  Date          : 2016/7/20
//  Author        : WangTao
//==================================================================================================

`timescale 1ns/1ps
module mem_model(
    mode,
    col_max,
    row_max
);
parameter   TOP_BOTTOM_SEL   = 1;                                           //���²��ֱ�ʶ
parameter   CHANNEL_IN_NUM   = 4;
parameter   CHANNEL_OUT_NUM  = 4;
parameter   HEAD_DIRECTION   = 2;                                           //�������ݷ���
parameter   OUTPUT_DIRECTION = 0;                                           //������ݷ���
parameter   FRAME_RAM_EN     = 0;                                           //֡����ʹ��
parameter   OVERLAP_WIDTH    = 3;                                           //�������
parameter   RAM_DEPTH        = 100;
parameter   VIDEO_DATA_WIDTH = 18;
localparam  TX_DEPTH         = RAM_DEPTH;                                   //mem_txÿ�����ݸ���
localparam  BIG_DEPTH        = TX_DEPTH*CHANNEL_IN_NUM+2*OVERLAP_WIDTH;     //mem_bigÿ�����ݸ���
localparam  REFER_DEPTH      = (TX_DEPTH+2*OVERLAP_WIDTH)*1024;             //mem_refer��ȣ�ÿ�����ݸ���*���ݿ�����
input                                   mode;                                          //1������ģʽ��2������ģʽ
input       [9:0]                       col_max;                                       //һ���ж��ٸ�����
input       [9:0]                       row_max;                                       //ÿ�����ݿ��ж�����

reg         [VIDEO_DATA_WIDTH-1:0]      mem_tx[CHANNEL_IN_NUM:0][1024:0][TX_DEPTH:0];   //���ɵ�ԭʼ���ݿ飬���͸�DUT
reg         [VIDEO_DATA_WIDTH-1:0]      mem_big[2048:0][BIG_DEPTH:0];                   //���������ݿ�ƴ�ӳɵĴ����ݿ�
reg         [VIDEO_DATA_WIDTH-1:0]      mem_refer[CHANNEL_OUT_NUM:0][REFER_DEPTH:0];    //�ϳɺ�����ݿ飬��DUT������Ա�
reg         [63:0]                      channel_direction;                              //ÿһ��������HEAD_DIRECTION
reg         [19:0]                      ram_add_end;                                    //ÿ���ϳɺ�����ݿ�ӵ�е����ݸ���
reg         [19:0]                      block_len;                                      //ÿ��������ݿ�һ�е����ݸ���

// initial begin            //��ģ�ͷ���ʱ�õĴ���
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


// task display_mem();//�����ݿ����ݴ�ӡ����������۲�,���Է���ģ��ʱʹ��
// integer handle0,handle1,handle2,handle3;    //mem_tx�ľ����ÿ�����ݿ鵥�����
// //integer handle4,handle5,handle6,handle7;
// integer handle_big;
// integer handle_0,handle_1,handle_2,handle_3;//������ݿ�����ÿ�����ݿ鵥�����
// integer i,j,k;
// reg [9:0] h_cnt_big;
// reg [9:0] l_cnt_big;
// reg [9:0] block_depth;                      //������ݿ�����
// reg [6:0] N;                                //mem_big��һ��������N�����ݿ�ƴ�Ӷ���
// begin
//     N       = CHANNEL_IN_NUM*$pow(2,(!TOP_BOTTOM_SEL))/2; //��Ϊ�������У�mem_big�ϰ벿��ӵ��CHANNEL_IN_NUM/2�����ݿ飬����ΪCHANEL_IN_NUM�����ݿ�
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
//     //��ӡ���͵����ݿ�mem_tx
//     for (i = 0; i < CHANNEL_IN_NUM; i++) begin
//         for (int j = 0; j < row_max; j++) begin
//             for (int k = 0; k < col_max; k++) begin
//                 $fwrite(handle0*$pow(2,i),"%d",mem_tx[i][j][k]);
//             end
//             $fwrite(handle0*$pow(2,i),"\n");
//         end
//         $fclose(handle0*$pow(2,i));
//     end
//     //��ӡmem_big
//     if(CHANNEL_IN_NUM == 1) begin
//     //��ֹ���������������1���飬��top_bottom=1
//         block_depth = row_max;
//     end
//     else begin
//         //�������ݿ��������У�mem_bigӵ��2*row_max�����ݣ���������mem_big��row_max������
//         block_depth = $pow(2,TOP_BOTTOM_SEL)*row_max;
//     end
//     repeat(block_depth) begin
//         l_cnt_big = 0;
//         repeat((col_max)*N+2*OVERLAP_WIDTH) begin //mem_bigһ��ӵ�е����ݸ���
//             $fwrite(handle_big,"%d",mem_big[h_cnt_big][l_cnt_big++]);
//         end
//         $fwrite(handle_big,"\n");
//         h_cnt_big++;
//     end
//     $fclose(handle_big);
//     //��ӡmem_refer
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
//���ݲ����������ݿ�
//ÿһ�����ص���18bit��ǰ6λ��ʾ�ڼ������ݿ飬����12bit��ʾ���ص����ڵ��С���
reg [10:0] h_cnt;      //ram �м��������ݶ�ÿһ�����ݿ�Ϊ8��
reg [10:0] l_cnt;      //ram �м�������һ�����512������
reg [5:0] channel;
integer i;
begin
    h_cnt  = 0;
    l_cnt  = 0;
    channel= 0;
    for(i=0;i<CHANNEL_IN_NUM;i++) begin
        repeat(row_max) begin        //���ݿ��ж���������
            l_cnt = 0;
            repeat(col_max) begin    //һ����col_max������
                mem_tx[channel][h_cnt][l_cnt++] = {channel*1000000 + h_cnt*1000 + l_cnt};
                //ÿ�������ܷ�ӳ����λ�á�649999:��64ͨ���ĵ�99�е�99�и���
            end
            h_cnt++;
        end
        h_cnt = 0;
        channel++;
    end
    //��ӡmem_tx
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
//�ж�ÿ�����ݿ�����뷽��
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
//����mem_big�����������ݴ�ŵ�һ��mem����
integer i;
reg [19:0] l_cnt;       //�������ݿ��м�����
reg [19:0] h_cnt;       //�������ݿ��м�����
reg [19:0] h_cnt_big;   //mem_big���м�����
reg [19:0] l_cnt_big;   //mem_big���м�����
reg        rptr_dir;    //ָ�뷽��1��������0���ݼ�
reg [6:0]  repeat_time; //�����ݿ�����ɶ��ٸ�С���ݿ����
reg [5:0]  channel;     //��ǰ����������һ�����ݿ�
reg [19:0] block_depth;
reg [10:0] N;
begin
//����ÿ��������뷽�򣬽��������ݿ���ݹ���ƴ�ӳ�һ��������ݿ�
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
        repeat(OVERLAP_WIDTH) begin//��߶Գ������
            if(rptr_dir == 1'b1) begin
                mem_big[h_cnt_big][l_cnt_big++] = mem_tx[0][h_cnt][l_cnt++];
            end
            else begin
                mem_big[h_cnt_big][l_cnt_big++] = mem_tx[0][h_cnt][l_cnt--];
            end
        end
        if(CHANNEL_IN_NUM == 1) begin
        //��ֹ���������������1���飬��top_bottom=1
            repeat_time = 7'd1;
        end
        else if(TOP_BOTTOM_SEL == 1'b0) begin //ֻ��һ�����ݿ�
            repeat_time = CHANNEL_IN_NUM;
        end
        else begin//���������ݿ�
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
                if(rptr_dir == 1'b1) begin //��ǰ���ݿ�������ҵݼ�
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

    if(repeat_time == CHANNEL_IN_NUM/2) begin //�����������ݿ�
        h_cnt = row_max - 1;               //��mem_tx�����һ�п�ʼд
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
            //������Ч����������
            repeat(repeat_time) begin //CHANNEL_IN_NUM/2�����ݿ�
                if(channel_direction[channel] == 1'b1) begin
                    l_cnt    = col_max - 1'b1;
                    rptr_dir = 1'b0;
                end
                else begin
                    l_cnt    = 0;
                    rptr_dir = 1'b1;
                end
                repeat(col_max) begin
                    if(rptr_dir == 1'b0) begin //��ǰ���ݿ�������ҵݼ�
                        mem_big[h_cnt_big][l_cnt_big++] = mem_tx[channel][h_cnt][l_cnt--];
                    end
                    else begin
                        mem_big[h_cnt_big][l_cnt_big++] = mem_tx[channel][h_cnt][l_cnt++];
                    end
                end
                channel--;
            end
            channel++;
            //���ұ߶Գ����
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
    //��ӡmem_big
    //  N       = CHANNEL_IN_NUM*$pow(2,(!TOP_BOTTOM_SEL))/2; //��Ϊ�������У�mem_big�ϰ벿��ӵ��CHANNEL_IN_NUM/2�����ݿ飬����ΪCHANEL_IN_NUM������
    // if(CHANNEL_IN_NUM == 1) begin
    // //��ֹ���������������1���飬��top_bottom=1
    //     block_depth = row_max;
    // end
    // else begin
    //     //�������ݿ��������У�mem_bigӵ��2*row_max�����ݣ���������mem_big��row_max������
    //     block_depth = $pow(2,TOP_BOTTOM_SEL)*row_max;
    // end
    // h_cnt_big = 0;
    // repeat(block_depth) begin
    //     l_cnt_big = 0;
    //     repeat((col_max)*N+2*OVERLAP_WIDTH) begin //mem_bigһ��ӵ�е����ݸ���
    //         $write("%d",mem_big[h_cnt_big][l_cnt_big++]);
    //     end
    //     $write("\n");
    //     h_cnt_big++;
    // end
end
endtask

task mem_move;              //��mem_bigĿ���ַ�����ݰᵽmem_refer,ֻ����һ��������ݿ�
input [5:0] channel;        //��ǰҪ����������һ��mem_refer
input [20:0] rptr;          //������mem_big�еĺ�����ʼ��ַ
input       h_cnt_big_dir;  //��mem_bigȡ����ʱ���ж��м������������ǵݼ�1��������0���ݼ�
reg   [10:0] block_num;      //block_num=CHANNEL_IN_NUM /CHANNEL_OUT_NUM
reg   [30:0]ram_add;        //mem_refer �ĵ�ַ
reg   [20:0]h_cnt_big;      //mem_big�е��м�����
reg   [20:0]l_cnt_big;      //mem_big���м�����
reg   [10:0] block_depth;    //����������
begin
    ram_add = 0;
    block_num = CHANNEL_IN_NUM/CHANNEL_OUT_NUM;
    if(mode == 1'b1) begin //����ģʽ��Ҫ�����,һ�е����ݸ���
        block_len = 2*OVERLAP_WIDTH + (col_max)*block_num;
    end
    else begin
        block_len = (col_max)*block_num;
    end

    //�жϴ�mem_bigȡ����ʱ��ʼ��������mem_bigȡ�ĵ�һ����������Ϊ��h_cnt_big��rptr��
    if(h_cnt_big_dir == 1'b0) begin//�ڶ��е�������ݿ�
        h_cnt_big = row_max*2 - 1'd1;
    end
    else begin//��һ�е�������ݿ�
        h_cnt_big = 0;
    end

    if(mode && TOP_BOTTOM_SEL && !FRAME_RAM_EN && (CHANNEL_IN_NUM != 1)) begin
    //��Ҫ������������������ʱÿ����������������
        block_depth = row_max + OVERLAP_WIDTH;
    end
    else begin
    //���ý��������
        block_depth = row_max;
    end
    repeat(block_depth) begin
        l_cnt_big = rptr;
        repeat(block_len)begin //������ݿ��һ������
            if(OUTPUT_DIRECTION[channel] == 1'b0) begin //�������Ҷ�
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
//��������飬����mem_refer
reg [5:0] channel;      //������ݿ�ı��
reg [5:0] block_num;    //CHANNEL_IN_NUM/CHANNEL_OUT_NUM
reg [20:0] rptr;        //������ݿ��һ��������mem_bigһ���еĵ�ַ
reg       h_cnt_big_dir;//��mem_big��ȡ����ʱ���м������Ӽ��ķ���1��������2���ݼ�
reg [30:0]rptr_frame;   //֡���岻ʹ�ܽ��������ʱ����mem_refer�ĵ�ַָ�룬
reg [30:0]rptr_refer;   //�����ʱ��mem_refer�еĵ�ַָ��
begin
    channel   = 0;
    block_num = CHANNEL_IN_NUM/CHANNEL_OUT_NUM;
    judge_direction();
    mem_gather();
    repeat(CHANNEL_OUT_NUM) begin //ѡȡÿ��������ݿ�
        if((TOP_BOTTOM_SEL == 1'b1) && (channel >= CHANNEL_OUT_NUM/2) && (CHANNEL_OUT_NUM != 1)) begin
        //�����������ݿ���°벿��
            if(OUTPUT_DIRECTION[channel] == 1'b0) begin
                rptr = (col_max) * (CHANNEL_OUT_NUM - 1'b1 - channel)
                        * block_num + OVERLAP_WIDTH*(!mode);
            end
            else begin
                rptr = (col_max) * (CHANNEL_OUT_NUM - channel)
                        * block_num + 2*OVERLAP_WIDTH - 1'b1 - OVERLAP_WIDTH*(!mode);
            end
            h_cnt_big_dir = 1'b0;   //ȡ����ʱmem_big�м������ݼ�
        end
        else begin //��һ�����ݿ�
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
    //��ӡmem_refer
    // for (int i = 0; i < CHANNEL_OUT_NUM; i++) begin
    //     $display("CHANNEL%0d",i);
    //     for (int j = 0; j < ram_add_end; j++) begin
    //         $write("%0d    ",mem_refer[i][j]);
    //     end
    // end
end
endtask

endmodule