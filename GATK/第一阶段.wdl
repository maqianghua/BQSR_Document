第一阶段
// 解析协变量参数，并建立在此处需要用到的协变量列表。
// 基于协变量评估分配data hashmap的初始化容量
 public void onTraversalStart() {
 	// 检查read header是否包含除illumina以外的任何read groups，对于这种情况要发出警告。
 	Utils.warnOnNonIlluminaReadGroups(getHeaderForReads(), logger);
 	// 根据针对BQSR所有的命令行参数，以及read的header创建BaseRecalibrationEngine对象
 	recalibrationEngine = new BaseRecalibrationEngine(recalArgs, getHeaderForReads()){
 	 	// 设置BAQ object利用所提供的gap open惩罚值
 	 	// 建立一个新的标准的BQSR协变量列表，并初始化每个协变量
 	 	covariates = new StandardCovariateList(recalArgs, readsHeader);{
 	 		// 建立一个新的标准的BQSR协变量列表，并初始化每个协变量
 	 		// 形参结果：返回该read对的应的header中所有的readGroup名称
 	 		this(rac, ReadGroupCovariate.getReadGroupIDs(header));{
 	 			// 通过header获取所有的ReadGroups
 	 			ReadGroupCovariate.getReadGroupIDs(header){
 	 				// 替换整个read groups列表，给定储存好的列表，而不是复制得到的。
 	 				public void setReadGroups(final List<SAMReadGroupRecord> readGroups)
 	 			}
 	 			// 建立readGroupLookupTable：储存从read group id映射到number
 	 			// 建立建立readGroupReverseLookupTable：储存从number映射到到read group id，与readGroupLookupTable相比是颠倒的映射
 	 			readGroupCovariate = new ReadGroupCovariate(rac, allReadGroups)
 	 			// 建立报告质量分数协变量对象
 	 			qualityScoreCovariate = new QualityScoreCovariate(rac);
 	 			// context size(碱基数)的最大值被允许；我们需要保证最左边的碱基自由，这样值才不会是负值.
 	 			// 同时我们保留4位来表示conext的长度；一个碱基需要2位来编码
 	 			final ContextCovariate contextCovariate = new ContextCovariate(rac);
 	 			// 对于Cycle 协变量，对于ILLUMINA cycle简单指在read上的位置（假如是反向链的read，逆向计算）
 	 			final CycleCovariate cycleCovariate = new CycleCovariate(rac);
 	 			// 针对更快的查找首先进行计算，（在简况中有展示）。实际上就是为所有的斜变量建立map映射
 	 			indexByClass.put(allCovariates.get(i).getClass(), i);
 	 		}
 	 	}
 	 }
 	// 列举所有使用的协变量
 	recalibrationEngine.logCovariatesUsed();
 	// 利用fasta文件初始化reference数据资源列表，
 	// 提供的fasta文件必须有.fai 和.dict 文件的同伴
 	referenceDataSource = ReferenceDataSource.of(referenceArguments.getReferencePath());
 }