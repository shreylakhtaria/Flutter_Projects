void main() {
  Bank myacc = new Bank(2000);

  myacc.deposite(1000);
  print("you have deposited X amount");

  myacc.getBalanc();

  myacc.withDraw(500);
  print("you have withdrawed X amount");

  myacc.getBalanc();
}

class Bank {
  dynamic amount = 0;

  Bank(amount) {
    this.amount = amount;
  }

  deposite(amount) {
    this.amount += amount;
  }

  withDraw(amount) {
    this.amount = this.amount - amount;
  }

  getBalanc() {
    print("Your account balance is ${this.amount}");
  }
}
