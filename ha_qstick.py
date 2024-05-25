from datetime import datetime
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import yfinance as yf
import asyncio
import plotly.graph_objects as go
import math



last_day =datetime.now()
last_day=last_day.date()
last_day=str(last_day)






symbol_analyze="BTC-USD"
count=500     # how much candle ?



#################  download data


def yahoo_symbol(symbol="NVDA",timeframe='1d'):
    while True:
        try:
            data = yf.download(symbol,period='max',interval= timeframe)
            return(data)
        except Exception as e:
            print(f"An error occurred: {e}")
            asyncio.sleep(2)  # Sleep for 10 seconds before retrying




price_data=yahoo_symbol(symbol=symbol_analyze)
price_data=price_data.tail(count)





def heikinashi(symbol_data: pd.DataFrame) -> pd.DataFrame:
     
    df_HA = symbol_data.copy()
    df_HA['Close']=(df_HA['Open']+ df_HA['High']+ df_HA['Low']+df_HA['Close'])/4
 
    for i in range(0, len(symbol_data)):
        if i == 0:
            df_HA['Open'][i]= ( (df_HA['Open'][i] + df_HA['Close'][i] )/ 2)
        else:
            df_HA['Open'][i] = ( (df_HA['Open'][i-1] + df_HA['Close'][i-1] )/ 2)
 
    df_HA['High']=df_HA[['Open','Close','High']].max(axis=1)
    df_HA['Low']=df_HA[['Open','Close','Low']].min(axis=1)
    return df_HA



df_HA=heikinashi(price_data)
len_df=len(df_HA)






def calculate_qstick(length=14):

    
    # محاسبه تفاوت‌ها
    difference = df_HA['Close'].rolling(window=length).sum() - df_HA['Open'].rolling(window=length).sum()
    
    # محاسبه QStick
    df_HA['QStick'] = difference / length
    
    return df_HA



calculate_qstick(14)




plt.plot(df_HA['QStick'])
plt.axhline(y=0, color='g', linestyle='--', label='zeroline')
plt.show()