ContextCovariate.wdl

public void recordValues(GaeaSamRecord read, ReadCovariates values){
	/ 获取原始的碱基
	/ 建立一个ReadClipper对象:clipper
	/ 创建一个GaeaSamRecord 对象clippedRead；（利用的是N覆盖掉原来质量值小的碱基）
	/ clippedRead是否为反向链
	/ 获取clippedRead的碱基
	/ 假如是反向链，read碱基只是简单的进行反向遍历输出
	/ 创建mismatchKeys和indelKeys整型列表
	/ 遍历read的所有碱基{
		/ 该read的协变量对象，向mkeys里面设置对应的协变量值。（mismatch值：mismatchkey列表的值） 
	}
}

public int maximumKeyValue() {
	/ 获取mContextSize和iContextSize的较大值length
	/ 当length=iContextSize（默认值值为3）时，最后的返回值是：1111110011=1011
}