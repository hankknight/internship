# 能力测试

## 环境需求
- 操作系统: Ubuntu 20.04
- C++环境
    - gcc/g++ 9.4.0
    - CMake 3.23+
- 第三方依赖
    - Libtorch 1.8.1+

## 功能需求

1. 请在 `src/sequential.cpp` 中实现 `sampler/sequential.h` 头文件给出的抽象成员函数，其中公/私有变量可按需求自行定义。
2. 完成C++的实现后，需要在 `example/workflow.cpp` 中按示例中给出的输入，完成要求的输出示例。

**注: 在实现过程中，可根据需求添加函数或变量，最终只需要保证功能一致即可。**

## 抽象函数解析

### TSSequentialSampler 构造函数
- 输入参数
    - `data` 交易数据
        - 键: `string` 公司股票代码。
        - 值: `tensor` 均为2维，其中行表示时间，列表示行情或其他指标。
    - `step_len` 样本步长
    - `meta_info` 信息元数据
        - 键: `string` 公司股票代码。
        - 值: `vector<string>` 对应公司的交易记录
    - `fill_type` 填充类型
        - `none` 默认给缺失数据填NaN
        - `pre` 默认给缺失数据以第一条数据向前填充
        - `post` 默认给缺失数据以最后一条数据向后填充

- 示例

```c++
    int64_t step = 3;
    map<string, torch::Tensor> data = {{"000001.XSHE", torch::Tensor()}, 
                                       {"000002.XSHE", torch::Tensor()}/*, ...*/}
    map<string, vector<string>> meta_info = {{"000001.XSHE", {"2022-07-18", "2022-07-19", "2022-07-20"}}, 
                                             {"000002.XSHE", {"2020-05-11", "2020-05-12"}}, /*, ...*/}

    TSSequentialSampler sampler(data, step, meta_info, "none");
```

**注: 若要精简TSSequentialSampler的构造函数中 `data` 与 `meta_info` 字典，可自拟结构体，但不能改变要求的输出结果，如 `get` 成员函数返回自拟的结构体，此操作即视为修改输出结果。**

### size 成员函数
- `size` 获取当前可取样本的总数量(可直接返回一个整型数值，此时打印的结果为 `{*, *, *}`)。

- 示例

```c++
    cout << sampler.size() << endl;
    // output
    // {*, *, *}
```

### get 成员函数

- `get` 按索引获取给定步长的样本
    - `index` 样本索引序号

- `get` 按时间及公司代码获取给定步长的样本
    - `date` 查询交易日期。
    - `company` 公司股票代码。

- 返回值 `torch::data::Example` 结构体，格式为:`{Tensor(), Tensor()}`
    - data: 按步长获取的样本。
    - target: 获取样本的最后一列，即对data进行切片处理。

```c++
// get 返回示例，示例仅为解释如何构造torch::data::Example的返回值
torch::data::Example<> TSSequentialSampler::get(size_t index) override {
    torch::Tensor data = torch::Tensor();
    torch::Tensor target = torch::Tensor();

    return {data, target};
}
```

## 简单示例

```c++
    // 现有2022-07-04至2022-07-07共4天的数据，其中A公司只有2022-07-06至2022-07-07这2天的数据
    map<string, torch::Tensor> data;    
    data["A"] = torch::tensor({{1, 1, 1}, 
                               {2, 2, 2}});
    data["B"] = torch::tensor({{1, 1, 1}, 
                               {2, 2, 2}, 
                               {3, 3, 3}, 
                               {4, 4, 4}});

    // 日期元信息
    map<string, vector<string>> meta_info;
    meta_info["A"] = {"2022-07-06", "2022-07-07"};
    meta_info["B"] = {"2022-07-04", "2022-07-05", "2022-07-06", "2022-07-07"};

    // 默认使用nan填充，样本步长为3，前/后向填充为可选
    TSSequentialSampler sampler(/*data=*/data, /*step_len=*/3L, /*meta_info=*/meta_info, /*fill_type=*/"none"/*other*/);

    // -------------------- 索引方法获取样本 --------------------

    //获取第一个样本
    cout << sampler.get(0).data << endl;
    // {{nan, nan, nan},
    //  {  1,   1,   1},
    //  {  2,   2,   2}}

    //获取第二个样本
    cout << sampler.get(1).data << endl;
    // {{  1,   1,   1},
    //  {  2,   2,   2},
    //  {  3,   3,   3}}    
    
    //获取第三个样本
    cout << sampler.get(2).data << endl;
    // {{  2,   2,   2},
    //  {  3,   3,   3},
    //  {  4,   4,   4}}

    // -------------------- 日期与公司方法获取样本 --------------------

    // 取A公司在2022-07-06日的样本数据
    cout << sampler.get("2022-07-06", "A").data << endl;
    // 报错，提示样本不存在

    // 取A公司在2022-07-07日的样本数据
    cout << sampler.get("2022-07-07", "A").data << endl;
    // {{nan, nan, nan},
    //  {  1,   1,   1},
    //  {  2,   2,   2}}

    // 取B公司在2022-07-07日的样本数据
    cout << sampler.get("2022-07-07", "B").data << endl;
    // {{  2,   2,   2},
    //  {  3,   3,   3},
    //  {  4,   4,   4}}

    /* 注: 按索引与日期公司的取样本返回的值应相同，区别仅是获取方式不同。 */
```

## 编译与运行

```bash
    # 创建并进入编译文件夹
    $ mkdir build && cd build
    # 调用cmake进行编译
    $ cmake ..
    $ cmake --build .
    # 前往bin目录运行示例
    $ ./bin/workflow
```

## 参考资料

### git提交规范

- [ ] 项目的拉取及提交
- [ ] 提交内容的书写规范

提交规范参考[Angular.js develope document](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#commits)中的 `Git Commit Guidelines` 章节。

### 熟悉基础的C++代码规范

参考[Google C++ Guide](https://google.github.io/styleguide/cppguide.html)官方文档。

### 熟悉libtorch的基础使用

选看章节:

- [ ] INSTALLING C++ DISTRIBUTIONS OF PYTORCH
- [ ] TENSOR CREATION API
- [ ] TENSOR INDEXING API

参考[Libtorch Guide](https://pytorch.org/cppdocs/index.html)官方文档。
