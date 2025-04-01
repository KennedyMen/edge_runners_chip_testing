
### Full top module

![](https://holocron.so/uploads/535e2dc1-pasted-image-20250328204420.png)

to start we have very low coverage on specific points specifically on sections where the bit with is 10 (or ten with bit slicing)

 ![](https://holocron.so/uploads/eb558103-pasted-image-20250328204712.png)
 after a bit of looking it seems to be because the values for the 9th and 10th are never set on or off. i have believe this is due to either the values never updating or being read at that level and being truncated at the test-bench

 the other reality is that there just might not be anything becoming that large
###  arc_tan.sv

 ![](https://holocron.so/uploads/618fa36d-pasted-image-20250328212216.png)

 the most basic problems that i'm seeing is the fact that the  G values are severely loosing in terms in coverage assuming with the fact that the top input and output are actually inputting everything i'm assuming that it just isn't calculating values that high

 ![](https://holocron.so/uploads/c6ee629b-pasted-image-20250328212146.png)


 from the fact that we have differing values here that don't look quite right means that i'm probably correct in my assessment here and its a matter of giving a kernel that will allow for this
$$
\Theta = atan2(G_y,G_x)
$$
this equation directly determines the angle we'll get for the entirety of the module 
to start 
![[Pasted image 20250328230717.png]]
the basic explanation here is that this number will never touch the top two bits due to the fact that we need an angle of y of negative 1024 and and angle of 512 in order to flip these bits for checking this is due the face that we need to do the 2's complement which basically means we need to add a kernel that outputs this
![[Pasted image 20250328231426.png]]
this section to determine the intermediate values we need to make sure we have a couple of values but there's the problem that we cannot get full coverage due to the largest possible number i can get the top 19th bit with this being $$
1024\cdot424=
434176=1101010000000000000\  (19 bits)
$$
however due to us multiplying by a even number its actually impossible to get the bottom singular bit but we can get the top two it'd be better to simply make the cl value much smaller and then work with it 

overall for this module its all about making sure that we choose correct bit widths in order to make sure it all works properly 


### pixel_loaders
![[Pasted image 20250329130956.png]]
**row counter** basically doesn't need to exist. yes its nice but they are at the very least it inst necessary but we don't need it in the future it is just a counter that increments but is never properly called upon for any reason 
![[Pasted image 20250329131051.png]]
**buffer_pixel_count** never becomes larger than 10 bits 11 bits doesn't get to 1536 and if it reaches that it resets in the READ section 
![[Pasted image 20250329131132.png]]
**also set off rstN**

#### pl3
same issues as other pixel loaders save for some extra things neccesary 
![[Pasted image 20250329131209.png]]
**Pixel_in/buffer0-3_out** these need to output an entire value of 768 at least on every single pixel in a kernel so in our case we need a kernel where the gradient value will be 768 for every single value

#### pl5 
very low row counter value in this case there seem to be lost rows specifically for hysteresis this needs to be addressed if that matters but the row counter is completely unimportant 
![[Pasted image 20250329131233.png]]






### Non-Max-Suppresion
![[Pasted image 20250329131336.png]]
frankly same issue. we need to create a kernel where the entirety of the kernel will have an output of 768 in order to get full toggle coverage 
## Double Threshold
![[Pasted image 20250329131528.png]]
basically it another necessary 768 magnitude kernel
## Gaussian Filter 
![[Pasted image 20250329133110.png]]
the problem is again the width of the sum_data unfortunately you just can't get a value taking up 16 bits the maximum that it could be is 12 bits this is another bit width change 
$$
\begin{aligned}
sum\_data= (4*in)+4(2*in)+4(in)\\
if \ in=255 \ sum\_data= 4080 
\end{aligned}
$$
also reset 

## Gradient Calculation

Ok so we've got some real issues here regarding actual building of the gradient data as our edge cases just will not work properly 
![[Pasted image 20250329134416.png]]

**square_data_x&y** we have a major issue the width is actually too short the maximum we can get for the square data is 
$$
\begin{flalign*}
    \text{square\_data} &= \text{sum\_data\_x}^2 \\ 
    \text{if } sum\_data\_x &= 2047, \quad \text{then } \text{square\_data} = 4190209 \\ 
    \text{square\_data\_2} &= 1111111111000000000001 \quad \text{(Width = 22 bits)}
\end{flalign*}
$$

this means that 1. we aren't fully utilizing the data so it seems that we need to make a sum data x and sum data y value 
![[Pasted image 20250329140040.png]]
furthermore we have an issue where we need to basically output a signed gradient data that will be a full size value that will multiply to the largest possible number. in order to get that i think that outputting with a fully bright kernel with maxed out values will fix it but we also need to make it so that the square data is 22 bits in order to be able to take the maximum possible value 
## Hysteresis is completely at 100% no issues good job 
