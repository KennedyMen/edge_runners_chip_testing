`timescale 1ps/1ps

module hysteresis_tb;

  logic         clk;
  logic         rstN;
  logic [7:0]   pixel_in;
  logic         pixel_in_valid;
  logic [71:0]  pl1_data_out, pl2_data_out;
  logic [98:0]  pl3_data_out; 
  logic [17:0]  pl5_data_out;
  logic [17:0]  pl4_data_out;
  logic         pl1_data_out_valid, pl2_data_out_valid, pl3_data_out_valid, pl4_data_out_valid, pl5_data_out_valid;
  logic [7:0]   gaussian_pixel_out;
  logic         gaussian_pixel_out_valid;
  logic [10:0]  gradient_magnitude;
  logic [1:0]   gradient_direction;
  logic         gradient_out_valid; 
  logic [7:0]   sobel_out;
  logic [7:0]   sobel_out_x, sobel_out_y;
  logic         sobel_xy_valid;
  logic [10:0]  nms_magnitude;
  logic [1:0]   nms_direction;
  logic         nms_valid;
  logic [1:0]   strength;
  logic         str_valid;
  logic [7:0]   pixel_out;
  logic         pixel_out_valid;

  pixel_loader pl1(
    .clk(clk),
    .rstN(rstN),
    .pixel_in(pixel_in),
    .pixel_in_valid(pixel_in_valid),
    .pixel_data_out(pl1_data_out),
    .pixel_data_out_valid(pl1_data_out_valid)
  );

  gaussian_filter g1(
    .clk(clk),
    .rstN(rstN),
    .gaussian_data_in(pl1_data_out),
    .gaussian_data_in_valid(pl1_data_out_valid),
    .gaussian_pixel_out(gaussian_pixel_out),
    .gaussian_pixel_out_valid(gaussian_pixel_out_valid)
  );

  pixel_loader pl2(
    .clk(clk),
    .rstN(rstN),
    .pixel_in(gaussian_pixel_out),
    .pixel_in_valid(gaussian_pixel_out_valid),
    .pixel_data_out(pl2_data_out),
    .pixel_data_out_valid(pl2_data_out_valid)
  );

  gradient_calculation gc(
    .clk(clk), 
    .rstN(rstN),
    .gradient_data_in(pl2_data_out),
    .gradient_data_in_valid(pl2_data_out_valid),
    .gradient_magnitude(gradient_magnitude),
    .gradient_direction(gradient_direction),
    .gradient_out_valid(gradient_out_valid),
    .pixel_out(sobel_out),
    .pixel_out_x(sobel_out_x),
    .pixel_out_y(sobel_out_y),
    .pixel_xy_valid(sobel_xy_valid)
  );

  pixel_loader #(.ITEM_SIZE(11)) pl3(
    .clk(clk),
    .rstN(rstN),
    .pixel_in(gradient_magnitude),
    .pixel_in_valid(gradient_out_valid),
    .pixel_data_out(pl3_data_out),
    .pixel_data_out_valid(pl3_data_out_valid)
  );

  pixel_loader #(.ITEM_SIZE(2)) pl4(
    .clk(clk),
    .rstN(rstN),
    .pixel_in(gradient_direction),
    .pixel_in_valid(gradient_out_valid),
    .pixel_data_out(pl4_data_out),
    .pixel_data_out_valid(pl4_data_out_valid)
  );

  non_max_suppression nms(
    .clk(clk),
    .rstN(rstN),
    .gradient_magnitude(pl3_data_out),
    .gradient_direction(pl4_data_out),
    .gradient_data_valid(pl3_data_out_valid),
    .nms_magnitude(nms_magnitude),
    .nms_direction(nms_direction),
    .nms_valid(nms_valid)
  );

  double_threshold db(
    .clk(clk),
    .rstN(rstN),
    .magnitude(nms_magnitude),
    .mag_valid(nms_valid),
    .strength(strength),
    .str_valid(str_valid)
  );

  pixel_loader #(.ITEM_SIZE(2)) pl5(
    .clk(clk),
    .rstN(rstN),
    .pixel_in(strength),
    .pixel_in_valid(str_valid),
    .pixel_data_out(pl5_data_out),
    .pixel_data_out_valid(pl5_data_out_valid)
  );

  hysteresis ht(
    .clk(clk),
    .rstN(rstN),
    .strength(pl5_data_out),
    .str_valid(pl5_data_out_valid),
    .edge_out(pixel_out),
    .edge_out_valid(pixel_out_valid)
  );

  byte image_mem[512*512]; // Array to store image data 

  task read_txt_file;
    int file;               // File handle
    int byte_data;          // Variable to store byte data
    int i;                  // Loop index
    
    // Open the file for reading
    file = $fopen("./testImages/images_binary/\t291.txt", "rb");
    if (file == 0) begin
      $error("ERROR: Could not open the text file.");
      $finish;
    end
    
    // Read the file byte by byte (for text files, each character is 1 byte)
    i = 0;
    while (!$feof(file)) begin
      byte_data = $fgetc(file); // Read 1 byte
      if (byte_data == -1) begin
        // End of file or an error
        break;
      end
      image_mem[i] = byte_data; // Store the byte in memory
      i = i + 1;
    end

    // Close the file
    $fclose(file);

    $display("File read complete. Total bytes read: %0d", i);
  endtask

  // Clock generation
  always #5 clk = ~clk;

  // Reset and drive the pixel input with random values
  initial begin
    clk = 1;
    rstN = 0;
    pixel_in = 8'b0;
    pixel_in_valid = 0;
    read_txt_file();

    // Apply reset for a few clock cycles
    #20;
    rstN = 1;

    for (int i = 0; i < 262144; i++) begin
      pixel_in = image_mem[i]; 
      pixel_in_valid = 1;  // Set the input valid
      #10;  // Wait for one clock cycle
    end
    pixel_in_valid = 0;
  end

  int file2;
  task clear_file;
    input string path;
    begin
      // clear the file
      file2 = $fopen(path, "w");
      if (file2 == 0) begin
        $display("Error: Unable to open file for writing.");
      end
      $fclose(file2);
    end
  endtask

  // Task to write pixel value to the .txt file
  task write_pixel_to_file;
    input logic [7:0] pixel_value;  // Pixel value to write
    input string path;
    begin
      // Open the file in append mode
      file2 = $fopen(path, "a");
      if (file2) begin
        // Write the pixel value to the file (in binary format, followed by newline)
        $fwrite(file2, "%b\n", pixel_value);  // Write binary representation of the pixel
        $fclose(file2);  // Close the file after writing
      end else begin
        $display("Error: Unable to open file for writing.");
      end
    end
  endtask

  task write_rgb_to_file;
    input logic [23:0] pixel_value;  // Pixel value to write
    input string path;
    begin
      // Open the file in append mode
      file2 = $fopen(path, "a");
      if (file2) begin
        // Write the pixel value to the file (in binary format, followed by newline)
        $fwrite(file2, "%b\n", pixel_value);  // Write binary representation of the pixel
        $fclose(file2);  // Close the file after writing
      end else begin
        $display("Error: Unable to open file for writing.");
      end
    end
  endtask

  initial begin
    clear_file("./testImages/output_binary/direction_contour.txt");
    clear_file("./testImages/output_binary/edge.txt");
    clear_file("./testImages/output_binary/gaussian_output.txt");
    clear_file("./testImages/output_binary/gradient_magnitude.txt");
    clear_file("./testImages/output_binary/gradient_direction.txt");
    clear_file("./testImages/output_binary/intermediate_edge.txt");
    clear_file("./testImages/output_binary/intermediate_x.txt");
    clear_file("./testImages/output_binary/intermediate_y.txt");
    clear_file("./testImages/output_binary/nms.txt");
    clear_file("./testImages/output_binary/nms_dir.txt");
  end

  always @ (posedge clk) begin
    if (gaussian_pixel_out_valid) begin
      write_pixel_to_file(gaussian_pixel_out, "./testImages/output_binary/gaussian_output.txt");
    end
    if (gradient_out_valid) begin
      write_pixel_to_file(gradient_magnitude, "./testImages/output_binary/gradient_magnitude.txt");
      write_pixel_to_file(gradient_direction, "./testImages/output_binary/gradient_direction.txt");
      case (gradient_direction)
        0: write_rgb_to_file(24'h0000FF, "./testImages/output_binary/direction_contour.txt");
        1: write_rgb_to_file(24'h00FF00, "./testImages/output_binary/direction_contour.txt");
        2: write_rgb_to_file(24'hFF0000, "./testImages/output_binary/direction_contour.txt");
        3: write_rgb_to_file(24'hFFFF00, "./testImages/output_binary/direction_contour.txt");
      endcase
      write_pixel_to_file(sobel_out, "./testImages/output_binary/intermediate_edge.txt");
    end
    if (sobel_xy_valid) begin
      write_pixel_to_file(sobel_out_x, "./testImages/output_binary/intermediate_x.txt");
      write_pixel_to_file(sobel_out_y, "./testImages/output_binary/intermediate_y.txt");
    end
    if (nms_valid) begin
      write_pixel_to_file(nms_magnitude, "./testImages/output_binary/nms.txt");
      write_pixel_to_file(nms_direction, "./testImages/output_binary/nms_dir.txt");
    end
    if (pixel_out_valid) begin
      write_pixel_to_file(pixel_out,
      "./testImages/output_binary/edge.txt");
    end
  end

endmodule: hysteresis_tb
