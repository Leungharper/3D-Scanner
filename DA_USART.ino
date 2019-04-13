// 通过（MATLAB）与arduino的串口通信控制DA模块

void setup()
{
  Serial.begin(9600);//设置波特率9600
  DDRD = 0xFF;
  //DDRD = B11111111;
  
  // 下面的等值于 OC1A = 输出用于定时器1的CTC模式
  pinMode(9, OUTPUT);  // 设置默认关联了D9（查表得知）为输出
  TCCR1B=0; // 只是个复位的习惯可以不要
  TCCR1A=_BV(COM1A0); // 要是困扰的话你也可以写成 TCCR1A = 0b01000000; 
  //这里和上一个表示了 = CTC 模式, 开启比较器（默认输出）, prescaler = 1
  TCCR1B = _BV(WGM12)|_BV(CS10) ; //  这里等值于 TCCR1B = 0b00001001;

  // 最有意思的了，16位的玩意来确定要一个怎样的频率
  OCR1A = 0; // 计算为：F_CPU/2/Need_HZ-1 来得到你想要的，遗憾的是四舍五入来截取频率
}

int i = 0;
void loop()
{
  if( Serial.available() )
  {
    i = ( Serial.read() );//i = Serial.read();
    PORTD = i;
  }
}
