interface spi_if (input logic rst, input logic clk);
  wire           [8-1:0] ss_pad_o;         // slave select
  wire                   sclk_pad_o;       // serial clock
  wire                   mosi_pad_o;       // master out slave in
  logic                  miso_pad_i;       // master in slave out

	bit loopback_en;
	logic miso_bit;

	assign miso_pad_i = (loopback_en == 1) ? mosi_pad_o : miso_bit;

	initial begin
		loopback_en = 0;
		miso_bit = 1;
	end

endinterface

