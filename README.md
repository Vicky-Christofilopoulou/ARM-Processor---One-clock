# ARM-Processor-One-clock

The goal of this project is to design the microarchitecture of a simplified single-cycle ARM processor in FPGA technology, using the Vivado IDE (Integrated Development Environment) tool from Xilinx.

The processor consists of two parts: the datapath, which processes data in the appropriate arithmetic and logic units, and the control unit, which decodes the instruction and generates the corresponding control signals.

![image](https://github.com/user-attachments/assets/3e3f0bda-ed05-4596-897c-e0b4672f294a)


The ARM processor that will be designed consists of two key components: the datapath and the control unit.

## Datapath: 
This component is responsible for carrying out all the data processing operations. It consists of various functional blocks such as registers, multiplexers, arithmetic and logic units (ALUs), and data buses that work together to execute the instructions. These blocks interact to perform tasks such as adding, subtracting, logical operations (like AND, OR), and data movement operations (like loading from memory or writing back to memory).

## Control Unit: 
The control unit plays a crucial role in decoding the instructions and generating the appropriate control signals that drive the datapath. The control unit interprets each instruction based on its opcode and operands, then produces signals that control the operation of the datapath components (such as selecting specific registers, enabling certain ALU operations, and controlling memory access).

This design approach is a simplified version of the ARM processor architecture, focusing on a single-cycle execution model. Each instruction is designed to be completed in one clock cycle, making the design easier to implement and analyze, though it may not be as efficient as more complex multi-cycle or pipelined processors.
