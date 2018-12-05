gatk代码逻辑梳理：基于用户指定的不同协变量生成重矫正表格
 
第一步：解析命令行参数，建立协变量的映射map，并初始化其容量大小（第一阶段）{
	设置BAQ惩罚系数，
	获取所有的ReadGroups：
		创建readGroupLookupTable：存储readGroupID到number的映射
		创建readGroupReverseLookupTable：存储number到readGroupID的映射
	设置协变列表。
		创建协变量对象：Special={ReadGroup，Quality};non-Special={Context,Cycle}
		将所有的协变量对象的字节码文件对象存储在indexByClass中。
	创建recalTables对象：根据协变量列表和readGroup创建：
		additionalTables;allTables;covariateToTable,tableToCovariate；对象，并向其对象中放入不同协变量对象和表格。
	获取reference数组资源
}

第二步：获取默认的read过滤器，用于BQSR context的列表，测试read格式是否良好，避免下游分析出错。

第三步：处理read上的每一个位点，是否能匹配到reference，根据该位点获取不同的协变量值，处理后的结果存储在recalTableFile中{
	read转换{
		合并每个碱基的比对情况，合并成一个cigar字符串
		设置默认的碱基质量值
		根据用户参数确认是否使用原始碱基质量（BQSR前，read有OQ标签不使用矫正后的质量分数，没有的话使用），设置原始的碱基质量值
		返回一个不包含接头的新read
		硬切掉软跳过的碱基，返回新read
	}
	统计该read中SNP和indel的事件总数nError（不管执不执行BAQ，都要统计）
	是否执行BAQ修正{
		不修正：当nError数为0或者用户参数不执行BAQ
		修正：read中SNP和INDEL的事件总数不等于0 或者用户参数enableBAQ值是false（！fasle=true）
	}
	baqArray不为null{
		针对read上每一个碱基计算所有的协变量值矩阵
		跳过已知的变异位点，低质量和非规律性的碱基
		计算snpError数组（根据isSNP，baqArray）
		计算insertionError数组（根据isInsertion和baqArray）
		计算deletionError数组（根据isDeletion和baqArray）
		在特定table的特定位置（碱基位点）增加RecalDatum{
			假如没有RecalDatum,就利用一个observation和一个或零个错误新增一个RecalDatum(根据组合的协变量构建RecalDatum)。
			假如存在RecalDatum，直接增加观察数和mismatch数				
		}
		存在特殊的协变量，也同样在特定table的特定位置（碱基位点）增减RecalDatum。
	}
	对已处理的read数目加1
}

第四步：质量分数表已全部更新，通过read Group遍历质量分数表以此创建汇总表格{
		rgDatum为空：创建qualDatum副本，并使用read Group初始化
		rgDatum不为空：利用read Group组合qualDatum
		复制BQSR结果recalibrationTable，将相应列的数值进行有效位数的四舍五入
}

第五步：通过质量分数表和使用观察数和经验质量分数建立量化的质量分数直方图，然后通过量化算法，森林惩罚法，生成重矫正质量和量化质量之间的map映射。

第六步：通过输入根据协变量生成的用户报告表；量化质量表和重矫正表生成重矫正的GATK报告。