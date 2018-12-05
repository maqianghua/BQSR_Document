QualityCovariate.wdl

public void recordValues(final GaeaSamRecord read, final ReadCovariates values) {
	/ 获取read上每个碱基的质量值byte[] baseQualities
	/ 获取每个碱基的插入质量值
	/ 获取每个碱基的删除质量值
	/ 遍历read的每个碱基{
		该read的协变量对象，向mkeys里面设置对应的协变量值。（碱基对应的质量值）
	}
}