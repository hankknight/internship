/**
 * @file workflow.cpp
 * @date 2022-07-08 14:07:45
 * @author zhongziyang (hankknight@live.com)
 * @brief Quick start of how to use Time Series Sequential Sampler C++
 *        achievement
 *
 * @copyright Copyright (c) 2022
 *
 */
#include <map>
#include <string>
#include <vector>
#include <iostream>
#include <torch/torch.h>

#include "sampler/sequential.h"

using namespace std;

int main(int argc, char* argv[]) {
    // finish your code
    cout << "*** example workflow start ***" << endl;

    // step 1: prepare input
    // here 3 companies with 2, 3 and 4 days trading indicates
    // assume row as trading dates
    // assume column as different trading indicates
    map<string, torch::Tensor> data;
    data["A"] = torch::tensor({{1, 1, 1}, {2, 2, 2}});
    data["B"] = torch::tensor({{1, 1, 1}, {2, 2, 2}, {3, 3, 3}});
    data["C"] = torch::tensor({{1, 1, 1}, {2, 2, 2}, {3, 3, 3}, {4, 4, 4}});

    map<string, vector<string>> meta_info;
    meta_info["A"] = {"2022-07-18", "2022-07-19"};
    meta_info["B"] = {"2022-07-18", "2022-07-19", "2022-07-20"};
    meta_info["C"] = {"2022-07-18", "2022-07-19", "2022-07-20", "2022-07-21"};

    // step 2: using your sampler to process input
    // 1. forward/backfowrd/nan fill lacking sample
    // 2. step parameter we fix to 3

    // example:
    // TSSequentialSampler sampler(data, 3, ...);

    // step 3: show output
    // 1. total sample length
    // 2. print index 0, 1, 2, 3, etc(output sample must include company C)

    return 0;
}
