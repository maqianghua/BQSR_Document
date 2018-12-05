第一步：根据read所在窗体的不同，将（样本ID，染色体ID，窗体ID，read比对到reference的起始位置）作为key，将（SAMRecord read）作为value输出到reducer

第二步：
假如染色体ID为-1（该窗体内的read没有比对到染色体上）{
	遍历所有的read，将其输出。并清空SAMRecord列表，清空过滤后的SAMRecord列表。
}否则{
	根据染色体ID和窗体ID设置win（包含染色体名，染色体ID，窗体起始位置，窗体终止位置）	
	进行重矫正{
		获取窗体内的碱基序列，
		获取窗体内的所有已知SNPs
		遍历所有的read{
			read所在窗体ID与reducer 的key获取的窗体ID不一致，就不会执行质量统计，过滤，矫正等工作。
			假如read所在窗体ID和reducer窗体ID一致{
				假如read没有通过过滤（即就是read没有提前被（比对和去重复）标记，就需要比对矫正）{
					遍历read的碱基{
						获取碱基相对于reference上的位置qpos
						dnsnp中不包含该碱基（只判断mismatch）{
							/ 假如read Color Space不一致（是与预先设置的Color标签值不一致？）{
								退出比对read函数
							}/ 否则{
								计算read协变量
							}
							/ 假如该碱基未比对到reference上，或碱基质量小于6，或该read的协变量为null，或该碱基与read的Color space不一致，退出当前碱基操作，执行下一个碱基
							/ 根据碱基在reference上的位置，碱基字节码，碱基质量，reference上的碱基字符值（强转为字节码值byte）,read的协变量， 更新数据表(rgRecalTable,QualRecalTable,covRecalTable)。
						}
					}
				}
			}
		}
	}
	清空ArrayList<GaeaSamRecord> records 和ArrayList<GaeaSamRecord> filteredRecords
}

第三步：将所有的table和table中的元素，进行对象的唯一性封装，转换成String对象，然后通过多个Reducer输出。
