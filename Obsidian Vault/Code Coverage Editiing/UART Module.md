### Full Top Module
![[Pasted image 20250329141113.png]]
so we obviously still have the **rstN** not completely set off and the

**tx_full** the TX never gets full this is actually quite OK but we might have to insert the full value in order to test it's functionality in order to check it all out 

**rx_rd** I believe this signal is just not really necessary 

**rx_empty** once again its honestly a good thing that this never properly gets set off but we should still work force this to be on to see exactly what happens
### uart_tx_inst
this is generally OK but we have a few issues regarding width 
![[Pasted image 20250329141714.png]]
TX_reg and TX_next will never be larger than 1 bit as its basically just an on or off and it will only output the first bit regardless so it just not worth it to have ti be more than one bit 
### fifo_rx (ignore and explain)
![[Pasted image 20250329141957.png]]
this is simply kind of confusing . we don't have any address or any complex stack for output so I'm confused by the use of addresses and the such. we should go through the FIFO code to explain the situation and how to index through the code 
![[Pasted image 20250329143605.png]]
looking into the control section specifically non of the addressing and the filling for the fifo actually do anything we should look into the entire control based module for the fifo in order to figure out exactly what it is doing ### fifo_tx

![[Pasted image 20250329143757.png]]
basically we need to see what happens when full we need to go through the fifo modules as a whole