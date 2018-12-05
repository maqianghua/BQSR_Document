第二阶段
获取默认的read过滤器
public List<ReadFilter> getDefaultReadFilters() {
	return getStandardBQSRReadFilterList();
	// 返回基本的原始read filters用于BQSR contexts的列表，包含WellFormed
	// 返回还没有被header填充的原始read过滤器列表
	public static List<ReadFilter> getStandardBQSRReadFilterList() {
		final List<ReadFilter> bqsrFilters = getBQSRSpecificReadFilterList();
		// 返回基本的原始read filters用于BQSR contexts的列表，不包含WellFormed
		// 返回原始read filters列表 ，还没有被header初始化，
		public static List<ReadFilter> getBQSRSpecificReadFilterList() {
		 	List<ReadFilter> filters = new ArrayList<>(6); // 创建容量为6的list
		 	// 过滤掉比对的质量值为0的reads
	        filters.add(ReadFilterLibrary.MAPPING_QUALITY_NOT_ZERO);
	        // 过滤掉比对的质量值不可得的reads，（比对质量为255）
	        filters.add(ReadFilterLibrary.MAPPING_QUALITY_AVAILABLE); 
	        // 过滤掉没有比对上的reads
	        filters.add(ReadFilterLibrary.MAPPED);
	        // 过滤掉代表secondary比对情况的reads（0x100）256
	        filters.add(ReadFilterLibrary.NOT_SECONDARY_ALIGNMENT);
	        // 过滤掉被标记为重复的reads(0x400):1024
	        filters.add(ReadFilterLibrary.NOT_DUPLICATE);
	        // 过滤掉没有通过platform/vendor质量检查的reads(0x200):512
	        filters.add(ReadFilterLibrary.PASSES_VENDOR_QUALITY_CHECK);
	        return filters;
		}
		// 测试一个read是否是“(引号$quto);格式良好的引号;也就是说，该read内部有重大的不一致性和问题，可能会导致下游流程分析的错误，假如一个read通过了该过滤，剩下的engine将能顺利处理该read。（不会产生失败）
		bqsrFilters.add(new WellformedReadFilter());		
	}
}

