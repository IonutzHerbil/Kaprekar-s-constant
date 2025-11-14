# Overview

This program implements the Kaprekar routine for 4-digit numbers using 8086 assembly programming language.  
The program repeatedly sorts the digits in ascending and descending order, subtracts the two numbers, and continues the process until one of the stopping conditions is reached.

The algorithm stops when:

- The number becomes **6174** (Kaprekar’s constant), or  
- All four digits are the same (e.g., 1111, 2222), which makes further iterations impossible.

The program outputs each step of the process and prints the total number of iterations.

---

# Program Flow

1. The user is prompted to enter a 4-digit number.  
2. Input is validated to ensure it contains only digits.  
3. The digits are sorted ascending and descending.  
4. The program subtracts the descending value from the ascending value.  
5. The result is printed.  
6. The iteration counter is incremented.  
7. The program checks:
   - If the number is 6174  
   - If all digits are equal  
8. If neither condition is met, the loop continues.  
9. When finished, the number of iterations is printed.

---

# Main Components

## Data Segment
- Input buffers (`NUMBER`, `NUMBER2`)
- Messages for user interaction
- Flags used for validation and comparisons
- Iteration counter

## Procedures
- `SORT_ASC` – Sorts digits in ascending order  
- `SORT_DESC` – Sorts digits in descending order  

## Key Macros
- `READS` – Reads user input  
- `PRINTS` – Prints a 4-digit buffer  
- `VALIDATE` – Ensures input contains digits only  
- `COPY_NUM` – Copies one number buffer to another  
- `EQUAL_DIGI` – Checks if all digits are the same  
- `IS_KAP_CT` – Checks if the number is 6174  
- `SUBTRACTION` – Performs digit-by-digit subtraction  

---

# Example Output
```
Starting from: 3524
2345 - 5432 = 3087
0378 - 8730 = 8352
2358 - 8532 = 6174
Iterations: 3
```
