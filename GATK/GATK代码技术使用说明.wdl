技术说明6：
non-PF reads：
	通过chastity——filter的碱基叫pass-filter
	定义：前面25个周期中，没有一个碱基的chastity小于0.6
	chastity=最亮强度的碱基数/(最亮强度的碱基数+次亮强度的碱基数)
Illumina sequencers perform an internal quality filtering procedure called chastity filter, and reads that pass this filter are called PF for pass-filter. According to Illumina, chastity is defined as the ratio of the brightest base intensity divided by the sum of the brightest and second brightest base intensities. Clusters of reads pass the filter if no more than 1 base call has a chastity value below 0.6 in the first 25 cycles. This filtration process removes the least reliable clusters from the image analysis results.
For additional information on chastity filters, please see:
Illumina, Inc. (2015). Calculating Percent Passing Filter for Patterned and Non-Patterned Flow Cells: A comparison of methods for calculating percent passing filter on Illumina flow cells
Ilumina Inc. (2014) HiSeq X System user guide
Both articles can be found at http://www.Illumina.com

技术说明5：
GATK代码使用技术说明：
D:\GitHub\back\gatk\src\main\java\org\broadinstitute\hellbender\utils\recalibration\covariates\ContextCovariate.java
//Note: we're using a non-standard library here because boxing came up on profiling as taking 20% of time in applyBQSR.IntList avoids boxing
IntList避免了在应用applyBQSR的时候造成装箱与拆箱的性能损失

技术说明4：
C:\Users\maqianghua\.gradle\caches\modules-2\files-2.1\com.github.samtools\htsjdk\2.16.1\60f9e412216c66b438c08e0d2eb61826c96f266f\htsjdk-2.16.1-sources.jar!\htsjdk\samtools\util\Locatable.java
Locatable.java:{
	格式：public interface Locatable
	说明：任何有一个简单的映射逻辑到基因上的类，都要实现该Locatable接口。应该是基于1开始，并可以从两端结束
}

技术说明3：
// D:\GitHub\back\gatk\src\main\java\org\broadinstitute\hellbender\utils\baq\BAQ.java
on the fly计算BAQ数组，使用的HMM（Hidden Markov Model）隐马尔可夫模型。（后面需要的话，进行深究）

技术说明2：
// enum的values方法：
	1 在Enum的API文档中找不到这个方法
	2 理论上此方法可以将枚举类型转变为一个枚举类型的数组，因为枚举中没有下标，我们没有办法通过下标来快速找到需要的枚举类，这时候，转变为数组之后，我们就可以通过数组的下标，来找到我们需要的枚举类了。
// 每次调用EventType.values()（或者是枚举类型）建立一个新的数组实例，但是它们都是相等的（等价于包含相同的元素）
// 当该数组被建立了数十亿次，当在BQSR案例中，那将是非常昂贵且浪费资源的
// 解决办法就是缓存它们到这里

技术说明1：
D:\GitHub\back\gatk\src\main\java\org\broadinstitute\hellbender\utils\recalibration\EventType.java
private final EventType[] cachedEventTypes;
// 返回一个缓存值是EventType.values()的调用。（更加精确，一个不能修改的数组列表视图）
// 每次调用EventType.values()（或者是枚举类型）建立一个新的数组实例，但是它们都是相等的（等价于包含相同的元素）
// 当该数组被建立了数十亿次，当在BQSR案例中，那将是非常昂贵且浪费资源的
// 该解决办法是建立一次，重复使用
// 然而我们不能把这个数组暴露给API，因为我们不能建立一个一成不变的数组
// 暴露该数组当做一个列表也不能工作，因为Collections.UnmodifiableCollection.iterator()的性能很差，并会破坏我们的性能
// 解决方案就是暴露该数组通过只读方式调用，并拥有明确的迭代clients
 private static final EventType[] cachedValues = EventType.values();