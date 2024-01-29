#please run using speed 10inst/sec
.data
countdown_message: .asciiz "\nALARM BUZZES, PLEASE EXIT PARKING LOT!\n"
prompt1: .asciiz "Car Parked? (Enter 1 for True / 0 for False): "
.text
main:

    li $v0, 4               # syscall code for print_str
    la $a0, prompt1         # load address of prompt1
    syscall                 # print prompt1
    # Accept user input
    li $v0, 5               # syscall code for read_int
    syscall                 # read integer
    move $t0, $v0           # store user input in $t0
    # Check if car is parked
    beq $t0, 1, countdown   # if car is parked (input is 1), start countdown
    j exit        # if car is not parked (input is 0), exit program

 countdown:   
    # Initialize counter with the number of seconds (30 seconds in this case)
    li $t0, 30

countdown_loop:
    # Display the countdown value
    move $a0, $t0          # Load the countdown value into $a0
    li $v0, 1              # System call for print integer
    syscall

    # Delay for approximately 1 second (adjust the delay to 10inst/sec on ur MARS 4.5)
    li $v0, 32             # System call for sleep
    li $a0, 1              # Sleep for 1 second (adjust as needed)
    syscall

    # Decrement the counter
    subi $t0, $t0, 1

    # Check if the countdown has reached zero
    bnez $t0, countdown_loop

    # Print message after the countdown
    li $v0, 4              # System call for print string
    la $a0, countdown_message
    syscall

exit:
    # Exit the program
    li $v0, 10             # System call for exit
    syscall
