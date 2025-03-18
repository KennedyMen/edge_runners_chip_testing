from PIL import Image
import numpy as np
# if you want to find the outputs from the simulation you can look in
# Vivado/Sims/nms_project.sim/sim_1/behav/xsim/testImages/
def txt_to_png(txt_file, png_file, width=512, height=512):
    data = []
    invalid_count = 0
    with open(txt_file, 'r') as f:
        for line_num, line in enumerate(f, start=1):
            line = line.strip()
            if len(line) == 11 and all(c in "01" for c in line):
                value = int(line, 2)
                # Scale from 11-bit (0-2047) to 8-bit (0-255) for display
                value = int((value / 2047) * 255)  # Scale to 8-bit range
                data.append(value)
            elif len(line) == 8 and all(c in "01" for c in line):
                data.append(int(line,2))
            else:
                print(f"Warning: Replacing invalid line {line_num} with 0")
                data.append(0)  # Replace invalid entries with 0 (black pixel)
                if (line_num <= 262144): invalid_count += 1              
    print("Number of invalid pixels =", invalid_count)

    # Ensure data has exactly width * height elements
    if len(data) != width * height:
        print(f"Warning: Adjusting pixel count from {len(data)} to {width * height}")
        data = data[:width * height] + [0] * (width * height - len(data))

    # Convert to numpy array and reshape
    image_array = np.array(data, dtype=np.uint8).reshape((height, width))

    # Create and save the image
    image = Image.fromarray(image_array, mode='L')  # 'L' mode for grayscale
    image.save(png_file)

if __name__ == "__main__":
    # Directly specify the input and output file paths
    input_file = "Vivado/Sims/nms_project.sim/sim_1/behav/xsim/testImages/output_binary/nms.txt"  # Replace with your input file path
    output_file = "testImages/Mensah_Testing/Outputting.png"  # Replace with your output file path
    
    txt_to_png(input_file, output_file)