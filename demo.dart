import "dart:io";

void main(){

// Doing sum of 3 number
print("enter the number you want to add:");
print("enter number 1");
var a = stdin.readLineSync();
print("enter number 2");
var b = stdin.readLineSync();
print("enter number 3");
var c = stdin.readLineSync();

var sumAns = doSum(int.parse(a!), int.parse(b!), int.parse(c!));
print(sumAns);

// do perctange of marks
print("Enter your tota marks to calculate the percantage");

var d = stdin.readLineSync();
var percentageAns = doPercentage(int.parse(d!));
print(percentageAns);

// do mutiplication by lamada function
print("Enter the two numebr you want to multiply");
var num1 = stdin.readLineSync();
var num2 = stdin.readLineSync();
var multiplicationAns = doMultiplication(int.parse(num1!), int.parse(num2!));
print(multiplicationAns); 
}

doSum(a, b , c){
  var d = a + b + c;
  return d;
}

doPercentage(e){
  var percentage = e / 300 * 100;
  return percentage;
}

doMultiplication(a , b) => a * b;

doGrade(){

}