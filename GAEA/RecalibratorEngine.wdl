RecalibratorEngine.wdl
/ this.covariates=用户请求的协变量数组
/ mHeader.getReadGroups().size()=read对应的ReadGroups大小（个数）
/ recalibratorTables = new RecalibratorTable(this.covariates, mHeader.getReadGroups().size());
public RecalibratorTable(final Covariate[] covariates, int readGroupNumber) {
	/ 创建NestedObjectArray[] tables：数组长度为协变量数组的长度
	/ 最大的质量值分数=93+1=94
	/ 事件的大小为事件类型的长度（个数）=3
	/ 创建ReadGroupTable tables[Type.READ_GROUP_TABLE.index=0]:根据read对应的readGroup个数（至少为1）和事件类型个数3
	/ 创建tables[Type.QUALITY_SCORE_TABLE.index=1]:根据read对应的readGroup个数（至少为1），最大的质量值94，事件类型个数3
	/ 创建可选的Context和Cycle协变量对应的tables[2]:根据read对应的readGroup个数（至少为1），最大的质量值94，(cycle:2002;Context:1012）,事件类型个数3
}