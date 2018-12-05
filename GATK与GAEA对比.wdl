GATK的表格：
	协变量，碱基数，mismatch数，实际质量分数
Gaea的表格：
	协变量Datum：
		增加碱基数，增加mismatch数，计算实际质量分数

事件类型：
gaea：仅有SNP（mismatch）
GATK：有SNP（mismatch）必选，INDEL（deletion和insertiorn）可选

数据更新：
gaea：碱基位置(相对于reference)，碱基字节码，碱基质量，reference上碱基字节码，read协变量
GATK：
	1 read , covariates,skip,snpErrors,insertionErrors,deletionsErrors
	2 然后有个量化的过程，利用森林惩罚法（实际上就是将误差向下取整，增大质量值），建立量化的质量表，同时建立质量分数与量化质量表之间的一个映射关系。
GTAK独有
	1 read转换：
		将read的cigar字符串合并，
		设置read碱基的默认质量值（默认值为正值，就添加，reads有缺失或质量不完整就需要默认值）
		用户假如使用原始的碱基质量，就会重置read碱基的质量值为原始质量值
		去掉read的接头序列
		切掉软跳过的read碱基，返回新的read（有可能为null：ummapped，all of soft and hard clips）
	2 统计该read中SNP和indel的事件总数nError：（不管执不执行BAQ，都要统计）
	3 是否执行BAQ修正：{
		不执行BAQ：当nError数为0或者用户参数不执行BAQ
		执行BAQ：read中SNP和INDEL的事件总数不等于0 或者用户参数enableBAQ值是false（！fasle=true）
			条件是：BAQ.CalculationMode.RECALCULATE, BAQ.QualityMode.ADD_TAG：将hmmresult.bq作为BAQ的标签值加入到read中	
					隐马尔模型：计算碱基的质量值。
	}
	4 跳过：
		1 不规则碱基（除ATCG或*）
		2 低质量碱基（<6）
		3 dbsnp中相同碱基
	5 recalInfo更新时，获取事件类型的质量值：
		1 SNP：mismatch ：碱基的质量值
		2 INDEL：insertion或deletion：45（需要优化的地方）
	6 根据量化的质量表生成QualityScoreTable。
