/*
缺页率置换算法
输入格式为 1 3 4 9 2 0 ...
*/


#include <iostream>
#include <stdlib.h>
#include <memory.h>
using namespace std;

const int MAXINDEX = 10;

const int INTERVALTIME = 2;  // T 值为 2

bool pages_in_memory[MAXINDEX];
int pages_last_time[MAXINDEX];

int current_time = 0;
int last_time = 0;

void pageReplacement(int index)
{
	if (INTERVALTIME < (current_time - last_time)) {

		for (int i = 0; i < MAXINDEX; i++) {
			if (pages_last_time[i] < last_time)
				pages_in_memory[i] = false;
		}

	}
	else {
		pages_in_memory[index] = true;
		pages_last_time[index] = current_time;
	}

	last_time = current_time;
}

void printPagesInMemory()
{
	cout << "memory : ";
	for (int i = 0; i < MAXINDEX; i++)
		if (pages_in_memory[i])
			cout << i << " ";

	cout << endl;
}

int main(int argc, char *argv[])
{
	memset(pages_in_memory, 0, sizeof(pages_in_memory));
	memset(pages_last_time, 0, sizeof(pages_last_time));

	while (true)
	{
		int now_visit_page;
		cin >> now_visit_page;

		if (pages_in_memory[now_visit_page]) {
			pages_last_time[now_visit_page] = current_time;

			cout << "HIT " << now_visit_page << "  ";
			printPagesInMemory();
		}
		else {
			pageReplacement(now_visit_page);

			cout << "MISS " << now_visit_page << "  ";
			printPagesInMemory();
		}

		current_time++;
	}



	return 0;
}