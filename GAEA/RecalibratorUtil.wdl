RecalibratorUtil.wdl
/ 通过用户提供的协变量列表（协变量+ReadGroup+Quality）计算read的协变量
/ public static ReadCovariates computeCovariates(final GaeaSamRecord read, final Covariate[] covariates) {
	/ 创建并初始化该read对应的协变量对象readCovariates（初始化mkeys=int[1][read长度][协变量长度]）
	/ 通过read、协变量列表和read的协变量计算read的协变量值
	/ computeCovariates(read, covariates, readCovariates);
	public static void computeCovariates(final GaeaSamRecord read, final Covariate[] covariates,ReadCovariates readCovariates){
		/ 遍历协变量列表元素{
			
		}
	}
}