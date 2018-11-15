ReadGroupCovariate.java
// 对该read上的所有位点计算协变量值;输入：计算协变量值的read；read的SAM header; 对read上每个碱基记录协变量值的对象；针对indels指示协变量值是否需要被记录;
public void recordValues(final GATKRead read, final SAMFileHeader header, final ReadCovariates values, final boolean recordIndelValues){
		// 获取rg
		// 通过rg获取readGroupId
		// 通过readGroupId在readGroupLookupTable中获取对应的number值(key)
		// 获取read的长度
		// 针对read的偏移位点，对于目前的协变量键值更新对应的mismatch，insertion和deletion；注意:考虑到性能因素，对于协变量的数量（key）没有执行检查。在访问keysCache之后，数量得到了增加，该方法会抛出一个数组索引出界的异常。该异常目前仅在测试装置中出现，我们预计它不会成为正常运行的一部分；输入：mismatch的键值；insertion的键值，deletion的键值；read的偏移量，必须大于0且小于等于用于创建read协变量的read长度
		values.addCovariate(key, key, key, i);
}