///////////////////////////
// Test Bench
///////////////////////////

`timescale 1ns/1ps

// 乘法的检测对比模�?
module multiplier_compare(a, b, p);
    input signed    [15:0] a, b;
    output signed   [31:0] p;
    assign          p = a*b;
endmodule

// tb 模块
module multiplier_tb;
    // 时钟信号
    parameter	TCLK = 22;
    reg		clk;
    // 测试过程中，我们�?要关注的�?
    reg		[15: 0]	x, y;       // 测试用例
    wire	[31: 0] res;        // 乘法器计算�??
    wire   	[31: 0] res_com;    // 对照�?
    // 初始化时钟信号，并且每过 5 个时钟单位，clk 跳变�?�?
    initial	clk = 1'b0;
    always #(TCLK/2)	clk = ~clk;
    
    // 存在计算错误时的部分
    reg[31: 0] res_com1, res_com2, res_com3; // 保存�?近三次的计算结果
    reg[5 : 0] counter; // 错误计数
    initial counter = 0;
    always @(posedge clk)
        begin
            // 保存�?近三次，正确的计算结�?
            res_com1 <= res_com;
            res_com2 <= res_com1;
            res_com3 <= res_com2;
            if (res != res_com)
                counter <= counter+1;
        end

    // 生成 100 对乘法对，数量可以自行调�?
    initial
        begin
            repeat(100)
                begin
                    // 生成 16 位的数据
                    // 也就是小�? 17'h10000 的数�?
                    x = {$random}%17'h10000;
                    y = {$random}%17'h10000;
                    // 每一对乘法数据延�? TCLK
                    // 每一�? TCLK 里会有一�? clk 上升沿到�?
                    // 每次 clk 上升沿进行一次错误检�?
                    // 也就保证每对乘法数据都进行一次错误检�?
                    #TCLK ; 
                end
            $stop;
        end

    // 调用加法器进行计�?
    TopMultiplier multiplier_tb	(.x_in (x),
                                .y_in (y),
                                .result_out (res)
                                );
    // 调用加法，对比模块计�?
    multiplier_compare	multiplier_com (.a(x),
                                        .b(y),
                                        .p(res_com)
                                        );

endmodule