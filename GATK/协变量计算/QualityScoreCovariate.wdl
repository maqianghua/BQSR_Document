QualityScoreCovariate.java
// 对该read上的所有位点计算协变量值;输入：计算协变量值的read；read的SAM header; 对read上每个碱基记录协变量值的对象；针对indels指示协变量值是否需要被记录;
public void recordValues(final GATKRead read, final SAMFileHeader header, final ReadCovariates values, final boolean recordIndelValues){
	// 返回在read序列中碱基质量值的二进制数组长度;该方法的默认实现是调用getBaseQualities().length。子类可以重写以提供更高效的实现
	// final int baseQualityCount = read.getBaseQualityCount();
	// default int getBaseQualityCount(){
		// 返回碱基的质量值为二进制的phred score，或者当碱基质量不存在返回一个空的byte[]数组。注意：该方法在输出返回值之前，构建了一个防守型的碱基质量数组副本，因此修改返回路径的数组，不会改变原read上的碱基质量。
		// byte[]  getBaseQualities();
		// return getBaseQualities().length;
	}
	// 当recordIndelValues是真值，执行以下程序，否为null
	// final byte[] baseInsertionQualities = recordIndelValues ? ReadUtils.getBaseInsertionQualities(read) : null;{
		// 默认效用是查询一条read上碱基插入质量。假如read没有一个碱基插入质量，它会创建一个默认质量值（Q45）的数组，并分配给read；返回：碱基插入质量值（base insertion quality）数组
		// ReadUtils.getBaseInsertionQualities(read)		
		// public static byte[] getBaseInsertionQualities(final GATKRead read){
			// 返回：碱基deletion质量byte数组或假如read没有一个deletion，就返回null
			// byte [] quals = getExistingBaseInsertionQualities(read);
			// 假如byte[] quals为null{
				// 将来的某一天当碱基插入和碱基删除质量在samtools API存在的话，INDEL quality将会得到更新。
				// 原始的质量将会被pulled here。但是目前我们假设原始的质量是flat Q45
			}
		}
	}
	// 对于deletion同insertion同样的做法
	// 注意：复制循环以避免在每次迭代中检查recordIndelValues
	// 假如	当recordIndelValues是真值{
		// 针对read的偏移位点，对于目前的协变量键值更新对应的mismatch，insertion和deletion；注意:考虑到性能因素，对于协变量的数量（key）没有执行检查。在访问keysCache之后，数量得到了增加，该方法会抛出一个数组索引出界的异常。该异常目前仅在测试装置中出现，我们预计它不会成为正常运行的一部分；输入：mismatch的键值；insertion的键值，deletion的键值；read的偏移量，必须大于0且小于等于用于创建read协变量的read长度
		// values.addCovariate(read.getBaseQuality(i), baseInsertionQualities[i], baseDeletionQualities[i], i);
	}// 假如recordIndelValues是假{
		values.addCovariate(read.getBaseQuality(i), 0, 0, i);
	}
}