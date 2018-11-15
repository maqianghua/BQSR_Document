CycleCovariate.java
// 对该read上的所有位点计算协变量值;输入：计算协变量值的read；read的SAM header; 对read上每个碱基记录协变量值的对象；针对indels指示协变量值是否需要被记录;
public void recordValues(final GATKRead read, final SAMFileHeader header, final ReadCovariates values, final boolean recordIndelValues){
	/// 从read的属性中,用来获取协变量的值，
	public void recordValues(final GATKRead read, final SAMFileHeader header, final ReadCovariates values, final boolean recordIndelValues) {
		/// 注意：复制循环以避免在每次迭代中检查recordIndelValues
		// 假如	当recordIndelValues是真值{
			// 对于read的给定碱基位点，计算编码的CycleCovariate's键值。使用KeyFromCycle做编码；输入：用来计算键值的碱基索引值；read；是一个indel键或者是替换的key值；计算键值的最大碱基的值（假如计算cycle number键值的绝对值大于该值，该方法抛出用户使用异常。）
			final int substitutionKey = cycleKey(i, read, false, MAXIMUM_CYCLE_VALUE);
			// public static int cycleKey(final int baseNumber, final GATKRead read, final boolean indel, final int maxCycle){
				// if ( !indel ){
					// 将cycle number编码为键
					return CycleCovariate.keyFromCycle(cycle, maxCycle);
				}
				final int maxCycleForIndels = readLength - CycleCovariate.CUSHION_FOR_INDELS - 1;
				// if ( baseNumber <CycleCovariate.CUSHION_FOR_INDELS(默认值是4) || baseNumber >maxCycleForIndels){		return -1;
				}else{
					// 将cycle number编码为键
					return CycleCovariate.keyFromCycle(cycle, maxCycle);
				}
			}
			values.addCovariate(substitutionKey, indelKey, indelKey, i);
		}// else 假如当recordIndelValues是假值{
			values.addCovariate(substitutionKey, 0, 0, i);
		}
	}
}