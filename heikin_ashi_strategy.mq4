//+------------------------------------------------------------------+
//|                                         heikin_ashi_strategy.mq4 |
//|                              ALIREZA DEZFOOLI NEZHAD (ADN_GROUP) |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ALIREZA DEZFOOLI NEZHAD (ADN_GROUP)"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 6






#property  description "id telegram: @Adn1994"
#property  description "Alireza Dezfooli Nezhad"



double haclose[];
double haOpen[];
double haHigh[];
double haLow[];

         
  
double tr_ema13_long[];
double tr_ema13_short[];





//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {






/*


SetIndexBuffer(0,haOpen);
    SetIndexLabel(0,"haOpen");

      
      
SetIndexBuffer(1,haHigh);
    SetIndexLabel(1,"haHigh");

      
      
SetIndexBuffer(2,haLow);
    SetIndexLabel(2,"haLow");

      
      
SetIndexBuffer(3,haclose);
    SetIndexLabel(3,"haclose");

*/





//--- sets first bar from what index will be drawn
   IndicatorSetString(INDICATOR_SHORTNAME,"heikin_ahi");
   

  
















   return(INIT_SUCCEEDED);
  }
  
  
  
 //-----------------------------------------------------------------------
void OnDeinit(const int reason) 
{

ObjectsDeleteAll();

ChartRedraw();

}

 
  
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {









SetIndexBuffer(0,haOpen);
    SetIndexLabel(0,"haOpen");

      
      
SetIndexBuffer(1,haHigh);
    SetIndexLabel(1,"haHigh");

      
      
SetIndexBuffer(2,haLow);
    SetIndexLabel(2,"haLow");

      
      
SetIndexBuffer(3,haclose);
    SetIndexLabel(3,"haclose");












    SetIndexBuffer(4,tr_ema13_long);
   SetIndexStyle(4,DRAW_ARROW,5,2,clrRed);
    SetIndexArrow(4,159);
    SetIndexLabel(4,"tr_ema13_long");




    SetIndexBuffer(5,tr_ema13_short);
   SetIndexStyle(5,DRAW_ARROW,5,2,clrBlue);
    SetIndexArrow(5,159);
    SetIndexLabel(5,"tr_ema13_short");










for(int i=rates_total-60;i>=0 ;i--)


{ 






haclose[i]=( iOpen(Symbol(),PERIOD_CURRENT,i)+ iHigh(Symbol(),PERIOD_CURRENT,i)+ iLow(Symbol(),PERIOD_CURRENT,i)+ iClose(Symbol(),PERIOD_CURRENT,i))/4; 
haOpen[i]= ( haOpen[i+1]+ haclose[i+1])/2;
haHigh[i]=MathMax(iHigh(Symbol(),PERIOD_CURRENT,i),MathMax(haOpen[i],haclose[i]));
haLow[i]=MathMin( iLow(Symbol(),PERIOD_CURRENT,i),MathMin(haOpen[i],haclose[i]));






mainex(i);


trailing(i);



}





   return(rates_total);
  }
  
  
//--------------------------------------------------------------------
void trailing(int i)
{

double ema0=iMA(Symbol(),PERIOD_CURRENT,13,0,MODE_EMA,PRICE_CLOSE,i);
double ema1=iMA(Symbol(),PERIOD_CURRENT,13,0,MODE_EMA,PRICE_CLOSE,i+1);

double sma0=iMA(Symbol(),PERIOD_CURRENT,49,0,MODE_SMA,PRICE_CLOSE,i);
double sma1=iMA(Symbol(),PERIOD_CURRENT,49,0,MODE_SMA,PRICE_CLOSE,i+1);





if( haclose[i+1]>=ema1   &&   haclose[i]<ema0    )
{

tr_ema13_long[i]=iHigh(Symbol(),PERIOD_CURRENT,i)*1.05;
}



if( haclose[i+1]<=ema1   &&   haclose[i]>ema0    )
{

tr_ema13_short[i]=iLow(Symbol(),PERIOD_CURRENT,i)*1.05;
}







}  
  
  
//--------------------------------------------------------------------

void mainex(int i)
{

double ema0=iMA(Symbol(),PERIOD_CURRENT,13,0,MODE_EMA,PRICE_CLOSE,i);
double ema1=iMA(Symbol(),PERIOD_CURRENT,13,0,MODE_EMA,PRICE_CLOSE,i+1);

double sma0=iMA(Symbol(),PERIOD_CURRENT,49,0,MODE_SMA,PRICE_CLOSE,i);
double sma1=iMA(Symbol(),PERIOD_CURRENT,49,0,MODE_SMA,PRICE_CLOSE,i+1);




if( haclose[i]>ema0  &&  haclose[i]>sma0   &&    ema0>sma0   &&  haOpen[i]==haLow[i]  )
{



           {Vertical_Line(0,"vlinelong"+IntegerToString(i),0,iTime(Symbol(),0,i),clrGreen,STYLE_DASH,2);}


}



if( haclose[i]<ema0  &&  haclose[i]<sma0   &&    ema0<sma0   &&  haOpen[i]==haHigh[i])
{



           {Vertical_Line(0,"vlineshort"+IntegerToString(i),0,iTime(Symbol(),0,i),clrRed,STYLE_DASH,2);}


}










}
//+------------------------------------------------------------------+
//| خط عمودی (Vertical Line)                                         |
//+------------------------------------------------------------------+
bool Vertical_Line(const long          chart_ID=0,        // ای دی چارت
                   const string          name="VLine",      // اسم خط
                   const int             sub_window=0,      // شماره پنجره
                   datetime              time=0,            // زمان قرار گیری خط
                   const color           clr=clrRed,        // رنگ خط
                   const ENUM_LINE_STYLE style=STYLE_SOLID, // استایل خط
                   const int             width=1,           // اندازه خط
                   const bool            back=false,        // قرار کرفتن در پشت
                   const bool            selection=false,    // قابلیت حرکت
                   const bool            hidden=true,       // مخفی شدن از لیست
                   const long            z_order=0)         // اولویت برای کلیک ماوس
  {

   ResetLastError();
   if(ObjectCreate(chart_ID,name,OBJ_VLINE,sub_window,time,0))
     {
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
      ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ChartRedraw();
      return(true);

     }
   else
     {
      Print(__FUNCTION__,
            ": failed to create => ",name," object! Error code = ",GetLastError());
      return(false);
     }
  }


//-------------------------------------------------------------------------------
