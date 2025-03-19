module double_thresholding
    import definitions_pkg::*;
(
    input logic [10:0] nms_magnitude,
    input logic nms_valid,
    output logic [1:0] strength,
    output logic strength_valid
);
    //double threshold parameter declaration 
    parameter t_high = 40;
    parameter t_low = 20;

    assign strength = (nms_magnitude >= t_high) ? 2'b01 :         //strong edge 
                      (nms_magnitude < t_low)  ? 2'b00 : 2'b10;      //discarded edge if true otherwise weak edge
    assign strength_valid = nms_valid;

endmodule




