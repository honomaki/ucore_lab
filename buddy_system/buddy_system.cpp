// �޸�����ǰ�Լ�д�Ļ��ϵͳ����ϰ��������Ƚ����

#include<iostream>
#include<stdlib.h>
using namespace std;

class StoragePool;

void* my_malloc(size_t size, StoragePool* pool)
{
	cout << " my_malloc in " << pool->name << endl;
	return acquire(pool, size);
}

void my_free(void* ptr)
{
	reclaim(ptr);
}

int main(int argv, char** argc)
{

	StoragePool pool_1(2048);
	StoragePool pool_2(4096);
	char name_1[] = "pool_1";
	char name_2[] = "pool_2";

	pool_1.name = name_1;
	pool_2.name = name_2;



	int* var1 = my_malloc(sizeof(int), &pool_1);
	double* var2 = my_malloc(sizeof(double), &pool_2);

	my_free(var1);
	my_free(var2);


	var1 = my_malloc(40 * sizeof(int), &pool_1);
	var2 = my_malloc(20 * sizeof(double), &pool_2);

	my_free(var1);
	my_free(var2);

	return 0;
}


struct BuddyNode  // �������࣬���Ϊ�˽�ʡ�ڴ���Էŵ������ͬ��ڵ���
{                 // Ϊ��д�������㣬���ɵ�һ��ڵ���
	bool rdy;
	short log2size;
	void* data;
	StoragePool* pool;
	BuddyNode* parent;
	BuddyNode* buddy;
	BuddyNode* front;
	BuddyNode* next;
};




class StoragePool
{
public:
	StoragePool(int);
	~StoragePool();

	void* acquire(int);
	void reclaim(BuddyNode*);


	static int poolCount;
	char* name;

	static BuddyNode** buddysArray;
	static int buddysArraySize;
	static int buddysArrayCount;
	static BuddyNode* freeNodesList;   // Ϊ�˽�ʡ�ڴ棬������Ż��յĽڵ�
	static int NodesCount;



private:
	int size;  // Ϊlog2(��ʵ��С)
	void* dataPool;

	BuddyNode** SizeArray;  // ��Ÿ�����С�Ľڵ�����飬��С�ڵ�Ϊ16�ֽ�


							// buddy system
	void split(BuddyNode*);
	bool merge(BuddyNode*); // ����ֱ�Ӻϲ������жϺ�ϲ�
	void join(BuddyNode*);
	void pop(BuddyNode*);

	// �Ի��ڵ�ľ�̬�洢�ؽ���ȫ�ֳ�ʼ��
	void initBuddyNodes();
	void deleteBuddyNodes();

	// ������̬�洢��
	void increaseBuddysSize();
	void increaseBuddysArraySize();
	BuddyNode* newNodes();
	BuddyNode* initNodes(BuddyNode*);
	void freeNode(BuddyNode*);
	void freeAllNodes();

	// ���ߺ���
	int log2size(int);
	void initDataPool(void*, BuddyNode*);
	void* startAddr(void*);
};










int StoragePool::poolCount = 0;

BuddyNode** StoragePool::buddysArray = NULL;
BuddyNode* StoragePool::freeNodesList = NULL;
int StoragePool::NodesCount = 0;
int StoragePool::buddysArraySize = 0;
int StoragePool::buddysArrayCount = 0;



StoragePool::StoragePool(int size_0)
{
	if (poolCount == 0)
		initBuddyNodes();
	poolCount++;

	if (size_0 < 16)  size_0 = 16;  // ��С16�ֽ�
	dataPool = new char[size_0];

	size = log2size(size_0) - 1;
	SizeArray = new BuddyNode*[size - 3];

	for (int i = 0; i < size - 3; i++)
		SizeArray[i] = NULL;

	char* tempPtr = (char*)dataPool;
	while (size_0 > 16)
	{
		int tempSize = log2size(size_0) - 1;
		BuddyNode* node = newNodes();
		node->log2size = tempSize;
		node->data = tempPtr;
		SizeArray[tempSize - 4] = node;
		initDataPool(tempPtr, node);

		tempPtr += (1 << tempSize);
		size_0 -= (1 << tempSize);
	}

}

StoragePool::~StoragePool()
{
	freeAllNodes();

	free(dataPool);
	free(SizeArray);

	poolCount--;
	if (poolCount == 0)
		deleteBuddyNodes();

}

void* StoragePool::acquire(int size_0)  // �޷�����ʱ����NULL
{
	size_0 += 8; // ������ָ�������ռ�
	int Count = log2size(size_0) - 4;
	if (size < Count + 4) return NULL;

	BuddyNode* node;
	if (SizeArray[Count])
	{
		node = SizeArray[Count];
		pop(node);
	}
	else
	{
		int splitCount = Count + 1;
		while (splitCount <= size - 4 && !SizeArray[splitCount])
			splitCount++;

		if (splitCount > size - 4) return NULL;

		while (Count < splitCount) {
			split(SizeArray[splitCount]);
			splitCount--;
		}
		node = SizeArray[Count];
	}

	pop(node);
	return startAddr(node);
}

void StoragePool::reclaim(BuddyNode* node)
{
	node->rdy = true;
	join(node);
	int count = node->log2size - 4;
	while (count < size - 3 && merge(SizeArray[count]))  // ����ʹ�ö��Ժϲ������������Ż�
		count++;                                          // Ϊ��д�������㣬����ֱ�Ӻϲ�
}

// buddy system
void StoragePool::split(BuddyNode* node)
{
	if (node->log2size <= 4 || !node->rdy) return;

	pop(node);

	BuddyNode* child_1 = newNodes();
	BuddyNode* child_2 = newNodes();

	child_1->parent = child_2->parent = node;
	child_1->buddy = child_2;
	child_2->buddy = child_1;

	child_1->log2size = child_2->log2size = node->log2size - 1;
	child_1->data = node->data;
	child_2->data = (void*)((char*)node->data + (int)(1 << int(child_1->log2size)));
	initDataPool(child_1->data, child_1);
	initDataPool(child_2->data, child_2);


	join(child_1);
	join(child_2);
}

bool StoragePool::merge(BuddyNode* node)
{
	if (!(node->buddy && node->parent && node->buddy->rdy)) return false;

	BuddyNode* buddy = node->buddy;
	BuddyNode* parent = node->parent;
	parent->rdy = true;
	initDataPool(parent->data, parent);
	join(parent);

	pop(node);
	pop(buddy);
	freeNode(node);
	freeNode(buddy);
	return true;
}

void StoragePool::join(BuddyNode* node)
{
	int count = node->log2size - 4;
	if (SizeArray[count]) {
		node->next = SizeArray[count];
		SizeArray[count]->front = node;
		SizeArray[count] = node;
	}
	else
		SizeArray[count] = node;

	node->front = NULL;
}

void StoragePool::pop(BuddyNode* node)
{
	node->rdy = false;
	if (node->next)
		node->next->front = node->front;

	if (node->front)
		node->front->next = node->next;
	else
		SizeArray[node->log2size - 4] = node->next;
}

//���ߺ���
int StoragePool::log2size(int size)
{
	int count = 4;
	size >>= 4;  // ��С����4

	while (size) {
		count++;
		size >>= 1;
	}

	return count;
}




// �Ի��ڵ�ľ�̬�洢�ؽ���ȫ�ֳ�ʼ��
void StoragePool::initBuddyNodes()
{
	buddysArray = NULL;
	freeNodesList = NULL;

	buddysArray = new BuddyNode*[20];
	buddysArraySize = 20;// ��ʼ��20����
	buddysArrayCount = NodesCount = 0;

	increaseBuddysSize();
}

void StoragePool::deleteBuddyNodes()
{

	for (int i = 0; i < buddysArraySize; i++)
		free(buddysArray[i]);

	free(buddysArray);

	buddysArray = NULL;
	freeNodesList = NULL;
}



// ������̬�洢��
void StoragePool::increaseBuddysSize()
{
	if (buddysArraySize <= (buddysArrayCount + 2))
		increaseBuddysArraySize();


	buddysArray[buddysArrayCount] = new BuddyNode[1 << (buddysArrayCount + 4)];
	buddysArrayCount++;
	NodesCount = 0;
}

void StoragePool::increaseBuddysArraySize()
{
	BuddyNode** temp = buddysArray;
	buddysArray = new BuddyNode*[buddysArraySize << 1];

	for (int i = 0; i < buddysArraySize; i++)
		buddysArray[i] = temp[i];

	buddysArraySize <<= 1;
	free(temp);
}


BuddyNode* StoragePool::newNodes()
{
	if (freeNodesList)
	{
		BuddyNode* temp = freeNodesList;
		freeNodesList = freeNodesList->next;
		return initNodes(temp);
	}
	else
	{
		if ((1 << (buddysArrayCount + 3)) <= (NodesCount + 2))
			increaseBuddysSize();


		return initNodes(&buddysArray[buddysArrayCount - 1][NodesCount++]);
	}
}

BuddyNode* StoragePool::initNodes(BuddyNode* node)
{
	node->rdy = true;
	node->pool = this;
	node->data = node->parent = node->buddy = node->front = node->next = NULL;

	return node;
}

void StoragePool::freeNode(BuddyNode* node)
{
	node->next = freeNodesList;
	freeNodesList = node;
}

void StoragePool::freeAllNodes()
{
	for (int i = 0; i < size - 3; i++) {
		BuddyNode* now = SizeArray[i];
		while (now) {
			BuddyNode* next = now->next;  // freeNode()�����now->next����Ҫ�ȱ���
			freeNode(now);
			now = next;
		}
	}
}

inline void StoragePool::initDataPool(void* DataPool, BuddyNode* node)
{
	*(BuddyNode**)DataPool = node;
}
inline void* StoragePool::startAddr(void* DataAddr)
{
	return (void*)((BuddyNode*)DataAddr + 1);
}

