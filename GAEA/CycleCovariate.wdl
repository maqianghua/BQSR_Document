CycleCovariate.wdl

public void recordValues(GaeaSamRecord read, ReadCovariates values){
	/ 获取read的长度值readLength
	/ 获取测序平台值ngsPlatform，条件：默认测序平台为null：是:获取read的测序平台；否则：获取默认的测序平台
	/ 预先设置的测序平台包含ngsPlatform，预先设置测序平台有（illumina，solid，Pacbio，COMPLETE）{
		/ int readOrderfactor赋值条件：read是双端测序并且是read2，是：-1；否：1
		/ 假如是反向链{
			/ cycle=为-1*readLength
			/ increment=-1*-1=1
		}或者是正向链{
			/ cycle=-1
			/ increment=-1
		}
		/ 设置INDEL的最大cycle值为readLength-5；
		/ 遍历read的每个碱基{
			/ 获取cycle对应的键substitutionKey，给cycle值乘2，当cycle值为-1时，再加1
			/ 获取indelKey：条件：碱基索引<4或者碱基索引>(readLength-5);是：-1；否：substitutionKey
			/ 该read的协变量对象，向mkeys里面设置对应的协变量值。（cycle对应的键substitutionKey）
			/ cycle递增
		}
	}或者假如FLOW_CYCLE_PLATFORMS(LS454, ION_TORRENT)包含该测序平台{
		/ 获取read的碱基byte[]
		/ 给multiplyByNegativel赋值：条件：read是双端测序并且是read2；是：true；否：false
		/ cycle赋值：条件：multiplyByNegativel为真或假：真：-1，假：1；
		/ 假如是正向链{
			/ 该read的协变量对象，向mkeys里面设置对应的协变量值。（cycle对应的键）
		}否则是负向链{
			/ 该read的协变量对象，向mkeys里面设置对应的协变量值。（cycle对应的键）
		}
	}/ 否则抛出不被识别的测序平台异常
}

public int maximumKeyValue() {
	/ 返回的最大值是2001
}