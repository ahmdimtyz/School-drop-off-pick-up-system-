#CSCI 3301 Group Project, Group Yeat
#Project : School Pick-up & Drop off sys
#Module 1 : Attendance reader system

#Sensor: Keyphob rfid tags, rfid reader, microcontroller, led display 

.data
RFID_READ_RANGE:  .word 15      # read the range of rfid readers(centimerters)
studentID:         .word 2123456   # a sample of student id 
checkin_message:   .asciiz "Check-in time: "
studentID_message: .asciiz " Student ID: "
unauthorized_message:  .asciiz "Unauthorized. Please contact the office." #displayed when the student ID is not registered 

.text
main:
    # Initialize components (assume RFID tag is scanned and ID is received)
    lw $t1, studentID          # Load authorized student ID

    # Simulate RFID reader detecting a student's tag within the read range
    lw $t0, RFID_READ_RANGE    # Load RFID read range
    li $t2, 0                  # Initialize flag to print RFID read range

    # Assuming the scanned RFID tag ID is in $t3
    # For simplicity, we'll directly use a hardcoded value here
    li $t3, 2123456               # Sample scanned RFID tag ID

    beq $t3, $t1, record_attendance   # Branch to record attendance if IDs match
    j unauthorized             # Jump to unauthorized if IDs do not match

record_attendance:
    # Record attendance 
    # For simplicity, let's assume storing check-in time in $t4
    li $t4, 1230               # Sample check-in time (12:30 PM)

    # Simulate displaying check-in time on LED (replace with actual code for your hardware)
    la $a0, checkin_message   # Load check-in message
    li $v0, 4                 # System call for print string
    syscall

    move $a0, $t4             # Load check-in time into $a0
    li $v0, 1                 # System call for print integer
    syscall

    # Set flag to avoid printing RFID read range again
    li $t2, 1

    # Simulate displaying student ID on LED 
    la $a0, studentID_message # Load student ID message
    li $v0, 4                 # System call for print string
    syscall

    move $a0, $t3             # Load student ID into $a0
    li $v0, 1                 # System call for print integer
    syscall

    j end_program

unauthorized:
    # Student is unauthorized
    la $a0, unauthorized_message  # Load unauthorized message
    jal PrintString            # Print the unauthorized message

end_program:
    # Exit program
    li $v0, 10                 # Exit system call
    syscall

PrintString:
    # Print the null-terminated string at the address in $a0
    li $v0, 4                   # System call for print string
    syscall
    jr $ra                      # Return
