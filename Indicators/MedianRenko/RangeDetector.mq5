//+------------------------------------------------------------------+
//|                                                          RRD.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, File45"
#property link      "http://codebase.mql4.com/en/author/file45"
#property version   "1.01"
#property strict
#property indicator_chart_window

input string Text = "Renko";
input color Font_Color = DodgerBlue;
input int Font_Size = 11;
input bool Font_Bold = true;
input int Left_Right = 25;
input int Up_Down = 150;
input ENUM_BASE_CORNER Corner = CORNER_RIGHT_LOWER;

string The_Font;
double Pointz;
string name_rnk;
string Renko_Range;

bool   isFirstRun;
long   chartId;

//
#include <AZ-INVEST/CustomBarConfig.mqh>
//
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   Pointz=_Point;
// 1, 3 & 5 digits pricing
   if(_Point==0.1) Pointz=1;
   if((_Point==0.00001) || (_Point==0.001)) Pointz*=10;

   if(Font_Bold==true)
     {
      The_Font="Arial Bold";
     }
   else
     {
      The_Font="Arial";
     }

   name_rnk = "RNK";
   isFirstRun = true;
   chartId = ChartID();


   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Deinit                  
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectDelete(chartId, name_rnk);
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
   if(!customChartIndicator.OnCalculate(rates_total,prev_calculated,time,close))
      return(0);
      
   if(!customChartIndicator.BufferSynchronizationCheck(close))
      return(0);
   
   if(customChartIndicator.IsNewBar == false && isFirstRun == false)
   {
      isFirstRun = false;
      return(0);
   }
      
   int index = ArraySize(customChartIndicator.Close)-2;
   Renko_Range=DoubleToString(MathAbs((customChartIndicator.Open[index]-customChartIndicator.Close[index])/Pointz),1);
   
   if(ObjectFind(chartId, name_rnk)!=-1) 
      ObjectDelete(chartId, name_rnk);
   
   ObjectCreate(chartId,name_rnk,OBJ_LABEL,0,0,0);
   ObjectSetString(chartId,name_rnk,OBJPROP_TEXT,Text+" "+Renko_Range);
   ObjectSetString(chartId,name_rnk,OBJPROP_FONT,The_Font); 
   ObjectSetInteger(chartId,name_rnk,OBJPROP_COLOR,Font_Color);
   ObjectSetInteger(chartId,name_rnk,OBJPROP_FONTSIZE,Font_Size);
   ObjectSetInteger(chartId,name_rnk,OBJPROP_CORNER,Corner);
   ObjectSetInteger(chartId,name_rnk,OBJPROP_XDISTANCE,Left_Right);
   ObjectSetInteger(chartId,name_rnk,OBJPROP_YDISTANCE,Up_Down);

   return(rates_total);
  }
