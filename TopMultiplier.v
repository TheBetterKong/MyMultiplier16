// 16 位乘法器的顶层模块，构建其整体框架

module	TopMultiplier ( x_in, y_in, result_out );

input	[15: 0]	x_in, y_in;
output	[31: 0]	result_out;

// 生成的中间互连，具体含义可见结构图
wire	[15:0]	pp0, pp1, pp2, pp3, pp4, pp5, 
				pp6, pp7, pp8, pp9, pp10, pp11, 
				pp12, pp13, pp14, pp15; 
wire	[31: 0]	opa, opb;
wire	[15: 0]	sign;
wire	[31: 0]	sign_compensate;
wire	[31: 0]	res_tmp;

// 部分积生成
Booth	booth (	.M( x_in ),
						.R( y_in ),
						.pp0( pp0 ),
						.pp1( pp1 ),
						.pp2( pp2 ),
						.pp3( pp3 ),
						.pp4( pp4 ),
						.pp5( pp5 ),
						.pp6( pp6 ),
						.pp7( pp7 ),
						.pp8( pp8 ),
						.pp9( pp9 ),
						.pp10( pp10 ),
						.pp11( pp11 ),
						.pp12( pp12 ),
						.pp13( pp13 ),
						.pp14( pp14 ),
						.pp15( pp15 ),
						.S( sign )
						);

// 调用 wallace 树相加部分积
WallaceTree16 wallace (	
							.pp0( pp0 ),
							.pp1( pp1 ),
							.pp2( pp2 ),
							.pp3( pp3 ),
							.pp4( pp4 ),
							.pp5( pp5 ),
							.pp6( pp6 ),
							.pp7( pp7 ),
							.pp8( pp8 ),
							.pp9( pp9 ),
							.pp10( pp10 ),
							.pp11( pp11 ),
							.pp12( pp12 ),
							.pp13( pp13 ),
							.pp14( pp14 ),
							.pp15( pp15 ),
							.opa( opa),
							.opb( opb)
						);

// 计算部分积的符号补偿
// 每一个部分积都应该有一位符号位，16 个部分积因此符号位应该是一个 16 位信号
SRCS_Adder32	signcomp (
						.a( {~sign, 16'b0} ),
						.b( {15'b0, 1'b1, 16'b0} ),
						.cin( 1'b0 ),
						.sum( sign_compensate ),
						.cout()
					);

// 部分积的和部分
SRCS_Adder32	resulttemp (
							.a( opa ),
							.b( opb ),
							.cin( 1'b0 ),
							.sum( res_tmp ),
							.cout()
						);

// 最终结果
SRCS_Adder32	result (
						.a( res_tmp ),
						.b( sign_compensate ),
						.cin( 1'b0 ),
						.sum( result_out),
						.cout()
					);

endmodule