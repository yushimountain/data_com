//=================================================================================================
//  Filename      : data_save.v
//  Description   : ���ݴ洢ģ��
//  Date          : 2016��7��12�� 10:22:46
//  Author        : PanShen
//=================================================================================================


module data_save (
    clk,
    ch_clk,
    ce,
    sclr,
    video_data_in,
    //from receive,for write
    wr_addr1,
    wr_addr2,
    pp_flagw,
    pp_flagr,
    effect_reigon,
    //from send, for read
    addra_s,
    ena_s,
    douta_s,
    addrb_s,
    enb_s,
    doutb_s
    );


parameter VIDEO_DATA_WIDTH  = 18;                   //��Ƶ�����źſ��
parameter TIMES             = 1;                    //�������������
parameter RAM_DEPTH         = 100;                  //�л���ram���
localparam ADDR_WIDTH       = clogb2(RAM_DEPTH-1);  //addra,addrb���

input                               sclr;
input                               ce;
input                               clk;
input                               ch_clk;
input [VIDEO_DATA_WIDTH-1'b1:0]     video_data_in;
input                               pp_flagw;       //ƹ�Ҳ�����־λ
input                               pp_flagr;       //ƹ�Ҳ�����־λ
input                               effect_reigon;  //�������ݵ���Ч����
input [ADDR_WIDTH-1'b1:0]           wr_addr1;       //����ָ�룬ram0ʹ��
input [ADDR_WIDTH-1'b1:0]           wr_addr2;       //����ָ�룬ram1ʹ��
input [ADDR_WIDTH-1:0]              addra_s;        //send --> receive
input [ADDR_WIDTH-1:0]              addrb_s;        //send --> receive
input                               ena_s;          //send --> receive
input                               enb_s;          //send --> receive

output [VIDEO_DATA_WIDTH-1'b1:0]    douta_s;        //send <-- receive
output [VIDEO_DATA_WIDTH-1'b1:0]    doutb_s;        //send <-- receive

reg    [1:0]                        wea;            //RAM1,RAM0дʹ�ܣ�1��a�˿�ֻд��0��a��ֻ��
reg    [1:0]                        ena_w;          //RAM a portʹ��
reg    [2*VIDEO_DATA_WIDTH-1'b1:0]  dina;           //a port д������

reg    [2*ADDR_WIDTH-1:0]           addra_r;        //RAM a port ��ַ
reg    [2*ADDR_WIDTH-1:0]           addrb;          //RAM a port ��ַ
reg    [1:0]                        ena_r;          //RAM a portʹ��
reg    [1:0]                        enb;            //RAM a portʹ��
reg    [VIDEO_DATA_WIDTH-1'b1:0]    douta_s;
reg    [VIDEO_DATA_WIDTH-1'b1:0]    doutb_s;
reg    [clogb2(TIMES-1)-1:0]        cnt_en_slow;    //port aдʹ���ź�
reg    [VIDEO_DATA_WIDTH-1:0]       video_data_in_d1;

wire   [2*ADDR_WIDTH-1:0]           addra;          //RAM a port ��ַ
wire   [1:0]                        ena;            //RAM a portʹ��
wire   [2*VIDEO_DATA_WIDTH-1'b1:0]  douta;
wire   [2*VIDEO_DATA_WIDTH-1'b1:0]  doutb;
wire                                en_slow;


//��������RAM
generate
    genvar i;
    for (i = 0; i < 2'd2; i=i+1'b1) begin : blk_ram_f
        true_dual_ram #(
        .RAM_WIDTH(VIDEO_DATA_WIDTH),         // Specify RAM data width
        .RAM_DEPTH(RAM_DEPTH),                // Specify RAM depth (number of entries)
        .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY"
        .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
        ) blk_ram (
        .clka(clk),         // Clock
        .wea(wea[i]),       // Port A write enable
        .web(1'd0),         // Port B write enable,only read ,so not used
        .ena(ena[i]),       // Port A RAM Enable, for additional power savings, disable port when not in use
        .enb(enb[i]),       // Port B RAM Enable, for additional power savings, disable port when not in use
        .addra(addra[i*ADDR_WIDTH + ADDR_WIDTH-1 -:ADDR_WIDTH]),   // Port A address bus
        .addrb(addrb[i*ADDR_WIDTH + ADDR_WIDTH-1 -:ADDR_WIDTH]),   // Port B address bus, width determined from RAM_DEPTH
        .dina(dina[i*VIDEO_DATA_WIDTH+VIDEO_DATA_WIDTH-1'b1 -:VIDEO_DATA_WIDTH]),   // Port A RAM input data, width determined from RAM_WIDTH,����
        .dinb({VIDEO_DATA_WIDTH{1'b0}}),                                            // Port B RAM input data, width determined from RAM_WIDTH
        .douta(douta[i*VIDEO_DATA_WIDTH+VIDEO_DATA_WIDTH-1'b1 -:VIDEO_DATA_WIDTH]), // Port A RAM output data, width determined from RAM_WIDTH
        .doutb(doutb[i*VIDEO_DATA_WIDTH+VIDEO_DATA_WIDTH-1'b1 -:VIDEO_DATA_WIDTH]), // Port B RAM output data, width determined from RAM_WIDTH
        .rsta(1'd0),     // Port A output reset (does not affect memory contents)
        .rstb(1'd0),     // Port B output reset (does not affect memory contents)
        .regcea(1'd1),   // Port A output register enable
        .regceb(1'd1)    // Port B output register enable
        );
    end
endgenerate

//en signal
always@(posedge clk)
    if(sclr)
        cnt_en_slow <= 0;
    else if(cnt_en_slow == TIMES - 1)
        cnt_en_slow <= 0;
    else
        cnt_en_slow <= cnt_en_slow + 1;

assign en_slow = (cnt_en_slow == TIMES - 1);

always @(posedge ch_clk) begin
    if(sclr) begin
        video_data_in_d1 <= 0;
    end else if(ce) begin
        video_data_in_d1 <= video_data_in;
    end
end

//���ݻ���
always @(*) begin
    if(ce) begin
        //��Ч����,д����ʹ��
        if(effect_reigon && en_slow) begin
            if(pp_flagw) begin//write ram0 for line 0,2,4
                ena_w    = 2'b01;
            end else begin //write ram1 for line  1,3,5
                ena_w    = 2'b10;
            end
        end else begin
            ena_w  = 2'b00;
        end
    end else begin
        ena_w  = 2'b00;
    end
end


//���ݻ���
always @(*) begin
    if(ce) begin
        //��Ч���䣬д���ݣ�дʹ��
        if(effect_reigon) begin
            if(pp_flagw) begin//write ram0 for line 0,2,4
                wea      = 2'b01;
                dina  = {{VIDEO_DATA_WIDTH{1'b0}},video_data_in_d1};
            end else begin    //write ram1 for line  1,3,5
                wea      = 2'b10;
                dina  = {video_data_in_d1,{VIDEO_DATA_WIDTH{1'b0}}};
            end
        end else begin
            wea    = 2'b00;
            dina   = 0;
        end
    end else begin
        wea    = 2'b00;
        dina   = 0;
    end
end


//��RAMƹ�Ҳ���
//��Щ���ena_r�˿�û��ʹ�ã�addra_sδ���������Ӷ�Ϊ����̬����ɫ����Ӱ����
always @(*) begin
    if(pp_flagr) begin//1 for ram1 when read
        enb      = {enb_s,1'b0};
        ena_r    = {ena_s,1'b0};
        addrb    = {addrb_s,{ADDR_WIDTH{1'b0}}};
        addra_r  = {addra_s,{ADDR_WIDTH{1'b0}}};

        doutb_s  = doutb[VIDEO_DATA_WIDTH*2-1 :VIDEO_DATA_WIDTH];
        douta_s  = douta[VIDEO_DATA_WIDTH*2-1 :VIDEO_DATA_WIDTH];
    end else begin
        enb      = {1'b0,enb_s};
        ena_r    = {1'b0,ena_s};
        addrb    = {{ADDR_WIDTH{1'b0}},addrb_s};
        addra_r  = {{ADDR_WIDTH{1'b0}},addra_s};

        doutb_s  = doutb[VIDEO_DATA_WIDTH-1 :0];
        douta_s  = douta[VIDEO_DATA_WIDTH-1 :0];
    end
end

//RAM��ַ�ϳ�
assign ena = ena_r | ena_w;
//ram0 ��ַѡ���Ƕ�����д
assign addra[ADDR_WIDTH-1:0] = wea[0] ? wr_addr1 : addra_r[ADDR_WIDTH-1:0];
//ram1 ��ַѡ���Ƕ�����д
assign addra[ADDR_WIDTH*2-1:ADDR_WIDTH] = wea[1] ? wr_addr2 : addra_r[ADDR_WIDTH*2-1:ADDR_WIDTH];

//  The following function calculates the ��ַ width based on specified RAM depth
function integer clogb2;
    input integer depth;
    for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
endfunction

endmodule