---
title: "学习scikit-learn"
date: 2020-07-14T21:23:07+08:00
tags: ["机器学习", "sklearn"]
categories: ["技术"]
---

# 安装

使用`scoop`很简单地安装`Anaconda3`

```powershell
scoop install anaconda3
```

# 配置环境并激活

## 创建环境

```powershell
conda create -n learn-scikit
```

## 激活环境

```powershell
conda activate learn-scikit
```

## 退出环境

```powershell
conda deactive
```

## 删除环境

```powershell
conda remove -n learn-scikit --all
```

## 列出当前所有已创建的环境

```powershell
conda env list
```

*`Windows`上的最新命令`activate`和`deactivate`前都有加`conda`了，以前不加可以使用，但现在必须要加了。*

## 解决Collecting package metadata (current_repodata.json): failed

方案来自GitHub [#9554](https://github.com/conda/conda/issues/9554) [#9555](https://github.com/conda/conda/issues/9555)

> Copy files libcrypto-1_1-x64.dll and libssl-1_1-x64.dll from the directory ./Anaconda3/Library/bin/ to ./Anaconda3/DLLs.

## 解决Your shell has not been properly configured to use 'conda activate'

使用`Windows Terminal`的`PowerShell`时，输入`conda activate learn-scikit`会显示无法使用`conda activate`，即使我按照提示使用`conda init powershell`命令后也不行，于是转而想使用`Anaconda`自带的`Anaconda Powershell Prompt`，于是往`Windows Terminal`的设置里面添加一个`Anaconda`的标签页。

以下内容添加至`Windows Terminal`的`setting.json`，`profiles`的`list`里

```json
{
	// Make changes here to the cmd.exe profile.
	"guid": "{0caa0dad-35be-5f56-a8ff-afceee452369}",
	"name": "Anaconda",
	"icon": "%USERPROFILE%\\scoop\\apps\\anaconda3\\current\\Menu\\anaconda-navigator.ico",
	"commandline": "%windir%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -ExecutionPolicy ByPass -NoExit -Command \"& 'C:\\Users\\LittleGhost\\scoop\\apps\\anaconda3\\2020.02\\shell\\condabin\\conda-hook.ps1'\"",
	"hidden": false
}
```

*注意`commandline`这一项，后面的`C:\\Users\\LittleGhost\\scoop\\apps\\anaconda3\\2020.02\\shell\\condabin\\conda-hook.ps1`请根据情况自行修改，直接复制以上配置肯定是会出错的。*

# 简单例子

```python
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score
import pandas as pd

data = pd.read_csv('in.csv')
# 读取数据
ipdata = data.copy()
# 拷贝数据

ipdata.dropna(axis=0, how='any', inplace=True)
# 当某一行有空值时，将该行数据删除
# 当然，可以选择其他处理空值的方法，例如使用平均值或者中值等数据进行填充

y = ipdata['type']
# 可以将数据集中的最后一列看作y轴上的变量，其余值当作X轴上的变量，因此此处设置数据中`type`这一列为y
# 等下进行X的设置

single_unique_cols = [col for col in ipdata.columns if ipdata[col].nunique() == 1]
# 找出只有一种值的那一列

ipdata.drop(single_unique_cols, axis=1, inplace=True)
# 丢掉只有一种值的那几列，因为这几列作为特征没有意义，因此丢掉
ipdata.drop('type', axis=1, inplace=True)
# 丢掉y轴上的变量，此时X轴上的变量即为ipdate

X_train, X_test, y_train, y_test = train_test_split(ipdata.values, y, test_size=0.3, random_state=17)
# 使用ipdata.values, y作为X和y
# test_size=0.3表示为：将数据集中30%作为测试集，其余为训练集
# random_state=17表示为：打乱数据集的程度


# 以下以决策树为例

tree = DecisionTreeClassifier(max_depth=11, random_state=17)
# 导入决策树模型
# max_depth=11表示为：决策树最大深度为11
# random_state=17表示为：分枝中的随机模式的参数，默认值None

tree.fit(X_train, y_train)
# 拟合训练数据

tree_pred = tree.predict(X_test)
# 使用已训练的模型对测试集进行预测

accuracy = accuracy_score(y_test, tree_pred)
# 将由模型出来的预测结果与测试机作比较，获得准确度

print('accuracy', accuracy)
```

# 机器学习主要步骤

导入数据->预处理+划分数据集（训练集和测试集）->导入模型（调参）->拟合数据->预测数据模型评估

## 导入数据+预处理+划分数据集

训练集和测试集可以分两次导入 或者 一次性导入后由`sklearn`自动区分。

### 两次导入

```python
train = pd.read_csv(train_csv_filepath, parse_dates=True)
test = pd.read_csv(test_csv_filepath, parse_dates=True)
# 其中parse_dates参数的作用是将csv中的时间字符串转换成日期格式，如果不涉及时间时可以不设置此参数
```

### 一次导入

```python
data = pd.read_csv(csv_filepath, parse_dates=True)

...
# 数据预处理

X_train, X_test, y_train, y_test = train_test_split(data.values, y, test_size=0.3, random_state=17)
# 区分数据集
```

### 导入模型示例

调参还没看到-_-||

#### 逻辑回归

```python
from sklearn.metrics import confusion_matrix, precision_recall_curve, roc_curve, auc, log_loss
logreg = LogisticRegression()
logreg.fit(X_train, y_train)
y_pred = logreg.predict(X_test)
```

```
print('Train/Test split results:')
```

#### 随机森林

```python
from sklearn.ensemble import RandomForestClassifier
rf_clf = RandomForestClassifier()
rf_clf.fit(X_train, y_train)
pred_rf = rf_clf.predict(X_test)
acc_rf = accuracy_score(y_test, pred_rf)
print(acc_rf)
```

目前就学到这里了...学习机器学习的第四天，好菜啊...

# 附录

## 代码回显

### data.head()

显示数据集的前五行（不包括列名称那一行）

```python
print(data.head())
```

```
#             0   1     2             3          4         5          6           7           8  ...           37           38  39    40            41     42  43  protocol  type
# 0  154.333333  60   447  2.806225e+04   0.005014  0.000010   0.025647     0.00007   98.555556  ...      0.00015    27.666667   0    77  1.834333e+03    253   3    botnet     1
# 1   64.515152  60   303  3.726049e+02  21.872947  0.000005  95.096931  1591.90077   10.393939  ...   2245.97092    10.862500   0   249  7.316644e+02   5201  80    botnet     1
# 2  707.850000  60  5894  2.190878e+06   0.004535  0.000004   0.035794     0.00014  653.450000  ...      0.00035  2579.600000   0  5840  3.998264e+06  26344  10    botnet     1
# 3  720.435294  60  5894  1.425022e+06   0.026498  0.000002   0.316742     0.00540  666.247059  ...      0.01323  2077.740741   0  5840  1.571990e+06  57565  27    botnet     1
# 4  490.079545  60  3126  4.429459e+05   0.114622  0.000002   5.997465     0.41719  435.943182  ...      1.37860  1178.656250   2  3072  3.478916e+05  39449  32    botnet     1

# [5 rows x 46 columns]
```

### data.shape

数据集的行数和列数

```python
print(data.shape)
```

```
# (1490, 46)
```

### data.columns

列名称

```python
print(data.columns)
```

```
# Index(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12',
#    '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24',
#    '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36',
#    '37', '38', '39', '40', '41', '42', '43', 'protocol', 'type'],
#    dtype='object')
```

### data.info()

```python
print(data.info())
```

```
# <class 'pandas.core.frame.DataFrame'>
# RangeIndex: 1490 entries, 0 to 1489
# Data columns (total 46 columns):
# 0           1490 non-null float64
# 1           1490 non-null int64
# 2           1490 non-null int64
# 3           1490 non-null float64
# 4           1490 non-null float64
# 5           1490 non-null float64
# 6           1490 non-null float64
# 7           1490 non-null float64
# 8           1490 non-null float64
# 9           1490 non-null int64
# 10          1490 non-null int64
# 11          1490 non-null float64
# 12          1490 non-null int64
# 13          1490 non-null float64
# 14          1490 non-null int64
# 15          1490 non-null int64
# 16          1490 non-null float64
# 17          1490 non-null int64
# 18          1490 non-null int64
# 19          1490 non-null float64
# 20          1490 non-null float64
# 21          1490 non-null float64
# 22          1490 non-null float64
# 23          1487 non-null float64
# 24          1490 non-null float64
# 25          1490 non-null int64
# 26          1490 non-null int64
# 27          1490 non-null float64
# 28          1490 non-null int64
# 29          1490 non-null int64
# 30          1490 non-null float64
# 31          1490 non-null int64
# 32          1490 non-null int64
# 33          1458 non-null float64
# 34          1458 non-null float64
# 35          1458 non-null float64
# 36          1458 non-null float64
# 37          1362 non-null float64
# 38          1490 non-null float64
# 39          1490 non-null int64
# 40          1490 non-null int64
# 41          1458 non-null float64
# 42          1490 non-null int64
# 43          1490 non-null int64
# protocol    1490 non-null object
# type        1490 non-null int64
# dtypes: float64(25), int64(20), object(1)
# memory usage: 535.5+ KB
# None
```

### data.dtype == 'O'

数值型列

```python
non_num_cols = [col for col in data.columns if data[col].dtype == 'O']
non_num_data = data[non_num_cols]
```

### num_cols

数值型

```python
num_cols = list(set(data.columns) - set(non_num_cols))
```

### 非数值型列及值种类

```python
print([(col, non_num_data[col].nunique()) for col in non_num_cols])
```

```
# [('protocol', 2)]
```

### 非数值型列中各值的比例

```python
def summarize_cat(col_name):
    sorted_values = sorted(non_num_data[col_name].value_counts().iteritems(), key = lambda x:x[1], reverse=True)
    remaining_per = 100
    for (value, count) in sorted_values:
        per = count / len(non_num_data) * 100
        if per >= 1:
            print(f'{value} : {per:.2f}%')
        else :
            print(f'Others : {remaining_per:.2f}%')
            break
        remaining_per = remaining_per - per

for col in non_num_cols:
	print(f"Summary of {col} column : ")
	summarize_cat(col)
	print('\n')
```

```
# Summary of protocol column :
# web : 58.93%
# botnet : 41.07%
```

### data.describe()

数据的概述

```python
print(data[num_cols].describe())
```

```
#                  35           22             5           34            4           38     ...                17           31           18           39           14           23
# count  1.458000e+03  1490.000000  1.490000e+03  1458.000000  1490.000000  1490.000000     ...       1490.000000  1490.000000  1490.000000  1490.000000  1490.000000  1487.000000
# mean   1.083619e-01    18.427270  8.767883e-06     2.727398     1.246424   467.326310     ...         62.770470    63.063087   657.128859     0.056376    72.795302    78.803126
# std    1.347127e+00    23.793159  1.871342e-05     6.383875     1.998975   463.315265     ...          3.680627     3.502668   423.490892     0.331130   397.439873   229.754015
# min    9.536743e-07     0.000751 -9.536743e-07     0.000740     0.000175     0.000000     ...         54.000000    54.000000    62.000000     0.000000     4.000000     0.000000
# 25%    8.106232e-06     0.164139  3.814697e-06     0.055656     0.055600   105.906250     ...         60.000000    60.000000   367.500000     0.000000    11.000000     0.006610
# 50%    3.993511e-05     9.600529  5.960464e-06     0.623061     0.518072   396.160954     ...         66.000000    66.000000   529.000000     0.000000    19.000000     5.027170
# 75%    5.565286e-04    45.163266  8.106232e-06     3.642134     1.693726   599.325000     ...         66.000000    66.000000   887.000000     0.000000    39.000000   100.957545
# max    4.545752e+01   297.300050  3.221035e-04   166.666251    33.333297  3442.111111     ...         66.000000    74.000000  1514.000000     2.000000  9241.000000  6732.370350

# [8 rows x 45 columns]
```

### data.isnull().any()

判断哪些列存在缺失值

```python
print([col for col in num_cols if data[col].isnull().any()])
```

```
# ['35', '37', '36', '34', '33', '23', '41']
```

### 每一列的范围以及唯一值的个数

```python
print("range and no. of unique values in numeric columns")
for col in num_cols:
    print(f'{col}\tRange : {max(data[col]) - min(data[col])}, No. of unique values : {data[col].nunique()}')
```

```python
# range and no. of unique values in numeric columns
# 37      Range : 83331.97094, No. of unique values : 1201
# 42      Range : 6749637, No. of unique values : 978
# 11      Range : 3453236.71542, No. of unique values : 1129
# 30      Range : 3437.0, No. of unique values : 993
# 43      Range : 4947, No. of unique values : 151
# 40      Range : 8853, No. of unique values : 232
# 8       Range : 1087.0764488286068, No. of unique values : 1118
# 24      Range : 1281.3886792452831, No. of unique values : 1015
# 35      Range : 45.45751905441284, No. of unique values : 662
# 18      Range : 1452, No. of unique values : 530
# type    Range : 1, No. of unique values : 2
# 4       Range : 33.33312187194824, No. of unique values : 1490
# 28      Range : 369042, No. of unique values : 961
# 38      Range : 3442.1111111111113, No. of unique values : 988
# 0       Range : 1093.2091245376077, No. of unique values : 1112
# 41      Range : 13725520.2, No. of unique values : 1014
# 9       Range : 0, No. of unique values : 1
# 32      Range : 8847, No. of unique values : 244
# 15      Range : 3134, No. of unique values : 100
# 7       Range : 16658.35719, No. of unique values : 1342
# 22      Range : 297.29929924011225, No. of unique values : 1489
# 1       Range : 12, No. of unique values : 3
# 20      Range : 42.96079697779247, No. of unique values : 1490
# 27      Range : 504810.25, No. of unique values : 1045
# 36      Range : 499.9957299232483, No. of unique values : 1455
# 14      Range : 9237, No. of unique values : 212
# 10      Range : 8853, No. of unique values : 273
# 12      Range : 7038191, No. of unique values : 1100
# 26      Range : 1460, No. of unique values : 536
# 17      Range : 12, No. of unique values : 3
# 2       Range : 8845, No. of unique values : 268
# 39      Range : 2, No. of unique values : 2
# 29      Range : 6151, No. of unique values : 144
# 16      Range : 1275.4185428798348, No. of unique values : 1024
# 13      Range : 3609.0353598594666, No. of unique values : 1488
# 3       Range : 3452641.65455, No. of unique values : 1131
# 25      Range : 0, No. of unique values : 1
# 34      Range : 166.66551174720132, No. of unique values : 1457
# 6       Range : 499.88302969932556, No. of unique values : 1490
# 19      Range : 502931.58268, No. of unique values : 1051
# 33      Range : 13720819.8, No. of unique values : 1014
# 21      Range : 0.3386540412902832, No. of unique values : 351
# 5       Range : 0.0003230571746826172, No. of unique values : 92
# 23      Range : 6732.37035, No. of unique values : 1313
# 31      Range : 20, No. of unique values : 6
```

### data.nunique()

唯一值的个数

#### 例一

```python
cols_for_hist = [col for col in num_cols if data[col].nunique() <= 50]
print(cols_for_hist, len(cols_for_hist))
```

```python
# ['type', '39', '17', '31', '25', '1', '9'] 7
```

#### 例二

```python
cols_for_desc = [col for col in num_cols if data[col].nunique() > 50]
print(cols_for_desc)
```

```
# ['24', '4', '23', '36', '35', '29', '16', '30', '5', '2', '3', '15', '42', '38', '43', '7', '12', '32', '22', '18', '8', '40', '19', '10', '37', '13', '28', '41', '6', '20', '34', '21', '26', '27', '0', '14', '11', '33']
```

## 绘图

### 例：输出决策树

当没安装`graphviz`时，会提示[`GraphViz's executables not found`](https://stackoverflow.com/questions/48868524/graphvizs-executables-not-found)，因为`graphviz`需要单独安装，并非Python自带。

#### Windows

自行下载安装包安装，并确保`graphviz`的可执行文件在`PATH`路径中

#### Linux

```bash
$ sudo apt install graphviz
```

#### 输出图的Python代码

```python
from sklearn.tree import export_graphviz
import pydotplus
# pip install pydotplus

def tree_graph_to_png(tree, feature_names, png_file_to_save):
    # def tree_graph_to_png(tree, png_file_to_save):
    tree_str = export_graphviz(tree, feature_names=feature_names, filled=True, out_file=None)
    graph = pydotplus.graph_from_dot_data(tree_str)
    graph.write_png(png_file_to_save)
```

当需要输出决策树是可直接调用该函数

```python
tree_graph_to_png(tree=tree, feature_names=ipdata.columns, png_file_to_save='topic3_decision_tree3.png')
```



