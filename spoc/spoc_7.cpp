#include<iostream>

using namespace std;

void translate(unsigned int va, unsigned int pa)
{
	unsigned int pde_idx = (va >> 22) & 0x3ff;
	unsigned int pde_ctx = ((pde_idx - 0x300 + 1) << 12) | 0x3;
	unsigned int pte_idx = (va >> 12) & 0x3ff;
	unsigned int pte_ctx = pa & 0x3ff | 0x3;

	cout << "va 0x" << hex << va << ", pa 0x" << hex << pa
		<< ", pde_idx 0x" << hex << pde_idx << ", pde_ctx 0x" << hex << pde_ctx
		<< ", ptd_idx 0x" << hex << pte_idx << ", pte_ctx 0x" << hex << pte_ctx
		<< endl;
}

int main() {

	unsigned int va;
	unsigned int pa;

	cout << "va : ";
	cin >> hex >> va;
	cout << "pa : ";
	cin >> hex >> pa;

	translate(va, pa);

	system("pause");


	return 0;
}