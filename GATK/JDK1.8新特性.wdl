
案例4：
D:\GitHub\back\gatk\src\main\java\org\broadinstitute\hellbender\utils\recalibration\covariates\StandardCovariateList.java
/**
 * 返回一个可读的字符串代表已使用的协变量
 * 返回：一个非空的，逗号隔开的字符串
 */
 public String covariateNames() {
        return String.join(",", getStandardCovariateClassNames());
    }
案例3：
D:\GitHub\back\gatk\src\main\java\org\broadinstitute\hellbender\transformers\ReadTransformer.java
/**
 * Classes将会执行从GATKread到GATKread的转换，应该通过重写{@link SerializableFunction<GATKRead,GATKRead>#apply(GATKRead)}
 * 实现该接口
 */
@FunctionalInterface
public interface ReadTransformer extends UnaryOperator<GATKRead>, SerializableFunction<GATKRead, GATKRead> {
	//HACK: These methods are a hack to get to get the type system to accept compositions of ReadTransformers
	// HACK：这些方法是为了让类型系统接收ReadTransformers的组合	
}

案例2：
D:\GitHub\back\gatk\src\main\java\org\broadinstitute\hellbender\utils\recalibration\covariates\ReadGroupCovariate.java
/*
 * Stores the mapping from read group id to a number.
 */
private final Map<String, Integer> readGroupLookupTable;

/*
 * Stores the reverse mapping, from number to read group id.
 */
private final Map<Integer, String> readGroupReverseLookupTable;
readGroups.stream().filter(readGroupId -> !rgLookupTable.containsKey(readGroupId)).forEach(readGroupId -> {
            final int nextId = rgLookupTable.size();
            rgLookupTable.put(readGroupId, nextId);
            rgReverseLookupTable.put(nextId, readGroupId);
        });
 案例1：
 D:\GitHub\back\gatk\src\main\java\org\broadinstitute\hellbender\utils\recalibration\covariates\ReadGroupCovariate.java
public static List<String> getReadGroupIDs(final SAMFileHeader header) {
        return header.getReadGroups().stream().map(rg -> getID(rg)).collect(Collectors.toList());
    }

