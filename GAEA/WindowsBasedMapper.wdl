WindowsBasedMapper.wdl
D:\GitHub\SOAPgaeaDevelopment4.0\src\main\java\org\bgi\flexlab\gaea\framework\tools\mapreduce\WindowsBasedMapper.java
protected void setup(Context context) throws IOException, InterruptedException{
	/ 获取配置文件对象
	/ 获取windowsSize值，默认值10000
	/ 获取windowsExtendSize值，默认值500
	/ 获取多样本判断布尔值，默认值false
	/ 获取是否仅执行bqsr的布尔值，默认值false
	/ 初始化输出值对象SamRecordWritable
	/ 获取SAMFile的头文件header
	/ 假如header为null{
		/ 获取输入的文件名数组String[]
		/ 抛出文件不存在异常，丢失header异常
	}
	/ 创建一个sampleIDS的HashMap对象<String,Integer>
	/ 获取header文件的所有ReadGroups List对象
	/ 遍历ReadGroup List对象，并将其第i个元素SAMReadGroupRecord获取SM(sampleName)标签值作为key，i作为值，插入到sampleIDs的HashMap对象中
	/ 获取SAM_RECORD_FILTER对应的class文件名
	/ 假如SAM_RECORD_FILTER对应的class文件名为null{
		/ 返回一个默认的SAMRecordFilter对象作为recordFilter
	}否则{
		/ 通过SAM_RECORD_FILTER对应的class文件建立SAMRecordFilter实例对象
	}
	/ 假如REFERENCE_REGION不为null{
		/ 获取region对象
		/ 通过region解析来自HDFS上的bed文件
	}
}
protected void map(LongWritable key, SamRecordWritable value, Context context) throws IOException, InterruptedException {
		/ 获取一行read：sam
		/ 通过region过滤read？（没有做过滤）
		/ 设置输出SamRecordWritable对象sam
		/ read isUnmapped为真{
			/ 假如不仅仅只做bqsr为真{
				/ 不考虑，只做BQSR
			}
		}
		/ 获取read的对应的染色体名chrName
		/ 根据read的比对起始位置，终止位置，染色体chrName的序列长度，获取扩展的位置int[] wimNum
		/ int[] winNums = getExtendPosition(sam.getAlignmentStart(), sam.getAlignmentEnd(),header.getSequence(chrName).getSequenceLength());
		protected int[] getExtendPosition(int start, int end, int length){
			/ winNum[0]:read比对的起始位置与windowsSize取商
			/ winNum[1]:条件：read比对的起始位置>windowsExtendSize；是：(read比对的起始位置-windowsExtendSize)/windowsSize;否：0/windowsSize
			/ winNum[2]:条件：(read比对的终止位置+windowsExtendSize)>染色体长度；是：染色体长度/windowsSize;否:(read比对的终止位置+windowsExtendSize)/windowsSize;
		}
		/ 遍历winNum的值，将相同窗体的read{
			/ 设置keyout的组成元素
			/ setKey(sam, winNums[i]);
			protected void setKey(SAMRecord sam, int winNum) {
				/ 设置输出的键WindowsBasedWritable keyout由sampleID,染色体ID(有可能值为-1,没有比对到任何一个染色体上),窗体ID(从0开始计数的)，read的比对起始位置组成。
				/ setKey(sam.getReadGroup().getSample(), sam.getReferenceIndex(), winNum, sam.getAlignmentStart());
				protected void setKey(String sampleName, int chrIndex, int winNum, int position) {
					// 假如是多样本的，通过sampleName获取sampleID，否则sampleID为0
				}
				/ 设置keyout的组成元素
			}
			/ 将keyout(类型 WindowsBasedWritable)和outputValue(read 类型SANRecord)输出到Reducer
		}
}
