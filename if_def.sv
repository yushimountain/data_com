//==================================================================================================
//  Copyright     : 重庆宜时宜景公司
//  Filename      : if_def.sv
//  Description   : 更改testbench顶层的输入参数
//  Date          : 2016/7/20
//  Author        : WangTao
//==================================================================================================
`timescale  1ns/1ps

 `define a194
//下面是港宇基本配置
// `define a9        //2 1 2 0 0 w
// `define a43       //4 2 2 1 0 w
// `define a44       //4 2 2 1 1 w
// `define a161      //32 4 1 0 0 q
// `define a163      //32 4 2 0 0
// `define a193      //32 4 2 1 0
// `define a194      //32 4 2 1 1 s

module if_def ();

parameter    VIDEO_DATA_WIDTH  = 30;
parameter    TIMING_CNT_WIDTH  = 11;
parameter    OVERLAP_WIDTH     = 4;
parameter    RAM_DEPTH         = 1024*OVERLAP_WIDTH;
parameter    OUTPUT_DIRECTION  = 64'hb;

`ifdef  a1
    parameter CHANNEL_IN_NUM   = 1;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a2
    parameter CHANNEL_IN_NUM   = 1;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a3
    parameter CHANNEL_IN_NUM   = 1;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a4
    parameter CHANNEL_IN_NUM   = 1;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a5
    parameter CHANNEL_IN_NUM   = 2;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a6
    parameter CHANNEL_IN_NUM   = 2;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a7
    parameter CHANNEL_IN_NUM   = 2;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a8
    parameter CHANNEL_IN_NUM   = 2;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a9
    parameter CHANNEL_IN_NUM   = 2;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a10
    parameter CHANNEL_IN_NUM   = 2;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a11
    parameter CHANNEL_IN_NUM   = 2;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a12
    parameter CHANNEL_IN_NUM   = 2;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a13
    parameter CHANNEL_IN_NUM   = 2;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a14
    parameter CHANNEL_IN_NUM   = 2;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a15
    parameter CHANNEL_IN_NUM   = 2;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a16
    parameter CHANNEL_IN_NUM   = 2;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a17
    parameter CHANNEL_IN_NUM   = 2;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a18
    parameter CHANNEL_IN_NUM   = 2;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a19
    parameter CHANNEL_IN_NUM   = 2;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a20
    parameter CHANNEL_IN_NUM   = 2;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a21
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a22
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a23
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a24
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a25
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a26
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a27
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a28
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a29
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a30
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a31
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a32
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a33
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a34
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a35
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a36
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a37
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a38
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a39
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a40
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a41
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a42
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a43
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a44
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a45
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a46
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a47
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a48
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a49
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a50
    parameter CHANNEL_IN_NUM   = 4;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a51
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a52
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a53
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a54
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a55
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a56
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a57
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a58
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a59
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a60
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a61
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a62
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a63
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a64
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a65
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a66
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a67
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a68
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a69
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a70
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a71
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a72
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a73
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a74
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a75
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a76
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a77
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a78
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a79
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a80
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a81
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a82
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a83
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a84
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a85
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a86
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a87
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a88
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a89
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a90
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a91
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a92
    parameter CHANNEL_IN_NUM   = 8;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a93
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a94
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a95
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a96
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a97
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a98
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a99
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a100
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a101
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a102
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a103
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a104
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a105
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a106
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a107
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a108
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a109
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a110
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a111
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a112
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a113
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a114
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a115
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a116
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a117
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a118
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a119
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a120
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a121
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a122
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a123
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a124
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a125
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a126
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a127
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a128
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a129
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a130
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a131
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a132
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a133
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a134
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a135
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a136
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a137
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a138
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a139
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a140
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a141
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a142
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a143
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a144
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a145
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a146
    parameter CHANNEL_IN_NUM   = 16;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a147
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a148
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a149
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a150
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a151
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a152
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a153
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a154
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a155
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a156
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a157
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a158
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a159
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a160
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a161
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a162
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a163
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a164
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a165
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a166
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a167
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a168
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a169
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a170
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a171
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a172
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a173
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a174
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a175
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a176
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a177
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a178
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a179
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a180
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a181
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a182
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a183
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a184
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a185
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a186
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a187
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a188
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a189
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a190
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a191
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a192
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a193
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a194
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a195
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a196
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a197
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a198
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a199
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a200
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a201
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a202
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a203
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a204
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a205
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a206
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a207
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a208
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a209
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a210
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a211
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a212
    parameter CHANNEL_IN_NUM   = 32;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a213
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a214
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a215
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a216
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a217
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a218
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 1;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a219
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a220
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a221
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a222
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a223
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a224
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a225
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a226
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a227
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a228
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a229
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a230
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a231
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a232
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a233
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a234
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a235
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a236
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a237
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a238
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a239
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a240
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a241
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a242
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a243
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a244
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a245
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a246
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a247
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a248
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a249
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 64;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a250
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 64;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a251
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 64;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a252
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 64;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a253
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 64;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a254
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 64;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 0;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a255
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a256
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a257
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a258
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a259
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a260
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 2;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a261
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a262
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a263
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a264
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a265
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a266
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 4;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a267
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a268
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a269
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a270
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a271
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a272
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 8;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a273
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a274
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a275
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a276
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a277
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a278
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 16;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a279
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a280
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a281
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a282
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a283
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a284
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 32;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a285
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 64;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a286
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 64;
    parameter HEAD_DIRECTION   = 0;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a287
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 64;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a288
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 64;
    parameter HEAD_DIRECTION   = 1;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif


`ifdef  a289
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 64;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 0;
`endif


`ifdef  a290
    parameter CHANNEL_IN_NUM   = 64;
    parameter CHANNEL_OUT_NUM  = 64;
    parameter HEAD_DIRECTION   = 2;
    parameter TOP_BOTTOM_SEL   = 1;
    parameter FRAME_RAM_EN     = 1;
`endif

top #(
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
    ) top();

endmodule
