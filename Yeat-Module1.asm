#CSCI 3301 Group Project, Group Yeat
#Project : School Pick-up & Drop off sys
#Module 1 : Car entry system

#Sensor: Rfid reader, reads rfid stickers from parents car at school gate only allowing registered car to enter school compound. 

.data
carID:       	.word 1, 2, 3, 4, 5,     #array of car IDs allowed to enter school (5 cars for prototype purposes)
prompt:         .asciiz  "Enter car's ID : "
alert_msg:      .asciiz  "Alert: Unregistered car. You may not enter. Proceed to Guard post to request guest ID"
allow_msg:     .asciiz   "Welcome to Sekolah Menengah Jujutsu. You may enter."

.text
main:
    # Prompt user for input
    li $v0, 4            # Print string
    la $a0, prompt       # Load address of prompt string
    syscall

    # Read car's ID from user (enter int 1-5 for car entry test cases and else for entry declined)
    li $v0, 5            # Read integer
    syscall
    move $t0, $v0        # Move the car's ID to register $t0

    # Check if the car's ID is allowed to enter
    la $t1, carID        # Load the base address of the array
    li $t2, 0            # Initialize loop counter

checkID:
    lw $t3, 0($t1)       # Load the current car ID from the array
    beq $t0, $t3, allow # Branch to within if car ID matches
    addi $t1, $t1, 4     # Move to the next element in the array
    addi $t2, $t2, 1     # Increment loop counter
    bne $t2, 5, checkID  # Continue loop if not checked all IDs
    j unauthorized       # Jump to unauthorized if none of the IDs match

allow:
    # Car is within the allowed list
    la $a0, allow_msg   # Load address of within_msg string
    jal PrintString      # Call the PrintString subroutine
    j end_program

unauthorized:
    # Car is not within the allowed list
    la $a0, alert_msg    # Load address of alert_msg string
    jal PrintString      # Call the PrintString subroutine

end_program:
    # Exit program
    li $v0, 10           # Exit system call
    syscall


PrintString:
    # Print the null-terminated string at the address in $a0
    li $v0, 4         # System call for print_str
    syscall
    jr $ra            # Return
