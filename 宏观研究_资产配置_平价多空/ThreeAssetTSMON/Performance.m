function [ output ] = Performance( AssetAll )
%计算收益指标
caplist = cell2mat(AssetAll(2:end,5));%总资本序列
capital = caplist(1);
TradingDays = AssetAll(2:end,1);
%capital为资本金
%tradingdays为日期
%pnllist为盈亏序列
%% 本周盈亏
pnllist = diff(caplist);
pnl_week = sum(pnllist((end-4):(end))); %本周盈亏
ret_week = pnl_week/capital; %本周收益率

%% 累计盈亏和累计盈亏，收益率
cumpnl = cumsum(pnllist);%累计盈亏序列
cumpnl_end = cumpnl(end); %累计盈亏
ret_all = cumpnl(end)/capital;%收益率

%% 收益率序列
%retlist = diff(caplist)./caplist(1:(end-1));
retlist = log(caplist(2:end)./caplist(1:(end-1))); %对数收益率,适应后文累计收益率的计算
retlist = [0;retlist]; %在第一个位置添加一个零
dailyret = retlist;%收益率序列

%% 最大回撤
dailyret(isnan(dailyret)) = 0;
retcum = cumsum(dailyret);
drawdown = retcum - cummax(retcum);
MaxDD = min(drawdown);

%%  年化收益率
AnnualYield = mean(dailyret)*252;

%% 年化夏普率
volatility_year = std(dailyret)*sqrt(252);% 年化波动率
%年化夏普率
if(std(dailyret) ~= 0)
    Sharpe = sqrt(252)*mean(dailyret)./std(dailyret);
else
    Sharpe = NaN;
end

%% 累计净值序列
netlist = cell(size(caplist,1),size(caplist,2));
for i = 1:size(caplist,1)
    netlist{i} = caplist(i)/caplist(1);
end
%% 年收益率


%% 输出结果
output(:,1) = TradingDays; %日期
output(:,2) = netlist; %累计净值
output{1,3} = '本周盈亏'; output{1,4} = pnl_week;
output{2,3} = '本周收益率' ; output{2,4} = ret_week;
output{3,3} = '累计盈亏' ; output{3,4} = cumpnl_end;
output{4,3} = '收益率'; output{4,4} = ret_all;
output{5,3} = '最大回撤'; output{5,4} = MaxDD;
output{6,3} = '年化收益率'; output{6,4} = AnnualYield;
output{7,3} = '年化波动率'; output{7,4} = volatility_year;
output{8,3} = '年化夏普率'; output{8,4} = Sharpe;
end