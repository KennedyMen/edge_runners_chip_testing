> #### Full top module
>
> ![](https://holocron.so/uploads/535e2dc1-pasted-image-20250328204420.png)


> to start we have very low coverage on specific points specifically on sections where the bit with is 10 (or ten with bit slicing)
>
> ![](https://holocron.so/uploads/eb558103-pasted-image-20250328204712.png)


> after a bit of looking it seems to be because the values for the 9th and 10th are never set on or off. i have believe this is due to either the values never updating or being read at that level and being truncated at the test-bench
>
> the other reality is that there just might not be anything becoming that large

> #### inner Module arc_tan.sv
>
> ![](https://holocron.so/uploads/618fa36d-pasted-image-20250328212216.png)


> the most basic problems that i'm seeing is the fact that the  G values are severely loosing in terms in coverage assuming with the fact that the top input and output are actually inputting everything i'm assuming that it just isn't calculating values that high
>
> ![](https://holocron.so/uploads/c6ee629b-pasted-image-20250328212146.png)


> from the fact that we have differing values here that don't look quite right means that i'm probably correct in my assessment here and its a matter of giving a kernel that will allow for this