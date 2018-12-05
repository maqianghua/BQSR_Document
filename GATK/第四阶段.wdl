BaseRecalibrationEngine.java
// 如果合适的话，在重新校准表中确定所有产生的数据。所有的read调用完processRead方法之后，该方法被调用一次。假设所有主要的表格（质量分数表）已经被完全更新了，并通过read group遍历此数据以创建汇总数据表。
public static void finalizeRecalibrationTables( final RecalibrationTables tables ) }{
	// RecalDatum:重矫正数据是单独的一个部分，每一部分统计了组合协变量的观察数量(碱基数)和reference错配的数量，
	// RecalibrationTables:实用的工具类，方便碱基质量分数的重矫正
	/ 获取byReadGroupTable（ReadGroup）和byQualTable(Quality)	
	// 遍历在qual表中的所有值:获取rgKey，事件类型索引，rgDatum，qualDatum。
	// if 当rgDatum为null){
		/// 创建qualDatum的副本，并使用它初始化byReadGroup表
		// 通过给定的键值在特定的位点插入一个数值；输入：插入的值RecalDatum；键是指定树中值的位置；
		// byReadGroupTable.put(new RecalDatum(qualDatum), rgKey, eventIndex);
		// public void put(final T value, final int... keys){
			/// 警告：值会先于键值
			/// 如果我们达到或超过了预先分配的最后一个维度，我们需要检查下一个现存的分支是否存在，假如不存在，我们就需要建立。
		}
	}else{
		/// 在byReadGroup表中利用现存的rgDatum组合qualDatum
		// 该对象中加入其他对象中的所有数据，通过两个对象中的Error数和碱基数，更新reported quality，输入：需要组合的RecalDatum
		// rgDatum.combine(qualDatum);
		// public void combine(final RecalDatum other) {
			// 在datum中，计算给定估计报告质量和观测值的预期误差数量:返回：对错误数量的估计为正数(可能是部分)
			// private double calcExpectedErrors(){
				/// 返回观察数量与预期误差数量的乘积
				// return getNumObservations() * QualityUtils.qualToErrorProb(estimatedQReported);
			}
			// 算总的Errors
			// 计算estimatedQReported=-10 * Math.log10(sumErrors / getNumObservations());
			// empiricalQuality=-1
		}
	}
	/// 复制BQSR的结果，不管我们是否保存表格到存储上（在spark上我们需要），我们需要把数字缩减到小数点后几位（那是写入和读取做的事）
	// roundTableValues(tables);
	// private static void roundTableValues(final RecalibrationTables rt) {
		// 把double数值四舍五入到给定的小数点位。举例:四舍五入3.1415926到3位有效位位3.142.要求是:该方法求解要准确。写入和读取数字都是以字符串的形式表示。mismatch数保留2位有效位，EmpiricalQuality和EstimatedQReported保留4位有效位数
		// leaf.value.setNumMismatches(MathUtils.roundToNDecimalPlaces(leaf.value.getNumMismatches(), RecalUtils.NUMBER_ERRORS_DECIMAL_PLACES));
		// public static double roundToNDecimalPlaces(final double in, final int n) 
	}
}