function  result =  sum_of_absolute_differences(input1, input2)
difference = input1 - input2;
absolute = abs(difference);
result = sum(absolute(:));