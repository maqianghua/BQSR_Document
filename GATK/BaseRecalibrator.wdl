public abstract class ReadWalker extends GATKTool
public final class BaseRecalibrator extends ReadWalker
BaseRecalibrator
* 首先通过碱基质量分数进行重矫正。基于不同的协变量生成一个重矫正的table。默认的协变量是read group，reported quality score，machine cycle，和nucleotide context。

* 该walker产生基于特定协变量的tables。仅仅在已知的变异集合VCF中通过基因座（轨迹）执行遍历. ExAc,genomAD,或者dbsnp资源可以被用作已知变异位点集合。假设我们看到的所有reference mismatch都是错误，并表示为低质量碱基。在该位点看到给定的特殊协变量，因为那里有一大堆数据被用来计算empirical error的可能性，P(error)=num mismatches/num observations。输出的是表格文件，（一些协变量的值，num observations，num mismatches，empirical quality score）

* 输入：read数据，需要评估其碱基质量分数
* 输入：可跳过的已知多态位点的数据库

* 有很多表格的GATK报告文件如下：
	参数列表；量化的质量表；通过read group生成的重矫正表；通过质量分数生成的重矫正表；针对所有的可选协变量生成重矫正表；

* GATK报告要趋向于易于读取和计算，查看GATKReport的文档，了解如何操作这个表

public final class BaseRecalibrator extends ReadWalker
// 生成BQSR重矫正表格
// BQSR第一步：基于用户指定的不同协变量生成重矫正表；（比如：协变量有read group，reported quality score，machine cycle，和nucleotide context）

* 表示针对BQSR所有的命令行参数以及其协变量{
	@ArgumentCollection(doc="all the command line arguments for BQSR and its covariates")
	private final RecalibrationArgumentCollection recalArgs = new RecalibrationArgumentCollection();
}

* 本算法是将每一个reference mismatch 表示为一个显示的error，然而真正的基因突变是我们所期望mismatch到reference。因此给定本工具一个真正的多态变异位点的数据集（dbsnp）显得尤为重要，同时也会将会跳过这些点。本工具接收包含VCF，BCF，BED等任意类型的文件作为数据集。对于用户期望排除这些区间内的已知变异位点，仅仅使用-XL my.interval.list 从而跳过处理这些位点。然而请注意这些通过工具的-XL参数反映并过滤掉的位点，并不是真正的变异位点。{
	@Argument(fullName = KNOWN_SITES_ARG_FULL_NAME, doc = "One or more databases of known polymorphic sites used to exclude regions around known polymorphisms from analysis.", optional = false)
	private List<FeatureInput<Feature>> knownSites;
}

* header之后，data统计了每一行的（read），直到文件末尾。每行的前几列值是各自独立的协变量的值，在运行时将会根据指定的那几个协变量发生变化。Data的最后三列，是存储组合协变量的观察数，reference的mismatch数和通过phred-scaling the mismatch rate计算的原始empirical quality score。使用/dev/stdout打印到标准输出{
	@Argument(shortName = StandardArgumentDefinitions.OUTPUT_SHORT_NAME, fullName = StandardArgumentDefinitions.OUTPUT_LONG_NAME, doc = "The output recalibration table file to create", optional = false)
	private File recalTableFile = null;
}


private BaseRecalibrationEngine recalibrationEngine;

// 保存用户传递的reference的数据资源，我们正在使用一个来自不同于engine本身的缓存数据，以避免干扰它的缓存{
	private ReferenceDataSource referenceDataSource; 
}

* 用来对quality score quantization追踪有必要的信息对象{
	private QuantizationInfo quantizationInfo = null;
}

* 解析协变量参数并建立此处用到的协变量列表，基于协变量，评估并分配初始化data hashmap（存储协变量的对象）的容量.(第一阶段){
	public void onTraversalStart()；
}

* 获取默认的过滤read过滤器(第二阶段) {
	public List<ReadFilter> getDefaultReadFilters(){
		// 获取标准的BQSRread过滤器列表
		return getStandardBQSRReadFilterList();
		// 返回原始read filters全列表，用于BQSR contexts，包含WellFormed
			public static List<ReadFilter> getBQSRSpecificReadFilterList() {
				final List<ReadFilter> bqsrFilters = getBQSRSpecificReadFilterList();
				// 返回基本元素的列表，原始read filters用于BQSR contexts，不包含WellFormed	
				public static List<ReadFilter> getStandardBQSRReadFilterList()
			}		
		}
	}
}

// 父类ReadWalker.java方法说明{
	// 处理一个一个单独的read（有可选的Contextual信息）必须被工具使用者实现。通常，工具的使用者应该简单从apply()输出流，并尽可能保留一点内在的状态
	//Todo: 确定GATK引擎是否以及在何种程度上应该提供减少操作
	//Todo: 补充（完善）这个操作。至少，我们应该让apply()返回一个值
	// Todo: 在walkers不鼓励有状态，但是如何处理这个值是TBD（待定）
}

* 针对每条read在该位点（基因座）获取不同的协变量值，并基于该碱基是 否匹配到reference特定的位置。在map中增加该位置。
@Override
public void apply( GATKRead read, ReferenceContext ref, FeatureContext featureContext ) {
	// 针对每条read在该位点（基因座）获取不同的协变量值，并基于该碱基是 否匹配到reference特定的位置。在map中增加该位置。（第三阶段）    
	recalibrationEngine.processRead(read, referenceDataSource, featureContext.getValues(knownSites));
}

9 GATKTool.java{
	// 在成功遍历之后立即执行的操作，（等价于在遍历期间没有抛出未捕获到的异常）；在遍历之后，应该被工具使用者覆盖，并需要关闭本地资源等。而且允许工具返回一个值表示遍历的结果，应该被engine输出。默认实现是什么都不做，返回null。注释：返回一个表示遍历结果的目标，或者假如工具没有返回值就是null。返回：对象代表遍历的结果。假如工具没有返回一个值就是null。
}
public Object onTraversalSuccess(){
	// 如果合适的话，在重新校准表中确定所有产生的数据。所有的read调用完processRead方法之后，该方法被调用一次。假设所有主要的表格（质量分数表）已经被完全更新了，并通过read group遍历此数据以创建汇总数据表。
	// recalibrationEngine.finalizeData();
	// public void finalizeData(){
		// 解释同上
		finalizeRecalibrationTables(recalTables);（第四阶段）
		finalized = true
	}
	// 计算量化的质量分数
	quantizeQualityScores();（10）
	// 生成质量重矫正的报告
	generateReport();(11)
}

10 // 通过质量分数表和使用observations和empirical quality score去建立量化的quality score 直方图。然后利用量化算法去生成量化的map<recalibrated_qual -> quantized_qual>
private void quantizeQualityScores() {
	// recalArgs.QUANTIZING_LEVELS=16：BQSR为后续工具能快速量化，生成一个量化的表格。BQSR不会量化碱基质量，该操作是利用-qq 或-bqsr选项被engine所执行。该参数告诉BQSR建立量化表格时，量化的水平数值
	// 在执行finalizeData()之后，获取最终的重矫正表格.通过该engine收集并返回最终的最终的重矫正表.在finalizeData被调用前，执行该方法会产生错误.返回：通过该engine收集得到最后的重矫正表格。
	// recalibrationEngine.getFinalRecalibrationTables()
	// public RecalibrationTables getFinalRecalibrationTables(){return recalTables;}
	// 该类封装BQSR量化质量分数所需的信息
    quantizationInfo = new QuantizationInfo(recalibrationEngine.getFinalRecalibrationTables(), recalArgs.QUANTIZING_LEVELS);(第五阶段)
}
11 //生成报告
// 
RecalUtils.outputRecalibrationReport(recalTableStream, recalArgs, quantizationInfo, recalibrationEngine.getFinalRecalibrationTables(), recalibrationEngine.getCovariates());（第六阶段）
