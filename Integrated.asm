.data
carID:               .word 1, 2, 3, 4, 5     # array of car IDs allowed to enter school (5 cars for prototype purposes)
prompt_entry:        .asciiz "Enter car's ID: "
alert_msg:           .asciiz "Alert: Unregistered car. You may not enter. Proceed to Guard post to request guest ID"
allow_msg:           .asciiz "Welcome to Sekolah Menengah Jujutsu. You may enter."
countdown_msg:       .asciiz "\nALARM BUZZES, PLEASE EXIT PARKING LOT!"
prompt_studentID:    .asciiz "Student ID: "
unauthorized_msg:    .asciiz "Unauthorized access. Please contact school administration."

.text
main:
    # Module 1: Car Entry System

    # Prompt user for input
    li $v0, 4            # Print string
    la $a0, prompt_entry # Load address of prompt_entry string
    syscall

    # Read car's ID from user
    li $v0, 5            # Read integer
    syscall
    move $t0, $v0        # Move the car's ID to register $t0

    # Check if the car's ID is allowed to enter
    la $t1, carID        # Load the base address of the array
    li $t2, 0            # Initialize loop counter

checkID:
    lw $t3, 0($t1)       # Load the current car ID from the array
    beq $t0, $t3, allow   # Branch to allow if car ID matches
    addi $t1, $t1, 4     # Move to the next element in the array
    addi $t2, $t2, 1     # Increment loop counter
    bne $t2, 5, checkID  # Continue loop if not checked all IDs
    j unauthorized       # Jump to unauthorized if none of the IDs match

allow:
    # Car is within the allowed list
    la $a0, allow_msg    # Load address of allow_msg string
    jal PrintString      # Call the PrintString subroutine
    jal module2

unauthorized:
    # Car is not within the allowed list
    la $a0, alert_msg    # Load address of alert_msg string
    jal PrintString      # Call the PrintString subroutine


# Module 2: Countdown System

    # Set flag to avoid printing RFID read range again
module2:
    li $t2, 1

    # Simulate displaying countdown message
    la $a0, countdown_msg # Load countdown message
    jal PrintString       # Call the PrintString subroutine

    # Initialize counter with the number of seconds (30 seconds in this case)
    li $t0, 30

countdown_loop:
    # Display the countdown value
    move $a0, $t0          # Load the countdown value into $a0
    li $v0, 1              # System call for print integer
    syscall

    # Delay for approximately 1 second (adjust the delay to 10inst/sec on your MARS 4.5)
    li $v0, 32             # System call for sleep
    li $a0, 1              # Sleep for 1 second (adjust as needed)
    syscall

    # Decrement the counter
    subi $t0, $t0, 1

    # Check if the countdown has reached zero
    bnez $t0, countdown_loop

    # Print message after the countdown
    la $a0, countdown_msg
    jal PrintString

# Module 3: Display Student ID
module3:
    la $a0, prompt_studentID  # Load address of prompt_studentID string
    li $v0, 4                 # System call for print string
    syscall

    # Simulate displaying student ID on LED
    move $a0, $t3             # Load student ID into $a0
    li $v0, 1                 # System call for print integer
    syscall

    j end_program

end_program:
    # Exit program
    li $v0, 10                # Exit system call
    syscall

PrintString:
    # Print the null-terminated string at the address in $a0
    li $v0, 4                   # System call for print string
    syscall
    jr $ra                      # Return
