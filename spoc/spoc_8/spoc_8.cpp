#include <iostream>
#include <fstream>
#include <stdlib.h>

using namespace std;


int mem[0x80][32];
int disk[0x80][32];

void init(char file_name[], int arr[][32])
{
	ifstream f(file_name);
	
	for (int i = 0; i < 0x80; i++) {
		char temp[10];
		f >> temp >> temp;
		for (int j = 0; j < 32; j++)
			f >> hex >> arr[i][j];
	}

	f.close();
}


void translate(int va)
{
	int pde_idx = (va >> 10) & 0b11111;
	int pde_ctx = mem[0x6c][pde_idx];

	int pde_valid = pde_ctx >> 7;
	int pde_fn = pde_ctx & 0b1111111;
	cout << "  --> pde index:0x" << hex << pde_idx
		<< " pde contents:(valid " << pde_valid
		<< ", pfn 0x" << hex << pde_fn << ")" << endl;

	if (pde_valid == 0 && pde_fn == 0x7f) {
		cout << "    --> Fault (page directory entry not valid)" << endl;
		return;
	}

	int pte_idx = (va >> 5) & 0b11111;
	int pte_ctx = mem[pde_fn][pte_idx];

	int pte_valid = pte_idx >> 7;
	int pte_fn = pte_ctx & 0b1111111;
	cout << "    --> pte index:0x" << hex << pte_idx
		<< " pte contents:(valid " << pte_valid
		<< ", pfn 0x" << hex << pte_fn << ")" << endl;

	int pa = (pte_fn << 5) + (va & 0b11111);
	if (pte_valid == 1) {
		int value = ((int*)mem)[pa];
		cout << "      --> Translates to Physical Address 0x" << hex << pa
			<< " --> Value:" << value << endl;
	}
	else {
		int value = ((int*)disk)[pa];
		cout << "      --> To Disk Sector Address 0x" << hex << pa
			<< " --> Value:" << value << endl;
	}
}

int main(int argc, char *argv[])
{
	init("mem.txt", mem);
	init("disk.txt", disk);

	int va;
	cout << "virtual address : ";
	cin >> hex >> va;

	translate(va);


	return 0;
}