.data
countdown_message: .asciiz "Hello, World!\n"

.text
main:
    # Initialize counter with the number of seconds (10 seconds in this case)
    li $t0, 10

countdown_loop:
    # Display the countdown value
    move $a0, $t0          # Load the countdown value into $a0
    li $v0, 1              # System call for print integer
    syscall

    # Delay for approximately 1 second (adjust the delay based on your MIPS machine's speed)
    li $v0, 32             # System call for sleep
    li $a0, 1              # Sleep for 1 second (adjust as needed)
    syscall

    # Decrement the counter
    subi $t0, $t0, 1

    # Check if the countdown has reached zero
    bnez $t0, countdown_loop

    # Print "Hello, World!" after the countdown
    li $v0, 4              # System call for print string
    la $a0, countdown_message
    syscall

    # Exit the program
    li $v0, 10             # System call for exit
    syscall
