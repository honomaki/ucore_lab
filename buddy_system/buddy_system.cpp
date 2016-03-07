// 修改自以前自己写的伙伴系统的练习，代码风格比较奇怪

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


struct BuddyNode  // 过于冗余，如果为了节省内存可以放到多个不同类节点中
{                 // 为了写起来方便，集成到一类节点中
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
	static BuddyNode* freeNodesList;   // 为了节省内存，用来存放回收的节点
	static int NodesCount;



private:
	int size;  // 为log2(真实大小)
	void* dataPool;

	BuddyNode** SizeArray;  // 存放各个大小的节点的数组，最小节点为16字节


							// buddy system
	void split(BuddyNode*);
	bool merge(BuddyNode*); // 不是直接合并，先判断后合并
	void join(BuddyNode*);
	void pop(BuddyNode*);

	// 对伙伴节点的静态存储池进行全局初始化
	void initBuddyNodes();
	void deleteBuddyNodes();

	// 操作静态存储池
	void increaseBuddysSize();
	void increaseBuddysArraySize();
	BuddyNode* newNodes();
	BuddyNode* initNodes(BuddyNode*);
	void freeNode(BuddyNode*);
	void freeAllNodes();

	// 工具函数
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

	if (size_0 < 16)  size_0 = 16;  // 最小16字节
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

void* StoragePool::acquire(int size_0)  // 无法分配时返回NULL
{
	size_0 += 8; // 给返回指针留出空间
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
	while (count < size - 3 && merge(SizeArray[count]))  // 可以使用惰性合并机制来进行优化
		count++;                                          // 为了写起来方便，这里直接合并
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

//工具函数
int StoragePool::log2size(int size)
{
	int count = 4;
	size >>= 4;  // 最小返回4

	while (size) {
		count++;
		size >>= 1;
	}

	return count;
}




// 对伙伴节点的静态存储池进行全局初始化
void StoragePool::initBuddyNodes()
{
	buddysArray = NULL;
	freeNodesList = NULL;

	buddysArray = new BuddyNode*[20];
	buddysArraySize = 20;// 初始有20容量
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



// 操作静态存储池
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
			BuddyNode* next = now->next;  // freeNode()会更改now->next，需要先保存
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

