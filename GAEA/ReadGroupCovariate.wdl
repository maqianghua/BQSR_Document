ReadGroupCovariate.wdl

public void initialize(RecalibratorOptions option) {
}

public void initializeReadGroup(SAMFileHeader mFileHeader) {
	
}

public void recordValues(final GaeaSamRecord read, final ReadCovariates values){
	/ 获取read对应的readGroupId
	/ 通过readGroupId获取read对应的key（readGroupID对应的索引值）
	/ 遍历read的每一个碱基{
		该read的协变量对象，向mkeys里面设置对应的协变量值。（mismatch：readGroupId对应的索引值）
	}
}