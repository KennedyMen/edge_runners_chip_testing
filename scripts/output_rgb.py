from PIL import Image
import numpy as np
import argparse

def txt_to_png_rgb(txt_file, png_file, width=512, height=512):
    data = []
    invalid_count = 0

    with open(txt_file, 'r') as f:
        for line_num, line in enumerate(f, start=1):
            line = line.strip()
            if len(line) == 24 and all(c in "01" for c in line):
                r = int(line[0:8], 2)   # First 8 bits -> Red
                g = int(line[8:16], 2)  # Next 8 bits -> Green
                b = int(line[16:24], 2) # Last 8 bits -> Blue
                data.append((r, g, b))
            else:
                print(f"Warning: Replacing invalid line {line_num} with black")
                data.append((0, 0, 0))  # Replace invalid entries with black
                if line_num <= width * height:
                    invalid_count += 1

    print("Number of invalid pixels =", invalid_count)

    # Ensure data has exactly width * height elements
    if len(data) != width * height:
        print(f"Warning: Adjusting pixel count from {len(data)} to {width * height}")
        data = data[:width * height] + [(0, 0, 0)] * (width * height - len(data))

    # Convert to numpy array and reshape
    image_array = np.array(data, dtype=np.uint8).reshape((height, width, 3))

    # Create and save the image
    image = Image.fromarray(image_array, mode='RGB')
    image.save(png_file)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert a text file of 24-bit RGB values to a PNG image.")
    parser.add_argument("-i", "--input", required=True, help="Path to the input text file")
    parser.add_argument("-o", "--output", required=True, help="Path to the output PNG file")

    args = parser.parse_args()
    txt_to_png_rgb(args.input, args.output)
