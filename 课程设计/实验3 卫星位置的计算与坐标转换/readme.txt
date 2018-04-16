getSatpos.m    主函数
ephemeris.m    导航电文解析函数
satpos.m       卫星位置计算函数
check_t.m      周内秒计数预处理函数。
               按照ICD文件，为解决跨周问题，通常参考历元定为周中。当t-t0大于302400时（即跨到第二周时），t-t0减去604800，当t-t0小于-302400时，t-t0加604800

其他辅助函数在ehpemeirs.m中会用到：
checkPhase.m   根据ICD文件，根据上一个字的最后一个bit校验位，对后续30bit做原始数据恢复
invert.m       根据checkPhase需要，按照ICD进行bit值翻转，导航电文恢复用
twosComp2dec.m 将由'0'、'1'构成的char数组，转换成对应的整数,导航电文解析用

实验数据：
navBitsBinNN.mat PRN为NN卫星播发的一帧导航电文数据（类型为char）。其中，第1bit为上一个字最后一个bit，第2-1501个bit为完整的一帧导航电文 
