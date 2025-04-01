# Big O Notation

Big O measures the number of steps in an algorithm

**Big O** - upper bound of an algorithm (the worst case)
**Omage Notation** - lower bound of an algorithm (the best case)
**Theta Notation** - both upper and lower bound (average case)

**O(1) Constant Complexity**:
As the data size scales, the time stays constant.

Array lookups are an example:
arr = [1,2,3,4,5]
arr[2]

**O(log N) Logarithmic Complexity**:
When the data size doubles, the time increases by one step.

5,000 -> 10,000 only gives an additional step

Binary search is an example of an O(log N) algorithm.

**O(N) Linear Complexity**
As the number of items grows, so does the number of steps (at the same rate).

an array of 5 items will take 5 steps, 10 will take 10, etc.

**O(N log N) N x Log N Complexity**
An algorithm like Binary Search that repeatedly breaks an array in half, but each of those array halves are processed by another algorithm with complexity O(N).

Merge sort is an example of this.

**O(n^2) Quadratic Complexity**
for i in x:
    for j in x:
        ...

when you have to loop through the array inside a loop that is looping through the array.

**O(n^3) Cubic Complexity**
for i in x:
    for j in x:
        for k in x:
            ...

when you have to loop through the array inside a loop that is looping through the array inside a loop that is looping through the array.

**O(2^n) Exponential Complexity**
Everytime an item is added to the data size, the number of steps **doubles**.

**O(N!) Factorial Complexity**
factorial = the product of all the numbers between 1 and that number.

4! = 4 * 3 * 2 * 1

Factorial complexity can be found in premutations and combinations.

**Time and Space Complexities Both use Big O.**

