ContextCovariate.java
// 对该read上的所有位点计算协变量值;输入：计算协变量值的read；read的SAM header; 对read上每个碱基记录协变量值的对象；针对indels指示协变量值是否需要被记录;
public void recordValues(final GATKRead read, final SAMFileHeader header, final ReadCovariates values, final boolean recordIndelValues){
	/// 获取原始read的长度
	/// 存储原始的碱基，然后改写低质量的碱基为N	;注意：该方法，构建一个read的copy副本	
 	// 给定一个read，跳过低质量的末端碱基（使用N重写）并返回剩余的碱基，然后反向补充反向链的reads；输入：一个read；每个碱基质量小于或等于该read末端的低质量值，将会被替换为N。返回：read的所有碱基（假如所有的碱基小于lowTail，将会是空数组）
	// final byte[] strandedClippedBases = getStrandedClippedBytes(read, lowQualTail);
	// @VisibleForTesting
    // static byte[] getStrandedClippedBytes(final GATKRead read, final byte lowQTail){
	 	// 用N改写reads末端的低质量碱基，以避免把他们添加到context中
	 }
	/// 注意：我们目前使用非标准的库，因为在applyBQSR中boxing在性能分析中耗费20%的时间.IntList避免了boxing
	// 计算一个碱基的context，独立于协变量模式（mismatch，insertion，deletion）;输入：read上的碱基构建context形式；用来建立context的大小；用于提取context bits的mask
	// final IntList mismatchKeys = contextWith(strandedClippedBases, mismatchesContextSize, mismatchesKeyMask);
	// private static IntList contextWith(final byte[] bases, final int contextSize, final int mask) {
	 	/// 注意：我们使用一个特定的集合，以避免boxing和unboxing的耗费，否则会体现在性能上.
	 	/// 第一个contextSize-1的碱基数（复数）将不会有以前足够的context大小
	 	/// 获取（并添加）context键值，始于第一个碱基
	 	/// 假如第一个键值是-1，即就是在context中第一个碱基是N，计算它影响的多少个连续的context
	 	if (baseIndex == -1){
	 		/// 忽略非ATCG的碱基
	 		/// 重置key值
	 	}else{
	 		// 推动该碱基的贡献到键值，移动everything 2个bits，隐藏非context的bits，并且添加新的碱基和长度到（key）
	 	}
	 }
	/// 有必要确保我们没有保存在ReadCovariates值的历史数据；因为context协变量也许没有横跨整个read协变量的值集合。由于跳过了低质量的碱基
	// if 跳过之后read长度不等于原始read的长度{
		/// 假如我们要重写整个数组，不需要每个元素都置零了
		/// for从0开始，小于原始read长度的碱基添加协变量值
		/// values.addCovariate(0, 0, 0, i);
	}
	// 注意：复制循环以避免在每次迭代中检查recordIndelValues
	// 假如	当recordIndelValues是真值{
		// 针对read的偏移位点，对于目前的协变量键值更新对应的mismatch，insertion和deletion；注意:考虑到性能因素，对于协变量的数量（key）没有执行检查。在访问keysCache之后，数量得到了增加，该方法会抛出一个数组索引出界的异常。该异常目前仅在测试装置中出现，我们预计它不会成为正常运行的一部分；输入：mismatch的键值；insertion的键值，deletion的键值；read的偏移量，必须大于0且小于等于用于创建read协变量的read长度
		values.addCovariate(mismatchKeys.getInt(i), indelKey, indelKey, readOffset)
	}// else 当recordIndelValues是假值{
		values.addCovariate(mismatchKeys.getInt(i), 0, 0, readOffset);
	}
}