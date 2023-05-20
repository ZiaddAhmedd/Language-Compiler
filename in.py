int Func (int y, int z) {int sum = y + z; return sum;}
int Func2 () {int y = 3; int z = 4; int sum = y + z; return sum;}
void Func3 (int y, int z) {y = 5; z = 6; return;}
void Func4 (int y, int z) {y = 5;}
void Func5 () {int y = 5;  int z = 6; return;}
int Func6 (int x, int y, int z, int x2, char y2, string z2) {y=3; return y;}

int a = 3;
int b = 4;
Func (a, b);
int z = Func2();
a = Func2();

